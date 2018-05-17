From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH] crypto: inside-secure - do not use memset on MMIO
Date: Thu, 17 May 2018 15:22:14 +0200
Message-ID: <20180517132214.23528-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, oferh@marvell.com, igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch fixes the Inside Secure driver which uses a memtset() call to
set an MMIO area from the cryptographic engine to 0. This is wrong as
memset() isn't guaranteed to work on MMIO for many reasons. This led to
kernel paging request panics in certain cases. Use memset_io() instead.

Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto engine driver")
Reported-by: Ofer Heifetz <oferh@marvell.com>
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 46ab2d0eb3fd..4e86f864a952 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -153,8 +153,8 @@ static int eip197_load_firmwares(struct safexcel_crypto_priv *priv)
 	       EIP197_PE_ICE_SCRATCH_CTRL_CHANGE_ACCESS;
 	writel(val, EIP197_PE(priv) + EIP197_PE_ICE_SCRATCH_CTRL);
 
-	memset(EIP197_PE(priv) + EIP197_PE_ICE_SCRATCH_RAM, 0,
-	       EIP197_NUM_OF_SCRATCH_BLOCKS * sizeof(u32));
+	memset_io(EIP197_PE(priv) + EIP197_PE_ICE_SCRATCH_RAM, 0,
+		  EIP197_NUM_OF_SCRATCH_BLOCKS * sizeof(u32));
 
 	eip197_write_firmware(priv, fw[FW_IFPP], EIP197_PE_ICE_FPP_CTRL,
 			      EIP197_PE_ICE_RAM_CTRL_FPP_PROG_EN);
-- 
2.17.0
