From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: talitos - fix IPsec cipher in length
Date: Sat, 31 Mar 2018 01:42:44 +0800
Message-ID: <20180330174243.GH28120@gondor.apana.org.au>
References: <20180322095701.4563E6F352@po15720vm.idsi0.si.c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>, horia.geanta@nxp.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
To: Christophe Leroy <christophe.leroy@c-s.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180322095701.4563E6F352@po15720vm.idsi0.si.c-s.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Mar 22, 2018 at 10:57:01AM +0100, Christophe Leroy wrote:
> For SEC 2.x+, cipher in length must contain only the ciphertext length.
> In case of using hardware ICV checking, the ICV length is provided via
> the "extent" field of the descriptor pointer.
> 
> Cc: <stable@vger.kernel.org> # 4.8+
> Fixes: 549bd8bc5987 ("crypto: talitos - Implement AEAD for SEC1 using HMAC_SNOOP_NO_AFEU")
> Reported-by: Horia Geantă <horia.geanta@nxp.com>
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
