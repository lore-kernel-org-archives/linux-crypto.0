From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/3] crypto: use unaligned accessors in aligned fast paths
Date: Mon,  8 Oct 2018 23:15:51 +0200
Message-ID: <20181008211554.5355-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: jason@zx2c4.com, herbert@gondor.apana.org.au, arnd@arndb.de,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>, ebiggers@google.com,
 linux-arm-kernel@lists.infradead.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
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

CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS behaves a bit counterintuitively
on ARM: we set it for architecture revisions v6 and up, which support
any alignment for load/store instructions that operate on bytes, half
words or words. However, load/store double word and load store multiple
instructions still require 32-bit alignment, and using them on unaligned
quantities results in costly alignment traps that have to be fixed up by
the kernel's fixup code.

Fortunately, the unaligned accessors do the right thing here: on
architectures that really tolerate any misalignment, they simply resolve
to the aligned accessors, while on ARMv6+ (which uses the packed struct
wrappers for unaligned accesses), they result in load/store sequences
that avoid the instructions that require 32-bit alignment.

Since there is not really a downside to using the unaligned accessors on
aligned paths for architectures other than ARM that define
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS, let's switch to them in a couple
of places in the crypto code.

Note that all patches are against code that has been observed to be emitted
with ldm or ldrd instructions when building ARM's multi_v7_defconfig.

Ard Biesheuvel (3):
  crypto: memneq - use unaligned accessors for aligned fast path
  crypto: crypto_xor - use unaligned accessors for aligned fast path
  crypto: siphash - drop _aligned variants

 crypto/algapi.c         |   7 +-
 crypto/memneq.c         |  24 +++--
 include/crypto/algapi.h |  11 +-
 include/linux/siphash.h | 106 +++++++++-----------
 lib/siphash.c           | 103 ++-----------------
 5 files changed, 83 insertions(+), 168 deletions(-)

-- 
2.11.0
