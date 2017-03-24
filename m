From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta-3arQi8VN3Tc@public.gmane.org>
Subject: Re: [PATCH] arm64: dts: ls1012a: add crypto node
Date: Fri, 24 Mar 2017 07:17:50 +0000
Message-ID: <DB4PR04MB0847D837CB2762D5094720CB983E0@DB4PR04MB0847.eurprd04.prod.outlook.com>
References: <20170322122939.22117-1-horia.geanta@nxp.com>
 <20170324015606.GC30608@dragon>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Harninder Rai <harninder.rai-3arQi8VN3Tc@public.gmane.org>,
        "Catalin Marinas" <catalin.marinas-5wv7dgnIgG8@public.gmane.org>,
        Bhaskar U <bhaskar.upadhaya-3arQi8VN3Tc@public.gmane.org>,
        "Will Deacon" <will.deacon-5wv7dgnIgG8@public.gmane.org>,
        Dan Douglass <dan.douglass-3arQi8VN3Tc@public.gmane.org>,
        "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org"
        <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
To: Shawn Guo <shawnguo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On 3/24/2017 3:56 AM, Shawn Guo wrote:=0A=
> On Wed, Mar 22, 2017 at 02:29:39PM +0200, Horia Geant=E3 wrote:=0A=
>> LS1012A has a SEC v5.4 security engine.=0A=
>>=0A=
>> Signed-off-by: Horia Geant=E3 <horia.geanta-3arQi8VN3Tc@public.gmane.org>=0A=
>> ---=0A=
>>  arch/arm64/boot/dts/freescale/fsl-ls1012a-frdm.dts |  9 +++=0A=
>>  arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts  |  9 +++=0A=
>>  arch/arm64/boot/dts/freescale/fsl-ls1012a-rdb.dts  |  9 +++=0A=
>>  arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi     | 91 +++++++++++++++=
++++++-=0A=
>>  4 files changed, 117 insertions(+), 1 deletion(-)=0A=
>>=0A=
>> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1012a-frdm.dts b/arch/a=
rm64/boot/dts/freescale/fsl-ls1012a-frdm.dts=0A=
>> index a619f6496a4c..bab9e68947e4 100644=0A=
>> --- a/arch/arm64/boot/dts/freescale/fsl-ls1012a-frdm.dts=0A=
>> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1012a-frdm.dts=0A=
>> @@ -49,6 +49,15 @@=0A=
>>  	model =3D "LS1012A Freedom Board";=0A=
>>  	compatible =3D "fsl,ls1012a-frdm", "fsl,ls1012a";=0A=
>>  =0A=
>> +	aliases {=0A=
>> +		crypto =3D &crypto;=0A=
>> +		rtic_a =3D &rtic_a;=0A=
>> +		rtic_b =3D &rtic_b;=0A=
>> +		rtic_c =3D &rtic_c;=0A=
>> +		rtic_d =3D &rtic_d;=0A=
>> +		sec_mon =3D &sec_mon;=0A=
>> +	};=0A=
>> +=0A=
>>  	sys_mclk: clock-mclk {=0A=
>>  		compatible =3D "fixed-clock";=0A=
>>  		#clock-cells =3D <0>;=0A=
>> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts b/arch/ar=
m64/boot/dts/freescale/fsl-ls1012a-qds.dts=0A=
>> index 14a67f1709e7..5c4e84c7f20d 100644=0A=
>> --- a/arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts=0A=
>> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts=0A=
>> @@ -49,6 +49,15 @@=0A=
>>  	model =3D "LS1012A QDS Board";=0A=
>>  	compatible =3D "fsl,ls1012a-qds", "fsl,ls1012a";=0A=
>>  =0A=
>> +	aliases {=0A=
>> +		crypto =3D &crypto;=0A=
>> +		rtic_a =3D &rtic_a;=0A=
>> +		rtic_b =3D &rtic_b;=0A=
>> +		rtic_c =3D &rtic_c;=0A=
>> +		rtic_d =3D &rtic_d;=0A=
>> +		sec_mon =3D &sec_mon;=0A=
>> +	};=0A=
>> +=0A=
>>  	sys_mclk: clock-mclk {=0A=
>>  		compatible =3D "fixed-clock";=0A=
>>  		#clock-cells =3D <0>;=0A=
>> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1012a-rdb.dts b/arch/ar=
m64/boot/dts/freescale/fsl-ls1012a-rdb.dts=0A=
>> index 62c5c7123a15..ff9dd16aa65a 100644=0A=
>> --- a/arch/arm64/boot/dts/freescale/fsl-ls1012a-rdb.dts=0A=
>> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1012a-rdb.dts=0A=
>> @@ -48,6 +48,15 @@=0A=
>>  / {=0A=
>>  	model =3D "LS1012A RDB Board";=0A=
>>  	compatible =3D "fsl,ls1012a-rdb", "fsl,ls1012a";=0A=
>> +=0A=
>> +	aliases {=0A=
>> +		crypto =3D &crypto;=0A=
>> +		rtic_a =3D &rtic_a;=0A=
>> +		rtic_b =3D &rtic_b;=0A=
>> +		rtic_c =3D &rtic_c;=0A=
>> +		rtic_d =3D &rtic_d;=0A=
>> +		sec_mon =3D &sec_mon;=0A=
>> +	};=0A=
> =0A=
> What are these aliases used for?  Are they board specific?  If not, we=0A=
> should probably have them in fsl-ls1012a.dtsi, since you are adding=0A=
> them for all three fsl-ls1012a based boards.=0A=
> =0A=
Indeed, these can be shared and thus should be moved to=0A=
fsl-ls1012a.dtsi. Will be fixed in v2.=0A=
=0A=
crypto alias is used in u-boot to fixup the crypto node with a=0A=
"fsl,sec-era" property.=0A=
=0A=
rtic and sec_mon aliases have been added to be in line with the PPC=0A=
device trees, I am not aware how they are used.=0A=
=0A=
>>  };=0A=
>>  =0A=
>>  &duart0 {=0A=
>> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi b/arch/arm64=
/boot/dts/freescale/fsl-ls1012a.dtsi=0A=
>> index cffebb4b3df1..68f3012ae07e 100644=0A=
>> --- a/arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi=0A=
>> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi=0A=
>> @@ -42,7 +42,7 @@=0A=
>>   *     OTHER DEALINGS IN THE SOFTWARE.=0A=
>>   */=0A=
>>  =0A=
>> -#include <dt-bindings/interrupt-controller/irq.h>=0A=
>> +#include <dt-bindings/interrupt-controller/arm-gic.h>=0A=
>>  =0A=
>>  / {=0A=
>>  	compatible =3D "fsl,ls1012a";=0A=
>> @@ -113,6 +113,95 @@=0A=
>>  			big-endian;=0A=
>>  		};=0A=
>>  =0A=
>> +		crypto: crypto@1700000 {=0A=
>> +			compatible =3D "fsl,sec-v5.4", "fsl,sec-v5.0",=0A=
>> +				     "fsl,sec-v4.0";=0A=
>> +			fsl,sec-era =3D <8>;=0A=
>> +			#address-cells =3D <1>;=0A=
>> +			#size-cells =3D <1>;=0A=
>> +			ranges =3D <0x0 0x00 0x1700000 0x100000>;=0A=
>> +			reg =3D <0x00 0x1700000 0x0 0x100000>;=0A=
>> +			interrupts =3D <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;=0A=
>> +=0A=
>> +			sec_jr0: jr@10000 {=0A=
>> +				compatible =3D "fsl,sec-v5.4-job-ring",=0A=
>> +					     "fsl,sec-v5.0-job-ring",=0A=
>> +					     "fsl,sec-v4.0-job-ring";=0A=
>> +				reg	   =3D <0x10000 0x10000>;=0A=
>> +				interrupts =3D <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>;=0A=
>> +			};=0A=
>> +=0A=
>> +			sec_jr1: jr@20000 {=0A=
>> +				compatible =3D "fsl,sec-v5.4-job-ring",=0A=
>> +					     "fsl,sec-v5.0-job-ring",=0A=
>> +					     "fsl,sec-v4.0-job-ring";=0A=
>> +				reg	   =3D <0x20000 0x10000>;=0A=
>> +				interrupts =3D <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;=0A=
>> +			};=0A=
>> +=0A=
>> +			sec_jr2: jr@30000 {=0A=
>> +				compatible =3D "fsl,sec-v5.4-job-ring",=0A=
>> +					     "fsl,sec-v5.0-job-ring",=0A=
>> +					     "fsl,sec-v4.0-job-ring";=0A=
>> +				reg	   =3D <0x30000 0x10000>;=0A=
>> +				interrupts =3D <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>;=0A=
>> +			};=0A=
>> +=0A=
>> +			sec_jr3: jr@40000 {=0A=
>> +				compatible =3D "fsl,sec-v5.4-job-ring",=0A=
>> +					     "fsl,sec-v5.0-job-ring",=0A=
>> +					     "fsl,sec-v4.0-job-ring";=0A=
>> +				reg	   =3D <0x40000 0x10000>;=0A=
>> +				interrupts =3D <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;=0A=
>> +			};=0A=
>> +=0A=
>> +			rtic@60000 {=0A=
>> +				compatible =3D "fsl,sec-v5.4-rtic",=0A=
>> +					     "fsl,sec-v5.0-rtic",=0A=
>> +					     "fsl,sec-v4.0-rtic";=0A=
>> +				#address-cells =3D <1>;=0A=
>> +				#size-cells =3D <1>;=0A=
>> +				reg =3D <0x60000 0x100 0x60e00 0x18>;=0A=
>> +				ranges =3D <0x0 0x60100 0x500>;=0A=
>> +=0A=
>> +				rtic_a: rtic-a@0 {=0A=
>> +					compatible =3D "fsl,sec-v5.4-rtic-memory",=0A=
>> +						     "fsl,sec-v5.0-rtic-memory",=0A=
>> +						     "fsl,sec-v4.0-rtic-memory";=0A=
>> +					reg =3D <0x00 0x20 0x100 0x100>;=0A=
>> +				};=0A=
>> +=0A=
>> +				rtic_b: rtic-b@20 {=0A=
>> +					compatible =3D "fsl,sec-v5.4-rtic-memory",=0A=
>> +						     "fsl,sec-v5.0-rtic-memory",=0A=
>> +						     "fsl,sec-v4.0-rtic-memory";=0A=
>> +					reg =3D <0x20 0x20 0x200 0x100>;=0A=
>> +				};=0A=
>> +=0A=
>> +				rtic_c: rtic-c@40 {=0A=
>> +					compatible =3D "fsl,sec-v5.4-rtic-memory",=0A=
>> +						     "fsl,sec-v5.0-rtic-memory",=0A=
>> +						     "fsl,sec-v4.0-rtic-memory";=0A=
>> +					reg =3D <0x40 0x20 0x300 0x100>;=0A=
>> +				};=0A=
>> +=0A=
>> +				rtic_d: rtic-d@60 {=0A=
>> +					compatible =3D "fsl,sec-v5.4-rtic-memory",=0A=
>> +						     "fsl,sec-v5.0-rtic-memory",=0A=
>> +						     "fsl,sec-v4.0-rtic-memory";=0A=
>> +					reg =3D <0x60 0x20 0x400 0x100>;=0A=
>> +				};=0A=
>> +			};=0A=
>> +		};=0A=
>> +=0A=
>> +		sec_mon: sec_mon@1e90000 {=0A=
> =0A=
> Hyphen is more preferred to be used in node name than underscore.=0A=
> =0A=
This would imply changing the=0A=
Documentation/devicetree/bindings/crypto/fsl-sec4.txt binding and=0A=
dealing with all the consequences, which IIUC is probably not worth.=0A=
=0A=
Thanks,=0A=
Horia=0A=
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
