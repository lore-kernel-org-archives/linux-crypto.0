Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F69629BDB6
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 06:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758177372; cv=none; b=ukR7neVadxrfgsObgJ9C8UbSPLDWxxVVj+aUjKDEGUhd6dR7vLB7nKB59aWT8MuMMgGPWqTKtFpjkKyUAlJ8jNQmdNO/uvLvKwspunWbRC4PclvwwVCN1ostgYh1Gt3wiU2wXlYBNKQEymNMDeWG0/hPwkUptSiGExYq/7ZuZnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758177372; c=relaxed/simple;
	bh=mLsK2P9o/PVsSH+ZSFN+0IASgJ72ISRGleKWYu9sCSg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OeMfoY0gSpQ/N+IKUSoB4sNb8BQFrZPO3heAX2OISJNjkId07foY5PNQEcI30s1nAAQW0gKQPFsaTphP8ET4dLDSIkLZfFml9czQMD1VbsD/d8fvl5xBlv11PMtkobOI6G/cm9UIdM/Im3BOhuUzMn/HhywdM8tu5yKiPZNbW98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D+7e8irB; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D+7e8irB"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45cb604427fso3004995e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 17 Sep 2025 23:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758177369; x=1758782169; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pD1GqEfStiaojYrQnQeMsM18jIp83N4vklBUGeXEk0Y=;
        b=D+7e8irBiDdNYI7S5xxbpyUYvaBLJCXgUhIrPHm1crl45UieccFahRubnYAfXAnmPi
         +wKtVsIUbnI+Ae8sBnj39Xno1JPh5+9jg4kMrKaBbfEDIJ2mLUKzsFRsVctxLvpLe2af
         djb1G5M+NtG+3hBtkGDB/BTqwJziZ9mBPF1B1IJNuuTXTJkj9N+BZhhjb1idtIsRpwVH
         SSf2hYftLzyO2rG6UdAkx8CkVYJ0OyrA2xsjeyJEH6auY6uGbX3R57FIW94/r29yJ0jP
         KZvV3uaO9wkyryhWbaInumUEjmyHr6Wm8rcOupH7icM21pfv3j2j97UqiSoSGpTocol5
         MRpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758177369; x=1758782169;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pD1GqEfStiaojYrQnQeMsM18jIp83N4vklBUGeXEk0Y=;
        b=LtAeAl6vXT737civ2GCo6QTcI3/CXr+GdYHq6wBjbutoTdy8qShZWkun0uKFh9+Pq1
         75d7xnuQY4rc7WfU+gcqKJy/w0xuie8JKqPqMJfeELp5zVuTh+ps84hM8uKJPStxRLW5
         SGrBs7d8bxGAjws9V1EsUMoQPHqr/0P0PuJUgI69E4VPGPEwQZtGTo/gb8jv53cz1mjd
         2pkQ9saX0qJPGuvV5LjSMjxrNF3SOLtOBb6uUxfltUaaoYtZ3tkStaGP3gFOD4FgE+r4
         ISphnIvR8OMXcs19P63XKb6ui3WveIBH8ouiSX68ykHDPvzKqtIfk+0iN0z1rAO03i7q
         +3GA==
X-Gm-Message-State: AOJu0YzFdiYxkZV4PWFfwqSfhGAOhaI6d7c3v5NSf6XrmeGi5JScQ0IF
	9ZqhQSgIValvEqAdcKq+FGimX1f7r8saOLER/1i+xOFOaS+e4uJX2z1OMGuiwpDdHXM/wLMtSg=
	=
X-Google-Smtp-Source: AGHT+IFBX7q+olV3TxKCMLPGDOXeRlUO54aOaLC2GWe3WCaoWqZDVDYjlTr0slmxpCXGLHTZDbGyUhSR
X-Received: from wmrn43.prod.google.com ([2002:a05:600c:502b:b0:45d:eb3b:54a0])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3509:b0:45d:f817:c44c
 with SMTP id 5b1f17b1804b1-46201f8b105mr44939285e9.4.1758177368875; Wed, 17
 Sep 2025 23:36:08 -0700 (PDT)
Date: Thu, 18 Sep 2025 08:35:41 +0200
In-Reply-To: <20250918063539.2640512-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250918063539.2640512-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=877; i=ardb@kernel.org;
 h=from:subject; bh=XBh8pq2KsPALfmaJFm04pRdLlOab2MUmglzVdmLzRgY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeP0CtusBs1FB0Ilkqf/6511vMyv3m3WTW7p2cK6mvmG7
 y7Ky/R1lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgInwLWFkeLtZV0eJ14IlZdrh
 Z49bnoeq/lx+6g2z4IXFWotOFsbOT2Zk2Mr280O4kl3o6UN71aymdmzevvzOMfesD5F33m26171 7HSsA
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918063539.2640512-8-ardb+git@google.com>
Subject: [PATCH 1/5] crypto/arm64: aes-ce-ccm - Avoid pointless yield of the
 NEON unit
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Kernel mode NEON sections are now preemptible on arm64, and so there is
no need to yield it explicitly in order to prevent scheduling latency
spikes.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-ce-ccm-glue.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index 2d791d51891b..2eb4e76cabc3 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -114,11 +114,8 @@ static u32 ce_aes_ccm_auth_data(u8 mac[], u8 const in[], u32 abytes,
 			in += adv;
 			abytes -= adv;
 
-			if (unlikely(rem)) {
-				kernel_neon_end();
-				kernel_neon_begin();
+			if (unlikely(rem))
 				macp = 0;
-			}
 		} else {
 			u32 l = min(AES_BLOCK_SIZE - macp, abytes);
 
-- 
2.51.0.384.g4c02a37b29-goog

