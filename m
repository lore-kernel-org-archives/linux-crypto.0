Return-Path: <SRS0=BhDJ=YL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D95CA9EA0
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 08:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B1CA2089C
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 08:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405177AbfJRICn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Oct 2019 04:02:43 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37294 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729376AbfJRICn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Oct 2019 04:02:43 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iLNDb-0001rH-Uo; Fri, 18 Oct 2019 19:02:41 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Oct 2019 19:02:39 +1100
Date:   Fri, 18 Oct 2019 19:02:39 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Cc:     linux-crypto@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH] dt-bindings: hwrng: Add Samsung Exynos 5250+ True RNG
 bindings
Message-ID: <20191018080239.GD25128@gondor.apana.org.au>
References: <CGME20191009141735eucas1p216018d6fd7716bde4143f70e51b58ef2@eucas1p2.samsung.com>
 <20191009141732.1489-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191009141732.1489-1-l.stelmach@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 09, 2019 at 04:17:32PM +0200, Łukasz Stelmach wrote:
> Add binding documentation for the True Random Number Generator
> found on Samsung Exynos 5250+ SoCs.
> 
> Acked-by: Rob Herring <robh@kernel.org>
> Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  .../bindings/rng/samsung,exynos5250-trng.txt    | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
