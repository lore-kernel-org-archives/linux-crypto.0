Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A998258EEA
	for <linux-crypto@vger.kernel.org>; Wed,  8 Oct 2025 15:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759938409; cv=none; b=hBxuQSnQygSv4mLp3tPHXOKex5pEu9kySnu+T6fzJoMKTpH0HxFW8FIZy/hsGVU8I0wH3NORsZ34epNk1PjmQZEHOGiN4gLYBGzccCN1VnLV2pg92dHykxu0FsAJ8TruQBSNE1pFaUduaooG/IubRfiHs8CeFvhDGGB3sfdMOG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759938409; c=relaxed/simple;
	bh=12RXdlH8WUVCzzyh4vIFws4ja8Gr26ZMeYscmOm7oNE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jJfTPxOS6ebASY/YBQFzkHy9i7Z/ExkbdgeTKylLez0l/RZYptTdq5AzN7hECfgm7tn2g9WCCEE5UT6CS0Y0f9WZJE9zse0+WhGfsEf9tsPDfN9pqWco5Ebk4yVXQyl/2MejDvK1cdourqDUi0tFws9OdI9pXJyeFVtBFKQwbDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MkUEtHk4; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MkUEtHk4"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e39567579so22955e9.0
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 08:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759938406; x=1760543206; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0AhbZPensuqKG/yW0Qj7LE8IaoQDaRVlqpZyE8QDARA=;
        b=MkUEtHk4snIs5lRXjuc0RGebRrxYuNBdxlqNzkB5nZ/9E+9mGNa75OK+/LDVlerJyh
         0CvnrK97nno0ptq7K2lk9McykRedmKZzhJDexco23c8L/xnDd0E/N2oNlVKqM+E4Vocp
         OFBeHsaRiwTE24y6gNMYzM78KmrsWTPcjgslga+cy4nVKvaeWtXVMNY/99/T+JPgitXS
         LJM/8qzIHQm2IPA6KFlSi1NIjQziIot/G7O1Vm7pFWa7ey/nn+LWh8gF3y42skE5msUk
         kXvJgcHg6zzKIaehoNaoMUvyjI41EJRfDtuZFKxp9LpjHz5XxapMq6j0/jk9wsskEDGs
         Hf1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759938406; x=1760543206;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0AhbZPensuqKG/yW0Qj7LE8IaoQDaRVlqpZyE8QDARA=;
        b=cixrb/enFK35uqJeTUQwfpB0oX0s89eZ/BPXF5jdkQaRRd8UxC21vIetgjaq1tCPoK
         Octvzp69YJRsmQDJRjkCX9GMpnE8rbUmA4PbUllpA45G3vzQ89mXhoxN+1G15X0h3eNc
         0Yj1VflwZGdPlwD71ksS4nk1GwEIyoUjAbWqH4gK/S1Lzu/myUn8Dbt6HMav1mAIeRdz
         5cerbF48xkO07jF/VA1IBmm1MLbqZM/3Bas5l5Xi6Gc9vX01ZZP1O8KbamPGGxZ79hfR
         rQk5wBiurwJ6AWjW+rO0bW/h7HlW1uK2Hz5O91ASm4+4Isedf5nVrORA31IftMpN1Hhf
         Zl3w==
X-Forwarded-Encrypted: i=1; AJvYcCWPm/d0UPRpoL/Y8FrETsMRtVgYFaAjyp6RflQXchjjcESm9MHTL+Vmnx7rpQL8cDlPNDo/g1u9DCAc6+8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzNJCCovi9Nv80J7KZ1ux0q+evOCgiYT3eo3ItQnz/202WYcl3
	RnJ8ix7JZFrv8oTrgPxr+dnZx/bRbtz5xdCfC1wblXUjRJ6RBaDhkm2lRWzRsayAL2/mqZDRpQ=
	=
X-Google-Smtp-Source: AGHT+IFGiSWygFLP8i64IlU/Ujr5WlDyO+2EV/4Cl8eQXXpZQ1evYrz2O0ebGMwfs5ylyK1bfixkdj8Z
X-Received: from wmbgx7.prod.google.com ([2002:a05:600c:8587:b0:46f:aa50:d70a])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f08:b0:46e:3dcb:35b0
 with SMTP id 5b1f17b1804b1-46fa9a94553mr27472645e9.2.1759938405883; Wed, 08
 Oct 2025 08:46:45 -0700 (PDT)
Date: Wed,  8 Oct 2025 17:45:35 +0200
In-Reply-To: <20251008154533.3089255-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008154533.3089255-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=926; i=ardb@kernel.org;
 h=from:subject; bh=dFhPhM339lpxbecIP5ywrFTMp3sezPQKRMrRY5eAeY4=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeNZu1Lfp9XzPjod2dxh3FPPsqyyScbs3OtNeYcfX7Y+w
 Fm+oNm2o5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEzE6QEjwxpeIaV+vccGIcs9
 Dyc+unbs7fSJWqcyfXV2LPXdKGaT9ZmRYVXe3vsMtX7S1jcOe/o0fpbfGaJcmHeg7Mq7F+7nFwd d5gEA
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008154533.3089255-24-ardb+git@google.com>
Subject: [PATCH v3 01/21] crypto/arm64: aes-ce-ccm - Avoid pointless yield of
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
2.51.0.710.ga91ca5db03-goog

