Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44BB2CAB
	for <linux-crypto@vger.kernel.org>; Sat,  6 Apr 2024 00:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712363287; cv=none; b=mh2gmzAIBPOjv117KAhhS0u9GWnThti5mh4LI/bKTAooU5/RAmZA1rm6rKoEWSdQFd9UNGC55jiU0ZN5nIOwNUN8QyuZQ8CI6m8u0L8olv8EI8/CjGcAIU4LajFvqU2ySQ2dIB1xvxM10gBOiLuXujuYdpDixezSS3Ljfuudmeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712363287; c=relaxed/simple;
	bh=HyTNCHwRiyVtvVQuLZycGw9jDb9+G3ZiYKXX8g+LLzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gw0PRxU3fD1KKTbbS6IyHhSl6MvV5ayKizxZRiiWf7Pcx0t6ARnfxyIxEVum5P4mDZ+raOFvMSgTp19xpdFXSmf4/lQS2/Oqm2twb1AnTS2Av2TpPAJgDcmz6NQmnpbeknPWMVTnewOXPuUphH5DM6nf3r/k0leOqDrvRAR2hbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oiG72Znk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oiG72Znk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C740C433C7;
	Sat,  6 Apr 2024 00:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712363286;
	bh=HyTNCHwRiyVtvVQuLZycGw9jDb9+G3ZiYKXX8g+LLzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oiG72Znkk++15W67rpieOoJVY/oNvdA7TZirv9GYFzvoI2eXccs8zWoT0uvvMdBi3
	 9S3etXilgrjDUY6SEYR7qzxF/1SGpy1n1dC1rdD/2Mpc5GCtKk8EevaUdEcnDSaVOY
	 sLR1ltkRjBSBEI8iUOInl5vD1zSVP9duEr9UfXqUbqepBMx1v7LOkJTAjvsSXCeAUF
	 1YLMpApKmUXUk/XB4QRtPKXazLPzlvdgbVpuukS3Jmg2w3mf+vA34AA+t6t5G9JKbC
	 fdsj/0jnBnIFWFSSwBH4zwO7YhYlWlMPsCO/D67NaoQLdRTAiPPF8/4hW6lkzgA+TZ
	 tWP/m1IBdzS0Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 3/3] crypto: x86/sha512-avx2 - add missing vzeroupper
Date: Fri,  5 Apr 2024 20:26:10 -0400
Message-ID: <20240406002610.37202-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240406002610.37202-1-ebiggers@kernel.org>
References: <20240406002610.37202-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Since sha512_transform_rorx() uses ymm registers, execute vzeroupper
before returning from it.  This is necessary to avoid reducing the
performance of SSE code.

Fixes: e01d69cb0195 ("crypto: sha512 - Optimized SHA512 x86_64 assembly routine using AVX instructions.")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/sha512-avx2-asm.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/crypto/sha512-avx2-asm.S b/arch/x86/crypto/sha512-avx2-asm.S
index f08496cd6870..24973f42c43f 100644
--- a/arch/x86/crypto/sha512-avx2-asm.S
+++ b/arch/x86/crypto/sha512-avx2-asm.S
@@ -678,10 +678,11 @@ SYM_TYPED_FUNC_START(sha512_transform_rorx)
 	pop	%r14
 	pop	%r13
 	pop	%r12
 	pop	%rbx
 
+	vzeroupper
 	RET
 SYM_FUNC_END(sha512_transform_rorx)
 
 ########################################################################
 ### Binary Data
-- 
2.44.0

