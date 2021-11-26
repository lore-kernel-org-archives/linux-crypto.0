Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE7AC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Nov 2021 05:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358633AbhKZFg7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Nov 2021 00:36:59 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:57150 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237891AbhKZFe5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Nov 2021 00:34:57 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mqTpm-0008R7-9g; Fri, 26 Nov 2021 13:31:42 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mqTpi-0004Z1-TO; Fri, 26 Nov 2021 13:31:38 +0800
Date:   Fri, 26 Nov 2021 13:31:38 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Samuel Holland <samuel@sholland.org>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        linux-sunxi@lists.linux.dev
Subject: Re: [PATCH 2/2] crypto: sun8i-ce: Add support for the D1 variant
Message-ID: <20211126053138.GC17477@gondor.apana.org.au>
References: <20211119051026.13049-1-samuel@sholland.org>
 <20211119051026.13049-2-samuel@sholland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119051026.13049-2-samuel@sholland.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 18, 2021 at 11:10:25PM -0600, Samuel Holland wrote:
> From: Corentin Labbe <clabbe.montjoie@gmail.com>
> 
> The Allwinner D1 SoC has a crypto engine compatible with sun8i-ce.
> Add support for it.
> 
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> Signed-off-by: Samuel Holland <samuel@sholland.org>
> ---
> 
>  .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 21 +++++++++++++++++++
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  |  1 +
>  2 files changed, 22 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
