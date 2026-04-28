Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF333C3BE2
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 15:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777391630; cv=none; b=VjazERyhCzJF7MNUbRFDwM/HXSxAO+vqbG94fmize2Jhf69+thhLiE3KdXBFGvGnygcmyWe2bzE/qOh6DoTkugXrJf5jQVN7jCEmqp1wsP4wxlzmwJDbY+d0rQ0ZaWmF4CHBBFmDtz3RNkpKPc9sf2FPyYQEm09aP08sKqoZhnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777391630; c=relaxed/simple;
	bh=92040OvP7NphZOcgJ01LGqbNZOBjVXmSRgTtp03HPzs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EAPppqc+bOVJhKQk1+PpsOkzaC/bRkfh6+i2CwBlMEp8d+54fhnSvljHsiBQS2cvHgfwgk7g+RF1nvygwgtu/xGkgtP4VNekiVZHYYpanUTw1de1K5J1ByK1F3x+VH+SfQ72v9o2dUhX6+/+xEb1y3a9H5Yav3aqUSg/RHiXqI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fyy6wJXR; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fyy6wJXR"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82f5f48458eso6955069b3a.3
        for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 08:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777391628; x=1777996428; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kQTB8wCBT8LVtOg4OyEn9zyS1CPfIyYMGlnzm+b7XDs=;
        b=Fyy6wJXRQvkfAUjbfUFVq01cLng/WvJZkQnaxFh0bUdGWj2lYl3Lft9IyZKoaOwIV/
         naNf2u+1YuL01lOOadaPQheUrDlX91QDPTlUxN1PNacdE0O9NY9chU8qHMNwDyUiDQoz
         Z2zKXSx1hnOrAo6NLTAoBaR3u6BFm9QFb0JDvjm/znah96wu008KrpnSYSlTew+cw9DD
         qt1q9KATGTHpKVQ7Gn/AtguqEB6RrjB1eBvLyd1bUvwja9z4r8gJ/ierFH2KWEkk21T/
         /B3nGvtkX9PNMnd20eOBtA/QRYJ2Mrk0lNq9H+IHWx7NDWGzERQZs7yFCGsjFJX78EDV
         +8ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777391628; x=1777996428;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kQTB8wCBT8LVtOg4OyEn9zyS1CPfIyYMGlnzm+b7XDs=;
        b=MNuil/U7KCNY90v3gSWx7/5ZUM59+5bmHSq2ZYHJ0/CMUkLRCy3cnPIko4kw2bFOVa
         7fsaeATScXJNq9VyDp0iTEiIfSDM4/YDs5SUH7yShoNxVDpXD7KzJ1G3vc5tcdvDNEft
         uylCJsG8XNioRboIV32PUvxfCzk1EC/Z9nmdXJ/lgemC7fTC35fRc+yFQm3yw2T661Zk
         opZxSnGufQQwQk9nJqqHpf6SwRsoyWta1ws/04IxhqnUZt4Mb1QrwBZfXqq46cVm/u7w
         8wnAGSDgNg7sNgCDCwCTuTxX8Ual5g5IgiePy20yvcJOzjsjWZjyV6EQcPuUIq5O1Q64
         yQEQ==
X-Forwarded-Encrypted: i=1; AFNElJ/Wu7N5iVHGHyo86Q3HUrT737f2PQP42AbwAHluG8nDca8nDzb4qhCnHC3dHrLbnU9e5NQuY91WiRCfNKE=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywp85afsdPvR2dBWePPoHORr6/ynPJrG8rnn94j9KVp4bY9rUYv
	rvO/yIir6IdxF+65sJzPrV/8Orp8+RNavJQaZWht92sNsxVALwbuO9VQZJS+DOQfPop0d2YGYO+
	AfTnghw==
X-Received: from pfbem34.prod.google.com ([2002:a05:6a00:3762:b0:82f:7a66:cfb0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:12c1:b0:829:8c08:d1f4
 with SMTP id d2e1a72fcca58-834ddbec0e6mr3804392b3a.39.1777391627873; Tue, 28
 Apr 2026 08:53:47 -0700 (PDT)
Date: Tue, 28 Apr 2026 08:53:46 -0700
In-Reply-To: <afDJZQHNi-qdcEEe@tycho.pizza>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260427204847.112899-1-tycho@kernel.org> <20260427204847.112899-4-tycho@kernel.org>
 <ae_TCofu4bHP_Ch-@google.com> <afDJZQHNi-qdcEEe@tycho.pizza>
Message-ID: <afDYCpbeT0HsXTMF@google.com>
Subject: Re: [PATCH v2 3/4] KVM: SEV: Add the kvm-amd.rapl_disable module parameter
From: Sean Christopherson <seanjc@google.com>
To: Tycho Andersen <tycho@kernel.org>
Cc: Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
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
> On Mon, Apr 27, 2026 at 02:20:10PM -0700, Sean Christopherson wrote:
> > On Mon, Apr 27, 2026, Tycho Andersen wrote:
> > > From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> > > 
> > > Add a user-visible way to set the RAPL_DIS bit for SNP init.
> > > 
> > > Since setting RAPL_DIS affects the whole system, put the module parameter
> > > in kvm_amd instead of in the CCP driver to hopefully make it more obvious
> > > to admins.
> > > 
> > > Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> > > ---
> > >  Documentation/admin-guide/kernel-parameters.txt | 5 +++++
> > >  arch/x86/kvm/svm/sev.c                          | 8 ++++++++
> > >  2 files changed, 13 insertions(+)
> > > 
> > > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > > index 4d0f545fb3ec..2b50eed8664c 100644
> > > --- a/Documentation/admin-guide/kernel-parameters.txt
> > > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > > @@ -3207,6 +3207,11 @@ Kernel parameters
> > >  			max_snp_asid == min_sev_asid-1, will effectively make
> > >  			SEV-ES unusable.
> > >  
> > > +	kvm-amd.rapl_disable=	[KVM,AMD] Whether to disable RAPL
> > > +			(Running Average Power Limit) when initializing the SNP
> > > +			firmware. This disables the counters for the entire system until an
> > > +			SNP shutdown command is issued.
> > 
> > I'm pretty sure I said this earlier: KVM absolutely should not be able to disable
> > RAPL for the entire system.  That needs to be a power management thing.
> 
> You definitely noted "not CCP", I don't think I quite understood what
> that meant though:
> https://lore.kernel.org/all/aZ86BZWi-GLiHvmt@tycho.pizza/
> 
> I'm a little worried that putting it in power management will generate
> some weird dependencies, or weakref symbols that can't change things
> if they are loaded independently of kvm_amd or something. But let me
> see what I can come up with.

Ugh, and it's not even powerman per se, it's actually a module in perf.  Oof.

I 100% agree it'll be tricky, but I also stand by comments that neither the CCP
driver or KVM should be allowed to silently pull the rug out from under the RAPL
module.

> > KVM then needs to communicate (and enforce?) the policy to
> > userspace.
> 
> KVM doesn't need to enforce anything, the SEV firmware will generate a
> launch error for policy violation if it's not supported.
> 
> For communicating to userspace if it's not a kvm module parameter, one
> option is to mask it off in sev_get_snp_supported_policy() if it was
> initialized without the support. Then it'll be visible via
> KVM_X86_SNP_POLICY_BITS.

Ya, this is what I was envisioning.
