Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0CFA50
	for <linux-crypto@vger.kernel.org>; Sat,  6 Apr 2024 00:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712363285; cv=none; b=TGrKkONuldE+bHR6+t2N1SIOTfmSJLZbBUxMM/N6ekhfUuuAXE1bYqDD+oeLTRM1jc5h4MS8v2m4WUm9bB9Ut0vLrLMI1JlTk7eVI4JGYWPfo0kkiiWyL8vF3EnDP9FqpX2SdcFtPmws0gpcs6EICoe5BMGA6dKFwGPbnhMBvrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712363285; c=relaxed/simple;
	bh=aOzuonNLlnJXwWBEwSgEzvclltWB5nPogY4JWBW1pH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWU/hGMcQ5uHBkHkAXA4X6KJJulTTViJvG5oSEgaVdlIcllkErMoM6fZbqzt22szpQZI3zE37+EW8VqGSpdF4SzILj81j2/MKXs9WGVFg0UoSpwhTq6gIv/DVIfEYx6tY+UXtWfYC4aRDXEYRUhXOuhO7HEOaHDV0taO/ES6Ha4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cTO2WAk3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cTO2WAk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41DA4C43394;
	Sat,  6 Apr 2024 00:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712363285;
	bh=aOzuonNLlnJXwWBEwSgEzvclltWB5nPogY4JWBW1pH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cTO2WAk3em3FSnaF/wPo3bwxFCVaGIMotrc++Bz1leL1NRLreOSWgEwnlER2UcLhq
	 vHvZfeW18oheooXKChi38rRZulctSlB/aTdyJnExSBSkqCsOxmDfsR9kqTDfJTJL2g
	 uZX86oLFhPb0QLHFgct1BYd2nLyny/Rnq+8bEWDYOueF/x6MUFRbfWhOicr2qHCvIU
	 pv6C7+LhWO5OAUzzEtDeMQhV++UJJhNqxL6kvWuNLaIYJkwV+NuXuUxHeQRgfvEMyz
	 ke3BC8MmSbO3i7CrtMMsYKUwRloooaA9Tum4Bgi6IyUat02coQXLXB3ceWjZtqr9pR
	 VDU5PjWZhxf9w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 1/3] crypto: x86/nh-avx2 - add missing vzeroupper
Date: Fri,  5 Apr 2024 20:26:08 -0400
Message-ID: <20240406002610.37202-2-ebiggers@kernel.org>
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

Since nh_avx2() uses ymm registers, execute vzeroupper before returning
from it.  This is necessary to avoid reducing the performance of SSE
code.

Fixes: 0f961f9f670e ("crypto: x86/nhpoly1305 - add AVX2 accelerated NHPoly1305")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/nh-avx2-x86_64.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/crypto/nh-avx2-x86_64.S b/arch/x86/crypto/nh-avx2-x86_64.S
index ef73a3ab8726..791386d9a83a 100644
--- a/arch/x86/crypto/nh-avx2-x86_64.S
+++ b/arch/x86/crypto/nh-avx2-x86_64.S
@@ -152,7 +152,8 @@ SYM_TYPED_FUNC_START(nh_avx2)
 
 	vpaddq		T5, T4, T4
 	vpaddq		T1, T0, T0
 	vpaddq		T4, T0, T0
 	vmovdqu		T0, (HASH)
+	vzeroupper
 	RET
 SYM_FUNC_END(nh_avx2)
-- 
2.44.0

