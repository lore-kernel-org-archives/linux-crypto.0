Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E1E14EC59;
	Wed, 13 Nov 2024 10:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731494579; cv=none; b=eg+CujIo4Y3oCTzsXDSlNBP0Amy5W/Il+9eMMs73mWG8k50qfoTTD9A4qrjptT2rhx89Yrkvkl/Csc7zVS3Ovj0DvRKxOcWaUr+tWfIKfQ1Ri+0r14F3CiOVlDwRD6DMspkEmRjTU8ejAXU9nxGsysLK+Zck1NGJaoEGsTshK8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731494579; c=relaxed/simple;
	bh=jUhzIupyMkyKqXHwF5Yr4ndAF0RqVQddHvkOcAYxmgY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=n6duQjtX60OqnyAqLqaGAMpO2te2uQS71DWsAPnMHFuC+4I2V5mmsZuRVihLXfD88ABrmULn/VKL2Zhk13RbxOTBuaMTu2H4pSvmf9tfL0z5s81UWE6dzFLxBzlAMHKDsarM6h4ZPr5e6idYddR4UFP/hlREx0YPeNJy79F8ucY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VfpeCNU8; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VfpeCNU8"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-71e8235f0b6so5705471b3a.3;
        Wed, 13 Nov 2024 02:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731494577; x=1732099377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2LtsH8ouhCA6XRx1lBCvdM4CP4gAZ0q9wxfJhxDlXCk=;
        b=VfpeCNU81LEY7S5gIF5WRGhG8Yy50jipQhhCIfNS7/Dapzqrxh0tM2WwL71EaziPYF
         HpzLCL5SjXdZLXybw0o2HOqtee3QO2XVzcJdR0Xr6/0bnhTfWSzzcEsbDJfr3EnmkXS6
         K/qt8YXSzpONuOlm9iJoGWiTiDlz7PMJcDgDnhUlVAJsXvvtOVEuWi8Ftb7Ts2mS/4Yc
         7RabR1ZIwNIkMlDZGQkaYvdrvxthp4Ok5hWKj3VqdJpQwWNF+iIqsTYb8C97Ggf5SRnV
         Mfkedv2na+nMUL2rUko8w+6INTXJ5Q/IyH0lYEHh5PUrcYtETsw+xNLZTc2Bhv2DdPDv
         jSxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731494577; x=1732099377;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2LtsH8ouhCA6XRx1lBCvdM4CP4gAZ0q9wxfJhxDlXCk=;
        b=Q8uCH77h5L32x2b8jVMeNveSWnv3u+8N7Hb5wA+ruFD8pDkNMLFJYTQlFEIRgPgZ35
         r2mdkx975DGD9QV50yHm4P5F1XzfZDtHXS6qxnSAE8tCAWB+auwH8XKZYv6mLrFZLEsX
         1Wp2/JFwSp0GY4ysImJb6eO9i8mN//X3FpOMXsY/6BptzAou5P242M6KVkFxRpQw5ksx
         hv2Ujlc2glb5fyvS+cW4+m22crhoRKZuBEc2a1FsnoJVmSsWtHYAtSrJYWO2HLO5sMcv
         zX3fhlBX7DbfrJVrIzt1YDgrRI7jrO3tMsmnj6zOwTfXuaivwef75Xr0XlGY0MBa0ZBL
         4Nbw==
X-Forwarded-Encrypted: i=1; AJvYcCVDl6S9QJXs5uhFFAm7BOcRyb0Txjy1snTmYw36Vdn4g2WT8bhhS1UVWi6UYLRVMDq4P5/or2uBIv8FtQ0=@vger.kernel.org, AJvYcCVhrUJhomfqFGp/TZJeMyBJT79dUGIL9nN09GhWtFNzjW1tgtBhwzr61SYYNStJ0IOgZ4XggpEXcwt9gQk+@vger.kernel.org
X-Gm-Message-State: AOJu0YzCYYF8wQu1xmZ3IlPk5efqlXxi5zWl5Rytz07Eb4AwG745qngT
	BQkKErtoJBXbRizWxUAJnxf4NMiDHOyuTu/xiWzE7vwRAcMQpuSt
X-Google-Smtp-Source: AGHT+IGAXS5Vws6orJFEKQt0sk5vBw4N/CstBrYPj0GsMSlJ6rVTcsR2601FcrF86bchDcrOPpb7+A==
X-Received: by 2002:a05:6a20:7f8e:b0:1db:d84f:c7d8 with SMTP id adf61e73a8af0-1dc70338e7dmr3155559637.2.1731494576954;
        Wed, 13 Nov 2024 02:42:56 -0800 (PST)
Received: from localhost.localdomain ([45.137.180.202])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177e5a9ebsm108031105ad.198.2024.11.13.02.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 02:42:56 -0800 (PST)
From: Zhihang Shao <zhihang.shao.iscas@gmail.com>
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	palmer@dabbelt.com,
	paul.walmsley@sifive.com,
	aou@eecs.berkeley.edu,
	akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] RISC-V CRC-T10DIF optimization with zbc extension and CRC-T10DIF selftest
Date: Wed, 13 Nov 2024 10:40:34 +0000
Message-Id: <20241113104036.254491-1-zhihang.shao.iscas@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Compared to other architectures, RISC-V still lacks accerlerated implementations 
for some encryption and checksum algorithms. 
This patchset aims to add optimization for crc-t10dif algorithm with zbc extension.
To verify the correctness and measure performance of the optimization, 
the selftest is also included as part of patchset.

Zhihang Shao (2):
  lib/crct10diftest.c add selftests for crct10dif
  riscv: Optimize crct10dif with zbc extension

 arch/riscv/crypto/Kconfig               |  14 +
 arch/riscv/crypto/Makefile              |   4 +
 arch/riscv/crypto/crct10dif-riscv-zbc.c | 182 +++++++
 lib/Kconfig                             |   9 +
 lib/Makefile                            |   1 +
 lib/crct10diftest.c                     | 687 ++++++++++++++++++++++++
 6 files changed, 897 insertions(+)
 create mode 100644 arch/riscv/crypto/crct10dif-riscv-zbc.c
 create mode 100644 lib/crct10diftest.c

-- 
2.34.1

