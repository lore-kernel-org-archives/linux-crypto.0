Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E83D17C9A3
	for <linux-crypto@vger.kernel.org>; Tue,  5 Nov 2024 16:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730823249; cv=none; b=oe4a0uHaB5BKUwBAAL/WGFDXnXugdu9gg2hV04EteB3TGMnBEEuCWlLjq2w2kWcQcktehxPIvbF2wdOYvrQp+sONFx4B/Y3kDr7wQVE9nGNrd1/Cgx+8p2s/mHh15rzz2ilvqI4IUoi5qkvQ+uCCiy3QqXlSmrhYFYtXvv26Cy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730823249; c=relaxed/simple;
	bh=uQd2WSq/KpiWtVdhUcI/1aM+6ss12Y55aI/O2+gTMME=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=RQ3Sym3lKn+/KxwDSapI3S1ozRVCng34B+aI4mP1u358Nz37BRFwMZRZ0bFn3K0HnYX22p3MNqYH2AROLV0/4mZp8ALekPChof7R4fEa+T/C5xejCY8u6sU9VBOh2tphgG21/mmkmWOOXnHGD/cSLOE8eJ3tPuPcHmTYgdRVoPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fz3vWWwP; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fz3vWWwP"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e2e3321aae0so8725405276.1
        for <linux-crypto@vger.kernel.org>; Tue, 05 Nov 2024 08:14:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730823247; x=1731428047; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8aGK7Z8v6XDcP9ImnsPr0SruZINT8w1jjDwyvhJdeK4=;
        b=fz3vWWwPgyvldGDxZt5mHubSiXtYgR+nKuk/K57PQU+DobgQA8ps/1WjX3zkhhYEpY
         iWYmyHX8bfF+jHYNfK2cm2xQB4UovSBc3Iwe+56nrPzaM5TbkI7HSzZRhZFb4pEu6IcD
         5ITPxJsWddHItH+OhA5B+5C4un2/QG7H89uohqYoOev/mltY9YWL4G7iA/B4FudToO6t
         sZpmd/RCiNBEKBcL1B0pxIZcs1mauPFeb04HWHbmUZBb0F7oB2b1uCNsc/ONnG6hRPQd
         HsVKfY5nMrRzONZJ7qB/LJjCLcajLYki9hFSFyGyMF/huAvC9zO1kjwGRZnlv/j9LW8w
         kNog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730823247; x=1731428047;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8aGK7Z8v6XDcP9ImnsPr0SruZINT8w1jjDwyvhJdeK4=;
        b=TvLnPa9h0W7oDtDkf+GKDFnJz9hVJ6KbKoC2WuRerrDYa/qvuCVgANTDpnlh8KR/W4
         r7GVILkzPyZCpSOq3pGFoK7JeZS89cZmFX01c2fdbOj/yBs3PBFC2F9PyZzXxtdIhzKl
         Zp/TdeXWQRPNQI2Tl1nSxefHM+kQzKeTqEPJiY1b4wkiF+BkKLS75MPNTp4CHp0pxa8/
         lzEgC8XvHchq4Q/e7eh8X95pC/PJFzJudb1ls0SkSR1lK7GswYG7u3E+TbPA+XaHayoI
         Ydd2qeuKJPzvzf+k0bAlbE+x6ItZrZht3OIjAcP+AYH3ZOUSsgXU4VHQWTrF5Di8V63a
         QZ4Q==
X-Gm-Message-State: AOJu0Yycnhhk2oDwpHzXSsCgGXuCKeElBAk7d8LWhqLqFilSSA213yBR
	QpqN/wlrJZNKe8lFw+KTbXhF6pI/ByuSYRwp5tWNe3sLHOo9i+J9sziiJM2+GTj8do8Z87aKjZ7
	AvUNdSPRIO3sR9mJfLHA9deRx0oOD4vC9aIy9t2osizZwpTZ3zekHibZjq58hWb8k6NSAmHNTbd
	wO7roaQW8JWLQVOnV92q6eMxXJ5KqIIA==
X-Google-Smtp-Source: AGHT+IFgQPhrMAKZuJf7yR51BZB3JEW7r+3P9Pk41hz0OBgjmmPUoYv34HFNtd350qIvCf5NfzctdqMY
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:7b:198d:ac11:8138])
 (user=ardb job=sendgmr) by 2002:a25:83c3:0:b0:e2b:cd96:67a6 with SMTP id
 3f1490d57ef6-e30e5a904d0mr12569276.5.1730823246978; Tue, 05 Nov 2024 08:14:06
 -0800 (PST)
Date: Tue,  5 Nov 2024 17:09:00 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1821; i=ardb@kernel.org;
 h=from:subject; bh=Pzrr73yq0Dd7jZRnQEQgJMh0/mIP5h5eFWKeB+7qJPw=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIV3LWWbHtruB0yT9DUXnnppdv+ZosNX9TR/+aWc38yfla
 Ij6fgzpKGVhEONgkBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABP5PYPhn9pFraXNV9vXsG15
 ++n2+qLIHVbsjKXbM85aJTqcij3l5MvwP2BtgdjiZd1SE85+09FMVfBhW1VhN4+3W27X+cuMnDE X+QA=
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <20241105160859.1459261-8-ardb+git@google.com>
Subject: [PATCH v2 0/6] Clean up and improve ARM/arm64 CRC-T10DIF code
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

Changes since v1:
- fix bug introduced in refactoring
- add asm comments to explain the fallback algorithm
- type 'u8 *out' parameter as 'u8 out[16]'
- avoid asm code for 16 byte inputs (a higher threshold might be more
  appropriate but 16 is nonsensical given that the folding routine
  returns a 16 byte output)

Ard Biesheuvel (6):
  crypto: arm64/crct10dif - Remove obsolete chunking logic
  crypto: arm64/crct10dif - Use faster 16x64 bit polynomial multiply
  crypto: arm64/crct10dif - Remove remaining 64x64 PMULL fallback code
  crypto: arm/crct10dif - Use existing mov_l macro instead of __adrl
  crypto: arm/crct10dif - Macroify PMULL asm code
  crypto: arm/crct10dif - Implement plain NEON variant

 arch/arm/crypto/crct10dif-ce-core.S   | 249 ++++++++++-----
 arch/arm/crypto/crct10dif-ce-glue.c   |  55 +++-
 arch/arm64/crypto/crct10dif-ce-core.S | 335 +++++++++-----------
 arch/arm64/crypto/crct10dif-ce-glue.c |  48 ++-
 4 files changed, 376 insertions(+), 311 deletions(-)

-- 
2.47.0.199.ga7371fff76-goog

