From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH 1/4] crypto: ccp: Fix sparse, use plain integer as NULL pointer
Date: Mon, 15 Jan 2018 07:32:02 -0600
Message-ID: <20180115133205.93859-2-brijesh.singh@amd.com>
References: <20180115133205.93859-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: kvm@vger.kernel.org
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180115133205.93859-1-brijesh.singh@amd.com>
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Fix sparse warning: Using plain integer as NULL pointer. Replaces
assignment of 0 to pointer with NULL assignment.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Gary Hook <gary.hook@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/psp-dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index fcfa5b1eae61..b3afb6cc9d72 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -211,7 +211,7 @@ static int __sev_platform_shutdown_locked(int *error)
 {
 	int ret;
 
-	ret = __sev_do_cmd_locked(SEV_CMD_SHUTDOWN, 0, error);
+	ret = __sev_do_cmd_locked(SEV_CMD_SHUTDOWN, NULL, error);
 	if (ret)
 		return ret;
 
@@ -271,7 +271,7 @@ static int sev_ioctl_do_reset(struct sev_issue_cmd *argp)
 			return rc;
 	}
 
-	return __sev_do_cmd_locked(SEV_CMD_FACTORY_RESET, 0, &argp->error);
+	return __sev_do_cmd_locked(SEV_CMD_FACTORY_RESET, NULL, &argp->error);
 }
 
 static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
@@ -299,7 +299,7 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp)
 			return rc;
 	}
 
-	return __sev_do_cmd_locked(cmd, 0, &argp->error);
+	return __sev_do_cmd_locked(cmd, NULL, &argp->error);
 }
 
 static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp)
@@ -624,7 +624,7 @@ EXPORT_SYMBOL_GPL(sev_guest_decommission);
 
 int sev_guest_df_flush(int *error)
 {
-	return sev_do_cmd(SEV_CMD_DF_FLUSH, 0, error);
+	return sev_do_cmd(SEV_CMD_DF_FLUSH, NULL, error);
 }
 EXPORT_SYMBOL_GPL(sev_guest_df_flush);
 
-- 
2.9.5
