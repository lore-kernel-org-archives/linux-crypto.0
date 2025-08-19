Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F998318137;
	Tue, 19 Aug 2025 08:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755593964; cv=none; b=GNkPiBcag5WdrDG7LzsN1j9feJ5yPA5d3jMrcpcT2wW6OC0Icoqia6NKyrtk2tp3nd4gbgt+Kyme6pQHZeAvAk54JXzznwUp+QulhAav6UIaWIveMZdNKT7UXq/uO2Ll7ktkefXPa7wAUIvjdLX8WYOSr+RYFz2aBh2azNAuAjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755593964; c=relaxed/simple;
	bh=i9rbyPwb+o3Fd4RJ1MYMmCM6KP5DIlWyzXLk2g4/5I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+t4kHPD1ZoCDzao7Hyw2peteHBGCj3JCLmv+Z2UH23YkhfrnRBQo+3SbZrIpM5pOeKeyBi3r6WM0IJOp4oy7nFoEB1P+D2Rqmthj+kR3vuwAV8OODce8g5Z1ons0cZcoXX4SGsgWH6r5Cza4mcnGv5TDP909Nn2L6iVUYOlfZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E+QYepEt; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E+QYepEt"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3b9d41c1964so3372070f8f.0;
        Tue, 19 Aug 2025 01:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755593960; x=1756198760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7pY8YB+h7Jx+Q+nTzqn1TwHe2CurBONvGCQSfi/C3Og=;
        b=E+QYepEt9mizuSUO+ccAOvCbA08o9aEmT+guRQA5k6ds2CroTvqRE2s3xeiDDABgt/
         w6TcPZdAtzaLdhixGlK5912LnSK22KZFoRwxF5DZi3rM395KfKcNEbGcyIQMgggK8H/o
         uiUo5qs3YIRpfT8br5t0T8Cn0oK9bYUAlxjWXz9CnqunadnmXuHCT39KEkFRxxhixBDB
         Frd6A8eQKHpL6Hf1/T8oLTTIx1KL3voUfJYk0hwLRvI4OQ5EpNtmn780CVB9bW43ZF3s
         mOuucHIX904faBWQfZubiPmmknten6nygeRhT8iRUCsL+HjuUAaYuqT/2Zm2Gb5Vhfq+
         itVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755593960; x=1756198760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7pY8YB+h7Jx+Q+nTzqn1TwHe2CurBONvGCQSfi/C3Og=;
        b=RGGJ5Dh8u+ezN6QOAcnBN8EUXmyGnEIlD9zW6kDiYb0IRaAB70SLAXFcrqSnwbhoOc
         gm8U/zv5bRMQG+FI7iHtwGg6mA32u/FioJ/Ct+rmFTkTwv73ZrNktmD3dccPCto1txUt
         IjfL3ygXYfrXKtfd+KkhIJuXuQevuydxlo8gDUM/PIbLicV3PJ4VDbqS02Swo9VYgyk1
         lDwV9TXWj2EFB8B0pRwvNkougwMt21uU5PCoNmrOsaiMd0G9pdGkfxb0LZO8oxyOq8Nj
         aO93uZdF/AOPodVbRF01YqTne7x1b/AdCzsF2WXnO/z50ydHHq9h2Uo0+Ojfd/BjDbo+
         QYYQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8fVbFph1UbCr7Vd8vbuIU98oQejCbyUQnFUcLT/HyqakeqAdYeeIhTeI6OnuFhd454tUdow/h63ajOhM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzezlskRsix/hP3gBOfM0Yd4HgWgc27lDQFcNA2jr3eS4n3KlE2
	eDxHEJ+t+qaJ5rQhmgW4gnaM+241XEUPUVxuxr9fwHVStpH6eVyyVk28U7diqw==
X-Gm-Gg: ASbGnct4lqpJHU6VhkzmY1qW5f31pxDa9HLxZ9lK1hmpYfpFW31+bEsVcp1qQ2DzPNb
	eOwyLirf/uLaCPmn/cEHIINPGDeLp9wgt0lFNpFCFQ75EdSX8A0vqgvbk1bhfFFinXgAoGdOFYS
	A/5aYdgqDvsCHpQsHIhbz9jfSsqrHe7/zqRgZgVfN/d0fC3AjUCqYmXY1YcaOxxqa7fp3q10IjF
	VLem8OqZeLRdNZMvGjh/BIW//V0GGbblR992C/ugRvBuMe9pwd8SymDc/kDtc8w3ZY8lILDIUTv
	qk0E/49HED5wZ8kExcMr8VTE7qbH5mVD8/5nNYE/EZPCEVFn4WGWBCZKwmyTTHwGJW9EDC+BmBx
	6LthMmnJAo+WmkKTSgHa3uA==
X-Google-Smtp-Source: AGHT+IGTAgQeFPbSJNT7TmNCMl+V4Kkitl4Ms2H0vZ/7pL/RnnR4/yloGe6oJ9WjDIlBy+TfIPqiYQ==
X-Received: by 2002:a05:6000:2010:b0:3b8:d115:e6c7 with SMTP id ffacd0b85a97d-3c0eca48ad8mr1159282f8f.33.1755593960294;
        Tue, 19 Aug 2025 01:59:20 -0700 (PDT)
Received: from fedora ([193.77.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c0771c166bsm2819758f8f.33.2025.08.19.01.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 01:59:19 -0700 (PDT)
From: Uros Bizjak <ubizjak@gmail.com>
To: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 4/4] x86: Remove CONFIG_AS_AVX512
Date: Tue, 19 Aug 2025 10:57:52 +0200
Message-ID: <20250819085855.333380-4-ubizjak@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250819085855.333380-1-ubizjak@gmail.com>
References: <20250819085855.333380-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 5f5305dea066 ("raid6: skip avx512 checks") and commit
bc23fe6dc172 ("crypto: x86 - Remove CONFIG_AS_AVX512 handling")
removed all uses of CONFIG_AS_AVX512.

Remove check for assembler support of AVX-512 instructions.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/Kconfig.assembler | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/Kconfig.assembler b/arch/x86/Kconfig.assembler
index ea0e9dfdfc5c..b1c59fb0a4c9 100644
--- a/arch/x86/Kconfig.assembler
+++ b/arch/x86/Kconfig.assembler
@@ -1,11 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Copyright (C) 2020 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
 
-config AS_AVX512
-	def_bool $(as-instr,vpmovm2b %k1$(comma)%zmm5)
-	help
-	  Supported by binutils >= 2.25 and LLVM integrated assembler
-
 config AS_WRUSS
 	def_bool $(as-instr64,wrussq %rax$(comma)(%rbx))
 	help
-- 
2.50.1

