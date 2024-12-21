Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562921F2376
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772294; cv=none; b=EwMYW8xCUteYhfxh+zw9QSsm4tQNokVgckvk2JgKQpJlygM6/v2XJp/hfIa6M+IfnD7xZthlJ33nJN/zqzDelyKyFBj6NPhPcES47pY464HlmsIsiQ3YwWm+HABjMqQ9toprtA5jvGrvrx6sRtKWXKzLhZxNASPC/PROoP2rM/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772294; c=relaxed/simple;
	bh=flgH9kGUEUUdU5GGIoLcecbOKpZ/9P71he8YGiVnKlw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfIfrHZIXy/us/2pYjNQwVVJ32jAzmq7hIzzS2Low1s0IlB0CbsACA2lXx6lDjB3f+Mj1xnmfVFKwZ3k4E4RDNpyTVLIpqlZle6hAykalKs9JzOtrq0lGGlnXA54jUCg8YGncBo9jTV7d1OTQfdGgJ+78gnmlAPKRxSpjQETUt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t8fL2qOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t8fL2qOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF4FC4CED6
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734772294;
	bh=flgH9kGUEUUdU5GGIoLcecbOKpZ/9P71he8YGiVnKlw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=t8fL2qOKGbTnhMv9a04sUoTFR28WY+/BLHluuRKR37EYbGg53O2FD1WfWe3KQLxZc
	 7Dwvc0LB9ltuJBs43LTlmVOGagHJy9mTid+EqiR3CFecyFv/6e/h/1EPaa7RqGcU4J
	 WMqZi5whEsL14ppW0zd2M4KWbaOZh4qYKIqb5KbWphrL+IpNhiW/+V3nURknPPf1gu
	 llSv0csshe+x4l0Y8n4fO9xHdtQmGeb+9dQA2IgrePYPw1Z2PBLo+veq/ZBbIce3SN
	 hdf/161PNFpzaYyO2M4uFzC9ciCB8ZtRCIhuNmVDcQcTEOzpd1UiFmitP1em1BiTra
	 5lljalwi2kAVQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 17/29] crypto: arm/ghash - use the new scatterwalk functions
Date: Sat, 21 Dec 2024 01:10:44 -0800
Message-ID: <20241221091056.282098-18-ebiggers@kernel.org>
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

Use scatterwalk_next() which consolidates scatterwalk_clamp() and
scatterwalk_map(), and use scatterwalk_done_src() which consolidates
scatterwalk_unmap(), scatterwalk_advance(), and scatterwalk_done().
Remove unnecessary code that seemed to be intended to advance to the
next sg entry, which is already handled by the scatterwalk functions.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/crypto/ghash-ce-glue.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index 3af997082534..9613ffed84f9 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -457,30 +457,23 @@ static void gcm_calculate_auth_mac(struct aead_request *req, u64 dg[], u32 len)
 	int buf_count = 0;
 
 	scatterwalk_start(&walk, req->src);
 
 	do {
-		u32 n = scatterwalk_clamp(&walk, len);
-		u8 *p;
+		unsigned int n;
+		const u8 *p;
 
-		if (!n) {
-			scatterwalk_start(&walk, sg_next(walk.sg));
-			n = scatterwalk_clamp(&walk, len);
-		}
-
-		p = scatterwalk_map(&walk);
+		p = scatterwalk_next(&walk, len, &n);
 		gcm_update_mac(dg, p, n, buf, &buf_count, ctx);
-		scatterwalk_unmap(p);
+		scatterwalk_done_src(&walk, p, n);
 
 		if (unlikely(len / SZ_4K > (len - n) / SZ_4K)) {
 			kernel_neon_end();
 			kernel_neon_begin();
 		}
 
 		len -= n;
-		scatterwalk_advance(&walk, n);
-		scatterwalk_done(&walk, 0, len);
 	} while (len);
 
 	if (buf_count) {
 		memset(&buf[buf_count], 0, GHASH_BLOCK_SIZE - buf_count);
 		pmull_ghash_update_p64(1, dg, buf, ctx->h, NULL);
-- 
2.47.1

