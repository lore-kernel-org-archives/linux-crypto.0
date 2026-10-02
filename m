Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507C6282F09;
	Fri,  2 Oct 2026 03:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790912664; cv=none; b=E5FPEREMmDyVkBKbtz3tPE/gXeZEBAxmKcES6rwsLIfBk7vL7pgyRoXxlBW/dIE/S+EwxFU7OXeY88lCqN2GsSnSS4qYfVlYRVGAt69/+06HopKozqst6BLhv2MiDxMTnpb286j9RwiBCGvkQkukazXgcMrpH7eGWEe0yo5Ujws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790912664; c=relaxed/simple;
	bh=+DOhqr+poTlo3urZ1ftfzIxp7WmCdCeRGqyE7G3eVec=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sZXUOS1a09VlxQevwHLgZ9EK8HLEtB3uTvgzevSX6Quc+oMqyl7x16j9lielK7xTemZoQIYuNO30mTGko1xvVI1EJqVDJ5brS9SIGgjg+rqwNcAUcRBfpyyWLqS9Z7TC05eSrS7sUZA5Spip+Dojv7Uo/K1r/My+KIRCit3OJMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JpKlurud; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JpKlurud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B931F1F000FF;
	Fri,  2 Oct 2026 03:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790912662;
	bh=/ynodn5OHWC4jZ9SKMczWLDATY/LtrHJOagsrGndSEk=;
	h=From:To:Cc:Subject:Date;
	b=JpKlurudV/TDQsEqat8WQy5NBC3zE9xyHbS1xQboGvPrSUM+xhKP1Y/qhWFKZ1tWx
	 DbtG9foZ3xKZgvV9l3WmG+nQMyy1KAWBtiAy/Snngo4a3qjwWOODlG/qCpRtOfueab
	 AohRG8Hsz2BOUjhBMpfLJ4zRtNgznBpmZlY+5D++ryD/FzUqS2u+COIU5p2UwX5nke
	 z00bc5R9N770KMPzwykSmvR9h4/Jc4uil+GNmQcNTZpffZ7ALGTbRKq4JQoI/wjHAB
	 HL0nFtaH3wHH3fwD96dnIWOGkxsL0KFnlTExNTgeGHlM5c4L7z5+yWKXUvVLwhY7vq
	 7X0R3KAZyCM6Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: x86/aes-ctr: Remove some unreachable code
Date: Thu,  1 Oct 2026 20:44:05 -0700
Message-ID: <20261002034405.49886-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the AES-CTR and AES-XCTR code that handles a remainder of '4*VL < LEN
< 8*VL', first 4 full vectors are processed, leaving 0 < LEN < 4*VL.
After that, five different cases are handled depending on whether there
are 0, 1, 2, 3, or 4 full vectors remaining.  But the case of 4 vectors
is never reached there, making the code handling it unused.  Remove it.

With that done, the '.Lxor_tail_partial_vec_3\@' block would be reached
only via an unconditional jump.  Therefore, relocate it to the only
place that jumps to it.  This allows removing the jump at the end of the
'.Lxor_tail_partial_vec_2\@' block and making it fall through.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/aes-ctr-avx-x86_64.S | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/lib/crypto/x86/aes-ctr-avx-x86_64.S b/lib/crypto/x86/aes-ctr-avx-x86_64.S
index c232337899b6..13b3e2cfae37 100644
--- a/lib/crypto/x86/aes-ctr-avx-x86_64.S
+++ b/lib/crypto/x86/aes-ctr-avx-x86_64.S
@@ -419,10 +419,12 @@
 	cmp		$3*VL-1, LEN32
 	jle		.Lxor_tail_partial_vec_2\@
 	_xor_data	2
-	cmp		$4*VL-1, LEN32
-	jle		.Lxor_tail_partial_vec_3\@
-	_xor_data	3
-	jmp		.Ldone\@
+	add		$-3*VL, LEN32
+	jz		.Ldone\@
+	sub		$-3*VL, SRC
+	sub		$-3*VL, DST
+	_vmovdqa	AESDATA3, AESDATA0
+	jmp		.Lxor_tail_partial_vec_0\@
 
 .Lenc_tail_atmost4vecs\@:
 	cmp		$2*VL, LEN32
@@ -469,14 +471,6 @@
 	sub		$-2*VL, SRC
 	sub		$-2*VL, DST
 	_vmovdqa	AESDATA2, AESDATA0
-	jmp		.Lxor_tail_partial_vec_0\@
-
-.Lxor_tail_partial_vec_3\@:
-	add		$-3*VL, LEN32
-	jz		.Ldone\@
-	sub		$-3*VL, SRC
-	sub		$-3*VL, DST
-	_vmovdqa	AESDATA3, AESDATA0
 
 .Lxor_tail_partial_vec_0\@:
 	// XOR the remaining 1 <= LEN < VL bytes.  It's easy if masked

base-commit: 9ca77aa621027149c43551308112eba06b1de3af
-- 
2.56.0

