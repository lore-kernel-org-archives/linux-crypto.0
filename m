From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: pcrypt - fix freeing pcrypt instances
Date: Fri, 22 Dec 2017 19:36:36 +1100
Message-ID: <20171222083635.GA30861@gondor.apana.org.au>
References: <94eb2c05a380d3908b056096eb58@google.com>
 <20171220222825.207321-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171220222825.207321-1-ebiggers3@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Dec 20, 2017 at 02:28:25PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> pcrypt is using the old way of freeing instances, where the ->free()
> method specified in the 'struct crypto_template' is passed a pointer to
> the 'struct crypto_instance'.  But the crypto_instance is being
> kfree()'d directly, which is incorrect because the memory was actually
> allocated as an aead_instance, which contains the crypto_instance at a
> nonzero offset.  Thus, the wrong pointer was being kfree()'d.
> 
> Fix it by switching to the new way to free aead_instance's where the
> ->free() method is specified in the aead_instance itself.
> 
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Fixes: 0496f56065e0 ("crypto: pcrypt - Add support for new AEAD interface")
> Cc: <stable@vger.kernel.org> # v4.2+
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
