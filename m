From: Pravin Shedge <pravin.shedge4linux@gmail.com>
Subject: [PATCH 02/45] drivers: crypto: remove duplicate includes
Date: Tue,  5 Dec 2017 07:27:22 +0530
Message-ID: <1512439057-15443-1-git-send-email-pravin.shedge4linux@gmail.com>
Cc: pravin.shedge4linux@gmail.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Corentin LABBE <clabbe.montjoie@gmail.com>,
        Steve Lin <steven.lin1@broadcom.com>,
        Rob Rice <rob.rice@broadcom.com>,
        raveendra padasalagi <raveendra.padasalagi@broadcom.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Srikanth Jampala <Jampala.Srikanth@cavium.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

These duplicate includes have been found with scripts/checkincludes.pl but
they have been removed manually to avoid removing false positives.

Signed-off-by: Pravin Shedge <pravin.shedge4linux@gmail.com>
---
 drivers/crypto/bcm/cipher.c                  | 1 -
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c | 1 -
 drivers/crypto/ccp/ccp-crypto-aes-galois.c   | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index ce70b44..2b75f95 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -42,7 +42,6 @@
 #include <crypto/authenc.h>
 #include <crypto/skcipher.h>
 #include <crypto/hash.h>
-#include <crypto/aes.h>
 #include <crypto/sha3.h>
 
 #include "util.h"
diff --git a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
index 4addc23..deaefd5 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
@@ -6,7 +6,6 @@
 #include "nitrox_dev.h"
 #include "nitrox_req.h"
 #include "nitrox_csr.h"
-#include "nitrox_req.h"
 
 /* SLC_STORE_INFO */
 #define MIN_UDD_LEN 16
diff --git a/drivers/crypto/ccp/ccp-crypto-aes-galois.c b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
index ff02b71..ca1f0d7 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-galois.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
@@ -21,7 +21,6 @@
 #include <crypto/ctr.h>
 #include <crypto/gcm.h>
 #include <crypto/scatterwalk.h>
-#include <linux/delay.h>
 
 #include "ccp-crypto.h"
 
-- 
2.7.4
