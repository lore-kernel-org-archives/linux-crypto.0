Received: from mail-gw02.astralinux.ru (mail-gw02.astralinux.ru [93.188.205.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52735356741;
	Sat, 22 Aug 2026 08:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.188.205.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787387982; cv=none; b=IsDoSbJH64ii76AvBZ5urE/p8AAVJpn+jA9XaoghT5XoC8PctRv/pM5ChKAOlGEpuno8fCgomyJk18mHnBJ6EV10J4BC/xzCJSy3IULS3Kw+wllISPRMaOD4RTPmu3Tf5K7F8N+gGUWFNrnPzV2cSuygGsxFXOf7nWhQ8pRDVHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787387982; c=relaxed/simple;
	bh=GOqJZVXezJLkMC+IR6QwE6Qumte1UfZRsXtHWm7AbqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LAapTbXQLi25jxW7/T2VhknIoqKictHzzrfMa+NCc16EvkCLhaMYT/NTLHhCwtAH6tEbah8SJcQ/qeXnKv6LrsuVfK1K4v2gGY2gvBd0tFYghzN7lxEwfnMXoK0l7TWfLa9wiZUdSs4ZeIAZ1Ct0iIlS4CicX16oRdyHj1bi8NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru; spf=pass smtp.mailfrom=astralinux.ru; dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b=Nutcs9fs; arc=none smtp.client-ip=93.188.205.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b="Nutcs9fs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1787387463;
	bh=GOqJZVXezJLkMC+IR6QwE6Qumte1UfZRsXtHWm7AbqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nutcs9fsOjJDCxsVz4eoEqRjWa3Fbh0Y5fgr5ug+IhQ7C/OimI57qplAHrM18L/VS
	 qPoaQ3gttY01VZUyByk1SN3WLglpxEF5ZXVk2qxjNnTGKn4JnmgX03zQj0MXXNSCIZ
	 3RzuiYa7NhYlG3C3zau1Q7kiK2IdALLCqrtPmQR1/P+kdqa/LaevAtMzNFInUGnKVO
	 7G0X6/BCMp67TXIolqZjLxd1pCCTdZYdTitxHAztjRVlQKjJ/bn9y8wCZUHtQWV8nP
	 HwcKANRsVeR52C870CgTDptNGD6ZejA6jexxNP2wsyIwCX+7FIWIfZC6U4FD0Mx5QU
	 HDuL2e2vLlQEw==
Received: from gca-msk-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw02.astralinux.ru (Postfix) with ESMTP id D104F1F740;
	Sat, 22 Aug 2026 11:31:03 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw02.astralinux.ru (Postfix) with ESMTPS;
	Sat, 22 Aug 2026 11:31:03 +0300 (MSK)
Received: from astra.astra.ru (unknown [10.198.17.65])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4hRr3q1SpVzrBR;
	Sat, 22 Aug 2026 11:31:03 +0300 (MSK)
From: Timofei Novikov <tnovikov@astralinux.ru>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Timofei Novikov <tnovikov@astralinux.ru>
Subject: [PATCH 2/3] x509: add CRL parser with indirect CRL support
Date: Sat, 22 Aug 2026 11:26:41 +0300
Message-ID: <20260822082642.48936-3-tnovikov@astralinux.ru>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260822082642.48936-1-tnovikov@astralinux.ru>
References: <20260822082642.48936-1-tnovikov@astralinux.ru>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: tnovikov@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 116 0.3.116 e16f906af7c720a8bd440e8c76eb19faffaac9ce, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;astralinux.ru:7.1.1;new-mail.astralinux.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 205480 [Aug 21 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.27
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/08/22 08:00:00 #28528350
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1

Implement X.509 Certificate Revocation List (CRL) parsing according to
RFC 5280.  The parser extracts the issuer and list of revoked
certificates, then blacklists them using a hash of the certificate's
serial number and issuer name.

Support indirect CRLs by parsing the Issuing Distribution Point (IDP)
extension to detect the indirectCRL flag, and the Certificate Issuer
extension on CRL entries to obtain the per-entry issuer.  For indirect
CRLs, the entry-specific issuer is used for blacklisting; for regular
CRLs, the CRL issuer is used.

Add new OIDs for issuingDistributionPoint (2.5.29.28),
certificateIssuer (2.5.29.29), and cRLReason (2.5.29.21).

The CRL is loaded via the blacklist keyring with a "crl:" prefix,
similar to "tbs:" and "bin:" prefixes for other blacklist types.

Signed-off-by: Timofei Novikov <tnovikov@astralinux.ru>
---
 certs/blacklist.c                         |  17 ++-
 crypto/asymmetric_keys/Makefile           |   8 +-
 crypto/asymmetric_keys/x509_cert_parser.c | 121 ++++++++++++++++++++++
 crypto/asymmetric_keys/x509_crl.asn1      |  59 +++++++++++
 crypto/asymmetric_keys/x509_idp.asn1      |  12 +++
 crypto/asymmetric_keys/x509_loader.c      |  84 +++++++++++++++
 crypto/asymmetric_keys/x509_parser.h      |  18 ++++
 crypto/asymmetric_keys/x509_public_key.c  |  21 ++++
 include/keys/asymmetric-type.h            |   3 +
 include/keys/system_keyring.h             |   2 +
 include/linux/oid_registry.h              |   4 +
 11 files changed, 343 insertions(+), 6 deletions(-)
 create mode 100644 crypto/asymmetric_keys/x509_crl.asn1
 create mode 100644 crypto/asymmetric_keys/x509_idp.asn1

diff --git a/certs/blacklist.c b/certs/blacklist.c
index fa561c12eabf..7c61e4014527 100644
--- a/certs/blacklist.c
+++ b/certs/blacklist.c
@@ -32,6 +32,7 @@
 
 static const char tbs_prefix[] = "tbs";
 static const char bin_prefix[] = "bin";
+static const char crl_prefix[] = "crl";
 
 static struct key *blacklist_keyring;
 
@@ -46,16 +47,16 @@ extern __initconst const unsigned long revocation_certificate_list_size;
  */
 static int blacklist_vet_description(const char *desc)
 {
-	int i, prefix_len, tbs_step = 0, bin_step = 0;
+	int i, prefix_len, tbs_step = 0, bin_step = 0, crl_step = 0;
 
 	/* The following algorithm only works if prefix lengths match. */
-	BUILD_BUG_ON(sizeof(tbs_prefix) != sizeof(bin_prefix));
+	BUILD_BUG_ON(sizeof(tbs_prefix) != sizeof(bin_prefix) ||
+		     sizeof(tbs_prefix) != sizeof(crl_prefix));
 	prefix_len = sizeof(tbs_prefix) - 1;
 	for (i = 0; *desc; desc++, i++) {
 		if (*desc == ':') {
-			if (tbs_step == prefix_len)
-				goto found_colon;
-			if (bin_step == prefix_len)
+			if (tbs_step == prefix_len || bin_step == prefix_len ||
+			    crl_step == prefix_len)
 				goto found_colon;
 			return -EINVAL;
 		}
@@ -65,6 +66,8 @@ static int blacklist_vet_description(const char *desc)
 			tbs_step++;
 		if (*desc == bin_prefix[i])
 			bin_step++;
+		if (*desc == crl_prefix[i])
+			crl_step++;
 	}
 	return -EINVAL;
 
@@ -160,6 +163,10 @@ static char *get_raw_hash(const u8 *hash, size_t hash_len,
 		type_len = sizeof(bin_prefix) - 1;
 		type_prefix = bin_prefix;
 		break;
+	case BLACKLIST_HASH_X509_CRL:
+		type_len = sizeof(crl_prefix) - 1;
+		type_prefix = crl_prefix;
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		return ERR_PTR(-EINVAL);
diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index bc65d3b98dcb..007615ebf200 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -19,6 +19,8 @@ obj-$(CONFIG_X509_CERTIFICATE_PARSER) += x509_key_parser.o
 x509_key_parser-y := \
 	x509.asn1.o \
 	x509_akid.asn1.o \
+	x509_crl.asn1.o \
+	x509_idp.asn1.o \
 	x509_cert_parser.o \
 	x509_loader.o \
 	x509_public_key.o
@@ -29,10 +31,14 @@ x509_selftest-$(CONFIG_FIPS_SIGNATURE_SELFTEST_ECDSA) += selftest_ecdsa.o
 
 $(obj)/x509_cert_parser.o: \
 	$(obj)/x509.asn1.h \
-	$(obj)/x509_akid.asn1.h
+	$(obj)/x509_akid.asn1.h \
+	$(obj)/x509_crl.asn1.h \
+	$(obj)/x509_idp.asn1.h
 
 $(obj)/x509.asn1.o: $(obj)/x509.asn1.c $(obj)/x509.asn1.h
 $(obj)/x509_akid.asn1.o: $(obj)/x509_akid.asn1.c $(obj)/x509_akid.asn1.h
+$(obj)/x509_crl.asn1.o: $(obj)/x509_crl.asn1.c $(obj)/x509_crl.asn1.h
+$(obj)/x509_idp.asn1.o: $(obj)/x509_idp.asn1.c $(obj)/x509_idp.asn1.h
 
 #
 # PKCS#8 private key handling
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index bfd10f0195e0..76b61f36c082 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -15,6 +15,8 @@
 #include "x509_parser.h"
 #include "x509.asn1.h"
 #include "x509_akid.asn1.h"
+#include "x509_crl.asn1.h"
+#include "x509_idp.asn1.h"
 
 struct x509_parse_context {
 	struct x509_certificate	*cert;		/* Certificate being constructed */
@@ -36,6 +38,10 @@ struct x509_parse_context {
 	const void	*raw_akid;		/* Raw authorityKeyId in ASN.1 */
 	const void	*akid_raw_issuer;	/* Raw directoryName in authorityKeyId */
 	unsigned	akid_raw_issuer_size;
+	bool		is_crl;			/* true if parsing CRL */
+	bool		indirect_crl;		/* true if indirect CRL */
+	struct list_head revoked_list;		/* list of revoked serials */
+	u8		crl_reason;		/* CRL reason code */
 };
 
 /*
@@ -574,6 +580,7 @@ int x509_process_extension(void *context, size_t hdrlen,
 	struct x509_parse_context *ctx = context;
 	struct asymmetric_key_id *kid;
 	const unsigned char *v = value;
+	int ret;
 
 	pr_debug("Extension: %u\n", ctx->last_oid);
 
@@ -661,6 +668,32 @@ int x509_process_extension(void *context, size_t hdrlen,
 		return 0;
 	}
 
+	/* CRL-specific extensions */
+	if (ctx->last_oid == OID_id_ce_issuingDistributionPoint) {
+		/* Decode IssuingDistributionPoint */
+		ret = asn1_ber_decoder(&x509_idp_decoder, ctx, v, vlen);
+		return ret < 0 ? ret : 0;
+	}
+
+	if (ctx->last_oid == OID_id_ce_certificateIssuer) {
+		struct x509_revoked_entry *entry;
+
+		if (ctx->is_crl && !list_empty(&ctx->revoked_list)) {
+			entry = list_last_entry(&ctx->revoked_list,
+					struct x509_revoked_entry, list);
+			entry->raw_issuer = v;
+			entry->raw_issuer_size = vlen;
+		}
+		return 0;
+	}
+
+	if (ctx->last_oid == OID_id_ce_cRLReason) {
+		/* CRLReason: ENUMERATED (tag 0x0a, len 1) */
+		if (vlen >= 3 && v[0] == 0x0a && v[1] == 1)
+			ctx->crl_reason = v[2];
+		return 0;
+	}
+
 	return 0;
 }
 
@@ -840,3 +873,91 @@ int x509_akid_note_serial(void *context, size_t hdrlen,
 	ctx->cert->sig->auth_ids[0] = kid;
 	return 0;
 }
+
+struct x509_crl_context *x509_crl_parse(const void *data, size_t datalen)
+{
+	struct x509_crl_context *crl_ctx __free(kfree) = NULL;
+	struct x509_parse_context *ctx __free(kfree) = NULL;
+	struct x509_certificate *cert __free(x509_free_certificate) = NULL;
+	int ret;
+
+	crl_ctx = kzalloc_obj(struct x509_crl_context);
+	if (!crl_ctx)
+		return ERR_PTR(-ENOMEM);
+
+	cert = kzalloc_obj(struct x509_certificate);
+	if (!cert)
+		return ERR_PTR(-ENOMEM);
+
+	cert->pub = kzalloc_obj(struct public_key);
+	cert->sig = kzalloc_obj(struct public_key_signature);
+	if (!cert->pub || !cert->sig)
+		return ERR_PTR(-ENOMEM);
+
+	ctx = kzalloc_obj(struct x509_parse_context);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+
+	ctx->cert = cert;
+	ctx->is_crl = true;
+	ctx->data = (unsigned long)data;
+	INIT_LIST_HEAD(&ctx->revoked_list);
+
+	ret = asn1_ber_decoder(&x509_crl_decoder, ctx, data, datalen);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	/* Transfer parsed data to crl_context */
+	INIT_LIST_HEAD(&crl_ctx->revoked_list);
+	crl_ctx->indirect_crl = ctx->indirect_crl;
+	crl_ctx->raw_issuer = cert->raw_issuer;
+	crl_ctx->raw_issuer_size = cert->raw_issuer_size;
+	list_splice(&ctx->revoked_list, &crl_ctx->revoked_list);
+
+	/* Detach pointers from cert before auto-free */
+	cert->raw_issuer = NULL;
+	cert->raw_serial = NULL;
+
+	return_ptr(crl_ctx);
+}
+
+void x509_crl_free(struct x509_crl_context *ctx)
+{
+	struct x509_revoked_entry *entry, *tmp;
+
+	list_for_each_entry_safe(entry, tmp, &ctx->revoked_list, list) {
+		list_del(&entry->list);
+		kfree(entry->serial);
+		kfree(entry);
+	}
+	kfree(ctx);
+}
+
+int x509_note_indirect_crl(void *context, size_t hdrlen, unsigned char tag,
+			   const void *value, size_t vlen)
+{
+	struct x509_parse_context *ctx = context;
+
+	if (vlen == 1 && *(const u8 *)value == 0xFF)
+		ctx->indirect_crl = true;
+	return 0;
+}
+
+int crl_note_serial(void *context, size_t hdrlen, unsigned char tag,
+		    const void *value, size_t vlen)
+{
+	struct x509_parse_context *ctx = context;
+	struct x509_revoked_entry *entry;
+
+	entry = kzalloc_obj(struct x509_revoked_entry);
+	if (!entry)
+		return -ENOMEM;
+	entry->serial = kmemdup(value, vlen, GFP_KERNEL);
+	if (!entry->serial) {
+		kfree(entry);
+		return -ENOMEM;
+	}
+	entry->serial_size = vlen;
+	list_add_tail(&entry->list, &ctx->revoked_list);
+	return 0;
+}
diff --git a/crypto/asymmetric_keys/x509_crl.asn1 b/crypto/asymmetric_keys/x509_crl.asn1
new file mode 100644
index 000000000000..3ec8f5a32aca
--- /dev/null
+++ b/crypto/asymmetric_keys/x509_crl.asn1
@@ -0,0 +1,59 @@
+--
+-- X.509 CRL (RFC 5280, section 5.1)
+--
+
+CertificateList ::= SEQUENCE {
+	tbsCertList		TBSCertList,
+	signatureAlgorithm	AlgorithmIdentifier,
+	signature		BIT STRING ({ x509_note_signature })
+	}
+
+TBSCertList ::= SEQUENCE {
+	version			Version OPTIONAL,
+	signature		AlgorithmIdentifier ({ x509_note_sig_algo }),
+	issuer			Name ({ x509_note_issuer }),
+	thisUpdate		Time ({ x509_note_not_before }),
+	nextUpdate		Time OPTIONAL ({ x509_note_not_after }) ,
+	revokedCertificates	SEQUENCE OF RevokedCertificate OPTIONAL,
+	crlExtensions		[ 0 ] Extensions OPTIONAL
+	}
+
+RevokedCertificate ::= SEQUENCE {
+	userCertificate		CertificateSerialNumber ({ crl_note_serial }),
+	revocationDate		Time,
+	crlEntryExtensions	Extensions OPTIONAL
+	}
+
+--
+-- Primitives and common types
+--
+
+Version ::= INTEGER
+CertificateSerialNumber ::= INTEGER
+
+AlgorithmIdentifier ::= SEQUENCE {
+	algorithm		OBJECT IDENTIFIER ({ x509_note_OID }),
+	parameters		ANY OPTIONAL ({ x509_note_params })
+}
+
+Name ::= SEQUENCE OF RelativeDistinguishedName
+
+RelativeDistinguishedName ::= SET OF AttributeValueAssertion
+
+AttributeValueAssertion ::= SEQUENCE {
+	attributeType		OBJECT IDENTIFIER ({ x509_note_OID }),
+	attributeValue		ANY ({ x509_extract_name_segment })
+}
+
+Time ::= CHOICE {
+	utcTime			UTCTime,
+	generalTime		GeneralizedTime
+}
+
+Extensions ::= SEQUENCE OF Extension
+
+Extension ::= SEQUENCE {
+	extnid			OBJECT IDENTIFIER ({ x509_note_OID }),
+	critical		BOOLEAN DEFAULT,
+	extnValue		OCTET STRING ({ x509_process_extension })
+	}
diff --git a/crypto/asymmetric_keys/x509_idp.asn1 b/crypto/asymmetric_keys/x509_idp.asn1
new file mode 100644
index 000000000000..204556bc8449
--- /dev/null
+++ b/crypto/asymmetric_keys/x509_idp.asn1
@@ -0,0 +1,12 @@
+--
+-- Issuing Distribution Point (RFC 5280, section 5.2.5)
+--
+
+IssuingDistributionPoint ::= SEQUENCE {
+	distributionPoint	[0] ANY OPTIONAL,
+	onlyContainsUserCerts	[1] IMPLICIT BOOLEAN OPTIONAL,
+	onlyContainsCACerts	[2] IMPLICIT BOOLEAN OPTIONAL,
+	onlySomeReasons		[3] IMPLICIT BIT STRING OPTIONAL,
+	indirectCRL		[4] IMPLICIT BOOLEAN OPTIONAL ({ x509_note_indirect_crl }),
+	onlyContainsAttributeCerts [5] IMPLICIT BOOLEAN OPTIONAL
+	}
diff --git a/crypto/asymmetric_keys/x509_loader.c b/crypto/asymmetric_keys/x509_loader.c
index 0d516c77cc26..344e6bf31612 100644
--- a/crypto/asymmetric_keys/x509_loader.c
+++ b/crypto/asymmetric_keys/x509_loader.c
@@ -3,6 +3,10 @@
 #include <linux/kernel.h>
 #include <linux/key.h>
 #include <keys/asymmetric-type.h>
+#include <keys/system_keyring.h>
+#include <linux/slab.h>
+#include <crypto/sha2.h>
+#include "x509_parser.h"
 
 int x509_load_certificate_list(const u8 cert_list[],
 			       const unsigned long list_size,
@@ -56,3 +60,83 @@ int x509_load_certificate_list(const u8 cert_list[],
 	return 0;
 }
 EXPORT_SYMBOL_GPL(x509_load_certificate_list);
+
+#ifdef CONFIG_SYSTEM_BLACKLIST_KEYRING
+static const void *crl_entry_issuer(const struct x509_crl_context *crl,
+				    const struct x509_revoked_entry *entry,
+				    size_t *size)
+{
+	if (crl->indirect_crl && entry->raw_issuer) {
+		*size = entry->raw_issuer_size;
+		return entry->raw_issuer;
+	}
+	*size = crl->raw_issuer_size;
+	return crl->raw_issuer;
+}
+
+int x509_load_crl_list(const u8 crl_list[], const unsigned long list_size)
+{
+	const u8 *p = crl_list, *end = p + list_size;
+
+	while (p < end) {
+		size_t plen;
+		struct x509_crl_context *crl_ctx;
+		struct x509_revoked_entry *entry, *tmp;
+
+		/* Need at least: tag(1) + length(1) = 2 bytes */
+		if (end - p < 2 || p[0] != 0x30)
+			goto dodgy_crl;
+
+		if (p[1] == 0x82) {
+			if (end - p < 4)
+				goto dodgy_crl;
+			plen = ((p[2] << 8) | p[3]) + 4;
+		} else if (p[1] == 0x81) {
+			if (end - p < 3)
+				goto dodgy_crl;
+			plen = p[2] + 3;
+		} else {
+			goto dodgy_crl;
+		}
+
+		if (plen > end - p)
+			goto dodgy_crl;
+
+		crl_ctx = x509_crl_parse(p, plen);
+		if (IS_ERR(crl_ctx)) {
+			pr_err("Problem parsing CRL (%ld)\n", PTR_ERR(crl_ctx));
+			goto next_crl;
+		}
+		list_for_each_entry_safe(entry, tmp, &crl_ctx->revoked_list, list) {
+			struct asymmetric_key_id *kid;
+			const void *issuer;
+			size_t issuer_size;
+
+			issuer = crl_entry_issuer(crl_ctx, entry, &issuer_size);
+			kid = asymmetric_key_generate_id(entry->serial,
+							 entry->serial_size,
+							 issuer, issuer_size);
+			if (!IS_ERR(kid)) {
+				u8 digest[SHA256_DIGEST_SIZE];
+
+				sha256(kid->data, kid->len, digest);
+				mark_hash_blacklisted(digest, SHA256_DIGEST_SIZE,
+						      BLACKLIST_HASH_X509_CRL);
+				kfree(kid);
+			}
+			list_del(&entry->list);
+			kfree(entry->serial);
+			kfree(entry);
+		}
+		x509_crl_free(crl_ctx);
+next_crl:
+		p += plen;
+	}
+	return 0;
+
+dodgy_crl:
+	pr_err("Problem parsing CRL list\n");
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(x509_load_crl_list);
+#endif
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index b7aeebdddb36..13cc0bc3d7e2 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -46,6 +46,22 @@ struct x509_certificate {
 /*
  * x509_cert_parser.c
  */
+struct x509_crl_context {
+	const void *raw_issuer;
+	size_t raw_issuer_size;
+	struct list_head revoked_list;
+	bool indirect_crl;
+	u8 crl_reason;
+};
+
+struct x509_revoked_entry {
+	struct list_head list;
+	u8 *serial;
+	size_t serial_size;
+	const void *raw_issuer;      /* for indirect */
+	size_t raw_issuer_size;
+};
+
 extern void x509_free_certificate(struct x509_certificate *cert);
 DEFINE_FREE(x509_free_certificate, struct x509_certificate *,
 	    if (!IS_ERR(_T)) x509_free_certificate(_T))
@@ -53,6 +69,8 @@ extern struct x509_certificate *x509_cert_parse(const void *data, size_t datalen
 extern int x509_decode_time(time64_t *_t,  size_t hdrlen,
 			    unsigned char tag,
 			    const unsigned char *value, size_t vlen);
+struct x509_crl_context *x509_crl_parse(const void *data, size_t datalen);
+void x509_crl_free(struct x509_crl_context *ctx);
 
 /*
  * x509_public_key.c
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 25cf8ac7f257..598b94455b8d 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <crypto/sha2.h>
 #include "asymmetric_keys.h"
 #include "x509_parser.h"
 
@@ -90,6 +91,26 @@ int x509_get_sig_params(struct x509_certificate *cert)
 	if (ret < 0)
 		goto error_2;
 
+	/* Check CRL blacklist (hash of serial + issuer) */
+	if (!cert->blacklisted && cert->raw_serial && cert->raw_issuer) {
+		struct asymmetric_key_id *kid;
+
+		kid = asymmetric_key_generate_id(cert->raw_serial, cert->raw_serial_size,
+						 cert->raw_issuer, cert->raw_issuer_size);
+		if (!IS_ERR(kid)) {
+			u8 digest[SHA256_DIGEST_SIZE];
+
+			sha256(kid->data, kid->len, digest);
+			ret = is_hash_blacklisted(digest, SHA256_DIGEST_SIZE,
+						  BLACKLIST_HASH_X509_CRL);
+			if (ret == -EKEYREJECTED) {
+				pr_err("Cert is CRL-blacklisted\n");
+				cert->blacklisted = true;
+			}
+			kfree(kid);
+		}
+	}
+
 error_2:
 	kfree(desc);
 error:
diff --git a/include/keys/asymmetric-type.h b/include/keys/asymmetric-type.h
index 1b91c8f98688..635644c8dcf1 100644
--- a/include/keys/asymmetric-type.h
+++ b/include/keys/asymmetric-type.h
@@ -86,6 +86,9 @@ extern struct key *find_asymmetric_key(struct key *keyring,
 
 int x509_load_certificate_list(const u8 cert_list[], const unsigned long list_size,
 			       const struct key *keyring);
+#ifdef CONFIG_SYSTEM_BLACKLIST_KEYRING
+int x509_load_crl_list(const u8 crl_list[], const unsigned long list_size);
+#endif
 
 /*
  * The payload is at the discretion of the subtype.
diff --git a/include/keys/system_keyring.h b/include/keys/system_keyring.h
index a6c2897bcc63..01f832160e27 100644
--- a/include/keys/system_keyring.h
+++ b/include/keys/system_keyring.h
@@ -15,6 +15,8 @@ enum blacklist_hash_type {
 	BLACKLIST_HASH_X509_TBS = 1,
 	/* Raw data hash */
 	BLACKLIST_HASH_BINARY = 2,
+	/* Hash = serial + issuer */
+	BLACKLIST_HASH_X509_CRL = 3,
 };
 
 #ifdef CONFIG_SYSTEM_TRUSTED_KEYRING
diff --git a/include/linux/oid_registry.h b/include/linux/oid_registry.h
index ebce402854de..d63be17387d3 100644
--- a/include/linux/oid_registry.h
+++ b/include/linux/oid_registry.h
@@ -150,6 +150,10 @@ enum OID {
 	OID_id_ml_dsa_65,			/* 2.16.840.1.101.3.4.3.18 */
 	OID_id_ml_dsa_87,			/* 2.16.840.1.101.3.4.3.19 */
 
+	OID_id_ce_issuingDistributionPoint,	/* 2.5.29.28 */
+	OID_id_ce_certificateIssuer,		/* 2.5.29.29 */
+	OID_id_ce_cRLReason,			/* 2.5.29.21 */
+
 	OID__NR
 };
 
-- 
2.43.0

