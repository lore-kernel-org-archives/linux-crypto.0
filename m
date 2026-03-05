Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0487A2C21F9
	for <linux-crypto@vger.kernel.org>; Thu,  5 Mar 2026 18:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772735559; cv=none; b=g/uQ8qMuA+1lqpI5B5eQS5Jcqg5ZBv95kx5hUDXdbaBdhQ5xCts3W16x2AB6VOLfUS4927s2LLOnuZrvXmLPetcUBow4GEQNbwcoFgv7Rlkv8jbENtMlNCb68VBE+rOQ/nOUrk8o3giPDiZ/myv4QV7XD2ncp/DUNXvGCePfJDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772735559; c=relaxed/simple;
	bh=sn3aOPLkyRtsI05FAzhweqIJIOISUjZXWv3/eBTzQuo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ej7g3gI0firKtGdAs36eHlmAzOlV8Pz3OJlZ/EK2xwf7yK2Gxb45SglBEUTZWBGWgJlxzMIu9sb24Rej4Ky+/1mgF5pBulcgzFAyPLgdcKn12XF2R6nvhnAgzDnxYjl36LVJrWqDqU3zWOIJhQxi8OKvwP8ftWrP/33CyfPSiA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fF2fj9bG; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fF2fj9bG"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-82987437624so630740b3a.1
        for <linux-crypto@vger.kernel.org>; Thu, 05 Mar 2026 10:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772735557; x=1773340357; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=E8X4J3YnGtFMlKI1flQlOPu7lYUst5o9wwkZ0vaHFP0=;
        b=fF2fj9bGwP7dlq2DsPwh1lc8Qc/+fCL/aZQhOy/Max1GVGnESp2kjKULj+9pKU2dvd
         QIDFnFPOmeYkxIF6PiL5o0SvRQzeG6B6EudoXjNbJ2YJE+oHS6iMF11NnY6pwdHVQM/G
         fM6k9ec9HZYx7iioUSCBpeSc12CfTGs5v225sLdWzYr3hthBZPsCoCuyyau0VrLH3k5Z
         irBnqtvNGR/yhECFXcZtTlcGYaR5TNJwnORfwPv4H3yBVFPE7a2JrC7PIhNf5N3Xmifi
         wYa3aFKpfh8vyEhInCsLm+BkWRo03El79E8e4HTq9z6dBQRHSWImAMx8Ct5cQxxUIV7O
         nVBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772735557; x=1773340357;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E8X4J3YnGtFMlKI1flQlOPu7lYUst5o9wwkZ0vaHFP0=;
        b=qMFS5JEmX8icx5CqHPXymeQuGKClA9Nhe+4IR8MneIasVoM7drlH9Fx/1d87Km3bWK
         0ZoFDnXZoa/pVZGGNDmasCOI2VCikZWxAWjuoBEr+R/+1ikOBR7cpCVXqF1rVw79tJN3
         xSlCSPtmvhtWwWdtDnUe42iw0M26Pag/s5CqYh7eIT/3i3j2msTKkv0xY2LjC61ZpBy6
         OBIRIBy0ZOxVKzRGFFLCau1vUZpktgkvED6i2FWbrp8/qOS/mDEH/EDplYZxbWnyU1Hf
         kMyJaW47lGQwODoaCa79kQpfK4y521A2ijrr1aAY8UssnxnEpuasHVOtp9Glk2D2v51y
         lfGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFguEqSuMKl0OAkzPaFA6eTH835llhhURra26+uYtDlCP2K/otbNANlf/9TVZtRJ/IjUOu0aT48VB457s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxmiv63+TlvzMogWrfmTy7WwZQf5Q5SW+y45Kn4Ra2GYeWvJ9d7
	c/50oT14m7SAHN8f5wceSkPLsojmGldtwTmaIJ0BEAS1CoTkvhSVGJgg
X-Gm-Gg: ATEYQzwajvIgb8b/lwghcqr0qFijMK3q7U4g0PM9/kQ1zP8ZBLiLzmTOpcEHGnBqAuD
	Pj2IP4Ld2VGB7jIv5Cqw5fCYSsHFxHNyR3FLgWCHb7Nsvjv2eH2/FGh28lGpLM8HRN72nSje3WW
	7AdHH9Eb62ueAPrnHRB480dTAWZlNLw+cokmePl+QXJtFFQ3PC6GB5WCBLOLdY5MGmiQP7C7gA2
	FXhMgplEseFCJ3jYTYDdQEWyu6odzReGLPRna6Qkd5cifIMbnhEgQ9VrnszFulQ6OgIEbvOU8J6
	FNKZ5pfP48LKaS1MCe8VzH1I+V3TFDDSK5UKt9i2Mafe+hmcbYY5bxCr+wqdwKIa92enGJNehoI
	ErvYF4hDDmHSKXTxNaPoxeYBIoV/fOoAo70CJBItvvDHEIc3pX2Y9DpK2ndJGprN7HFcSeTKCpG
	8A/UVp8t9n53orWtnXGdBmZBUitGhGWw==
X-Received: by 2002:a05:6a00:1c96:b0:81c:717b:9d31 with SMTP id d2e1a72fcca58-829855ddd18mr2791886b3a.2.1772735557298;
        Thu, 05 Mar 2026 10:32:37 -0800 (PST)
Received: from arm-server.. ([2001:288:7001:2724:1a31:bfff:fe58:b622])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829898e1417sm2554420b3a.62.2026.03.05.10.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 10:32:36 -0800 (PST)
From: Cheng-Yang Chou <yphbchou0911@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: jserv@ccns.ncku.edu.tw,
	yphbchou0911@gmail.com
Subject: [PATCH 0/1] crypto: arm64/aes-neonbs - Move key expansion off the stack
Date: Fri,  6 Mar 2026 02:32:23 +0800
Message-ID: <20260305183229.150599-1-yphbchou0911@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

aesbs_setkey() and aesbs_cbc_ctr_setkey() trigger -Wframe-larger-than=
warnings because struct crypto_aes_ctx is allocated on the stack,
pushing the frame size to ~1040 bytes and exceeding the 1024-byte limit.

arch/arm64/crypto/aes-neonbs-glue.c: In function ‘aesbs_setkey’:
arch/arm64/crypto/aes-neonbs-glue.c:92:1: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]
   92 | }
      | ^
arch/arm64/crypto/aes-neonbs-glue.c: In function ‘aesbs_cbc_ctr_setkey’:
arch/arm64/crypto/aes-neonbs-glue.c:152:1: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]
  152 | }
      | ^

Tested on arm64. Confirmed the -Wframe-larger-than= warning is resolved.

Thanks,
Cheng-Yang

---

Cheng-Yang Chou (1):
  crypto: arm64/aes-neonbs - Move key expansion off the stack

 arch/arm64/crypto/aes-neonbs-glue.c | 39 ++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 14 deletions(-)

-- 
2.48.1

