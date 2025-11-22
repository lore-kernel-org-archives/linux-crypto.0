Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8622D4816;
	Sat, 22 Nov 2025 19:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763840569; cv=none; b=BIuWdehfYGns5SZU8BxBPwzVPZELrLg8i3mXwvVKmkvzH7WPSKRfx/SNcB6TJVqmR6vJvG1nwDDIvcWnO0DxcpUNhX8Smc4rPUvVH2tueUptA8creqnu2h3cr+I10YJjBV5nH0REm5F27RWST76BPq9puV8G+T3VoM5tIMbHHew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763840569; c=relaxed/simple;
	bh=0IOUqs8lMMDtwM/i/7ezFpGR18sjAzjwbBN/o8ZuLWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvzUIk5fbBdoEgmwJZLfMfKhpb1FAdNe77ORXTyt4y2DZ31Uo0Zojml+TJwVSwbD0gyeyoCCUGcc5nqJYwSfPmaRVbN63Mk3Zs0R+pXlbSapj7taCXTrbXmscFCSHTIl/8xHKk6KY3m2oeQC2gXYdgxYqY41aOSpEUJmmFCOZ1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l2rI8DQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l2rI8DQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803D6C19425;
	Sat, 22 Nov 2025 19:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763840567;
	bh=0IOUqs8lMMDtwM/i/7ezFpGR18sjAzjwbBN/o8ZuLWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l2rI8DQRNoSuhrE5yb3zxnsKN8J96NlO9OU5eD5pOnrsg69KUwya1Aw8ahm4dx31h
	 TlMB3Wu0IHh7FCZQ6fEzDCuRImnuqrYSSTc4FK3HNYJuYIsZFIyE966NPs6ErfV02K
	 SmKV3eUH+KlbPae5+T9wZelfEtEamJigg+ZZoJ2wikH63ynk9TnMzGgsyQtdyAEqkd
	 FbDNZk8RcP+5hwJPovVC8Ud1XTQeNzFCYWW/A9IN0V7up3ISIStGO+SP6xELbdPy2m
	 OrXXDJ+LTiLwf+XdpSM1rwCXKGrmQKAQvtr70IwdV0RUpZjxjbQmXN/00XVAwmdxFt
	 tsxHe/v8AG+AA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 4/6] lib/crypto: poly1305: Add at_least decoration to fixed-size array params
Date: Sat, 22 Nov 2025 11:42:04 -0800
Message-ID: <20251122194206.31822-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251122194206.31822-1-ebiggers@kernel.org>
References: <20251122194206.31822-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the at_least (i.e. 'static') decoration to the fixed-size array
parameters of the poly1305 library functions.  This causes clang to warn
when a too-small array of known size is passed.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/poly1305.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/crypto/poly1305.h b/include/crypto/poly1305.h
index d4daeec8da19..190beb427c6d 100644
--- a/include/crypto/poly1305.h
+++ b/include/crypto/poly1305.h
@@ -57,11 +57,11 @@ struct poly1305_desc_ctx {
 	u32 s[4];
 	struct poly1305_block_state state;
 };
 
 void poly1305_init(struct poly1305_desc_ctx *desc,
-		   const u8 key[POLY1305_KEY_SIZE]);
+		   const u8 key[at_least POLY1305_KEY_SIZE]);
 void poly1305_update(struct poly1305_desc_ctx *desc,
 		     const u8 *src, unsigned int nbytes);
 void poly1305_final(struct poly1305_desc_ctx *desc, u8 *digest);
 
 #endif
-- 
2.51.2

