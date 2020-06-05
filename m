Return-Path: <SRS0=mFw2=7S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F8D7C433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 00:29:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 275D2206A2
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 00:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgFEA3F (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jun 2020 20:29:05 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:39506 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgFEA3F (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jun 2020 20:29:05 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jh0EE-00013h-CJ; Fri, 05 Jun 2020 10:28:59 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 05 Jun 2020 10:28:58 +1000
Date:   Fri, 5 Jun 2020 10:28:58 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net] esp: select CRYPTO_SEQIV
Message-ID: <20200605002858.GB31846@gondor.apana.org.au>
References: <20200604192322.22142-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604192322.22142-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 04, 2020 at 12:23:22PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Since CRYPTO_CTR no longer selects CRYPTO_SEQIV, it should be selected
> by INET_ESP and INET6_ESP -- similar to CRYPTO_ECHAINIV.
> 
> Fixes: f23efcbcc523 ("crypto: ctr - no longer needs CRYPTO_SEQIV")
> Cc: Corentin Labbe <clabbe@baylibre.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  net/ipv4/Kconfig | 1 +
>  net/ipv6/Kconfig | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
> index 23ba5045e3d3..d393e8132aa1 100644
> --- a/net/ipv4/Kconfig
> +++ b/net/ipv4/Kconfig
> @@ -361,6 +361,7 @@ config INET_ESP
>  	select CRYPTO_SHA1
>  	select CRYPTO_DES
>  	select CRYPTO_ECHAINIV
> +	select CRYPTO_SEQIV
>  	---help---
>  	  Support for IPsec ESP.

Hmm, the selection list doesn't include CTR so just adding SEQIV
per se makes no sense.  I'm not certain that we really want to
include every algorithm under the sun.  Steffen, what do you think?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
