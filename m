Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D38D3815D3
	for <linux-crypto@vger.kernel.org>; Mon,  2 Feb 2026 17:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770051768; cv=none; b=B2rBUkX1u1tsMz3/ceckaeIiXHxYAKwgmkl+ZOys5ByuKj85HX0FdtqtTb/Wd1CtWcEBAPIwWxo4YgPvN7Jtm+y4m0AIt87ZluTZW9+MfO1gk7dFhc8lHWiYNBIhAIVsnAuE2AasslzsD37yIlqoC9q4fztMveQE4vVSijABCjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770051768; c=relaxed/simple;
	bh=2e9SH7J4BWQiTO5bhBJRbINXA5Y+RUH8hrW83p9106E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pncPKv7lCuXoOPyGOwjYeVewTZgYZz9OgsiR/dd+SjwtK/dCbVWiE1H+vSCAcxZYxa7S4o/CihHDc2w5oDqDFRejtNse9t+w2r0brXapAZ3Is8DIdO8FiU9bCO5DfEgjxIgv/O4uRJriVhGe3mV2x7LVFV6/Xn2DSYEGFSaOXcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QVdsj9v9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QVdsj9v9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770051766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o/2GlCgZLrpUqq5D1yRzHDnrzr+MKF5Tesne7omct6g=;
	b=QVdsj9v95MtxQDvnsFPVotQaXMZEtXQYSCBKc6D9JMisbUz4JGCPnxY/rJXdpmN0C0MRj+
	XFodDD7b3qGdO56Jxc8UNL4mpv1T4qrU4j4Axj36GkimGko99kWIugw2sO3wldR5htvi27
	tL+WlxHtJCMi2flHPcIt8RcdQf7kuSo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-19-URFNfZZXOeSd8jiflZS4Vg-1; Mon,
 02 Feb 2026 12:02:41 -0500
X-MC-Unique: URFNfZZXOeSd8jiflZS4Vg-1
X-Mimecast-MFC-AGG-ID: URFNfZZXOeSd8jiflZS4Vg_1770051759
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A620A18002F1;
	Mon,  2 Feb 2026 17:02:38 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.44.33.164])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5B8A418008FF;
	Mon,  2 Feb 2026 17:02:33 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@cloudflare.com>
Cc: David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Stephan Mueller <smueller@chronox.de>,
	linux-crypto@vger.kernel.org,
	keyrings@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v16 2/7] x509: Separately calculate sha256 for blacklist
Date: Mon,  2 Feb 2026 17:02:07 +0000
Message-ID: <20260202170216.2467036-3-dhowells@redhat.com>
In-Reply-To: <20260202170216.2467036-1-dhowells@redhat.com>
References: <20260202170216.2467036-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Calculate the SHA256 hash for blacklisting purposes independently of the
signature hash (which may be something other than SHA256).

This is necessary because when ML-DSA is used, no digest is calculated.

Note that this represents a change of behaviour in that the hash used for
the blacklist check would previously have been whatever digest was used
for, say, RSA-based signatures.  It may be that this is inadvisable.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
cc: Lukas Wunner <lukas@wunner.de>
cc: Ignat Korchagin <ignat@cloudflare.com>
cc: Stephan Mueller <smueller@chronox.de>
cc: Eric Biggers <ebiggers@kernel.org>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: keyrings@vger.kernel.org
cc: linux-crypto@vger.kernel.org
---
 crypto/asymmetric_keys/x509_parser.h     |  2 ++
 crypto/asymmetric_keys/x509_public_key.c | 22 +++++++++++++---------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index 0688c222806b..b7aeebdddb36 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -9,12 +9,14 @@
 #include <linux/time.h>
 #include <crypto/public_key.h>
 #include <keys/asymmetric-type.h>
+#include <crypto/sha2.h>
 
 struct x509_certificate {
 	struct x509_certificate *next;
 	struct x509_certificate *signer;	/* Certificate that signed this one */
 	struct public_key *pub;			/* Public key details */
 	struct public_key_signature *sig;	/* Signature parameters */
+	u8		sha256[SHA256_DIGEST_SIZE]; /* Hash for blacklist purposes */
 	char		*issuer;		/* Name of certificate issuer */
 	char		*subject;		/* Name of certificate subject */
 	struct asymmetric_key_id *id;		/* Issuer + Serial number */
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 12e3341e806b..79cc7b7a0630 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -31,6 +31,19 @@ int x509_get_sig_params(struct x509_certificate *cert)
 
 	pr_devel("==>%s()\n", __func__);
 
+	/* Calculate a SHA256 hash of the TBS and check it against the
+	 * blacklist.
+	 */
+	sha256(cert->tbs, cert->tbs_size, cert->sha256);
+	ret = is_hash_blacklisted(cert->sha256, sizeof(cert->sha256),
+				  BLACKLIST_HASH_X509_TBS);
+	if (ret == -EKEYREJECTED) {
+		pr_err("Cert %*phN is blacklisted\n",
+		       (int)sizeof(cert->sha256), cert->sha256);
+		cert->blacklisted = true;
+		ret = 0;
+	}
+
 	sig->s = kmemdup(cert->raw_sig, cert->raw_sig_size, GFP_KERNEL);
 	if (!sig->s)
 		return -ENOMEM;
@@ -69,15 +82,6 @@ int x509_get_sig_params(struct x509_certificate *cert)
 	if (ret < 0)
 		goto error_2;
 
-	ret = is_hash_blacklisted(sig->digest, sig->digest_size,
-				  BLACKLIST_HASH_X509_TBS);
-	if (ret == -EKEYREJECTED) {
-		pr_err("Cert %*phN is blacklisted\n",
-		       sig->digest_size, sig->digest);
-		cert->blacklisted = true;
-		ret = 0;
-	}
-
 error_2:
 	kfree(desc);
 error:

