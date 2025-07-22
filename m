Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FB4372;
	Tue, 22 Jul 2025 00:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753142735; cv=none; b=TYWMhdxpHKYpc62eceV0n8zZF3g003whpxhJrJ5IlbsfnGnMo1mB8m3pUXlylA9N/CScKxCJJ0+nzNhmkMFNjjxqwGlVJHyIaxPAojz6gT1YwgFwu+/YEoPg1ziJFPinC6YdnPnDbbXHGFBpGQDSVvhyyifhOKEakWSYdK6WcS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753142735; c=relaxed/simple;
	bh=hqgqt25X+/WxZm+XOfMjvIfCy/+yrPeiHQqgFXW0vkw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LqsIQdHgaL1Xhd9MqZ43CB9VV15vULm1iSC5gHnwpBTO1VsB9Lg8WjhtaSNd14MaYXYf8LDgfetv3JyC3krXJpjZ8z72H8jIcgyu3iT7lgUbDj0GIPe8ePiNFL1pISdjblHREEzDyrrrco6lIJqa/MD/9OJ7r2u536zJITBHOTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uuni8npE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uuni8npE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F68C4CEF5;
	Tue, 22 Jul 2025 00:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753142735;
	bh=hqgqt25X+/WxZm+XOfMjvIfCy/+yrPeiHQqgFXW0vkw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Uuni8npESzyZccRb4DxUe5dVbjGT8BqC73sh1e8L9P5dbPq7/K17O3ysp4SEDu/dC
	 qFqLHlSu8i/1axNF2pyvk4mCPGPUm+gO6LTY4nFp9Kp7IU0qiEvvmy3vwhpv0paozB
	 9s4AHSm7lYvBbLW9FouZPbRBOu7l5SU119E/VaK1SXyj/cIq8aoKWS3GQopdZMwddQ
	 /eASINnSHCEF7Zz+CFS+5S7vJj2txRqw4kU43BeI/3ouYd/nOzVeXPezhl4H0Uin7K
	 3ZOMc/2WuHrLS7V+tWI9CqPxWISA9dxNVybUe5DfjL6LOoekH4gVDOPZJw77adk32B
	 YzFfuaJHZlS/w==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-55a27e6da1cso4152214e87.3;
        Mon, 21 Jul 2025 17:05:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU6HzF6fUr5YAT+SpwN6fR66AuARqPd4lYCYCvRZQ/r65Y00CCwejVtklrv7bj6skJLp5AoCmd/edmZf1E=@vger.kernel.org, AJvYcCUQAv88lE3eZCFFep4jDrSewthh/ucQnLz63tiAjAz8zk+SZGl16fHEm1dKrgpt9/6SU4F4lNa4ADb4RXGO@vger.kernel.org
X-Gm-Message-State: AOJu0YzsXbCCB5KZgnTEVlSsQ/in/h89tA/5751pv1NqpGvCk+BzV9nc
	cQnpDp6w6rSJwcs87pU24EJLd0OUYIZKyQT+M9Sv6XMXBiuanDR4g0+lmB5qWzz46L5V0XalCq9
	HgLVNoO/YvndWIhLV4zJZwqdVATCcBxM=
X-Google-Smtp-Source: AGHT+IHscF03ly8mnZnW/UiXgnQLyDCMh1kQWvQ3aIj/Lr06cOLNH0g5HAuMZ9vUjyT+Asb0ztXeg6Uvmy1Emfm5GwY=
X-Received: by 2002:a05:6512:b19:b0:553:241d:4e77 with SMTP id
 2adb3069b0e04-55a23efbfd8mr5815800e87.22.1753142733397; Mon, 21 Jul 2025
 17:05:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250721231917.3182029-1-linux@roeck-us.net>
In-Reply-To: <20250721231917.3182029-1-linux@roeck-us.net>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 22 Jul 2025 10:05:22 +1000
X-Gmail-Original-Message-ID: <CAMj1kXEY1xtHpwQwsCqDqvgNyYwf=NocXysKOXyYMeWfaeLuZg@mail.gmail.com>
X-Gm-Features: Ac12FXxrwa2MgDMC5KiJVj9gTa0hsZoyGxpKOAfytDhF3HVO_7IBWhRaCHmfPdg
Message-ID: <CAMj1kXEY1xtHpwQwsCqDqvgNyYwf=NocXysKOXyYMeWfaeLuZg@mail.gmail.com>
Subject: Re: [PATCH] lib/crypto: tests: Annotate worker to be on stack
To: Guenter Roeck <linux@roeck-us.net>
Cc: Eric Biggers <ebiggers@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 22 Jul 2025 at 09:19, Guenter Roeck <linux@roeck-us.net> wrote:
>
> The following warning traceback is seen if object debugging is enabled
> with the new crypto test code.
>
> ODEBUG: object 9000000106237c50 is on stack 9000000106234000, but NOT annotated.
> ------------[ cut here ]------------
> WARNING: lib/debugobjects.c:655 at lookup_object_or_alloc.part.0+0x19c/0x1f4, CPU#0: kunit_try_catch/468
> ...
>
> This also results in a boot stall when running the code in qemu:loongarch.
>
> Initializing the worker with INIT_WORK_ONSTACK() fixes the problem.
>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Fixes: 950a81224e8b ("lib/crypto: tests: Add hash-test-template.h and gen-hash-testvecs.py")
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  lib/crypto/tests/hash-test-template.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/lib/crypto/tests/hash-test-template.h b/lib/crypto/tests/hash-test-template.h
> index ffee1741a1b3..f437a0a9ac6c 100644
> --- a/lib/crypto/tests/hash-test-template.h
> +++ b/lib/crypto/tests/hash-test-template.h
> @@ -398,7 +398,7 @@ static void run_irq_test(struct kunit *test, bool (*func)(void *),
>          */
>         hrtimer_setup_on_stack(&state.timer, hash_irq_test_timer_func,
>                                CLOCK_MONOTONIC, HRTIMER_MODE_REL_HARD);
> -       INIT_WORK(&state.bh_work, hash_irq_test_bh_work_func);
> +       INIT_WORK_ONSTACK(&state.bh_work, hash_irq_test_bh_work_func);
>
>         /* Run for up to max_iterations or 1 second, whichever comes first. */
>         end_jiffies = jiffies + HZ;
> --
> 2.45.2
>
