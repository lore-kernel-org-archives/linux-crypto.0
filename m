From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH crypto 2/2] crypto: caam - add allocation failure handling in SPRINTFCAT macro
Date: Fri, 18 Apr 2014 13:01:42 +0300
Message-ID: <1397815302-15915-2-git-send-email-horia.geanta@freescale.com>
References: <1397815302-15915-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <stable@vger.kernel.org>,
	Kim Phillips <kim.phillips@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1397815302-15915-1-git-send-email-horia.geanta@freescale.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

GFP_ATOMIC memory allocation could fail.
In this case, avoid NULL pointer dereference and notify user.

Cc: <stable@vger.kernel.org> # 3.2+
Cc: Kim Phillips <kim.phillips@freescale.com>
Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/error.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 9f25f5296029..0eabd81e1a90 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -16,9 +16,13 @@
 	char *tmp;						\
 								\
 	tmp = kmalloc(sizeof(format) + max_alloc, GFP_ATOMIC);	\
-	sprintf(tmp, format, param);				\
-	strcat(str, tmp);					\
-	kfree(tmp);						\
+	if (likely(tmp)) {					\
+		sprintf(tmp, format, param);			\
+		strcat(str, tmp);				\
+		kfree(tmp);					\
+	} else {						\
+		strcat(str, "kmalloc failure in SPRINTFCAT");	\
+	}							\
 }
 
 static void report_jump_idx(u32 status, char *outstr)
-- 
1.8.3.1
