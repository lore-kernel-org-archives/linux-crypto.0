From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [dm-devel] [PATCH v2 10/11] crypto: ahash: Remove VLA usage for
 AHASH_REQUEST_ON_STACK
Date: Mon, 25 Jun 2018 15:56:09 -0700
Message-ID: <20180625225609.GA181665@gmail.com>
References: <20180625211026.15819-1-keescook@chromium.org>
 <20180625211026.15819-11-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        qat-linux@intel.com, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-crypto@vger.kernel.org,
        Lars Persson <larper@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>,
        Rabin Vincent <rabinv@axis.com>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180625211026.15819-11-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 25, 2018 at 02:10:25PM -0700, Kees Cook wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this caps
> the ahash request size similar to the other limits and adds a sanity
> check at registration. Unfortunately, these reqsizes can be huge. Looking
> at all callers of crypto_ahash_set_reqsize(), the largest appears to be
> 664 bytes, based on a combination of manual inspection and pahole output:
> 
> 4       dcp_sha_req_ctx
> 40      crypto4xx_ctx
> 52      hash_req_ctx
> 80      ahash_request
> 88      rk_ahash_rctx
> 104     sun4i_req_ctx
> 200     mcryptd_hash_request_ctx
> 216     safexcel_ahash_req
> 228     sha1_hash_ctx
> 228     sha256_hash_ctx
> 248     img_hash_request_ctx
> 252     mtk_sha_reqctx
> 276     sahara_sha_reqctx
> 304     mv_cesa_ahash_req
> 316     iproc_reqctx_s
> 320     caam_hash_state
> 320     qce_sha_reqctx
> 356     sha512_hash_ctx
> 384     ahash_req_ctx
> 400     chcr_ahash_req_ctx
> 416     stm32_hash_request_ctx
> 432     talitos_ahash_req_ctx
> 462     atmel_sha_reqctx
> 496     ccp_aes_cmac_req_ctx
> 616     ccp_sha_req_ctx
> 664     artpec6_hash_request_context
> 
> So, this chooses 720 as a larger "round" number for the max.
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Biggers <ebiggers@google.com>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>
> Cc: Rabin Vincent <rabinv@axis.com>
> Cc: Lars Persson <larper@axis.com>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/crypto/hash.h          | 3 ++-
>  include/crypto/internal/hash.h | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/crypto/hash.h b/include/crypto/hash.h
> index 5d79e2f0936e..b550077c4767 100644
> --- a/include/crypto/hash.h
> +++ b/include/crypto/hash.h
> @@ -66,10 +66,11 @@ struct ahash_request {
>  
>  #define AHASH_MAX_DIGESTSIZE	512
>  #define AHASH_MAX_STATESIZE	512
> +#define AHASH_MAX_REQSIZE	720
>  
>  #define AHASH_REQUEST_ON_STACK(name, ahash) \
>  	char __##name##_desc[sizeof(struct ahash_request) + \
> -		crypto_ahash_reqsize(ahash)] CRYPTO_MINALIGN_ATTR; \
> +		AHASH_MAX_REQSIZE] CRYPTO_MINALIGN_ATTR; \
>  	struct ahash_request *name = (void *)__##name##_desc
>  
>  /**
> diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
> index a0b0ad9d585e..d96ae5f52125 100644
> --- a/include/crypto/internal/hash.h
> +++ b/include/crypto/internal/hash.h
> @@ -142,6 +142,7 @@ static inline struct ahash_alg *__crypto_ahash_alg(struct crypto_alg *alg)
>  static inline void crypto_ahash_set_reqsize(struct crypto_ahash *tfm,
>  					    unsigned int reqsize)
>  {
> +	BUG_ON(reqsize > AHASH_MAX_REQSIZE);
>  	tfm->reqsize = reqsize;
>  }

This isn't accounting for the cases where a hash algorithm is "wrapped" with
another one, which increases the request size.  For example, "sha512_mb" ends up
with a request size of

	sizeof(struct ahash_request) +
	sizeof(struct mcryptd_hash_request_ctx) +
	sizeof(struct ahash_request) + 
	sizeof(struct sha512_hash_ctx)

	== 808 bytes, on x86_64 with CONFIG_DEBUG_SG enabled.

	(Note also that structure sizes can vary depending on the architecture
	 and the kernel config.)

So, with the self-tests enabled your new BUG_ON() is hit on boot:

------------[ cut here ]------------
kernel BUG at ./include/crypto/internal/hash.h:145!
invalid opcode: 0000 [#1] SMP PTI
CPU: 4 PID: 337 Comm: cryptomgr_test Not tainted 4.18.0-rc2-00048-gda396e1e8ca5 #11
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
RIP: 0010:mcryptd_hash_init_tfm+0x36/0x40 crypto/mcryptd.c:289
Code: 01 00 00 e8 0c 05 fd ff 48 3d 00 f0 ff ff 77 18 48 89 43 40 8b 40 40 05 c8 00 00 00 3d d0 02 00 00 77 07 89 43 f8 31 c0 5b c3 <0f> 0b 0f 1f 84 00 00 00 00 00 80 7f 0c 00 74 01 c3 65 8b 05 d2 e2 
RSP: 0000:ffffb180c0dafc50 EFLAGS: 00010202
RAX: 00000000000002d8 RBX: ffffa1867c9267c8 RCX: ffffffffb66f5ef0
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffa1867c927c48
RBP: ffffa1867c926780 R08: 0000000000000001 R09: ffffa1867c927c00
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffffa1867c9c6848 R14: ffffa1867c9c6848 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffa1867fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000035c10001 CR4: 00000000001606e0
Call Trace:
 crypto_create_tfm+0x86/0xd0 crypto/api.c:475
 crypto_alloc_tfm+0x4b/0xb0 crypto/api.c:543
 mcryptd_alloc_ahash+0x6f/0xb0 crypto/mcryptd.c:603
 sha512_mb_async_init_tfm+0x1a/0x50 arch/x86/crypto/sha512-mb/sha512_mb.c:724
 crypto_create_tfm+0x86/0xd0 crypto/api.c:475
 crypto_alloc_tfm+0x4b/0xb0 crypto/api.c:543
 __alg_test_hash+0x1c/0x90 crypto/testmgr.c:1799
 alg_test_hash+0x6b/0x100 crypto/testmgr.c:1841
 alg_test.part.5+0x119/0x2a0 crypto/testmgr.c:3687
 cryptomgr_test+0x3b/0x40 crypto/algboss.c:223
 kthread+0x114/0x130 kernel/kthread.c:240
 ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:412
Modules linked in:
---[ end trace d726be03a53bddb5 ]---
