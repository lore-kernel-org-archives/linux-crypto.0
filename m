Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C42263C9F
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 00:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779151449; cv=none; b=qNTNOk3TMl4dXd5ZP/NUDAM30kRIt5AGbipZKIzo3oHshpDiYEkPEx0T2Ys3OnlEKLZClLza96e51dxAY3k2khbe7bgbPBKfb96vZEdLYN268Xw3UEFgS9rnYAg25LOPmEd/GImH34EsHx+GkgzOW6lHsUen1wraLUodhbMplZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779151449; c=relaxed/simple;
	bh=qmBzkNxEWGzq2VwD2HyByFiUYOVkAQ1nM5jGrpGDqvI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s2UI3bxODaM/lvj6UCFkB1gpFdbueUy2AIWZ0bGGLu+dpeL8iqHSgpd5HBVJebu12PGeHZT3Uy9HuqWGFlpGDNlZkvKBxpvlaDq1dQY4jd0pCGu4Twq6SJrmzjTnWDPTyenVi9X7kSnMdZIEgRCiL6fUAsdT3+yRncKiV0Nxq7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jsLqz0v/; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jsLqz0v/"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c70f19f0f37so1469805a12.0
        for <linux-crypto@vger.kernel.org>; Mon, 18 May 2026 17:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779151447; x=1779756247; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K5P6e80dFm0NAQdFpnmNLaZSqqU5/u6DG8vr5DyvsFM=;
        b=jsLqz0v//R8A4V6cCMa7jx2X4mXdJJk0Atu4+XeYeFgKnw5L1jIlieMCLy5hTH05O+
         pwb+Qv/nBxn67ShVjAZTMmATb2iO3TJghyvTG33fzW3w+sg35H0fTKrAR2sE8wc+s1f4
         k7VOwZXTGdKfNUw6D2ivvnQSLBuNlOs9+vQA7J6sX57CBTJGEpCwrBZYoeBwWvdYCV6H
         JG3sc5ilPr2SLKS8bAv9UpguIno2JinG5TJVUp7yFINJNZayp2+/6Cwz2TWuPLiHa7cL
         FKmj6cYwhcC16UO+hs2kD+NTeo4kxGhS7AzOAT4vGfnK5XMgzTjlcuXgafSe3PSM0wfH
         wLnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779151447; x=1779756247;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K5P6e80dFm0NAQdFpnmNLaZSqqU5/u6DG8vr5DyvsFM=;
        b=ArodJ0Y6/fVU4VPMNatzmrbgNP4JF/Tn00uB1jReFagFLgeGx5c22uho25rlXfFh+T
         ekDIUZgVTwVJDnePTA+td5k40pBgfku9uF6cK9pTQJ3VzTO5OHjHIhcXQR4cdoFI0MaJ
         9SfOz56OHL4r+uAaqfCfv2S0cnWelb1QIb0pRdFF8VnGyhH6IVz+ok9+2Movhmkmjwgc
         zhtQRGiIJN5tRw60BSyNf9v1h0x9vUKay/bkTo3dd5et80neVjLgP82E78gznfClv4Zb
         MLycUSEnwQsxtxBLJLiKHiYBdNX1slug9SSJWaLE77Uzc5CykaUOnl6kaioU/OG8cgnC
         HGCw==
X-Forwarded-Encrypted: i=1; AFNElJ/83ribhl3sbNoNtvXXfn8KHsY4bZsBDGUazswVUXjhn8Dyce6q7VurmcRf8uYMQjGc9u6Gq7mznH567Oo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1OloYcHCooUxxXdvsStnmF6JdAqQ/jDVmXwyortbQn7gUomhX
	UbTrz2ZBNzYRwPysx437XG7tCYUrN8XhJSj5dFb/hOobFx3I6ETft6FDKLmHUO5IPB5UJ5hVcf1
	Z0uB/rg==
X-Received: from pgbfm5.prod.google.com ([2002:a05:6a02:4985:b0:c82:7df9:8c21])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3382:b0:39c:4e62:b843
 with SMTP id adf61e73a8af0-3b22d1a7175mr15817756637.10.1779151447095; Mon, 18
 May 2026 17:44:07 -0700 (PDT)
Date: Mon, 18 May 2026 17:41:04 -0700
In-Reply-To: <20260416232329.3408497-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260416232329.3408497-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <177915097791.2229301.15490282436883023446.b4-ty@google.com>
Subject: Re: [PATCH v3 0/7] KVM: SEV: Don't advertise unusable VM types
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	Tycho Andersen <tycho@kernel.org>
Content-Type: text/plain; charset="utf-8"

On Thu, 16 Apr 2026 16:23:22 -0700, Sean Christopherson wrote:
> My preference would be to take this through the KVM tree, with acks on the
> crypto patches.  I'd also be a-ok with a stable branch/tag of the crypto
> changes.
> 
> In the words of Tycho:
> 
> Recent SEV firmware [1] does not support SEV-ES VMs when SNP is enabled.
> Expose this by revoking VM-types that are not supported by the current
> configurations either from firmware restrictions or ASID configuration.
> 
> [...]

Applied to kvm-x86 sev, thanks!  Holler if anyone needs a stable tag.

[1/7] crypto/ccp: hoist kernel part of SNP_PLATFORM_STATUS
      https://github.com/kvm-x86/linux/commit/acf4d11a35d8
[2/7] crypto/ccp: export firmware supported vm types
      https://github.com/kvm-x86/linux/commit/4b28f0846ef6
[3/7] KVM: SEV: Set supported SEV+ VM types during sev_hardware_setup()
      https://github.com/kvm-x86/linux/commit/c2a02db765af
[4/7] KVM: SEV: Consolidate logic for printing state of SEV{,-ES,-SNP} enabling
      https://github.com/kvm-x86/linux/commit/82bf8282444c
[5/7] KVM: SEV: Don't advertise support for unusable VM types
      https://github.com/kvm-x86/linux/commit/93d1a486e1d4
[6/7] KVM: SEV: Don't advertise VM types that are disabled by firmware
      https://github.com/kvm-x86/linux/commit/d8355a92df1f
[7/7] KVM: selftests: Teach sev_*_test about revoking VM types
      https://github.com/kvm-x86/linux/commit/accb7f3a6384

--
https://github.com/kvm-x86/linux/tree/next
