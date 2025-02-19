Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C82721A455;
	Wed, 19 Feb 2025 18:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739989471; cv=none; b=NfddZh4AOZl9isUgWm0FTKcYCsdUEvYH2REnGwzF7scMVpHmF/CXhwdoc604L6b8vXh4mCejQbPG+MBgxD2eIV/0ILFlSjWccEwS2B7plyaTxjgcWa5OuUUGPooUH4lYDw4A+TX392ypa+uvXQX9C2Vfa5E3HwHcuf7TmSGsP18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739989471; c=relaxed/simple;
	bh=DMl5gHfD8qUZ3YL0b5yRXo2ontnZm0E6uzFbcU4n97Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvQWXVj0/lcCV7qLF/E7kJOm10n9XXqDhT65oqyyD7edzGfEk9cN4D2tdvAOk/zlgXQ0PmyEk407EHLC5Cr9OxlCBPVCbdJYPCTxuVYB0gAI6k1+Vo1rLgIlFMRgaI2U9q+T/CLgY1wruCw1/qA1DJ/iAho16aJ6n8GbolGOuas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pm5aLEls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pm5aLEls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CECC4CEDD;
	Wed, 19 Feb 2025 18:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739989471;
	bh=DMl5gHfD8qUZ3YL0b5yRXo2ontnZm0E6uzFbcU4n97Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pm5aLElsFC9f8IRhcPWIG7PYWCKWJe5LAjTvmEo+WqLtfMWdqKMTvpte5ibgOSdhW
	 d9GIcEHvqXx8VCOvVzkt5/RwQ5VRaNHA+c92FDEX5jRm+c4EteQp5lgtm89OkV6v8m
	 czhZWMA/4mYa+9izPUDyJ1p0B9fs6WKMAXzSsXc3dEhn1CoL0pQa6AjwIztVVC+7AA
	 yaEBGcYSnfifqZtYo6NbX3SNWFADfupAEGA7L7kuBQzLT9QypC11vgkxzTQgubKV9h
	 g+ln6hlW8NpYyBkhWMb+VbgWoxDsN2nlSDdoTrMngr+kvFaoEf5k4yzQ0u69rWJtfw
	 HTPivI50Kxevw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v3 14/19] crypto: x86/aes-gcm - use the new scatterwalk functions
Date: Wed, 19 Feb 2025 10:23:36 -0800
Message-ID: <20250219182341.43961-15-ebiggers@kernel.org>
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
index 3e0cc15050f32..f963f5c04006d 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1279,45 +1279,45 @@ static void gcm_process_assoc(const struct aes_gcm_key *key, u8 ghash_acc[16],
 
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
2.48.1

