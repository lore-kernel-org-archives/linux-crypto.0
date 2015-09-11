From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto/testmgr: don't copy from source IV too much
Date: Fri, 11 Sep 2015 22:14:43 +0800
Message-ID: <20150911141443.GA6962@gondor.apana.org.au>
References: <20150903132057.GA31317@gondor.apana.org.au>
 <1441879915-5362-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1441879915-5362-1-git-send-email-aryabinin@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 10, 2015 at 01:11:55PM +0300, Andrey Ryabinin wrote:
> While the destination buffer 'iv' is MAX_IVLEN size,
> the source 'template[i].iv' could be smaller, thus
> memcpy may read read invalid memory.
> Use crypto_skcipher_ivsize() to get real ivsize
> and pass it to memcpy.
> 
> Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
