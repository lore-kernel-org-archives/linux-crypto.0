Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1369A336EC7
	for <linux-crypto@vger.kernel.org>; Fri, 17 Oct 2025 14:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760712298; cv=none; b=KIEP9e1msLqHQX3n6fCtpi0CbRLcDfAaBtL7Nd7soLIR3kV2tt0D4Bg+qYhhTION748MfMds2gaOLE/TaGW493AJGTGyLV3/E4J6tXnXNu+keYmFZQEdjQYyeljH4mzxQb91Ve5VvKlAYNiDrvhHvb2vrG3HHtORbC5fPv9RY/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760712298; c=relaxed/simple;
	bh=UJ0JNuAjO4bhNUyDJJTmWDirBsmcCcvUnyXrgyxFwC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZ+bO0u4n15d7A/0PWFDJThHLVxYGXlSTAdYwsQ6zmS45myMzt2haKXA+MDdNKaGqn/l3HtUqZNRAjjAcMBNJPpmFBSEYzBSJ0cevP4wvFq1NJPSJY4yBKfFOTlWdVsIrOm4kOU/Oy6fmq6D1ftoC4Pcwfr7oQVp2h+zMSwaJyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TMYi1fdS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TMYi1fdS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760712295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LPY+GhOJq5nNgZrUBrGTmZ1jrCpWP/ToTTWyLrp7aIg=;
	b=TMYi1fdS6MRbuSfB5P79Xer3ILHtIVLTgVyojjRd6pFaL0NDeB81tOzTxeTkHeb7fGKHfo
	t5J+boiyRxHeApRQojULndOd7lL6L7STm1ZyR18n5ukIueHMrFxDD6PqkdFtsfjB9s9Kon
	Rsj1bVKASOepl8JzuqUDr7gJh9wlr6I=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-508-XW_wST_qN0-uNRK2-35BQQ-1; Fri,
 17 Oct 2025 10:44:46 -0400
X-MC-Unique: XW_wST_qN0-uNRK2-35BQQ-1
X-Mimecast-MFC-AGG-ID: XW_wST_qN0-uNRK2-35BQQ_1760712283
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9DC0119560B5;
	Fri, 17 Oct 2025 14:44:43 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.57])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2888D1800446;
	Fri, 17 Oct 2025 14:44:39 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Howells <dhowells@redhat.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@cloudflare.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	linux-crypto@vger.kernel.org,
	keyrings@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 15/17] pkcs7: Allow the signing algo to calculate the digest itself
Date: Fri, 17 Oct 2025 15:42:59 +0100
Message-ID: <20251017144311.817771-16-dhowells@redhat.com>
In-Reply-To: <20251017144311.817771-1-dhowells@redhat.com>
References: <20251017144311.817771-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

The ML-DSA public key algorithm really wants to calculate the message
digest itself, rather than having the digest precalculated and fed to it
separately as RSA does[*].  The kernel's PKCS#7 parser, however, is
designed around the latter approach.

  [*] ML-DSA does allow for an "external mu", but CMS doesn't yet have that
  standardised.

Fix this by noting in the public_key_signature struct when the signing
algorithm is going to want this and then, rather than doing the digest of
the authenticatedAttributes ourselves and overwriting the sig->digest with
that, replace sig->digest with a copy of the contents of the
authenticatedAttributes section and adjust the digest length to match.

This will then be fed to the public key algorithm as normal which can do
what it wants with the data.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Lukas Wunner <lukas@wunner.de>
cc: Ignat Korchagin <ignat@cloudflare.com>
cc: Stephan Mueller <smueller@chronox.de>
cc: Eric Biggers <ebiggers@kernel.org>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: keyrings@vger.kernel.org
cc: linux-crypto@vger.kernel.org
---
 crypto/asymmetric_keys/pkcs7_parser.c |  4 +--
 crypto/asymmetric_keys/pkcs7_verify.c | 48 ++++++++++++++++++---------
 include/crypto/public_key.h           |  1 +
 3 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 423d13c47545..3cdbab3b9f50 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -599,8 +599,8 @@ int pkcs7_sig_note_set_of_authattrs(void *context, size_t hdrlen,
 	}
 
 	/* We need to switch the 'CONT 0' to a 'SET OF' when we digest */
-	sinfo->authattrs = value - (hdrlen - 1);
-	sinfo->authattrs_len = vlen + (hdrlen - 1);
+	sinfo->authattrs = value - hdrlen;
+	sinfo->authattrs_len = vlen + hdrlen;
 	return 0;
 }
 
diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 6d6475e3a9bf..0f9f515b784d 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -70,8 +70,6 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 	 * digest we just calculated.
 	 */
 	if (sinfo->authattrs) {
-		u8 tag;
-
 		if (!sinfo->msgdigest) {
 			pr_warn("Sig %u: No messageDigest\n", sinfo->index);
 			ret = -EKEYREJECTED;
@@ -97,20 +95,40 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 		 * as the contents of the digest instead.  Note that we need to
 		 * convert the attributes from a CONT.0 into a SET before we
 		 * hash it.
+		 *
+		 * However, for certain algorithms, such as ML-DSA, the digest
+		 * is integrated into the signing algorithm.  In such a case,
+		 * we copy the authattrs, modifying the tag type, and set that
+		 * as the digest.
 		 */
-		memset(sig->digest, 0, sig->digest_size);
-
-		ret = crypto_shash_init(desc);
-		if (ret < 0)
-			goto error;
-		tag = ASN1_CONS_BIT | ASN1_SET;
-		ret = crypto_shash_update(desc, &tag, 1);
-		if (ret < 0)
-			goto error;
-		ret = crypto_shash_finup(desc, sinfo->authattrs,
-					 sinfo->authattrs_len, sig->digest);
-		if (ret < 0)
-			goto error;
+		if (sig->algo_does_hash) {
+			kfree(sig->digest);
+
+			ret = -ENOMEM;
+			sig->digest = kmalloc(umax(sinfo->authattrs_len, sig->digest_size),
+					      GFP_KERNEL);
+			if (!sig->digest)
+				goto error_no_desc;
+
+			sig->digest_size = sinfo->authattrs_len;
+			memcpy(sig->digest, sinfo->authattrs, sinfo->authattrs_len);
+			((u8 *)sig->digest)[0] = ASN1_CONS_BIT | ASN1_SET;
+			ret = 0;
+		} else {
+			u8 tag = ASN1_CONS_BIT | ASN1_SET;
+
+			ret = crypto_shash_init(desc);
+			if (ret < 0)
+				goto error;
+			ret = crypto_shash_update(desc, &tag, 1);
+			if (ret < 0)
+				goto error;
+			ret = crypto_shash_finup(desc, sinfo->authattrs + 1,
+						 sinfo->authattrs_len - 1,
+						 sig->digest);
+			if (ret < 0)
+				goto error;
+		}
 		pr_devel("AADigest = [%*ph]\n", 8, sig->digest);
 	}
 
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index 81098e00c08f..e4ec8003a3a4 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -46,6 +46,7 @@ struct public_key_signature {
 	u8 *digest;
 	u32 s_size;		/* Number of bytes in signature */
 	u32 digest_size;	/* Number of bytes in digest */
+	bool algo_does_hash;	/* Public key algo does its own hashing */
 	const char *pkey_algo;
 	const char *hash_algo;
 	const char *encoding;

