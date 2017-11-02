From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH 1/4] crypto: dh - fix double free of ctx->p
Date: Thu, 2 Nov 2017 12:55:56 +0200
Message-ID: <93501fc6-94df-bf27-cdd8-7a44b04effc1@microchip.com>
References: <20171101222517.41602-1-ebiggers3@gmail.com>
 <20171101222517.41602-2-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <keyrings@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        Stephan Mueller <smueller@chronox.de>,
        Eric Biggers <ebiggers@google.com>, <stable@vger.kernel.org>
To: Eric Biggers <ebiggers3@gmail.com>, <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171101222517.41602-2-ebiggers3@gmail.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi, Eric,

On 11/02/2017 12:25 AM, Eric Biggers wrote:
> When setting the secret with the software Diffie-Hellman implementation,
> if allocating 'g' failed (e.g. if it was longer than
> MAX_EXTERN_MPI_BITS), then 'p' was freed twice: once immediately, and
> once later when the crypto_kpp tfm was destroyed.  Fix it by using
> dh_free_ctx() in the error paths, as that sets the pointers to NULL.

Other solution would be to have just an one-line patch that sets p to
NULL after freeing it. The benefit of just setting p to NULL and not
using dh_free_ctx() is that you'll spare some cpu cycles. If g fails,
g and a will already be NULL, so freeing them and set them to NULL is
redundant.

However, if you decide to always use dh_free_ctx(), you'll have to get
rid of dh_clear_params(), because it will be used just in dh_free_ctx().
You can copy dh_clear_params() body to dh_free_ctx().

Cheers,
ta
