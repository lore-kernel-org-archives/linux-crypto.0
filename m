From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: arm64/ghash-ce - performance improvements
Date: Tue, 7 Aug 2018 17:53:41 +0800
Message-ID: <20180807095341.osf4ugfhl5kzhenc@gondor.apana.org.au>
References: <20180804184625.28523-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: jerome.forissier@linaro.org, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, jens.wiklander@linaro.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180804184625.28523-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Aug 04, 2018 at 08:46:23PM +0200, Ard Biesheuvel wrote:
> Another bit of performance work on the GHASH driver: this time it is not
> the combined AES/GCM algorithm but the bare GHASH driver that gets updated.
> 
> Even though ARM cores that implement the polynomical multiplication
> instructions that these routines depend on are guaranteed to also support
> the AES instructions, and can thus use the AES/GCM driver, there could
> be reasons to use the accelerated GHASH in isolation, e.g., with another
> symmetric blockcipher, with a faster h/w accelerator, or potentially with
> an accelerator that does not expose the AES key to the OS.
> 
> The resulting code runs at 1.1 cycles per byte on Cortex-A53 (down from
> 2.4 cycles per byte)
> 
> Ard Biesheuvel (2):
>   crypto: arm64/ghash-ce - replace NEON yield check with block limit
>   crypto: arm64/ghash-ce - implement 4-way aggregation
> 
>  arch/arm64/crypto/ghash-ce-core.S | 153 ++++++++++++++------
>  arch/arm64/crypto/ghash-ce-glue.c |  87 ++++++-----
>  2 files changed, 161 insertions(+), 79 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
