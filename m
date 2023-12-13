Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ds77uMCZ"
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C700C9
	for <linux-crypto@vger.kernel.org>; Wed, 13 Dec 2023 09:30:15 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-dbcbd789ddcso991203276.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Dec 2023 09:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702488614; x=1703093414; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x/vSOPRW34ZBEoGLP7AobDWeoYbZlEIfUFdS/cfIhTI=;
        b=Ds77uMCZO06Sm/Op4a+nRPTn6rNaHRN4vaW+cgznbepoCcsSccoc+EpJjp6IjjeV/u
         pWqIz0vUwjf7SqRZLRCIXe0vR15q3OMaX942nA4fxDWbfvkLZyndjHENxf1urnDf2hr6
         m2aJ3VqwIYMvU1+QIK5hcisvNEfSWn+FaU7YqaLBMpExArBt8mkrinYqdHwPJpfE8mTm
         5mqL5ice6P6HJJWOB75OzUvo3dFZQKkvgWM9sTuqmMAC0IYcj2S490kxNDtOloGfTNQe
         38SRnPPNN9bgC7VwaYD29gh6oIuIfGtDmGLtFT4RxVs27WVso2RAuMYx91gZ6C6KWWZP
         jLcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702488614; x=1703093414;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x/vSOPRW34ZBEoGLP7AobDWeoYbZlEIfUFdS/cfIhTI=;
        b=GLc4RskYmfk5FWKFJ/O8vvYP82bxr5J9eRPbxGm+zmxOEnoBKYFoW6dgfiStfU6Nvp
         PiO721YRCbEe+BpRl0vQtjZHr7XRoHJU+r+q05PPQh8aEBI1J7h2X4xWRq5kwem6/Qo5
         ZA1+NoFjUF/L53M8bFHGeMlUdaDysOAjE26PrWzByzY7kdkASQXOI380++yklR+xSuMf
         lw31Gxe193Ga1QvKiuKrPrb3FxLRHxP8R/0eZwU/EwBqlRcLf7wPQxR4NTGS2DHuep6E
         /zmbo9yVGWjWMB8NK80T0LGJ1Z1MkUHZpzTPtS24crulGBibg+sEF0/QVixFcypI50oP
         HT0A==
X-Gm-Message-State: AOJu0YwQZPt/DrcCoNFYFB2Zdb0gT83HbYnHNIL7CG7ttRK6yBjAuHeJ
	TWxo5SEeXusKPRHJTklFO8/SgxkSk60=
X-Google-Smtp-Source: AGHT+IFOP09PwT6lqIkFRJAMnbtTHRKLbaBMtetikxZWuMnGPaXYka0H53M769c+RQXX26fiZIa7/SXOFXE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1812:b0:dbc:cc25:8ab with SMTP id
 cf18-20020a056902181200b00dbccc2508abmr23845ybb.4.1702488614570; Wed, 13 Dec
 2023 09:30:14 -0800 (PST)
Date: Wed, 13 Dec 2023 09:30:12 -0800
In-Reply-To: <e094dc8b-6758-4dd8-89a5-8aab05b2626b@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-4-michael.roth@amd.com> <e094dc8b-6758-4dd8-89a5-8aab05b2626b@redhat.com>
Message-ID: <ZXnqJMKD6lO6a0oq@google.com>
Subject: Re: [PATCH v10 03/50] KVM: SEV: Do not intercept accesses to
 MSR_IA32_XSS for SEV-ES guests
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com, 
	alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com, 
	nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com, 
	zhi.a.wang@intel.com, Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 13, 2023, Paolo Bonzini wrote:
> On 10/16/23 15:27, Michael Roth wrote:
> > Address this by disabling intercepts of MSR_IA32_XSS for SEV-ES guests
> > if the host/guest configuration allows it. If the host/guest
> > configuration doesn't allow for MSR_IA32_XSS, leave it intercepted so
> > that it can be caught by the existing checks in
> > kvm_{set,get}_msr_common() if the guest still attempts to access it.
> 
> This is wrong, because it allows the guest to do untrapped writes to
> MSR_IA32_XSS and therefore (via XRSTORS) to MSRs that the host might not
> save or restore.
> 
> If the processor cannot let the host validate writes to MSR_IA32_XSS,
> KVM simply cannot expose XSAVES to SEV-ES (and SEV-SNP) guests.
> 
> Because SVM doesn't provide a way to disable just XSAVES in the guest,
> all that KVM can do is keep on trapping MSR_IA32_XSS (which the guest
> shouldn't read or write to).  In other words the crash on accesses to
> MSR_IA32_XSS is not a bug but a feature (of the hypervisor, that
> wants/needs to protect itself just as much as the guest wants to).
> 
> The bug is that there is no API to tell userspace "do not enable this
> and that CPUID for SEV guests", there is only the extremely limited
> KVM_GET_SUPPORTED_CPUID system ioctl.
> 
> For now, all we can do is document our wishes, with which userspace had
> better comply.  Please send a patch to QEMU that makes it obey.

Discussed this early today with Paolo at PUCK and pointed out that (a) the CPU
context switches the underlying state, (b) SVM doesn't allow intercepting *just*
XSAVES, and (c) SNP's AP creation can bypass XSS interception.

So while we all (all == KVM folks) agree that this is rather terrifying, e.g.
gives KVM zero option if there is a hardware issue, it's "fine" to let the guest
use XSAVES/XSS.

See also https://lore.kernel.org/all/ZUQvNIE9iU5TqJfw@google.com
