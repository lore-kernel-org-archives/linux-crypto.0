From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/6] crypto: ARM/arm64 - AES and ChaCha20 updates for v4.11
Date: Mon,  2 Jan 2017 18:21:02 +0000
Message-ID: <1483381268-12987-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>
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

This series adds SIMD implementations for arm64 and ARM of ChaCha20 (*),
and a port of the ARM bit-sliced AES algorithm to arm64, and 

Patch #1 is a prerequisite for the AES-XTS implementation in #6, which needs
a secondary AES transform to generate the initial tweak.

Patch #2 optimizes the bit-sliced AES glue code for ARM to iterate over the
input in the most efficient manner possible.

Patch #3 adds a NEON implementation of ChaCha20 for ARM.

Patch #4 adds a NEON implementation of ChaCha20 for arm64.

Patch #5 modifies the existing NEON and ARMv8 Crypto Extensions implementations
of AES-CTR to be available as a synchronous skcipher as well. This is intended
for the mac80211 code, which uses synchronous encapsulations of ctr(aes)
[ccm, gcm] in softirq context, which supports SIMD algorithms on arm64.

Patch #6 adds a port of the ARM bit-sliced AES code to arm64, in ECB, CTR
and XTS modes.

Ard Biesheuvel (6):
  crypto: generic/aes - export encrypt and decrypt entry points
  crypto: arm/aes-neonbs - process 8 blocks in parallel if we can
  crypto: arm/chacha20 - implement NEON version based on SSE3 code
  crypto: arm64/chacha20 - implement NEON version based on SSE3 code
  crypto: arm64/aes-blk - expose AES-CTR as synchronous cipher as well
  crypto: arm64/aes - reimplement bit-sliced ARM/NEON implementation for
    arm64

 arch/arm/crypto/Kconfig                |   6 +
 arch/arm/crypto/Makefile               |   2 +
 arch/arm/crypto/aesbs-glue.c           |  67 +-
 arch/arm/crypto/chacha20-neon-core.S   | 524 ++++++++++++
 arch/arm/crypto/chacha20-neon-glue.c   | 128 +++
 arch/arm64/crypto/Kconfig              |  13 +
 arch/arm64/crypto/Makefile             |   6 +
 arch/arm64/crypto/aes-glue.c           |  25 +-
 arch/arm64/crypto/aes-neonbs-core.S    | 879 ++++++++++++++++++++
 arch/arm64/crypto/aes-neonbs-glue.c    | 344 ++++++++
 arch/arm64/crypto/chacha20-neon-core.S | 450 ++++++++++
 arch/arm64/crypto/chacha20-neon-glue.c | 127 +++
 crypto/aes_generic.c                   |  10 +-
 include/crypto/aes.h                   |   3 +
 14 files changed, 2549 insertions(+), 35 deletions(-)
 create mode 100644 arch/arm/crypto/chacha20-neon-core.S
 create mode 100644 arch/arm/crypto/chacha20-neon-glue.c
 create mode 100644 arch/arm64/crypto/aes-neonbs-core.S
 create mode 100644 arch/arm64/crypto/aes-neonbs-glue.c
 create mode 100644 arch/arm64/crypto/chacha20-neon-core.S
 create mode 100644 arch/arm64/crypto/chacha20-neon-glue.c

-- 
2.7.4
