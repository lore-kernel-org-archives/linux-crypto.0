Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807B315F3E6;
	Wed, 28 Aug 2024 17:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724864636; cv=none; b=Grh1JUoUM9R8suMLqbA0jZ/qOYqJQOm85HVS901WGcf3BT4eSwAguwlu/MlobopN9cUSSw4SXs5XlVxD30MaYy1xwu+pnaEL/8y/Or/8VJVjYI8yhAJBbd1uO64mo5MUuX5gfWgZaUHA3uI19wh40HT8We1V7tkZ9nKYkG6bu2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724864636; c=relaxed/simple;
	bh=n819NHCxtnhnw1i53ckId8OAwuQolpEzr4GYYZZH2sE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HgqU1WC928HvVU8AJ7U/YZL3SgLivOdHVlmfTe3Xgh8HTJ7ujK+16WdvNFoYC065N++Pzkg9rEH+YJqoaNR+DG11gL7g/IHpM2rpIDFDuQ/2Otsk3SYKi6P5XpHm8E0V+Izm1rE2+vwbrmyuCTKgHnvI9XXrHxmW98l0bbVSKQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=XRUBu5Xh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="XRUBu5Xh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969FDC4CEC0;
	Wed, 28 Aug 2024 17:03:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="XRUBu5Xh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1724864634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fnlf4Nn0q79QyDN//xTaS0uYdOMz1VYesQkx3XoquQo=;
	b=XRUBu5Xhs4SJzVjQpxnUgwxRhcHayZNlUeTN6nw+++fxV3sDUWZ7NaQYh1vensiP/6l+hP
	np888uoOXxZLON2r2XomwGeD4LE2+qzSpliX6NGGqayEpD5ZSRl9mXHMjNHzchvbq4Bu5Z
	1OIpl2+iUTFD+B0CNjFhqtQ9WGOqLhM=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9dce1b26 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Wed, 28 Aug 2024 17:03:53 +0000 (UTC)
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	christophe.leroy@csgroup.eu
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] random: vDSO: assume key is 32-bit aligned on x86_64
Date: Wed, 28 Aug 2024 19:03:50 +0200
Message-ID: <20240828170350.3422587-1-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The prototype of this function ensures a u32* type for the key, and all
uses of it are using state->key, which is a u32 array. When userspace
slices up a memory region into an array of states, it does so using a
state size that also ensures the alignment. So it's safe to assume that
the key is always 32-bit aligned. That in turn means it's possible to
use movaps instead of movups for loading the key.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/x86/entry/vdso/vgetrandom-chacha.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/vdso/vgetrandom-chacha.S b/arch/x86/entry/vdso/vgetrandom-chacha.S
index bcba5639b8ee..07ae91dcdbda 100644
--- a/arch/x86/entry/vdso/vgetrandom-chacha.S
+++ b/arch/x86/entry/vdso/vgetrandom-chacha.S
@@ -43,8 +43,8 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
 	/* copy0 = "expand 32-byte k" */
 	movaps		CONSTANTS(%rip),copy0
 	/* copy1,copy2 = key */
-	movups		0x00(key),copy1
-	movups		0x10(key),copy2
+	movaps		0x00(key),copy1
+	movaps		0x10(key),copy2
 	/* copy3 = counter || zero nonce */
 	movq		0x00(counter),copy3
 	/* one = 1 || 0 */
-- 
2.46.0

