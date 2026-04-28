Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB91329E79
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 16:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777394806; cv=none; b=os78BhptmP2Epk/hDRvGhTR3zP6tJoIew+eXdXnYThyAjbJ1FnVuFhN8cY5pLgw9AuDFeYc6InwqOIbnHWWbF0wJFIMqOkM85Hk+mi+p7K8X8uCF203UexVt4zc59ILFVPblxm+VUDqZ7DnWuUUi2RDJXXNDLWZOGR6vEkeWia0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777394806; c=relaxed/simple;
	bh=02Ll0yphJszxQQ3HWl4fGFlC3mEDZ3rgtgF4T/gAhdc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hXoWMCjyU4lHsYIEClxoJ7Ytg54qnJ3M7NgUIjwgzr4XgXBWSZUDYVEQTC97sfxpd0Kt2otj6Jexd6HzAJJyQVDhFoL7xCZffnCrAbqGRX8xGexr68+mMCPKBFhLc+gG54U1tBWpKxjCYPv5wdroMJq/M2DouYh7kdgNF0Gc4ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hVOGYrQN; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hVOGYrQN"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35d9278587bso14058833a91.2
        for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 09:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777394804; x=1777999604; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kEkPC/bbmwo82zT+9sMdK7tO+DGFA2UM3xH5lqU9uE8=;
        b=hVOGYrQNYg6P/8G4eKUVwhdKyjDwMXiB5eQ9087qmJI1lyCBmM3OseIjfS/q8VVJhg
         ADPRjMrlOxT7EK8MTZ0tsjcq+JAh5WfbU2+jM8tBl0vXBVwES8+6B3/MJQqSvaX6pV4L
         ajb7UdDtFQFgU0N5oh1FdXQ5OZTXkyl4+PCjyi1DmUtfDM5J8jO5JLczp1veitgmszfq
         +tjYUHOVCMQnfd8a6CynmoNLgQ11ILWXuTJhfF9oG8KlPEpj4qPBDTXtv6XVffqdC9rS
         weSEqTD3S6WOWRgfS5xjI9OJrm5otHK7lh3vepR/DGJufXkg77k+0GUwxN2NL1eC79rN
         eI1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777394804; x=1777999604;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kEkPC/bbmwo82zT+9sMdK7tO+DGFA2UM3xH5lqU9uE8=;
        b=Kl/mxYgi9rx2sVIoTw1KNM3jpTtTTxPof2bR039Zii5UZwU/UJuqpYJyWD7egW/3+A
         V9UKC+O1YNXyh8vB+o0/C0O1CtYs/XH6nLwfXu/v/J4Lt62DxcCUxCzTmy5aPtYLENxV
         LdSu0NwsU9W2TDqAxpJsWm2Xjp1D1wZQdGY3PJ0nB0I1DycgDuG3JevrybNLAia6UQ8w
         Ac6A05XMqD7aNkrxeMK6s7OTmbsh0ugq2ZiDvOj5krLcoZhHg4x8g7SCumauzJCHVSTv
         Gf05vF234iopHRc9I3s8333SwwsUSzkk+KdX6Rl+zZRR2nDYB721i3rjHWWaiLqbnS6i
         0qtg==
X-Forwarded-Encrypted: i=1; AFNElJ9qyNi2tkynXeAoNar73PBxfF46Z5UndgDvZI0TaE0c8jKU9dKmyZzgh/d17Oqo7RZSx9MjBe98AIM9Pr0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9zLDSGC7jSZarnCv+Mb6s70ClNv3fFm0lQvBuEHLXtgcBLUnC
	ezDzPq3ssTR5ox7ZQq+QYO1VH5qtXxfWuorGGlpMjGNzaCulmeTfUzwbxZBncOJP4QD7E/iH+Xq
	/1WpTsQ==
X-Received: from pgbcz1.prod.google.com ([2002:a05:6a02:2301:b0:c61:2d0c:40bf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a1a:b0:3a3:5726:7e39
 with SMTP id adf61e73a8af0-3a3af426340mr463737637.23.1777394803747; Tue, 28
 Apr 2026 09:46:43 -0700 (PDT)
Date: Tue, 28 Apr 2026 09:46:42 -0700
In-Reply-To: <20f94bed-2843-44ab-877c-3e68bd4314f8@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260427204847.112899-1-tycho@kernel.org> <20260427204847.112899-4-tycho@kernel.org>
 <ae_TCofu4bHP_Ch-@google.com> <afDJZQHNi-qdcEEe@tycho.pizza>
 <afDYCpbeT0HsXTMF@google.com> <20f94bed-2843-44ab-877c-3e68bd4314f8@amd.com>
Message-ID: <afDkcpcQ5vPsjQkO@google.com>
Subject: Re: [PATCH v2 3/4] KVM: SEV: Add the kvm-amd.rapl_disable module parameter
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Tycho Andersen <tycho@kernel.org>, Ashish Kalra <ashish.kalra@amd.com>, 
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kees Cook <kees@kernel.org>, Marco Elver <elver@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Li RongQing <lirongqing@baidu.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 28, 2026, Tom Lendacky wrote:
> On 4/28/26 10:53, Sean Christopherson wrote:
> > On Tue, Apr 28, 2026, Tycho Andersen wrote:
> >> On Mon, Apr 27, 2026 at 02:20:10PM -0700, Sean Christopherson wrote:
> >>> I'm pretty sure I said this earlier: KVM absolutely should not be able to disable
> >>> RAPL for the entire system.  That needs to be a power management thing.
> >>
> >> You definitely noted "not CCP", I don't think I quite understood what
> >> that meant though:
> >> https://lore.kernel.org/all/aZ86BZWi-GLiHvmt@tycho.pizza/
> >>
> >> I'm a little worried that putting it in power management will generate
> >> some weird dependencies, or weakref symbols that can't change things
> >> if they are loaded independently of kvm_amd or something. But let me
> >> see what I can come up with.
> > 
> > Ugh, and it's not even powerman per se, it's actually a module in perf.  Oof.
> > 
> > I 100% agree it'll be tricky, but I also stand by comments that neither the CCP
> > driver or KVM should be allowed to silently pull the rug out from under the RAPL
> > module.
> 
> Maybe something that can be added to the current sev= kernel command line
> parameter, e.g. sev=norapl, or such?

Yeah.  The only question I have is if we expect end users to want to disable RAPL
at runtime.  If so, then we probably want a sysfs knob or something.

However, letting RAPL be toggled on/off will introduce some amount of complexity,
as the kernel would need to negotiate/coordinate with the RAPL perf module and
with the CPP driver to ensure RAPL stays in the "correct" state.  E.g. if the
perf module is loaded, then RAPL is effectively pinned "on".  And if SNP has been
initialized with RAPL_DIS, then RAPL is effectively pinned "off".  Blech.

> Maybe even with a kernel config option for a default value?

Probably overkill?

> On SNP_SHUTDOWN it will be re-enabled if it was disabled.

Stating the obvious, if we do this, we open the can of worms I described above.

> >>> KVM then needs to communicate (and enforce?) the policy to
> >>> userspace.
> >>
> >> KVM doesn't need to enforce anything, the SEV firmware will generate a
> >> launch error for policy violation if it's not supported.
> >>
> >> For communicating to userspace if it's not a kvm module parameter, one
> >> option is to mask it off in sev_get_snp_supported_policy() if it was
> 
> Did you mean sev_get_snp_policy_bits() or were you referring to the KVM
> ioctl() for retrieving them?
> 
> >> initialized without the support. Then it'll be visible via
> >> KVM_X86_SNP_POLICY_BITS.
> > 
> > Ya, this is what I was envisioning.
> 
> It's still a valid policy bit (if supported by the platform), so I don't
> think masking it off is appropriate.

But it's not fully supported, no?  I.e. won't the VM fail if it requests RAPL_DIS?

Ooh, presumably the subtle difference is that on a platform without RAPL_DIS at
all, the VM will successfully launch and thus could run with RAPL enabled even
if the VM requested RAPL_DIS?
