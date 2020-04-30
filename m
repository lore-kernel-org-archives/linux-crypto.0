Return-Path: <SRS0=3pbX=6O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 540DDC83001
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 04:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F5582083B
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 04:44:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgD3EoN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Apr 2020 00:44:13 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:59908 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgD3EoN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Apr 2020 00:44:13 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jU11s-0004jj-Fi; Thu, 30 Apr 2020 14:42:33 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Apr 2020 14:43:24 +1000
Date:   Thu, 30 Apr 2020 14:43:24 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] crypto: drbg: DRBG should select SHA512
Message-ID: <20200430044324.GA13460@gondor.apana.org.au>
References: <1587735647-17718-1-git-send-email-clabbe@baylibre.com>
 <1587735647-17718-2-git-send-email-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587735647-17718-2-git-send-email-clabbe@baylibre.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 24, 2020 at 01:40:45PM +0000, Corentin Labbe wrote:
> Since DRBG could use SHA384/SHA512, it should select it.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  crypto/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index c24a47406f8f..6d27fc6a7bf5 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -1810,10 +1810,12 @@ config CRYPTO_DRBG_HMAC
>  	default y
>  	select CRYPTO_HMAC
>  	select CRYPTO_SHA256
> +	select CRYPTO_SHA512
>  
>  config CRYPTO_DRBG_HASH
>  	bool "Enable Hash DRBG"
>  	select CRYPTO_SHA256
> +	select CRYPTO_SHA512
>  	help
>  	  Enable the Hash DRBG variant as defined in NIST SP800-90A.

The default hash drbg is sha256, the others are only optional.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
