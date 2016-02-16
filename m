From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH 1/3] Documentation: devicetree: add Freescale SCC bindings
Date: Tue, 16 Feb 2016 09:41:17 +0100
Message-ID: <73fuwtdp3m.fsf@unicorn.hi.pengutronix.de>
References: <1455199485-24458-1-git-send-email-s.trumtrar@pengutronix.de> <20160214075557.GP6756@tiger>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	kernel@pengutronix.de
To: Shawn Guo <shawnguo@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:48841 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754328AbcBPIl0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Feb 2016 03:41:26 -0500
In-reply-to: <20160214075557.GP6756@tiger>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Hi!

Shawn Guo writes:

> On Thu, Feb 11, 2016 at 03:04:43PM +0100, Steffen Trumtrar wrote:
>> Add documentation for the Freescale Security Controller (SCC)
>> found on i.MX25 SoCs.
>> 
>> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
>> ---
>>  .../devicetree/bindings/crypto/fsl-imx-scc.txt          | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/crypto/fsl-imx-scc.txt
>> 
>> diff --git a/Documentation/devicetree/bindings/crypto/fsl-imx-scc.txt b/Documentation/devicetree/bindings/crypto/fsl-imx-scc.txt
>> new file mode 100644
>> index 000000000000..9a15ab8da94f
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/crypto/fsl-imx-scc.txt
>> @@ -0,0 +1,17 @@
>> +Freescale Security Controller (SCC)
>> +
>> +Required properties:
>> +- compatible : Should be "fsl,imx25-scc".
>> +- reg : Should contain register location and length.
>> +- interrupts : Should contain interrupt numbers for SCM IRQ and SMN IRQ.
>> +
>> +Example:
>> +
>> +	scc: crypto@53fac000 {
>> +		compatible = "fsl,imx25-scc";
>> +		reg = <0x53fac000 0x4000>;
>> +		clocks = <&clks 111>;
>> +		clock-names = "ipg";
>
> Shouldn't these two be mentioned in properties list above too?
>

What is the current policy on clocks in bindings? There are some with
and some without.

Of course I can add them to the required properties if necessary.

Thanks,
Steffen

-- 
Pengutronix e.K.                           | Steffen Trumtrar            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
