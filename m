From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 4/4] crypto: RSA padding algorithm
Date: Fri, 4 Dec 2015 22:12:25 +0800
Message-ID: <20151204141225.GA17284@gondor.apana.org.au>
References: <1448798541-17580-2-git-send-email-andrew.zaborowski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Andrew Zaborowski <andrew.zaborowski@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57406 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbbLDOM3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Dec 2015 09:12:29 -0500
Content-Disposition: inline
In-Reply-To: <1448798541-17580-2-git-send-email-andrew.zaborowski@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Andrew Zaborowski <andrew.zaborowski@intel.com> wrote:
>
> +       err = crypto_akcipher_encrypt(&req_ctx->child_req);
> +       if (err != -EINPROGRESS && err != -EBUSY)
> +               return pkcs1pad_encrypt_sign_complete(req, err);

What if err == -EBUSY but the bit MAY_BACKLOG is not set? In that
case you need to call complete, right?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
