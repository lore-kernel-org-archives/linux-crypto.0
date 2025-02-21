Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A032AE89;
	Fri, 21 Feb 2025 11:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740137649; cv=none; b=NaXxw/XR4y0e/9Vsq2dSvjZXfUeiovNk2pLx6ptU3mMT3hWa5QdxRicHguDkiXoOvoZMdTHovQ558giglErAiZjYdBTVC3K2baxlOmViSZQIJYiiwJ2bCP0Vq4nIntHYNAdLVBDSeiSvOWsch0Y2aWO1VKRvQ6D4jUHXNyMr35c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740137649; c=relaxed/simple;
	bh=OS9hY96E/r8fylEp9fwxYpkQLLw5dBFt3WyoGpksN6I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FeR3n8PDabA07aM/KGdp6OldDvj0gmsLEk6IyD5CDMIRw7azqj8IV3poTVkQGlJc8pWVeJ+jUfjLJnZ7wJO31u/qeuda46951LuI7+dibZY6H+8LB9zrBCf4qyieMsCuZ4mL+eUHL7sh8NeGRHw8J3Qejc7F6Jueqv8bzLNKVhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=amq0o053; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="amq0o053"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xry111.site;
	s=default; t=1740137647;
	bh=Cc8ye2VMQWy+pBTH7jzTDaj20fNnEg8wmnHIfxMAHh8=;
	h=From:To:Cc:Subject:Date:From;
	b=amq0o05359nZly4KUjcES+dsDoBoRWd42N1782YEbjVd7UEBtI2L5JF0TbIJG8KzU
	 pzQLPcngYjmPkOoVJNLLmQaVdeEJRAC17ywo0O+86sQI4TdamXmX9SCHhc+UlJX2Yp
	 mNJE9vQDNHKQP9detTCqWxIRgZpk9CRrsDn2HJRU=
Received: from stargazer.. (unknown [IPv6:240e:454:4311:1f25:535e:dcbe:c175:b1da])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id CCC45664E4;
	Fri, 21 Feb 2025 06:34:01 -0500 (EST)
From: Xi Ruoyao <xry111@xry111.site>
To: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-crypto@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Xi Ruoyao <xry111@xry111.site>
Subject: [PATCH] LoongArch: vDSO: vgetrandom-chacha: Make use of the t8 register
Date: Fri, 21 Feb 2025 19:32:43 +0800
Message-ID: <20250221113341.108063-1-xry111@xry111.site>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

So we don't need to reuse a register and rematerialize a constant.  I
couldn't count :(.

Signed-off-by: Xi Ruoyao <xry111@xry111.site>
---

Tested with vdso_test_getrandom and vdso_test_chacha.

 arch/loongarch/vdso/vgetrandom-chacha.S | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/loongarch/vdso/vgetrandom-chacha.S b/arch/loongarch/vdso/vgetrandom-chacha.S
index c2733e6c3a8d..c4dd2bab8825 100644
--- a/arch/loongarch/vdso/vgetrandom-chacha.S
+++ b/arch/loongarch/vdso/vgetrandom-chacha.S
@@ -58,9 +58,7 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
 #define copy0		t5
 #define copy1		t6
 #define copy2		t7
-
-/* Reuse i as copy3 */
-#define copy3		i
+#define copy3		t8
 
 /* Packs to be used with OP_4REG */
 #define line0		state0, state1, state2, state3
@@ -99,6 +97,7 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
 	li.w		copy0, 0x61707865
 	li.w		copy1, 0x3320646e
 	li.w		copy2, 0x79622d32
+	li.w		copy3, 0x6b206574
 
 	ld.w		cnt_lo, counter, 0
 	ld.w		cnt_hi, counter, 4
@@ -108,7 +107,7 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
 	move		state0, copy0
 	move		state1, copy1
 	move		state2, copy2
-	li.w		state3, 0x6b206574
+	move		state3, copy3
 
 	/* state[4,5,..,11] = key */
 	ld.w		state4, key, 0
@@ -167,12 +166,6 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
 	addi.w		i, i, -1
 	bnez		i, .Lpermute
 
-	/*
-	 * copy[3] = "expa", materialize it here because copy[3] shares the
-	 * same register with i which just became dead.
-	 */
-	li.w		copy3, 0x6b206574
-
 	/* output[0,1,2,3] = copy[0,1,2,3] + state[0,1,2,3] */
 	OP_4REG	add.w	line0, copy
 	st.w		state0, output, 0
-- 
2.48.1

