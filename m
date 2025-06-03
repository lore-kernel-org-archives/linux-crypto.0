Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6381C7005
	for <linux-crypto@vger.kernel.org>; Tue,  3 Jun 2025 04:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748926595; cv=none; b=EeEEnUDBVTftKIkEbJtmN5ERlYWEdafMrCW6sofMfpD8SOb1BtFsqu6UjVz2PRYggWPAzZTI6n6j2rw04TloRU4arQvG3nJxl4z7atKNvceuBtQCe40ZjAm7RPmQractmTf32Jxchspo0mKNKvGNbHhDEii0do+HS0/en4N2/6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748926595; c=relaxed/simple;
	bh=oYMqfULeZPGoKCGddcD1RK8vhILr9q8b53wOjmMVyoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XuKv6zzYYbKVZZG7YbSeEYHknvqUugMWspLtAXpK8+2Cq0AbXum/NCT5AlSbulxPLHolllSMOE4h2YPIGnKO+10gMGFJecuBtkL4KvIFkPoChthmIXVVtGYJUdST46t+cA24SEP9VOVzegwzxs9XlEpfgdmaFUSg49XUYOsT2rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ud/iC3kB; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ud/iC3kB"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-742af848148so3383627b3a.1
        for <linux-crypto@vger.kernel.org>; Mon, 02 Jun 2025 21:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748926591; x=1749531391; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bj5cAM1/rmK0n2hEMe5+To8Y8SpxiSCSEVLQ6lLbhIk=;
        b=Ud/iC3kB6b/gCTeqbTNygsKlK/qzrbo/1Ed2YbZqN2SA0LfScOqG6F3spY6kmGBx6h
         vKdPjn4kty+Zknd1Hl1YT7Poqnvux+ZS+4LQm2z2XsPSGSqYnoyR7UqduGIGmOOpRNnB
         /9J/iuNAeMpaowOolTiDVvD2uy2rkMO+8nmiT64UTbY1tYzw8oMcMvYpcopMisW4fJoq
         wXc7QL4/AiFWBPBjqDvuzaHuGg47tqRW7LYiCy0vfG0FplQDpa/IY0O5SbJ6BGMnRp53
         PfWGLy2hlQUFB/EYAy/tYVchPSDcFIsZXMm4BKLxbcOsJnQrg+yWDsM3a+/uwKQR3nO6
         levw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748926591; x=1749531391;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bj5cAM1/rmK0n2hEMe5+To8Y8SpxiSCSEVLQ6lLbhIk=;
        b=q+MOf3ervE5F7qIqM07tGoKDJQdE0gAEYAF2GygXqmdaqHBc7ESyWHH5VfB/59A7Bq
         sSChxCnDv89pBuyMX7Es3C/RSXssJX+w4P+ytXkBH20xJCFUL7X9tAATmRCxdygI+M0C
         YSjGVSK1EPLeM6/hUt5QVxkwX9E0w/Z2v7Kk3/n7XBoGM26gaET11XDL4VDMkRj0eQXz
         LQmDiYEeilupPSSTMPgPmTX4SlNS7S4FFVunoM6y1cFhks59Nox3KR1ShPVMq+VWVV5X
         ZZISib6x4RW0pBPa8FhoNUv0Pp/BfUcTnN2+cEOFdkAO8gXkleYCZaxEyI5kOZZcNazX
         XoDQ==
X-Gm-Message-State: AOJu0YxzU1BVyvk9hVxs/an5vT+3PYoMd6W7xmFfu8xy4nhEQv0xHh+l
	2UijjmTIO9wtD/jx7AtYF3hQr5TEI922Z8ZPg939/Nr9wqKU7eFikDt2
X-Gm-Gg: ASbGncvLfh05m3B/eoIqPQr2Bl8HKRq2pUMV4lh2an3bnul1zFHg9O3Zb7Zt9k1gNBu
	UWh2hV/DJvRN13khIvlYsc1s5jEmMjjEJ3iOhNWbcsKfuYuOKzF4TfYFcNQUgGO+i+QGZlsYpPF
	RUbX8/vSs0wyWxoN0GGHKQCZpGFa8cGy3JCS2e+S4OxxHRJcRIcidx0WBBzdHEnqMpnCmUKQaCc
	KTpf0aBSoYBc4ikMEkg0GRoNncxDpjiaULiLbymmN/zuOf2PmrXbVvjCGDpp+mibdGua/i0Nj2V
	/Rsb6Pwkc5evBqeNRRb21cDROZa1E1aO+U7aGlIesXglVOlB6befFsAgZHvmD+/S
X-Google-Smtp-Source: AGHT+IHJ9xKtdl5zDj/gyXRWXE1LClYzP6+346qAd6s0tgh3W5JiHGwy+E7+vAoDxPugtmCWu5XIdA==
X-Received: by 2002:a05:6a20:7349:b0:1f5:95a7:8159 with SMTP id adf61e73a8af0-21ba1165cb7mr17413574637.10.1748926591543;
        Mon, 02 Jun 2025 21:56:31 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-747afff7464sm8549267b3a.180.2025.06.02.21.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jun 2025 21:56:31 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 2 Jun 2025 21:56:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	linux-rt-devel@lists.linux.dev
Subject: Re: [v2 PATCH 1/9] crypto: lib/sha256 - Add helpers for block-based
 shash (RT build failure)
Message-ID: <85984439-5659-4515-a2bb-09cdad69a3e3@roeck-us.net>
References: <cover.1746162259.git.herbert@gondor.apana.org.au>
 <c9e5c4beaad9c5876dc0f4ab15e16f020b992d9d.1746162259.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9e5c4beaad9c5876dc0f4ab15e16f020b992d9d.1746162259.git.herbert@gondor.apana.org.au>

Hi,

On Fri, May 02, 2025 at 01:30:53PM +0800, Herbert Xu wrote:
> Add an internal sha256_finup helper and move the finalisation code
> from __sha256_final into it.
> 
> Also add sha256_choose_blocks and CRYPTO_ARCH_HAVE_LIB_SHA256_SIMD
> so that the Crypto API can use the SIMD block function unconditionally.
> The Crypto API must not be used in hard IRQs and there is no reason
> to have a fallback path for hardirqs.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

This patch triggers the following build error. It is seen when
trying to build loongson3_defconfig + CONFIG_PREEMPT_RT.

Error log:
In file included from /opt/buildbot/slave/qemu-loongarch-rt/build/include/asm-generic/simd.h:6,
                 from ./arch/loongarch/include/generated/asm/simd.h:1,
                 from /opt/buildbot/slave/qemu-loongarch-rt/build/include/crypto/internal/simd.h:9,
                 from /opt/buildbot/slave/qemu-loongarch-rt/build/include/crypto/internal/sha2.h:6,
                 from /opt/buildbot/slave/qemu-loongarch-rt/build/lib/crypto/sha256.c:15:
/opt/buildbot/slave/qemu-loongarch-rt/build/include/asm-generic/simd.h: In function 'may_use_simd':
/opt/buildbot/slave/qemu-loongarch-rt/build/include/linux/preempt.h:111:34: error: 'current' undeclared (first use in this function)
  111 | # define softirq_count()        (current->softirq_disable_cnt & SOFTIRQ_MASK)
      |                                  ^~~~~~~

While the problem is only exposed by this patch, it does not seem to be
straightforward to fix: preempt.h does not directly include asm/current.h,
and doing so only exposes follow-up build failures.

Reverting this patch after also reverting the follow-up patch touching
sha256.c fixes the problem.

Copying scheduler and realtime subsystem maintainers for advice.

Guenter

---
bisect log:

# bad: [cd2e103d57e5615f9bb027d772f93b9efd567224] Merge tag 'hardening-v6.16-rc1-fix1-take2' of git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux
# good: [0ff41df1cb268fc69e703a08a57ee14ae967d0ca] Linux 6.15
git bisect start 'HEAD' 'v6.15'
# bad: [b08494a8f7416e5f09907318c5460ad6f6e2a548] Merge tag 'drm-next-2025-05-28' of https://gitlab.freedesktop.org/drm/kernel
git bisect bad b08494a8f7416e5f09907318c5460ad6f6e2a548
# bad: [a9e6060bb2a6cae6d43a98ec0794844ad01273d3] Merge tag 'sound-6.16-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
git bisect bad a9e6060bb2a6cae6d43a98ec0794844ad01273d3
# bad: [3349ada3cffdbe4579872a004360daa31938f683] Merge tag 'powerpc-6.16-1' of git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux
git bisect bad 3349ada3cffdbe4579872a004360daa31938f683
# good: [8fdabcd9c01d9ac585d8109a921e0734a69479fb] Merge tag 'gfs2-for-6.16' of git://git.kernel.org/pub/scm/linux/kernel/git/gfs2/linux-gfs2
git bisect good 8fdabcd9c01d9ac585d8109a921e0734a69479fb
# bad: [2297554f01df6d3d4e98a3915c183ce3e491740a] x86/fpu: Fix irq_fpu_usable() to return false during CPU onlining
git bisect bad 2297554f01df6d3d4e98a3915c183ce3e491740a
# good: [0d474be2676d9262afd0cf6a416e96b9277139a7] crypto: sha3-generic - Use API partial block handling
git bisect good 0d474be2676d9262afd0cf6a416e96b9277139a7
# good: [7db55726450af0373b128e944f263b848eaa7dc2] crypto: qat - expose configuration functions
git bisect good 7db55726450af0373b128e944f263b848eaa7dc2
# bad: [bde393057bbc452731a521bafa7441932da5f564] crypto: null - merge CRYPTO_NULL2 into CRYPTO_NULL
git bisect bad bde393057bbc452731a521bafa7441932da5f564
# bad: [ecd71c95a60e7298acfabe81189439f350bd0e18] crypto: zynqmp-sha - Fix partial block implementation
git bisect bad ecd71c95a60e7298acfabe81189439f350bd0e18
# bad: [5b90a779bc547939421bfeb333e470658ba94fb6] crypto: lib/sha256 - Add helpers for block-based shash
git bisect bad 5b90a779bc547939421bfeb333e470658ba94fb6
# good: [165ef524bbeb71ccd470e70a4e63f813fa71e7cd] dt-bindings: rng: rockchip,rk3588-rng: add rk3576-rng compatible
git bisect good 165ef524bbeb71ccd470e70a4e63f813fa71e7cd
# good: [8fd17374be8f220c26bec2b482cabf51ebbaed80] crypto: api - Rename CRYPTO_ALG_REQ_CHAIN to CRYPTO_ALG_REQ_VIRT
git bisect good 8fd17374be8f220c26bec2b482cabf51ebbaed80
# good: [7d2461c7616743d62be0df8f9a5f4a6de29f119a] crypto: sun8i-ce-hash - use pm_runtime_resume_and_get()
git bisect good 7d2461c7616743d62be0df8f9a5f4a6de29f119a
# first bad commit: [5b90a779bc547939421bfeb333e470658ba94fb6] crypto: lib/sha256 - Add helpers for block-based shash
