From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH 4/6] ima: Log the same audit cause whenever a file has no signature
Date: Tue, 18 Apr 2017 17:17:44 -0300
Message-ID: <1492546666-16615-5-git-send-email-bauerman@linux.vnet.ibm.com>
References: <1492546666-16615-1-git-send-email-bauerman@linux.vnet.ibm.com>
Cc: linux-ima-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Claudio Carvalho <cclaudio@linux.vnet.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41223 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1757564AbdDRUS7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Apr 2017 16:18:59 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3IKIu8w127746
        for <linux-crypto@vger.kernel.org>; Tue, 18 Apr 2017 16:18:58 -0400
Received: from e24smtp04.br.ibm.com (e24smtp04.br.ibm.com [32.104.18.25])
        by mx0b-001b2d01.pphosted.com with ESMTP id 29wqptn7c6-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 18 Apr 2017 16:18:58 -0400
Received: from localhost
        by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <bauerman@linux.vnet.ibm.com>;
        Tue, 18 Apr 2017 17:18:27 -0300
In-Reply-To: <1492546666-16615-1-git-send-email-bauerman@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If the file doesn't have an xattr, ima_appraise_measurement sets cause to
"missing-hash" while if there's an xattr but it's a digest instead of a
signature it sets cause to "IMA-signature-required".

Fix it by setting cause to "IMA-signature-required" in both cases.

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_appraise.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 427a896bc806..8c8030a29117 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -205,7 +205,8 @@ int ima_appraise_measurement(enum ima_hooks func,
 		if (rc && rc != -ENODATA)
 			goto out;
 
-		cause = "missing-hash";
+		cause = iint->flags & IMA_DIGSIG_REQUIRED ?
+				"IMA-signature-required" : "missing-hash";
 		status = INTEGRITY_NOLABEL;
 		if (opened & FILE_CREATED) {
 			iint->flags |= IMA_NEW_FILE;
-- 
2.7.4
