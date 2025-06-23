Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E921E492D;
	Mon, 23 Jun 2025 11:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750677120; cv=none; b=dPbF/G2ty1ifhJ9QZcKqnKuCJJDtupLL4PXSON3yzUuNJ/SmG4hoS/5GnUlk5S5ki3C9Z1jDrsmFbQWQqxPD5INKUydm4JDbBuawx3EZWcW16OiHWG6Ky//JIlbRBwq91P6/Uol0dyAp6P9aSpCLvy7g57dzyGpJEi9hky8V8Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750677120; c=relaxed/simple;
	bh=IPMrlSrNNdRttYlCpxufd8/aaOWYvAdxOpWLktQesUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O6r5l02uqA70x0+YHh9rOZSjqI7s1mD7WGBliOc5ccD3K48cDUX4mMo2XE3oAX0+vzGgXtssXglN2LDcHhtNmaE2ta7s1L0h71r8kVCCxa3x4lGsPuzVnhfs6WBUje/Rgged8v1d+GdC9ffhFZ08dphwRJJ0xLg4O+DFg5e9xX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CkljQLoB; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CkljQLoB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1CgKfi34HOfaueYZqtEP5U71y4ZdtDUkIBvSaw1ptvM=; b=CkljQLoBUvY6OTigxJ2FN1bF8C
	xdZnfQFBdHTo6Z5YgdxQovBE0mCDD6g3GSkjFAbCr3KiuOm3E+3mG2mW1lPKv0DZwRyq61qaRc5aV
	DJH9eJnt1MXNLNAjtLn+amVeR27NtTzbr04cErmem1b6QE2Mzv2jF1qJf04L+RYc9OW0i5YFumugS
	wDeicWRr9dL7F9BeChJsInh59u74oNn9l+6ZDnL10pjk5T1EJ8s+zK2Z1wgUV+uPkzYB8u2QdhlJY
	48lHuv/1RtV1TZ0Gig4CJFHsDf+k+J69u3rgrAtN2MVVV1Z0eK2y4JEOenBP+NukXXKvF58UwkkJf
	qYIen89Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uTeq9-000HYJ-2l;
	Mon, 23 Jun 2025 19:11:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Jun 2025 19:11:50 +0800
Date: Mon, 23 Jun 2025 19:11:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Milan Broz <gmazyland@gmail.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: [v2 PATCH] dm-crypt: Extend state buffer size in crypt_iv_lmk_one
Message-ID: <aFk2diodY0QhmZS8@gondor.apana.org.au>
References: <f1625ddc-e82e-4b77-80c2-dc8e45b54848@gmail.com>
 <aFTe3kDZXCAzcwNq@gondor.apana.org.au>
 <afeb759d-0f6d-4868-8242-01157f144662@gmail.com>
 <cc21e81d-e03c-a8c8-e32c-f4e52ce18891@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc21e81d-e03c-a8c8-e32c-f4e52ce18891@redhat.com>

On Mon, Jun 23, 2025 at 11:40:39AM +0200, Mikulas Patocka wrote:
>
> 345 bytes on the stack - I think it's too much, given the fact that it 
> already uses 345 bytes (from SHASH_DESC_ON_STACK) and it may be called in 
> a tasklet context. I'd prefer a solution that allocates less bytes.
> 
> I don't see the beginning of this thread, so I'd like to ask what's the 
> problem here, what algorithm other than md5 is used here that causes the 
> buffer overflow?

The md5 export size has increased due to the partial block API
thus triggering the overflow.

How about this patch?

---8<---
Add a macro CRYPTO_MD5_STATESIZE for the Crypto API export state
size of md5 and use that in dm-crypt instead of relying on the
size of struct md5_state (the latter is currently undergoing a
transition and may shrink).

Fixes: 8cf4c341f193 ("crypto: md5-generic - Use API partial block handling")
Reported-by: Milan Broz <gmazyland@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 9dfdb63220d7..17157c4216a5 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -517,7 +517,10 @@ static int crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
 {
 	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
 	SHASH_DESC_ON_STACK(desc, lmk->hash_tfm);
-	struct md5_state md5state;
+	union {
+		struct md5_state md5state;
+		u8 state[CRYPTO_MD5_STATESIZE];
+	} u;
 	__le32 buf[4];
 	int i, r;
 
@@ -548,13 +551,13 @@ static int crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
 		return r;
 
 	/* No MD5 padding here */
-	r = crypto_shash_export(desc, &md5state);
+	r = crypto_shash_export(desc, &u.md5state);
 	if (r)
 		return r;
 
 	for (i = 0; i < MD5_HASH_WORDS; i++)
-		__cpu_to_le32s(&md5state.hash[i]);
-	memcpy(iv, &md5state.hash, cc->iv_size);
+		__cpu_to_le32s(&u.md5state.hash[i]);
+	memcpy(iv, &u.md5state.hash, cc->iv_size);
 
 	return 0;
 }
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 6f6b9de12cd3..db294d452e8c 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -202,6 +202,8 @@ struct shash_desc {
 #define HASH_REQUEST_CLONE(name, gfp) \
 	hash_request_clone(name, sizeof(__##name##_req), gfp)
 
+#define CRYPTO_HASH_STATESIZE(coresize, blocksize) (coresize + blocksize + 1)
+
 /**
  * struct shash_alg - synchronous message digest definition
  * @init: see struct ahash_alg
diff --git a/include/crypto/md5.h b/include/crypto/md5.h
index 198b5d69b92f..28ee533a0507 100644
--- a/include/crypto/md5.h
+++ b/include/crypto/md5.h
@@ -2,6 +2,7 @@
 #ifndef _CRYPTO_MD5_H
 #define _CRYPTO_MD5_H
 
+#include <crypto/hash.h>
 #include <linux/types.h>
 
 #define MD5_DIGEST_SIZE		16
@@ -15,6 +16,9 @@
 #define MD5_H2	0x98badcfeUL
 #define MD5_H3	0x10325476UL
 
+#define CRYPTO_MD5_STATESIZE \
+	CRYPTO_HASH_STATESIZE(MD5_STATE_SIZE, MD5_HMAC_BLOCK_SIZE)
+
 extern const u8 md5_zero_message_hash[MD5_DIGEST_SIZE];
 
 struct md5_state {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
