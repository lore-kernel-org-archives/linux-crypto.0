From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: aesni: make arrays aesni_simd_skciphers and
 aesni_simd_skciphers2 static
Date: Fri, 22 Sep 2017 18:13:29 +0800
Message-ID: <20170922101329.GF16270@gondor.apana.org.au>
References: <20170820213438.14686-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170820213438.14686-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Aug 20, 2017 at 10:34:38PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Arrays aesni_simd_skciphers and aesni_simd_skciphers2 are local to the
> source and do not need to be in global scope, so make them static.
> 
> Cleans up sparse warnings:
> symbol 'aesni_simd_skciphers' was not declared. Should it be static?
> symbol 'aesni_simd_skciphers2' was not declared. Should it be static?
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
