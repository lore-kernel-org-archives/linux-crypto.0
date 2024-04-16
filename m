Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A6B1327E7
	for <linux-crypto@vger.kernel.org>; Tue, 16 Apr 2024 17:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713286883; cv=none; b=B5IMLE0XjN9xAoRoubnYgVfn9NE54KzHNjTv/d/6zHSn9/9LbEUdY0AbRgeukfUkOc7mULZKXwJMgleDLWvCQrCso81pZ03S3zfcg9VEAEpJ+hW+S0aIv/n+Xu7aWPairw5kCVRYHGa+ddVKdz6OsHjyilYVEwu2vp2BaaHHzKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713286883; c=relaxed/simple;
	bh=d8yfNDlD2slCnTX5YrNTAPoVtr6kE/Nqrv0NiCbczaQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ax3a0ceHs6xi88MsaN7b6kF04lmsdmAYN1eq/tedUUqBMikCypLbH5/R4UnZec321qMNqEqjtRuOu/Ik3t3Ji0cJDpVHc1EZujGCWK52ABs5zvLYmZoHfIMPMsLnCyRB8QyOIcIdaZvRFFUAQpExYN6+lvHsCnTtYHEJZT9xxTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JeGRKW18; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JeGRKW18"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713286881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YV3huxxwV4cNX30vuhj/67sfqzzrbon2fJPguOJkhQA=;
	b=JeGRKW18O5nyr5llQD+oP8Xn/XKOtR/weaoizCTROrdsBfmqvljBIG1UyCz8Ehy+K58+YS
	Qbq6D6FNRzFaoJPzRMPUdoC1HvX7bUsa6sgMbORIP6/hKWO42+MthWV1LZtLWGaAQT8MVQ
	xLsoH6fduEQ/CoAAuduWPoNKeWhxGlA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-2UdE-vKyOZ2UGkiUIeEz0g-1; Tue, 16 Apr 2024 13:01:11 -0400
X-MC-Unique: 2UdE-vKyOZ2UGkiUIeEz0g-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-343e74dcf0bso2808393f8f.0
        for <linux-crypto@vger.kernel.org>; Tue, 16 Apr 2024 10:01:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713286870; x=1713891670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YV3huxxwV4cNX30vuhj/67sfqzzrbon2fJPguOJkhQA=;
        b=By6as2DSClk66u3srdId8sn5a7Bqd1NesWW81q/zrbJu+f8B27bxlCCB+o8FC7ULaP
         uEOx2l2eQtCVVQctStZYHro9yNQG59VlMq1voPnjXZJUc7ElNB0Er3KXckd9J44HRSTK
         KCH3dURpm0DQUskdyBOUidkN/o/8zZ2UZwJZ5Crpiq8iyCwCpIGwsibQUoGQzE9hBua6
         RzpJlgi7vHQ34NP+fdMrtyPzfViOR2Kgd8Tk8wy2+sYD+Az+2HshiNMuUnHs80oGbG4q
         eKeDu4+/EQ9gt9t4V/iH64rs8chCKc5I5RcMpzOAIVI4tO/UUfwq/FpFDgGAXqnSgrpZ
         Iy4A==
X-Forwarded-Encrypted: i=1; AJvYcCUJue+IBetVsWcBbfFNGl3VDMFdxasKsdD4nqS3Q0IlmMQpFyvOoI4WzCh0u70/zTc/BNqQF9rxQJHvN+sKu0f99PgILGEIVp6vE27i
X-Gm-Message-State: AOJu0YyPUhYvz89QB529LkJmxo/QBYhErtEkpeqOeTNRdKzql33HcLQ5
	0no/FNlhZ/9BhFtCiXvO2NPqRu2D1tvCQFVKz36MACv3GQ6UIeEdcsQ9sctD8JF1ycHaiNVyEnG
	Y3TZXTcjpBeZHGAHID8BZ75CgD2EwBPFHgC+3su0E0TGvRQujvMtwy8Y/cx3wqsdnPAr0uy/BYN
	gjjYKf85mHwKgFtfycuhAzCkNkoOEfNHCVhQXq
X-Received: by 2002:a5d:6247:0:b0:348:5e40:62aa with SMTP id m7-20020a5d6247000000b003485e4062aamr2053430wrv.2.1713286870093;
        Tue, 16 Apr 2024 10:01:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6fYFk6xl1nuI2T7KirzQuQyw/sEuJB0A3gheWB+RJwuSGwFc7r4/2ReNv9v/wLow5jcYtNYlNsRKa11DX2JM=
X-Received: by 2002:a5d:6247:0:b0:348:5e40:62aa with SMTP id
 m7-20020a5d6247000000b003485e4062aamr2053410wrv.2.1713286869755; Tue, 16 Apr
 2024 10:01:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240329225835.400662-1-michael.roth@amd.com> <20240329225835.400662-19-michael.roth@amd.com>
 <67685ec7-ca61-43f1-8ecd-120ec137e93a@redhat.com> <CABgObfZNVR-VKst8dDFZ4gs_zSWE8NE2gj5-Y4TNh0AnBfti7w@mail.gmail.com>
 <758c876d-ff77-0633-7b3e-965d863d5a93@amd.com>
In-Reply-To: <758c876d-ff77-0633-7b3e-965d863d5a93@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 16 Apr 2024 19:00:58 +0200
Message-ID: <CABgObfbhNce22iuqjS3bF9V4aD1vpBg3oUcV6SLVHgvL+-UUmA@mail.gmail.com>
Subject: Re: [PATCH v12 18/29] KVM: SEV: Use a VMSA physical address variable
 for populating VMCB
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	jroedel@suse.de, hpa@zytor.com, ardb@kernel.org, seanjc@google.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 16, 2024 at 4:25=E2=80=AFPM Tom Lendacky <thomas.lendacky@amd.c=
om> wrote:
>
> On 4/16/24 06:53, Paolo Bonzini wrote:
> > On Sat, Mar 30, 2024 at 10:01=E2=80=AFPM Paolo Bonzini <pbonzini@redhat=
.com> wrote:
> >>
> >> On 3/29/24 23:58, Michael Roth wrote:
> >>> From: Tom Lendacky<thomas.lendacky@amd.com>
> >>>
> >>> In preparation to support SEV-SNP AP Creation, use a variable that ho=
lds
> >>> the VMSA physical address rather than converting the virtual address.
> >>> This will allow SEV-SNP AP Creation to set the new physical address t=
hat
> >>> will be used should the vCPU reset path be taken.
> >>>
> >>> Signed-off-by: Tom Lendacky<thomas.lendacky@amd.com>
> >>> Signed-off-by: Ashish Kalra<ashish.kalra@amd.com>
> >>> Signed-off-by: Michael Roth<michael.roth@amd.com>
> >>> ---
> >>
> >> I'll get back to this one after Easter, but it looks like Sean had som=
e
> >> objections at https://lore.kernel.org/lkml/ZeCqnq7dLcJI41O9@google.com=
/.
> >
>
> Note that AP create is called multiple times per vCPU under OVMF with
> and added call by the kernel when booting the APs.

Oooh, I somehow thought that

+ target_svm->sev_es.snp_vmsa_gpa =3D INVALID_PAGE;
+ target_svm->sev_es.snp_ap_create =3D true;

was in svm_create_vcpu().

So there should be separate "snp_ap_waiting_for_reset" and
"snp_has_guest_vmsa" flags. The latter is set once in
__sev_snp_update_protected_guest_state and is what governs whether the
VMSA page was allocated or just refcounted.

> But I believe that Sean wants a separate KVM object per VMPL level, so
> that would disappear anyway (Joerg and I want to get on the PUCK
> schedule to talk about multi-VMPL level support soon.)

Yes, agreed on both counts.

> >     /*
> >      * gmem pages aren't currently migratable, but if this ever
> >      * changes then care should be taken to ensure
> >      * svm->sev_es.vmsa_pa is pinned through some other means.
> >      */
> >     kvm_release_pfn_clean(pfn);
>
> Removing this here will cause any previous guest VMSA page(s) to remain
> pinned, that's the reason for unpinning here. OVMF re-uses the VMSA, but
> that isn't a requirement for a firmware, and the kernel will create a
> new VMSA page.

Yes, and once you understand that I was thinking of a set-once flag
"snp_has_guest_vmsa" it should all make a lot more sense.

Paolo

