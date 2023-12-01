Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6BA84;
	Fri,  1 Dec 2023 02:13:05 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r90Vp-005hmD-EH; Fri, 01 Dec 2023 18:12:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 01 Dec 2023 18:12:54 +0800
Date: Fri, 1 Dec 2023 18:12:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] powerpc/crypto: Avoid -Wstringop-overflow warnings
Message-ID: <ZWmxpmuBcAhsE1wf@gondor.apana.org.au>
References: <ZVz8fLtrYTz+YSjn@work>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZVz8fLtrYTz+YSjn@work>

On Tue, Nov 21, 2023 at 12:52:44PM -0600, Gustavo A. R. Silva wrote:
> The compiler doesn't know that `32` is an offset into the Hash table:
> 
>  56 struct Hash_ctx {
>  57         u8 H[16];       /* subkey */
>  58         u8 Htable[256]; /* Xi, Hash table(offset 32) */
>  59 };
> 
> So, it legitimately complains about a potential out-of-bounds issue
> if `256 bytes` are accessed in `htable` (this implies going
> `32 bytes` beyond the boundaries of `Htable`):
> 
> arch/powerpc/crypto/aes-gcm-p10-glue.c: In function 'gcmp10_init':
> arch/powerpc/crypto/aes-gcm-p10-glue.c:120:9: error: 'gcm_init_htable' accessing 256 bytes in a region of size 224 [-Werror=stringop-overflow=]
>   120 |         gcm_init_htable(hash->Htable+32, hash->H);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/crypto/aes-gcm-p10-glue.c:120:9: note: referencing argument 1 of type 'unsigned char[256]'
> arch/powerpc/crypto/aes-gcm-p10-glue.c:120:9: note: referencing argument 2 of type 'unsigned char[16]'
> arch/powerpc/crypto/aes-gcm-p10-glue.c:40:17: note: in a call to function 'gcm_init_htable'
>    40 | asmlinkage void gcm_init_htable(unsigned char htable[256], unsigned char Xi[16]);
>       |                 ^~~~~~~~~~~~~~~
> 
> Address this by avoiding specifying the size of `htable` in the function
> prototype; and just for consistency, do the same for parameter `Xi`.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Closes: https://lore.kernel.org/linux-next/20231121131903.68a37932@canb.auug.org.au/
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  arch/powerpc/crypto/aes-gcm-p10-glue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
