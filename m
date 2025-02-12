Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEED61487DD
	for <linux-crypto@vger.kernel.org>; Wed, 12 Feb 2025 01:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739325559; cv=none; b=VzpGkk0mMzoVimU2jtz6R7mbsuLUpK/KokJESXpmWs3BKDBBcCAgCKY4vlmi0GtDshchgrRuwYnsULRwokE9+Mzfg4DVj3/GQza+F0h2zLlWJePnToATPpczgrJ8lkFmIG3gJ7LzEg/2AWlTYwh46U+ZFHmm53cJQ4M2aK0/cy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739325559; c=relaxed/simple;
	bh=8plav0HWTt+1h9QiCkNdNPq1o+Y+AMAFq2hfN8tZSs8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uFzGt3QCWzfNvXzeQAqC2jKcMYDaBTY2znmvuLl5tTN+T2XSN2dOBHJSdPrPPii3RAHtl6puh7SOVeqmCRe5xg+smIboUHywCv/SG51p4MVOcPYMiaVkLMcuV/8D7u/X1GOaho1oAq9Jm27Laak7p0gZIPsFx9CHwyXZeTOeNZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vlExsrIx; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vlExsrIx"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa166cf656so11798189a91.2
        for <linux-crypto@vger.kernel.org>; Tue, 11 Feb 2025 17:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739325555; x=1739930355; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5TmAA7lrYyzPK7RPMr80QZDXqtaYCD1a8crOBimpM0Y=;
        b=vlExsrIxEZEHfUvcBMDMBuSIUS84rCdt5tgck0XWeP5fT1rJXN6W4aIFWgxaUc0HVV
         3U1c01nUZLMbTp6vhOuN1JirigMQxO/8MO68xZFck6rB3k4GGiMJBSWjZrfB65l3Cn/J
         BkhT0QLKFHLN3/BLjvWvEF3yjs+zVlcMLAPLDD6D4o+6ZroiXI+uofTjewvFZuniZGdd
         wN5W9mNzjvatxLtLDIwYONoDiViIqq/PC7m6YYkc5BD2ND/R8ewTABLzvK1x3V52RGTt
         yiyRpaM8Hv3EFtizbHz0ol0SssVJzdHASqBarhGcfnuqbyJZIFdh3aQb5VfiRuIiUYa1
         ydqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739325555; x=1739930355;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5TmAA7lrYyzPK7RPMr80QZDXqtaYCD1a8crOBimpM0Y=;
        b=ouzwwsB+EaexJEONH0DZxavkUy6fE4uF07ucgZofHtMGGcBYrPx1GsNSFNijU+fMhC
         GVPTlNXbsMWNPMFCbUEaMy2PouuNoh1FDf/hn0tKCrPMgzjjLujG5NxmKCrTp2EgnPcl
         ka9hqReQ+I9JP/Ey7Zhb4wSH3UJV7C7HWOPcgAhRJs2AnxrIsVweb55Z867z05wr2NxK
         qNf+62IA52lSsyL3c4vLyWVCuNqx8zRDb1icBfhCUh6Ymms1KaRmuuM1jZ8C/bBHvABl
         zxolffmXpWLWwhoQleaoHzsQ5q0AihVwjJDcChQMMxuWYxET8NLqcdTMjdH5t2TqGs/L
         yqGw==
X-Forwarded-Encrypted: i=1; AJvYcCUgJAQXQyNFNlXHXR1Dko/2kQzYAKqcBY6Pc0bXDTBLKIa0BEAs15DmDhz6LRKmBlTad0hOl1awJbaroE0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGqd2EiK738ophg6RyPdkZ2t1oTBLhCrqMfOYUZok2vZDfk0x+
	NPpTHDEnkGH4xBI95dXln5uIx6FTAPDVbS9wr8He5Qysn3uq4HEtBkcfYSZ+nvgNjZMOEuWGdA2
	JwA==
X-Google-Smtp-Source: AGHT+IGNXFHUFBAGO7+23DHP+xbhUNfnPfHgeiFc0IIY5LE7qIIGAVhpnh4dGAbimBx/4hI7qfnSlyKuElk=
X-Received: from pjbpq16.prod.google.com ([2002:a17:90b:3d90:b0:2e9:38ea:ca0f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:53cf:b0:2ee:ab29:1a57
 with SMTP id 98e67ed59e1d1-2fbf5bb8fb4mr2372898a91.2.1739325555495; Tue, 11
 Feb 2025 17:59:15 -0800 (PST)
Date: Tue, 11 Feb 2025 17:59:14 -0800
In-Reply-To: <20250203223205.36121-5-prsampat@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250203223205.36121-1-prsampat@amd.com> <20250203223205.36121-5-prsampat@amd.com>
Message-ID: <Z6wAclXklofHtY__@google.com>
Subject: Re: [PATCH v6 4/9] KVM: selftests: Add VMGEXIT helper
From: Sean Christopherson <seanjc@google.com>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	pbonzini@redhat.com, thomas.lendacky@amd.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, shuah@kernel.org, 
	pgonda@google.com, ashish.kalra@amd.com, nikunj@amd.com, pankaj.gupta@amd.com, 
	michael.roth@amd.com, sraithal@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 03, 2025, Pratik R. Sampat wrote:
> Abstract rep vmmcall coded into the VMGEXIT helper for the sev
> library.
> 
> No functional change intended.
> 
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
> Tested-by: Srikanth Aithal <sraithal@amd.com>
> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
> ---
> v5..v6:
> 
> * Collected tags from Pankaj and Srikanth.
> ---
>  tools/testing/selftests/kvm/include/x86/sev.h    | 2 ++
>  tools/testing/selftests/kvm/x86/sev_smoke_test.c | 2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86/sev.h b/tools/testing/selftests/kvm/include/x86/sev.h
> index 82c11c81a956..e7df5d0987f6 100644
> --- a/tools/testing/selftests/kvm/include/x86/sev.h
> +++ b/tools/testing/selftests/kvm/include/x86/sev.h
> @@ -27,6 +27,8 @@ enum sev_guest_state {
>  
>  #define GHCB_MSR_TERM_REQ	0x100
>  
> +#define VMGEXIT()		{ __asm__ __volatile__("rep; vmmcall"); }

Please make this a proper inline function, there's no reason to use a macro.
