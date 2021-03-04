Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87ACDC433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 04:39:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5755964EF6
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 04:39:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbhCDEic (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Mar 2021 23:38:32 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:47680 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233500AbhCDEiG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Mar 2021 23:38:06 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lHfjb-0005yd-Br; Thu, 04 Mar 2021 15:37:12 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 04 Mar 2021 15:37:11 +1100
Date:   Thu, 4 Mar 2021 15:37:11 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Romain Perier <romain.perier@gmail.com>
Cc:     Kees Cook <keescook@chromium.org>,
        kernel-hardening@lists.openwall.com,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/20] crypto: Manual replacement of the deprecated
 strlcpy() with return values
Message-ID: <20210304043711.GA25928@gondor.apana.org.au>
References: <20210222151231.22572-1-romain.perier@gmail.com>
 <20210222151231.22572-3-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222151231.22572-3-romain.perier@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 22, 2021 at 04:12:13PM +0100, Romain Perier wrote:
>
> diff --git a/crypto/lrw.c b/crypto/lrw.c
> index bcf09fbc750a..4d35f4439012 100644
> --- a/crypto/lrw.c
> +++ b/crypto/lrw.c
> @@ -357,10 +357,10 @@ static int lrw_create(struct crypto_template *tmpl, struct rtattr **tb)
>  	 * cipher name.
>  	 */
>  	if (!strncmp(cipher_name, "ecb(", 4)) {
> -		unsigned len;
> +		ssize_t len;
>  
> -		len = strlcpy(ecb_name, cipher_name + 4, sizeof(ecb_name));
> -		if (len < 2 || len >= sizeof(ecb_name))
> +		len = strscpy(ecb_name, cipher_name + 4, sizeof(ecb_name));
> +		if (len == -E2BIG || len < 2)

len == -E2BIG is superfluous as len < 2 will catch it anyway.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
