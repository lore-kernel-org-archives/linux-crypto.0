Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE971A3031;
	Mon, 30 Dec 2024 00:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735517767; cv=none; b=JkB68abSAHv9+nkIf+of9gR6TTRqV9bG07FX492ZsBq58EWAybTpFJpJv05fKm9zchjxLsQV56nkrZBWkJc6mRz6tYuGw510HFi2+J1qVUFdnMz9Eu2RN3FMAzDE7MWfce7Qhhrc1llgfREs26c0VNK/ReTBjuuUxXlmreYE9hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735517767; c=relaxed/simple;
	bh=Id9OlnOz/d+SiVoBEHgQnOUjd+cNJqgxBPN0qKJ4qTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHlr8g1sHJJwrt6DUvXSgY+RAh3CVbE+urvCGJK2+39FdIslAy4hYU/6+QTdJGUe1fFRD58v7ehRHZfxTRgFoK3PEb1bHAqc0nkiBlZX/udYKmgwCguq0mlnlQImhmWpHe+pmhsHq6Yy9uzOi2HfBTF1mOIqpel29kJIt/BUSEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kTWlGtUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kTWlGtUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1E7C4CED1;
	Mon, 30 Dec 2024 00:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735517767;
	bh=Id9OlnOz/d+SiVoBEHgQnOUjd+cNJqgxBPN0qKJ4qTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTWlGtUP6QMja6h5RgOVuD1T6HdMyJyy6Vr46sHKS9dvrg+mUj7QHHKHHzH/nGmog
	 043XOYVSuxYfCP/6JvA2/tWqixBMZs18+3ZI40n7Tom0OjsHdxwogEcn+dZHXig67v
	 5ch83O2l9x0CSPuJeyNVa7n3jP3yGY9LIXhn3p9F5hRRhu9UtLk9zXZ9Qe0NS8aI2P
	 WjyB13eMb/Q+CVsEX+Msim6kgdCPhqgMZNDyFYNI3wms0FWdGNeUNG6Sa0kCnwWAdE
	 oJ26qevfjPPByvynZeOS7nYJYMtErlv+JoljMA5DCgQ0fq6FMGJgYSHQdush4vz7hO
	 G0xpE53SXAaNg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 24/29] crypto: x86/aes-gcm - use the new scatterwalk functions
Date: Sun, 29 Dec 2024 16:14:13 -0800
Message-ID: <20241230001418.74739-25-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230001418.74739-1-ebiggers@kernel.org>
References: <20241230001418.74739-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

In gcm_process_assoc(), use scatterwalk_next() which consolidates
scatterwalk_clamp() and scatterwalk_map().  Use scatterwalk_done_src()
which consolidates scatterwalk_unmap(), scatterwalk_advance(), and
scatterwalk_done().

Also rename some variables to avoid implying that anything is actually
mapped (it's not), or that the loop is going page by page (it is for
now, but nothing actually requires that to be the case).

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 11e95fc62636..22e61efbf5fe 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1289,45 +1289,45 @@ static void gcm_process_assoc(const struct aes_gcm_key *key, u8 ghash_acc[16],
 
 	memset(ghash_acc, 0, 16);
 	scatterwalk_start(&walk, sg_src);
 
 	while (assoclen) {
-		unsigned int len_this_page = scatterwalk_clamp(&walk, assoclen);
-		void *mapped = scatterwalk_map(&walk);
-		const void *src = mapped;
+		unsigned int orig_len_this_step;
+		const u8 *orig_src = scatterwalk_next(&walk, assoclen,
+						      &orig_len_this_step);
+		unsigned int len_this_step = orig_len_this_step;
 		unsigned int len;
+		const u8 *src = orig_src;
 
-		assoclen -= len_this_page;
-		scatterwalk_advance(&walk, len_this_page);
 		if (unlikely(pos)) {
-			len = min(len_this_page, 16 - pos);
+			len = min(len_this_step, 16 - pos);
 			memcpy(&buf[pos], src, len);
 			pos += len;
 			src += len;
-			len_this_page -= len;
+			len_this_step -= len;
 			if (pos < 16)
 				goto next;
 			aes_gcm_aad_update(key, ghash_acc, buf, 16, flags);
 			pos = 0;
 		}
-		len = len_this_page;
+		len = len_this_step;
 		if (unlikely(assoclen)) /* Not the last segment yet? */
 			len = round_down(len, 16);
 		aes_gcm_aad_update(key, ghash_acc, src, len, flags);
 		src += len;
-		len_this_page -= len;
-		if (unlikely(len_this_page)) {
-			memcpy(buf, src, len_this_page);
-			pos = len_this_page;
+		len_this_step -= len;
+		if (unlikely(len_this_step)) {
+			memcpy(buf, src, len_this_step);
+			pos = len_this_step;
 		}
 next:
-		scatterwalk_unmap(mapped);
-		scatterwalk_pagedone(&walk, 0, assoclen);
+		scatterwalk_done_src(&walk, orig_src, orig_len_this_step);
 		if (need_resched()) {
 			kernel_fpu_end();
 			kernel_fpu_begin();
 		}
+		assoclen -= orig_len_this_step;
 	}
 	if (unlikely(pos))
 		aes_gcm_aad_update(key, ghash_acc, buf, pos, flags);
 }
 
-- 
2.47.1

