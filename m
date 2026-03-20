Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E6E72623;
	Fri, 20 Mar 2026 23:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774048458; cv=none; b=fun6n6K0M+17n5eH3ip4eaWk5RU50r7N0kTtVjmmDhZif0M0gcBDiUM94H/ujzjELhvZ9RxSKhVUgOnMTSZ5BpBKxfXxgvuUXzhHZvljChWRBUrsn3ZpM688fEI1fxtHTzG/Y6ZndTjuZSyQl42IwLccE0HKyeWVUnVbLyR73tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774048458; c=relaxed/simple;
	bh=X1dam4tJH4PvdyNTx2/eS0ilepgkwjLLyDLBzuxcDlI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l9jQ4M7nY45wuDoG72LlVPyGxc+AdRsbs4jxzyvJyz6uKKV8l40vfaZVndzAkFa1eyJNprZXdiJ1NKAsNHX9KF0zl/J6ufo8SnzZ/QCvFa+e/BbVW6K+4s++Klfkn+kKXLBS/yThDH6okhOXdX83IeqzuSn8lYABhd0tgaaaBD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TEED+ufx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TEED+ufx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B936C4CEF7;
	Fri, 20 Mar 2026 23:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774048457;
	bh=X1dam4tJH4PvdyNTx2/eS0ilepgkwjLLyDLBzuxcDlI=;
	h=From:To:Cc:Subject:Date:From;
	b=TEED+ufx9bSYZL1291Mf6OGejPulYCX0tJIwo+7Ajrrv8CAoxRmajERhMhkDdPApu
	 Ira+REeybGqqZBJczEmm9n5xj38R+7lLaVbhqGIFwoC4VPHM64UaPxcvsXU1SPvdkJ
	 JR3f/78Xwgw16is6Tc1iXsMhDiQAhYg6WJv9GdwQ9gEAfdzgtnV4BMo7EwKzFFriw1
	 mOQLMeiXNL1ruSwk03u41fIA7pkNr1p1GZYfMGRL7QoPDM7AYisjJj7Hal4r9wJM84
	 US8J2msK73B4oAYFQPfoGs18pe6+6pdtu8FED459TCobO8bpO0SkA/OoKn2pw6eCsz
	 rftVisJMTGe3A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: sha1: Explicitly specify alignment of sha1_ctx::buf
Date: Fri, 20 Mar 2026 16:14:03 -0700
Message-ID: <20260320231403.47323-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__sha1_final() writes a __be64 to &ctx->buf[56] using a plain write.
That assumes that the alignment of buf is at least that of __be64.  It
is, since it immediately follows a u64 field.  However, to make this
assumption explicit it's best to specify the field alignment explicitly
too, like what is done in the corresponding SHA-2 and MD5 structs.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/sha1.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/crypto/sha1.h b/include/crypto/sha1.h
index 4d973e016cd6..560ed4fd1703 100644
--- a/include/crypto/sha1.h
+++ b/include/crypto/sha1.h
@@ -38,11 +38,11 @@ struct sha1_block_state {
  * @buf: partial block buffer; bytecount % SHA1_BLOCK_SIZE bytes are valid
  */
 struct sha1_ctx {
 	struct sha1_block_state state;
 	u64 bytecount;
-	u8 buf[SHA1_BLOCK_SIZE];
+	u8 buf[SHA1_BLOCK_SIZE] __aligned(__alignof__(__be64));
 };
 
 /**
  * sha1_init() - Initialize a SHA-1 context for a new message
  * @ctx: the context to initialize

base-commit: 6bc9effb4cbf9b6eba0f51aba1c8893dfd4c8100
-- 
2.53.0

