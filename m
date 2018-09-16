From: Stefan Agner <stefan@agner.ch>
Subject: [PATCH 2/2] crypto: arm/crc32 - avoid warning when compiling with Clang
Date: Sat, 15 Sep 2018 21:38:25 -0700
Message-ID: <20180916043825.23247-2-stefan@agner.ch>
References: <20180916043825.23247-1-stefan@agner.ch>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: linux@armlinux.org.uk, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stefan Agner <stefan@agner.ch>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        ard.biesheuvel@linaro.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180916043825.23247-1-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The table id (second) argument to MODULE_DEVICE_TABLE is often
referenced otherwise. This is not the case for CPU features. This
leads to a warning when building the kernel with Clang:
  arch/arm/crypto/crc32-ce-glue.c:239:33: warning: variable
    'crc32_cpu_feature' is not needed and will not be emitted
    [-Wunneeded-internal-declaration]
  static const struct cpu_feature crc32_cpu_feature[] = {
                                  ^

Avoid warnings by using __maybe_unused, similar to commit 1f318a8bafcf
("modules: mark __inittest/__exittest as __maybe_unused").

Fixes: 2a9faf8b7e43 ("crypto: arm/crc32 - enable module autoloading based on CPU feature bits")
Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/crypto/crc32-ce-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/crypto/crc32-ce-glue.c b/arch/arm/crypto/crc32-ce-glue.c
index 96e62ec105d0..cd9e93b46c2d 100644
--- a/arch/arm/crypto/crc32-ce-glue.c
+++ b/arch/arm/crypto/crc32-ce-glue.c
@@ -236,7 +236,7 @@ static void __exit crc32_pmull_mod_exit(void)
 				  ARRAY_SIZE(crc32_pmull_algs));
 }
 
-static const struct cpu_feature crc32_cpu_feature[] = {
+static const struct cpu_feature __maybe_unused crc32_cpu_feature[] = {
 	{ cpu_feature(CRC32) }, { cpu_feature(PMULL) }, { }
 };
 MODULE_DEVICE_TABLE(cpu, crc32_cpu_feature);
-- 
2.19.0
