Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB3833AD9D;
	Tue, 28 Apr 2026 17:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777396183; cv=none; b=uioFx6CGHj7P3XrgtZXZi0pK1kk3NkAP33hZyU+8/ozUAYmq55cJMLWAyaSn+oFh1wd0jwQVRKhRMfo/QJsY9c7ZK6oIVQnWjSpiowaXtvJoDpCVWgyKKpFtE1My8gSpzy5GGzq1xi6HypqbAPZzgouT+cCPvJz+HQHVxdUPaOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777396183; c=relaxed/simple;
	bh=T//AuRVq+IjivDs5/dRujik2iW7yzHKWkQ6eRMrrilg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mrtayZmQlR5EcrVNraQaUCvGxdz3lTL247WJlMnGiK4LjSZUVr9bb/gSQNYQMyvxim03pVhPjwFJPhubtlwMnlM+Z2xfvtR4/1emOIVnZW2kSzwp6ksKW1GkIPHdm5T0MQowaz/jHfY6x68cpugU4fi6VwVvQk0HZ8Yuq5gMNPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dLBtWskZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dLBtWskZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C367FC2BCAF;
	Tue, 28 Apr 2026 17:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777396183;
	bh=T//AuRVq+IjivDs5/dRujik2iW7yzHKWkQ6eRMrrilg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dLBtWskZWsUOulpCMcM3MWdEy2V50NpVihohHQMHXb88VzuLBO3/AihpWT2iwwOHr
	 lHyVF/YMmhwRnZ/56n+H+0g8TWUVuE65lk1OnAytBvQyGsnierH84fuTEvvGW6SVC9
	 3mCqTLMjgJjtXflXp9g8ZNzHrjpvKFjzjoPShpN8dah36uTTiuPPFzwwuQShDKoHOo
	 vFLTAHkRhIm566JKzLLMdlhKJdFfX+WKf2rsBc9HStsrvvVtZZS3xLQvHTjMGvUUnY
	 tEApBiH4wTe1Xcty8O3g9zKw1LRX1xqUInjyV1cTs4B4H1jeaG18e7Z+73yiY6OWaK
	 wofzdVW9iAANQ==
Date: Tue, 28 Apr 2026 11:09:38 -0600
From: Tycho Andersen <tycho@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Shuah Khan <shuah@kernel.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kim Phillips <kim.phillips@amd.com>, Alexey Kardashevskiy <aik@amd.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kees Cook <kees@kernel.org>, Marco Elver <elver@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Li RongQing <lirongqing@baidu.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 3/4] KVM: SEV: Add the kvm-amd.rapl_disable module
 parameter
Message-ID: <afDnw8WYpr7TqEHS@tycho.pizza>
References: <20260427204847.112899-1-tycho@kernel.org>
 <20260427204847.112899-4-tycho@kernel.org>
 <ae_TCofu4bHP_Ch-@google.com>
 <afDJZQHNi-qdcEEe@tycho.pizza>
 <afDYCpbeT0HsXTMF@google.com>
 <20f94bed-2843-44ab-877c-3e68bd4314f8@amd.com>
 <afDkcpcQ5vPsjQkO@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afDkcpcQ5vPsjQkO@google.com>

On Tue, Apr 28, 2026 at 09:46:42AM -0700, Sean Christopherson wrote:
> On Tue, Apr 28, 2026, Tom Lendacky wrote:
> > On 4/28/26 10:53, Sean Christopherson wrote:
> > > On Tue, Apr 28, 2026, Tycho Andersen wrote:
> > >> On Mon, Apr 27, 2026 at 02:20:10PM -0700, Sean Christopherson wrote:
> > >>> I'm pretty sure I said this earlier: KVM absolutely should not be able to disable
> > >>> RAPL for the entire system.  That needs to be a power management thing.
> > >>
> > >> You definitely noted "not CCP", I don't think I quite understood what
> > >> that meant though:
> > >> https://lore.kernel.org/all/aZ86BZWi-GLiHvmt@tycho.pizza/
> > >>
> > >> I'm a little worried that putting it in power management will generate
> > >> some weird dependencies, or weakref symbols that can't change things
> > >> if they are loaded independently of kvm_amd or something. But let me
> > >> see what I can come up with.
> > > 
> > > Ugh, and it's not even powerman per se, it's actually a module in perf.  Oof.
> > > 
> > > I 100% agree it'll be tricky, but I also stand by comments that neither the CCP
> > > driver or KVM should be allowed to silently pull the rug out from under the RAPL
> > > module.
> > 
> > Maybe something that can be added to the current sev= kernel command line
> > parameter, e.g. sev=norapl, or such?
> 
> Yeah.  The only question I have is if we expect end users to want to disable RAPL
> at runtime.  If so, then we probably want a sysfs knob or something.
> 
> However, letting RAPL be toggled on/off will introduce some amount of complexity,
> as the kernel would need to negotiate/coordinate with the RAPL perf module and
> with the CPP driver to ensure RAPL stays in the "correct" state.  E.g. if the
> perf module is loaded, then RAPL is effectively pinned "on".  And if SNP has been
> initialized with RAPL_DIS, then RAPL is effectively pinned "off".  Blech.
> 
> > Maybe even with a kernel config option for a default value?
> 
> Probably overkill?
> 
> > On SNP_SHUTDOWN it will be re-enabled if it was disabled.
> 
> Stating the obvious, if we do this, we open the can of worms I described above.

Unfortunately that's how the firmware works and since we do a shutdown
on module unload, if you have ccp=m this is the behavior.

Maybe it makes sense to go the other way: have perf look for a ccp
symbol that's loaded that says whether RAPL is usable or not, and
refuse to allow access to the counters if it is? But it looks like
there are several UAPIs for this (perf, /dev/amd-hsmp-*, sysfs), so
it's not just one place, which is also ugly.

> > >>> KVM then needs to communicate (and enforce?) the policy to
> > >>> userspace.
> > >>
> > >> KVM doesn't need to enforce anything, the SEV firmware will generate a
> > >> launch error for policy violation if it's not supported.
> > >>
> > >> For communicating to userspace if it's not a kvm module parameter, one
> > >> option is to mask it off in sev_get_snp_supported_policy() if it was
> > 
> > Did you mean sev_get_snp_policy_bits() or were you referring to the KVM
> > ioctl() for retrieving them?

I was thinking of the ioctl() for retrieving them, but doing the
masking in sev_get_snp_policy_bits() since it would be able to
remember whether RAPL_DIS was set or not. Of course I merged the two
in my head when typing the sentence :)

> > >> initialized without the support. Then it'll be visible via
> > >> KVM_X86_SNP_POLICY_BITS.
> > > 
> > > Ya, this is what I was envisioning.
> > 
> > It's still a valid policy bit (if supported by the platform), so I don't
> > think masking it off is appropriate.
> 
> But it's not fully supported, no?  I.e. won't the VM fail if it requests RAPL_DIS?
> 
> Ooh, presumably the subtle difference is that on a platform without RAPL_DIS at
> all, the VM will successfully launch and thus could run with RAPL enabled even
> if the VM requested RAPL_DIS?

I haven't tested this, but I would hope what you describe an error. I
think Tom means it's supported by the architecture, it just needs to
be enabled via reconfiguration.

Tycho
