Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3562C224243
	for <linux-crypto@vger.kernel.org>; Fri, 23 May 2025 12:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748003343; cv=none; b=PEXlMO5fx2NjTkaeqznTO0mu2g6xgGvEpaMAnQ0C83AyANAqB6N3MwBjpRcFIeDQHiMLrC4iXmGk1jP16Ql3BCSYB6H0GCOeAu6kTt4xMRY1YMB4LJHkaksgNyn64U9ee+iiUNW7POdy1jmBjtzRJ6NaJTE9LC98oSTYtVErJ5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748003343; c=relaxed/simple;
	bh=wbBhbvG1yBEFHJ0y7JsiF5o5h7o2LN6sGyGrqClTAek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aPby1ddH76J1hBIAxVOVH0SfFtnG8JlbwrxhjRhOEqs1ZJFxHQW/TeS+mYzDUKkHU4mzNUyUNh9G0xIM4087kV3BTO0xepVrvafNrITLMYzT+OwKzp0E0A7KQYl0I0/Gya/6yDiulrFXM8IGuE1X5S2KVqC7KLnAJptS23VUCgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=PJXzGr/H; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="PJXzGr/H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DknMK1FGjP65HNINgcldDaLMnrNdaik3skAiPi7daSE=; b=PJXzGr/Hn9tbPdygT9hh7tmfI9
	VuzmsQE6KnRYlQtupnR9ciNxG1tzs2WSyOYPnDLyle6SRAiLvktiUJuamRvFgMkIOM0/gLFJaIwl0
	Ayqnj2veznRFrNRJwiJIiVnwz5QvVdwK2FIGYRb0giCfXKV1WTvqUBg7LDUeyWCJLwTRsWrL/e7gA
	H/42qTGqTldnZkQrO6cpuyKX4YgEHhnLC/vmp5P/UsHpOPSFGS0BlKieBGw+Ds3Jw0oOLu/diwoCn
	l5PidzBIbngkOlEYpKuP2wDeRfhpxg5O6SmByoc/jls0KtAnPtsiA39jvIK1QgvFFIUVJWqxEUlmL
	Nud2HYYQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uIRWC-008LdY-0r;
	Fri, 23 May 2025 20:28:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 23 May 2025 20:28:56 +0800
Date: Fri, 23 May 2025 20:28:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>
Subject: [PATCH] crypto: s390/sha3 - Use cpu byte-order when exporting
Message-ID: <aDBqCEdH0U-cNIHA@gondor.apana.org.au>
References: <623a7fcb-b4cb-48e6-9833-57ad2b32a252@linux.ibm.com>
 <aDBe3o77jZTFWY9B@gondor.apana.org.au>
 <38637840-a626-49a9-a548-c1a141917775@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38637840-a626-49a9-a548-c1a141917775@linux.ibm.com>

On Fri, May 23, 2025 at 02:03:23PM +0200, Ingo Franzki wrote:
>
> I hope you can sort it out what belongs to what.

Please let me know if this patch works or not:

---8<---
The sha3 partial hash on s390 is in little-endian just like the
final hash.  However the generic implementation produces native
or big-endian partial hashes.

Make s390 sha3 conform to that by doing the byte-swap on export
and import.

Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
Fixes: 6f90ba706551 ("crypto: s390/sha3 - Use API partial block handling")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/s390/crypto/sha.h b/arch/s390/crypto/sha.h
index d757ccbce2b4..cadb4b13622a 100644
--- a/arch/s390/crypto/sha.h
+++ b/arch/s390/crypto/sha.h
@@ -27,6 +27,9 @@ struct s390_sha_ctx {
 			u64 state[SHA512_DIGEST_SIZE / sizeof(u64)];
 			u64 count_hi;
 		} sha512;
+		struct {
+			__le64 state[SHA3_STATE_SIZE / sizeof(u64)];
+		} sha3;
 	};
 	int func;		/* KIMD function to use */
 	bool first_message_part;
diff --git a/arch/s390/crypto/sha3_256_s390.c b/arch/s390/crypto/sha3_256_s390.c
index 4a7731ac6bcd..03bb4f4bab70 100644
--- a/arch/s390/crypto/sha3_256_s390.c
+++ b/arch/s390/crypto/sha3_256_s390.c
@@ -35,23 +35,33 @@ static int sha3_256_init(struct shash_desc *desc)
 static int sha3_256_export(struct shash_desc *desc, void *out)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
-	struct sha3_state *octx = out;
+	union {
+		u8 *u8;
+		u64 *u64;
+	} p = { .u8 = out };
+	int i;
 
 	if (sctx->first_message_part) {
-		memset(sctx->state, 0, sizeof(sctx->state));
-		sctx->first_message_part = 0;
+		memset(out, 0, SHA3_STATE_SIZE);
+		return 0;
 	}
-	memcpy(octx->st, sctx->state, sizeof(octx->st));
+	for (i = 0; i < SHA3_STATE_SIZE / 8; i++)
+		put_unaligned(le64_to_cpu(sctx->sha3.state[i]), p.u64++);
 	return 0;
 }
 
 static int sha3_256_import(struct shash_desc *desc, const void *in)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
-	const struct sha3_state *ictx = in;
+	union {
+		const u8 *u8;
+		const u64 *u64;
+	} p = { .u8 = in };
+	int i;
 
+	for (i = 0; i < SHA3_STATE_SIZE / 8; i++)
+		sctx->sha3.state[i] = cpu_to_le64(get_unaligned(p.u64++));
 	sctx->count = 0;
-	memcpy(sctx->state, ictx->st, sizeof(ictx->st));
 	sctx->first_message_part = 0;
 	sctx->func = CPACF_KIMD_SHA3_256;
 
diff --git a/arch/s390/crypto/sha3_512_s390.c b/arch/s390/crypto/sha3_512_s390.c
index 018f02fff444..a5c9690eecb1 100644
--- a/arch/s390/crypto/sha3_512_s390.c
+++ b/arch/s390/crypto/sha3_512_s390.c
@@ -34,24 +34,33 @@ static int sha3_512_init(struct shash_desc *desc)
 static int sha3_512_export(struct shash_desc *desc, void *out)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
-	struct sha3_state *octx = out;
-
+	union {
+		u8 *u8;
+		u64 *u64;
+	} p = { .u8 = out };
+	int i;
 
 	if (sctx->first_message_part) {
-		memset(sctx->state, 0, sizeof(sctx->state));
-		sctx->first_message_part = 0;
+		memset(out, 0, SHA3_STATE_SIZE);
+		return 0;
 	}
-	memcpy(octx->st, sctx->state, sizeof(octx->st));
+	for (i = 0; i < SHA3_STATE_SIZE / 8; i++)
+		put_unaligned(le64_to_cpu(sctx->sha3.state[i]), p.u64++);
 	return 0;
 }
 
 static int sha3_512_import(struct shash_desc *desc, const void *in)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
-	const struct sha3_state *ictx = in;
+	union {
+		const u8 *u8;
+		const u64 *u64;
+	} p = { .u8 = in };
+	int i;
 
+	for (i = 0; i < SHA3_STATE_SIZE / 8; i++)
+		sctx->sha3.state[i] = cpu_to_le64(get_unaligned(p.u64++));
 	sctx->count = 0;
-	memcpy(sctx->state, ictx->st, sizeof(ictx->st));
 	sctx->first_message_part = 0;
 	sctx->func = CPACF_KIMD_SHA3_512;
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
