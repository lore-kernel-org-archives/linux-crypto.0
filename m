Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644E6155C8A
	for <linux-crypto@vger.kernel.org>; Sat,  7 Dec 2024 19:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733601514; cv=none; b=OlP/meoEMT3P4PgvEg/YVq3qZ8/YZh+/m8F6jl/zHEqN4qlpxmbZ6zjm8rjeCIf4JsK91ZM9rW+vD9gjAyeoag9FrsowTqv7EB7iYErOgcJk4fI5mf1dRjytmOR5OrTnVN6z+GvvRmfS8uBp6p5yS5pYO0rlfEa1es7Wa681yRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733601514; c=relaxed/simple;
	bh=WIJr3To+Bg946AFk5yTIVR8OK0ItC2hbRsJv4XNtRWc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLE8O/OsrNaEKTNqxCowmhx3KpldbjxkYd0GAjudDWZIyx836iJaItftyKTI3qLNxH7YIkgDF+H0QL9yhe94BZFWEyWouM7ahJ6rKueI7TUfzt2c3XDk0ljxC5+Jwa5ubKKuFz/6rCZAbM1N7BudF3KBGeG/z55M3IvVD5rIFm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KEPBgH+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KEPBgH+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC48C4CEDC
	for <linux-crypto@vger.kernel.org>; Sat,  7 Dec 2024 19:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733601513;
	bh=WIJr3To+Bg946AFk5yTIVR8OK0ItC2hbRsJv4XNtRWc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=KEPBgH+tNg3KepBzBcutWplYy1oyl3UEjApDJxUgfc6M1wnOJyTF4eTNvBBTgwYOy
	 lDoSH5nm7aA2YZO8XGpbxnPN0nu285bUXrTj+9FZQq0H9DhdIQi2nEhmHfC9Oqp3Zj
	 Y/xX+3SRfJQcrj079nEt99Z9k2zBiyfd2Lf18yF9Dio11Bz4bfJ/uAoVITEYSpoxht
	 6rdqZ3VDWRq+J058J5UNEO0C0heYLSVZ7PAHQwl59CzUtVCGp2bPokMLiCTC2hsUvs
	 +yzaaetjA3Y4Jv6/lALpkvETiB9l5SaElg7H64+I3yR4+MDaiEtQnpyQbs2NrladzR
	 06suZFXe+fKBA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 8/8] crypto: keywrap - remove assignment of 0 to cra_alignmask
Date: Sat,  7 Dec 2024 11:57:52 -0800
Message-ID: <20241207195752.87654-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241207195752.87654-1-ebiggers@kernel.org>
References: <20241207195752.87654-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Since this code is zero-initializing the algorithm struct, the
assignment of 0 to cra_alignmask is redundant.  Remove it to reduce the
number of matches that are found when grepping for cra_alignmask.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/keywrap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/keywrap.c b/crypto/keywrap.c
index 385ffdfd5a9b4..5ec4f94d46bd0 100644
--- a/crypto/keywrap.c
+++ b/crypto/keywrap.c
@@ -277,11 +277,10 @@ static int crypto_kw_create(struct crypto_template *tmpl, struct rtattr **tb)
 	/* Section 5.1 requirement for KW */
 	if (alg->cra_blocksize != sizeof(struct crypto_kw_block))
 		goto out_free_inst;
 
 	inst->alg.base.cra_blocksize = SEMIBSIZE;
-	inst->alg.base.cra_alignmask = 0;
 	inst->alg.ivsize = SEMIBSIZE;
 
 	inst->alg.encrypt = crypto_kw_encrypt;
 	inst->alg.decrypt = crypto_kw_decrypt;
 
-- 
2.47.1

