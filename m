From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/2] crypto: bcm: Delete an error message for a failed memory
 allocation in do_shash()
Date: Wed, 14 Feb 2018 22:39:25 +0100
Message-ID: <35f107c8-c640-07f9-c10f-83fbe1ce4259@users.sourceforge.net>
References: <68946b12-83d6-ab74-fd54-71b23cf9b7ef@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Rice <rob.rice@broadcom.com>,
        Steve Lin <steven.lin1@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <68946b12-83d6-ab74-fd54-71b23cf9b7ef@users.sourceforge.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 14 Feb 2018 22:05:11 +0100

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/crypto/bcm/util.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/bcm/util.c b/drivers/crypto/bcm/util.c
index d543c010ccd9..a912c6ad3e85 100644
--- a/drivers/crypto/bcm/util.c
+++ b/drivers/crypto/bcm/util.c
@@ -279,7 +279,6 @@ int do_shash(unsigned char *name, unsigned char *result,
 	sdesc = kmalloc(size, GFP_KERNEL);
 	if (!sdesc) {
 		rc = -ENOMEM;
-		pr_err("%s: Memory allocation failure\n", __func__);
 		goto do_shash_err;
 	}
 	sdesc->shash.tfm = hash;
-- 
2.16.1
