From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/8] crypto: arm64+generic - SHA3/SHA-512/SM-3 roundup
Date: Fri, 26 Jan 2018 23:46:23 +0800
Message-ID: <20180126154622.GI4002@gondor.apana.org.au>
References: <20180119120440.31556-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180119120440.31556-1-ard.biesheuvel@linaro.org>
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

On Fri, Jan 19, 2018 at 12:04:32PM +0000, Ard Biesheuvel wrote:
> This supersedes all outstanding patches from me related to SHA-3, SHA-512
> or SM-3.
> 
> - fix a correctness issue in the SHA-3 code (#1) and a performance issue (#2),
>   the first one is definitely a -stable candidate, the second one potentially
>   as well
> - patches #3 and #4 make the generic SHA-3 code reusable as a fallback for the
>   accelerated code introduced in #6
> - patch #5 adds some SHA-3 test cases
> - patch #6 implements SHA-3 using special arm64 instructions
> - patch #7 implements the Chinese SM3 secure hash algorithm using special
>   arm64 instructions
> - patch #8 contains some fixes for the recently queued SHA-512 arm64 code.
> 
> Ard Biesheuvel (8):
>   crypto/generic: sha3 - fixes for alignment and big endian operation
>   crypto/generic: sha3: rewrite KECCAK transform to help the compiler
>     optimize
>   crypto/generic: sha3 - simplify code
>   crypto/generic: sha3 - export init/update/final routines
>   crypto/testmgr: sha3 - add new testcases
>   crypto/arm64: sha3 - new v8.2 Crypto Extensions implementation
>   crypto/arm64: sm3 - new v8.2 Crypto Extensions implementation
>   crypto/arm64: sha512 - fix/improve new v8.2 Crypto Extensions code
> 
>  arch/arm64/crypto/Kconfig          |  12 +
>  arch/arm64/crypto/Makefile         |   6 +
>  arch/arm64/crypto/sha3-ce-core.S   | 210 ++++++++
>  arch/arm64/crypto/sha3-ce-glue.c   | 161 ++++++
>  arch/arm64/crypto/sha512-ce-core.S | 145 +++---
>  arch/arm64/crypto/sha512-glue.c    |   1 +
>  arch/arm64/crypto/sm3-ce-core.S    | 141 +++++
>  arch/arm64/crypto/sm3-ce-glue.c    |  92 ++++
>  crypto/sha3_generic.c              | 332 ++++++------
>  crypto/testmgr.h                   | 550 ++++++++++++++++++++
>  include/crypto/sha3.h              |   6 +-
>  11 files changed, 1413 insertions(+), 243 deletions(-)
>  create mode 100644 arch/arm64/crypto/sha3-ce-core.S
>  create mode 100644 arch/arm64/crypto/sha3-ce-glue.c
>  create mode 100644 arch/arm64/crypto/sm3-ce-core.S
>  create mode 100644 arch/arm64/crypto/sm3-ce-glue.c

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
