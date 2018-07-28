From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/2] crypto/arm64: aes-ce-gcm - switch to 2-way aggregation
Date: Sat, 28 Jul 2018 20:53:58 +0200
Message-ID: <20180728185400.8237-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, jerome.forissier@linaro.org,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>, catalin.marinas@arm.com,
 will.deacon@arm.com, vakul.garg@nxp.com, jens.wiklander@linaro.org,
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

Update the combined AES-GCM AEAD implementation to process two blocks
at a time, allowing us to switch to a faster version of the GHASH
implementation.

Note that this does not update the core GHASH transform, only the
combined AES-GCM AEAD mode. GHASH is mostly used with AES anyway, and
the ARMv8 architecture mandates support for AES instructions if
64-bit polynomial multiplication instructions are implemented. This
means that mosts users of the pmull.p64 based GHASH routines are better
off using the combined AES-GCM code anyway. Users of the pmull.p8 based
GHASH implementation are unlikely to benefit substantially from aggregation,
given that the multiplication phase is much more dominant in this case
(and it is only the reduction phase that is amortized over multiple
blocks)

Performance numbers for Cortex-A53 can be found after patch #2.

Ard Biesheuvel (2):
  crypto/arm64: aes-ce-gcm - operate on two input blocks at a time
  crypto/arm64: aes-ce-gcm - implement 2-way aggregation

 arch/arm64/crypto/ghash-ce-core.S | 128 +++++++++++++-------
 arch/arm64/crypto/ghash-ce-glue.c | 117 ++++++++++++------
 2 files changed, 165 insertions(+), 80 deletions(-)

-- 
2.18.0
