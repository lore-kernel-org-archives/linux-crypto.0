Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6728C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 13 May 2022 09:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378578AbiEMJew (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 May 2022 05:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379067AbiEMJew (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 May 2022 05:34:52 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F488297424;
        Fri, 13 May 2022 02:34:49 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1npRgu-00DHDO-S3; Fri, 13 May 2022 19:34:34 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 May 2022 17:34:33 +0800
Date:   Fri, 13 May 2022 17:34:33 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     jernej.skrabec@gmail.com, samuel@sholland.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev
Subject: Re: [PATCH v2 00/19] crypto: allwinner: lots of fixes
Message-ID: <Yn4mKfJKPI18KHrS@gondor.apana.org.au>
References: <20220502201929.843194-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502201929.843194-1-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 02, 2022 at 08:19:10PM +0000, Corentin Labbe wrote:
> Hello
> 
> This series is all fixes which I found on allwinner crypto drivers.
> 
> Regards
> 
> Change since v1:
> - fixed endianess of hash_pad() paramaters
> 
> Corentin Labbe (19):
>   crypto: sun8i-ce: Fix minor style issue
>   crypto: sun8i-ce: do not allocate memory when handling requests
>   crypto: sun4i-ss: do not allocate backup IV on requests
>   crypto: sun8i-ss: rework handling of IV
>   crypto: sun8i-ss: handle zero sized sg
>   crypto: sun8i-ss: remove redundant test
>   crypto: sun8i-ss: test error before assigning
>   crypto: sun8i-ss: use sg_nents_for_len
>   crypto: sun8i-ss: do not allocate memory when handling hash requests
>   crypto: sun8i-ss: do not zeroize all pad
>   crypto: sun8i-ss: handle requests if last block is not modulo 64
>   crypto: sun8i-ss: rework debugging
>   crypto: sun8i-ss: Add function for handling hash padding
>   crypto: sun8i-ss: add hmac(sha1)
>   crypto: sun8i-ss: do not fallback if cryptlen is less than sg length
>   crypto: sun8i-ce: Add function for handling hash padding
>   crypto: sun8i-ce: use sg_nents_for_len
>   crypto: sun8i-ce: rework debugging
>   crypto: sun8i-ce: do not fallback if cryptlen is less than sg length
> 
>  .../allwinner/sun4i-ss/sun4i-ss-cipher.c      |  22 +-
>  drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h  |   1 +
>  .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 102 +++--
>  .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c |  54 ++-
>  .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 130 ++++--
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  |  19 +-
>  .../allwinner/sun8i-ss/sun8i-ss-cipher.c      | 180 +++++---
>  .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c |  92 ++++-
>  .../crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 385 +++++++++++++++---
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h  |  33 +-
>  10 files changed, 767 insertions(+), 251 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
