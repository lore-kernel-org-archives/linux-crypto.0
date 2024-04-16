Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0AA128361
	for <linux-crypto@vger.kernel.org>; Tue, 16 Apr 2024 11:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713268421; cv=none; b=nR5h39OU56lRtwfdRDQQ+XrF+vK6kGOIa6WMniZbF73sbluFzp5DPYDr7Ut2x2F69wlGcTDHNiy9VCe0+jXhGi2/rVrylZiBn0s9Q3LzCnq2p1WgERAgz8O8fvNVQyfThfMW2p7+mAVbaCBJKg4WSbsHlzoXtXdtssTjT93DFY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713268421; c=relaxed/simple;
	bh=2B/0TZrDQ88vv16W4Pq06pS4UHrWwoD7Zfiru7x/BQY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G12JLOzjly53TiLHhAsTgKrHUyrjN5xlfzDx4Bv8MW1qR+yBKUpJZPB/gfropmS+5YgMd+M+hq8sjv2kMJEcyq+PFLUEaEgf6TJd5h6RNX4LHt59w6IuTuMrUsU0QUM3p0uWEtfsfc8rDzdN78+YsLQXXNIKkuQRwipGxUt3zEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f96ZtySB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f96ZtySB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713268419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Ux9rBA1E+x/XqOx1Zfa/TZpS8q2CNQskPcvct4f8Ic=;
	b=f96ZtySBKOmpjwkh/AW5JC8/+hH9IJe1BCjqFHiLL5JQ6R3BZVcpBiAC5J161sa13PT6Zf
	6PA0Jw0sf8UzhxemmYIYGPUr9SQCmmRDKsF6maOjKHd2N1pFEI9sg1hgs9HX7zIK0uZyCd
	ozTcWiU0JptyHMwVqz9NId7mYXOcUYs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-104-GfeQHE9nONeU9ZI6R-EsKg-1; Tue, 16 Apr 2024 07:53:38 -0400
X-MC-Unique: GfeQHE9nONeU9ZI6R-EsKg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-343ee8b13aeso3542332f8f.2
        for <linux-crypto@vger.kernel.org>; Tue, 16 Apr 2024 04:53:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713268416; x=1713873216;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Ux9rBA1E+x/XqOx1Zfa/TZpS8q2CNQskPcvct4f8Ic=;
        b=iazSAabR6pZqo/p3gdS6AeO1AcT8FY7Lvs1lMX3yauDhGNXHtwbAW4/j1bCzzYl0OP
         R9XXNHglyD2Jzgi638z8aT4oodzQG9D5Lkj0qCgi5IB/41oSw+pBJW3doNRkVIsKI4Fv
         BBu0sOGVxlrfTNSg4Xji0yEegKT7N9by6kvU6xZ7soeZVOd+BQaVwSv5skwU3U0kkuVI
         eiIeTcVAk8E+UigPKxQKDYJErEwJVrj3f60yEceF3M4vvzavHcnP9KemVp0TL/CnE0hM
         Q3OqajfNILZApvXHAenIfZJ/b2pS2vvqFxgrsFI/nXSXp0QJQa8q2CFLmJIB+Dr//lk7
         Ey/w==
X-Forwarded-Encrypted: i=1; AJvYcCVGb30vGdkphoV7g0IccVct4VO1J7l2DM5crl9WDBxDYONkgrdTPrp4yJCPakBpn68L92tj0VzQCWeYOYuB9bek8uYbCcU18ZeuazUb
X-Gm-Message-State: AOJu0Yw60rHWSTfdcrulNHfsF7Klm2YKI1M/N41BcKnrZQLRTTeWiMia
	8vz+U9sZxyUQ1C4M8PIgzNa/UjM1O2pPWZWHZ9zL7wDGMlgVe87VGttWk7nnrArlPUG5IXbWYJo
	OvIpf91ivqeo9xTuH4yKEOvsQMPB7se4hjtCw0xjs1HzQovKADhFMqCCu5ckcsKieLK9zkg6qK0
	5hl8ZRciZdxFFRLx9m/BKieiQmwnB97b3VzqJf
X-Received: by 2002:adf:cd11:0:b0:348:b435:2736 with SMTP id w17-20020adfcd11000000b00348b4352736mr1845204wrm.51.1713268416633;
        Tue, 16 Apr 2024 04:53:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHboei6CWQ68/kX4VWiS3hHyg54DT0hUEvoN+DvTUse7RMopQtT/6X8ZHkV5bkVVsxqb/R4glDVv0DZOX9sF8E=
X-Received: by 2002:adf:cd11:0:b0:348:b435:2736 with SMTP id
 w17-20020adfcd11000000b00348b4352736mr1845167wrm.51.1713268416287; Tue, 16
 Apr 2024 04:53:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240329225835.400662-1-michael.roth@amd.com> <20240329225835.400662-19-michael.roth@amd.com>
 <67685ec7-ca61-43f1-8ecd-120ec137e93a@redhat.com>
In-Reply-To: <67685ec7-ca61-43f1-8ecd-120ec137e93a@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 16 Apr 2024 13:53:24 +0200
Message-ID: <CABgObfZNVR-VKst8dDFZ4gs_zSWE8NE2gj5-Y4TNh0AnBfti7w@mail.gmail.com>
Subject: Re: [PATCH v12 18/29] KVM: SEV: Use a VMSA physical address variable
 for populating VMCB
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org, 
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
	pankaj.gupta@amd.com, liam.merwick@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 30, 2024 at 10:01=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com=
> wrote:
>
> On 3/29/24 23:58, Michael Roth wrote:
> > From: Tom Lendacky<thomas.lendacky@amd.com>
> >
> > In preparation to support SEV-SNP AP Creation, use a variable that hold=
s
> > the VMSA physical address rather than converting the virtual address.
> > This will allow SEV-SNP AP Creation to set the new physical address tha=
t
> > will be used should the vCPU reset path be taken.
> >
> > Signed-off-by: Tom Lendacky<thomas.lendacky@amd.com>
> > Signed-off-by: Ashish Kalra<ashish.kalra@amd.com>
> > Signed-off-by: Michael Roth<michael.roth@amd.com>
> > ---
>
> I'll get back to this one after Easter, but it looks like Sean had some
> objections at https://lore.kernel.org/lkml/ZeCqnq7dLcJI41O9@google.com/.

So IIUC the gist of the solution here would be to replace

   /* Use the new VMSA */
   svm->sev_es.vmsa_pa =3D pfn_to_hpa(pfn);
   svm->vmcb->control.vmsa_pa =3D svm->sev_es.vmsa_pa;

with something like

   /* Use the new VMSA */
   __free_page(virt_to_page(svm->sev_es.vmsa));
   svm->sev_es.vmsa =3D pfn_to_kaddr(pfn);
   svm->vmcb->control.vmsa_pa =3D __pa(svm->sev_es.vmsa);

and wrap the __free_page() in sev_free_vcpu() with "if
(!svm->sev_es.snp_ap_create)".

This should remove the need for svm->sev_es.vmsa_pa. It is always
equal to svm->vmcb->control.vmsa_pa anyway.

Also, it's possible to remove

   /*
    * gmem pages aren't currently migratable, but if this ever
    * changes then care should be taken to ensure
    * svm->sev_es.vmsa_pa is pinned through some other means.
    */
   kvm_release_pfn_clean(pfn);

if sev_free_vcpu() does

   if (svm->sev_es.snp_ap_create) {
     __free_page(virt_to_page(svm->sev_es.vmsa));
   } else {
     put_page(virt_to_page(svm->sev_es.vmsa));
   }

and while at it, please reverse the polarity of snp_ap_create and
rename it to snp_ap_created.

Paolo

