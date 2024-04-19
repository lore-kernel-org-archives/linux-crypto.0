Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05B77EF0A
	for <linux-crypto@vger.kernel.org>; Fri, 19 Apr 2024 12:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713528106; cv=none; b=SDPa9SRhJ1rfGyCtCHJYUuGNACENocetXshh+vmcc34MU/3JDGM4T3h/IhZabXSdwdnsuNbQ2LUp8PAh9Uo9NaNNOmlv1LvrnkN051xyWV9dTaiugLRxBnI29YFVDPX0PkyIZ6jvuwXTDeXEta4l1XQ7SwRK9qOCKICvFkEDuAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713528106; c=relaxed/simple;
	bh=acN4eXWZt8iLvqysCB2S2Dc6auK2r1UT70yxAxadgbw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hBiVTUVek1ugXqfCM9i71Fy6SrDzsYsYuFAkD5FnK7kHW2HtWPzNu/4xUNCvs1/rJTnGj603AorftnDuF2ibJvNOXM5rbpm2zyw6TXZ1miAsOjVNAz88NwvDCcsp1Cbtjq2T8D7ywA4j/oPqVCNTb56W136SG1F8ckQYEgLko9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Akw+r+IT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Akw+r+IT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713528104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vahs511qBysOkO0uiEmPvdJfNTUFHsURAvS7DcBv8xY=;
	b=Akw+r+ITtB6jgATaNf+mskwcKMUt3m4QXf/7JL+1hd09iQ5PHq5rQXrX7dnOXhSuRl3mFj
	/aIHEa/JxbuZfgCKM4urVzCW5K1QcHziyzYv1fpSx/jxey70qhHOQj8AlWanPXL3sgf7M1
	VNlofBOtP56Y9kWFuTP0tWPDr72JY70=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-172-R3QzBV_sNPOe4dUEeSyjMA-1; Fri, 19 Apr 2024 08:01:42 -0400
X-MC-Unique: R3QzBV_sNPOe4dUEeSyjMA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-418f6585034so6524105e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 19 Apr 2024 05:01:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713528101; x=1714132901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vahs511qBysOkO0uiEmPvdJfNTUFHsURAvS7DcBv8xY=;
        b=weYETloNJxQh6xnZvDZpJnDG6xEGUVEE5Enfq10KLUrO7YHWxpbwIAyHoTv1EOAWsC
         c700Q8ib2m99yBO99ZB++/PiklB2S0/uz4Vc22LQYbZwbk0OAKZWKSZPPl+Os7DXmsTM
         tbbr/H/Qo1i956jOyoq7+xHOjao6HG2gYUOfCNMfUIyk1bb6wlf42Ha7OTaOvA2+TCvo
         BO1+C7tNpGcQwBtr9SJ/C/iQj15oZCIIBMVGl+b12YpqrRKAp85cveo+rcmpFuqyVe4v
         cXKo/S1iiVwTrH2t3deXCaU/bgYTQI7rROXIYYSBRnlwv/gewfE/ALBzKTYlN659271c
         4MAA==
X-Forwarded-Encrypted: i=1; AJvYcCUZntikwGJQMWZxVXDQcJob8GPp/AvYHc7FHK4nstvrrY5rO2JlqHseyVnPR5wCbtqSOsjr/gyZuJzWl4x5DoxbJgavUxaWhXb+aeTe
X-Gm-Message-State: AOJu0YzKY/T4Hv3fsi7u/1W7QPoC9L/EV4HUxWcZFW6HGcBHGdT1tGc/
	VXHgawlMDLLbAih8ca3Df/67YCkBnl2mURHI6jrezbO6UsD2KBw4E4miGAeCnvG9BPv2zUuhtkI
	S8XBYa9xfNDgW0fPBns1POxHAyUqfOHEIU/rrjC5Osev/sa0UmnBf01XqS3ZZua91LQP5IAqNU8
	+JR/poycHV/mN206H4M3bfARzFYtFceM7F/7Lw
X-Received: by 2002:a05:600c:45cd:b0:418:9ba3:ee76 with SMTP id s13-20020a05600c45cd00b004189ba3ee76mr1378070wmo.4.1713528101569;
        Fri, 19 Apr 2024 05:01:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEaFUZhMFYFAs3ZhsYYcBoV+2/MzoyjDzM+1t4+goj9WAVZ/2QAmnhBwnZ/PquJCML4YzG+HJVNxiJvWhvW6sY=
X-Received: by 2002:a05:600c:45cd:b0:418:9ba3:ee76 with SMTP id
 s13-20020a05600c45cd00b004189ba3ee76mr1378024wmo.4.1713528101121; Fri, 19 Apr
 2024 05:01:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418194133.1452059-1-michael.roth@amd.com> <20240418194133.1452059-17-michael.roth@amd.com>
In-Reply-To: <20240418194133.1452059-17-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 19 Apr 2024 14:01:29 +0200
Message-ID: <CABgObfYzM4tsoYtVdACtbY4ZXs4j2hrsVEafD9=EnqnXjoJ+2Q@mail.gmail.com>
Subject: Re: [PATCH v13 16/26] KVM: SEV: Support SEV-SNP AP Creation NAE event
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, 
	Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 18, 2024 at 9:45=E2=80=AFPM Michael Roth <michael.roth@amd.com>=
 wrote:
>          * the VMSA will be NULL if this vCPU is the destination for intr=
ahost
>          * migration, and will be copied later.
>          */
> -       if (svm->sev_es.vmsa)
> +       if (!svm->sev_es.snp_has_guest_vmsa)
>                 svm->vmcb->control.vmsa_pa =3D __pa(svm->sev_es.vmsa);
>
>         /* Can't intercept CR register access, HV can't modify CR registe=
rs */

This needs to be svm->sev_es.vmsa && ... (see existing comment above the "i=
f").

Paolo

