From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH v5 18/18] ima: Write modsig to the measurement list
Date: Tue, 17 Oct 2017 22:53:31 -0200
Message-ID: <20171018005331.2688-19-bauerman@linux.vnet.ibm.com>
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
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20171018005331.2688-1-bauerman@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add modsig support for templates which require the contents of the file
signature to be included in the measurement list.

Suggested-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
---
 security/integrity/ima/ima.h              |  8 ++++++++
 security/integrity/ima/ima_api.c          |  8 +++++++-
 security/integrity/ima/ima_main.c         | 30 +++++++++++++++++++++++++++++-
 security/integrity/ima/ima_modsig.c       | 20 +++++++++++++++++++-
 security/integrity/ima/ima_template.c     | 12 ++++++++++++
 security/integrity/ima/ima_template_lib.c | 17 +++++++++++++++--
 6 files changed, 90 insertions(+), 5 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index b082138461b3..68f471666151 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -148,6 +148,7 @@ int ima_init_crypto(void);
 void ima_putc(struct seq_file *m, void *data, int datalen);
 void ima_print_digest(struct seq_file *m, u8 *digest, u32 size);
 struct ima_template_desc *ima_template_desc_current(void);
+bool ima_current_template_has_sig(void);
 int ima_restore_measurement_entry(struct ima_template_entry *entry);
 int ima_restore_measurement_list(loff_t bufsize, void *buf);
 int ima_measurements_show(struct seq_file *m, void *v);
@@ -264,6 +265,7 @@ int ima_read_modsig(enum ima_hooks func, const void *buf, loff_t buf_len,
 		    int *xattr_len);
 int ima_get_modsig_hash(struct evm_ima_xattr_data *hdr, enum hash_algo *algo,
 			void const **hash, u8 *len);
+int ima_modsig_serialize_data(struct evm_ima_xattr_data **data, int *data_len);
 int ima_modsig_verify(const unsigned int keyring_id,
 		      struct evm_ima_xattr_data *hdr);
 void ima_free_xattr_data(struct evm_ima_xattr_data *hdr);
@@ -334,6 +336,12 @@ static inline int ima_get_modsig_hash(struct evm_ima_xattr_data *hdr,
 	return -ENOTSUPP;
 }
 
+static inline int ima_modsig_serialize_data(struct evm_ima_xattr_data **data,
+					    int *data_len)
+{
+	return -ENOTSUPP;
+}
+
 static inline int ima_modsig_verify(const unsigned int keyring_id,
 				    struct evm_ima_xattr_data *hdr)
 {
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index c6d346e9f708..59a5b044b48b 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -284,7 +284,13 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
 					    xattr_len, NULL};
 	int violation = 0;
 
-	if (iint->measured_pcrs & (0x1 << pcr))
+	/*
+	 * We still need to store the measurement in the case of MODSIG because
+	 * we only have its contents to put in the list at the time of
+	 * appraisal. See comment in process_measurement for more details.
+	 */
+	if ((iint->measured_pcrs & (0x1 << pcr)) &&
+	    (!xattr_value || xattr_value->type != IMA_MODSIG))
 		return;
 
 	result = ima_alloc_init_template(&event_data, &entry);
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 6a2d960fbd92..0d3390de7432 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -246,7 +246,35 @@ static int process_measurement(struct file *file, char *buf, loff_t size,
 		rc = ima_appraise_measurement(func, iint, file, buf, size,
 					      pathname, &xattr_value,
 					      &xattr_len, opened);
-	if (action & IMA_MEASURE)
+
+	/*
+	 * MODSIG has one corner case we need to deal with here:
+	 *
+	 * Suppose the policy has one measure rule for one hook and an appraise
+	 * rule for a different hook. Suppose also that the template requires
+	 * the signature to be stored in the measurement list.
+	 *
+	 * If a file containing a MODSIG is measured by the first hook before
+	 * being appraised by the second one, the corresponding entry in the
+	 * measurement list will not contain the MODSIG because we only fetch it
+	 * for IMA_APPRAISAL. We don't fetch it earlier because if the file has
+	 * both a DIGSIG and a MODSIG it's not possible to know which one will
+	 * be valid without actually doing the appraisal.
+	 *
+	 * Therefore, after appraisal of a MODSIG signature we need to store the
+	 * measurement again if the current template requires storing the
+	 * signature.
+	 *
+	 * With the opposite ordering (the appraise rule triggering before the
+	 * measurement rule) there is the same problem but it's not possible to
+	 * do anything about it because at the time we are appraising the
+	 * signature it's impossible to know whether a measurement will ever
+	 * need to be stored for this file.
+	 */
+	if ((action & IMA_MEASURE) || ((iint->flags & IMA_MEASURE) &&
+				       xattr_value &&
+				       xattr_value->type == IMA_MODSIG &&
+				       ima_current_template_has_sig()))
 		ima_store_measurement(iint, file, pathname,
 				      xattr_value, xattr_len, pcr);
 	if (action & IMA_AUDIT)
diff --git a/security/integrity/ima/ima_modsig.c b/security/integrity/ima/ima_modsig.c
index 2786aa97060e..82c3e2693982 100644
--- a/security/integrity/ima/ima_modsig.c
+++ b/security/integrity/ima/ima_modsig.c
@@ -27,6 +27,10 @@ struct modsig_hdr {
 	const void *data;	/* Pointer to data covered by pkcs7_msg. */
 	size_t data_len;
 	struct pkcs7_message *pkcs7_msg;
+	int raw_pkcs7_len;
+
+	/* This will be in the measurement list if required by the template. */
+	struct evm_ima_xattr_data raw_pkcs7;
 };
 
 /**
@@ -86,7 +90,7 @@ int ima_read_modsig(enum ima_hooks func, const void *buf, loff_t buf_len,
 	sig_len = be32_to_cpu(sig->sig_len);
 	buf_len -= sig_len + sizeof(*sig);
 
-	hdr = kmalloc(sizeof(*hdr), GFP_KERNEL);
+	hdr = kmalloc(sizeof(*hdr) + sig_len, GFP_KERNEL);
 	if (!hdr)
 		return -ENOMEM;
 
@@ -97,6 +101,10 @@ int ima_read_modsig(enum ima_hooks func, const void *buf, loff_t buf_len,
 		return rc;
 	}
 
+	memcpy(hdr->raw_pkcs7.data, buf + buf_len, sig_len);
+	hdr->raw_pkcs7_len = sig_len + 1;
+	hdr->raw_pkcs7.type = IMA_MODSIG;
+
 	hdr->type = IMA_MODSIG;
 	hdr->data = buf;
 	hdr->data_len = buf_len;
@@ -129,6 +137,16 @@ int ima_get_modsig_hash(struct evm_ima_xattr_data *hdr, enum hash_algo *algo,
 	return 0;
 }
 
+int ima_modsig_serialize_data(struct evm_ima_xattr_data **data, int *data_len)
+{
+	struct modsig_hdr *modsig = (struct modsig_hdr *) *data;
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
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 3cc1d2763fd2..a5bad6996334 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -228,6 +228,18 @@ struct ima_template_desc *ima_template_desc_current(void)
 	return ima_template;
 }
 
+bool ima_current_template_has_sig(void)
+{
+	struct ima_template_desc *template = ima_template_desc_current();
+	int i;
+
+	for (i = 0; i < template->num_fields; i++)
+		if (!strcmp(template->fields[i]->field_id, "sig"))
+			return true;
+
+	return false;
+}
+
 int __init ima_init_template(void)
 {
 	struct ima_template_desc *template = ima_template_desc_current();
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index e8ec783b6a8d..d0e85def0ae9 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -379,10 +379,23 @@ int ima_eventsig_init(struct ima_event_data *event_data,
 		      struct ima_field_data *field_data)
 {
 	struct evm_ima_xattr_data *xattr_value = event_data->xattr_value;
+	int xattr_len = event_data->xattr_len;
 
-	if (!xattr_value || xattr_value->type != EVM_IMA_XATTR_DIGSIG)
+	if (!is_ima_sig(xattr_value))
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

