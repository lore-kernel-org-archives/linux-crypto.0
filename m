Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB912D7397
	for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2025 18:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763060060; cv=none; b=IDEJhdsXVUtEOFDP8DkXBTU01lsG4zXt20XOlWre5qT81EP1+jUU16MryqT2Wer/C7TgKLcwBOYI9JwiBpdUwm+0v/6/lL3aaTsmObBOOpTzA2zV2YQEie6P8I2504paPg+BQBbaXnEitjCaIkHztCzF9feRlLx/BrW1ZYjk1O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763060060; c=relaxed/simple;
	bh=FMPyLvuUt/PZ/G5WxsY1vXR+Y88MXaoP25kSbGbbODI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QRaU/jW2S0ehJof4ev/Sna2rMTwkhqJeNPdoxOi/oBvt/rez3IXDvXuH5A5hdtCzrx3PsKyhVutq+PYB/8ltVoKdK862Ws7TcvsTtRfhY+QUv7fqMqgVhbbBwZs3IPSWrzf0KiZzLewV/wc1L7tE/8vvb7pVzqZSbff/6vqEOY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wI8zZZW/; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wI8zZZW/"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2958c80fcabso30112195ad.0
        for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2025 10:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763060058; x=1763664858; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8n1/s9RaZEcOt9m3QKGZKQE6sB/YqrRhU3punAll4EM=;
        b=wI8zZZW/VF8Oqchn4RmT5CMgfJc7cIhrIaP5VP04ocNyNIp/6fdsjQMxoglbZpcc+T
         QCMrPhRiwmjUALSNFoWp9hdMPTEKMt7E5J5LQiOpm+7oEnCMqCLfzOfSIdj1uWF3FZcq
         DuxY1rmn1dGoj2BtpBGXMS6xpPBNSGDi9u7TbaQ4D/8Il868LHgZVGKIuP74/oTp4M5R
         49RWsHRpk1cCqroalz2R3tb9YE16d2N5F0HxbRhb/8rrirVxXWawj+hxmdffvL6v9J3f
         2bR8Gyrfh5dvz24OJM5Sz3Og3+0bfqAc+225RX3ePc1h4uypR81DHPoOl95YocGfZ8iO
         B8kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763060058; x=1763664858;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8n1/s9RaZEcOt9m3QKGZKQE6sB/YqrRhU3punAll4EM=;
        b=hDm2HSmMPMB4iZp/+PHQOzG/pEFyrZrIPVBhvvWp8SfertC8aXFA6jMp9bs0Z+Pm9W
         ZTLjJPGwXEqJXTIzzvbXRwTtyZammh6o7YezCB0V/B/wsXMEuuho2BTCLUaVQI17DNKs
         ZrccbXVIbGKuFqqqRD/5/0c1IfZ52L0LuQwdXBujrUqjNYHhOw9RcWnbjTpErT6dk0SS
         CjCr+BtfP6HVTk/jVbfyOcNa4gSLeQsWMqXVOxIM+CGIJE06QssCb88TSlkOGHZRWQ4r
         7Yx74w/OMOHPMkxkLOSJ0YSEkgEaHYR3WfkDdT7XLe0NcJ6t+ga1r/f5TE5LjneQz7AN
         sf/w==
X-Forwarded-Encrypted: i=1; AJvYcCXE1M0fCZMWgnz+jlZzq4BJ5ApQBwKVCQH2lZble+VUSBV51380SSceBS6F10ZvX0Rz+cY8BxA/+g1aD2s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyucBSQl4rGvKY9d0MAYucyUI+kQHjBt/Hp2z6ccR2QX6xS3v5o
	H8ICNnnr1MLEt+6kIvIAiU4csh3YzlFCJPGgBpi7drRRaq+T7yDrJO3sw1UoCs9HXyBGPZGOlyV
	2iMGf0w==
X-Google-Smtp-Source: AGHT+IEvsarrirvmCeHl1ineeicRUqdZYmQTIKm6UrYT7suNIHa17FzvX/dSYhupzGO5pgYCgT7nAj0KE/M=
X-Received: from plbkw15.prod.google.com ([2002:a17:902:f90f:b0:290:bd15:24ab])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1107:b0:297:e1e1:beb1
 with SMTP id d9443c01a7336-2986a6d684bmr712255ad.16.1763060058279; Thu, 13
 Nov 2025 10:54:18 -0800 (PST)
Date: Thu, 13 Nov 2025 10:54:16 -0800
In-Reply-To: <cover.1761593631.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1761593631.git.thomas.lendacky@amd.com>
Message-ID: <aRYpWLUn5IABs1Vx@google.com>
Subject: Re: [PATCH v4 0/4] SEV-SNP guest policy bit support updates
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	linux-crypto@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 27, 2025, Tom Lendacky wrote:
> This series aims to allow more flexibility in specifying SEV-SNP policy
> bits by improving discoverability of supported policy bits from userspace
> and enabling support for newer policy bits.

...

> Tom Lendacky (4):
>   KVM: SEV: Consolidate the SEV policy bits in a single header file
>   crypto: ccp - Add an API to return the supported SEV-SNP policy bits
>   KVM: SEV: Publish supported SEV-SNP policy bits
>   KVM: SEV: Add known supported SEV-SNP policy bits
> 
>  arch/x86/include/uapi/asm/kvm.h |  1 +
>  arch/x86/kvm/svm/sev.c          | 45 ++++++++++++++++++++-------------
>  arch/x86/kvm/svm/svm.h          |  3 ---
>  drivers/crypto/ccp/sev-dev.c    | 37 +++++++++++++++++++++++++++
>  include/linux/psp-sev.h         | 39 ++++++++++++++++++++++++++++
>  5 files changed, 105 insertions(+), 20 deletions(-)

Looks good overall, just the one minor nit.  Given that this adds new KVM uAPI,
and the CCP changes are fairly minor in the grand scheme, my preference would be
to take the entire series through kvm-x86 (with Acks as appropriate).
