Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1B11AE005
	for <linux-crypto@vger.kernel.org>; Wed, 19 Feb 2025 00:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926495; cv=none; b=rxebWW0k9jy0GdWdAt22DENfzf8x6z6WSqJZoVfnF6M666iUQCTdGpr3GgvPGkjO9ujPlN924Bl8OfMmQHemC9Psr103LG7vqM6psdUDAJYdS/HUc7IQC+whz0sEJgY+WkJsu4qSzFKetLltDTANcBfzYYofs3xBeODlSq0kXTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926495; c=relaxed/simple;
	bh=x3RPoMgClhFCt1lMFR9y6/g2w/dNOeOD2RyoSpfCcNQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uTVx4hpmPITUXSeIKrWKb9vB99ks+revsiQ7M8bR0SSaxh7pFFK7HIPsMTvfand7wVL8N9FQu5t+PakkOaL0vsa3t+q2c2O5mufLGDZjrhWqRsPMl9PntKg47feTyiHofLQg5vpIa3iqvURtOfJRaXfGz1AJpQH/7jmHcQohEWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iHdvqZpV; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iHdvqZpV"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-220ff7d7b67so86728745ad.2
        for <linux-crypto@vger.kernel.org>; Tue, 18 Feb 2025 16:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739926493; x=1740531293; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t46C7YC0Fd2kjhrwUymr7qDRo6+1mzmJx//VkrOA+Ek=;
        b=iHdvqZpV75I1ZIck3eCmNFFNQCGqZrDDrRKRLFoAoJLXLTmwlWwHEJwlnig6U64O5D
         3/J3A+kPtyqaOmmy+nAHacpf6jQM72h0LF1Zb039yX/qxIWKpm0HfgM23gCJBvdeQJ5t
         EGrMxB70S34OJtpjTwI4WHzy2zGTPZaQRE+WRXhfl+eWNNTQUbQWXmve/pb5Q0qja5On
         X0oyjuAT1BJJh/IyTqKzDP2gKYB91ShFtH3oNdiZrcZmob064hxYoZ3oJtRJbAIeY+Mb
         CPBkvygSCMj3KIqeZaneu8l42a4iE06//N7C44chUeN5cPBBhNsDEVVlgpF1R8L9AbKU
         Tjrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739926493; x=1740531293;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t46C7YC0Fd2kjhrwUymr7qDRo6+1mzmJx//VkrOA+Ek=;
        b=c9UriWQptHIMuhMzI4J8qiPWs7suQzr+QZHzY6ag8WvWOMX7jymiY+H2ru364sFRMf
         a69Q0hj/7nEZXvJOfRYNwN8dPtiiJaEl5yIlwZ+SrK8yjAAI9K5pQQoR+NqpHGbztqCb
         MsHGYEQs0J5GT2Btrcwr40f1Gq2hldpk+KK51IWtqogw0CdAQD/mCUyqnklY/6113i5v
         aw4c+UBcYqAZ8OB+bf1IaMZdhc9S5Tj5N5goMvc24r0G8ZiAdaneayFdSrds0jjr2i4i
         M6keyb4WDBfTGvLLj/uVeM4+llk81YFnrOdkpdQzUutEP8MW8dQjwoCQoeQH3/Q0yPej
         dWUg==
X-Forwarded-Encrypted: i=1; AJvYcCW+xSl9YOpAMpI52J2AagT6CXkBAqJ2hWHhIJKXqixtuIEPS03lqyntFhgSD/I0uH0aHU+7x3Yw0OpTog8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/mJA1QPNX/yEl9mdu3CXcMQR6tvegg1gYLttoCN5XkKU8V5Of
	XQqpgEQe0YW7vSk95AtePdVYAFPzhKwN+TmMpl9ifSOoP64rVys0cyRQN3DMzVQIRojq5HV3M9r
	ugg==
X-Google-Smtp-Source: AGHT+IFoS17LPJHddOQYgLraCie+jUqiUNgSY4BvAPXCIbSdRL9BrOE7UFqk4VCrHI3npo5kmzEKCjCQGtA=
X-Received: from pfbkq16.prod.google.com ([2002:a05:6a00:4b10:b0:730:98b0:1c58])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7a4c:b0:1ee:c8e7:203c
 with SMTP id adf61e73a8af0-1eec8e7219amr8474405637.24.1739926493632; Tue, 18
 Feb 2025 16:54:53 -0800 (PST)
Date: Tue, 18 Feb 2025 16:54:52 -0800
In-Reply-To: <e3136d20-977a-4e2d-ad7b-c04be1dca1db@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250203223205.36121-1-prsampat@amd.com> <20250203223205.36121-10-prsampat@amd.com>
 <Z6wIDsbjt2ZaiX0I@google.com> <e3136d20-977a-4e2d-ad7b-c04be1dca1db@amd.com>
Message-ID: <Z7Ur3HyM15vFBEvR@google.com>
Subject: Re: [PATCH v6 9/9] KVM: selftests: Add a basic SEV-SNP smoke test
From: Sean Christopherson <seanjc@google.com>
To: Pratik Rajesh Sampat <prsampat@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	pbonzini@redhat.com, thomas.lendacky@amd.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, shuah@kernel.org, 
	pgonda@google.com, ashish.kalra@amd.com, nikunj@amd.com, pankaj.gupta@amd.com, 
	michael.roth@amd.com, sraithal@amd.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 14, 2025, Pratik Rajesh Sampat wrote:
> 
> 
> On 2/11/25 8:31 PM, Sean Christopherson wrote:
> > On Mon, Feb 03, 2025, Pratik R. Sampat wrote:
> >> @@ -217,5 +244,20 @@ int main(int argc, char *argv[])
> >>  		}
> >>  	}
> >>  
> >> +	if (kvm_cpu_has(X86_FEATURE_SEV_SNP)) {
> >> +		uint64_t snp_policy = snp_default_policy();
> >> +
> >> +		test_snp(snp_policy);
> >> +		/* Test minimum firmware level */
> >> +		test_snp(snp_policy | SNP_FW_VER_MAJOR(SNP_MIN_API_MAJOR) |
> >> +			SNP_FW_VER_MINOR(SNP_MIN_API_MINOR));
> > 
> > Ah, this is where the firmware policy stuff is used.  Refresh me, can userspace
> > request _any_ major/minor as the min, and expect failure if the version isn't
> > supported?  If so, the test should iterate over the major/minor combinations that
> > are guaranteed to fail.  And if userspace can query the supported minor/major,
> > the test should iterate over all the happy versions too. 
> > 
> 
> Yes, any policy greater than the min policy (defined in sev-dev.c)
> should be supported. The sad path tests were intended to be added in the
> upcoming negative test patch series so that we could have the proper
> infrastructure to handle and report failures.
> 
> > Unless there's nothing interesting to test, I would move the major/minor stuff to
> > a separate patch.
> 
> Would you rather prefer I do the happy tests here (something like -
> min_policy and min_policy + 1?) and defer the failure tests for the
> next patchset? Or, I can remove policy testing from here entirely and
> introduce it only when the sad path testing infrastructure is ready, so
> that we can test this completely at once?

Let's do the latter.  For the initial series, do the bare minimum so that we can
get that merged, and then focus on the min API version stuff in a separate series.
The version testing shouldn't be terribly complex, but it doesn't seem like it's
entirely trivial either, and I don't want it to block the base SNP support.
