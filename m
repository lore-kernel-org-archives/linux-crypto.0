From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 4/4] crypto: RSA padding algorithm
Date: Thu, 26 Nov 2015 16:54:12 +0800
Message-ID: <20151126085412.GA22159@gondor.apana.org.au>
References: <1448446337-17176-4-git-send-email-andrew.zaborowski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Andrew Zaborowski <andrew.zaborowski@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54506 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbbKZIyP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Nov 2015 03:54:15 -0500
Content-Disposition: inline
In-Reply-To: <1448446337-17176-4-git-send-email-andrew.zaborowski@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Andrew Zaborowski <andrew.zaborowski@intel.com> wrote:
>
> +struct crypto_template rsa_pkcs1pad_tmpl = {
> +       .name = "pkcs1pad",
> +       .create = pkcs1pad_create,
> +       .free = pkcs1pad_free,

Please use inst->free instead (crypto/gcm.c is a good example).

BTW the first two patches are fine so you don't have to post them.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
