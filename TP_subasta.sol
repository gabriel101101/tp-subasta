/**
 *Submitted for verification at sepolia.scrollscan.com on 2024-11-18
*/

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Subasta {
   /// @titulo proyecto: Subasta
   /// @autor Gabriel Rodriguez 
   // Una stuctura, un array de ofertas de la subasta validadas, un constructor para el tiempo.
   // Variables de estado 

    enum StateSubasta{
        inicioSubasta,
        procesoSubasta,
        finSubasta
    }

    struct Ofertante{
        string  name;
        uint    valor;
        address direction;
        uint256 date;
    }

   uint256 public valorMin = 100;  //valor minimo de inicio
   string  articulo;
   uint256 totalComisiones;
   

   uint256 durationTime;           //duracion de subasta
   uint256 finishTime;             //tiempo que finaliza          
   uint256 extendTime = 600;        //tiempo de extension 10 minutos

   address ganador;
   uint256 pago;

   Ofertante[] public ofertantes;  // Lista de Ofertantes 
   
   constructor(uint256 _durationTime){
    durationTime = _durationTime;
    finishTime = block.timestamp + durationTime;
   }


    uint256 countOferta=0; // contador de ofertas validas

    function articuloSubastado(string memory _articulo) public {
        articulo=_articulo;
        
    }


    event ComienzaSubasta(string articulo, uint256  valorMin, uint indexed valor, address indexed direction, string indexed name, StateSubasta);

    // funcion para ofertar 
       function ofertar(address direction, string memory name) external payable  {
        
        uint256 saltoMinimoPuja = (valorMin/100)*5; 
 
        require(block.timestamp < finishTime, " Subasta en proceso");// Cumple condicion y comienza subasta 

        if(msg.value > (valorMin + saltoMinimoPuja)){

            valorMin  = msg.value;
            direction = msg.sender;

            ganador = msg.sender;
            pago    = valorMin;

             //llena el array con ofertantes
            ofertantes.push(Ofertante(name,msg.value,direction,block.timestamp));

            countOferta++;

            if(countOferta > 1){
            finishTime = durationTime + 600; //extiende tiempo 10 minutos por pujas antes del plazo original
            }

        }

        emit ComienzaSubasta( articulo , valorMin, msg.value, msg.sender, name, StateSubasta.inicioSubasta );

    }
    

    // Retirar de su depósito el importe por encima de su última oferta durante el desarrollo de la subasta.
    function entregarRembolso(address direction) external payable{
         uint256 rembolso;
         address ofertante;

        for(uint i=0; i < ofertantes.length; i++){

            if(ofertantes[i].direction == direction && ofertantes[i].valor > rembolso){
                rembolso  = ofertantes[i].valor;
                ofertante = ofertantes[i].direction;
            }
        }
        payable(ofertante).transfer(rembolso);
    }


    //Extiende el tiempo de la subasta.
    function agregarTiempo() external {
        if(block.timestamp < finishTime){
            finishTime = finishTime + extendTime;
        }
    }


    // Evento fin de subasta
    event FinSubasta( StateSubasta, string, address _ganador, uint256 _pago);


    // Muestra  ganador de la subasta.
    function ofertaWiner() public  {
            emit FinSubasta( StateSubasta.finSubasta," Ganador de la Subasta !!", ganador, pago);
            countOferta=0;
    }
    

    // Muestra lista de ofertantes y montos.
    function  listaOfertantes()external view returns (Ofertante[] memory){
        return ofertantes;
    }
    

    // Funcion para devolucion de depositos
    function devolucion() external payable{

        for(uint i=0; i < ofertantes.length; i++){
           address ofertante = ofertantes[i].direction;
            uint deposito = ofertantes[i].valor;

            if (ofertante != ganador) {
                uint comisionGas = deposito * 2 / 100;
                uint montoFinal = deposito - comisionGas;
                payable(ofertante).transfer(montoFinal);
                ofertantes[i].valor = 0;
                totalComisiones += comisionGas; 
            }
        }
       
    }


}