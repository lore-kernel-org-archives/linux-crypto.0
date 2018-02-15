From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH 2/2] include: psp-sev: Capitalize invalid length enum
Date: Thu, 15 Feb 2018 13:34:45 -0600
Message-ID: <20180215193445.40046-2-brijesh.singh@amd.com>
References: <20180215193445.40046-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Brijesh Singh <brijesh.singh@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary R Hook <gary.hook@amd.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0047.outbound.protection.outlook.com ([104.47.41.47]:58919
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755506AbeBOTfP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 14:35:15 -0500
In-Reply-To: <20180215193445.40046-1-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit 1d57b17c60ff ("crypto: ccp: Define SEV userspace ioctl and command
id") added the invalid length enum but we missed capitalizing it.

Fixes: 1d57b17c60ff (crypto: ccp: Define SEV userspace ioctl ...)
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
CC: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 include/uapi/linux/psp-sev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 3d77fe91239a..9008f31c7eb6 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -42,7 +42,7 @@ typedef enum {
 	SEV_RET_INVALID_PLATFORM_STATE,
 	SEV_RET_INVALID_GUEST_STATE,
 	SEV_RET_INAVLID_CONFIG,
-	SEV_RET_INVALID_len,
+	SEV_RET_INVALID_LEN,
 	SEV_RET_ALREADY_OWNED,
 	SEV_RET_INVALID_CERTIFICATE,
 	SEV_RET_POLICY_FAILURE,
-- 
2.14.3
