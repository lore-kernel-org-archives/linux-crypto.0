Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D58175AE
	for <linux-crypto@vger.kernel.org>; Mon,  7 Oct 2024 01:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728264298; cv=none; b=V/yaTTv8HIdIuC/bn3o+H7GcDwLRf/1c4qBu3MXAMaWMAMD62mNwIU/IzeZHm+FxEpvko5pxAK23c+cgY/44pQMrm34DmKxeJPII6whx0a5wlROq2nKu69Fv8DjcYAzcT0GoV8hY8CPwT+VikBF7olwovmoJsp8wAdRCQGesyrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728264298; c=relaxed/simple;
	bh=fSfzw890ze1jClqifVSPYJ9E3yn1ff9x7i5uiQyp+/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+ncOaphzUR74phUlWKkuMuNqbAYNA9M86stdPlvf3wvjp4FmBfPuRtqCO+LpZC/3TS0AQn7d6m4PrxDFkB061edp0lREjAw0DPdNrhML+t/iZ45P19arT1z7MYKmw0gmiESc+yWc8iDpBzjD1pD6MOtisYJpxSrvJmMn+B/fWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=akOx/DcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="akOx/DcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EFC7C4CED2;
	Mon,  7 Oct 2024 01:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728264298;
	bh=fSfzw890ze1jClqifVSPYJ9E3yn1ff9x7i5uiQyp+/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=akOx/DcLTl59EkqSuD9tZsXpeDCMmMU8QQDPpovnnGBl7Ffe2sdFFo3s9o5koAzbH
	 qPMnWlnH3FBManKdYgecsywxrFH7OCQ9/A+O/2uz/U41yGbFjbSHO903H8a58AAxTD
	 WD7cHFIP1kvJgue+cShvrSN69p1U6Lkyuc3HpEguMCtZ86r+Owx/10ifXXLAjOFGVU
	 cN1Kmt15Pi6/pcx1YY8eZXZsIITWlwbyiyDzx2xM/LOArmuPtMB2rUGuVC5cQd3AmL
	 RszFeVsfuYUpA8l0td9mLzlEgZcBOV3GYUiBAyPSQ24g/A2XqnuedEy9p+VSw6Lq63
	 T0tpLSjkMkYJQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 10/10] crypto: x86/aegis128 - remove unneeded RETs
Date: Sun,  6 Oct 2024 18:24:30 -0700
Message-ID: <20241007012430.163606-11-ebiggers@kernel.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241007012430.163606-1-ebiggers@kernel.org>
References: <20241007012430.163606-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Remove returns that are immediately followed by another return.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aegis128-aesni-asm.S | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-asm.S b/arch/x86/crypto/aegis128-aesni-asm.S
index e025c6bfadbd..c899948d24c9 100644
--- a/arch/x86/crypto/aegis128-aesni-asm.S
+++ b/arch/x86/crypto/aegis128-aesni-asm.S
@@ -276,12 +276,10 @@ SYM_FUNC_START(aegis128_aesni_ad)
 	movdqu STATE1, 0x00(STATEP)
 	movdqu STATE2, 0x10(STATEP)
 	movdqu STATE3, 0x20(STATEP)
 	movdqu STATE4, 0x30(STATEP)
 	movdqu STATE0, 0x40(STATEP)
-	RET
-
 .Lad_out:
 	RET
 SYM_FUNC_END(aegis128_aesni_ad)
 
 .macro encrypt_block s0 s1 s2 s3 s4 i
@@ -369,12 +367,10 @@ SYM_FUNC_START(aegis128_aesni_enc)
 	movdqu STATE0, 0x00(STATEP)
 	movdqu STATE1, 0x10(STATEP)
 	movdqu STATE2, 0x20(STATEP)
 	movdqu STATE3, 0x30(STATEP)
 	movdqu STATE4, 0x40(STATEP)
-	RET
-
 .Lenc_out:
 	RET
 SYM_FUNC_END(aegis128_aesni_enc)
 
 /*
@@ -504,12 +500,10 @@ SYM_FUNC_START(aegis128_aesni_dec)
 	movdqu STATE0, 0x00(STATEP)
 	movdqu STATE1, 0x10(STATEP)
 	movdqu STATE2, 0x20(STATEP)
 	movdqu STATE3, 0x30(STATEP)
 	movdqu STATE4, 0x40(STATEP)
-	RET
-
 .Ldec_out:
 	RET
 SYM_FUNC_END(aegis128_aesni_dec)
 
 /*
-- 
2.46.2

