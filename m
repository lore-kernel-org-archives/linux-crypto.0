Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D23330648
	for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2026 17:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771866917; cv=none; b=df9F2ox8CYiNt0OSxSKe2MVLj6rX86DIbN37If1yybfjjZ30ZM9IMU+A1R/sB7cfGsV5zgVKPkM0gRH4HZYA6Hs6kOP0/AsbymERV++ljxvcWDKTJnPcEuxnkbp8SQV4tXEW6Y1Gbv7uaJtAlPOB+uOUjke/RDjQa+mI5853hoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771866917; c=relaxed/simple;
	bh=HKwLbvFmJGYEGnpPr7MOM6oLTlNTOu8bfAhYYTRO13E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jSpHCfQbwzrobqar9zaOP0qRN70cEx7ZH7nbsUVZO388KRNOdnZ+5sD6FLkmF3S8jhJb41w4FCJqgfNc+MSIgA8S0fTLZj6OHAcuYAkj+Lk3g4Wk5gz5Q00SRsW6oSHX27AtgfxndAJz7Jt9EO2035zB8vOKCe9DVj5JEQy0APY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WgAGk0Bk; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WgAGk0Bk"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2aad60525deso336739055ad.1
        for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2026 09:15:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771866915; x=1772471715; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qB/D8oykiAjYH+aojy11MUffmbGAGIdMwqBS+z3LBGk=;
        b=WgAGk0Bk55uiejxu96L2NKrxY/yQztTYJ8SjfeOjAsYB7UT2PY82EebeMu4INfNuQ8
         24F1frhdW0Vr57JI/tAe/cCk0U/dEit9Va6WGmeKLxVZAR3pdx3cBZK3r0NM4VJGwqJJ
         Szq3x6FoggeTgB5m33sAm3rxMwMY+ODR9AMGY+KcITBlHxqT5m0w0O2VGEdEmn179oRm
         HADjm7dAr5CwfxOTRwl9izLomLx+v68xPhWio0rzKwRLP1UGNWLMxmJRsnfJESaj7yor
         6DXxIHFxKS+jZ8c3r45dt/NP0itUtxwefT4XNaLp+WqGmprewC88ZCM4mSbtIAzNJCnf
         DyOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771866915; x=1772471715;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qB/D8oykiAjYH+aojy11MUffmbGAGIdMwqBS+z3LBGk=;
        b=SgVqqrqrKEQaSBSAn8XnF67gTJGlLI5Jii6WP+bXdQpEtW+9mBUxxdltOUSvMpkPKn
         D10zMxBYsjF+2SKqTY3h2Sn9H3k3Za4yatVLP1W/lYVqeBar3gCpqGQsS1KRYN40ed0F
         kbqzIDH2CBF0AT+I4iNz7qbnvHz0l42PIKi+n40yaE3U7zMp/c2l9NazhI/NxjcyrGCu
         +njkikAhaFOjH+VE6Lq+Eaf548Ur1lwYJczYH6+OQmnevpAh78IhbXnOu1ZLkUIFQJLw
         9v2GGW4Qn1cHE2BwbNO2xAqT87Oetl19YO1w7GeSEgA4O4v3Wc7oxLfy0DAiUAlYTpYq
         9E6g==
X-Forwarded-Encrypted: i=1; AJvYcCVGceisZQPLbQbliNsaVKJBrfcE880Mb0792MxQa9a9Od8xnd3vz8A88mqf5A3VgV4bDctCsLSA985B0g8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwC5hTxLeFWYL0Lqr1yiRCHuG1F2G92TgwIfjlsQ8GdwhPmPzUN
	fgZRNc8cJHl1k44+kICXyCwC/ac3tMUgBSvRpw4osleldMOb9T5mZhc658lTTU9WEEzGB/Kr/pZ
	E5Gk34w==
X-Received: from plpw17.prod.google.com ([2002:a17:902:9a91:b0:2a0:c485:7eed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b90:b0:2a9:411a:c5c6
 with SMTP id d9443c01a7336-2ad74511698mr75532445ad.39.1771866915160; Mon, 23
 Feb 2026 09:15:15 -0800 (PST)
Date: Mon, 23 Feb 2026 09:15:13 -0800
In-Reply-To: <aZyE4zvPtujZ4-6X@tycho.pizza>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260223162900.772669-1-tycho@kernel.org> <20260223162900.772669-3-tycho@kernel.org>
 <aZyCEBo07EHw2Prk@google.com> <aZyE4zvPtujZ4-6X@tycho.pizza>
Message-ID: <aZyLIWtffvEnmtYh@google.com>
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

On Mon, Feb 23, 2026, Tycho Andersen wrote:
> > > +	/*
> > > +	 * In some cases when SEV-SNP is enabled, firmware disallows starting
> > > +	 * an SEV-ES VM. When SEV-SNP is enabled try to launch an SEV-ES, and
> > > +	 * check the underlying firmware error for this case.
> > > +	 */
> > > +	vm = vm_sev_create_with_one_vcpu(KVM_X86_SEV_ES_VM, guest_sev_es_code,
> > > +					 &vcpu);
> > 
> > If there's a legimate reason why an SEV-ES VM can't be created, then that needs
> > to be explicitly enumerated in some way by the kernel.  E.g. is this due to lack
> > of ASIDs due to CipherTextHiding or something?
> 
> Newer firmware that fixes CVE-2025-48514 won't allow SEV-ES VMs to be
> started with SNP enabled, there is a footnote (2) about it here:
> 
> https://www.amd.com/en/resources/product-security/bulletin/amd-sb-3023.html
> 
> Probably should have included this in the patch, sorry.
> 
> > Throwing a noodle to see if it sticks is not an option.
> 
> Sure, we could do some firmware version test to see if it's fixed
> instead? Or do this same test in the kernel and export that as an
> ioctl?

Uh, no idea what would be ideal, but there absolutely needs to be some way to
communicate lack of effective SEV-ES support to userspace, and in a way that
doesn't break userspace.

Hrm, I think we also neglected to communicate when SEV and SEV-ES are effectively
unusable, e.g. due to CipherTextHiding, so maybe we can kill two birds with one
stone?  IIRC, we didn't bother enumerating the limitation with CipherTextHiding
because making SEV-ES unusable would require a deliberate act from the admin.

"Update firmware" is also an deliberate act, but the side effect of SEV-ES being
disabled, not so much.
