Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E173929C340
	for <linux-crypto@vger.kernel.org>; Fri, 11 Apr 2025 21:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744407659; cv=none; b=L+VT03zeN+w+Jzx7LTpXDPBgvV861wkNNv7auImGvbWOSFlquDerQEB96OK1g4f1d/z6dLOHbMEbAYjeMQRV2lB2DuxlpGlIInUpqzg8MDLvtiez7KJe0IOQwIuZDxiwgPDf0xuIaJOVF/76Fjd8rFoL88eUaReHkMy8YCVobBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744407659; c=relaxed/simple;
	bh=1BkJGKhwVjhfDp/1cIUTZf7wwpOn8aY9NXN7o8UXgD8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R9kqzkkcVJOT6ifyGBSfvTgG2243w9q0onH39w1HXUSNquG6Hqq6oZpOA2KG71eQtdJSs0MxntLTVUrV0XwuciOBbQD68GsRZt+cWuCMmOdGWxGXFy1xjTM36WNGzCZgwsHMGshdrpRer6IEGq48D/KSudPzBhioQ/9NojbIdVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1XqtH/nq; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1XqtH/nq"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7375e2642b4so1802960b3a.2
        for <linux-crypto@vger.kernel.org>; Fri, 11 Apr 2025 14:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744407657; x=1745012457; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t9FKI0EnGL+ITiUEghed0r99tXKZdQe5KG58x8/Jte0=;
        b=1XqtH/nqxMaMfrRLY2sOlIZBo+3Oil3IVhEkhj+242S9RoZmTG2kkK9DKME29jea5S
         YsIN8XtVT2BKmAK27ETgtcmgazUfR3Fsqyavlck901AbZeKXwes4FbebVerFeNGOfwkp
         WMGZjQSI+ZKeRg+1x1WTFo8DU7A4iSH8RwbV1XG4dZ72IQgG73B++l/LGOGBKI10BMst
         q6KWTOF+RZEbyCs3X/Cpl+FYZGM6Ld0fq7u3q0OOWUljLvUYdz/byiewUrPdxm6xZHRy
         kO28eIXlDd0TTSX/UWNCskRQosbxinwuSJffwrZN+zrWC9x4Pdr1mHKHWL9IEesWqWyA
         bq8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744407657; x=1745012457;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t9FKI0EnGL+ITiUEghed0r99tXKZdQe5KG58x8/Jte0=;
        b=gsq4JkB15evBryotaD8cEIr987u37HvvvKwIepjgNl8DtTGOA4ZvqD7a/giRSOnFRi
         WlpTkM4mJM5ztZ99QpiXI4x8tmwLQv3DDiW5kOURGSe70skkChdBpNVgfjtloFyI8546
         Nf08C3B+RSbAYFLPtZBqCUo/cIjkzarK5qmD4D1h66yxQO4TZtng8cISI9KsAqKTO8DM
         M8cZ8F7smO8Qsvk8Wx5LOfLkIV22KiLp1J0v8o4+eoiz/hNDjmumUvEdAIYIphAGLNC8
         0KPEfUxpRaw0KF+AJZ2qVWbTrLQpPutD1u4NamoQmEa+pIVK4+h3PPy+NvYj4gHUar56
         seVg==
X-Forwarded-Encrypted: i=1; AJvYcCWrRHUxkUq+BxRoWoehx8P5/rTeHfjvhAI13Eaa4uShFvdw3Tx/o3RIMFyES4NLl0WMutDEubzcK0DrmSY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzsy+oysjvluqvOeVR972q8gsWBj30g9fdlpdQLp19W1GLmq5XO
	dxZmthAbmdUG3hyWdu2sBuFZmrVkX13OjI5iAarb/amagyVp33fDysN5Nt2337ecu0CXIGVyp1R
	RDA==
X-Google-Smtp-Source: AGHT+IHlHwSyxV0LTUHRGhNseRoHCYNIY6ncZEyXAVZHr/jzCGvSjE4K7i+J2dif5I4fTGdH0/RJAkcUZUM=
X-Received: from pfbeh4.prod.google.com ([2002:a05:6a00:8084:b0:730:7a22:c567])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4644:b0:736:9e40:13b1
 with SMTP id d2e1a72fcca58-73bd12b1315mr5481503b3a.23.1744407657218; Fri, 11
 Apr 2025 14:40:57 -0700 (PDT)
Date: Fri, 11 Apr 2025 14:40:56 -0700
In-Reply-To: <20250410204149.2576104-10-ross.philipson@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250410204149.2576104-1-ross.philipson@oracle.com> <20250410204149.2576104-10-ross.philipson@oracle.com>
Message-ID: <Z_mMaAykU0IVKsjU@google.com>
Subject: Re: [PATCH v13 09/19] x86: Secure Launch kernel early boot stub
From: Sean Christopherson <seanjc@google.com>
To: Ross Philipson <ross.philipson@oracle.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	linux-integrity@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-crypto@vger.kernel.org, kexec@lists.infradead.org, 
	linux-efi@vger.kernel.org, iommu@lists.linux.dev, 
	dpsmith@apertussolutions.com, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, hpa@zytor.com, dave.hansen@linux.intel.com, ardb@kernel.org, 
	mjg59@srcf.ucam.org, James.Bottomley@hansenpartnership.com, peterhuewe@gmx.de, 
	jarkko@kernel.org, jgg@ziepe.ca, luto@amacapital.net, nivedita@alum.mit.edu, 
	herbert@gondor.apana.org.au, davem@davemloft.net, corbet@lwn.net, 
	ebiederm@xmission.com, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	kanth.ghatraju@oracle.com, andrew.cooper3@citrix.com, 
	trenchboot-devel@googlegroups.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 10, 2025, Ross Philipson wrote:
> +	/*
> +	 * Get a pointer to the monitor location on this APs stack to test below
> +	 * after mwait returns. Currently %esp points to just past the pushed APIC
> +	 * ID value.
> +	 */
> +	movl	%esp, %eax
> +	subl	$(TXT_BOOT_STACK_SIZE - 4), %eax
> +	movl	$0, (%eax)
> +
> +	/* Clear ecx/edx so no invalid extensions or hints are passed to monitor */
> +	xorl	%ecx, %ecx
> +	xorl	%edx, %edx
> +
> +	/*
> +	 * Arm the monitor and wait for it to be poked by he SMP bringup code. The mwait

s/he/the

> +	 * instruction can return for a number of reasons. Test to see if it returned
> +	 * because the monitor was written to.
> +	 */
> +	monitor
> +
> +1:
> +	mfence
> +	mwait
> +	movl	(%eax), %edx

Why load the value into EDX?  At a glance, the value is never consumed.

> +	testl	%edx, %edx
> +	jz	1b

This usage of MONITOR/MWAIT is flawed.  The monitor needs to be re-armed in each
loop, otherwise mwait will be a glorified nop.

More importantly, the exit condition needs to be checked before monitor, even on
the first iteration.  In the (probably extremely unlikely) scenario that the write
to wake the CPU arrives before MONITOR is executed, this CPU may get stuck waiting
indefinitely.

E.g. something like:


1:
	monitor
	cmpl	(%eax), 0
	jnz	2f
	mwait
	jmp	1b
2:
