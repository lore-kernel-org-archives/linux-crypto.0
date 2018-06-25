From: Kees Cook <keescook@chromium.org>
Subject: Re: [dm-devel] [PATCH v2 10/11] crypto: ahash: Remove VLA usage for AHASH_REQUEST_ON_STACK
Date: Mon, 25 Jun 2018 16:13:31 -0700
Message-ID: <CAGXu5j+XG7y1RGMLt_=cDyiXxVhQX78_6VdHG3qwzdcwt8n7vw@mail.gmail.com>
References: <20180625211026.15819-1-keescook@chromium.org> <20180625211026.15819-11-keescook@chromium.org>
 <20180625225609.GA181665@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        qat-linux@intel.com, LKML <linux-kernel@vger.kernel.org>,
        dm-devel@redhat.com, linux-crypto <linux-crypto@vger.kernel.org>,
        Lars Persson <larper@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>,
        Rabin Vincent <rabinv@axis.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180625225609.GA181665@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 25, 2018 at 3:56 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
> On Mon, Jun 25, 2018 at 02:10:25PM -0700, Kees Cook wrote:
>> In the quest to remove all stack VLA usage from the kernel[1], this caps
>> the ahash request size similar to the other limits and adds a sanity
>> check at registration. Unfortunately, these reqsizes can be huge. Looking
>> at all callers of crypto_ahash_set_reqsize(), the largest appears to be
>> 664 bytes, based on a combination of manual inspection and pahole output:
>>
>> 4       dcp_sha_req_ctx
>> 40      crypto4xx_ctx
>> 52      hash_req_ctx
>> 80      ahash_request
>> 88      rk_ahash_rctx
>> 104     sun4i_req_ctx
>> 200     mcryptd_hash_request_ctx
>> 216     safexcel_ahash_req
>> 228     sha1_hash_ctx
>> 228     sha256_hash_ctx
>> 248     img_hash_request_ctx
>> 252     mtk_sha_reqctx
>> 276     sahara_sha_reqctx
>> 304     mv_cesa_ahash_req
>> 316     iproc_reqctx_s
>> 320     caam_hash_state
>> 320     qce_sha_reqctx
>> 356     sha512_hash_ctx
>> 384     ahash_req_ctx
>> 400     chcr_ahash_req_ctx
>> 416     stm32_hash_request_ctx
>> 432     talitos_ahash_req_ctx
>> 462     atmel_sha_reqctx
>> 496     ccp_aes_cmac_req_ctx
>> 616     ccp_sha_req_ctx
>> 664     artpec6_hash_request_context
>>
>> So, this chooses 720 as a larger "round" number for the max.
>>
>
> This isn't accounting for the cases where a hash algorithm is "wrapped" with
> another one, which increases the request size.  For example, "sha512_mb" ends up
> with a request size of
>
>         sizeof(struct ahash_request) +
>         sizeof(struct mcryptd_hash_request_ctx) +
>         sizeof(struct ahash_request) +
>         sizeof(struct sha512_hash_ctx)
>
>         == 808 bytes, on x86_64 with CONFIG_DEBUG_SG enabled.
>
>         (Note also that structure sizes can vary depending on the architecture
>          and the kernel config.)
>
> So, with the self-tests enabled your new BUG_ON() is hit on boot:

Ugh, right. Wow, that _really_ gets big. Which are likely to wrap
which others? Looks like software case plus hardware case? i.e.
mcryptd_hash_request_ctx with artpec6_hash_request_context is the
largest we could get? So: 80 + 80 + 200 + 664 ? Oh, hilarious. That
comes exactly to 1024. :P

So ... 1024?

-Kees

-- 
Kees Cook
Pixel Security
