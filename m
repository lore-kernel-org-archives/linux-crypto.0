Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F05E1EB30
	for <linux-crypto@vger.kernel.org>; Wed, 24 Apr 2024 20:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713990114; cv=none; b=kpb3Kquz8uODrgz0seXN0oqqYnuikFlU8BHzCuWuIxobZ9XIVt5tV5t53JNFSzUjEab1aVjq6l0VYnNsUDGc8KHF2F3xWfgGHPybfCAaqHHibT+6eR2N2BI5KyA3M5r81sd/CCibzSEHRkNOvgzF6L2z+NsMkJX+ZcdcdNFQLtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713990114; c=relaxed/simple;
	bh=TGEtv5XOiits4mamBa9OAfqfGV4U4S70ayjHE1cLPf0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hdj6Cev2R2oNkgBYgx1qHkxug4Twm0zrlEpIebc2auxzo4IAhbdSi/byXeHfX+9S9v2/zujubSM6QtKX43THqOOympN13CoDk8kS9PyO56udUND6Qknv9ZV8w2tJJNd1RAl0MiBCvdEiMnfYSf8zvEToNPdMo33aBM2gaLGmBRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LJWhaOBS; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LJWhaOBS"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61b4ede655aso4163337b3.0
        for <linux-crypto@vger.kernel.org>; Wed, 24 Apr 2024 13:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713990111; x=1714594911; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kJKivmW0J/DCohVbY4PLH/Gsm5HkrpKk4PumvPQkGTk=;
        b=LJWhaOBS23+m4cbeffQxfBi2+LhQiaxH0g4aN0wnbucjwJjOE43th6w3x5Kshx4k/1
         ksdbN/ffqddNeAOLSEXHRP0jRaxbX7Mq5pLjMASW7l7reMdVrUCcm+1JmbqVCFgWqa6p
         9ypcuIzdQkWkyknbyeg6yjMPyGOoNk4dhRDK7Z1TCPMrFznKIsUS0C4Bczwd6AiKEm2L
         /XNvlN3itMS4rlQRGCrMoJhRQ/mlJsBw/sgDL59KZ4FEC+zL/5qTDiNpzkah+Emu0cp8
         XPFettXTUNO68E+4Yu30UQGHJvKxs/khMkvXnaALWx8vrx+nPO029a34YdOxWqbOF1ey
         GfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713990111; x=1714594911;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kJKivmW0J/DCohVbY4PLH/Gsm5HkrpKk4PumvPQkGTk=;
        b=ctncIiBgrpG2tkpixNCQP1mH8nQkUi+cECebFFYBXKGfB+c4xXPr0Ndl5b1zZMYvCa
         5rPkun+2/ezT44jW2yi3Ee1ds+W0y4OUGj2piWd4JqYEvuFHMizFdvYPhgd0Niz2yaa/
         wwLYxmIpu7iaj3kT6yyPhAnM9yjDYSxvu1YeEKnEEX7/pHQNJRePjqcN0LtOu3oRw8pq
         m8MEdsxXggP8cMGn/IO/q6FpyecO/vmKuxfXwB97yrSbSFKfvLrAAkcBjc9XfTWwlZnh
         cfzD+s8ivXsPXt//yeobUaMGmawKbLsZHHbHyNllMA2KSxcFJUlxfgcHwlVmJaWZi8rk
         2W1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUonNOZpyJLqxcXpY+iXlyOFYijwH8/2xgAe8mXMbKBoETBPDrBJRMHHEk0yn3p+pGfnigD+BXJm0ji79OiayS53KoBkoz4j7Gogqxg
X-Gm-Message-State: AOJu0YzK/gY0kADN3Pd3yqUH5fnrO1n7Q6w7joEp4ndvrBC31hz6UThv
	rBlJcZeaGy9O4uguAXeUvYDQFm9dEUrJdJSxpMBaRzk3j/JorVPWGD88UjrEtgwznJKgw5qH+Zf
	H3w==
X-Google-Smtp-Source: AGHT+IET29Be+TqLLxR1el2WX7B1TltJHuVLHw4XBc2UEobX1IG760KHrKW5Mr9mGqY0ZbBfjntc+5CKv7o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c54c:0:b0:de1:d49:7ff6 with SMTP id
 v73-20020a25c54c000000b00de10d497ff6mr385878ybe.7.1713990111258; Wed, 24 Apr
 2024 13:21:51 -0700 (PDT)
Date: Wed, 24 Apr 2024 13:21:49 -0700
In-Reply-To: <20240421180122.1650812-4-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240421180122.1650812-1-michael.roth@amd.com> <20240421180122.1650812-4-michael.roth@amd.com>
Message-ID: <Zilp3Sp5S-sljoQE@google.com>
Subject: Re: [PATCH v14 03/22] KVM: SEV: Add GHCB handling for Hypervisor
 Feature Support requests
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
	pankaj.gupta@amd.com, liam.merwick@oracle.com, 
	Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Sun, Apr 21, 2024, Michael Roth wrote:
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 6e31cb408dd8..1d2264e93afe 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -33,9 +33,11 @@
>  #include "cpuid.h"
>  #include "trace.h"
>  
> -#define GHCB_VERSION_MAX	1ULL
> +#define GHCB_VERSION_MAX	2ULL
>  #define GHCB_VERSION_MIN	1ULL

This needs a userspace control.  Being unable to limit the GHCB version advertised
to the guest is going to break live migration of SEV-ES VMs, e.g. if a pool of
hosts has some kernels running this flavor of KVM, and some hosts running an
older KVM that doesn't support v2.
