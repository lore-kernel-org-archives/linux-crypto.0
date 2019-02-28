Return-Path: <SRS0=8Gy4=RD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02E50C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 06:36:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFB7520842
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 06:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbfB1GgN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Feb 2019 01:36:13 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:40000 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfB1GgM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Feb 2019 01:36:12 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gzFId-0005wx-PQ; Thu, 28 Feb 2019 14:36:07 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gzFIZ-0001sH-3s; Thu, 28 Feb 2019 14:36:03 +0800
Date:   Thu, 28 Feb 2019 14:36:03 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kamil Konieczny <k.konieczny@partner.samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v4 0/3] add AES support for Exynos5433
Message-ID: <20190228063603.5qgkmhk4sbp674h5@gondor.apana.org.au>
References: <CGME20190222122203eucas1p1e87a8066d4348be4beb3ff035ea55828@eucas1p1.samsung.com>
 <20190222122144.19024-1-k.konieczny@partner.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190222122144.19024-1-k.konieczny@partner.samsung.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 22, 2019 at 01:21:41PM +0100, Kamil Konieczny wrote:
> Add slimSSS node to DT and crypto AES support for Exynos5433. Tested on
> Exynos5433 board with crypto run-time self tests and with tcrypt with
> command insmod tcrypt.ko mode=500 sec=1
> 
> Changes since v3:
> - moved bindings documentation out from samsung-sss.txt into separate file
>   samsung-slimsss.txt
> 
> Changes since v2:
> - address Corentine Labbe note: add "const" to char* in declaration of
>   struct samsung_aes_variant
> 
> Changes since v1:
> - address Krzysztof Kozlowski review: add missing comma in struct
>   definition, add goto for error code path, correct indentation,
>   in documentation add that Exynos5433 has both slimSSS and SSS IPs.
> 
> Kamil Konieczny (3):
>   arm64: dts: exynos: add SlimSSS for Exynos5433
>   dt-bindings: crypto: document Exynos5433 SlimSSS
>   crypto: s5p: add AES support for Exynos5433
> 
>  .../bindings/crypto/samsung-slimsss.txt       | 19 +++++++
>  arch/arm64/boot/dts/exynos/exynos5433.dtsi    |  9 ++++
>  drivers/crypto/s5p-sss.c                      | 50 +++++++++++++++++--
>  3 files changed, 74 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/crypto/samsung-slimsss.txt

Patches 2-3 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
