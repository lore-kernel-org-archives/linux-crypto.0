From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: sun4i-ss: support the Security System PRNG
Date: Mon, 5 Dec 2016 20:37:05 +0800
Message-ID: <20161205123705.GA10732@gondor.apana.org.au>
References: <1480934922-20732-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, maxime.ripard@free-electrons.com,
        wens@csie.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55361 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750951AbcLEMhW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Dec 2016 07:37:22 -0500
Content-Disposition: inline
In-Reply-To: <1480934922-20732-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 05, 2016 at 11:48:42AM +0100, Corentin Labbe wrote:
> From: LABBE Corentin <clabbe.montjoie@gmail.com>
> 
> The Security System have a PRNG.
> This patch add support for it as an hwrng.
> 
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Please don't add PRNGs to hwrng.  If we have existing PRNGs in
there please let me know so that we can remove them.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
