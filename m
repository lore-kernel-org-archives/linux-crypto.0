From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 11/11] crypto: skcipher: Remove VLA usage for
 SKCIPHER_REQUEST_ON_STACK
Date: Tue, 26 Jun 2018 17:20:41 +0800
Message-ID: <20180626092041.mxfg4lxcvxfivzc2@gondor.apana.org.au>
References: <20180625211026.15819-1-keescook@chromium.org>
 <20180625211026.15819-12-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Alasdair Kergon <agk@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, qat-linux@intel.com,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180625211026.15819-12-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 25, 2018 at 02:10:26PM -0700, Kees Cook wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this
> caps the skcipher request size similar to other limits and adds a
> sanity check at registration. In a manual review of the callers of
> crypto_skcipher_set_reqsize(), the largest was 384:
> 
> 4	sun4i_cipher_req_ctx
> 6	safexcel_cipher_req
> 8	cryptd_skcipher_request_ctx
> 80	cipher_req_ctx
> 80	skcipher_request
> 96	crypto_rfc3686_req_ctx
> 104	nitrox_kcrypt_request
> 144	mv_cesa_skcipher_std_req
> 384	rctx
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

This has the same issue as the ahash reqsize patch.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
