Return-Path: <SRS0=WdwO=YZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F40FBCA9EC9
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 06:12:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCAF220656
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 06:12:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725784AbfKAGMF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Nov 2019 02:12:05 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37720 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbfKAGMF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Nov 2019 02:12:05 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iQQA7-0001yS-KT; Fri, 01 Nov 2019 14:11:55 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iQQA6-0004uG-Co; Fri, 01 Nov 2019 14:11:54 +0800
Date:   Fri, 1 Nov 2019 14:11:54 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     davem@davemloft.net, mark.rutland@arm.com, mripard@kernel.org,
        p.zabel@pengutronix.de, robh+dt@kernel.org, wens@csie.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v3 0/4] crypto: add sun8i-ss driver for Allwinner
 Security System
Message-ID: <20191101061154.abwwbcqzm6lg7uvi@gondor.apana.org.au>
References: <20191025185128.24068-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025185128.24068-1-clabbe.montjoie@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 25, 2019 at 08:51:24PM +0200, Corentin Labbe wrote:
> Hello
> 
> This patch serie adds support for the second version of Allwinner Security System.
> The first generation of the Security System is already handled by the sun4i-ss driver.
> Due to major change, the first driver cannot handle the second one.
> This new Security System is present on A80 and A83T SoCs.
> 
> For the moment, the driver support only DES3/AES in ECB/CBC mode.
> Patchs for CTR/CTS, RSA and RNGs will came later.
> 
> This serie is tested with CRYPTO_MANAGER_EXTRA_TESTS
> and tested on:
> sun8i-a83t-bananapi-m3
> sun9i-a80-cubieboard4
> 
> This serie is based on top of the "crypto: add sun8i-ce driver for
> Allwinner crypto engine" serie.
> 
> Regards
> 
> Changes since v2:
> - Made the reset mandatory
> - Removed reset-names
> 
> Changes since v1:
> - fixed uninitialized err in sun8i_ss_allocate_chanlist
> - Added missing commit description on DT Documentation patch
> 
> Corentin Labbe (4):
>   crypto: Add Allwinner sun8i-ss cryptographic offloader
>   dt-bindings: crypto: Add DT bindings documentation for sun8i-ss
>     Security System
>   ARM: dts: sun8i: a83t: Add Security System node
>   ARM: dts: sun9i: a80: Add Security System node
> 
>  .../bindings/crypto/allwinner,sun8i-ss.yaml   |  61 ++
>  arch/arm/boot/dts/sun8i-a83t.dtsi             |   9 +
>  arch/arm/boot/dts/sun9i-a80.dtsi              |   9 +
>  drivers/crypto/allwinner/Kconfig              |  28 +
>  drivers/crypto/allwinner/Makefile             |   1 +
>  drivers/crypto/allwinner/sun8i-ss/Makefile    |   2 +
>  .../allwinner/sun8i-ss/sun8i-ss-cipher.c      | 438 ++++++++++++
>  .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 642 ++++++++++++++++++
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h  | 218 ++++++
>  9 files changed, 1408 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun8i-ss.yaml
>  create mode 100644 drivers/crypto/allwinner/sun8i-ss/Makefile
>  create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
>  create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
>  create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h

Patches 1,2 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
