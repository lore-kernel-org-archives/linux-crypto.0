From: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Subject: [PATCH 1/2] Fix static checker warning
Date: Fri, 14 Sep 2018 17:32:03 -0500
Message-ID: <31c49295223e51f5c1c4e36e7a09fe100dab1711.1536959537.git.Janakarajan.Natarajan@amd.com>
References: <cover.1536959537.git.Janakarajan.Natarajan@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        Dan Carpenter <Dan.Carpenter@oracle.com>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1536959537.git.Janakarajan.Natarajan@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Under certain configuration SEV functions can be defined as no-op.
In such a case error can be uninitialized.

Initialize the variable to 0.

Cc: Dan Carpenter <Dan.Carpenter@oracle.com>
Reported-by: Dan Carpenter <Dan.Carpenter@oracle.com>
Signed-off-by: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
---
 drivers/crypto/ccp/psp-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 72790d8..f541e60 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -423,7 +423,7 @@ EXPORT_SYMBOL_GPL(psp_copy_user_blob);
 static int sev_get_api_version(void)
 {
 	struct sev_user_data_status *status;
-	int error, ret;
+	int error = 0, ret;
 
 	status = &psp_master->status_cmd_buf;
 	ret = sev_platform_status(status, &error);
-- 
2.7.4
