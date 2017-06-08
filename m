From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH v2 3/6] ima: Log the same audit cause whenever a file has no signature
Date: Wed,  7 Jun 2017 22:49:12 -0300
Message-ID: <1496886555-10082-4-git-send-email-bauerman@linux.vnet.ibm.com>
References: <1496886555-10082-1-git-send-email-bauerman@linux.vnet.ibm.com>
Cc: linux-ima-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>,
        Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1496886555-10082-1-git-send-email-bauerman@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

If the file doesn't have an xattr, ima_appraise_measurement sets cause to
"missing-hash" while if there's an xattr but it's a digest instead of a
signature it sets cause to "IMA-signature-required".

Fix it by setting cause to "IMA-signature-required" in both cases.

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_appraise.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index ea36a4f134f4..809ba70fbbbf 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -217,7 +217,8 @@ int ima_appraise_measurement(enum ima_hooks func,
 		if (rc && rc != -ENODATA)
 			goto out;
 
-		cause = "missing-hash";
+		cause = iint->flags & IMA_DIGSIG_REQUIRED ?
+				"IMA-signature-required" : "missing-hash";
 		status = INTEGRITY_NOLABEL;
 		if (opened & FILE_CREATED)
 			iint->flags |= IMA_NEW_FILE;
-- 
2.7.4

