From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] crypto: caam - de-CHIP-ify device tree compatibles
Date: Tue, 15 Mar 2011 18:59:51 -0600
Message-ID: <20110316005951.GA18791@angua.secretlab.ca>
References: <20110315165220.d4fb60bc.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	devicetree-discuss@lists.ozlabs.org,
	Scott Wood <scottwood@freescale.com>,
	Steve Cornelius <sec@pobox.com>,
	Kumar Gala <kumar.gala@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36377 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab1CPA75 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Mar 2011 20:59:57 -0400
Received: by gyf1 with SMTP id 1so459096gyf.19
        for <linux-crypto@vger.kernel.org>; Tue, 15 Mar 2011 17:59:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20110315165220.d4fb60bc.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 15, 2011 at 04:52:20PM -0500, Kim Phillips wrote:
> - all the integration parameters have been captured by the binding.
> - the block name really uniquely identifies this hardware.
> 
> Some advocate putting SoC names everywhere in case software needs
> to work around some chip-specific bug, but more precise SoC
> information already exists in SVR, and board information already
> exists in the top-level device tree node.
> 
> Note that sometimes the SoC name is a worse identifier than the
> block version, as the block version can change between revisions
> of the same SoC.
> 
> As a matter of historical reference, neither SEC versions 2.x
> nor 3.x (driven by talitos) ever needed CHIP references.
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

<sigh>  Very well.  As long as some level of versioning is used on the
compatible values, I guess I can live with it.

Acked-off-by: Grant Likely <grant.likely@secretlab.ca>

> Cc: Kumar Gala <kumar.gala@freescale.com>
> Cc: Scott Wood <scottwood@freescale.com>
> ---
>  .../devicetree/bindings/crypto/fsl-sec4.txt        |   64 ++++++++------------
>  arch/powerpc/boot/dts/p4080ds.dts                  |   32 ++++-------
>  2 files changed, 37 insertions(+), 59 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
> index 568aa3c..bf57ecd 100644
> --- a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
> +++ b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
> @@ -38,7 +38,7 @@ in the memory partition devoted to a particular core.  The P4080 has 4 JRs, so
>  up to 4 JRs can be configured; and all 4 JRs process requests in parallel.
>  
>  =====================================================================
> -P4080 SEC 4 Node
> +SEC 4 Node
>  
>  Description
>  
> @@ -53,7 +53,7 @@ PROPERTIES
>     - compatible
>        Usage: required
>        Value type: <string>
> -      Definition: Must include "fsl,p4080-sec-v4.0","fsl,sec-v4.0"
> +      Definition: Must include "fsl,sec-v4.0"
>  
>     - #address-cells
>         Usage: required
> @@ -105,7 +105,7 @@ PROPERTIES
>  
>  EXAMPLE
>  	crypto@300000 {
> -		compatible = "fsl,p4080-sec-v4.0", "fsl,sec-v4.0";
> +		compatible = "fsl,sec-v4.0";
>  		#address-cells = <1>;
>  		#size-cells = <1>;
>  		reg = <0x300000 0x10000>;
> @@ -115,7 +115,7 @@ EXAMPLE
>  	};
>  
>  =====================================================================
> -P4080 Job Ring (JR) Node
> +Job Ring (JR) Node
>  
>      Child of the crypto node defines data processing interface to SEC 4
>      across the peripheral bus for purposes of processing
> @@ -127,7 +127,7 @@ P4080 Job Ring (JR) Node
>    - compatible
>        Usage: required
>        Value type: <string>
> -      Definition: Must include "fsl,p4080-sec-v4.0-job-ring","fsl,sec-v4.0-job-ring"
> +      Definition: Must include "fsl,sec-v4.0-job-ring"
>  
>    - reg
>        Usage: required
> @@ -163,8 +163,7 @@ P4080 Job Ring (JR) Node
>  
>  EXAMPLE
>  	jr@1000 {
> -		compatible = "fsl,p4080-sec-v4.0-job-ring",
> -			     "fsl,sec-v4.0-job-ring";
> +		compatible = "fsl,sec-v4.0-job-ring";
>  		reg = <0x1000 0x1000>;
>  		fsl,liodn = <0x081>;
>  		interrupt-parent = <&mpic>;
> @@ -173,7 +172,7 @@ EXAMPLE
>  
>  
>  =====================================================================
> -P4080 Run Time Integrity Check (RTIC) Node
> +Run Time Integrity Check (RTIC) Node
>  
>    Child node of the crypto node.  Defines a register space that
>    contains up to 5 sets of addresses and their lengths (sizes) that
> @@ -186,7 +185,7 @@ P4080 Run Time Integrity Check (RTIC) Node
>    - compatible
>        Usage: required
>        Value type: <string>
> -      Definition: Must include "fsl,p4080-sec-v4.0-rtic","fsl,sec-v4.0-rtic".
> +      Definition: Must include "fsl,sec-v4.0-rtic".
>  
>     - #address-cells
>         Usage: required
> @@ -219,8 +218,7 @@ P4080 Run Time Integrity Check (RTIC) Node
>  
>  EXAMPLE
>  	rtic@6000 {
> -		compatible = "fsl,p4080-sec-v4.0-rtic",
> -			     "fsl,sec-v4.0-rtic";
> +		compatible = "fsl,sec-v4.0-rtic";
>  		#address-cells = <1>;
>  		#size-cells = <1>;
>  		reg = <0x6000 0x100>;
> @@ -228,7 +226,7 @@ EXAMPLE
>  	};
>  
>  =====================================================================
> -P4080 Run Time Integrity Check (RTIC) Memory Node
> +Run Time Integrity Check (RTIC) Memory Node
>    A child node that defines individual RTIC memory regions that are used to
>    perform run-time integrity check of memory areas that should not modified.
>    The node defines a register that contains the memory address &
> @@ -238,7 +236,7 @@ P4080 Run Time Integrity Check (RTIC) Memory Node
>    - compatible
>        Usage: required
>        Value type: <string>
> -      Definition: Must include "fsl,p4080-sec-v4.0-rtic-memory","fsl,sec-v4.0-rtic-memory".
> +      Definition: Must include "fsl,sec-v4.0-rtic-memory".
>  
>    - reg
>        Usage: required
> @@ -270,15 +268,14 @@ P4080 Run Time Integrity Check (RTIC) Memory Node
>  
>  EXAMPLE
>  	rtic-a@0 {
> -		compatible = "fsl,p4080-sec-v4.0-rtic-memory",
> -			     "fsl,sec-v4.0-rtic-memory";
> +		compatible = "fsl,sec-v4.0-rtic-memory";
>  		reg = <0x00 0x20 0x100 0x80>;
>  		fsl,liodn   = <0x03c>;
>  		fsl,rtic-region  = <0x12345678 0x12345678 0x12345678>;
>  	};
>  
>  =====================================================================
> -P4080 Secure Non-Volatile Storage (SNVS) Node
> +Secure Non-Volatile Storage (SNVS) Node
>  
>      Node defines address range and the associated
>      interrupt for the SNVS function.  This function
> @@ -288,7 +285,7 @@ P4080 Secure Non-Volatile Storage (SNVS) Node
>    - compatible
>        Usage: required
>        Value type: <string>
> -      Definition: Must include "fsl,p4080-sec-v4.0-mon", "fsl,sec-v4.0-mon".
> +      Definition: Must include "fsl,sec-v4.0-mon".
>  
>    - reg
>        Usage: required
> @@ -315,7 +312,7 @@ P4080 Secure Non-Volatile Storage (SNVS) Node
>  
>  EXAMPLE
>  	sec_mon@314000 {
> -		compatible = "fsl,p4080-sec-v4.0-mon", "fsl,sec-v4.0-mon";
> +		compatible = "fsl,sec-v4.0-mon";
>  		reg = <0x314000 0x1000>;
>  		interrupt-parent = <&mpic>;
>  		interrupts = <93 2>;
> @@ -325,7 +322,7 @@ EXAMPLE
>  FULL EXAMPLE
>  
>  	crypto: crypto@300000 {
> -		compatible = "fsl,p4080-sec-v4.0", "fsl,sec-v4.0";
> +		compatible = "fsl,sec-v4.0";
>  		#address-cells = <1>;
>  		#size-cells = <1>;
>  		reg = <0x300000 0x10000>;
> @@ -334,73 +331,64 @@ FULL EXAMPLE
>  		interrupts = <92 2>;
>  
>  		sec_jr0: jr@1000 {
> -			compatible = "fsl,p4080-sec-v4.0-job-ring",
> -				     "fsl,sec-v4.0-job-ring";
> +			compatible = "fsl,sec-v4.0-job-ring";
>  			reg = <0x1000 0x1000>;
>  			interrupt-parent = <&mpic>;
>  			interrupts = <88 2>;
>  		};
>  
>  		sec_jr1: jr@2000 {
> -			compatible = "fsl,p4080-sec-v4.0-job-ring",
> -				     "fsl,sec-v4.0-job-ring";
> +			compatible = "fsl,sec-v4.0-job-ring";
>  			reg = <0x2000 0x1000>;
>  			interrupt-parent = <&mpic>;
>  			interrupts = <89 2>;
>  		};
>  
>  		sec_jr2: jr@3000 {
> -			compatible = "fsl,p4080-sec-v4.0-job-ring",
> -				     "fsl,sec-v4.0-job-ring";
> +			compatible = "fsl,sec-v4.0-job-ring";
>  			reg = <0x3000 0x1000>;
>  			interrupt-parent = <&mpic>;
>  			interrupts = <90 2>;
>  		};
>  
>  		sec_jr3: jr@4000 {
> -			compatible = "fsl,p4080-sec-v4.0-job-ring",
> -				     "fsl,sec-v4.0-job-ring";
> +			compatible = "fsl,sec-v4.0-job-ring";
>  			reg = <0x4000 0x1000>;
>  			interrupt-parent = <&mpic>;
>  			interrupts = <91 2>;
>  		};
>  
>  		rtic@6000 {
> -			compatible = "fsl,p4080-sec-v4.0-rtic",
> -				     "fsl,sec-v4.0-rtic";
> +			compatible = "fsl,sec-v4.0-rtic";
>  			#address-cells = <1>;
>  			#size-cells = <1>;
>  			reg = <0x6000 0x100>;
>  			ranges = <0x0 0x6100 0xe00>;
>  
>  			rtic_a: rtic-a@0 {
> -				compatible = "fsl,p4080-sec-v4.0-rtic-memory",
> -					     "fsl,sec-v4.0-rtic-memory";
> +				compatible = "fsl,sec-v4.0-rtic-memory";
>  				reg = <0x00 0x20 0x100 0x80>;
>  			};
>  
>  			rtic_b: rtic-b@20 {
> -				compatible = "fsl,p4080-sec-v4.0-rtic-memory",
> -					     "fsl,sec-v4.0-rtic-memory";
> +				compatible = "fsl,sec-v4.0-rtic-memory";
>  				reg = <0x20 0x20 0x200 0x80>;
>  			};
>  
>  			rtic_c: rtic-c@40 {
> -				compatible = "fsl,p4080-sec-v4.0-rtic-memory",
> -					     "fsl,sec-v4.0-rtic-memory";
> +				compatible = "fsl,sec-v4.0-rtic-memory";
>  				reg = <0x40 0x20 0x300 0x80>;
>  			};
>  
>  			rtic_d: rtic-d@60 {
> -				compatible = "fsl,p4080-sec-v4.0-rtic-memory",
> -					     "fsl,sec-v4.0-rtic-memory";
> +				compatible = "fsl,sec-v4.0-rtic-memory";
>  				reg = <0x60 0x20 0x500 0x80>;
>  			};
>  		};
>  	};
>  
>  	sec_mon: sec_mon@314000 {
> -		compatible = "fsl,p4080-sec-v4.0-mon", "fsl,sec-v4.0-mon";
> +		compatible = "fsl,sec-v4.0-mon";
>  		reg = <0x314000 0x1000>;
>  		interrupt-parent = <&mpic>;
>  		interrupts = <93 2>;
> diff --git a/arch/powerpc/boot/dts/p4080ds.dts b/arch/powerpc/boot/dts/p4080ds.dts
> index 0430d24..927f94d 100644
> --- a/arch/powerpc/boot/dts/p4080ds.dts
> +++ b/arch/powerpc/boot/dts/p4080ds.dts
> @@ -423,7 +423,7 @@
>  		};
>  
>  		crypto: crypto@300000 {
> -			compatible = "fsl,p4080-sec-v4.0", "fsl,sec-v4.0";
> +			compatible = "fsl,sec-v4.0";
>  			#address-cells = <1>;
>  			#size-cells = <1>;
>  			reg = <0x300000 0x10000>;
> @@ -432,74 +432,64 @@
>  			interrupts = <92 2>;
>  
>  			sec_jr0: jr@1000 {
> -				compatible = "fsl,p4080-sec-v4.0-job-ring",
> -					     "fsl,sec-v4.0-job-ring";
> +				compatible = "fsl,sec-v4.0-job-ring";
>  				reg = <0x1000 0x1000>;
>  				interrupt-parent = <&mpic>;
>  				interrupts = <88 2>;
>  			};
>  
>  			sec_jr1: jr@2000 {
> -				compatible = "fsl,p4080-sec-v4.0-job-ring",
> -					     "fsl,sec-v4.0-job-ring";
> +				compatible = "fsl,sec-v4.0-job-ring";
>  				reg = <0x2000 0x1000>;
>  				interrupt-parent = <&mpic>;
>  				interrupts = <89 2>;
>  			};
>  
>  			sec_jr2: jr@3000 {
> -				compatible = "fsl,p4080-sec-v4.0-job-ring",
> -					     "fsl,sec-v4.0-job-ring";
> +				compatible = "fsl,sec-v4.0-job-ring";
>  				reg = <0x3000 0x1000>;
>  				interrupt-parent = <&mpic>;
>  				interrupts = <90 2>;
>  			};
>  
>  			sec_jr3: jr@4000 {
> -				compatible = "fsl,p4080-sec-v4.0-job-ring",
> -					     "fsl,sec-v4.0-job-ring";
> +				compatible = "fsl,sec-v4.0-job-ring";
>  				reg = <0x4000 0x1000>;
>  				interrupt-parent = <&mpic>;
>  				interrupts = <91 2>;
>  			};
>  
>  			rtic@6000 {
> -				compatible = "fsl,p4080-sec-v4.0-rtic",
> -					     "fsl,sec-v4.0-rtic";
> +				compatible = "fsl,sec-v4.0-rtic";
>  				#address-cells = <1>;
>  				#size-cells = <1>;
>  				reg = <0x6000 0x100>;
>  				ranges = <0x0 0x6100 0xe00>;
>  
>  				rtic_a: rtic-a@0 {
> -					compatible = "fsl,p4080-sec-v4.0-rtic-memory",
> -						     "fsl,sec-v4.0-rtic-memory";
> +					compatible = "fsl,sec-v4.0-rtic-memory";
>  					reg = <0x00 0x20 0x100 0x80>;
>  				};
>  
>  				rtic_b: rtic-b@20 {
> -					compatible = "fsl,p4080-sec-v4.0-rtic-memory",
> -						     "fsl,sec-v4.0-rtic-memory";
> +					compatible = "fsl,sec-v4.0-rtic-memory";
>  					reg = <0x20 0x20 0x200 0x80>;
>  				};
>  
>  				rtic_c: rtic-c@40 {
> -					compatible = "fsl,p4080-sec-v4.0-rtic-memory",
> -						     "fsl,sec-v4.0-rtic-memory";
> +					compatible = "fsl,sec-v4.0-rtic-memory";
>  					reg = <0x40 0x20 0x300 0x80>;
>  				};
>  
>  				rtic_d: rtic-d@60 {
> -					compatible = "fsl,p4080-sec-v4.0-rtic-memory",
> -						     "fsl,sec-v4.0-rtic-memory";
> +					compatible = "fsl,sec-v4.0-rtic-memory";
>  					reg = <0x60 0x20 0x500 0x80>;
>  				};
>  			};
>  		};
>  
>  		sec_mon: sec_mon@314000 {
> -			compatible = "fsl,p4080-sec-v4.0-mon",
> -				     "fsl,sec-v4.0-mon";
> +			compatible = "fsl,sec-v4.0-mon";
>  			reg = <0x314000 0x1000>;
>  			interrupt-parent = <&mpic>;
>  			interrupts = <93 2>;
> -- 
> 1.7.4.1
> 
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
