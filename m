Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5A01F9F51;
	Fri, 21 Feb 2025 07:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740123547; cv=none; b=jFCXfiXUrOoKpnmi6sUn42RnoJQnDRjZE35oKPd8F3/D1e8I+SkE5mqeY+Qb0AQcLkfiAVmz0PczPiver1I63rbx2rEOvS94zWLiO83d1G5uqYVWTtXPYsWExLegnD1MXHsKiXxjbEyR+xueV5DTLyB27XlLR6oLAFZ/wLckY18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740123547; c=relaxed/simple;
	bh=b/GiAGqv7s9yuuud5Txj5aS72CRFiu7njwkY+rnk2PM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hUTPttGF4n5RNSsD7hh3VAK3YdmzNmvf2T0CpMz0tIdG3GnPd0yjrPM0rnlyUXiC3/mucnO6oq0CqDKXN8pZniohi7njGZ+7a+aSMYrAuyDkYTnmlTKrcypta9nhZia8a4SBrCMxk0Z1HM779+26wRRpKW3Wlm34oOs8FUJAU0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WrJq+F9S; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WrJq+F9S"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4397dff185fso15159225e9.2;
        Thu, 20 Feb 2025 23:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740123544; x=1740728344; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FPpdsdL4n88yx8HwEA3SbEzBAydGSiAFaXP8UXGVdK4=;
        b=WrJq+F9SgCNjUvWzfKeWmqVEgYccVhQ6aDkr2hwjaVK1WZmu5IIyT3p91/hcc9J7G2
         0PIOPhycQwhM8tCaBTdY+pKujEFdpy7SX7apd7LhszQnf5zgheV4al27sFyEYYlZZkfu
         Or2n/QY/SFFsWeRasu9hRXUEruQ4rluFozOclQkd/2j8XQOwm5vm9Sb2zzhUWH1qkFTY
         UJvkkVi4RYuVKK9Lg+hpMZlJ7Lk1nXPDVV8krj2Oi/0iUZx2hxrvYXsYfkDfMk6RfXqN
         HpWBj0K/HkH+1sC30ZwfeWE14voKpBs3p0yl3Yy8pQRyQzdkWyWobMm0Si2Sycq2W/US
         Fczg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740123544; x=1740728344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FPpdsdL4n88yx8HwEA3SbEzBAydGSiAFaXP8UXGVdK4=;
        b=mp020jHJ5Zh6R2IV/Lra0Kx4RUcMPJGnPNbSubn43eeOKc7cajujC4BYoO5sBjZFxd
         GxwQMJW/hQFs0FvXK0G58m7XIkLKGXQClgZOXgJSCqfzOlX0o2KVmIWgZKNNWuSVPFT2
         v1QaUJaEc0v9JrKkfmWrHgDl8u7jxXDs3gbodSVePdRGoqUSkz5UqX/f9VXb4lAT+mru
         JJobVCR+rn1GRmzxPXa9/E/N/sgJfPS1y4uc8OGidCaD8Z4nflr2ZMRDad/DxoR8b1D0
         EGmAGsYICb/pH+10F1m+4O1ZElRKvsNi/4iGKJr6RUvudz8FQ21oUwHoQuu1UMthdPYl
         jW+A==
X-Forwarded-Encrypted: i=1; AJvYcCWa8r2A0KSgCzXROqTVVHNKKXhvGr78WYi8KY9h5eos6JEViWH08WsOZisLz2zmdSGufI0bHJ0VkSa9Pr4=@vger.kernel.org, AJvYcCXmjn9J4VBoJ1juXaIhwXWdHrliCOncJEuu8R74pKyFvr44OvFtTVGksrw2y4G2oJGxk/dXuV28CSRgRAJU@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/oLbsC7KKJ2R5500STnM7mMkORW/1m/8MktPoI8OLicNnsK7y
	1o4mDpClMZFfqukc0wLwD47hcIh4rmQ8MmibUyml6bcn8TL+aB9J06LR/JQ7lmKyARed/OWf7Mo
	5GoznfsQ7lohnemxG/P9jtd3Lzs0=
X-Gm-Gg: ASbGncuvbgan58Xyh+btSBc8h7N5ITHc2jeEW1bFIxS8PzaOoSWDwJLBcKkwjEp642D
	1A6xzRFZeEiEtRkcvPCLuMFuJfBHY0+AJOW3WTwE2kXc0CX4YtGet4QEj9SOXnssHA1BnzREK+7
	INasijIw==
X-Google-Smtp-Source: AGHT+IGKzvTku4u3P+ZC0blF8cwRCmiouqJC8xvDkD7mTD+KrqUsUnan7eMjRClBQVvkTYZCKVCdYcufvFJIX6SQ9/A=
X-Received: by 2002:a05:600c:4fd3:b0:439:9543:9488 with SMTP id
 5b1f17b1804b1-439ae2196a6mr13824825e9.21.1740123544039; Thu, 20 Feb 2025
 23:39:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250220051325.340691-1-ebiggers@kernel.org> <20250220051325.340691-2-ebiggers@kernel.org>
In-Reply-To: <20250220051325.340691-2-ebiggers@kernel.org>
From: Xiao Liang <shaw.leon@gmail.com>
Date: Fri, 21 Feb 2025 15:38:27 +0800
X-Gm-Features: AWEUYZm1g7Mr-grFK6X7pFEBOlj1wJCqmi_y2CU0k4OaIFulJAdMCCqigR4Bje8
Message-ID: <CABAhCOQjnSsos3gm4GWrxFUdV8dw-=r_mMn0+xdjnZjJ0PQ9MA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] x86/fpu: make kernel-mode FPU reliably usable in softirqs
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Ben Greear <greearb@candelatech.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 20, 2025 at 1:16=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Currently kernel-mode FPU is not always usable in softirq context on
> x86, since softirqs can nest inside a kernel-mode FPU section in task
> context, and nested use of kernel-mode FPU is not supported.
>
> Therefore, x86 SIMD-optimized code that can be called in softirq context
> has to sometimes fall back to non-SIMD code.  There are two options for
> the fallback, both of which are pretty terrible:
>
>   (a) Use a scalar fallback.  This can be 10-100x slower than vectorized
>       code because it cannot use specialized instructions like AES, SHA,
>       or carryless multiplication.
>
>   (b) Execute the request asynchronously using a kworker.  In other
>       words, use the "crypto SIMD helper" in crypto/simd.c.
>
> Currently most of the x86 en/decryption code (skcipher and aead
> algorithms) uses option (b), since this avoids the slow scalar fallback
> and it is easier to wire up.  But option (b) is still really bad for its
> own reasons:
>
>   - Punting the request to a kworker is bad for performance too.
>
>   - It forces the algorithm to be marked as asynchronous
>     (CRYPTO_ALG_ASYNC), preventing it from being used by crypto API
>     users who request a synchronous algorithm.  That's another huge
>     performance problem, which is especially unfortunate for users who
>     don't even do en/decryption in softirq context.
>
>   - It makes all en/decryption operations take a detour through
>     crypto/simd.c.  That involves additional checks and an additional
>     indirect call, which slow down en/decryption for *everyone*.

Thank you for the detailed information.

> Fortunately, the skcipher and aead APIs are only usable in task and
> softirq context in the first place, nor is it supported to call them
> with hardirqs disabled.  Thus, if kernel-mode FPU were to be reliably
> usable in softirq context, no fallback would be needed.  Indeed, other
> architectures such as arm, arm64, and riscv have already done this.
>
> Therefore, this patch updates x86 accordingly to reliably support
> kernel-mode FPU in softirqs (except when hardirqs are disabled).
>
> This is done by just disabling softirq processing in kernel-mode FPU
> sections, as that prevents the nesting that was problematic.
>
> This will delay some softirqs slightly, but only ones that would have
> otherwise been nested inside a task context kernel-mode FPU section.
> Any such softirqs would have taken the slow fallback path before if they
> tried to do any en/decryption.  Now these softirqs will just run at the
> end of the task context kernel-mode FPU section (since local_bh_enable()
> runs pending softirqs) and will no longer take the slow fallback path.

I think this will delay all softirqs, including those that don't use
FPU. Will there be a performance impact?
(I guess you've noticed the patch I submitted last year. And this is
the main reason why it was implemented in the way you mentioned as
the second alternative.)
