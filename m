Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B548146D59
	for <linux-crypto@vger.kernel.org>; Tue, 25 Feb 2025 05:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740459820; cv=none; b=bbNqDaiO3XttHCJRjEnM00foTdh7HDpSJDSwse1i842+5sL0twmCxt+f+OmX/xZdufSlfuXfRbuc5BjFI8WGKqhpbvPJPUnuj1w9E0vz9uXuVHJ5+VJhaPvui7hB8yak9Vf1pfiqSTZWgIUEc3EtAS2u4PgBaP2oJ69GFu4mHbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740459820; c=relaxed/simple;
	bh=i+dKd7gX9/IkCCAwhAgPVKs1BNTxXIYyeToi3FSCirw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Bd8hccxE2d3WjyLXBoksBGKTIC4t5/OyOhxDvRPsr3EDzqhII8uJSP7RK3n4COsNSuCE4UZbj71WU5CZKSNDAOn2qLS8QzANFBl4KY/Fq0aJxSRh0HlnOmf+9WX5EKAkjcVsEA5OeXz0Q+JA4uh01KBMPTdsiKQzHTHZ1GHcH00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Ojb6XsNG; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Ojb6XsNG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=l3hbku6YHG6T2fUgXw1k21n3241ilP9OhyTRErQSUTQ=; b=Ojb6XsNGDZjMLMloqNgvMauuMz
	+8d9Zbcwzz3Hbn6W3Q/bWyDG9y8v2gsMPR7M5iQe+qnpZBrVkM6Jq38bc2PkjdQTs9K+OIfzN2czq
	yfZEJN2+OUuKz2TJi0KOzzNlCY6XUohMvKMduYqWl525pjry533Z/AV9VMJnNDmSPUqPAUfsNs+km
	MimW7z5DlqbV+h4XjGZ4c8Skf7tiLVK5Pkgc74cvbiy79Hc9smN9Hu4bG7azHWIUNR+s2oMxFAWX5
	rBuBHhTDbOznF77ANxXm972haCBa6QNyaR1ablrLuI8+vhaEBt07c8up24JJb7HIFVARGpnSTWQH0
	OB8ltxzw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tmn6M-001V70-1v;
	Tue, 25 Feb 2025 13:03:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 25 Feb 2025 13:03:26 +0800
Date: Tue, 25 Feb 2025 13:03:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: api - Move struct crypto_type into internal.h
Message-ID: <Z71PHnpl0FeqChRE@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Move the definition of struct crypto_type into internal.h as it
is only used by API implementors and not algorithm implementors.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/internal.h b/crypto/internal.h
index 46b661be0f90..08d43b40e7db 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -33,6 +33,20 @@ struct crypto_larval {
 	bool test_started;
 };
 
+struct crypto_type {
+	unsigned int (*ctxsize)(struct crypto_alg *alg, u32 type, u32 mask);
+	unsigned int (*extsize)(struct crypto_alg *alg);
+	int (*init_tfm)(struct crypto_tfm *tfm);
+	void (*show)(struct seq_file *m, struct crypto_alg *alg);
+	int (*report)(struct sk_buff *skb, struct crypto_alg *alg);
+	void (*free)(struct crypto_instance *inst);
+
+	unsigned int type;
+	unsigned int maskclear;
+	unsigned int maskset;
+	unsigned int tfmsize;
+};
+
 enum {
 	CRYPTOA_UNSPEC,
 	CRYPTOA_ALG,
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 11065978d360..94989b2e1350 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -55,20 +55,6 @@ struct scatterlist;
 struct seq_file;
 struct sk_buff;
 
-struct crypto_type {
-	unsigned int (*ctxsize)(struct crypto_alg *alg, u32 type, u32 mask);
-	unsigned int (*extsize)(struct crypto_alg *alg);
-	int (*init_tfm)(struct crypto_tfm *tfm);
-	void (*show)(struct seq_file *m, struct crypto_alg *alg);
-	int (*report)(struct sk_buff *skb, struct crypto_alg *alg);
-	void (*free)(struct crypto_instance *inst);
-
-	unsigned int type;
-	unsigned int maskclear;
-	unsigned int maskset;
-	unsigned int tfmsize;
-};
-
 struct crypto_instance {
 	struct crypto_alg alg;
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
