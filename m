Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6089F2D7813
	for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2025 18:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763059927; cv=none; b=CEMiwTg57iBgRVZABPSrJw1ev5CyEHS1glXJMF3L3WKHkoGj6hgwcnp383GKMHTCykpRPkQ6S57Pd4xYwPqPM8TxsgccDJcW7Zq+a38XoVfTVUuGZ+oLsWlUGaL0/vOFPJoz/FaP5YNEa8z2fqJUMm1XRUBsPS5VuPvhM6n8T5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763059927; c=relaxed/simple;
	bh=1I81ZMh2flMGmGHT9awFaIU8CTiz5EtPfzZ60BaJIQg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GephB9V/jxzIj+ukvG5HCCf3wKkCfm6e8rII5JSKLl2qnWeV2VFtHYhL1nCVaNX7X3wImF4LumfERe56RhjfkQt6u9l1eQ1knIXk4tm7LGviK2IocRvbNgPWMFLDp7wohincT4tlDHjCODlGiNeGw2RiWqhlje3mOnmyhortnxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rGYOArWL; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rGYOArWL"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-297e5a18652so13282415ad.1
        for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2025 10:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763059925; x=1763664725; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cIVgrZy+vZcCrxI7QYJ8hXcnFmjFjPoiu79u6DzwfMA=;
        b=rGYOArWLBoU/z7s2/0AFUplNEZJlfgGZoFD0CPngpcrsVtURCpOHU5T8W1uWSDnD72
         i3QCs2ESzUzudtmienyD0J/nc2O1Hr2cBHB8R/hFhTOKyDmFrcJz4uT5vPE0DXjGAXSB
         wREraRFWzCZDCHB+BPFQ4rFo/+DXMm8tsocoX0sGhLP417QhH+NWf2oY46zCW2m7HX5C
         tLqjkfLLECu3yBngKAbDa5img1EVRvDarrs64s5HBy+qaqWDDv7hNdTDBAzmDOwJ8c4z
         zWp3HwaXx0wecl8fQRwf8zp0yjLf3nRFP4hOjSCUfXD+C5wvSD+gx6itbQTBKAnirHdH
         kcGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763059925; x=1763664725;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cIVgrZy+vZcCrxI7QYJ8hXcnFmjFjPoiu79u6DzwfMA=;
        b=txOyIpT7BjaoC07DQCp12ovwor7aqiQ7fRfpj7ZvWm537y9VWZjDzsOm40/NE1oJnQ
         7HsvQ6V+z9IoB45PmMtPPomy9iqUbMq23Gvvuv0fDvfZ4f/CDwSfZFc0ITQeo812I5FJ
         cw1407A9uhPW0jchBRsYclvm1oK3k/89zufdTfqJruzJnGh2LjX5Pn5PmXjmPNobuc+B
         gxH4EEtWcRVCR94DAmajolQySluBC9OI8/MoSDnV5EOlhGDKnKFfGLUeAedWlRnlqdOu
         acPU6npkIfK1ZpgcJFtNI0AGuIN+ZFG4FI8KmzSWX1fMLUSRwzYvzpE9e3A+ugSrw8FB
         H/pg==
X-Forwarded-Encrypted: i=1; AJvYcCUzHLO2G7RtUUgAgGWaTrMYGYtGStYkqOTJIhNgLjJL2X+GsEghOOVLvg2MGAoztlACaJ5rwzZAVLEvhJs=@vger.kernel.org
X-Gm-Message-State: AOJu0YznK+iPW956WzbysOIkxojxwUbAHXc1PlrSZUJmWFXLdBO1KyFv
	PFgVwkiuQ5t5yCS++35YpcSItf+ZnxgyXWs0X78dzh1p6d0PBxeBQfTKubBoQOVgfSPvtdQ0FAv
	EYRgF/g==
X-Google-Smtp-Source: AGHT+IELLdvnYt/gi3DBJs5U+itYxHk4SoCPsQR2iLQbi7s7Ha6OS3ZSPCJ4OFt28AA30gan8pj0zZ6ieKk=
X-Received: from plbkp5.prod.google.com ([2002:a17:903:2805:b0:297:fd8b:fe1e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ecc7:b0:297:db6a:a82f
 with SMTP id d9443c01a7336-2986a6d27fcmr422445ad.24.1763059924664; Thu, 13
 Nov 2025 10:52:04 -0800 (PST)
Date: Thu, 13 Nov 2025 10:52:03 -0800
In-Reply-To: <e3f711366ddc22e3dd215c987fd2e28dc1c07f54.1761593632.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1761593631.git.thomas.lendacky@amd.com> <e3f711366ddc22e3dd215c987fd2e28dc1c07f54.1761593632.git.thomas.lendacky@amd.com>
Message-ID: <aRYo05KMsaNdj59U@google.com>
Subject: Re: [PATCH v4 2/4] crypto: ccp - Add an API to return the supported
 SEV-SNP policy bits
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
> Supported policy bits are dependent on the level of SEV firmware that is
> currently running. Create an API to return the supported policy bits for
> the current level of firmware.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---

...

> @@ -1014,6 +1031,7 @@ void *snp_alloc_firmware_page(gfp_t mask);
>  void snp_free_firmware_page(void *addr);
>  void sev_platform_shutdown(void);
>  bool sev_is_snp_ciphertext_hiding_supported(void);
> +u64 sev_get_snp_policy_bits(void);
>  
>  #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>  
> @@ -1052,6 +1070,8 @@ static inline void sev_platform_shutdown(void) { }
>  
>  static inline bool sev_is_snp_ciphertext_hiding_supported(void) { return false; }
>  
> +static inline u64 sev_get_snp_policy_bits(void) { return 0; }

As called out in the RFC[*], this stub is unnecesary.

[*] https://lore.kernel.org/all/aMHP5EO-ucJGdHXz@google.com
