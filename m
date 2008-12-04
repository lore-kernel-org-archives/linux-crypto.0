From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/4][RFC] crypto: michael_mic - Switch to shash
Date: Thu, 4 Dec 2008 11:29:56 +0800
Message-ID: <20081204032956.GA16987@gondor.apana.org.au>
References: <12283498922490-git-send-email-ken@codelabs.ch> <12283498932360-git-send-email-ken@codelabs.ch> <12283498942104-git-send-email-ken@codelabs.ch> <12283498953450-git-send-email-ken@codelabs.ch> <12283498962759-git-send-email-ken@codelabs.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com
To: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46776 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752709AbYLDDhW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Dec 2008 22:37:22 -0500
Content-Disposition: inline
In-Reply-To: <12283498962759-git-send-email-ken@codelabs.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 04, 2008 at 01:18:12AM +0100, Adrian-Ken Rueegsegger wrote:
>
>  struct michael_mic_ctx {
> +	u32 l, r;
> +};
> +
> +struct michael_mic_desc_ctx {
>  	u8 pending[4];
>  	size_t pending_len;
>  
>  	u32 l, r;
>  };

Any reason why you left them in the desc context?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
