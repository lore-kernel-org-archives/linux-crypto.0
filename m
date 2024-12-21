Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164351F2C2A
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772296; cv=none; b=cnnHGM8JtODR0HmfNpO6x4MOgf1GLVDW3HoVcotypQCVoAQzFDqr7U36hplo49WfJ+G8ofA3Onmj79KbLLKOf2EJXwpkVlV2QvlDg/OXoLnJ2KwMPX6F6MAaVzIP83r4g7/BdmZxvHzDdvcE70ab9+noGFJOe456metZeB2t6Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772296; c=relaxed/simple;
	bh=O3Xdr0JpCB71MKHbMwJUz16l51VzXXpHu+RjIVWy0zA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EP2i0TffT2FS+WZXlJDLo1DpwTmz2Ilrg82wfHuFoz5KinkFzrwD8Y1HRmNBPR+mXTFbXnmiIsz1kz44pzrK2Nq5l1Xgn8ww4wvBc+168LRNBItvnrP4LMhSpdIgtBAyiIip+xkSiwWQRuqQmEvZgDpy+44mjLvpoQeUxSk4WM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WAbBMalS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WAbBMalS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1AEFC4CEDD
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734772296;
	bh=O3Xdr0JpCB71MKHbMwJUz16l51VzXXpHu+RjIVWy0zA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=WAbBMalSXw5biKS4eDF/+4xtBAo0gpP6lRKeIHsD2HZRt4nueUWVVreT9KqKkYy/v
	 D7/3fkSOj43L9MSNah+K6O5UY1Ju71UXMPy66ebP2J2EyHK0KyzMbWm3ild0VHBcYh
	 xL3qBEENqDfxP4QdLoPNF5eWoFgGN2fC3Th4HUx2Xzv+0aulBfg/nuJwUxHumy2Pg5
	 YNoB9NL72WP5+MASAQomvyoY21uxOZBkAe4xwWdZlZcG9lKzOjCOuz4W6wI2+cKThh
	 5j50J9istktOLGN3Kqdigmr/dN5ipCLI+qhzbfIUqHqYYFQwCu6BkV5E4Lr4DZSpwU
	 s9yW1GdgodCkg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 24/29] crypto: x86/aes-gcm - use the new scatterwalk functions
Date: Sat, 21 Dec 2024 01:10:51 -0800
Message-ID: <20241221091056.282098-25-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241221091056.282098-1-ebiggers@kernel.org>
References: <20241221091056.282098-1-ebiggers@kernel.org>
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
index fbf43482e1f5..c65d44b037b5 100644
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

