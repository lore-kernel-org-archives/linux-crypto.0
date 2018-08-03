From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: virtio: Replace GFP_ATOMIC with GFP_KERNEL in
 __virtio_crypto_ablkcipher_do_req()
Date: Fri, 3 Aug 2018 21:58:14 +0800
Message-ID: <20180803135814.452fdflcronacrjr@gondor.apana.org.au>
References: <20180723084346.16488-1-baijiaju1990@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mst@redhat.com, jasowang@redhat.com, arei.gonglei@huawei.com,
        davem@davemloft.net, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180723084346.16488-1-baijiaju1990@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 23, 2018 at 04:43:46PM +0800, Jia-Ju Bai wrote:
> __virtio_crypto_ablkcipher_do_req() is never called in atomic context.
> 
> __virtio_crypto_ablkcipher_do_req() is only called by 
> virtio_crypto_ablkcipher_crypt_req(), which is only called by 
> virtcrypto_find_vqs() that is never called in atomic context.
> 
> __virtio_crypto_ablkcipher_do_req() calls kzalloc_node() with GFP_ATOMIC,
> which is not necessary.
> GFP_ATOMIC can be replaced with GFP_KERNEL.
> 
> This is found by a static analysis tool named DCNS written by myself.
> I also manually check the kernel code before reporting it.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
