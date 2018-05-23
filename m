From: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: [PATCH v7 13/14] ima: Write modsig to the measurement list
Date: Tue, 22 May 2018 21:12:52 -0300
Message-ID: <20180523001253.15247-14-bauerman@linux.ibm.com>
References: <20180523001253.15247-1-bauerman@linux.ibm.com>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
To: linux-integrity@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180523001253.15247-1-bauerman@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add modsig support to the "sig" template field, allowing the the contents
of the modsig to be included in the measurement list.

Suggested-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
---
 security/integrity/ima/ima.h              |  7 +++++++
 security/integrity/ima/ima_modsig.c       | 13 +++++++++++++
 security/integrity/ima/ima_template_lib.c | 15 ++++++++++++++-
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 4ed7b0610842..33120c10a173 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -314,6 +314,7 @@ int ima_read_modsig(enum ima_hooks func, const void *buf, loff_t buf_len,
 		    int *xattr_len);
 int ima_get_modsig_hash(struct evm_ima_xattr_data *hdr, enum hash_algo *algo,
 			const u8 **hash, u8 *len);
+int ima_modsig_serialize_data(struct evm_ima_xattr_data **data, int *data_len);
 int ima_modsig_verify(const unsigned int keyring_id,
 		      struct evm_ima_xattr_data *hdr);
 void ima_free_xattr_data(struct evm_ima_xattr_data *hdr);
@@ -338,6 +339,12 @@ static inline int ima_get_modsig_hash(struct evm_ima_xattr_data *hdr,
 	return -EOPNOTSUPP;
 }
 
+static inline int ima_modsig_serialize_data(struct evm_ima_xattr_data **data,
+					    int *data_len)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int ima_modsig_verify(const unsigned int keyring_id,
 				    struct evm_ima_xattr_data *hdr)
 {
diff --git a/security/integrity/ima/ima_modsig.c b/security/integrity/ima/ima_modsig.c
index 0a8b9216cfa5..105fd04d585e 100644
--- a/security/integrity/ima/ima_modsig.c
+++ b/security/integrity/ima/ima_modsig.c
@@ -167,6 +167,19 @@ int ima_get_modsig_hash(struct evm_ima_xattr_data *hdr, enum hash_algo *algo,
 	return pkcs7_get_digest(modsig->pkcs7_msg, hash, len);
 }
 
+int ima_modsig_serialize_data(struct evm_ima_xattr_data **data, int *data_len)
+{
+	struct modsig_hdr *modsig = (struct modsig_hdr *) *data;
+
+	if (!*data || (*data)->type != IMA_MODSIG)
+		return -EINVAL;
+
+	*data = &modsig->raw_pkcs7;
+	*data_len = modsig->raw_pkcs7_len;
+
+	return 0;
+}
+
 int ima_modsig_verify(const unsigned int keyring_id,
 		      struct evm_ima_xattr_data *hdr)
 {
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index 36d175816894..417cd153ba60 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -411,10 +411,23 @@ int ima_eventsig_init(struct ima_event_data *event_data,
 		      struct ima_field_data *field_data)
 {
 	struct evm_ima_xattr_data *xattr_value = event_data->xattr_value;
+	int xattr_len = event_data->xattr_len;
 
 	if (!is_signed(xattr_value))
 		return 0;
 
-	return ima_write_template_field_data(xattr_value, event_data->xattr_len,
+	/*
+	 * The xattr_value for IMA_MODSIG is a runtime structure containing
+	 * pointers. Get its raw data instead.
+	 */
+	if (xattr_value->type == IMA_MODSIG) {
+		int rc;
+
+		rc = ima_modsig_serialize_data(&xattr_value, &xattr_len);
+		if (rc)
+			return rc;
+	}
+
+	return ima_write_template_field_data(xattr_value, xattr_len,
 					     DATA_FMT_HEX, field_data);
 }
