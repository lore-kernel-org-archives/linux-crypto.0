Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37F93AC0CD
	for <linux-crypto@vger.kernel.org>; Thu, 12 Mar 2026 20:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773345895; cv=none; b=C2BTrh/LJYyqVCSO6iNLJojaCP2W0Bt+44Epiz/5mfhbmnifH5I9FXmJzIub0kxMu6w3OAEi3KBlZ7L584bw2+wgA2Y6lNyu/ItzxMYXSmTS7dS7MKcmP87w5IoHRtXRZb7xgyXHOIFl9KVS/44ubOy9rLIb1b0ZyWSCTZyip2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773345895; c=relaxed/simple;
	bh=Q2Dz5/OEh6DH4pX3NgP0K3CGI0lXwl2eOSeT06eOFH4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ul8T/kkeZ2bBOHeQPNEP69i4P7rCmTGTsGkzlHOEdIpxsIWMvM8HMubv9VNF6wi+d+EHy1hCMfLS5gZs+z0yKmACyzwoFKnfL+exJonkEU672mLCkJDMnxTEmWnb4tmGTPsdQuvUpOeoB0QOF6Hq+8sgdyLl8IqIIlgq3tHJUAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qS4O+BzF; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qS4O+BzF"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae502a1dd9so20298575ad.3
        for <linux-crypto@vger.kernel.org>; Thu, 12 Mar 2026 13:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773345893; x=1773950693; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mquuBhH5mEBbGKF1zjKCYUJkvskIC0Bertlw5dm983s=;
        b=qS4O+BzFHSVoxn0NOz01fRbXJYI8xiDIUFNINNAaLM3JjeDpJPsGPXjDeplIgDkGex
         SIAiUbrvNFpY83Mi+AUl5xXMS/2pw9nkGE9hnOZavHjtojp3Sj0Pt+YZSWOnpLDaHi8p
         uQkJT/VU5zJ2+DbN+lMQeQA80bLPvQjoI2x1vPX793FJkJHHzkPG0XadXZzA2KV4TNpL
         4HqMW3rOfsOGHDbBBEGroMOWa8KZTj/0fnpB8PJia+XzlBs3N2oNns2/TzWqpHxN3MOw
         5eHUNDQr4rXUByN/naaEKIDBxkG4bxkpp+yiG3OAeR+rV+4+BNsDKl3ylBCnYJDC2KTP
         XhrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773345893; x=1773950693;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mquuBhH5mEBbGKF1zjKCYUJkvskIC0Bertlw5dm983s=;
        b=FSUhTRN7dzK7D/DfGqFUkwkKNDJua89kUuy7fZpyf7U3R3EPmoKAy0+LvdD10kG4EI
         vBevzXNTgWHoxSgpGg2FZb9b52QHDC05sj7XrQcb4PTW33kQt0pDoJ5+12OD/nLlc8H7
         Ax4e+Vj1I3uzeKKs4PHrRa9/YSSKGgFMOS7sKPwmOKsIXOu79p/JLFXhwZ9SzJmqH6eR
         QmVxXU94qMN0chVrCNPcIZM1JwSsyJS+t/gjSbIlNtRqwLiz+2BkesKxfoic8UFBeD6I
         OXWzWEbCwqJ/6xC21K5JKoakCczsnV3eBhlfBU2y8Au7UOjc46AcLkauHnfTGtDa9Psv
         lj9A==
X-Forwarded-Encrypted: i=1; AJvYcCVTBJD9DOr8v2Sf4ZEzq1ENaXEsR20cmLmxc7L84nexSTWE5JEPziygZ9QrD3BzMY+1XAGEKdzWwrFuL0k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxspMAP/YfJxeFrCAPdMI+319AV4CloZQE1mhwEoGN1mdcD7FBg
	9jsZYceMNtNk4nfgGe46pSh8Mb6n+0tX2eg9MlPTe8psR/ua7C1xsq1j6m93LQOn7FNQQjzSdWI
	UUxZQag==
X-Received: from plcf13.prod.google.com ([2002:a17:903:104d:b0:2ae:c5aa:fcd7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d485:b0:2ae:5228:e0ff
 with SMTP id d9443c01a7336-2aecaacf65cmr5648905ad.29.1773345892982; Thu, 12
 Mar 2026 13:04:52 -0700 (PDT)
Date: Thu, 12 Mar 2026 13:04:51 -0700
In-Reply-To: <20260303191509.1565629-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260303191509.1565629-1-tycho@kernel.org>
Message-ID: <abMcYw1wMin6cqY8@google.com>
Subject: Re: [PATCH 0/5] Revoke supported SEV VM types
From: Sean Christopherson <seanjc@google.com>
To: Tycho Andersen <tycho@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Shuah Khan <shuah@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 03, 2026, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> Recent SEV firmware [1] does not support SEV-ES VMs when SNP is enabled.
> Sean suggested [2] adding an API so that userspace can check for this
> condition, so do that. Also introduce and use SNP_VERIFY_MITIGATION to
> determine whether it is present or not.
> 
> [1]: https://www.amd.com/en/resources/product-security/bulletin/amd-sb-3023.html
> [2]: https://lore.kernel.org/all/aZyLIWtffvEnmtYh@google.com/
> 
> Tycho Andersen (AMD) (5):
>   kvm/sev: don't expose unusable VM types
>   crypto/ccp: introduce SNP_VERIFY_MITIGATION
>   crypto/ccp: export firmware supported vm types
>   kvm/sev: mask off firmware unsupported vm types
>   selftests/kvm: teach sev_*_test about revoking VM types
> 
>  arch/x86/kvm/svm/sev.c                        | 16 +++-
>  drivers/crypto/ccp/sev-dev.c                  | 84 +++++++++++++++++++
>  include/linux/psp-sev.h                       | 56 +++++++++++++
>  .../selftests/kvm/x86/sev_init2_tests.c       | 14 ++--
>  .../selftests/kvm/x86/sev_migrate_tests.c     |  2 +-
>  .../selftests/kvm/x86/sev_smoke_test.c        |  4 +-
>  6 files changed, 162 insertions(+), 14 deletions(-)

Other than a few nits, this LGTM.  Even though the sev-dev.c changes are far more
extensive, I would prefer to take the KVM changes through kvm-x86 due to the
effective change in KVM's ABI.  I'd be happy to carry the whole thing, or use a
stable topic branch as a base (patch 1 can easily become patch 3). 
