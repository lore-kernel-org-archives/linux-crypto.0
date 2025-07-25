Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0945724677C
	for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 12:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753445978; cv=none; b=ZZUJ1S1kKgwr1FtMVga0Z/V+JD2jboP9TS9PA0Kmac17WP6VdK7Xp0MODkrJxUGTAFJJzpADlOxcyzw8bhw2uz3vwwj4c6j8UJylL7DK4wJ14HL3v47i40aiHh5vsXlVXCYq1ycUOJcRd82pIm/KYrEIofeYc5cD/WL9chwAFDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753445978; c=relaxed/simple;
	bh=C0Hps5C7VVp6TMJa5SSauLjDYas/RuYUmWcHmSjZVvE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=MZuY35olHil2Kr5X+W5SLYJaModDEaNr5J6qPTpQfqMODapIaosPg7s3XjhVFPmhuPQwcGCkfZb1L+qn2wKC4FJ+O2SBZkpOJDdy6Nvg1su0c6EfTZJmHdZ4S0ak4Xob450bftrIEmE6SMZd2xDrp/i5XQpCoFoL0S+qyKK2ssA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NEEhQoUi; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NEEhQoUi"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-7fd35b301bdso2635122a12.2
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 05:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753445976; x=1754050776; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NeMfxo6+NjtkxLuUXyqyKSelgastqUQJsatQRBwVL9M=;
        b=NEEhQoUi8aw7gVz9S7RUOn0EpZ6sZZBXtdJhETduRQNut86xa6uyvjlOruHOaLwWGR
         lIW5aBvdlp85Ug95xubBgEZOo0g8a/yo++wCr/q2vYpREYRPVU4SbxtynPTp/cf/908U
         /x6gbiG7nVFLwJL6q9DQ9gJ/Wr7uwpz1FHxn09e5Kq1bUVfErW1Qd842MKNhEeFLi1Fg
         N3MzTG+cPj4ymf2D7381kHxktIS508x8YDBGfEOG1Kv9GF8sziy6vhCpIPo/9eIZ1F6n
         ydKd+rcO3PBm1Q2Aqw+dK300JTFpKBqeGKQYVn9GMw6F2LE2pUYQIFL0sbICZDYHZ3U0
         nkew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753445976; x=1754050776;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NeMfxo6+NjtkxLuUXyqyKSelgastqUQJsatQRBwVL9M=;
        b=Hojs8HTF2KJiQ+ZCB4vWxtdTTZFuIZoOeZdNVP+dSbjSbbTkTdz2bp/mXdqYztnZhV
         yR112mPBGgmijN51DyYOKd2DAD/c+o3SlVPU9nqv7F1Fhq0aUr9IKOzUCJLo+exz89ar
         50wKslCu/0I7HWWXF1tWeRzAaDAOTdZOs+AnH0Q1zjdeKpX66oTJuY8rrug16VfAH1+Z
         i2x/JW6bOC1xxE52BaLdEKBcIa0Prid52HUaPO0ovIArSWzxUZlzVizIUfRrO6JWFeKm
         ljaMRapRFALcbm2Z0TgQcnpaTL3J7vx94d4uxZmZCS85MK+P7m7FHV9PM7TRwDuRzNAy
         ZF2Q==
X-Gm-Message-State: AOJu0Yye7pFvT8ev4ZNTRLkXQPHWcX+YMMVF6s7yMdWlQ5nw+sK2NonH
	AJDxai+B7ss+nDUMSJB1Z4NMYXOVgCXsYQnFldYR4m4p20c7DDmmBwowBVgMABL0sTmh1F8UUcs
	47EAjjuemvdnhSqGjvqvDLdOB3xakfnRgykxD2cqcdLwozRosSolNEog=
X-Gm-Gg: ASbGncsrjXum6cWLgtI7a5B5CFKVh11p4p61H4/ijoRonjrD0nxgpOZ64ZkAwjgtWvB
	1/dm6lNAT9pKk6bqZvLgqXM34fRRHTdDZodZApdltePxTDX7+tC/Ow8LVgu9P1D+yB3QhxRSM3y
	5v9qL1LoiCm9DApN3vbjUnuNZgdaboifyCWoX45Mpa+EESv5wZbWNbMcglxXXkolhRcKJmjrtXL
	u73JzlnZonNvzBHWf9nNamc1iZCJyC6/tobumE=
X-Google-Smtp-Source: AGHT+IGdYljlX5X3dzqQG4BZUzWT+e8A4L5gJt/XoCo4bLpcHRLiUWIeX/SHGfQbsZ8DVFMGkkjaR0FrY9REWiry2is=
X-Received: by 2002:a17:903:1b05:b0:234:b743:c7a4 with SMTP id
 d9443c01a7336-23fb30e42a3mr30388225ad.38.1753445975730; Fri, 25 Jul 2025
 05:19:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 25 Jul 2025 17:49:24 +0530
X-Gm-Features: Ac12FXwd36DF0XFKorhLZXh2IFhKm9PTaX7sVXvKuHjnNnv3_TFODhgbB7WE3cU
Message-ID: <CA+G9fYs2LDdWX-w=7JA26tkYN450qg0230H9mfB-PymqmPsZ4Q@mail.gmail.com>
Subject: next-20250725 nomadik-rng.c undefined reference to `amba_release_regions'
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	lkft-triage@lists.linaro.org, Linux Regressions <regressions@lists.linux.dev>
Cc: Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"

Regressions noticed while building x86_64 and s390 builds with gcc-13
toolchain with allyesconfig on the Linux next-20250725 tag.

First seen on the Linux next-20250725
Good: next-20250724
Bad:  next-20250725

Regression Analysis:
- New regression? Yes
- Reproducibility? Yes

* s390, build
  - gcc-13-allyesconfig

* x86_64, build
  - gcc-13-allyesconfig

Build regression: next-20250725 nomadik-rng.c undefined reference to
`amba_release_regions'

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build log
x86_64-linux-gnu-ld: nomadik-rng.c:(.text+0x6fa057a): undefined
reference to `amba_release_regions'
x86_64-linux-gnu-ld: nomadik-rng.c:(.text+0x6fa05a0): undefined
reference to `amba_release_regions'

## Source
* Git tree: https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next.git
* Project: https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250725/
* Git sha: d7af19298454ed155f5cf67201a70f5cf836c842
* Git describe: 6.16.0-rc7-next-20250725
* kernel version: next-20250725
* Architectures: x86_64 s390
* Toolchains: gcc-13
* Kconfigs: allyesconfig

## Test
* Test log: https://qa-reports.linaro.org/api/testruns/29245454/log_file/
* Test details:
https://regressions.linaro.org/lkft/linux-next-master/next-20250725/log-parser-build-gcc/general-ld-undefined-reference-undefined-reference-to-amba_release_regions/
* Test plan: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/builds/30LiIUwnkUApDe74DgNCqkngoPB
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/30LiIUwnkUApDe74DgNCqkngoPB/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/30LiIUwnkUApDe74DgNCqkngoPB/config

## steps to reproduce
 * tuxmake --runtime podman --target-arch x86_64 --toolchain gcc-13
--kconfig allyesconfig

--
Linaro LKFT
https://lkft.linaro.org
