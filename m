Return-Path: <SRS0=NP+Z=6A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 186EFC2BA2B
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Apr 2020 06:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED2CD214D8
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Apr 2020 06:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436968AbgDPGwS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Apr 2020 02:52:18 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:41448 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436898AbgDPGwN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Apr 2020 02:52:13 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jOyMh-0005IU-H1; Thu, 16 Apr 2020 16:51:12 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Apr 2020 16:51:11 +1000
Date:   Thu, 16 Apr 2020 16:51:11 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Hadar Gat <hadar.gat@arm.com>
Cc:     Matt Mackall <mpm@selenic.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <ofir.drang@arm.com>
Subject: Re: [PATCH v7 0/3] hw_random: introduce Arm CryptoCell TRNG driver
Message-ID: <20200416065111.GC7901@gondor.apana.org.au>
References: <1585289423-18440-1-git-send-email-hadar.gat@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585289423-18440-1-git-send-email-hadar.gat@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 27, 2020 at 09:10:20AM +0300, Hadar Gat wrote:
> The Arm CryptoCell is a hardware security engine.
> This patch introduces driver for its TRNG (True Random Number Generator)
> engine.
> 
> v7 change: in arm-cctrng.yaml, removed unneeded 'minitems'
> 
> v6 change: add missing initialization of hwrng quality.
> 
> v5 changes:
> 	1. in arm-cctrng.yaml, fixed error in 'make dt_binding_check'
> 	2. in cctrng.c, clean up cctrng clock handling
> 
> v4 changes: update arm-cctrng.yaml to conform with json-schema standard.
> 
> v3 change: removed few unneeded "#ifdef CONFIG_PM" from the code.
> 
> v2 changes: fixed 'make dt_bnding_check' errors.
> 
> Hadar Gat (3):
>   dt-bindings: add device tree binding for Arm CryptoCell trng engine
>   hw_random: cctrng: introduce Arm CryptoCell driver
>   MAINTAINERS: add HG as cctrng maintainer
> 
>  .../devicetree/bindings/rng/arm-cctrng.yaml        |  54 ++
>  MAINTAINERS                                        |   9 +
>  drivers/char/hw_random/Kconfig                     |  12 +
>  drivers/char/hw_random/Makefile                    |   1 +
>  drivers/char/hw_random/cctrng.c                    | 736 +++++++++++++++++++++
>  drivers/char/hw_random/cctrng.h                    |  72 ++
>  6 files changed, 884 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/arm-cctrng.yaml
>  create mode 100644 drivers/char/hw_random/cctrng.c
>  create mode 100644 drivers/char/hw_random/cctrng.h

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
