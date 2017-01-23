From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 00/10] crypto - AES for ARM/arm64 updates for v4.11 (round #2)
Date: Mon, 23 Jan 2017 14:05:16 +0000
Message-ID: <1485180326-25612-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36800 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbdAWOFc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Jan 2017 09:05:32 -0500
Received: by mail-wm0-f53.google.com with SMTP id c85so134172927wmi.1
        for <linux-crypto@vger.kernel.org>; Mon, 23 Jan 2017 06:05:32 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patch #1 is a fix for the CBC chaining issue that was discussed on the
mailing list. The driver itself is queued for v4.11, so this fix can go
right on top.

Patches #2 - #6 clear the cra_alignmasks of various drivers: all NEON
capable CPUs can perform unaligned accesses, and the advantage of using
the slightly faster aligned accessors (which only exist on ARM not arm64)
is certainly outweighed by the cost of copying data to suitably aligned
buffers.

NOTE: patch #5 won't apply unless 'crypto: arm64/aes-blk - honour iv_out
requirement in CBC and CTR modes' is applied first, which was sent out
separately as a bugfix for v3.16 - v4.9. If this is a problem, this patch
can wait.

Patch #7 and #8 are minor tweaks to the new scalar AES code.

Patch #9 improves the performance of the plain NEON AES code, to make it
more suitable as a fallback for the new bitsliced NEON code, which can
only operate on 8 blocks in parallel, and needs another driver to perform
CBC encryption or XTS tweak generation.

Patch #10 updates the new bitsliced AES NEON code to switch to the plain
NEON driver as a fallback.

Patches #9 and #10 improve the performance of CBC encryption by ~35% on
low end cores such as the Cortex-A53 that can be found in the Raspberry Pi3

Changes since v1:
- shave off another few cycles from the sequential AES NEON code (patch #9)

Ard Biesheuvel (10):
  crypto: arm64/aes-neon-bs - honour iv_out requirement in CTR mode
  crypto: arm/aes-ce - remove cra_alignmask
  crypto: arm/chacha20 - remove cra_alignmask
  crypto: arm64/aes-ce-ccm - remove cra_alignmask
  crypto: arm64/aes-blk - remove cra_alignmask
  crypto: arm64/chacha20 - remove cra_alignmask
  crypto: arm64/aes - avoid literals for cross-module symbol references
  crypto: arm64/aes - performance tweak
  crypto: arm64/aes-neon-blk - tweak performance for low end cores
  crypto: arm64/aes - replace scalar fallback with plain NEON fallback

 arch/arm/crypto/aes-ce-core.S          |  84 ++++----
 arch/arm/crypto/aes-ce-glue.c          |  15 +-
 arch/arm/crypto/chacha20-neon-glue.c   |   1 -
 arch/arm64/crypto/Kconfig              |   2 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c    |   1 -
 arch/arm64/crypto/aes-cipher-core.S    |  59 ++----
 arch/arm64/crypto/aes-glue.c           |  18 +-
 arch/arm64/crypto/aes-modes.S          |   8 +-
 arch/arm64/crypto/aes-neon.S           | 210 ++++++++------------
 arch/arm64/crypto/aes-neonbs-core.S    |  25 ++-
 arch/arm64/crypto/aes-neonbs-glue.c    |  38 +++-
 arch/arm64/crypto/chacha20-neon-glue.c |   1 -
 12 files changed, 203 insertions(+), 259 deletions(-)

-- 
2.7.4
