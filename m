From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 1/5] crypto: omap-aes: pr_err() strings should end with newlines
Date: Mon, 25 Sep 2017 16:06:12 +0530
Message-ID: <1506335776-1887-2-git-send-email-arvind.yadav.cs@gmail.com>
References: <1506335776-1887-1-git-send-email-arvind.yadav.cs@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net, mst@redhat.com,
        jasowang@redhat.com, arei.gonglei@huawei.com, harsh@chelsio.com,
        giovanni.cabiddu@intel.com, salvatore.benedetto@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1506335776-1887-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

pr_err() messages should terminated with a new-line to avoid
other messages being concatenated onto the end.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/crypto/omap-aes-gcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-aes-gcm.c b/drivers/crypto/omap-aes-gcm.c
index 7d4f8a4..9f8a1f7 100644
--- a/drivers/crypto/omap-aes-gcm.c
+++ b/drivers/crypto/omap-aes-gcm.c
@@ -214,7 +214,7 @@ static int do_encrypt_iv(struct aead_request *req, u32 *tag, u32 *iv)
 		}
 		/* fall through */
 	default:
-		pr_err("Encryption of IV failed for GCM mode");
+		pr_err("Encryption of IV failed for GCM mode\n");
 		break;
 	}
 
-- 
1.9.1
