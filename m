Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B4F12F376
	for <linux-crypto@vger.kernel.org>; Fri, 19 Apr 2024 16:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713543149; cv=none; b=Y2zKX4vhVBUJm6L6tvsiFTCs3cpeJ1jQMay8o7q5xCQOZ4YWyJY/Wa1llLMJDrwKk260K06HG6aF9wyKA+EBU5LHY9Pi6LU0qNZCtlCsx9uuOJRGqKGpaSoUmvrgJAUg94mS++qIyw3M2JLU4JVFeVoQW2H/pEk/Kp0rl3ZXfYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713543149; c=relaxed/simple;
	bh=BoY/Dy3UEpWzAlEVCqDQTE76CEu5CAwU1Yr/gwGs0FU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=egVXsj3R6RP/JiFZGaa3W6VTyqFv8qpq5Pmj6QHwMBRaOAXd8OE3t2edjZhODWLcv1BEyGO23ePPIxkjWFtafbNO+20Dh3PM+q0+MRMlp6ZPBVdQ6yS/9I4Z6D54kjQ5K2z4nfVhzSBgTx5uSVGfyzdjQyWxn1+hl6iMiBqTSkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BzV4BJKy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BzV4BJKy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713543146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9uBiWyy2Y6aSUbUd2veflvDo2gmH6uQXxYZf3A1GRsI=;
	b=BzV4BJKyqk7hJjh0On+5j+foOmt+69ti/kM0nQYgbT+oafjmAQUPAvWIlwhaMERdBQvjCP
	CDzOGTy55TCavSdOFLREZyYKVJEIhq1bDZw+N8yQ0ikKfh0SPlaABXe154iPJZ9npxmddW
	w/7mfqcVzZ4P0C6cYCkCUK5VdXLFrcs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-d21fGfmTMHOT_FPUbD2AwQ-1; Fri, 19 Apr 2024 12:12:24 -0400
X-MC-Unique: d21fGfmTMHOT_FPUbD2AwQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3473168c856so1346679f8f.1
        for <linux-crypto@vger.kernel.org>; Fri, 19 Apr 2024 09:12:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713543143; x=1714147943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9uBiWyy2Y6aSUbUd2veflvDo2gmH6uQXxYZf3A1GRsI=;
        b=GGXcjZ3xzeA3gwwowxg3DPmtrmTNUy2ElCKSZldrUs0XyI5otDRDG50hrur1Jw9RUb
         WmvKioqFDHRo6SdPUdj11i1vIEURBpc3RXV3ccu6dscssddN6UVqfhqU9JA3kRQD7jNH
         hVcD4+tDIyz8hDNyPJlMUCB1iwTx8eW3f1PYKcLXHxQTLI+7eH4KYmoYxm07tUHUE8mx
         nqqe3uXIEPxlje0md4u3Hq34QuNAX6U9aKU2+CvxGjWiQ2isCkYT1uWX2+a69aPChJhY
         tM5T9OHoQqnPcDqweBk7zqYzFh6/qEsXKnAe9A2r+1e78fKMlJDBw0erVVpZfpOY1DeG
         Svgg==
X-Forwarded-Encrypted: i=1; AJvYcCX0c86UhaEaydZAr4EgON0vdvkYkdBr0PcfGiHxM+xVWNwEDBzDKBbqI1HjYqQyzGueNAqG1IAaJOz9DPxCVgpVsjlUek5Gop+3/yKH
X-Gm-Message-State: AOJu0YzC+aV1BRZ4nQItcE+4BoXzRxgjMEsV0MxoIyFIj5rrfVk4xVRh
	DeoEwqcs3kA4+5GAevZgP2TMOB8W7HcbEGP6wpnL9QjahDZz8ncZie6/jfXH12fD1nmidVCI5pE
	LwRj6gWn1LIUuc2vho0um7nXFvwwGwgIQizMCNEDr9as9rnRXcGaI9jnVY31Jf3fWg1DtJKG4WC
	gDOhcaaQjAfrvvgSNAr3WCWUURqZ5QRD2MgG10
X-Received: by 2002:a05:6000:f:b0:34a:72d:8dae with SMTP id h15-20020a056000000f00b0034a072d8daemr1744521wrx.22.1713543142972;
        Fri, 19 Apr 2024 09:12:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGu/laGQnrA9BrIF/Cu+lsjfknC5maDVu87SwW7AhUXq8hp5tDZF8U2qhpYBw4LEzoXCxA4xzi8O802s4cFw3o=
X-Received: by 2002:a05:6000:f:b0:34a:72d:8dae with SMTP id
 h15-20020a056000000f00b0034a072d8daemr1744478wrx.22.1713543142601; Fri, 19
 Apr 2024 09:12:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418194133.1452059-1-michael.roth@amd.com>
 <20240418194133.1452059-11-michael.roth@amd.com> <CABgObfaj4-GXSCWFx+=o7Cdhouo8Ftz4YEWgsQ2XNRc3KD-jPg@mail.gmail.com>
In-Reply-To: <CABgObfaj4-GXSCWFx+=o7Cdhouo8Ftz4YEWgsQ2XNRc3KD-jPg@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 19 Apr 2024 18:12:11 +0200
Message-ID: <CABgObfa9Ya-taTKkRbmUQGcwqYG+6cs_=kwdqzmFrbgBQG3Epw@mail.gmail.com>
Subject: Re: [PATCH v13 10/26] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
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

On Fri, Apr 19, 2024 at 1:56=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
> > +       ret =3D kvm_gmem_populate(kvm, params.gfn_start, u64_to_user_pt=
r(params.uaddr),
> > +                               npages, sev_gmem_post_populate, &sev_po=
pulate_args);
> > +       if (ret < 0) {
> > +               argp->error =3D sev_populate_args.fw_error;
> > +               pr_debug("%s: kvm_gmem_populate failed, ret %d (fw_erro=
r %d)\n",
> > +                        __func__, ret, argp->error);
> > +       } else if (ret < npages) {
> > +               params.len =3D ret * PAGE_SIZE;
> > +               ret =3D -EINTR;
>
> This probably should 1) update also gfn_start and uaddr 2) return 0
> for consistency with the planned KVM_PRE_FAULT_MEMORY ioctl (aka
> KVM_MAP_MEMORY).

To be more precise, params.len should be set to the number of bytes *left*,=
 i.e.

   params.len -=3D ret * PAGE_SIZE;
   params.gfn_start +=3D ret * PAGE_SIZE;
   if (params.type !=3D KVM_SEV_SNP_PAGE_TYPE_ZERO)
       params.uaddr +=3D ret * PAGE_SIZE;

Also this patch needs some other changes:

1) snp_launch_update() should have something like this:

   src =3D params.type =3D=3D KVM_SEV_SNP_PAGE_TYPE_ZERO ? NULL :
u64_to_user_ptr(params.uaddr),;

so that then...

> +               vaddr =3D kmap_local_pfn(pfn + i);
> +               ret =3D copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_S=
IZE);
> +               if (ret) {
> +                       pr_debug("Failed to copy source page into GFN 0x%=
llx\n", gfn);
> +                       goto out_unmap;
> +               }

... the copy can be done only if src is non-NULL

2) the struct should have some more fields

> +        struct kvm_sev_snp_launch_update {
> +                __u64 gfn_start;        /* Guest page number to load/enc=
rypt data into. */
> +                __u64 uaddr;            /* Userspace address of data to =
be loaded/encrypted. */
> +                __u32 len;              /* 4k-aligned length in bytes to=
 copy into guest memory.*/
> +                __u8 type;              /* The type of the guest pages b=
eing initialized. */

__u8 pad0;
__u16 flags;   // must be zero
__u64 pad1[5];

with accompanying flags check in snp_launch_update().

If you think IMI can be implemented already (with a bit in flags) go
ahead and do it.

Paolo

