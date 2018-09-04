From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: arm/chacha20 - faster 8-bit rotations and
 other optimizations
Date: Tue, 4 Sep 2018 13:22:11 +0800
Message-ID: <20180904052211.tlncsdzljwjh5xyg@gondor.apana.org.au>
References: <20180901071707.14712-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Eric Biggers <ebiggers@kernel.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180901071707.14712-1-ebiggers@kernel.org>
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

On Sat, Sep 01, 2018 at 12:17:07AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Optimize ChaCha20 NEON performance by:
> 
> - Implementing the 8-bit rotations using the 'vtbl.8' instruction.
> - Streamlining the part that adds the original state and XORs the data.
> - Making some other small tweaks.
> 
> On ARM Cortex-A7, these optimizations improve ChaCha20 performance from
> about 12.08 cycles per byte to about 11.37 -- a 5.9% improvement.
> 
> There is a tradeoff involved with the 'vtbl.8' rotation method since
> there is at least one CPU (Cortex-A53) where it's not fastest.  But it
> seems to be a better default; see the added comment.  Overall, this
> patch reduces Cortex-A53 performance by less than 0.5%.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/arm/crypto/chacha20-neon-core.S | 277 ++++++++++++++-------------
>  1 file changed, 143 insertions(+), 134 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
