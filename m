From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH] crypto: ccp - Check for CCP before registering crypto algs
Date: Fri, 5 Sep 2014 10:31:09 -0500
Message-ID: <20140905153109.14637.12600.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <lkml14@scotdoyle.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0140.outbound.protection.outlook.com ([65.55.169.140]:31821
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753373AbaIEPbq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Sep 2014 11:31:46 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If the ccp is built as a built-in module, then ccp-crypto (whether
built as a module or a built-in module) will be able to load and
it will register its crypto algorithms.  If the system does not have
a CCP this will result in -ENODEV being returned whenever a command
is attempted to be queued by the registered crypto algorithms.

Add an API, ccp_present(), that checks for the presence of a CCP
on the system.  The ccp-crypto module can use this to determine if it
should register it's crypto alogorithms.

Reported-by: Scot Doyle <lkml14@scotdoyle.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-main.c |    4 ++++
 drivers/crypto/ccp/ccp-dev.c         |   14 ++++++++++++++
 include/linux/ccp.h                  |   12 ++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index 20dc848..4d4e016 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -367,6 +367,10 @@ static int ccp_crypto_init(void)
 {
 	int ret;
 
+	ret = ccp_present();
+	if (ret)
+		return ret;
+
 	spin_lock_init(&req_queue_lock);
 	INIT_LIST_HEAD(&req_queue.cmds);
 	req_queue.backlog = &req_queue.cmds;
diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index a7d1106..c6e6171 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -55,6 +55,20 @@ static inline void ccp_del_device(struct ccp_device *ccp)
 }
 
 /**
+ * ccp_present - check if a CCP device is present
+ *
+ * Returns zero if a CCP device is present, -ENODEV otherwise.
+ */
+int ccp_present(void)
+{
+	if (ccp_get_device())
+		return 0;
+
+	return -ENODEV;
+}
+EXPORT_SYMBOL_GPL(ccp_present);
+
+/**
  * ccp_enqueue_cmd - queue an operation for processing by the CCP
  *
  * @cmd: ccp_cmd struct to be processed
diff --git a/include/linux/ccp.h b/include/linux/ccp.h
index ebcc9d1..7f43703 100644
--- a/include/linux/ccp.h
+++ b/include/linux/ccp.h
@@ -27,6 +27,13 @@ struct ccp_cmd;
 	defined(CONFIG_CRYPTO_DEV_CCP_DD_MODULE)
 
 /**
+ * ccp_present - check if a CCP device is present
+ *
+ * Returns zero if a CCP device is present, -ENODEV otherwise.
+ */
+int ccp_present(void);
+
+/**
  * ccp_enqueue_cmd - queue an operation for processing by the CCP
  *
  * @cmd: ccp_cmd struct to be processed
@@ -53,6 +60,11 @@ int ccp_enqueue_cmd(struct ccp_cmd *cmd);
 
 #else /* CONFIG_CRYPTO_DEV_CCP_DD is not enabled */
 
+static inline int ccp_present(void)
+{
+	return -ENODEV;
+}
+
 static inline int ccp_enqueue_cmd(struct ccp_cmd *cmd)
 {
 	return -ENODEV;
