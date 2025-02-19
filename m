Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C924B215184;
	Wed, 19 Feb 2025 18:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739989468; cv=none; b=qiIN1zVZuH1rMT6nGo4IExqSWjY76N44pxmpR6isxhiEk5+Rh9uitwYPqNkyzRA1vPN0dSOJ9QA6CFH3ti/ugoG7arVrPwZU2olADw0XXTWC2NHDyuaZWqguiOniatPTi9oIeZq6dUacIv7uS3rbGGlT/7qBroogkgYMegYxGzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739989468; c=relaxed/simple;
	bh=ZqAvF4vHiLc/5vatLVvUZCNM6+C9ciriG0My6qjcqpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUMTRFj2zokYzN2vrNwTuSzz6K69hBCGzZvVeOekaGAR3/maLYDG/Yrv53CKEHvtPf4J556XSbknqAQfPxKbUVPEwRAP5mCIxpwjDl8yjYcLCZZYwLAlIhq/hyczQMNoRAHnVSFTCRWEuTXK1GgPn+hUDfiJBCZ8VC1D2zt74MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tf71jMKO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tf71jMKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906E6C4CEF4;
	Wed, 19 Feb 2025 18:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739989468;
	bh=ZqAvF4vHiLc/5vatLVvUZCNM6+C9ciriG0My6qjcqpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tf71jMKOQx7DJoQrus86YNwFbYNGvhjrDjpn89t2/idNGmlpafmlMyzpPLZYxW5P5
	 Lc3C7Sk4LJfP/qm8EQRjJd2E4HqRClTI8tzdJKMKETj6OSZB5Q/t0g+B9yxGPbMl26
	 /8ERue1WMBtRlPsrXbdd7thBoqPLyfbnEpxnKEBSSPOpNK7sFsjIfY6EibpaEC1o/J
	 7PFlXszA64wye9VlKGInJ4F9cPIH7YYmpiCJPy+Lbp6PNOnH3hWcjEPegILvE6sYvs
	 sfKQDcERIL94QbaBmVZ3VqCdaa+gVWGg+6Bci6Df5XKJVqYuiPLYcoiKOSO//x/ABE
	 XqkhC9PlzQ/Kw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v3 06/19] crypto: skcipher - use scatterwalk_start_at_pos()
Date: Wed, 19 Feb 2025 10:23:28 -0800
Message-ID: <20250219182341.43961-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219182341.43961-1-ebiggers@kernel.org>
References: <20250219182341.43961-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

In skcipher_walk_aead_common(), use scatterwalk_start_at_pos() instead
of a sequence of scatterwalk_start(), scatterwalk_copychunks(..., 2),
and scatterwalk_done().  This is simpler and faster.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index e3751cc88b76e..33508d001f361 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -361,18 +361,12 @@ static int skcipher_walk_aead_common(struct skcipher_walk *walk,
 		walk->flags = 0;
 
 	if (unlikely(!walk->total))
 		return 0;
 
-	scatterwalk_start(&walk->in, req->src);
-	scatterwalk_start(&walk->out, req->dst);
-
-	scatterwalk_copychunks(NULL, &walk->in, req->assoclen, 2);
-	scatterwalk_copychunks(NULL, &walk->out, req->assoclen, 2);
-
-	scatterwalk_done(&walk->in, 0, walk->total);
-	scatterwalk_done(&walk->out, 0, walk->total);
+	scatterwalk_start_at_pos(&walk->in, req->src, req->assoclen);
+	scatterwalk_start_at_pos(&walk->out, req->dst, req->assoclen);
 
 	/*
 	 * Accessing 'alg' directly generates better code than using the
 	 * crypto_aead_blocksize() and similar helper functions here, as it
 	 * prevents the algorithm pointer from being repeatedly reloaded.
-- 
2.48.1

