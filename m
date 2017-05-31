From: Cosar Dindar <cosardindar@gmail.com>
Subject: Re: [PATCH v2 2/5] dt-bindings : Document the STM32F4 CRC32 binding
Date: Wed, 31 May 2017 11:17:33 +0300
Message-ID: <20170531081733.GB21306@osboxes>
References: <cover.1495285223.git.cosardindar@gmail.com>
 <bb672acb88667e9d27beb4d1e4fd8882f265ee47.1495285223.git.cosardindar@gmail.com>
 <20170530225024.ypguef347yqbjbsd@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org, alexandre.torgue@st.com,
 linux-kernel@vger.kernel.org, fabien.dessenne@st.com,
 linux-crypto@vger.kernel.org, mcoquelin.stm32@gmail.com, davem@davemloft.net,
 linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au
To: Rob Herring <robh@kernel.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20170530225024.ypguef347yqbjbsd@rob-hp-laptop>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Tue, May 30, 2017 at 05:50:24PM -0500, Rob Herring wrote:
> On Sat, May 20, 2017 at 04:32:12PM +0300, Cosar Dindar wrote:
> > Add device tree binding for STM32F4.
> > 
> > Signed-off-by: Cosar Dindar <cosardindar@gmail.com>
> > ---
> >  Documentation/devicetree/bindings/crypto/st,stm32-crc.txt | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt b/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
> > index 3ba92a5..7b30f1e 100644
> > --- a/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
> > +++ b/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
> > @@ -1,7 +1,7 @@
> >  * STMicroelectronics STM32 CRC
> >  
> >  Required properties:
> > -- compatible: Should be "st,stm32f7-crc".
> > +- compatible: Can be either "st,stm32f7-crc" or "st,srm32f4-crc".
> 
> Here you say either, but the example has both.
>
Thanks for reviewing. Here it could be changed as :
	Should be one of the following string
	      "st,stm32f7-crc"
	      "st,stm32f4-crc"

Also, example may not contain both binding strings, I think. It could be leaved unchanged
as in the previous version. I will make these changes with this way if it is OK.

> >  - reg: The address and length of the peripheral registers space
> >  - clocks: The input clock of the CRC instance
> >  
> > @@ -10,7 +10,7 @@ Optional properties: none
> >  Example:
> >  
> >  crc: crc@40023000 {
> > -	compatible = "st,stm32f7-crc";
> > +	compatible = "st,stm32f7-crc", "st,stm32f4-crc";
> >  	reg = <0x40023000 0x400>;
> >  	clocks = <&rcc 0 12>;
> >  };
> > -- 
> > 2.7.4
> > 
