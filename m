Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CC722C36E
	for <linux-crypto@vger.kernel.org>; Tue, 10 Dec 2024 23:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733875150; cv=none; b=lKXvOgHHrVklDm7JU+vZhuODv/dopvRN59yM9FEnUhM25Yt7o/FQJHqinCQh4meFuxz8zJSk1G1/MUEQXEoAx5o4VnBZBLrZaZadOvLTT3VzPG2kZvRqpA9kZgyXQpBbzInT86QyHdoIPzXFdHijtpIstUoKLe1RpZOX5Mbk6RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733875150; c=relaxed/simple;
	bh=roscPuA9UjIXPEx3TkJZPsedVDwX9liM0Ge5TCmHKb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RaHA9tQT4YJE9WnYlDaemiXO/+l6VhNnjmlYgY6Fe7bb6nPMFhTUyYeNeUxsIrA0vwt5RKD6HvoFn+f5zv6SaIv1VSE6in/lGOcJD1m/Sst8NeAqjUuo7kvAnaUj+1D0AxckZe/tlegDCpCrY7MXVKzAv+scRVHdlEx4lBm7ge4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ugmrz+CR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ugmrz+CR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95075C4CEDF;
	Tue, 10 Dec 2024 23:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733875149;
	bh=roscPuA9UjIXPEx3TkJZPsedVDwX9liM0Ge5TCmHKb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ugmrz+CRopVVNuDEBZY4cmYimjNDTYP0AhlobLrKeuZxm1T3P8y13iAFKVTDio/vW
	 LWOYr16fCS7zkgOMT7DdQEN+9e2RXZ591IoNBtcoflOnAvr/O+ix6yPjjOkX9RcnLe
	 iuCK2ZxxWcfmyUvaaMc76HaSaheeFMh/0NXaZWNzLfiTvPtD79YeT49onR4alYqEOX
	 agDGAst+8X/X+Dq2UlC4fyQIVzZKxOZ+/emh28G+Y8c5Dn4Fdyl95xR6sTcxy33Eef
	 MZaSDX9TEq3iJYv+izXMC05LJiIfTpcxCwd7xuJfDUAESGZAcuiZVfTbtt3SPFazjP
	 sKmAWs8ze5zQA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org
Subject: [PATCH 3/7] crypto: x86/aes-xts - use .irp when useful
Date: Tue, 10 Dec 2024 15:58:30 -0800
Message-ID: <20241210235834.40862-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241210235834.40862-1-ebiggers@kernel.org>
References: <20241210235834.40862-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Use .irp instead of repeating code.

No change in the generated code.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aes-xts-avx-x86_64.S | 50 +++++-----------------------
 1 file changed, 9 insertions(+), 41 deletions(-)

diff --git a/arch/x86/crypto/aes-xts-avx-x86_64.S b/arch/x86/crypto/aes-xts-avx-x86_64.S
index 48f97b79f7a9c..63e5d3b3e77f5 100644
--- a/arch/x86/crypto/aes-xts-avx-x86_64.S
+++ b/arch/x86/crypto/aes-xts-avx-x86_64.S
@@ -110,43 +110,17 @@
 
 .macro _define_aliases
 	// Define register aliases V0-V15, or V0-V31 if all 32 SIMD registers
 	// are available, that map to the xmm, ymm, or zmm registers according
 	// to the selected Vector Length (VL).
-	_define_Vi	0
-	_define_Vi	1
-	_define_Vi	2
-	_define_Vi	3
-	_define_Vi	4
-	_define_Vi	5
-	_define_Vi	6
-	_define_Vi	7
-	_define_Vi	8
-	_define_Vi	9
-	_define_Vi	10
-	_define_Vi	11
-	_define_Vi	12
-	_define_Vi	13
-	_define_Vi	14
-	_define_Vi	15
+.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+	_define_Vi	\i
+.endr
 .if USE_AVX10
-	_define_Vi	16
-	_define_Vi	17
-	_define_Vi	18
-	_define_Vi	19
-	_define_Vi	20
-	_define_Vi	21
-	_define_Vi	22
-	_define_Vi	23
-	_define_Vi	24
-	_define_Vi	25
-	_define_Vi	26
-	_define_Vi	27
-	_define_Vi	28
-	_define_Vi	29
-	_define_Vi	30
-	_define_Vi	31
+.irp i, 16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
+	_define_Vi	\i
+.endr
 .endif
 
 	// V0-V3 hold the data blocks during the main loop, or temporary values
 	// otherwise.  V4-V5 hold temporary values.
 
@@ -616,19 +590,13 @@
 	_vaes_4x	\enc, 0, 2
 .Laes192\@:
 	_vaes_4x	\enc, 0, 3
 	_vaes_4x	\enc, 0, 4
 .Laes128\@:
-	_vaes_4x	\enc, 0, 5
-	_vaes_4x	\enc, 0, 6
-	_vaes_4x	\enc, 0, 7
-	_vaes_4x	\enc, 0, 8
-	_vaes_4x	\enc, 0, 9
-	_vaes_4x	\enc, 0, 10
-	_vaes_4x	\enc, 0, 11
-	_vaes_4x	\enc, 0, 12
-	_vaes_4x	\enc, 0, 13
+.irp i, 5,6,7,8,9,10,11,12,13
+	_vaes_4x	\enc, 0, \i
+.endr
 	_vaes_4x	\enc, 1, 14
 
 	// XOR in the tweaks again.
 	_vpxor		TWEAK0, V0, V0
 	_vpxor		TWEAK1, V1, V1
-- 
2.47.1

