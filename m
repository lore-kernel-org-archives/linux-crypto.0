Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074D0125AA
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 17:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777396484; cv=none; b=Qz4oWZ8/7NJkPhHV+6Pt9G2ovubU0AQxQNFp4PCIidy9oRwajR6rlaxhvHvvhCcXmcWivESWl8WMre90tYZR0Usprd8eC/vGEhYzgtRnEya1Y9PCfLeGEMRPFsXnR6M1S47mOYOOr5gPAgssjoDxIFtSlnCbMDtYoT2MvRPzMtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777396484; c=relaxed/simple;
	bh=LtvzAMKP8P4C7eT31W1TOmw6wHT+t3l0z1jVhu757RM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dQcH5QZlHs1Utj23N3uj23Vx1ELRpDvCQxq6KH2xmitwOhEsNj/nIK0rGAORYfdGG5/FAePsI8F0NSky1TmyFojRgf3lTewmZvknteMHSfrcVm/ZV64MdamW6exjcMOVH1fu0QEAg29YkK5g6fDkaqJLBhcOR4BrLRQLC7EdeZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mol89KD+; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mol89KD+"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82f9f49e4beso6366513b3a.0
        for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 10:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777396482; x=1778001282; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1FTL1KInrBgDPjS8ez4nCUhnLyZ0q2rWH/o4QlF78bg=;
        b=mol89KD+Qdfiw4ILw1PKeUdWyirWJNB1l0pJyOqU02iVBLQB4dSCgdoH3+BzVtvL/L
         UT35+LTdMC5gE9T0Qmjv9BNgnybso1uqKuXfLeWpKSTLFN4V441lq5BXPRoY+wCKwThk
         K6OxRQ6b5PtholQzhwePVJxucHxgfQ3dUuDKMsY+6Y35ktOzP5E9fltYLRrLWPmimVeu
         l4ayHXQ+MU2kGJ7f9Egv84ZmjzBgTWaowebrvt7NyeZQRbVVXNKmH68TXV04m2dO5qiH
         ijaI0sCJep0Icm0VSYo1a1QXEH9Jq5kSkdWVXAvnZTpZAKcGksGW4Pgb/arOIHMuX4jX
         Z+bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777396482; x=1778001282;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1FTL1KInrBgDPjS8ez4nCUhnLyZ0q2rWH/o4QlF78bg=;
        b=Quk6fi/4DeIiY2tw+3I73SX+Qn2/PbLtcXQRD4x++UQBsYIVeQ24ay4AL77Hw3dBad
         rxWUHrhboG1y4HG22u2MFw7CUYiABj9+bZ9IxfO1ik3YRoW3ti3C1x8RNszGKtYN8YNS
         PfzuXVp8grtV85tpImmIPPFOVYczQtNib8swOT0BhUIqEJRt5QR8vdbYWto7l7NBDfqa
         5/TZjveQKOuTE1pb0S17bKe3xAkmbL2+/R1lmkqxuS5Kgc79Fr+vUBitvRfkvT2kDgxK
         z6zNmQaPKge+b3vUl0hFrDiu9aHDrxJ9OKHKEZOQj8ud4AlE1j3afUheFua+HsS9CRh8
         7kVw==
X-Forwarded-Encrypted: i=1; AFNElJ88zKVITOd3ZrKB4yH3Caib+0voXXFgdHGxyhMNtKbXJAct1hoSaVw8JKT+/5m1KvBymNAXTDkkFhWFpwk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlHzLPMuolt39nb9sqiJBI0Igd9kE35uJNDA3VSmYc7fbDptty
	GE4TMRAAwq/9Ls6sOkRsTAL7TRIURV8NPNyBo94cY1x0BdQOK927+Viih+aTzaNDdwbg5Kwzlk3
	/5aGvog==
X-Received: from pfbjs41.prod.google.com ([2002:a05:6a00:91a9:b0:82f:6c9a:6139])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:8a11:b0:834:e15a:19e4
 with SMTP id d2e1a72fcca58-834e15a2061mr2103778b3a.39.1777396482142; Tue, 28
 Apr 2026 10:14:42 -0700 (PDT)
Date: Tue, 28 Apr 2026 10:14:40 -0700
In-Reply-To: <afDnw8WYpr7TqEHS@tycho.pizza>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260427204847.112899-1-tycho@kernel.org> <20260427204847.112899-4-tycho@kernel.org>
 <ae_TCofu4bHP_Ch-@google.com> <afDJZQHNi-qdcEEe@tycho.pizza>
 <afDYCpbeT0HsXTMF@google.com> <20f94bed-2843-44ab-877c-3e68bd4314f8@amd.com>
 <afDkcpcQ5vPsjQkO@google.com> <afDnw8WYpr7TqEHS@tycho.pizza>
Message-ID: <afDrAJPmCIm1HT8l@google.com>
Subject: Re: [PATCH v2 3/4] KVM: SEV: Add the kvm-amd.rapl_disable module parameter
From: Sean Christopherson <seanjc@google.com>
To: Tycho Andersen <tycho@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, 
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

On Tue, Apr 28, 2026, Tycho Andersen wrote:
> On Tue, Apr 28, 2026 at 09:46:42AM -0700, Sean Christopherson wrote:
> > On Tue, Apr 28, 2026, Tom Lendacky wrote:
> > > On 4/28/26 10:53, Sean Christopherson wrote:
> > > > On Tue, Apr 28, 2026, Tycho Andersen wrote:
> > > >> On Mon, Apr 27, 2026 at 02:20:10PM -0700, Sean Christopherson wrote:
> > > >>> I'm pretty sure I said this earlier: KVM absolutely should not be able to disable
> > > >>> RAPL for the entire system.  That needs to be a power management thing.
> > > >>
> > > >> You definitely noted "not CCP", I don't think I quite understood what
> > > >> that meant though:
> > > >> https://lore.kernel.org/all/aZ86BZWi-GLiHvmt@tycho.pizza/
> > > >>
> > > >> I'm a little worried that putting it in power management will generate
> > > >> some weird dependencies, or weakref symbols that can't change things
> > > >> if they are loaded independently of kvm_amd or something. But let me
> > > >> see what I can come up with.
> > > > 
> > > > Ugh, and it's not even powerman per se, it's actually a module in perf.  Oof.
> > > > 
> > > > I 100% agree it'll be tricky, but I also stand by comments that neither the CCP
> > > > driver or KVM should be allowed to silently pull the rug out from under the RAPL
> > > > module.
> > > 
> > > Maybe something that can be added to the current sev= kernel command line
> > > parameter, e.g. sev=norapl, or such?
> > 
> > Yeah.  The only question I have is if we expect end users to want to disable RAPL
> > at runtime.  If so, then we probably want a sysfs knob or something.
> > 
> > However, letting RAPL be toggled on/off will introduce some amount of complexity,
> > as the kernel would need to negotiate/coordinate with the RAPL perf module and
> > with the CPP driver to ensure RAPL stays in the "correct" state.  E.g. if the
> > perf module is loaded, then RAPL is effectively pinned "on".  And if SNP has been
> > initialized with RAPL_DIS, then RAPL is effectively pinned "off".  Blech.
> > 
> > > Maybe even with a kernel config option for a default value?
> > 
> > Probably overkill?
> > 
> > > On SNP_SHUTDOWN it will be re-enabled if it was disabled.
> > 
> > Stating the obvious, if we do this, we open the can of worms I described above.
> 
> Unfortunately that's how the firmware works and since we do a shutdown
> on module unload, if you have ccp=m this is the behavior.

Right, but that's just at the hardware level.  The kernel can still leave RAPL
"disabled" at a software level, i.e. can still disallow loading the RAPL perf
module.

> Maybe it makes sense to go the other way: have perf look for a ccp
> symbol that's loaded that says whether RAPL is usable or not, and
> refuse to allow access to the counters if it is?

Yeah, this is what I suggesting.  Or rather, trying to suggest :-)

> But it looks like there are several UAPIs for this (perf, /dev/amd-hsmp-*,
> sysfs), so it's not just one place, which is also ugly.
> 
> > > >>> KVM then needs to communicate (and enforce?) the policy to
> > > >>> userspace.
> > > >>
> > > >> KVM doesn't need to enforce anything, the SEV firmware will generate a
> > > >> launch error for policy violation if it's not supported.
> > > >>
> > > >> For communicating to userspace if it's not a kvm module parameter, one
> > > >> option is to mask it off in sev_get_snp_supported_policy() if it was
> > > 
> > > Did you mean sev_get_snp_policy_bits() or were you referring to the KVM
> > > ioctl() for retrieving them?
> 
> I was thinking of the ioctl() for retrieving them, but doing the
> masking in sev_get_snp_policy_bits() since it would be able to
> remember whether RAPL_DIS was set or not. Of course I merged the two
> in my head when typing the sentence :)
> 
> > > >> initialized without the support. Then it'll be visible via
> > > >> KVM_X86_SNP_POLICY_BITS.
> > > > 
> > > > Ya, this is what I was envisioning.
> > > 
> > > It's still a valid policy bit (if supported by the platform), so I don't
> > > think masking it off is appropriate.
> > 
> > But it's not fully supported, no?  I.e. won't the VM fail if it requests RAPL_DIS?
> > 
> > Ooh, presumably the subtle difference is that on a platform without RAPL_DIS at
> > all, the VM will successfully launch and thus could run with RAPL enabled even
> > if the VM requested RAPL_DIS?
> 
> I haven't tested this, but I would hope what you describe an error. I
> think Tom means it's supported by the architecture, it just needs to
> be enabled via reconfiguration.
> 
> Tycho
