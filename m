Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12065C61DA4
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Feb 2023 01:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjBJBjk convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Feb 2023 20:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjBJBjj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2023 20:39:39 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC86E659F;
        Thu,  9 Feb 2023 17:39:35 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id DF39024E161;
        Fri, 10 Feb 2023 09:39:26 +0800 (CST)
Received: from EXMBX168.cuchost.com (172.16.6.78) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 10 Feb
 2023 09:39:26 +0800
Received: from EXMBX168.cuchost.com (172.16.6.78) by EXMBX168.cuchost.com
 (172.16.6.78) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 10 Feb
 2023 09:39:26 +0800
Received: from EXMBX168.cuchost.com ([fe80::3c2d:dee5:4938:3fc4]) by
 EXMBX168.cuchost.com ([fe80::3c2d:dee5:4938:3fc4%16]) with mapi id
 15.00.1497.044; Fri, 10 Feb 2023 09:39:26 +0800
From:   JiaJie Ho <jiajie.ho@starfivetech.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor.dooley@microchip.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Subject: RE: [PATCH v2 4/4] crypto: starfive - Add hash and HMAC support
Thread-Topic: [PATCH v2 4/4] crypto: starfive - Add hash and HMAC support
Thread-Index: AQHZNMIM/vLXVq3JgUiER7vBRC/T367F50EAgAGPv4A=
Date:   Fri, 10 Feb 2023 01:39:26 +0000
Message-ID: <4f40b91f0756417ba5edbc742a3cd349@EXMBX168.cuchost.com>
References: <20230130154242.112613-1-jiajie.ho@starfivetech.com>
 <20230130154242.112613-5-jiajie.ho@starfivetech.com>
 <Y+TBDqkjsuMiA/P7@gondor.apana.org.au>
In-Reply-To: <Y+TBDqkjsuMiA/P7@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [202.190.105.77]
x-yovoleruleagent: yovoleflag
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: 9 February, 2023 5:47 PM
> To: JiaJie Ho <jiajie.ho@starfivetech.com>
> Cc: David S . Miller <davem@davemloft.net>; Rob Herring
> <robh+dt@kernel.org>; Krzysztof Kozlowski
> <krzysztof.kozlowski+dt@linaro.org>; Emil Renner Berthing
> <kernel@esmil.dk>; Conor Dooley <conor.dooley@microchip.com>; linux-
> crypto@vger.kernel.org; devicetree@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-riscv@lists.infradead.org
> Subject: Re: [PATCH v2 4/4] crypto: starfive - Add hash and HMAC support
> 
> On Mon, Jan 30, 2023 at 11:42:42PM +0800, Jia Jie Ho wrote:
> >
> > +static inline int starfive_hash_wait_hmac_done(struct
> > +starfive_cryp_ctx *ctx) {
> > +	struct starfive_cryp_dev *cryp = ctx->cryp;
> > +	u32 status;
> > +
> > +	return readl_relaxed_poll_timeout(cryp->base +
> STARFIVE_HASH_SHACSR, status,
> > +					  (status &
> STARFIVE_HASH_HMAC_DONE), 10, 100000); }
> > +
> > +static inline int starfive_hash_wait_busy(struct starfive_cryp_ctx
> > +*ctx) {
> > +	struct starfive_cryp_dev *cryp = ctx->cryp;
> > +	u32 status;
> > +
> > +	return readl_relaxed_poll_timeout(cryp->base +
> STARFIVE_HASH_SHACSR, status,
> > +					  !(status & STARFIVE_HASH_BUSY),
> 10, 100000); }
> > +
> > +static inline int starfive_hash_wait_key_done(struct
> > +starfive_cryp_ctx *ctx) {
> > +	struct starfive_cryp_dev *cryp = ctx->cryp;
> > +	u32 status;
> > +
> > +	return readl_relaxed_poll_timeout(cryp->base +
> STARFIVE_HASH_SHACSR, status,
> > +					  (status &
> STARFIVE_HASH_KEY_DONE), 10, 100000); }
> 
> Is there no IRQ mechanism for this?

Only hmac done has IRQ, I'll add that in the next version.

Thanks
Jia Jie
