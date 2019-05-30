Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2261C072B1
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 07:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCCBC24CFA
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 07:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfE3HOf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 03:14:35 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:33572 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726512AbfE3HOf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 03:14:35 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hWFGj-0003Ek-Ay; Thu, 30 May 2019 15:14:33 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hWFGC-0005R8-JX; Thu, 30 May 2019 15:14:00 +0800
Date:   Thu, 30 May 2019 15:14:00 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Stephan Mueller <smueller@chronox.de>,
        Milan Broz <gmazyland@gmail.com>,
        Ondrej Kozina <okozina@redhat.com>,
        Daniel Zatovic <dzatovic@redhat.com>
Subject: Re: [PATCH] crypto: af_alg - implement keyring support
Message-ID: <20190530071400.jpadh2fjjaqzyw6m@gondor.apana.org.au>
References: <20190521100034.9651-1-omosnace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521100034.9651-1-omosnace@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 21, 2019 at 12:00:34PM +0200, Ondrej Mosnacek wrote:
>
> @@ -256,6 +362,48 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
>  			goto unlock;
>  
>  		err = alg_setkey(sk, optval, optlen);
> +#ifdef CONFIG_KEYS
> +		break;
> +	case ALG_SET_KEY_KEYRING_LOGON:
> +		if (sock->state == SS_CONNECTED)
> +			goto unlock;
> +		if (!type->setkey)
> +			goto unlock;
> +
> +		err = alg_setkey_keyring(sk, &alg_keyring_type_logon,
> +					 optval, optlen);
> +		break;
> +	case ALG_SET_KEY_KEYRING_USER:
> +		if (sock->state == SS_CONNECTED)
> +			goto unlock;
> +		if (!type->setkey)
> +			goto unlock;
> +
> +		err = alg_setkey_keyring(sk, &alg_keyring_type_user,
> +					 optval, optlen);
> +#if IS_REACHABLE(CONFIG_TRUSTED_KEYS)
> +		break;
> +	case ALG_SET_KEY_KEYRING_TRUSTED:
> +		if (sock->state == SS_CONNECTED)
> +			goto unlock;
> +		if (!type->setkey)
> +			goto unlock;
> +
> +		err = alg_setkey_keyring(sk, &alg_keyring_type_trusted,
> +					 optval, optlen);
> +#endif
> +#if IS_REACHABLE(CONFIG_ENCRYPTED_KEYS)
> +		break;
> +	case ALG_SET_KEY_KEYRING_ENCRYPTED:
> +		if (sock->state == SS_CONNECTED)
> +			goto unlock;
> +		if (!type->setkey)
> +			goto unlock;
> +
> +		err = alg_setkey_keyring(sk, &alg_keyring_type_encrypted,
> +					 optval, optlen);
> +#endif
> +#endif /* CONFIG_KEYS */
>  		break;

What's with the funky placement of "break" outside of the ifdefs?

> diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
> index bc2bcdec377b..f2d777901f00 100644
> --- a/include/uapi/linux/if_alg.h
> +++ b/include/uapi/linux/if_alg.h
> @@ -35,6 +35,13 @@ struct af_alg_iv {
>  #define ALG_SET_OP			3
>  #define ALG_SET_AEAD_ASSOCLEN		4
>  #define ALG_SET_AEAD_AUTHSIZE		5
> +#define ALG_SET_PUBKEY			6 /* reserved for future use */
> +#define ALG_SET_DH_PARAMETERS		7 /* reserved for future use */
> +#define ALG_SET_ECDH_CURVE		8 /* reserved for future use */

Why do you need to reserve these values?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
