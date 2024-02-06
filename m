Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDBC1CF8B
	for <linux-crypto@vger.kernel.org>; Tue,  6 Feb 2024 23:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707263522; cv=none; b=D/fG0E9WBfjBj0a2cBtpVyVjLgAYEQByr4Hbsm4f8TnXKfbf6CvJHynw1Ymv5YtFdodLX1ZOv3gX9pHNIx6HDyxSY9eq2brK+aAhN9oxRNXB+YXqml+XFk0GflCbagTTxCbd8VA2f7OJKHTUZvawAs2TuntCFwyqmwuHrsKMg4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707263522; c=relaxed/simple;
	bh=ve66283HQWjoTIfCCyXOJ53dpz5pgvyRfthFOrG2wSQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TnKeG201wNjVis+DCYz7Wrh39Wt+6IryteA3p44M76Z8SwbqaysBdHNAQhsjoc650lelhAjNBGapBk2HGerAq6kcisXsAFAGgFWB2vAU0n32Lfl4MN4TNGXr+PVl9gwk9tRiu2Z9ERp2YIkPwyCUrokmkYPP/34cn706fAEPCYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fels2s3I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fels2s3I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707263519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QlaMHMv+OFsz29LUU+CREUFzhlwBZ5CupOOm81GfonI=;
	b=fels2s3IuSxeSTU0T1hhpedDNZri0VY5q4h8xVz36HJgxtjdNUWCw5/tp6GvyaYiEe4+AY
	BjYVVSEgV16IjWuescU2tlfpHz9qrAhwtCYmz+rMMkPr0JLNE3eQstlzVX16jruBBIgD3R
	BqOHb00jFRULkYfrz4tx9+MO8unakes=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-4xGAveEmPaS4wtCM3OvurA-1; Tue, 06 Feb 2024 18:51:58 -0500
X-MC-Unique: 4xGAveEmPaS4wtCM3OvurA-1
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-46d26e4118dso4906137.0
        for <linux-crypto@vger.kernel.org>; Tue, 06 Feb 2024 15:51:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707263518; x=1707868318;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QlaMHMv+OFsz29LUU+CREUFzhlwBZ5CupOOm81GfonI=;
        b=LQ1oFHz87XyAX7TtS1rD/sL/YZ7QfzLRWI6irfJltJLIPRYGz2mx2dRqfHgw+YoYsr
         v5Oj0q8aKF73I/JOI6Ua6P5mLrasbgXgkNy5mPnW11VkD2UvqQMSjgSxdWNdFfP/4afo
         OU/Qy7/EyUqYcR/TCJqQq/cV9JRaKj+PqBgSn7BiDp2Swzm5nZ359AKEdK12AHFXzwZh
         24Rp+yKllxzRdX9uXVck5MDHAk4AXiFTNlSKqNZSEHy5v5JAPrLSxIC53wAsaXBSgdQl
         yGMCmrS3GDzNAKDGNpEQlZbxXdK4FKaI1eelheSJ8yVngvfZdqSwo9q3U7vr+ZS00Vnh
         3MSg==
X-Gm-Message-State: AOJu0YzMjnCfJhht7jtpR7q9CRwK/FieIBWvvbpYfk+B7xfZoi7EzDJu
	yFI6BnVSC1bkdaQC/IRb8EI+HjPZmSH9krTnR2RD+K3HCVgRumbDHqMZ6XQG3rgKJvwuSinv2ve
	Zj/4JkK/CQIDkVSebg+bIBXZGpG8lr2Cyhvu7R6xVC5t0WEu1SothcOMLCiIERqWp2txxTCw2Eq
	AceyDhqw33o/NYoBKQdopZpxX+Ln1BwBZ8UZdb
X-Received: by 2002:a05:6102:cf:b0:46c:fd63:bde1 with SMTP id u15-20020a05610200cf00b0046cfd63bde1mr1286412vsp.19.1707263518113;
        Tue, 06 Feb 2024 15:51:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF70k2IB6sfXGMG5DxBsPeJSyX4Z7lyvMyz2eIY0biSnZnIU+nH0ONxsk7eIwQOzejVn484uJrg8s77iTZynRo=
X-Received: by 2002:a05:6102:cf:b0:46c:fd63:bde1 with SMTP id
 u15-20020a05610200cf00b0046cfd63bde1mr1286379vsp.19.1707263517863; Tue, 06
 Feb 2024 15:51:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231230172351.574091-1-michael.roth@amd.com> <20231230172351.574091-16-michael.roth@amd.com>
In-Reply-To: <20231230172351.574091-16-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 7 Feb 2024 00:51:46 +0100
Message-ID: <CABgObfYDeUWMT03=yjvKG5J2GHYc9M7+A4+oY22gpqMCk1eQBg@mail.gmail.com>
Subject: Re: [PATCH v11 15/35] KVM: SEV: Add KVM_SNP_INIT command
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
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com, 
	Brijesh Singh <brijesh.singh@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 30, 2023 at 6:26=E2=80=AFPM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> The KVM_SNP_INIT command is used by the hypervisor to initialize the
> SEV-SNP platform context. In a typical workflow, this command should be
> the first command issued. When creating SEV-SNP guest, the VMM must use
> this command instead of the KVM_SEV_INIT or KVM_SEV_ES_INIT.
>
> The flags value must be zero, it will be extended in future SNP support
> to communicate the optional features (such as restricted INT injection
> etc).

We have a (preexisting) problem in that KVM_SEV_INIT and
KVM_SEV_ES_INIT are not flexible enough. debug_swap has broken
measurements of the VMSA because it changed the contents of the VMSA
under userspace's feet, therefore VMSA features need to be passed into
the API somehow. It's preexisting but we need to fix it before the new
KVM_SNP_INIT API makes it worse.

I have started prototyping a change to move SEV-ES/SEV-SNP to
KVM_CREATE_VM, and introduce a single KVM_SEV_INIT_VM operation that
can be used for the PSP initialization.

> +The flags bitmap is defined as::
> +
> +   /* enable the restricted injection */
> +   #define KVM_SEV_SNP_RESTRICTED_INJET   (1<<0)
> +
> +   /* enable the restricted injection timer */
> +   #define KVM_SEV_SNP_RESTRICTED_TIMER_INJET   (1<<1)

These are not yet supported, so they might as well not be documented.
If you want to document them, you need to provide an API to query
SEV_SNP_SUPPORTED_FLAGS. Let's do that later.

> +       if (params.flags & ~SEV_SNP_SUPPORTED_FLAGS)
> +               ret =3D -EOPNOTSUPP;
> +
> +       params.flags =3D SEV_SNP_SUPPORTED_FLAGS;

This assignment is not necessary.

Paolo

