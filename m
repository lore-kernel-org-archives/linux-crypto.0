Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348457081E
	for <linux-crypto@vger.kernel.org>; Tue, 10 Dec 2024 01:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733794205; cv=none; b=MYs2U3uKg5gNlQ57LIX7lJmKDn9lk1VD0fNmVhzDwXIoSbf1spwXpJTc2QAGNrnyHRKmI+gVqdNO1NtHRWGEIQiWGbnG9DMaBIfDskVrCfTu9Hp2yBvAeKjK0sgxhaPIOBkKutgOx5YXAKL47/EOAoy109raBdUh2GFmXU6w44g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733794205; c=relaxed/simple;
	bh=BcPfmEiRmgV4VZjZpxIpRvHfIid9sYFc+NJp3Wm6m0w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q780fvw61qT4rIX+2T0uOcxzDMq6Z1wzzcmRapMJcj08NLXTO2J0G8vT5Aj0Zgtj1E0lkcI+06SobIEaA2pmfngRj4PlYoeig3d9LtJTRu/8DPdyrh0nJBltO2D/LIS9K9ip2wfJP54IYcwYYv5XU+ZLWEnI0GZ9Laeh61yTmEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IIibbfwC; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IIibbfwC"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7259416fcafso4943352b3a.0
        for <linux-crypto@vger.kernel.org>; Mon, 09 Dec 2024 17:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733794203; x=1734399003; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IawN1h9tDZZl4sXjqWOYnHPtIN4c66MBp2zlZKr/isY=;
        b=IIibbfwCJYl4LumTvwxrV2K6LIJhrG1vyseTBadHNQG6KgrDVoO4FLcCCTzDXpQOpf
         6e4DyKQX4Un8/6cPQ+MrrePWRMAOFFqciJW6RF4ReOtPIMil1K+XuGVEycF+1sLW8Pib
         2AGqg+1cNLSXGqGV1YjR0vMMrIAJQNHfXFUC7TkDm0DVZw4hx87/WU5uxEnIV2NtMkOS
         z6/dNcXFU317VPFuoVqgE4cnMmRK2RnOTRMbHqP+z1DiPNfCvEekElIVrpU0Rwu8hyFM
         0FeWLA+GgukEFODoy2DcGWVqavsCB4p3zsPy3PLegGfQ5zm/2wabtpAfwydQPCFtxpPB
         eWKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733794203; x=1734399003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IawN1h9tDZZl4sXjqWOYnHPtIN4c66MBp2zlZKr/isY=;
        b=IUedpP95XQKB9i7g5MVLFmZZxyhl1uOHRnwlpNQ+GMZzH/L47DixsUCsDlYFLAWkaB
         45aE8AU446+39cWNW7k96m2wrSejhQK4j2FBWei4YpVYX6T4uOQJEg2Efor20wqjORQ8
         cwcdxGwphdXpTSIp3BTSkTpBnnz4Hj4ky5lTlEvUZHdOLFHhH02F850TotYPAPS9OwUk
         QyFCwgd2KVuZq2rh/JxPOLLxZ8yy4xw0+Skr3Y8Ogf5QgUNJxAJ9sLmod2k2uYg2gOhC
         YCZ+AZqiDIbgi+FMz0MIZUnnuLJ1HfC2lc/AVEreS+4LQOja5AO8fiI4x7MD+1Dffi1O
         tZQA==
X-Forwarded-Encrypted: i=1; AJvYcCXm1XVPo9fbKhSZaYR/5+vdEdPh3Y8PpW1M6SdDMh3CnxLdNoyJx9wgO1tJ8FmhlkxKo+L+4qdOBm5Ebkk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVTEVnymRwwS6+/DwcEAohRUmu/Ta1VFVXc8gge+8B5o0m48FJ
	Zw/FfFm2wWc0caU+61AkRJjatFigGgrrkXaPu+q9m8omSgGh8GTE9buwVbdH98Ym/inTfjGDPjW
	EXw==
X-Google-Smtp-Source: AGHT+IHrSogYHesN3H8W1zIQjGJoAsi0hhsHSh2qT+6NWuzVY/4G3SpHRO/jrFrF7Soqzrl/xjYmjctZg7U=
X-Received: from pfbeg18.prod.google.com ([2002:a05:6a00:8012:b0:728:9b0a:2ddf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7895:b0:1e1:ab63:c5ed
 with SMTP id adf61e73a8af0-1e1ab63c75cmr7275418637.23.1733794202997; Mon, 09
 Dec 2024 17:30:02 -0800 (PST)
Date: Mon, 9 Dec 2024 17:30:01 -0800
In-Reply-To: <5b77d19d-3f34-46d7-b307-738643504cd5@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <1e43dade-3fa7-4668-8fd8-01875ef91c2b@amd.com> <Zz5aZlDbKBr6oTMY@google.com>
 <d3e78d92-29f0-4f56-a1fe-f8131cbc2555@amd.com> <d3de477d-c9bc-40b9-b7db-d155e492981a@amd.com>
 <Zz9mIBdNpJUFpkXv@google.com> <cb62940c-b2f7-0f3e-1710-61b92cc375e5@amd.com>
 <Zz9w67Ajxb-KQFZZ@google.com> <7ea2b3e8-56b7-418f-8551-b905bf10fecb@amd.com>
 <Z1N7ELGfR6eTuO6D@google.com> <5b77d19d-3f34-46d7-b307-738643504cd5@amd.com>
Message-ID: <Z1eZmXmC9oZ5RyPc@google.com>
Subject: Re: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, Peter Gonda <pgonda@google.com>, pbonzini@redhat.com, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au, 
	x86@kernel.org, john.allen@amd.com, davem@davemloft.net, michael.roth@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 06, 2024, Ashish Kalra wrote:
> On 12/6/2024 4:30 PM, Sean Christopherson wrote:
> >> This can reuse the current support (in KVM) to do SEV INIT implicitly when
> >> the first SEV VM is run: sev_guest_init() -> sev_platform_init() 
> > 
> > I don't love the implicit behavior, but assuming hotloading firmware can't be done
> > after SEV_CMD_INIT{_EX}, that does seem like the least awful solution.
> > 
> > To summarize, if the above assumptions hold:
> > 
> >  1. Initialize SNP when kvm-amd.ko is loaded.
> >  2. Define CipherTextHiding and ASID params kvm-amd.ko.
> >  3. Initialize SEV+ at first use.
> 
> Yes, the above summary is correct except for (3).

Heh, that wasn't a statement of fast, it was a suggestion for a possible
implementation.

> The initial set of patches will initialize SNP and SEV both at kvm-amd.ko module load,
> similar to PSP module load/probe time.

Why?  If SEV+ is initialized at kvm-amd.ko load, doesn't that prevent firmware
hotloading?

> For backward compatibility, the PSP module parameter psp_init_on_probe will still be
> supported, i believe it is used for INIT_EX support.

Again, why?  If the only use of psp_init_on_probe is to _disable_ that behavior,
and we make the code never init-on-probe, then the param is unnecessary, no?

> > Just to triple check: that will allow firmware hotloading even if kvm-amd.ko is
> > built-in, correct?  I.e. doesn't requires deferring kvm-amd.ko load until after
> > firmware hotloading.
> 
> Yes, this should work, for supporting firmware hotloading, the PSP driver's
> psp_init_on_probe parameter will need to be set to false, which will ensure
> that SEV INIT is not done during SEV/SNP platform initialization at KVM module
> probe time and instead it will be done implicitly at first SEV/SEV-ES VM launch.

Please no.  I really, really don't want gunk like this in KVM:

	init_args.probe = false;
	ret = sev_platform_init(&init_args);

That's inscrutable without a verbose comment, and all kinds of ugly.  Why can't
we simply separate SNP initialization from SEV+ initialization?
