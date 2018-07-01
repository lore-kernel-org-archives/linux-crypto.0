From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: arm/speck - fix building in Thumb2 mode
Date: Sun, 1 Jul 2018 21:18:39 +0800
Message-ID: <20180701131839.kpbwifrfgdf36p4p@gondor.apana.org.au>
References: <20180618223323.130072-1-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Stefan Agner <stefan@agner.ch>, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180618223323.130072-1-ebiggers@google.com>
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

On Mon, Jun 18, 2018 at 03:33:23PM -0700, Eric Biggers wrote:
> Building the kernel with CONFIG_THUMB2_KERNEL=y and
> CONFIG_CRYPTO_SPECK_NEON set fails with the following errors:
> 
>     arch/arm/crypto/speck-neon-core.S: Assembler messages:
> 
>     arch/arm/crypto/speck-neon-core.S:419: Error: r13 not allowed here -- `bic sp,#0xf'
>     arch/arm/crypto/speck-neon-core.S:423: Error: r13 not allowed here -- `bic sp,#0xf'
>     arch/arm/crypto/speck-neon-core.S:427: Error: r13 not allowed here -- `bic sp,#0xf'
>     arch/arm/crypto/speck-neon-core.S:431: Error: r13 not allowed here -- `bic sp,#0xf'
> 
> The problem is that the 'bic' instruction can't operate on the 'sp'
> register in Thumb2 mode.  Fix it by using a temporary register.  This
> isn't in the main loop, so the performance difference is negligible.
> This also matches what aes-neonbs-core.S does.
> 
> Reported-by: Stefan Agner <stefan@agner.ch>
> Fixes: ede9622162fa ("crypto: arm/speck - add NEON-accelerated implementation of Speck-XTS")
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
