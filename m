From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/6] [CRYPTO] added the code of Camellia cipher algorithm.
Date: Sun, 22 Oct 2006 15:09:54 +1000
Message-ID: <20061022050954.GA24183@gondor.apana.org.au>
References: <20061018.161510.796986352.takamiya@po.ntts.co.jp> <20061018.161647.1044955937.takamiya@po.ntts.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, netdev@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:13834 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S1422993AbWJVFJ4
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 22 Oct 2006 01:09:56 -0400
To: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
Content-Disposition: inline
In-Reply-To: <20061018.161647.1044955937.takamiya@po.ntts.co.jp>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 18, 2006 at 07:16:47AM +0000, Noriaki TAKAMIYA wrote:
>
> +static int
> +camellia_set_key(struct crypto_tfm *tfm, const u8 *in_key,
> +		 unsigned int key_len, u32 *flags)

Ugh, this doesn't compile with the current tree since the flags
field no longer exists for set_key.  I've fixed it up in my tree.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
