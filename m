Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80501418A54;
	Tue,  1 Sep 2026 14:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788274696; cv=none; b=TZSbQvMM1d5G9gwdfybuY+C5A5GnvIjvYEdNZ4+rvT+V+4La8gekhhLN/pePJBbOiLlKUHM2360dhiuZ/7DmEKwVkItK64F5nSWIrxsfPdsauuT/DFfPYR8u/icCGFaHCS36xSDCZlunniR6+8XgpuDK4tEoL+O66EjSoZ9Ue2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788274696; c=relaxed/simple;
	bh=bURSDeOHD7BeXhOUO95qSmh0YND+CXXzB5NqaBliqI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dn68j80ML1ioIKMLKgIAryxHiLrmnJBUGSxwKYO3lJ+FAJUtoYChGCAv1FHm5oEshgsSsX6Mt+giEV+y4jUiKeOUiwrEFrucy8F0CfVAjA6AyRiO931kpHlbQNrJmoCYZ61Uwp4UqCsh6eajvV5lSg+XdyrkYvJbXiY4i/AC8RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VhSj3+Bk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VhSj3+Bk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31C61F000E9;
	Tue,  1 Sep 2026 14:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788274695;
	bh=CGFmBktDb18Ou8jdzee9BRhN2jpwroPuYWGDnSphFl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VhSj3+BkQtVSyy/0a/UXLwqRnLqlZyrvWJvJ4DMKYKWfTyH44WJT6jDdHbynwgnaD
	 itgUcs3lXcrGXsGbeu20U2B2c8yr5dwKlpIrTcTIUg65IWx+T7wNL6jJ9fxhYw72t9
	 N0V+CEFK7uD5kXrBPhTbQ2AowtyQdCNIZabPOBnzEIgZL1k0LiwshRwTTVGmPOvlqf
	 dkrgnah1pNjTN2z75fEFLOXowZHGWm/M9uf+2BQy3fPxIrRgBvmie5g/8AzFbWCpXr
	 xIg0isQ71KxHd9h8LmQZ9X6qwtH2UaMIlFXJWJKIfVOPWviFWrQ4xP+iYFQPiJqyyV
	 zyPDQqoaEEG2A==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v5 7/8] xor: Remove redundant X86_FEATURE_OSXSAVE check
Date: Tue,  1 Sep 2026 07:57:39 -0700
Message-ID: <20260901145740.42337-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901145740.42337-1-ebiggers@kernel.org>
References: <20260901145740.42337-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

X86_FEATURE_AVX implies X86_FEATURE_OSXSAVE already.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/raid/xor/x86/xor_arch.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/raid/xor/x86/xor_arch.h b/lib/raid/xor/x86/xor_arch.h
index 99fe85a213c6..991abe3f4bbd 100644
--- a/lib/raid/xor/x86/xor_arch.h
+++ b/lib/raid/xor/x86/xor_arch.h
@@ -18,8 +18,7 @@ extern struct xor_block_template xor_block_avx;
  */
 static __always_inline void __init arch_xor_init(void)
 {
-	if (boot_cpu_has(X86_FEATURE_AVX) &&
-	    boot_cpu_has(X86_FEATURE_OSXSAVE)) {
+	if (boot_cpu_has(X86_FEATURE_AVX)) {
 		xor_force(&xor_block_avx);
 	} else if (IS_ENABLED(CONFIG_X86_64) || boot_cpu_has(X86_FEATURE_XMM)) {
 		xor_register(&xor_block_sse);
-- 
2.55.0

