Received: from mail-gw02.astralinux.ru (mail-gw02.astralinux.ru [93.188.205.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526AA353A87;
	Sat, 22 Aug 2026 08:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.188.205.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787387982; cv=none; b=WaUSSnI4BWhlOKBEiq+CFOtgyGOq6W4wVPlbRoAm7xg8k3T2ltKVl+bEW8ponW6oVZ2D/RO33/QLZUOknCZd1UbqjZ8YsG1Wv31JCgxYtJcVG2/OziWafaD1WBUuSLi/RCnCAKMFCuXTSfv0jUAIEgdKplcSs7XtDDIr4PF3E18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787387982; c=relaxed/simple;
	bh=HrVxEiOBejm53deFYXKIx9wefhrq3PwoTak3ca3EqYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YW4EkHoSTq87fvuMxKvgDYQDDq7u3+uQkdMiS/i1RO1QguIB3IxwBzv8wHMxkEvbff7H7Wvv0pvDe7xoUjDtUHsd1SgWDIbZdhO8ndtePiGBBmtn9zGh3X4nEpIx4M73HroUea+p6VYDe3/TCj9H4zYmddVwU4oWtCRJSf+z1ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru; spf=pass smtp.mailfrom=astralinux.ru; dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b=0NH0PyyW; arc=none smtp.client-ip=93.188.205.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b="0NH0PyyW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1787387466;
	bh=HrVxEiOBejm53deFYXKIx9wefhrq3PwoTak3ca3EqYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0NH0PyyWK1xzw+gXLumcb3NNKkynlqbuA6FSajMAxpWlE7aPc/1ZaAOAldG1fJckZ
	 1e3IN2VLEQW+qTgR70gOroKncE+QIXcsMp95FGvSPF727ebDkbRGoIybhoyFJgZXNa
	 CP0KPX6lSSHk/Dn5Pj+ixmGVsxm8Y5YV9gKjuo4/ttT07EsmyAjSYu2wliA7qMpH/k
	 hsqw5hVyhjuPZN/jb6VU2B8nT0QW57O5g/W0e85LNYIOnksFtTiKs5Ywacg9xmEDPI
	 yLp/jPbcK2QZ69xmGsZo8/9QoAViMu/lsoq6ZOnqtACF18UjPUuzZ1vshuihhbj1fH
	 Fl0VknqoESoaw==
Received: from gca-msk-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw02.astralinux.ru (Postfix) with ESMTP id 181191F9C9;
	Sat, 22 Aug 2026 11:31:06 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw02.astralinux.ru (Postfix) with ESMTPS;
	Sat, 22 Aug 2026 11:31:05 +0300 (MSK)
Received: from astra.astra.ru (unknown [10.198.17.65])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4hRr3s3Y7FzrBb;
	Sat, 22 Aug 2026 11:31:05 +0300 (MSK)
From: Timofei Novikov <tnovikov@astralinux.ru>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Timofei Novikov <tnovikov@astralinux.ru>
Subject: [PATCH 3/3] x509: add CRL signature verification support
Date: Sat, 22 Aug 2026 11:26:42 +0300
Message-ID: <20260822082642.48936-4-tnovikov@astralinux.ru>
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

Verify the digital signature of Certificate Revocation Lists (CRLs)
before processing their entries.  Extract signature parameters via
x509_get_sig_params() and preserve the TBS data during parsing to
enable signature verification with verify_signature().

Add the keyring parameter to x509_load_crl_list() to specify which
keyring to use for CRL issuer lookup.  If no keyring is provided,
signature verification is skipped.

Signed-off-by: Timofei Novikov <tnovikov@astralinux.ru>
---
 crypto/asymmetric_keys/x509_cert_parser.c | 11 ++++++++
 crypto/asymmetric_keys/x509_crl.asn1      |  2 +-
 crypto/asymmetric_keys/x509_loader.c      | 31 ++++++++++++++++++++++-
 crypto/asymmetric_keys/x509_parser.h      |  2 +-
 include/keys/asymmetric-type.h            |  3 ++-
 5 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 76b61f36c082..39ef4cf4b05d 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -907,14 +907,24 @@ struct x509_crl_context *x509_crl_parse(const void *data, size_t datalen)
 	if (ret < 0)
 		return ERR_PTR(ret);
 
+	/*
+	 * Extract signature parameters (sig->s, sig->digest, etc.)
+	 * This does what we previously tried to do manually.
+	 */
+	ret = x509_get_sig_params(cert);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
 	/* Transfer parsed data to crl_context */
 	INIT_LIST_HEAD(&crl_ctx->revoked_list);
 	crl_ctx->indirect_crl = ctx->indirect_crl;
 	crl_ctx->raw_issuer = cert->raw_issuer;
 	crl_ctx->raw_issuer_size = cert->raw_issuer_size;
+	crl_ctx->sig = cert->sig;
 	list_splice(&ctx->revoked_list, &crl_ctx->revoked_list);
 
 	/* Detach pointers from cert before auto-free */
+	cert->sig = NULL;
 	cert->raw_issuer = NULL;
 	cert->raw_serial = NULL;
 
@@ -930,6 +940,7 @@ void x509_crl_free(struct x509_crl_context *ctx)
 		kfree(entry->serial);
 		kfree(entry);
 	}
+	public_key_signature_free(ctx->sig);
 	kfree(ctx);
 }
 
diff --git a/crypto/asymmetric_keys/x509_crl.asn1 b/crypto/asymmetric_keys/x509_crl.asn1
index 3ec8f5a32aca..910af624d828 100644
--- a/crypto/asymmetric_keys/x509_crl.asn1
+++ b/crypto/asymmetric_keys/x509_crl.asn1
@@ -16,7 +16,7 @@ TBSCertList ::= SEQUENCE {
 	nextUpdate		Time OPTIONAL ({ x509_note_not_after }) ,
 	revokedCertificates	SEQUENCE OF RevokedCertificate OPTIONAL,
 	crlExtensions		[ 0 ] Extensions OPTIONAL
-	}
+	} ({ x509_note_tbs_certificate })
 
 RevokedCertificate ::= SEQUENCE {
 	userCertificate		CertificateSerialNumber ({ crl_note_serial }),
diff --git a/crypto/asymmetric_keys/x509_loader.c b/crypto/asymmetric_keys/x509_loader.c
index 344e6bf31612..7c1a098b2ecb 100644
--- a/crypto/asymmetric_keys/x509_loader.c
+++ b/crypto/asymmetric_keys/x509_loader.c
@@ -6,6 +6,7 @@
 #include <keys/system_keyring.h>
 #include <linux/slab.h>
 #include <crypto/sha2.h>
+#include <crypto/public_key.h>
 #include "x509_parser.h"
 
 int x509_load_certificate_list(const u8 cert_list[],
@@ -74,7 +75,30 @@ static const void *crl_entry_issuer(const struct x509_crl_context *crl,
 	return crl->raw_issuer;
 }
 
-int x509_load_crl_list(const u8 crl_list[], const unsigned long list_size)
+static int x509_crl_verify_signature(struct x509_crl_context *crl_ctx,
+				     const struct key *keyring)
+{
+	struct key *key;
+	int ret = -ENOKEY;
+
+	if (!crl_ctx->raw_issuer || !crl_ctx->sig)
+		return -ENOKEY;
+
+	key = find_asymmetric_key(keyring,
+				  crl_ctx->sig->auth_ids[0],
+				  crl_ctx->sig->auth_ids[1],
+				  crl_ctx->sig->auth_ids[2],
+				  false);
+	if (IS_ERR(key))
+		return PTR_ERR(key);
+
+	ret = verify_signature(key, crl_ctx->sig);
+	key_put(key);
+	return ret;
+}
+
+int x509_load_crl_list(const u8 crl_list[], const unsigned long list_size,
+		       const struct key *keyring)
 {
 	const u8 *p = crl_list, *end = p + list_size;
 
@@ -107,6 +131,11 @@ int x509_load_crl_list(const u8 crl_list[], const unsigned long list_size)
 			pr_err("Problem parsing CRL (%ld)\n", PTR_ERR(crl_ctx));
 			goto next_crl;
 		}
+		if (keyring && x509_crl_verify_signature(crl_ctx, keyring) < 0) {
+			pr_warn("CRL signature verification failed, skipping\n");
+			x509_crl_free(crl_ctx);
+			goto next_crl;
+		}
 		list_for_each_entry_safe(entry, tmp, &crl_ctx->revoked_list, list) {
 			struct asymmetric_key_id *kid;
 			const void *issuer;
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index 13cc0bc3d7e2..7c48ccb1008c 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -49,9 +49,9 @@ struct x509_certificate {
 struct x509_crl_context {
 	const void *raw_issuer;
 	size_t raw_issuer_size;
+	struct public_key_signature *sig;
 	struct list_head revoked_list;
 	bool indirect_crl;
-	u8 crl_reason;
 };
 
 struct x509_revoked_entry {
diff --git a/include/keys/asymmetric-type.h b/include/keys/asymmetric-type.h
index 635644c8dcf1..db586a4c2981 100644
--- a/include/keys/asymmetric-type.h
+++ b/include/keys/asymmetric-type.h
@@ -87,7 +87,8 @@ extern struct key *find_asymmetric_key(struct key *keyring,
 int x509_load_certificate_list(const u8 cert_list[], const unsigned long list_size,
 			       const struct key *keyring);
 #ifdef CONFIG_SYSTEM_BLACKLIST_KEYRING
-int x509_load_crl_list(const u8 crl_list[], const unsigned long list_size);
+int x509_load_crl_list(const u8 crl_list[], const unsigned long list_size,
+		       const struct key *keyring);
 #endif
 
 /*
-- 
2.43.0

