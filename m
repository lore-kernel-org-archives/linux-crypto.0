Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10817131BCB
	for <linux-crypto@vger.kernel.org>; Fri, 19 Apr 2024 16:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713543487; cv=none; b=AgY87mhY19POQTDml80dOMlL8cdEpxhYcytuaIH7FTAzAzlUSvsgaW1Uf/9fiXgy0USHlZfUND55J0PxSarnYT7fkGj5/YEWlAKQDfyNXvFIj3K1McmWbXyAQYmWFfTlXuT74P4m4ITvsYDuUzMP2T9ax98CmfJ157zzJxbgiVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713543487; c=relaxed/simple;
	bh=ltYnxkGmhFpcFrwY19hNp3Q7sHEjefSoiJDD3ImAFQk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GXyWSyYtkZa3MLIvPmJlJCNT9KZrtpbziWol8uHsW+KLBOkcA1zbnmY0zwrt5TMr+eAP7PqBT/4K0YlxTqY7Od+TQoljaKU3qd/HKuvfdaBmb7wPx/0D7sQtcTJSkYUPRWoLU1ImqTlg3/2zoOFxJf9/6kUCbD7a4zKIf7iziSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QHG4xZkd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QHG4xZkd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713543485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fCQBeSy7fxIc6enJRzf0fB8fa+25yMzZIh550xKv9hI=;
	b=QHG4xZkd+55AEDXtRaK4CuVah1nQ/vYF5saC9rB2VkeJDaYbHnJ67dEi+tgQ8aLsXa31v4
	VOkyBJ3BU8ZQTB6EEA9EM/Jv9OTM1M95sbEYLM+uvQdenbesf43aZqwqjcF0/F+XlX5IKm
	cMlkcOXNTYvXU0Ajf05qTMYmMyRG/C4=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-64-DeAmrVDtP56UKY0ff3GYqA-1; Fri, 19 Apr 2024 12:17:59 -0400
X-MC-Unique: DeAmrVDtP56UKY0ff3GYqA-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2d871086a09so20659271fa.1
        for <linux-crypto@vger.kernel.org>; Fri, 19 Apr 2024 09:17:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713543478; x=1714148278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fCQBeSy7fxIc6enJRzf0fB8fa+25yMzZIh550xKv9hI=;
        b=S2uhY489jA70PjnqrGb1hngK4Owd+rg3GIdsJHTQWeAfy7y0MvwkEuT3LOILvh1x8G
         k5EpJLBDO8A3dSPMTCEe3NgPB/2fC1oM6Q/Ouw2CF/8IbbHvH2g2jyvv9c/uMl3XmUNe
         4gr5hAEKQlzjw6nrBVEqb7YIa7gdqQ2P8RjlrE1CmaYtoWGZ1D/kfR+i8FAPglV4XlC8
         AzyURB9X4Up3s9jCW+Kdf+DKn571Q9hdFLAAe7T+WcXk7/J1HP3e4XmLCq/3+iy89N1x
         YNKf+UJf7KcPGS/6bjBiSzVuMlyQXbZaHzr2P30Vls7Md0bRcYl+tY8JPHwHQiTqw7cN
         n33Q==
X-Forwarded-Encrypted: i=1; AJvYcCWo9HFQkW5IwdK6cB9fFtKByHMplPd0FhVs+9pdHDGMhcUc3hnsEHt1i3SPO9eKyoxmxXFuhxw/87/9G255UI8WDDwq4ZvUVzzU6cKz
X-Gm-Message-State: AOJu0YxULh5p5OpSDdso0BcCUvjRWV5lA4JvzrwL8N87IK3YZVynZYjD
	a+P3Lwi5MvBMptbTY/uv8Zc6fkoE1/jbC/mX5ySXt1PzDD8XKMSym6GLJWufCx25zQvZ4THfiR+
	1LVjPbnWvi2Z06Cpa1890cR6Kik90bN/6DV9E5wUgywoDcIFkPocjF0d9/4SDuKkg4ZdcSDhrJS
	fVIVkfhIJw+Pr+s0ucR2+aKg3aPo28PAjEd3Pm
X-Received: by 2002:a2e:2c1a:0:b0:2da:7af:e6a1 with SMTP id s26-20020a2e2c1a000000b002da07afe6a1mr1689586ljs.3.1713543478025;
        Fri, 19 Apr 2024 09:17:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFs1jtdCXbIxqpwbuCS5xK85TAjnmuAZI/8TTHrvW2yG8L2y0KPYV6w7Jcu0HjZtCeFL5Vk1Cg+pcQRewqSow=
X-Received: by 2002:a2e:2c1a:0:b0:2da:7af:e6a1 with SMTP id
 s26-20020a2e2c1a000000b002da07afe6a1mr1689551ljs.3.1713543477605; Fri, 19 Apr
 2024 09:17:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418194133.1452059-1-michael.roth@amd.com>
 <20240418194133.1452059-5-michael.roth@amd.com> <a6086ba5-6137-44a0-9e51-ce4df5eb6ce4@redhat.com>
 <20240419151109.bo6kz4s24jgrmaj4@amd.com>
In-Reply-To: <20240419151109.bo6kz4s24jgrmaj4@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 19 Apr 2024 18:17:46 +0200
Message-ID: <CABgObfY4brEENatf_kVMcGv85M=ia01TStLGBwV4y9t=iOedAg@mail.gmail.com>
Subject: Re: [PATCH v13 04/26] KVM: guest_memfd: Fix PTR_ERR() handling in __kvm_gmem_get_pfn()
To: Michael Roth <michael.roth@amd.com>
Cc: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, 
	seanjc@google.com, vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 19, 2024 at 5:11=E2=80=AFPM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> On Fri, Apr 19, 2024 at 02:58:43PM +0200, David Hildenbrand wrote:
> > On 18.04.24 21:41, Michael Roth wrote:
> > > kvm_gmem_get_folio() may return a PTR_ERR() rather than just NULL. In
> > > particular, for cases where EEXISTS is returned when FGP_CREAT_ONLY
> > > flag is used. Handle this properly in __kvm_gmem_get_pfn().
> > >
> > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > > ---
> > >   virt/kvm/guest_memfd.c | 4 ++--
> > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > > index ccf22e44f387..9d7c6a70c547 100644
> > > --- a/virt/kvm/guest_memfd.c
> > > +++ b/virt/kvm/guest_memfd.c
> > > @@ -580,8 +580,8 @@ static int __kvm_gmem_get_pfn(struct file *file, =
struct kvm_memory_slot *slot,
> > >     }
> > >     folio =3D kvm_gmem_get_folio(file_inode(file), index, prepare);
> > > -   if (!folio)
> > > -           return -ENOMEM;
> > > +   if (IS_ERR_OR_NULL(folio))
> > > +           return folio ? PTR_ERR(folio) : -ENOMEM;
> >
> > Will it even return NULL?  Staring at other filemap_grab_folio() users,=
 they
> > all check for IS_ERR().
>
> Looks like the NULL case is handled with PTR_ERR(-ENOENT), so IS_ERR()
> would be sufficient. I think in the past kvm_gmem_get_folio() itself
> would return NULL in some cases, but as of commit 2b01b7e994e95 that's
> no longer the case.
>
> I'll fix this up to expect only PTR_ERR() when I re-spin v14, and also
> address the other kvm_gmem_get_folio() / __filemap_get_folio() call
> sites.
>
> >
> > >     if (folio_test_hwpoison(folio)) {
> > >             r =3D -EHWPOISON;
> >
> > Do we have a Fixes: tag?
>
> Fixes: 2b01b7e994e95 ("KVM: guest_memfd: pass error up from filemap_grab_=
folio")

I'll squash it so when you rebase on the new kvm-coco-queue it will go
away. Thanks to both!

Paolo

