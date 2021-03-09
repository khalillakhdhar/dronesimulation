classdef Block_Chain < handle
    properties
	totalCount    
	liste_block     
    end
    methods
	function obj = Block_Chain()
	    obj.liste_block =[ strec_block(0,'testttt')];   
	    obj.totalCount = 1 ;
	    obj.calculateGensisBlockHash();              
	end
	function bc = getLatest(obj)                            
	    bc = obj.liste_block(end);
	end
	function calculateGensisBlockHash(obj) 
	    gb = obj.liste_block(1);
	   
	    str = strcat(num2str(gb.indice_bloc),gb.donnee_block)      
	    gb.crypt = cryptage(  str );        
	end
	function addBlock(obj,nex_block)                 
	   if  obj.validatenex_block(nex_block)          
	       obj.liste_block(end+1) = nex_block;        
	   end
	end
	function tf = validatenex_block(obj,nex_block)    
	   new_hasha = cryptage(  strcat( nex_block.getCombined(), num2str(nex_block.poin_mem) ));
	   if(strcmp(new_hasha(1:2),'00') && strcmp(nex_block.crypt,new_hasha))
	       tf=  true;
	   else
	       tf = false;
	   end           
	end
    end
end