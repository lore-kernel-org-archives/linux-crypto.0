Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6891222A4EF
	for <linux-crypto@vger.kernel.org>; Mon, 23 Jun 2025 23:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750721036; cv=none; b=W8HiiBCNt8dljM4oZY+l5G5gixz0BVE0bIt6SyWAjwQqHhQV/4/yW18bAqM7wArEDbiQG8BWfTzkb6G71BQwUG+bWE+F7SQ2OQdQSo5zXxaQkiU30BhcBrAHV5NFRGdhMrmlibUgNbtqLdkfd9CrmxB1BoHF91l/PUjNOBa1GuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750721036; c=relaxed/simple;
	bh=vP5+0drxEJoLf9RIzIy0U7Sua2x4szgGO0Sc8NDmFPY=;
	h=Date:Subject:In-Reply-To:CC:From:To:Message-ID:Mime-Version:
	 Content-Type; b=lqSTmHpnMXjPU1c5f0ZFy0YPqwyOTV8A+kpEyear3ERhj628mguAljuWqoAmtlGEY2uLMF3TSu9u8/CPaLI55zhMh7Lqqze2b1ZI2dNxzPtCiGzxUSyDZt/aY6RPlT/PLPjvr6AHgAuiqd5WKVfHk/B3EDJVyVYrhzMomr+ZAK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com; spf=pass smtp.mailfrom=dabbelt.com; dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b=JwfU6mSU; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="JwfU6mSU"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7390d21bb1cso3714752b3a.2
        for <linux-crypto@vger.kernel.org>; Mon, 23 Jun 2025 16:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1750721033; x=1751325833; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IgHNU976VfrOwOD3ulvb2vI7O/PDlbsrK2gzKqrmtPs=;
        b=JwfU6mSUsC5mp9UqArTdPwKYB01CULbnSZqskytJbCWAESCTo/Om2jgCjth64lfuwv
         QY7Invz4kz7w8wA1QnVhIB1zfvpsylExkZToowQleJ8Dm4S9za+I1ulsC1ujc7HOxMdm
         PI/GC1G8svz/s7RSqbwdESd9mSbnnw3Xm3a/vhoeHo37t0BbQ9H/MEmfCNdjkgpQDLl3
         hii2WYCXQ+CqyXjVZcLHqv2Y1qWaqjastaCfCsxwo7h8haE42j9i8BrTql/62+Ioxvyg
         i6KLHsqDgBNx/zNymf7LTo1y4vHC4i+m5zO/CZbbM+S/spcOUl8xKixEsqk3MyZbI0e7
         enIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750721033; x=1751325833;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IgHNU976VfrOwOD3ulvb2vI7O/PDlbsrK2gzKqrmtPs=;
        b=JpugfbUoqMqtzvhOu7jkS8Pcws5wE4bmSWfAEjW7LpwTpUjrgkLyOppH0TMR2y87zh
         IO29b5VMsi4NRkL22BXTGH4JgISQMTLn5Gr7/tff7AS+2/yxh7/S1DjjTNuF7MovKuQ6
         4dIXkur+rNlwAnc68kPamcDhc4qonEZ/Xm8VP1ppb5lW6zNoEc5iryJkObjQ2YdIVHDt
         zwkPb5xRV6iICTLYPWNTKvGN2fzoPcNHXfHnxcHIOfGgdp9KVQ+YGlvk8q1Je3oYcU30
         rPgxfaRPQclT6NdV2xcyLi6Jx8pr14IsqTFWkZgr6c2MCz8mswsvlGoLbbYGcMpINAxO
         GMQA==
X-Gm-Message-State: AOJu0YzLy10p7QEIikg9zG82sw/BVGvtv/NcfkCOlVp8zZa3w1FMSvW2
	tbLL0na61cn1amzyJTD3EFh1v3SFoDP9rzwDOCQlX4ennbKEhfbI3g++2w9DAwHlZAgHueMaGOQ
	/fawtClE=
X-Gm-Gg: ASbGncv4J90PmyhPROsoSArmKr+9NXHWbcUy+eHxvv3ki5qVuQgYYad3zr/UQcktL6/
	lzPl+XChOlX3lDaElBU2tGAlrt3umyHxwMJM6WlajHi+YQF4LKVMbdv0o3gdyzD+w6q8emgAxzr
	riYORNNwT6/szX3Ja5Vgt+qUEQe5QRz3ezKVX7PpL0dLYR7ONE/9S9LBDhEblRfplLOld782GTu
	gjwK1wNYuqtaHKd4ASUMOrTy/nYscyNoqUtcaNKNeWdsUn3Yj2sKsl0RIxOF0jasaGXHiS+FDWZ
	dqO2etXYZSOuHJEWY8G4qP7AyHxLLjq2Y2vj+1XggooYFxnv81qcwSqGpn1/
X-Google-Smtp-Source: AGHT+IGv2SJju6xgRevma8Cx/i6GeIJiS1WAChIRaAqec6j+z8o+1u/uy+Lb1YfHwJThHoUvyYrxYQ==
X-Received: by 2002:a05:6a00:3cd4:b0:748:e38d:fecc with SMTP id d2e1a72fcca58-7490d71c76amr16954440b3a.22.1750721033150;
        Mon, 23 Jun 2025 16:23:53 -0700 (PDT)
Received: from localhost ([2620:10d:c090:500::4:8d10])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-749b5e211d1sm243166b3a.44.2025.06.23.16.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 16:23:52 -0700 (PDT)
Date: Mon, 23 Jun 2025 16:23:52 -0700 (PDT)
X-Google-Original-Date: Mon, 23 Jun 2025 16:23:50 PDT (-0700)
Subject:     Re: [PATCH v2 5/9] lib/crypto: riscv: move arch/riscv/lib/crypto/ into lib/crypto/
In-Reply-To: <20250619191908.134235-6-ebiggers@kernel.org>
CC: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Jason@zx2c4.com,
  Ard Biesheuvel <ardb@kernel.org>, linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
  linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
  sparclinux@vger.kernel.org, x86@kernel.org
From: Palmer Dabbelt <palmer@dabbelt.com>
To: ebiggers@kernel.org
Message-ID: <mhng-8FC37478-859D-40EA-A0E9-3EA86429DC53@palmerdabbelt-mac>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Thu, 19 Jun 2025 12:19:04 PDT (-0700), ebiggers@kernel.org wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> Move the contents of arch/riscv/lib/crypto/ into lib/crypto/riscv/.
>
> The new code organization makes a lot more sense for how this code
> actually works and is developed.  In particular, it makes it possible to
> build each algorithm as a single module, with better inlining and dead
> code elimination.  For a more detailed explanation, see the patchset
> which did this for the CRC library code:
> https://lore.kernel.org/r/20250607200454.73587-1-ebiggers@kernel.org/.
> Also see the patchset which did this for SHA-512:
> https://lore.kernel.org/linux-crypto/20250616014019.415791-1-ebiggers@kernel.org/
>
> This is just a preparatory commit, which does the move to get the files
> into their new location but keeps them building the same way as before.
> Later commits will make the actual improvements to the way the
> arch-optimized code is integrated for each algorithm.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/riscv/lib/Makefile                                         | 1 -
>  lib/crypto/Kconfig                                              | 2 +-
>  lib/crypto/Makefile                                             | 1 +
>  {arch/riscv/lib/crypto => lib/crypto/riscv}/Kconfig             | 0
>  {arch/riscv/lib/crypto => lib/crypto/riscv}/Makefile            | 0
>  .../riscv/lib/crypto => lib/crypto/riscv}/chacha-riscv64-glue.c | 0
>  .../riscv/lib/crypto => lib/crypto/riscv}/chacha-riscv64-zvkb.S | 0
>  .../crypto/riscv}/sha256-riscv64-zvknha_or_zvknhb-zvkb.S        | 0
>  {arch/riscv/lib/crypto => lib/crypto/riscv}/sha256.c            | 0
>  9 files changed, 2 insertions(+), 2 deletions(-)
>  rename {arch/riscv/lib/crypto => lib/crypto/riscv}/Kconfig (100%)
>  rename {arch/riscv/lib/crypto => lib/crypto/riscv}/Makefile (100%)
>  rename {arch/riscv/lib/crypto => lib/crypto/riscv}/chacha-riscv64-glue.c (100%)
>  rename {arch/riscv/lib/crypto => lib/crypto/riscv}/chacha-riscv64-zvkb.S (100%)
>  rename {arch/riscv/lib/crypto => lib/crypto/riscv}/sha256-riscv64-zvknha_or_zvknhb-zvkb.S (100%)
>  rename {arch/riscv/lib/crypto => lib/crypto/riscv}/sha256.c (100%)

I'm assuming you want to keep these all together.

Acked-by: Palmer Dabbelt <palmer@dabbelt.com>

Thanks!
