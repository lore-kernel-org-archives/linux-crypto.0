Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE55728C5D2
	for <linux-crypto@vger.kernel.org>; Wed,  7 May 2025 17:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746638912; cv=none; b=kOgmDwAJYRiB1CymCfD10hjaBfAg/IO1B8dbEFF9oxrMA5ZOeFFHyYLst5kNL151qzqqzozp3tQidoXMhMt5uyquOGZQXyGtT98UAk+Lrp61+zSQhoZSWJ1pCooGELNEhMdb/4C/og+E/XRjnZEuAqQ/7e7cdv5EPULlKyMWl2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746638912; c=relaxed/simple;
	bh=FZheEln+DecdmEZZGrByjZ/STe0Pg6RlF1CAnfLpyS4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=tXCkk4IG1r2XuTH5DXV4XkwK0MOkcbCrufMayOjM1lVep7SzGOhnEvi8I3aBrijnGLHEpQAVn0Jn0DLokRBnja1ZNDlXwLMrmne+WZ0xEWq/mrPim0Biisv+laeH+YCGrye/8hGdaGFCPJMMCcn22Lpuc6oozASO79l+NrI8Dt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ArP4cOLY; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ArP4cOLY"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-523eb86b31aso35926e0c.0
        for <linux-crypto@vger.kernel.org>; Wed, 07 May 2025 10:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746638909; x=1747243709; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sJLTnvgsmSh2wyqfhON/8YMw/+czkU0YdZcT/idsIUo=;
        b=ArP4cOLYK8ZcWM8trgOZs+16bTiM1+MaV6BhMWDEpj7kYGERL70jxMbuCcF7IuBucm
         ZqsclSmjMIJ02nldzNFcPWFNitpGzO8SGIJ2nDSa64AG80po0ZFH7iRYfypR5VLL5l2V
         giKywc2yDpRr6guGvE2IoHInnVRlbDD+8xlJwq3a/+VrCEd274Y38aoKrS/wlWQMCzgK
         FhVuhGl3e4P98WYE9xPIJcW/kpaCY7ih7/ZNczbghaBUqe6nSGpaDw25jjdeNer7XNGk
         Dwh/94ncbRJXx/nMJHLC5q7svSfWKPxCVY2EQXcoqc3aoPn+EynT3rrK9kJI2NEEAIqf
         HjKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746638909; x=1747243709;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sJLTnvgsmSh2wyqfhON/8YMw/+czkU0YdZcT/idsIUo=;
        b=CPyfZ/vvtFQqIHQLZvVUit97PrjZNrXwlO2OxOGs3ziqlx3CWKwdVRR8bfdlXjKtkr
         QJkNm+nkN3wURJDMbADdE2XdBF/NyfyHvXf48U4kdZg3W9/ASHJ5CU9zRrJWRX+43B3W
         1xhW05pH7MANw+8CcQxbu+9DDFl02VW5QqXySjhCeEHUBYD+7ZQl2Sy4Nnbmk5b9zssT
         UmCCWN6EFpqfDZFr+xppleLWTCMGFTMX/DWpvitYjpg3SMuvNfVS06BMmw3nGaAMZqWD
         UwWXb65uCYQLTUbf7OMF1Olagjz5tkIJYCL/1spX9eAlBltpeV8aMp47Ux6NhxZnICg9
         RZTA==
X-Gm-Message-State: AOJu0YxF4d9UaDvbOhUwXltQeBCAgvRBX8PdbFmjLgwWKj1NM22Nqb+3
	vqg+kprUhq3/iU2MmcRcQB4W5t/N1VEjysRV5CaIucrqIJCP8lKEEQSwdDNnG0Y1/fffaAnM565
	OIyr+IxwXarVa8QSM/PyNeDTNtXk8GKPEC6W3h1ckJ4/MMIxoSNA=
X-Gm-Gg: ASbGncuoT9cV7cwcsW+7ydl6eBKsl5DAHf7b57SrWDJkdMKkegJ0FP6F+aRaIAxR8z5
	yjE4w+gBbKq2opnYECa89tXud3WIaAJloGBFWlehcOHveIsNEgYCuYjjP3z8WY+n9qyqERRVlk5
	SfeG6ZTkYTczXYgQIjTenBhjLnKMgxWvw22YArjyGuxBBiREFy6mZviiMGujLhT2iu
X-Google-Smtp-Source: AGHT+IG4IZaoNkvRVKDzjVKbKIFzE/3psVUcmLfbZLgj5FXPKyORsxzJGTRDuB6JKK04vnZMts+sE8XiaT4hAEYEAdQ=
X-Received: by 2002:a05:6122:8c03:b0:529:2644:8c with SMTP id
 71dfb90a1353d-52c37ab714emr3191911e0c.8.1746638909299; Wed, 07 May 2025
 10:28:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 7 May 2025 22:58:18 +0530
X-Gm-Features: ATxdqUEMZ5W4dbsisOcqI2zyoKIHW94ya2MhqqQpRIXO8khKuthGJXEdEPM65MY
Message-ID: <CA+G9fYvcXTuxC0ncXBQYh8FZE2BxGSuTi6dvN_sWxBRcOAN8tQ@mail.gmail.com>
Subject: next-20250507: arm64 local label `"3" (instance number 1 of a fb
 label)' is not defined
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, linux-kernel@vger.kernel.or, 
	lkft-triage@lists.linaro.org, Linux Regressions <regressions@lists.linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Eric Biggers <ebiggers@google.com>, Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Regressions on arm64 lkftconfig failed with gcc-12 on the Linux next-20250507.

First seen on the next-20250507
 Good: next-20250506
 Bad:  next-20250507

Regressions found on arm64:
  - build/gcc-12-lkftconfig-graviton4

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: arm64 local label `"3" (instance number 1 of a fb
label)' is not defined

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build log arm64
/tmp/ccRYUGrZ.s: Assembler messages:
/tmp/ccRYUGrZ.s: Error: local label `"3" (instance number 1 of a fb
label)' is not defined
make[5]: *** [scripts/Makefile.build:335:
arch/arm64/lib/crypto/sha256-ce.o] Error 1

## Source
* Kernel version: 6.15.0-rc5
* Git tree: https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next.git
* Git sha: 08710e696081d58163c8078e0e096be6d35c5fad
* Git describe: next-20250507
* Project details:
https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250507/
* Architectures: arm64
* Toolchains: clang-20, gcc-12
* Kconfigs: lkftconfig

## Build arm64
* Build log: https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250507/testrun/28349400/suite/build/test/gcc-12-lkftconfig-graviton4/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250507/testrun/28349400/suite/build/test/gcc-12-lkftconfig-graviton4/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250507/testrun/28349400/suite/build/test/gcc-12-lkftconfig-graviton4/details/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2wl9II1HZVx3jggzwK4WceUmGrN/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2wl9II1HZVx3jggzwK4WceUmGrN/config

## Steps to reproduce on arm64
 - tuxmake  \
    --runtime podman  \
    --target-arch arm64  \
    --toolchain gcc-12  \
    --kconfig defconfig  \
    --kconfig-add
https://gitlab.com/Linaro/lkft/kernel-fragments/-/raw/main/graviton3_defconfig
 \
    --kconfig-add
https://gitlab.com/Linaro/lkft/kernel-fragments/-/raw/main/lkft.config
 \
    --kconfig-add
https://gitlab.com/Linaro/lkft/kernel-fragments/-/raw/main/lkft-crypto.config
 \
    --kconfig-add
https://gitlab.com/Linaro/lkft/kernel-fragments/-/raw/main/distro-overrides.config
 \
    --kconfig-add
https://gitlab.com/Linaro/lkft/kernel-fragments/-/raw/main/netdev.config
 \
    --kconfig-add
https://gitlab.com/Linaro/lkft/kernel-fragments/-/raw/main/systemd.config
 \
    --kconfig-add
https://gitlab.com/Linaro/lkft/kernel-fragments/-/raw/main/virtio.config
 \
    --kconfig-add CONFIG_SYN_COOKIES=y  \
    --kconfig-add CONFIG_SCHEDSTATS=y debugkernel dtbs dtbs-legacy
headers kernel modules


--
Linaro LKFT
https://lkft.linaro.org
