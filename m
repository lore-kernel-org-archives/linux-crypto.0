Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E06212550;
	Mon, 20 Oct 2025 00:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760921616; cv=none; b=abbHy+nqfdAdcGqf1V1UKwH5mQiXx/WgBJssNvHuaoScDkZKSyyEIZNSVRwZRZyzwJf1OqmNtwVk5U6QzNyp2j4z+ZyeFCgglwiwhpPoqCDoOsPIjks27dbJFeJiiGNDm5VM9ZeQMdkFHwYfudS8mq7rmKUwSdBqYbMOn1DP9OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760921616; c=relaxed/simple;
	bh=3ORQ9KVdJyyMj/gc8QaYuJQuZsbtFtyURkNerD2o3uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UnpVfMlR5Sr3WXTVV/hnapC5CRWRhSspAZRnS6VDPV7MVjdFxC1F8mDNLZxL9YTkqvIaFEs7ftgIURCSewkJ/ivRPmK3FDUjiGmn5XlkvbUr2GKSOyjxDVVGtGCg3wFyZTjMxM8XjXKnTo1KEFIg9/UraqPFeWEujOkQwT/UoUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oit5HcfN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oit5HcfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FB4C116C6;
	Mon, 20 Oct 2025 00:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760921615;
	bh=3ORQ9KVdJyyMj/gc8QaYuJQuZsbtFtyURkNerD2o3uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oit5HcfNshrDSHmVtH2/S/JLASBzI/Ti9cISjcCNnHc0K2pLTZdIR6fE3rYorCHej
	 Gmd04rN/u71NvIzZYDXIk++NB69tceE4IS7mShbKhrBOLtZHcpOdGUTck4J5oLdQ9p
	 lpnw0LdnIzk1JSekGDXjKb4yf6MO7qiJBJvrQFlASLbLIpt68bP/oC6m6at7lVP3qB
	 6hQbY2Rb89WT38+go/KYUS7yCW+xety/MFf8ddQw0hz6YJhcNl0869T+umw6XWXHl6
	 CixfqdyCd8099VjnSNoO5X8GyOSzQtytnCziqKW+gx/SmSebt+XRESHpxseeEi4X7w
	 7XDhQQ6PXT+yA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 09/17] lib/crypto: sha3: Consistently use EXPORT_SYMBOL_GPL
Date: Sun, 19 Oct 2025 17:50:30 -0700
Message-ID: <20251020005038.661542-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251020005038.661542-1-ebiggers@kernel.org>
References: <20251020005038.661542-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Consistently use EXPORT_SYMBOL_GPL in sha3.c, instead of a mix of
EXPORT_SYMBOL and EXPORT_SYMBOL_GPL.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/sha3.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/crypto/sha3.c b/lib/crypto/sha3.c
index 8f08e7b8f4521..f8167037138c7 100644
--- a/lib/crypto/sha3.c
+++ b/lib/crypto/sha3.c
@@ -329,11 +329,11 @@ void sha3_224(const u8 *in, size_t in_len, u8 out[SHA3_224_DIGEST_SIZE])
 
 	sha3_224_init(&ctx);
 	sha3_224_update(&ctx, in, in_len);
 	sha3_224_final(&ctx, out);
 }
-EXPORT_SYMBOL(sha3_224);
+EXPORT_SYMBOL_GPL(sha3_224);
 
 /**
  * sha3_256() - Convenience wrapper to digest a simple buffer as SHA3-256
  * @in: The data to be digested
  * @in_len: The amount of data to be digested in bytes
@@ -350,11 +350,11 @@ void sha3_256(const u8 *in, size_t in_len, u8 out[SHA3_256_DIGEST_SIZE])
 
 	sha3_256_init(&ctx);
 	sha3_256_update(&ctx, in, in_len);
 	sha3_256_final(&ctx, out);
 }
-EXPORT_SYMBOL(sha3_256);
+EXPORT_SYMBOL_GPL(sha3_256);
 
 /**
  * sha3_384() - Convenience wrapper to digest a simple buffer as SHA3-384
  * @in: The data to be digested
  * @in_len: The amount of data to be digested in bytes
@@ -371,11 +371,11 @@ void sha3_384(const u8 *in, size_t in_len, u8 out[SHA3_384_DIGEST_SIZE])
 
 	sha3_384_init(&ctx);
 	sha3_384_update(&ctx, in, in_len);
 	sha3_384_final(&ctx, out);
 }
-EXPORT_SYMBOL(sha3_384);
+EXPORT_SYMBOL_GPL(sha3_384);
 
 /**
  * sha3_512() - Convenience wrapper to digest a simple buffer as SHA3-512
  * @in: The data to be digested in bytes
  * @in_len: The amount of data to be digested in bytes
@@ -392,11 +392,11 @@ void sha3_512(const u8 *in, size_t in_len, u8 out[SHA3_512_DIGEST_SIZE])
 
 	sha3_512_init(&ctx);
 	sha3_512_update(&ctx, in, in_len);
 	sha3_512_final(&ctx, out);
 }
-EXPORT_SYMBOL(sha3_512);
+EXPORT_SYMBOL_GPL(sha3_512);
 
 /**
  * shake128() - Convenience wrapper to apply SHAKE128 to a simple buffer
  * @in: The input data to be used
  * @in_len: The amount of input data in bytes
@@ -416,11 +416,11 @@ void shake128(const u8 *in, size_t in_len, u8 *out, size_t out_len)
 	shake128_init(&ctx);
 	shake128_update(&ctx, in, in_len);
 	shake128_squeeze(&ctx, out, out_len);
 	shake128_clear(&ctx);
 }
-EXPORT_SYMBOL(shake128);
+EXPORT_SYMBOL_GPL(shake128);
 
 /**
  * shake256() - Convenience wrapper to apply SHAKE256 to a simple buffer
  * @in: The input data to be used
  * @in_len: The amount of input data in bytes
@@ -440,11 +440,11 @@ void shake256(const u8 *in, size_t in_len, u8 *out, size_t out_len)
 	shake256_init(&ctx);
 	shake256_update(&ctx, in, in_len);
 	shake256_squeeze(&ctx, out, out_len);
 	shake256_clear(&ctx);
 }
-EXPORT_SYMBOL(shake256);
+EXPORT_SYMBOL_GPL(shake256);
 
 /*
  * Do a quick test using SHAKE256 and a 200 byte digest.
  */
 static const u8 sha3_sample[] __initconst =
-- 
2.51.1.dirty

