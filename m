From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v3] crypto: s5p-sss: Add HASH support for Exynos
Date: Tue, 3 Oct 2017 21:30:39 +0200
Message-ID: <20171003193039.sadrgdxeeawu3jnx@kozik-lap>
References: <CGME20170927122551eucas1p2ce5b868e59bfa99941672936ba3c7bed@eucas1p2.samsung.com>
 <fddf226a-b0d8-fd68-3713-347ac3a0de20@partner.samsung.com>
 <20170930195044.kyhiit2nqmjgcwtl@kozik-lap>
 <77ef8f3f-a686-0043-c55d-761033a11956@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33085 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750812AbdJCTao (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2017 15:30:44 -0400
Content-Disposition: inline
In-Reply-To: <77ef8f3f-a686-0043-c55d-761033a11956@partner.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 03, 2017 at 04:57:43PM +0200, Kamil Konieczny wrote:
 
> >> [...]
> >> +static struct ahash_alg algs_sha256[] = {
> >> +{
> >> +	.init		= s5p_hash_init,
> >> +	.update		= s5p_hash_update,
> >> +	.final		= s5p_hash_final,
> >> +	.finup		= s5p_hash_finup,
> >> +	.digest		= s5p_hash_digest,
> >> +	.halg.digestsize	= SHA256_DIGEST_SIZE,
> >> +	.halg.base	= {
> >> +		.cra_name		= "sha256",
> >> +		.cra_driver_name	= "exynos-sha256",
> >> +		.cra_priority		= 100,
> >> +		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
> >> +					  CRYPTO_ALG_KERN_DRIVER_ONLY |
> >> +					  CRYPTO_ALG_ASYNC |
> >> +					  CRYPTO_ALG_NEED_FALLBACK,
> >> +		.cra_blocksize		= HASH_BLOCK_SIZE,
> >> +		.cra_ctxsize		= sizeof(struct s5p_hash_ctx),
> >> +		.cra_alignmask		= SSS_DMA_ALIGN_MASK,
> >> +		.cra_module		= THIS_MODULE,
> >> +		.cra_init		= s5p_hash_cra_init,
> >> +		.cra_exit		= s5p_hash_cra_exit,
> >> +	}
> >> +}
> >> +
> >> +};
> >> +
> >> +static struct sss_hash_algs_info exynos_hash_algs_info[] = {
> > 
> > You have warnings in your code. Please be sure that all compiler,
> > Smatch, Sparse, checkpatch and coccicheck warnings are fixed.
> > 
> > ../drivers/crypto/s5p-sss.c:1896:34: warning: ‘exynos_hash_algs_info’ defined but not used [-Wunused-variable]
> >  static struct sss_hash_algs_info exynos_hash_algs_info[] = {
> > 
> > Probably this should be __maybe_unused.
> 
> You are right, I did not check this with EXYNOS_HASH disabled, I will
> rewrite it.
> 
> > Also this should be const. I do not understand why you have to add one
> > more static variable (which sticks the driver to only one instance...)
> > and then modify it during runtime. Everything should be stored in device
> > state container (s5p_aes_dev) - directly or through some other pointers.
> 
> There is .registered field which is incremented with each algo register.
> I can move assignes to fields .import, .export and .statesize into struct.
> When I tried add const, I got compiler warn:
> drivers/crypto/s5p-sss.c: In function ‘s5p_aes_remove’:
> drivers/crypto/s5p-sss.c:2397:6: warning: passing argument 1 of ‘crypto_unregister_ahash’ discards ‘const’ qualifier from pointer target type [-Wdiscarded-qualifiers]
>       &hash_algs_i[i].algs_list[j]);
> so it was not designed to be const (in crypto framework).
> In AES code the alg struct is also static:
> static struct crypto_alg algs[] = {

The crypto_alg and ahash_alg must indeed stay non-const but
sss_hash_algs_info is different. You do not pass it to crypto-core.

> What you mean by 'stick the driver to only one instance' ? In Exynos 4412 there
> is only one SecSS block, in some other Exynos there is SlimSS, but it is not
> the same (it has lower capabilities and other io addresses), so there should not
> be two s5p_aes_dev drivers loaded at the same time. 

Current driver matches hardware in one-to-one so indeed there cannot be
two s5p_aes_dev devices. However this might change thus almost every
driver tries to follow the pattern of state-container passed to device
(e.g. platform_set_drvdata()). With this approach the code is nicely
encapsulated and usually much easier to review. Globals (or file-scope
variables) usually makes code more difficult to maintain.

In this driver this is not entirely possible as some crypto-functions do
not allow passing driver-supplied opaque pointer. But except this case,
everywhere else the driver should follow common convention - do not use
static variables.


Best regards,
Krzysztof
