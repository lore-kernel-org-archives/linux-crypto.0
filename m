Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4ABC33556C
	for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 10:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761907190; cv=none; b=Gs+IkUSK4RBGxApD8g22METaxI084SHGU4pRRME1kSEXfN2HVkSlC767fawT3mpjNV8dMEPBu4eTON48aG9L2ibJyxxFMUjarLadkZDDfLX77d+sfF2/jmikU/TMKSpeJdxuMgU1rkW30/sAft5YKyxi4v2EwNxAfL6DfrsIMH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761907190; c=relaxed/simple;
	bh=G5RRBNLWLHzW2CGf5F/p+HsgvhPSQr6XbmCWT5GCu/g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t1KmEB5cgV/Zkk6+LxR6TyFLbkL5Q7rFZQoyINXnx/8djYLk5s7JfVySaIwqHtrISZgf3AaNLYjFKa/LjWdqg30vp+BrFZ4sxcVBLeIit8PTpgFnGNMAY1e5Xu8nq6fLRl7xO1/S8pbmPoNgaF7kNeXMNjUeX9Rct0nRgM2EBJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DfD94dFX; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DfD94dFX"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b479e43ad46so223150066b.2
        for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 03:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761907187; x=1762511987; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YcJUAK6wYbUnIItcXuhAD3+TuliFkqmiKq4znCgSGF0=;
        b=DfD94dFXFgvxIuMzP+eKj/PMnThYexq88yovWKJDJAYqf+itbPKGbglgm3UKBe4Ae1
         hR/dhe9meXSKU1FESPfQDAVpwlCxPz+hf5cV8ilQAE56aMoqGK2BJ4f4poLOKuVxD0Zg
         isLbfwwv+anpjOtpJvoe0tsQ8Mo76WOdz0NfVXMItV132I3gr+mgP5sLO5G1UEcj2dWm
         iJcM/D2uz5EpI3sAZ1V0khwO8TUurOTeA+KlZVrKu3HJ5X/ZXwCFp2PsuSqFH3pgkwfS
         pv3hi9w7zyJvAJZoNgmSPjWA8tbQke9qwRTEtSucOmykdkoP8thPQlCtmfXQ/dhDe5Fr
         4pWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761907187; x=1762511987;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YcJUAK6wYbUnIItcXuhAD3+TuliFkqmiKq4znCgSGF0=;
        b=clOq1wAbwVBG466lsTnFmtuuuB1LBV55COHAQGr3WLRRZCYD0YQ8eASucDzgGd9KgP
         axxvbw6tUqEGKOU68PLqC1BobT5U0dI49XI9H6BAxeNw5IZxj8i48HQlYTq9+bYOIzzm
         nunKjoaF9NzbattQ+1Qo0eT4AwqVJpuRM8cI0K8T30rF0JaR6ByqFRLDVW5Kar5v/w5J
         NxwTQhC9B0NtLGcqQJoh+p0yCz5pxqQWvqEiwUKwVJYESrSUcfgAHLFVcqcWRbgv/qvt
         LI5eYrOkVz+3zLTJpP+pSui6uxo0rxtV9g+gz4JKHocMNJqiAuWXMhbGycpO9nOpG7Lu
         KgXg==
X-Forwarded-Encrypted: i=1; AJvYcCW2P5qTyaaoN8ltJhvy9EVHsJbm5GGu+vlEB1/MQUqVLMTyO7aivgC4JzXodFUjX1jVyRWcT1aPW19YQxo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpfZyWoPG6bOK/Ck28ter/BAQrF9WI19viW9qQ4R/L+hm3W/xo
	y7dyXJ1jHaYwEu1dC1HRAOBFLgWxYs044Um29ZGtVeIqGSfQaMIo7t4+jlCBK9N8T9bpDJPHcA=
	=
X-Google-Smtp-Source: AGHT+IGZh2XVfTLLj0zhjt1BICvTQf4H+YXy15GPZEDU6T61fPt/5oBnkxDlk7NOR3Q1+6PHRVp+5rAW
X-Received: from ejdao14.prod.google.com ([2002:a17:907:f48e:b0:b6d:5f6f:f88d])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:4fd3:b0:b2d:d7ba:8e7b
 with SMTP id a640c23a62f3a-b70701b183cmr329375466b.23.1761907187206; Fri, 31
 Oct 2025 03:39:47 -0700 (PDT)
Date: Fri, 31 Oct 2025 11:39:00 +0100
In-Reply-To: <20251031103858.529530-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031103858.529530-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=926; i=ardb@kernel.org;
 h=from:subject; bh=dO4a5jlY66z9w+gPMMFWeTG7Ku3rgSUkr2hPJWOMIU0=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZNl4pHD/75JiC/9K2vH/lbtRfh3+QvnpDrMDjge27JVP
 HOJ/5G3HaUsDGJcDLJiiiwCs/++23l6olSt8yxZmDmsTCBDGLg4BWAihQEM/zSie2ONrfwLXk3+
 t1VdNqr2RUzhcYsZcfEmO5qeTnM7/IXhn8H7NtmnN3p+XXt/sq5gYUf1EqtZvT3e2uK8kaf+XVX dzwAA
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251031103858.529530-24-ardb+git@google.com>
Subject: [PATCH v4 01/21] crypto/arm64: aes-ce-ccm - Avoid pointless yield of
 the NEON unit
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Kernel mode NEON sections are now preemptible on arm64, and so there is
no need to yield it explicitly in order to prevent scheduling latency
spikes.

Reviewed-by: Eric Biggers <ebiggers@kernel.org>
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
2.51.1.930.gacf6e81ea2-goog

