Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E42723B61E
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 06:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758177372; cv=none; b=Z4sPHbp0TTor9v5T3rUzHUb9C2u+teAxBah9pTSUV/JdQ5CTWv+wHtq4ahBU0Qlr3gfcN4DjHlHY/IoVUAJyw8z5vZk2nu22D1uh6kmkGZbZDUTaCIfmRnx/fq6vUDaho3yRU12ijlz56G1qLzb8Mc0tflp08ty5B2BdzKqVPSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758177372; c=relaxed/simple;
	bh=n5KE+fSMMf16oy+VMZN+yuIACUKup3MoEPGdDmhinn0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vgud0aT5ff6XUDFuH3y7/IhhH1Qj3bp3l988cIq4V/X6KNo+0x7JMzQXPfD7W8Ia7cIK/H4rvUyjNJ/W2pbarOCTdnwdD1As0IGw/PP/4jr2BiqWWdPXHs3QWzbVp69jID5LktOz3V3AYbrIWUgt263faQv+T3TG8hTSjKvLwN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xwHaQ6be; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xwHaQ6be"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3ee13e43dd9so20118f8f.1
        for <linux-crypto@vger.kernel.org>; Wed, 17 Sep 2025 23:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758177370; x=1758782170; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nyu3sJfTvBzaaF8NRzdol7D0KlXiLUJYuDTKFu5v89g=;
        b=xwHaQ6be6j7B01zuWRzY8+2K1iNQTcociGeIri69gmnvWQ+0C/qDhCHE+hAjuOhUJZ
         CYHZcCLlzweTBS66K0L65dHRpK7AIHnv/iwYZcnAJGOyNCp6Yi/e7TTyX9LTyIevHpX7
         EmI8nh14By10ioLzlOqcrJWhDIOMpYOSjICFCgpYnvyQ883UVKYHUkmb4LavbZHxrDiV
         hhsqNo3sY32CvVKbFuPO/EwCrMs0zuSAq0o3O/U15Dr6XHJQ98Uw+TKZHxZ14SZ+iuKn
         44b4vtbQMRMRVnbWexiB7aULfBrAEGDT2ErW6KNrt4bIm7YFvdrCPn4SHgFTD/xx//35
         a/1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758177370; x=1758782170;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nyu3sJfTvBzaaF8NRzdol7D0KlXiLUJYuDTKFu5v89g=;
        b=gAJ+/aDKqtltXs5lS8RBQ3y4J/UXeQHqgm31bxBqLe3mRmLv7qDHTUaZcJLrz0j3I/
         FAS0s8Y9hbfUkZpTu7gir4b56F5eZgTkeaZFnZD4B3LWGb9zTOWuwU+DxiA+5efgoF0g
         RFN05s24D9vXZ6J5nnG+dumyVwjhmJ1z6Nyl4Xqqey2EXzpJwUCX/2db9gGWh2VOymuk
         4TsTNxwSB2EevdBBD1fw+VEuAzUCINLL9f82FnlKZGeIEv19H4cTg//x1pFyObjE8Yh9
         JrPlnybd3SZbPJ+01bxi/flCfClEMPK/HsIOwx1BXSnX6wKjpgapxJbanEToClKxSjbi
         VI7A==
X-Gm-Message-State: AOJu0Yw0kRAY2kOJaJLDfIRPghFBP67cHlKqJpqITqRu494gl75DoJFm
	49mNacvfWrlSIZsvuJIfSdhd3jecCBD1B9FppXPsy6kmvH+ZsYgIrhDvKz+RFaB4L/OSiqLQ6A=
	=
X-Google-Smtp-Source: AGHT+IGb4uPsjREwonnmwlL62vl4gaBXll8+OUpYZ766bJ2GqzrjEt+LTSzqc6rAb48NKjy2ajlwiyBq
X-Received: from wmbdr18.prod.google.com ([2002:a05:600c:6092:b0:45c:b59f:8805])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2084:b0:3df:c5e3:55fe
 with SMTP id ffacd0b85a97d-3ecdfa3fa97mr3557665f8f.29.1758177369823; Wed, 17
 Sep 2025 23:36:09 -0700 (PDT)
Date: Thu, 18 Sep 2025 08:35:42 +0200
In-Reply-To: <20250918063539.2640512-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250918063539.2640512-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1398; i=ardb@kernel.org;
 h=from:subject; bh=dTXA4xH7T53eWCY0KfUSuWwFdpHaVa8zubCJjHScVKg=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeP0CvtShrSnrH/mf+9Kv+QanbfrxfSq7ceW7dWUPJX7Z
 uePpHtzOkpZGMS4GGTFFFkEZv99t/P0RKla51myMHNYmUCGMHBxCsBEyp8z/FN8zda/WnfdybOd
 5a+eKDxrZT32aL2f9z2dhL0vHqxhNrrFyDBlU3Lq+R/eWoxC/6T+nLY9obtbbtc1+dtqsxfmnHn xMp8BAA==
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918063539.2640512-9-ardb+git@google.com>
Subject: [PATCH 2/5] crypto/arm64: sm4-ce-ccm - Avoid pointless yield of the
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
no need to yield it when calling APIs that may sleep.

Also, move the calls to kernel_neon_end() to the same scope as
kernel_neon_begin(). This is needed for a subsequent change where a
stack buffer is allocated transparently and passed to
kernel_neon_begin().

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/sm4-ce-ccm-glue.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/crypto/sm4-ce-ccm-glue.c b/arch/arm64/crypto/sm4-ce-ccm-glue.c
index e9cc1c1364ec..f9771ab2a05f 100644
--- a/arch/arm64/crypto/sm4-ce-ccm-glue.c
+++ b/arch/arm64/crypto/sm4-ce-ccm-glue.c
@@ -179,11 +179,7 @@ static int ccm_crypt(struct aead_request *req, struct skcipher_walk *walk,
 				 walk->src.virt.addr, walk->iv,
 				 walk->nbytes - tail, mac);
 
-		kernel_neon_end();
-
 		err = skcipher_walk_done(walk, tail);
-
-		kernel_neon_begin();
 	}
 
 	if (walk->nbytes) {
@@ -193,15 +189,13 @@ static int ccm_crypt(struct aead_request *req, struct skcipher_walk *walk,
 
 		sm4_ce_ccm_final(rkey_enc, ctr0, mac);
 
-		kernel_neon_end();
-
 		err = skcipher_walk_done(walk, 0);
 	} else {
 		sm4_ce_ccm_final(rkey_enc, ctr0, mac);
-
-		kernel_neon_end();
 	}
 
+	kernel_neon_end();
+
 	return err;
 }
 
-- 
2.51.0.384.g4c02a37b29-goog

