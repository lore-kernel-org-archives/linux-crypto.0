From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH v5 11/18] ima: Export func_tokens
Date: Tue, 17 Oct 2017 22:53:24 -0200
Message-ID: <20171018005331.2688-12-bauerman@linux.vnet.ibm.com>
References: <20171018005331.2688-1-bauerman@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
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
To: linux-integrity@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171018005331.2688-1-bauerman@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

ima_read_modsig will need it so that it can show an error message.

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
---
 security/integrity/ima/ima.h        |  2 ++
 security/integrity/ima/ima_policy.c | 12 ++++++------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 4e61d3189b72..c9ba4362760b 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -195,6 +195,8 @@ enum ima_hooks {
 	__ima_hooks(__ima_hook_enumify)
 };
 
+extern const char *const func_tokens[];
+
 /* LIM API function definitions */
 int ima_get_action(struct inode *inode, int mask,
 		   enum ima_hooks func, int *pcr);
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index efd8e1c60c10..7355d4ab7bf4 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -959,6 +959,12 @@ void ima_delete_rules(void)
 	}
 }
 
+#define __ima_hook_stringify(str)	(#str),
+
+const char *const func_tokens[] = {
+	__ima_hooks(__ima_hook_stringify)
+};
+
 #ifdef	CONFIG_IMA_READ_POLICY
 enum {
 	mask_exec = 0, mask_write, mask_read, mask_append
@@ -971,12 +977,6 @@ static const char *const mask_tokens[] = {
 	"MAY_APPEND"
 };
 
-#define __ima_hook_stringify(str)	(#str),
-
-static const char *const func_tokens[] = {
-	__ima_hooks(__ima_hook_stringify)
-};
-
 void *ima_policy_start(struct seq_file *m, loff_t *pos)
 {
 	loff_t l = *pos;
