Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B886418C333
	for <linux-crypto@vger.kernel.org>; Mon, 28 Oct 2024 19:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730142153; cv=none; b=dcpOd7tbIvz6RD8m/KT/XFyj3Y2md6TWnONNC+wz6mk+n3913Dti8PkMfkftL9imDZUO/w30Pk1fAlW2EfMWkNxaq/5o6dvFCxyW0O60RjoW1zcG3brAtLZfrrXre8OJ2XsloBcjA8iFhnLMCjP1ytJBoM1XjO/lPq3lGcVcM6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730142153; c=relaxed/simple;
	bh=LYoCEwY9TDbeyVNchhJ3iEih7b36z6ozXpqgAc099Ig=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qJyiUX1yjVTGPpdfHXCsEMBjOEBtcfxsogc6f/NHKMxyfXV0XC+JWCPX/qA820IknzpoqsJsl7Iv06kxs8O1Re4Dmz00bCQdlOyCAjKPmAw1DPaC6p/Kdgi92xGRy8kcsTGLHvcToEu8icWJ/KmGus8y2yfSKomFW/ANku0eIeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m+LbI2jx; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m+LbI2jx"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e2e3321aae0so7398145276.1
        for <linux-crypto@vger.kernel.org>; Mon, 28 Oct 2024 12:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730142150; x=1730746950; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EHRpW98vkhSvMXXUJxWa0SLmg5kabWdlwzG0QsKPAGI=;
        b=m+LbI2jxVZfv4lSWPgmMTYu3SHEqPF7MXL/sdzneLrW07Z1NUH7qkySbJ30GzBc3O8
         4PBoJ/w+8zMd+f7uM15P5eXdL4qMrgGbDnmW//zm1MCHU3lW2j1hp+JIjKd1EVO9/QLN
         8VPtEMoIlh0p5VOsls0UTLVoyPBR1+Ok8jH75K6uFtEpPJJCJw3IqLJPkV21d2LOWQPH
         hnEkXrqvYQGGuOw9+XUo0n8FZxfJKrUg0nQe2c5VzxtTwFO0CMUjsNzt3cv1PS7cEnOJ
         bSMsMcNQd1ESiROCpbP3e1SPj+z5fH/6onYXxxaO5cIn6x/JObqFMR+3xOz3kAy2neTK
         gpVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730142150; x=1730746950;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EHRpW98vkhSvMXXUJxWa0SLmg5kabWdlwzG0QsKPAGI=;
        b=DhCNbpscyYiIRJhmDiLeoPg015BXBFBqbxa28tCoEVGLV3KLc97jHCVdRg9cmHAUVf
         dRrwz6Vn+O/5VSBUurlOFYxfWHHyD3ofROwn8Utng2/yUJ+3zHwaEtRvtXiqnUkREi1y
         7E+vlyBRn0Pmt7Q0pKIlNld/qGrv5obN5BEf1zhDojsTDe3Rajb7f5XxdV656X4Zciv0
         l+icOSUC2pSTpXr7ex+Nuk7TWPsPy4K21hjyRJaJdp/uq3jz9xAN8ADd5RCkNaVB26+9
         /WnDw17ojtiwbDs+zfCMRZP9/8BsiUL4bdlNMYBwZbODQNr0HexAs2G76uHL6pVmNgk4
         Yx4Q==
X-Gm-Message-State: AOJu0Ywff7HsWGpNpWiNV9HJU68jUJJX8e5REKYMYpWEnfMo7g31Jfhj
	d/ZZkPbE4EZNrC53vSHBT+dUfXoBnBufdIgiYGuCXccRlPULeW7AmZB0KltWEhIIBrngnI1Zux3
	dlriJtpZnHonc9bNBIHDW7jLcqIM+WGtcIJmZlAulvhSCqAPqFaXcfsJmSOEytcHxsGx4eXrqkT
	oznSpvK2HiGA3YiiC3eak37WYA3L00Yw==
X-Google-Smtp-Source: AGHT+IExR0a9aLuAYmfV3AxBJbQdp7YaKic3simKLqUlMUU6g9QSdNMB4Ovb/3VBggT78IboqW/ELPi8
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:7b:198d:ac11:8138])
 (user=ardb job=sendgmr) by 2002:a25:d882:0:b0:e2e:2940:9b43 with SMTP id
 3f1490d57ef6-e3087854558mr6137276.1.1730142149303; Mon, 28 Oct 2024 12:02:29
 -0700 (PDT)
Date: Mon, 28 Oct 2024 20:02:08 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1496; i=ardb@kernel.org;
 h=from:subject; bh=LUzoz+2dD/g/ixA8BHwNhatmeDEXOA7MAd15Lgh8fyM=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIV3+/oaLqzfPvhy+4+tr3SXO0vY3p/fl3JGwfcL0PymYY
 579o4t6HaUsDGIcDLJiiiwCs/++23l6olSt8yxZmDmsTCBDGLg4BWAiag6MDNfSn2071Bd+43vj
 rf45T3PS9dxkZ6+6vnLq75Zv+svF96cz/FMQWypkvabtblasdeTnbRKhb8UYDP0Fsibvv+P+WqP OjBsA
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241028190207.1394367-8-ardb+git@google.com>
Subject: [PATCH 0/6] Clean up and improve ARM/arm64 CRC-T10DIF code
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org, 
	herbert@gondor.apana.org.au, keescook@chromium.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

I realized that the generic sequence implementing 64x64 polynomial
multiply using 8x8 PMULL instructions, which is used in the CRC-T10DIF
code to implement a fallback version for cores that lack the 64x64 PMULL
instruction, is not very efficient.

The folding coefficients that are used when processing the bulk of the
data are only 16 bits wide, and so 3/4 of the partial results of all those
8x8->16 bit multiplications do not contribute anything to the end result.

This means we can use a much faster implementation, producing a speedup
of 3.3x on Cortex-A72 without Crypto Extensions (Raspberry Pi 4).

The same logic can be ported to 32-bit ARM too, where it produces a
speedup of 6.6x compared with the generic C implementation on the same
platform.

Ard Biesheuvel (6):
  crypto: arm64/crct10dif - Remove obsolete chunking logic
  crypto: arm64/crct10dif - Use faster 16x64 bit polynomial multiply
  crypto: arm64/crct10dif - Remove remaining 64x64 PMULL fallback code
  crypto: arm/crct10dif - Use existing mov_l macro instead of __adrl
  crypto: arm/crct10dif - Macroify PMULL asm code
  crypto: arm/crct10dif - Implement plain NEON variant

 arch/arm/crypto/crct10dif-ce-core.S   | 201 ++++++++------
 arch/arm/crypto/crct10dif-ce-glue.c   |  54 +++-
 arch/arm64/crypto/crct10dif-ce-core.S | 282 +++++++-------------
 arch/arm64/crypto/crct10dif-ce-glue.c |  43 ++-
 4 files changed, 274 insertions(+), 306 deletions(-)

-- 
2.47.0.163.g1226f6d8fa-goog

