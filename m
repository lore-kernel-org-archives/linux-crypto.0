Return-Path: <SRS0=J/bj=DC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1707C4363D
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 07:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5661923447
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 07:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbgIYHbd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Sep 2020 03:31:33 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53000 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727238AbgIYHbd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Sep 2020 03:31:33 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kLiBz-0006Ja-MU; Fri, 25 Sep 2020 17:30:56 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Sep 2020 17:30:55 +1000
Date:   Fri, 25 Sep 2020 17:30:55 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     arnd@arndb.de, davem@davemloft.net, mripard@kernel.org,
        wens@csie.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/7] crypto: sun4i-ss: linearize buffers content must
 be kept
Message-ID: <20200925073055.GA18879@gondor.apana.org.au>
References: <1600627038-40000-1-git-send-email-clabbe@baylibre.com>
 <1600627038-40000-2-git-send-email-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600627038-40000-2-git-send-email-clabbe@baylibre.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Sep 20, 2020 at 06:37:12PM +0000, Corentin Labbe wrote:
> When running the non-optimized cipher function, SS produce partial random
> output.
> This is due to linearize buffers being reseted after each loop.
> 
> Fixes: 8d3bcb9900ca ("crypto: sun4i-ss - reduce stack usage")
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
> index b72de8939497..b92d175b5d2a 100644
> --- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
> +++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
> @@ -163,6 +163,8 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
>  	unsigned int todo;
>  	struct sg_mapping_iter mi, mo;
>  	unsigned int oi, oo;	/* offset for in and out */
> +	char buf[4 * SS_RX_MAX];/* buffer for linearize SG src */
> +	char bufo[4 * SS_TX_MAX]; /* buffer for linearize SG dst */
>  	unsigned int ob = 0;	/* offset in buf */
>  	unsigned int obo = 0;	/* offset in bufo*/
>  	unsigned int obl = 0;	/* length of data in bufo */
> @@ -233,8 +235,6 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
>  
>  	while (oleft) {
>  		if (ileft) {
> -			char buf[4 * SS_RX_MAX];/* buffer for linearize SG src */
> -
>  			/*
>  			 * todo is the number of consecutive 4byte word that we
>  			 * can read from current SG

Ouch.  So this is obviously correct but I wonder if the stack
usage would be an issue again?

How about moving this code into another function so that it sits
at the same level as the fallback function, which would mean that
the buffers do not double up with the one for the fallback?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
