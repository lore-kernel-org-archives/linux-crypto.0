From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: implement SM4 for arm64 using special
 instructions
Date: Sat, 5 May 2018 15:17:11 +0800
Message-ID: <20180505071711.r5swugmom3t44kcd@gondor.apana.org.au>
References: <20180425122046.12695-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: gilad@benyossef.com, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180425122046.12695-1-ard.biesheuvel@linaro.org>
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

On Wed, Apr 25, 2018 at 02:20:44PM +0200, Ard Biesheuvel wrote:
> Patch #1 makes some preparatory changes so the C routines can be used as
> a fallback by other drivers.
> 
> Patch #2 implements the SM4 core cipher using the special instructions
> introduced as an optional extension by revision 8.2 of the ARM architecture.
> 
> Note that this does not implement cipher+chaining mode combinations as we
> do for AES. This can be added later if desiresd.
> 
> Ard Biesheuvel (2):
>   crypto: sm4 - export encrypt/decrypt routines to other drivers
>   crypto: arm64 - add support for SM4 encryption using special
>     instructions
> 
>  arch/arm64/crypto/Kconfig       |  6 ++
>  arch/arm64/crypto/Makefile      |  3 +
>  arch/arm64/crypto/sm4-ce-core.S | 36 ++++++++++
>  arch/arm64/crypto/sm4-ce-glue.c | 73 ++++++++++++++++++++
>  crypto/sm4_generic.c            | 10 +--
>  include/crypto/sm4.h            |  3 +
>  6 files changed, 127 insertions(+), 4 deletions(-)
>  create mode 100644 arch/arm64/crypto/sm4-ce-core.S
>  create mode 100644 arch/arm64/crypto/sm4-ce-glue.c

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
