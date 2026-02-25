Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CB43DA7C5
	for <linux-crypto@vger.kernel.org>; Wed, 25 Feb 2026 17:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772041459; cv=none; b=uhtL/1sVQuUKnm5MyEdLkibMhmXhzZgpJ4eROjVAJFb+JM/TJwYrMiOEJ+q1R0VGS2bNskq/91LIrIBnUG5eFiNzVI4Yuf5X2c/9z8l8Wr11b2kpM7mcIL++SQ7qGqmi+rcZGtDBpSfVJCzVUNHdU58m+eBkmCOdyjO1+IaLWSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772041459; c=relaxed/simple;
	bh=e8g6K6jqH7yi+J7S+Llf7wJHW3GxzjdSA1XAzbdLd+Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VLaGdAXC3IEJZLC+fbdIcZ7iv1gqU+LYbqVT0EeZtHL//RuTGFGTzfDdBu9g0e434q04Oj6fA6B8ZPlJEkTEamo1qjKgw0QW8r7ImI29qRfvutUzecJd9xnEoW6YDLPuhBcEvNrFWcPrOakNySWT/oEDD2NCNmxME7zTCgTfb9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uXUZgkId; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uXUZgkId"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-358e95e81aeso8913554a91.0
        for <linux-crypto@vger.kernel.org>; Wed, 25 Feb 2026 09:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772041457; x=1772646257; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Aw6GQL6ZdLBj1XQdIzcZiKvieiwtt1s7FniDgSgRoX4=;
        b=uXUZgkIdnxhqudhwwNwNJyjHnndkQWn+hblQTZ8KYQsYWhSizwej7/C3gXnYRxjVJV
         u1L2BxmH8n92RkO/XHI3Jhq3tpVQXzzao6GQXaSGXagXMgMNJpW2LETBFN0H/slc93Ra
         6X0C1r0y+x2XSxASKGWwTjNvTjdO4uE9jbYf3j2MowoaZXoS14+Ds5i7z6H/cZiVm7/e
         8axmlzAG3+4lfWD11BtVEuFf9THYkwDJFvy1DWFwiW4lNK+vZTuisG5d+709dmE0V0Ia
         jgnMZl2aNLv6/F3XmEmrNOQ8d4Dd5f//7MkHpNVbl1xJRvU06rwZgp1uVKPCZuBBGU+n
         T7RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772041457; x=1772646257;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Aw6GQL6ZdLBj1XQdIzcZiKvieiwtt1s7FniDgSgRoX4=;
        b=fdk7EzPTs2a6WXno7Xs7w7VSG616f1lF4icxp970mmZmrU8HwI/R+fABCzXq0xDjkS
         iwEZyG4uKcApw0WDFkyUeO0eDZ65QWAU2pwdHuxdYU5gnZiZ/tB5Lt24t4t7GRWehYG9
         68eQZQwgI4WYL+RW6bEv2WsG3MBgaWCm+ntpbHjREpw1C4GAhgw8QGvAQngFtHkywY9q
         6tGM0+r469mxqzsHsHx3DUxFVnBcYpELeU8C8w3V7AfD1WobJHvzR6WUgOb6umWsp925
         N+6fcdA4ZMuInbxuXa8aXLe1orqf8RIWWfor/9C8+M+K6G0xFnpnjDE9Na4uIG5k6VTi
         G0Tg==
X-Forwarded-Encrypted: i=1; AJvYcCW9xzd4wTY8dP+d3Bd8q5jf8tQsUOaaF3ztIeTzOC6nUF2OJRTg02oWUvltXtTXGkwTgu/2k9ha2oTF3Cs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNW9IoC5NLwb3FYPEfk4eOH37zhBCSUuZuKbIHp4HbupmI7ISl
	771tTXQYkJpUnApu9T7v6eDcMkNDzqH3Ngapp+GeTOrM9o1Lm03FaAGD2bj0YgyDMWbizRPCweJ
	sdnMxsw==
X-Received: from pjqo2.prod.google.com ([2002:a17:90a:ac02:b0:359:dfa:87b2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ccd:b0:34c:99d6:175d
 with SMTP id 98e67ed59e1d1-358ae7e9facmr14240529a91.2.1772041457104; Wed, 25
 Feb 2026 09:44:17 -0800 (PST)
Date: Wed, 25 Feb 2026 09:44:15 -0800
In-Reply-To: <aZ8xje-iM0_9ACie@tycho.pizza>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260223162900.772669-1-tycho@kernel.org> <20260223162900.772669-3-tycho@kernel.org>
 <aZyCEBo07EHw2Prk@google.com> <aZyE4zvPtujZ4-6X@tycho.pizza>
 <aZyLIWtffvEnmtYh@google.com> <aZzQy7c8VqCaZ_fE@tycho.pizza>
 <aZ3ntHUPXNTNoyx2@google.com> <aZ8xje-iM0_9ACie@tycho.pizza>
Message-ID: <aZ8077EfpxRGmT-O@google.com>
Subject: Re: [PATCH 2/4] selftests/kvm: check that SEV-ES VMs are allowed in
 SEV-SNP mode
From: Sean Christopherson <seanjc@google.com>
To: Tycho Andersen <tycho@kernel.org>
Cc: Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 25, 2026, Tycho Andersen wrote:
> On Tue, Feb 24, 2026 at 10:02:28AM -0800, Sean Christopherson wrote:
> > Hmm, I like the idea of clearing supported_vm_types.  The wrinkle is that "legacy"
> > deployments that use KVM_SEV_INIT instead of KVM_SEV_INIT2 will use
> > KVM_X86_DEFAULT_VM, and probably won't check for SEV and SEV_ES VM types.
> 
> Does that matter?

Yes, but I don't think it matters so much that it's worth dealing with.  For me,
being slightly nicer to userspace doesn't justify the risk of confusing KVM.

> If in the case of CiphertextHiding we would revoke KVM_X86_SEV_VM, users
> already couldn't start a VM anyway in the configuration.
> 
> The firmware update is more tricky, but I don't think you can blame
> the kernel there...

Yeah, that's about where I'm at. 

> > Alternatively, or in addition to, we could clear X86_FEATURE_SEV_ES.  But clearing
> > SEV_ES while leaving X86_FEATURE_SEV_SNP makes me nervous.  KVM doesn't *currently*
> > check for any of those in kvm_cpu_caps, but that could change in the future.  And
> > it's somewhat misleading, e.g. because sev_snp_guest() expects sev_es_guest() to
> > be true.
> > 
> > Given that it doesn't make sense for KVM to actively prevent the admin from upgrading
> > the firmware, I think it's ok if KVM can't "gracefully" handle *every* case.  E.g.
> > even if KVM clears X86_FEATURE_SEV_ES, userspace could have cached that information
> > at system boot. 
> > 
> > > > Hrm, I think we also neglected to communicate when SEV and SEV-ES are effectively
> > > > unusable, e.g. due to CipherTextHiding, so maybe we can kill two birds with one
> > > > stone?  IIRC, we didn't bother enumerating the limitation with CipherTextHiding
> > > > because making SEV-ES unusable would require a deliberate act from the admin.
> > > 
> > > We know these parameters at module load time so we could unset the
> > > supported bit, but...
> > > 
> > > > "Update firmware" is also an deliberate act, but the side effect of SEV-ES being
> > > > disabled, not so much.
> > > 
> > > since this could be a runtime thing via DOWNLOAD_FIRMWARE_EX at some
> > > point, I guess we need a new RUNTIME_STATUS ioctl or similar. Then the
> > > question is: does it live in /dev/sev, or /dev/kvm?
> > 
> > Ugh.  Yeah, updating supported_vm_types definitely seems like the least-awful
> > option.
> 
> Since firmware update only happens on init right now, I think we can
> add a:
> 
>     int sev_firmware_supported_vm_types();
> 
> that will do the feature detection from the ccp, and merge that with
> the results based on asid assignments during module init.

Ya, I don't have a better idea.  Bleeding VM types into the CCP driver might be
a bit wonky, though I guess it is uAPI so it's certainly not a KVM-internal detail.

> We'll eventually need some callback into KVM to say say "hey the
> firmware got updated here's a new list of vm types".
