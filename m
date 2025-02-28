Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017BF26738F;
	Fri, 28 Feb 2025 12:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740746402; cv=none; b=e6yIRIZYiCSLYspWTSdk2jrwr57cmmDtui6pIvDG+nPdX7TDgxIq4ybUfduIfwZ0sN0Nk1Uo5P/A8tYeCr8qpkJeeH9bmv+J1QBOyyx4qg6A8988xpaQ+Y+f/bwezPluwY4QjU4hvAwS441+H2P5W4gC7wijuvFDdDQ2ZEbycHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740746402; c=relaxed/simple;
	bh=vQmR1kpc/qeDZMF/Qgq52tU76GCNr7vw1s/819f3YJ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p+LczzPFYJZNuzq8waDFJzs+iazrKeephcEFwkEDhGKb+bC0xbSZLwW0NT1VuirY1LwjLYgzZcHWQ7hRwXeq4/+GPblcJif8Vq+FL3W1E1XsHIBf3QQtK5AEwKqMMvVyyB4zzkGrdMLd+zB97v9kzxphJsdx9Z1zUvavXBRoycQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P0P478oK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P0P478oK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A5EC4CEEA;
	Fri, 28 Feb 2025 12:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740746401;
	bh=vQmR1kpc/qeDZMF/Qgq52tU76GCNr7vw1s/819f3YJ8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=P0P478oKnNX0vF0r/Dz3i2lQPKeh2FLm4qR+IsZBZdIuB2eEjuMnXP5nEKFH+NIKb
	 TninQHZ8IqhPwtqOBJsFO1rRqfdvisrpst/dh5orZWTDVhXw9yVUL3xSJ6Bjau/YIJ
	 L0zjHHxf0N912hEupe/gradMfOa8RRVeR9F2unZqCY/xvbsRSv26oAaYlxho1ogsv3
	 2PThsP1+rRDr+3H1lhEdXGWVFJuFKJuW8OW2tRCw0DEWFHQF6ASg+r7X88iA6xQf7v
	 vN24m7g8CrClYdGkjI81XCfDoFFunj0Xcq6MMqUeSKZfgxChraEhOAeJi8DgLjBqTz
	 6odqAeTJOYmtA==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-546267ed92fso2124200e87.2;
        Fri, 28 Feb 2025 04:40:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUcozMUOnJQjIxqZkCelxwKx3WedRDTiYOFk84IelJ2XdkwCjwqTau96t5e05HVjn5GgjAhsXVWiopeRP7D@vger.kernel.org, AJvYcCWqTd0c+/O840VhiuD10hkBVWGhSAO8lKw9ZZUmDv+855O1OX7mNql9YOzj/1SstHZrL3IrAmJ4MUy4OD4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmZ8vIC+4Vszdd17U+9LTh0mE+vx3nQvpPmLStaG1ddfx/Qkol
	S8WrkcgEHkb9oF0OpwKb9hCNnwkbG89/0YxiavT8TL3o0XMM63jeRX5qvurbkuPz1HtI5IY9j+U
	E8o3p6rBvbgbVII8OchApzfj+3sM=
X-Google-Smtp-Source: AGHT+IG1ZhXMEhiYTjOCy0NzI7Eb0423hxYrdNajNkC8iWc1KAxbwLCjMNn15VYnBbRNLIqmRn5bAJaivZh1pqlAcgk=
X-Received: by 2002:a05:6512:31c1:b0:545:22fe:616f with SMTP id
 2adb3069b0e04-5494c3319e0mr1384091e87.24.1740746399751; Fri, 28 Feb 2025
 04:39:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250220051325.340691-1-ebiggers@kernel.org> <20250220051325.340691-2-ebiggers@kernel.org>
 <20250228035924.GC5588@sol.localdomain>
In-Reply-To: <20250228035924.GC5588@sol.localdomain>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 28 Feb 2025 13:39:48 +0100
X-Gmail-Original-Message-ID: <CAMj1kXH8ABcuUzPfAC=A6hzUvo+jPvWfphTtJqgGCTpbegAi0g@mail.gmail.com>
X-Gm-Features: AQ5f1Jpq11pDce8xKZ2gG0kJTVyocjGzLRmCUoN8VY_MzT-ld0oY95pvBRNWnqU
Message-ID: <CAMj1kXH8ABcuUzPfAC=A6hzUvo+jPvWfphTtJqgGCTpbegAi0g@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] x86/fpu: make kernel-mode FPU reliably usable in softirqs
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ben Greear <greearb@candelatech.com>, Xiao Liang <shaw.leon@gmail.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 28 Feb 2025 at 04:59, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, Feb 19, 2025 at 09:13:24PM -0800, Eric Biggers wrote:
> > To comply with the requirements of local_bh_disable and local_bh_enable,
> > this change also removes support for kernel-mode FPU in hardirq context
> > or with hardirqs disabled.  This should not be a problem, though.  There
> > does not appear to be any use case for kernel-mode FPU in such contexts,
> > and notably arm64 and riscv already have these same conditions.
>
> I found a problem with this assumption: the system suspend and resume code calls
> kernel_fpu_begin() and kernel_fpu_end() with hardirqs disabled.  See
> __save_processor_state() and __restore_processor_state() in
> arch/x86/power/cpu.c.  That triggers the WARN_ON_FPU(!irq_fpu_usable()).
>
> I think there are two directions we could go with this: either choose a solution
> that keeps kernel_fpu_begin() usable with hardirqs disabled;

I still owe you an investigation into how this interoperates with EFI
runtime services, but it appears there are cases (efi-pstore on an
OOPS) where EFI SetVariable() might be invoked with IRQs disabled.
arm64 has a special case for EFI runtime calls made under conditions
where SIMD may not be used, and essentially just preserves and
restores the entire state.

It is rather unfortunate that this is needed, but the UEFI spec
permits runtime service implementations to use XMM registers so there
is no way around this AFAIK.


> or change
> __save_processor_state() and __restore_processor_state() to save/restore the FPU
> registers directly, e.g. via save_fpregs_to_fpstate() and
> restore_fpregs_from_fpstate().  (Kernel-mode FPU isn't actually being used in
> this case, so a more direct save/restore might make sense here.)
>
> - Eric
