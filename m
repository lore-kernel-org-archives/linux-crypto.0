From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [REPORT] Possible unnecessary usages of GFP_ATOMIC in
 crypto/ablkcipher.c
Date: Mon, 23 Jul 2018 14:21:01 +0800
Message-ID: <20180723062101.zzm5royyjfda6jma@gondor.apana.org.au>
References: <78a7d726-f2fa-3afb-3451-bbd51a41a48a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <78a7d726-f2fa-3afb-3451-bbd51a41a48a@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 23, 2018 at 10:39:40AM +0800, Jia-Ju Bai wrote:
> My tool DCNS reports three unnecessary usages of GFP_ATOMIC in
> crypto/ablkcipher.c:
> crypto/ablkcipher.c, 162: kmalloc(GFP_ATOMIC) in ablkcipher_next_slow
> crypto/ablkcipher.c, 199: kmalloc(GFP_ATOMIC) in ablkcipher_copy_iv
> crypto/ablkcipher.c, 315: kmalloc(GFP_ATOMIC) in setkey_unaligned
> 
> I meant to manually check the code, but I find that there are many functions
> calling ablkcipher_next_slow(),
> ablkcipher_copy_iv() and setkey_unaligned(), so I am not sure whether the
> above three reports are true.
> 
> Could someone help me to validate these reports?
> Thanks a lot in advance :)

They must use GFP_ATOMIC because they can be called from softirq
context, e.g., IPsec.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
