From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: rsa-pkcs1pad: Replace GFP_ATOMIC with GFP_KERNEL
 in pkcs1pad_encrypt_sign_complete
Date: Thu, 15 Feb 2018 23:43:14 +0800
Message-ID: <20180215154314.GH7352@gondor.apana.org.au>
References: <1516874274-11851-1-git-send-email-baijiaju1990@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1516874274-11851-1-git-send-email-baijiaju1990@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jan 25, 2018 at 05:57:54PM +0800, Jia-Ju Bai wrote:
> After checking all possible call chains to kzalloc here,
> my tool finds that this kzalloc is never called in atomic context.
> Thus GFP_ATOMIC is not necessary, and it can be replaced with GFP_KERNEL.
> 
> This is found by a static analysis tool named DCNS written by myself.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
