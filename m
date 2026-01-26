Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9153423B61B
	for <linux-crypto@vger.kernel.org>; Mon, 26 Jan 2026 14:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769437803; cv=none; b=QoK1CFdj3DwIIpgr4fsDXqNAdix7MVWTS6dUrZG+ua1FkfGLOdugYQmRmiBgEjQ2vRilMPx0HfVoNfLDQL851mT1awHcLIWZ5qoM2ZV7rObDv1vK2sG5NsKxNqhrbghzACKiEaVqf/aIlVPBB/EaT9BIlerJpYeB+9iwam+cA5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769437803; c=relaxed/simple;
	bh=zWVGbSoeJSeylJFg4xuPPQw0S4v4e6q+ZujCzsynMak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5Xu1sG1NgyIHc/52I6U3kXWQDJzQcVTATJh8lL/+WsVFfh/aKG5br8BieZx83JxOp4ubLbjZ0Yg4CAAFRgdntnEp3fPzh07FOWuJhoke4ez1MiKyHwme+t9qBNdenRYOIirqYN0EDgYaQlEPFJ6nmtpKE9aT755HxMtFRpc3I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JUZMrokK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JUZMrokK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769437800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bq4OwZOcUv7PYvsl6dWJhmpDgkmBNkgX15y9m0yEJ7k=;
	b=JUZMrokKX3JWwuhEbRi7BeY/XML21m2IYLy6YK0t5SN8CU62ngUfAwM4Iw1Fv7QNe71S1v
	ZD68q5dE61UqS+fg+UQZUvh+Ce5YSx+LHggC8AXxtOlPK9DV9owrjsbqP1BiUcGeidsr3L
	LUg2Hhv/cbi1xKB2WOZaXV8sNGFypiE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-57-YSegEDuxMTCa3hefZMcbKA-1; Mon,
 26 Jan 2026 09:29:57 -0500
X-MC-Unique: YSegEDuxMTCa3hefZMcbKA-1
X-Mimecast-MFC-AGG-ID: YSegEDuxMTCa3hefZMcbKA_1769437795
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 37E651800365;
	Mon, 26 Jan 2026 14:29:55 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.44.33.164])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 382401956095;
	Mon, 26 Jan 2026 14:29:49 +0000 (UTC)
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
Subject: [PATCH v15 2/7] x509: Separately calculate sha256 for blacklist
Date: Mon, 26 Jan 2026 14:29:23 +0000
Message-ID: <20260126142931.1940586-3-dhowells@redhat.com>
In-Reply-To: <20260126142931.1940586-1-dhowells@redhat.com>
References: <20260126142931.1940586-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Calculate the SHA256 hash for blacklisting purposes independently of the
signature hash (which may be something other than SHA256).

This is necessary because when ML-DSA is used, no digest is calculated.

Note that this represents a change of behaviour in that the hash used for
the blacklist check would previously have been whatever digest was used
for, say, RSA-based signatures.  It may be that this is inadvisable.

Signed-off-by: David Howells <dhowells@redhat.com>
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

