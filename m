Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA2A372EFF;
	Wed, 16 Sep 2026 02:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789525660; cv=none; b=tIoOdSceoEcs/tYFl8CTQGdSu637sIA+LGRDg3ZKKclU8JuFpDxhAI/r/i9I4iXFd4UmNKWV4605OVs6ApQqC3SOYc2U3WfFrwF+e/Oc8GvC0gJnf+NVkjm7XIyRgUlbfdNG3F8jMxDIQntdROrO2MPvOlFr1GNAek2hWCaoC4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789525660; c=relaxed/simple;
	bh=0W5FLi29scsaoLwnDGhVLzsdMQVQuNmaB+611/fVC60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xrq8PYJtxNo5NN/nMtlB/bGUwSd7ADdBSYgqIb/Z87GV8OtHEi43CUoC3j2l4aYY2x5u+MPW/dwqIe56MTXmq7A79JHs6PFTkPzLvT7Yqvd4gwOihN4qDbKUIwHuWF1ZR1CVZXzDUcpMIvaDJ4mlnmU9b3MDiPbQCtxhOm4Mu5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=MbbdvObR; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="MbbdvObR"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D196C40E01F9;
	Wed, 16 Sep 2026 02:27:32 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id JSF7SCEODx2u; Wed, 16 Sep 2026 02:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789525642; bh=zJSqL8q/9lBPV7jkyxkmIPw20NqqiL1Mzr4Pn0/p630=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MbbdvObRS69RjqDCGZQlHHS+Sv7HNp/XDC/4lHB5bFBwnLT2XuOMin6Rj9TwTonXg
	 bF+qp9/hmGKxHLZpxZE8/HOskXBQRHWsroXehNgFdqkm91RsJGjNheT0OPq6wpLtRy
	 A8e6hHZ1kkx7m9cTInSexbwXipTGPbuSlVWikHaMEB6fNaXsC0+JphPTT5VOpqK8YA
	 gcR+NvhOirgvH0cSBLFymTDvibhdoP+sE5rXGOYgn77D6bZeYzDaTX0KHpKAodq/BH
	 zu6zJvdlK7GAY/XT+0yIUbPK/UoDuRcTIHQCPAZW4sAma6hLSfVlqQF4hUBS7EjdYa
	 XqPkjU3tUOhz3HF0xk9pI9+xMKqpij0tF4B2mvYBZsbPyH+s7+LLbDCxiHPhR5yKD7
	 H3ixxf6DBjjs4hL9nZmwO+pdEI6Sz2q0KHwruESvD2QO5l4zADIGK/c8/Y1Prbwrbw
	 dLSDUwI1L9mb52t8MPFgLnVBbd1PM+ZZ04FcQ0s8VcQEEoCNksRK7gorG0T5XTEWtm
	 5arryRJT3Y+U5zcTG4mbOBW/P6SjAYdYxOKQFw0Qg+0wircrLwzQIgM3qw2n8GeBl/
	 Xuory0H0rzsMypHZCFsixfuZeFT/AjxjrOu94Z3FmHogyVz61O7wu8KOlJXC6i9e/4
	 PYYGlcfmONbND6zJiNEskqFs=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D96E540E015B;
	Wed, 16 Sep 2026 02:27:08 +0000 (UTC)
Date: Tue, 15 Sep 2026 19:27:05 -0700
From: Borislav Petkov <bp@alien8.de>
To: Thomas Huth <thuth@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 10/11] x86/purgatory: Compile purgatory.c with
 -D__NO_FORTIFY
Message-ID: <20260916022705.GKaqn-eQ9zuCk5tYgR@fat_crate.local>
References: <20260813134953.979481-1-thuth@redhat.com>
 <20260813134953.979481-11-thuth@redhat.com>
 <20260814152457.GBan8zSeYlWd_1oWkz@fat_crate.local>
 <7d373eca-c23c-4f79-9391-29d75bd5a53f@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7d373eca-c23c-4f79-9391-29d75bd5a53f@redhat.com>

On Tue, Aug 18, 2026 at 10:53:53AM +0200, Thomas Huth wrote:
> @@ -37,6 +37,7 @@ PURGATORY_CFLAGS := -mcmodel=small -ffreestanding
> -fno-zero-initialized-in-bss -
>  PURGATORY_CFLAGS += -fpic -fvisibility=hidden
>  PURGATORY_CFLAGS += $(DISABLE_KSTACK_ERASE) -DDISABLE_BRANCH_PROFILING
>  PURGATORY_CFLAGS += -fno-stack-protector
> +PURGATORY_CFLAGS +=  -D__NO_FORTIFY
> 
>  # Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
>  # in turn leaves some undefined symbols like __fentry__ in purgatory and not
> 
> WDYT?

I guess... I probably don't care too much about string checks in the
purgatory thing...

But please explain in more detail in the commit message what "compilation
problems" are avoided by disabling those additional string checks.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
