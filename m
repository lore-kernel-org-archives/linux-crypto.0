From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH v5 01/18] ima: Remove redundant conditional operator
Date: Tue, 17 Oct 2017 22:53:14 -0200
Message-ID: <20171018005331.2688-2-bauerman@linux.vnet.ibm.com>
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

A non-zero value is converted to 1 when assigned to a bool variable, so the
conditional operator in is_ima_appraise_enabled is redundant.

The value of a comparison operator is either 1 or 0 so the conditional
operator in ima_inode_setxattr is redundant as well.

Confirmed that the patch is correct by comparing the object file from
before and after the patch. They are identical.

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_appraise.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 809ba70fbbbf..ec7dfa02c051 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -40,7 +40,7 @@ __setup("ima_appraise=", default_appraise_setup);
  */
 bool is_ima_appraise_enabled(void)
 {
-	return (ima_appraise & IMA_APPRAISE_ENFORCE) ? 1 : 0;
+	return ima_appraise & IMA_APPRAISE_ENFORCE;
 }
 
 /*
@@ -405,7 +405,7 @@ int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
 		if (!xattr_value_len || (xvalue->type >= IMA_XATTR_LAST))
 			return -EINVAL;
 		ima_reset_appraise_flags(d_backing_inode(dentry),
-			 (xvalue->type == EVM_IMA_XATTR_DIGSIG) ? 1 : 0);
+			xvalue->type == EVM_IMA_XATTR_DIGSIG);
 		result = 0;
 	}
 	return result;
