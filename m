Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E51820304
	for <linux-crypto@vger.kernel.org>; Tue, 12 Mar 2024 11:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710243177; cv=none; b=DbmbG1RG0W+lVWRT2ueRY1nUBiBqSi1suOxCflkG+1tyiCzJZbjTnGfPigtmvMyvr6VtGb08H7yg5xzddHc+WBYy/45mmMHBFWnS9tzqdus3ZfD8NrdPX69VX53SpmTP7OLTDZ7w7EdFBM8qyBei768LIB2UVdzMjb0BGInq610=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710243177; c=relaxed/simple;
	bh=iavYfcQIWRY4h767JABhzLkoOauEOhhOWkMGkRLr51Y=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=B3blHDVT9x8498qUtNe1sX6+lB/sIW4njNKc1AFkyB7UIKqPIKKu5jaftUPhpRKkpdFLMuGBONfYKvgVWxd/YSkZ2MVwZfX5kX1RP2jDB5vXw02a2sGddFpCs620v18WxfiIPSaMob8SM8bEM8xg2VmHfFsVes7ilr4hmvZuYSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q5S8lApy; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q5S8lApy"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6e617b39877so3938797b3a.3
        for <linux-crypto@vger.kernel.org>; Tue, 12 Mar 2024 04:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710243175; x=1710847975; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mIFmtkuhKpZ0h31uSGFwUD+cljEyRcTErrt/bHl00PY=;
        b=Q5S8lApyNzSNPN3ZZrs4oW43yBagzdOh50305Pa2nItFJu4Vzc5672MdfoJIxOA+i3
         eR3QDIyiSmpHEyWVidlKG093POPgFIUWSzS6aAESrD1IAwF6EWhoktVC+DXp/7s6BpEY
         FX+bSpFHOt0eTSySR6e68529ApfPJbEtP4b4+JRKi9T5h+Uhj6Y4rfo3m4xOGcLK1ton
         jxW/aSxDvYiHAFiAy4PnDgGfsCTKj0BZ9lwDKn+WlVqY1/rtioPnshteb8EWuOS4GZgI
         QYLwxj8GLZWlOwGH/aSlh0XKjcgeXrURRT7G+ovdmixsPa0vqq3G22vUpg02viUYX++T
         WX1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710243175; x=1710847975;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mIFmtkuhKpZ0h31uSGFwUD+cljEyRcTErrt/bHl00PY=;
        b=It/cigaUz0B6vvYzXjpztJX0gxEqkPdoEVfiyM/PXtmagt/Q297JSe5FDqIW8D70XW
         yrpmYZ1x88YQA5+2vdLLc4Id0KBVYb2tT8etQDf32kCltYATugYCQRlSHzcR8x7/xHyx
         dh8MqWNFP4dUcAZMpses9uevqp5ZM7Z1UsYVELpWu3opnf12wv/yOhpqB4OvVUkXzi7S
         JN1wYCeS5IkElJBNMq/R/UQf1BCDvcevCnAaeLOZ4XqJmafxTlyJG/fWl4Gbv7F8FvgS
         Hw0O16FaVnGyJWBGIpZy6FVvpmzAWfhgOl2Gfo5HttGjosWlqMwMaaTZinUkaDWmedWV
         6/0g==
X-Gm-Message-State: AOJu0YzANtHA+5HvWH6O0gak/dF14323TtF9fFJfHOQvysaoLr5UcvR5
	bWklE2UKQb1hIFTB8lhRHZEZWWi1wZxAC514hoVPHY/qeCF7uA8QVRsaQ523OPw4DA==
X-Google-Smtp-Source: AGHT+IECAeNRmsGZILP5RApzEr1K55L9vWp3dQbbc7xm/+asP7SLPvofsuGScxdgSryGgdCtxNADXw==
X-Received: by 2002:a05:6a20:9382:b0:1a1:3ecb:52fe with SMTP id x2-20020a056a20938200b001a13ecb52femr7091166pzh.0.1710243175335;
        Tue, 12 Mar 2024 04:32:55 -0700 (PDT)
Received: from serv-2204 ([119.66.44.95])
        by smtp.gmail.com with ESMTPSA id k13-20020a170902f28d00b001db5b39635dsm6485578plc.277.2024.03.12.04.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 04:32:55 -0700 (PDT)
Date: Tue, 12 Mar 2024 20:32:52 +0900
From: Dongsoo Lee <letrhee@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: letrhee@gmail.com, letrhee@nsr.re.kr
Subject: Looking for opinions on LEA crypto.
Message-ID: <ZfA9ZOFZ40xvdH3q@serv-2204>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

hello. We have previously provided an implementation of LEA crypto as a patch via  https://lore.kernel.org/linux-crypto/20240112022859.2384-1-letrhee@nsr.re.kr/ .

That implementation included a generic implementation of the LEA cipher, as well as SSE2, AVX2, and AVX-512F SIMD implementations available for x86-64.

We would like to hear your feedback on the patch, including any additional work needed for the patch to be accepted.

Thank you.

In addition to the explanation we included in the submitted patch, here is additional information on the utilization of LEA.

## Appendix 1. Explanation of the current position of LEAs

Describe the goal of LEA's utilization compared to the utilization of crypto already in widespread use.

- If AES or 128-bit block ciphers are already available as hardware instructions or co-processors, that is best.
- If there are enough use cases for ChaCha20+Poly1305, that may be sufficient.
- If there are enough use cases where something less than 128-bit (or 112-bit secure) is acceptable, that may be enough.

If none of the above is the case

- 128-bit block ciphers and modes of operation are required, and
- 128-bit security is required,
- The machine can fully utilize ARX (addition, rotation, XOR) operations on 32-bit integers,
- the environment requires a reduction in code size or memory usage,

LEA may be appropriate given the requirements.

## Appendix 2. Types of LEA Implementations

LEAs can be implemented in the following ways, both lightweight and fast implementations are available.

For the basic structure of a crypto, you can see Wikipedia or the paper.

  - https://en.wikipedia.org/wiki/LEA_(cipher)
  - Hong, Deukjo, et al. "LEA: A 128-bit block cipher for fast encryption on common processors.", WISA 2013.

(1) Crypto without a key schedule
  - For encryption, roundkeys can be created with just ARX without any additional space.
  - For decryption, it's enough to compute the last roundkey.
  - If it includes decryption, it requires space twice the size of the key, and a constant 8 32-bit deltas.
  - Crypto operations require at least 6 XORs, 3 additions, and 3 rotations per round, and 32-bit register moves.
  - Round-key operations require 8 rotations and 2 additions per round at 128 bits.
  - However, due to the round-key operation, it is required to be implemented separately by selecting one of 128-bit, 192-bit, or 256-bit.
(2) Generic structure with key schedule
  - In the structure in (1), all roundkeys can be precomputed and stored in memory.
  - The same code can be used for encryption and decryption without distinguishing the size of the keys.
(3) Generic structure with partial unrolling in 4 rounds
  - In the structure in (2), partial unrolling can be performed in 4-round increments to minimize register moves.
(4) Generic structure with additional storage of decryption roundkeys (submitted version)
  - In the structure in (3), we can store the decryption roundkey separately to optimize the decryption process.
  - This is the version we submitted as `lea_generic.c`.
(5) Structure with precomputed key scheduling process
  - In (2), we can precompute the delta required for the round key.
(6) SIMD implementation version (submitted)
  - An implementation of (3) or (4) can be implemented in SIMD.
  - We use 32x4, 32x8, and 32x16 registers and the ARX instruction.
  - This is the version we submitted as `lea_x86_64.c`.
