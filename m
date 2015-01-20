From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH] crypto: caam - don't emit ICV check failures to dmesg
Date: Tue, 20 Jan 2015 12:43:10 -0600
Message-ID: <20150120124310.ba1dd7a6454f65255c1ed713@freescale.com>
References: <1414686811-6527-1-git-send-email-tudor.ambarus@freescale.com>
	<1414688107-8196-1-git-send-email-tudor.ambarus@freescale.com>
	<20141106151714.GE4544@gondor.apana.org.au>
	<20141204182245.f352ea22dc61ea6f65d85c62@freescale.com>
	<20141211193018.2465016d545334a76c0f4bab@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Tudor Ambarus <tudor.ambarus@freescale.com>,
	<linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Marek Vasut <marex@denx.de>,
	Cristian Stoica <cristian.stoica@freescale.com>,
	Horia Geanta <horia.geanta@freescale.com>,
	<linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141211193018.2465016d545334a76c0f4bab@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

ICV check failures are part of normal operation;
leave user notification up to the higher levels,
as is done in s/w algorithm implementations.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/error.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 66d73bf..33e41ea 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -151,10 +151,15 @@ static void report_ccb_status(struct device *jrdev, const u32 status,
 	else
 		snprintf(err_err_code, sizeof(err_err_code), "%02x", err_id);
 
-	dev_err(jrdev, "%08x: %s: %s %d: %s%s: %s%s\n",
-		status, error, idx_str, idx,
-		cha_str, cha_err_code,
-		err_str, err_err_code);
+	/*
+	 * CCB ICV check failures are part of normal operation life;
+	 * we leave the upper layers to do what they want with them.
+	 */
+	if (err_id != JRSTA_CCBERR_ERRID_ICVCHK)
+		dev_err(jrdev, "%08x: %s: %s %d: %s%s: %s%s\n",
+			status, error, idx_str, idx,
+			cha_str, cha_err_code,
+			err_str, err_err_code);
 }
 
 static void report_jump_status(struct device *jrdev, const u32 status,
-- 
2.2.2
