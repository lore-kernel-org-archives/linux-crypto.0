Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BB317B51E
	for <linux-crypto@vger.kernel.org>; Tue, 14 May 2024 14:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715697388; cv=none; b=sz7wJmmvwRgCMCgjrE1YUo4w9HeVl6iQFqSB9kgyk9nd3MRNhAc67O7RjBfmVKTWsnGNn2IZ2h2WAInSutyqGxYzcuE1FXPKmQJLGomEIvxA7oO70LSBWBR3TFFnOvop7ClrQdBEPjaaW+9eZm12fiXj7sJiBzS60SfyT+Zw2sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715697388; c=relaxed/simple;
	bh=t7yCNqxHRAZaQ2Sd6n4IftLmyDfcyT+WoeB7g0mJ+zk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p5XgXKHKKc/N8ewAhWlOWdnKEOiuVtJpVx97ol7LwXts+0OU0FSfMf+T1/pLcwgEvz0PvQv8+Gk/VJPY75yCMt7DfXtCgX4LYcFPMp7vxzY74PDomDOKIkVdnkzehq6+poNaQygJm5n8JfFQYTyMVAXYrOENFuWssm+ta4XAJLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VYWgoOLm; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VYWgoOLm"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-ddaf165a8d9so7788204276.1
        for <linux-crypto@vger.kernel.org>; Tue, 14 May 2024 07:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715697386; x=1716302186; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KYTu2iCc2EA3s2d3YSNEraBt/XVrVyPfkFgkt4k3sTk=;
        b=VYWgoOLmW713qe4+R4rMwxAH6E9xTrR91bX51w8tDI4l16N3eXKNIXmMhE9VkyYXj4
         gP099RbCLJHYg/k6A3lLSbleU1Cf6NVB2MtbUKJKO2cpzVEVV/z1XN0QbISx1QtNh/Cn
         BVoSIWr9twlVObNFGk3IqnBNrCz3xwOZSZacGad4+HQalfUleMWfHmDzkJIWW/hCmQIZ
         s94cYiTECypFEAnivkS8Zm1ap1Z1VM5JSKRGg1LnfpFG82VvKOXEQoz8HL8Eyl4t1ktB
         afFhUaXsZbxUKK6p9Jbcy/KdwGBCsIUacxBspP71lGqaxn8CSiqOjU1YzT15eWPB6gv1
         MHUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715697386; x=1716302186;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KYTu2iCc2EA3s2d3YSNEraBt/XVrVyPfkFgkt4k3sTk=;
        b=qp86t/wLXZg+YMImkR7JrG5naSvm8dG+l9UNCR/pOqHvH6a2Ah8Rd7vIZI4gdzztE6
         V2SkeTzlonrhxy3k4RIy5BaBqvH2K0nfvHHkTtgCm0PRCBufeoRJzelBb85liKSGtB9M
         VM1fO0G3EyNQu4a5yMnnlcmb7c4YSX+mcrSpOdaC59s0lUbIRvIWeG/Av0LN8WxISv5e
         hR2tSPEYpLYl3uVVGjuybGk1+QbPFIKqtYuOzI/qv2mS+GZ+SA5Nfg36LWh7K5tFCQt6
         m89uOg6trCSJUr+McKHdRkI2Xai4f+9ByRbh3IAjqpuVgn5EH20W/XCqbGLPgxPbX0nU
         iX0g==
X-Forwarded-Encrypted: i=1; AJvYcCWidDhUQOArvKvwpfpIgthUsfYi0lyPd6FDhDf2M/vIgAZW5Mm+EEuuJNqGmCcSN656ccKnW8VUvUfCHW9KpK0rlyK/XO3+4D/sn3n3
X-Gm-Message-State: AOJu0YyP3llzA7dIx2LYH9kCng8AaDbE/58vPYWhLvYE08p7Iiaok3YR
	6qxqZVr2emOppG3dGmqdMEoSlHBtGr4RMQtRxjzxmSlqbLikKMpwkoFhngZsgMLjlRqLOp21uSl
	9ww==
X-Google-Smtp-Source: AGHT+IHYaKqQtQDZbvNEErS6KoOnbawFKVawxYz7fbohTiQjqYIJFXlVkCIxnrX3xKI/sJJLEXcxbqiBdX4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:fb0e:0:b0:de6:bf2:b026 with SMTP id
 3f1490d57ef6-dee4f506a8amr1045972276.13.1715697386197; Tue, 14 May 2024
 07:36:26 -0700 (PDT)
Date: Tue, 14 May 2024 07:36:20 -0700
In-Reply-To: <20240514025115.dkw3ysqrdbfaa2sg@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240501085210.2213060-20-michael.roth@amd.com> <ZkKmySIx_vn0W-k_@google.com>
 <20240514025115.dkw3ysqrdbfaa2sg@amd.com>
Message-ID: <ZkN25BPuLtTUmDKk@google.com>
Subject: Re: [PATCH v15 19/20] KVM: SEV: Provide support for
 SNP_EXTENDED_GUEST_REQUEST NAE event
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com
Content-Type: text/plain; charset="us-ascii"

On Mon, May 13, 2024, Michael Roth wrote:
> On Mon, May 13, 2024 at 04:48:25PM -0700, Sean Christopherson wrote:
> > Actually, I take that back, this isn't even an optimization, it's literally a
> > non-generic implementation of kvm_run.immediate_exit.
> 
> Relying on a generic -EINTR response resulting from kvm_run.immediate_exit
> doesn't seem like a very robust way to ensure the attestation request
> was made to firmware. It seems fully possible that future code changes
> could result in EINTR being returned for other reasons. So how do you
> reliably detect that the EINTR is a result of immediate_exit being called
> after the attestation request is made to firmware? We could squirrel something
> away in struct kvm_run to probe for, but delivering another
> KVM_EXIT_SNP_REQ_CERT with an extra flag set seems to be reasonably
> userspace-friendly.

And unnecessarily specific to a single exit.  But it's a non-issue (except
possibly on ARM).

I doubt it's formally documented anywhere, but userspace absolutely relies on
kvm_run.immediate_exit to be processed _after_ complete_userspace_io().  If KVM
exits with -EINTR before invoking cui(), live migration will break due to taking
a snapshot of vCPU state in the middle of an instruction.

Given that userspace has likely built up rigid expectations for immediate_exit,
I don't see any problem formally documenting KVM's behavior, i.e. signing a
contract guaranteeing that KVM will complete the "back half" of emulation if
immediate_exit is set and KVM_RUN return -EINTR.

ARM is the only arch that is at all suspect, due to its rather massive
kvm_arch_vcpu_run_pid_change() hook.  At a quick glance, it seems to be ok, too.
And if it's not, we need to fix that asap, because it's like a bug waiting to
happen.

> > If this were an optimization, i.e. KVM truly notified userspace without exiting,
> > then it would need to be a lot more robust, e.g. to ensure userspace actually
> > received the notification before KVM moved on.
> 
> Right, this does rely on exiting via , not userspace polling for flags or
> anything along that line.
> 
> > 
> > > +					__u8 flags;
> > > +  #define KVM_USER_VMGEXIT_REQ_CERTS_STATUS_PENDING	0
> > > +  #define KVM_USER_VMGEXIT_REQ_CERTS_STATUS_DONE		1
> > 
> > This is also a weird reimplementation of generic functionality.  KVM nullifies
> > vcpu->arch.complete_userspace_io _before_ invoking the callback.  So if a callback
> > needs to run again on the next KVM_RUN, it can simply set complete_userspace_io
> > again.  In other words, literally doing nothing will get you what you want :-)
> 
> We could just have the completion callback set complete_userspace_io
> again, but then you'd always get 2 userspace exit events per attestation
> request. There could be some userspaces that don't implement the
> file-locking scheme, in which case they wouldn't need the 2nd notification.

Then they don't set immediate_exit.

> That's why the KVM_USER_VMGEXIT_REQ_CERTS_FLAGS_NOTIFY_DONE flag is provided
> as an opt-in.
> 
> The pending/done status bits are so userspace can distinguish between the
> start of a certificate request and the completion side of it after it gets
> bound a completed attestation request and the filelock can be released.


