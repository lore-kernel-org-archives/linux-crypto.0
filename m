Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE163C5529
	for <linux-crypto@vger.kernel.org>; Fri, 10 Apr 2026 13:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775828409; cv=pass; b=tIvNe2WhG0mnlRCbzWfqkVB//zV7GtWLVCbgYp4xhESPxYxuMseZYSNTqI9pKJO8irTHVn/L2BjVeA6qMZKeAVnoLlmu4uDdr39VjdbNsuhfa7ehIijZqE6jZrF/Xd/aEOwtGVQq0vaSL3Aun1xZUlivK2Sp9FPAi8sp5Eh/TvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775828409; c=relaxed/simple;
	bh=LSR04DrYd2CNPoGkLuzcgQfT1tMVn5ZfdEM6iihG19s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eIMaxW8jLtbWR3hVjZbpmw3t3q6EFnzQIl75U4063oGC2Npyu5WWRqgkCa323/nH46BXYPOEvL+bXgpl860GxmzFEUxSxrV9wR6/kKcLzKIUmmblcnlWo2uMVSk/+loI0hm0EnG/jOb1IJ7VEb2FYBAjUwropQOqmGGR+aqNEzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WXkk7MjG; arc=pass smtp.client-ip=74.125.82.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WXkk7MjG"
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-128e4d0cc48so9423217c88.1
        for <linux-crypto@vger.kernel.org>; Fri, 10 Apr 2026 06:40:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775828407; cv=none;
        d=google.com; s=arc-20240605;
        b=hstErO9pnGQo8RGa/ReAyjo57K0PSYmsoWuKfhbVzxo+badDXTrcDtg/EJ1XM2FXDn
         m+RSCFe/DcaFuCVegIayE9Ki+r8pzzInf8s/h2W4cSk2PsHKBEOfGy216u7/pkKQ2gSf
         3rD1C5eSAI7F3xp1sC4oxJev0gKf9hZbvS+c5bqQKaJsomb6hc7Lu6bDtkAJgbNGXYhA
         Og0V4UzRXPOsc8wZF02FcLjKogyYUNi8Ai8bVfruu0sUAfpqUa6S2RQquC7F+565d3rK
         7NlxwvptRWf3QR2bY7d4PfCvsOU+3XdqXG6W+H4N7bpyj2y+C4aSoc8Y7lbKOsEd1Yiy
         Wd1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=iCXB7w7ko4o+lkpt1Tfr/OwLPxl1m2l/vGRhYm7vF9w=;
        fh=+3hwU3ecdJwR1gnlcMfm02LpD5qTmssoOratpkBvY9w=;
        b=Dh0xhsf/cuz58dzLM8Cwqfh5zleAkFcon/MpGPU4xeImVDeM4HHvnS7MZHhnwbHM+n
         Nc65silx124WWDhFipjBQoBsuquD01GLTn+RO3A83+DdUg9NydVDnOI+HlyHmtt13mHj
         pz+7ySTUDnM16ctFf9aE3tbJIFCrVceRojtMI/Rr/qOOvg0/d2yz5fJxgwcnIIGlne7x
         PkNHqA4UlbdyyvO+bEtoXkphXgYY7qa5vcZh2LbELNBjEQKTcsjt6/zKZ7o/Pz0joibf
         MAFHafToxESNLC7qtMyOhOFt/UdwxuSQnGLlt3d7syQolt+XGuK4zMTJ/e1tWcKVrQfP
         uBMg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775828407; x=1776433207; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iCXB7w7ko4o+lkpt1Tfr/OwLPxl1m2l/vGRhYm7vF9w=;
        b=WXkk7MjGsWCUHEg1iU7liVQxxmn76Z2Blc65Af4B1zix0M2rF8QfzApVNMifY6ss0I
         o28bXJ2WoZKKs4P+RMYVL7Cyz5rTozkqN1LFEZKxQrY0UWy/+P4MTVZ7JlV/GmTfYw7g
         BHdpmSI3dFIhezek0dIMEojwsl7VI9CpBDtWrVKxWRCyxE8FKu9tCx05MK1Z19mpDbLY
         UAmVUcxpvcLdZE3bWKkeviuFv+z6weHemrn+Q1dbNj19BdhmlV3lYWFxMcZ5yjPYSXjG
         1ICMvCFl+bVV4g0F5SiLzhG+oRaoJBenKb2hyA5tkvyV436rK7zq2Le6HAfSbviCkDzM
         W8gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775828407; x=1776433207;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iCXB7w7ko4o+lkpt1Tfr/OwLPxl1m2l/vGRhYm7vF9w=;
        b=CHwfnHxtNsJDaPpBcqDeDgKC3z+XT5PMMmjVI4+8QpsO7BMWdfxeM4ASk8GDQMPn4E
         zwcJqTfMUrUKKOaIfaxBVcrUoT1l+w9fZ7Kd6FTlFTNQbL0COqNt7L7a0mdr2WBWiqLI
         IQpAki2JKeGC8E3NEqKuetcKx4nMP/cx05n6CFipSdE1KkrYyd/HoAa5X0AZfaxr5oB3
         kgpwB7QO7U9oQLbh4GauTniOMt82ka8HN6dzzYA+44VFc9CWwnFeZNcd5YArXPC9VwvN
         xtMR4SpEG94Sz8a/4VOgpSWBHShkHfPS2FDVrpR6+VBvdb0NUEdLRWzmVwOrxWZf1qRJ
         q/ig==
X-Forwarded-Encrypted: i=1; AJvYcCXAT+lM5u4PYeBdBOy7FJ3QNBqxccuATXicY/fru04c+0cFMjKDxAQ6f5LBvbm9g4zAka0pfXRtebW2Rwc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/R5Crw1FTVVtD8Tr4NQ+5ozPKH2ZaYRC7bRPNmVI8XHnsrM0u
	TSPtRbx2ZwmSRT6MGA0gGoDT1hMdiVPV4rV9FyXIUTPxAV383mWMJt9qm8FCcB6t0QCr6csZhCK
	fVCcQj0RIVSP12X6VlV+xPy5D1pEbY7b6uGx/4sBgKzNq5KgEipglmzT2E4H9+Q==
X-Gm-Gg: AeBDieto1Ym/SbCUKrqYShbDbEysNDcdrNlpbFv+DnSjli4Rv+MVgv9B433asRDkVC6
	+2St6zSP2HvEvPvVAezl02y/78T7GGMprqPZi8meE7B2fht8NEVnRLVNLsuilnDHRI6sp+BMP7v
	9wgFT7SewabDL0ABji46mc/ifNL/rmLEaCz/6HBSO5zrmLQv62mbQD6TTw9UpLPC1viZWQdPQgP
	wTo+O37m5ORpxUkyMvCvpJq5ts0R9zNxKiR3gFfrmoAh8hORfQQXwLQjH0U1cPUPwpq1Fisayjj
	r3W1aOrx9HFVoITMCeeLIQM9NnUdGfMg6OstXeMsjizW+Sju
X-Received: by 2002:a05:7022:fa04:b0:12c:2ed4:62fa with SMTP id
 a92af1059eb24-12c34ef907emr1882312c88.32.1775828406651; Fri, 10 Apr 2026
 06:40:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260410120044.031381086@kernel.org> <20260410120318.862164111@kernel.org>
In-Reply-To: <20260410120318.862164111@kernel.org>
From: Marco Elver <elver@google.com>
Date: Fri, 10 Apr 2026 15:39:30 +0200
X-Gm-Features: AQROBzBE-9UxDQG5mMJLgipEeL_Y5pwE-Y_PUrJGxDBLilqBu51b8lLzxdip708
Message-ID: <CANpmjNO1vsO1LT6xijhz3nsjQa+_A=9omfgOSz=aGn293-LqTg@mail.gmail.com>
Subject: Re: [patch 19/38] kcsan: Replace get_cycles() usage
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev@googlegroups.com, Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, 
	Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev, 
	Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, 
	David Woodhouse <dwmw2@infradead.org>, Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org, 
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Thomas Sailer <t.sailer@alumni.ethz.ch>, 
	linux-hams@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Richard Henderson <richard.henderson@linaro.org>, linux-alpha@vger.kernel.org, 
	Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	loongarch@lists.linux.dev, Geert Uytterhoeven <geert@linux-m68k.org>, 
	linux-m68k@lists.linux-m68k.org, Dinh Nguyen <dinguyen@kernel.org>, 
	Jonas Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, 
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
	Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
	Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org, 
	Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 10 Apr 2026 at 14:20, Thomas Gleixner <tglx@kernel.org> wrote:
>
> KCSAN uses get_cycles() for two purposes:
>
>   1) Seeding the random state with get_cycles() is a historical leftover.
>
>   2) The microbenchmark uses get_cycles(), which provides an unit less
>      counter value and is not guaranteed to be functional on all
>      systems/platforms.
>
> Use random_get_entropy() for seeding the random state and ktime_get() which
> is universaly functional and provides at least a comprehensible unit.
>
> This is part of a larger effort to remove get_cycles() usage from
> non-architecture code.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Marco Elver <elver@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: kasan-dev@googlegroups.com

Reviewed-by: Marco Elver <elver@google.com>

> ---
>  kernel/kcsan/core.c    |    2 +-
>  kernel/kcsan/debugfs.c |    8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> --- a/kernel/kcsan/core.c
> +++ b/kernel/kcsan/core.c
> @@ -798,7 +798,7 @@ void __init kcsan_init(void)
>         BUG_ON(!in_task());
>
>         for_each_possible_cpu(cpu)
> -               per_cpu(kcsan_rand_state, cpu) = (u32)get_cycles();
> +               per_cpu(kcsan_rand_state, cpu) = (u32)random_get_entropy();
>
>         /*
>          * We are in the init task, and no other tasks should be running;
> --- a/kernel/kcsan/debugfs.c
> +++ b/kernel/kcsan/debugfs.c
> @@ -58,7 +58,7 @@ static noinline void microbenchmark(unsi
>  {
>         const struct kcsan_ctx ctx_save = current->kcsan_ctx;
>         const bool was_enabled = READ_ONCE(kcsan_enabled);
> -       u64 cycles;
> +       ktime_t nsecs;
>
>         /* We may have been called from an atomic region; reset context. */
>         memset(&current->kcsan_ctx, 0, sizeof(current->kcsan_ctx));
> @@ -70,16 +70,16 @@ static noinline void microbenchmark(unsi
>
>         pr_info("%s begin | iters: %lu\n", __func__, iters);
>
> -       cycles = get_cycles();
> +       nsecs = ktime_get();
>         while (iters--) {
>                 unsigned long addr = iters & ((PAGE_SIZE << 8) - 1);
>                 int type = !(iters & 0x7f) ? KCSAN_ACCESS_ATOMIC :
>                                 (!(iters & 0xf) ? KCSAN_ACCESS_WRITE : 0);
>                 __kcsan_check_access((void *)addr, sizeof(long), type);
>         }
> -       cycles = get_cycles() - cycles;
> +       nsecs = ktime_get() - nsecs;
>
> -       pr_info("%s end   | cycles: %llu\n", __func__, cycles);
> +       pr_info("%s end   | nsecs: %llu\n", __func__, nsecs);
>
>         WRITE_ONCE(kcsan_enabled, was_enabled);
>         /* restore context */
>
