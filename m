Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA3F46453;
	Mon, 27 May 2024 08:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716798370; cv=none; b=Ofr2WzH79a1XCSoA2d7ySMyO/fe5I0SsNHDAYTq6YcSn87rVgpc793COYNONPj5Zc+b96jU350l6zIihZtAvdwi3aX564gRQrXel6zr9Ji5Adsi+LnY8duOVVmQCMalcCKqTTjb6/R67gunqGLdtIod1oV6gfZOlUNrLH+pJwSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716798370; c=relaxed/simple;
	bh=qKVJ5s6tWF0rGf4IxoXicoBveQ0KxjUtwLHMAXcDThg=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=VmIudyFYXIi7xnDNw7vCI48GfJBDEh89OA3xWYCzfpDhpbfruqRudZHp5w1WWaZJg6o1foQhI34tuAxQyZrG1EjqqoXR/P6vnM0YyT8sPgZh1FtTwRkITfn9i9Awt8dkzeMVNJwjKViOjAkp5st3qQvFQ2Scc9HO+C5C/xzRGo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=HY8r+DF9; arc=none smtp.client-ip=198.47.19.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="HY8r+DF9"
Received: from fllv0035.itg.ti.com ([10.64.41.0])
	by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 44R8PL1l048596;
	Mon, 27 May 2024 03:25:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1716798321;
	bh=l8y8XUgX/zJirmS7nB2QP3/faPTAkS4T0rfRSJa68oY=;
	h=From:To:CC:Subject:In-Reply-To:References:Date;
	b=HY8r+DF9x9Tu61I/vYT0P0NVuBFfnCX8SJOA4ks68AEnZc6DLdPh8uXY1hvgajcC3
	 U9cpAj9njT9lqm13GWpeRloxLwEhig0xlXEUKVfAKUlu0ZBYcAEHvTNKbhmG/gfgjH
	 QdTsTgiTX6L/KkXEh2FhJpfAvdXv13qTiEALp++E=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
	by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 44R8PLoi100743
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 May 2024 03:25:21 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Mon, 27
 May 2024 03:25:21 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Mon, 27 May 2024 03:25:21 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 44R8PKoI017949;
	Mon, 27 May 2024 03:25:21 -0500
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: Conor Dooley <conor@kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        "Krzysztof
 Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley
	<conor+dt@kernel.org>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra
	<vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Catalin Marinas
	<catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Maxime Coquelin
	<mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>
Subject: Re: [EXTERNAL] Re: [PATCH v2 3/6] dt-bindings: crypto: Add Texas
 Instruments MCRC64
In-Reply-To: <20230811-imminent-fancied-89663c373ab5@spud>
References: <20230719-mcrc-upstream-v2-0-4152b987e4c2@ti.com>
 <20230719-mcrc-upstream-v2-3-4152b987e4c2@ti.com>
 <20230811-crestless-gratify-21c9bb422375@spud>
 <20230811-imminent-fancied-89663c373ab5@spud>
Date: Mon, 27 May 2024 13:55:19 +0530
Message-ID: <87plt7acgg.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

Conor Dooley <conor@kernel.org> writes:

> On Fri, Aug 11, 2023 at 04:34:33PM +0100, Conor Dooley wrote:
>> On Fri, Aug 11, 2023 at 12:58:50AM +0530, Kamlesh Gurudasani wrote:
>> > Add binding for Texas Instruments MCRC64
>> > 
>> > MCRC64 engine calculates 64-bit cyclic redundancy checks (CRC)
>> > according to the ISO 3309 standard.
>> > 
>> > The ISO 3309 64-bit CRC model parameters are as follows:
>> >     Generator Polynomial: x^64 + x^4 + x^3 + x + 1
>> >     Polynomial Value: 0x000000000000001B
>> >     Initial value: 0x0000000000000000
>> >     Reflected Input: False
>> >     Reflected Output: False
>> >     Xor Final: 0x0000000000000000
>> > 
>> > Signed-off-by: Kamlesh Gurudasani <kamlesh@ti.com>
>> > ---
>> >  Documentation/devicetree/bindings/crypto/ti,mcrc64.yaml | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>> >  MAINTAINERS                                             |  5 +++++
>> >  2 files changed, 52 insertions(+)
>> > 
>> > diff --git a/Documentation/devicetree/bindings/crypto/ti,mcrc64.yaml b/Documentation/devicetree/bindings/crypto/ti,mcrc64.yaml
>> > new file mode 100644
>> > index 000000000000..38bc7efebd68
>> > --- /dev/null
>> > +++ b/Documentation/devicetree/bindings/crypto/ti,mcrc64.yaml
>> > @@ -0,0 +1,47 @@
>> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> > +%YAML 1.2
>> > +---
>> > +$id: http://devicetree.org/schemas/crypto/ti,mcrc64.yaml#
>> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> > +
>> > +title: Texas Instruments MCRC64
>> > +
>> > +description: The MCRC64 engine calculates 64-bit cyclic redundancy checks
>> 
>> A newline after "description" please.
>> 
>> > +  (CRC) according to the ISO 3309 standard.
>> > +
>> > +maintainers:
>> > +  - Kamlesh Gurudasani <kamlesh@ti.com>
>> > +
>> > +properties:
>> > +  compatible:
>> > +    const: ti,am62-mcrc64
>> 
>> Is the am62 an SoC or a family of SoCs? I googled a wee bit for am62 &
>> there seems to be an am625 and an am623?
>
> Or is it an am62p5, in which case the compatible should contain
> ti,am62p5 I suppose. Sorry for my confusion here, its not really clear
> me too since I've been seeing many different-but-similar product names
> the last few days.
>
> Thanks,
> Conor.
>
Hi Conor,

Thanks for the review.

am62 is family of SOCs.

All devices under this family, like am623/5/p5 and etc, have MCRC64.

I have kept the naming convention similar to SA2UL/SA3UL[0].

[0] https://elixir.bootlin.com/linux/latest/source/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml#L18

Kamlesh

>> 
>> Otherwise, this looks good to me.
>> 
>> > +
>> > +  reg:
>> > +    maxItems: 1
>> > +
>> > +  clocks:
>> > +    maxItems: 1
>> > +
>> > +  power-domains:
>> > +    maxItems: 1
>> > +
>> > +required:
>> > +  - compatible
>> > +  - reg
>> > +  - clocks
>> > +  - power-domains
>> > +
>> > +additionalProperties: false
>> > +
>> > +examples:
>> > +  - |
>> > +    #include <dt-bindings/soc/ti,sci_pm_domain.h>
>> > +
>> > +    crc@30300000 {
>> > +      compatible = "ti,am62-mcrc64";
>> > +      reg = <0x30300000 0x1000>;
>> > +      clocks = <&k3_clks 116 0>;
>> > +      power-domains = <&k3_pds 116 TI_SCI_PD_EXCLUSIVE>;
>> > +    };
>> > +
>> > +...
>> > diff --git a/MAINTAINERS b/MAINTAINERS
>> > index 02a3192195af..66b51f43d196 100644
>> > --- a/MAINTAINERS
>> > +++ b/MAINTAINERS
>> > @@ -21481,6 +21481,11 @@ S:	Maintained
>> >  F:	Documentation/devicetree/bindings/iio/adc/ti,lmp92064.yaml
>> >  F:	drivers/iio/adc/ti-lmp92064.c
>> >  
>> > +TI MEMORY CYCLIC REDUNDANCY CHECK (MCRC64) DRIVER
>> > +M:	Kamlesh Gurudasani <kamlesh@ti.com>
>> > +S:	Maintained
>> > +F:	Documentation/devicetree/bindings/crypto/ti,mcrc64.yaml
>> > +
>> >  TI PCM3060 ASoC CODEC DRIVER
>> >  M:	Kirill Marinushkin <kmarinushkin@birdec.com>
>> >  L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
>> > 
>> > -- 
>> > 2.34.1
>> > 
