Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74DC17108A
	for <linux-crypto@vger.kernel.org>; Mon, 11 Nov 2024 21:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731360932; cv=none; b=HOz/D4bmwzF2wCT2N2WECluYPR45Xz4LvezQ/EWGXY090tlSt+fxXPFSpGwIFrflYKck6buCn/VS0i4BeVMK281OA6UEkXE6Ffiu+I1KUy7VGH5jkgNmJZ8BTG7059Hi8T9OfDV8hN92EuxHVN/emjF85f/b9JGj+oj28f1uhyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731360932; c=relaxed/simple;
	bh=sZPctFbSRa4VoNhG6YBk5++3iAfcZkXbOBSMSmr3Pv0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ilwi13v6M/D0B6LxpEBjsmOYLZBeA5SNU2Jz/Dv1sLZIuNyiQoRTSlK+ml+XTaXBHPZsyp7LxQ0BEmUpecPfXdNaB10Zx6Z2bbm7diLpsVnJV5i0ucTNZ4n086ouHSALdeXGeLjt2/YAYTX9Vanq2K5u8iMcxGry6WyH3j3/mZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DOee0zDw; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DOee0zDw"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-53b13ea6b78so7645203e87.2
        for <linux-crypto@vger.kernel.org>; Mon, 11 Nov 2024 13:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731360928; x=1731965728; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+fvRKUrqRzS9qo01XbB4L/q4tONbP8OJlgHyU9/kQes=;
        b=DOee0zDwp/GqygupfBzjFKq51jGvQzaei/gCL1dNqIfRGNH7h2G3rovNzBoeIGXNap
         UWF2QYMjGgrvOR/w1awao5EIIQfO4bm054XqFV5iMWUMbADwO+kORXiRhdEGLf5X6Okm
         fG22B6/6Zj7tI5sqP2+HhWQqdCO5PDI/Zqx/Rq8fpAyJuv+HzAM08uP2qvccKBeih9B1
         WFxcBo1s7WTLnq/cwDeyhJg36IJTml6fIIW5b5Tm3LOePwVRoBlI93BN3AAxzNoNwVMz
         LlvfZ9KC2BDBaERXKqX4hXUg/KymTVc9JytchjtDR3tI7eHoHKloh6pMJpPW4A1b0epj
         9A1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731360928; x=1731965728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+fvRKUrqRzS9qo01XbB4L/q4tONbP8OJlgHyU9/kQes=;
        b=BJVuJMtjL1HozQvQxMOYG/9EgFImUCOUy3Zi7dxUx2QIAbV20noNV/IP4j3t2NA64s
         EmtO9UoQFzO6CpKkHG2afUbxkkNKlv38uBvq9MSBNTliyZzUBPFGNIe+4vfD+8H9EAUY
         S3huWXLf92YT3C/Q6jiRm5RyGu19p6PTtO082kGUBeI4OprNWMDjBuLmQN0j/AsUeJ0c
         3oHoM9f4+foGotlwLHGeLPD9idGcCTGEAaqU0HseJPY69LtNHZ3M2hLUiJPnuDyJVsnL
         aE6sVuol8y1Prn4V2fJ28zGTlfUmGRHRYIcSgWrxPgfdNzh2H5LhuzAAJFDHWABJic9u
         zpAw==
X-Forwarded-Encrypted: i=1; AJvYcCWqXgM8p1uG/cKpYJ/OgVzuNdCCD5tDc9ZzuWJ2+QDOadbwcANCZG/KoGRUx/ldtmgSsTh6H3KZeHMJda8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSfMcJtbd8RgfkXnMYUo/UsXnhr/hodhdA7IxxMB/oKFunB3dy
	F6DuvH0hlupHFfc5yeKk2AIwFzf9QMm7/xlweCVCbKWtYhpmfsLBqY9+feZubZvMBfOxDngtOT6
	1+bbZWgmtTOiaA/aw2shkiqQmlaPjmSJcsLfa
X-Google-Smtp-Source: AGHT+IEmaxAKq1fyxj+USJEVwMlIk402bqPpwNvFPcaVmuyF+kyRKnin4d/Q0Cz9F198mdkbwOE3PbdRYalQk1Av1Ns=
X-Received: by 2002:a05:6512:3084:b0:539:8a50:6ee8 with SMTP id
 2adb3069b0e04-53d862f84cdmr8671535e87.57.1731360927824; Mon, 11 Nov 2024
 13:35:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241107232457.4059785-1-dionnaglaze@google.com>
 <20241107232457.4059785-6-dionnaglaze@google.com> <1719bdda-d901-4ff1-858d-f4ec0efddd90@amd.com>
In-Reply-To: <1719bdda-d901-4ff1-858d-f4ec0efddd90@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Mon, 11 Nov 2024 13:35:15 -0800
Message-ID: <CAAH4kHZWnbYRYJ6yCqemOtcVNjpn=Bpzr-Oe3O+XzAgNtph7mA@mail.gmail.com>
Subject: Re: [PATCH v5 05/10] crypto: ccp: Add GCTX API to track ASID assignment
To: "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	linux-coco@lists.linux.dev, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	Russ Weight <russ.weight@linux.dev>, Danilo Krummrich <dakr@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 11, 2024 at 1:16=E2=80=AFPM Kalra, Ashish <ashish.kalra@amd.com=
> wrote:
>
>
>
> On 11/7/2024 5:24 PM, Dionna Glaze wrote:
> > In preparation for SEV firmware hotloading support, introduce a new way
> > to create, activate, and decommission GCTX pages such that ccp is has
> > all GCTX pages available to update as needed.
> >
> > Compliance with SEV-SNP API section 3.3 Firmware Updates and 4.1.1
> > Live Update: before a firmware is committed, all active GCTX pages
> > should be updated with SNP_GUEST_STATUS to ensure their data structure
> > remains consistent for the new firmware version.
> > There can only be CPUID 0x8000001f_EDX-1 many SEV-SNP asids in use at
> > one time, so this map associates asid to gctx in order to track which
> > addresses are active gctx pages that need updating. When an asid and
> > gctx page are decommissioned, the page is removed from tracking for
> > update-purposes.
> >
> > CC: Sean Christopherson <seanjc@google.com>
> > CC: Paolo Bonzini <pbonzini@redhat.com>
> > CC: Thomas Gleixner <tglx@linutronix.de>
> > CC: Ingo Molnar <mingo@redhat.com>
> > CC: Borislav Petkov <bp@alien8.de>
> > CC: Dave Hansen <dave.hansen@linux.intel.com>
> > CC: Ashish Kalra <ashish.kalra@amd.com>
> > CC: Tom Lendacky <thomas.lendacky@amd.com>
> > CC: John Allen <john.allen@amd.com>
> > CC: Herbert Xu <herbert@gondor.apana.org.au>
> > CC: "David S. Miller" <davem@davemloft.net>
> > CC: Michael Roth <michael.roth@amd.com>
> > CC: Luis Chamberlain <mcgrof@kernel.org>
> > CC: Russ Weight <russ.weight@linux.dev>
> > CC: Danilo Krummrich <dakr@redhat.com>
> > CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > CC: "Rafael J. Wysocki" <rafael@kernel.org>
> > CC: Tianfei zhang <tianfei.zhang@intel.com>
> > CC: Alexey Kardashevskiy <aik@amd.com>
> >
> > Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> > ---
> >  drivers/crypto/ccp/sev-dev.c | 107 +++++++++++++++++++++++++++++++++++
> >  drivers/crypto/ccp/sev-dev.h |   8 +++
> >  include/linux/psp-sev.h      |  52 +++++++++++++++++
> >  3 files changed, 167 insertions(+)
> >
> > diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.=
c
> > index af018afd9cd7f..036e8d5054fcc 100644
> > --- a/drivers/crypto/ccp/sev-dev.c
> > +++ b/drivers/crypto/ccp/sev-dev.c
> > @@ -109,6 +109,10 @@ static void *sev_init_ex_buffer;
> >   */
> >  static struct sev_data_range_list *snp_range_list;
> >
> > +/* SEV ASID data tracks resources associated with an ASID to safely ma=
nage operations. */
> > +struct sev_asid_data *sev_asid_data;
> > +u32 nr_asids, sev_min_asid, sev_max_asid, sev_es_max_asid;
>
> This looks to be duplication of ASID management variables and support in =
KVM.
>

Agreed, though there will be duplication until all of the replacement
is ready and KVM can swap over.

> Probably this stuff needs to be merged with the ASID refactoring work bei=
ng done to
> move all SEV/SNP ASID allocation/management stuff to CCP from KVM.
>

Who's doing that work? I'm not clear on timelines either. If it's
currently underway, do you see a rebase on this patch set as
particularly challenging?
I wouldn't want to block hotloading support until it's all ready.

> > +
> >  static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
> >  {
> >       struct sev_device *sev =3D psp_master->sev_data;
> > @@ -1093,6 +1097,81 @@ static int snp_filter_reserved_mem_regions(struc=
t resource *rs, void *arg)
> >       return 0;
> >  }
> >
> > +void *sev_snp_create_context(int asid, int *psp_ret)
> > +{
> > +     struct sev_data_snp_addr data =3D {};
> > +     void *context;
> > +     int rc;
> > +
> > +     if (!sev_asid_data)
> > +             return ERR_PTR(-ENODEV);
> > +
> > +     /* Can't create a context for a used ASID. */
> > +     if (sev_asid_data[asid].snp_context)
> > +             return ERR_PTR(-EBUSY);
> > +
> > +     /* Allocate memory for context page */
> > +     context =3D snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
> > +     if (!context)
> > +             return ERR_PTR(-ENOMEM);
> > +
> > +     data.address =3D __psp_pa(context);
> > +     rc =3D sev_do_cmd(SEV_CMD_SNP_GCTX_CREATE, &data, psp_ret);
> > +     if (rc) {
> > +             pr_warn("Failed to create SEV-SNP context, rc %d fw_error=
 %d",
> > +                     rc, *psp_ret);
> > +             snp_free_firmware_page(context);
> > +             return ERR_PTR(-EIO);
> > +     }
> > +
> > +     sev_asid_data[asid].snp_context =3D context;
> > +
> > +     return context;
> > +}
> > +
> > +int sev_snp_activate_asid(int asid, int *psp_ret)
> > +{
> > +     struct sev_data_snp_activate data =3D {0};
> > +     void *context;
> > +
> > +     if (!sev_asid_data)
> > +             return -ENODEV;
> > +
> > +     context =3D sev_asid_data[asid].snp_context;
> > +     if (!context)
> > +             return -EINVAL;
> > +
> > +     data.gctx_paddr =3D __psp_pa(context);
> > +     data.asid =3D asid;
> > +     return sev_do_cmd(SEV_CMD_SNP_ACTIVATE, &data, psp_ret);
> > +}
> > +
> > +int sev_snp_guest_decommission(int asid, int *psp_ret)
> > +{
> > +     struct sev_data_snp_addr addr =3D {};
> > +     struct sev_asid_data *data =3D &sev_asid_data[asid];
> > +     int ret;
> > +
> > +     if (!sev_asid_data)
> > +             return -ENODEV;
> > +
> > +     /* If context is not created then do nothing */
> > +     if (!data->snp_context)
> > +             return 0;
> > +
> > +     /* Do the decommision, which will unbind the ASID from the SNP co=
ntext */
> > +     addr.address =3D __sme_pa(data->snp_context);
> > +     ret =3D sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &addr, NULL);
> > +
> > +     if (WARN_ONCE(ret, "Failed to release guest context, ret %d", ret=
))
> > +             return ret;
> > +
> > +     snp_free_firmware_page(data->snp_context);
> > +     data->snp_context =3D NULL;
> > +
> > +     return 0;
> > +}
> > +
> >  static int __sev_snp_init_locked(int *error)
> >  {
> >       struct psp_device *psp =3D psp_master;
> > @@ -1306,6 +1385,27 @@ static int __sev_platform_init_locked(int *error=
)
> >       return 0;
> >  }
> >
> > +static int __sev_asid_data_init(void)
> > +{
> > +     u32 eax, ebx;
> > +
> > +     if (sev_asid_data)
> > +             return 0;
> > +
> > +     cpuid(0x8000001f, &eax, &ebx, &sev_max_asid, &sev_min_asid);
> > +     if (!sev_max_asid)
> > +             return -ENODEV;
> > +
> > +     nr_asids =3D sev_max_asid + 1;
> > +     sev_es_max_asid =3D sev_min_asid - 1;
> > +
> > +     sev_asid_data =3D kcalloc(nr_asids, sizeof(*sev_asid_data), GFP_K=
ERNEL);
> > +     if (!sev_asid_data)
> > +             return -ENOMEM;
> > +
> > +     return 0;
> > +}
>
> Again, looks to be duplicating ASID setup code in sev_hardware_setup() (i=
n KVM),
> maybe all this should be part of the ASID refactoring work to move all SE=
V/SNP
> ASID code to CCP from KVM module, that should then really streamline all =
ASID/GCTX
> tracking.
>
> Thanks,
> Ashish
>
> > +
> >  static int _sev_platform_init_locked(struct sev_platform_init_args *ar=
gs)
> >  {
> >       struct sev_device *sev;
> > @@ -1319,6 +1419,10 @@ static int _sev_platform_init_locked(struct sev_=
platform_init_args *args)
> >       if (sev->state =3D=3D SEV_STATE_INIT)
> >               return 0;
> >
> > +     rc =3D __sev_asid_data_init();
> > +     if (rc)
> > +             return rc;
> > +
> >       /*
> >        * Legacy guests cannot be running while SNP_INIT(_EX) is executi=
ng,
> >        * so perform SEV-SNP initialization at probe time.
> > @@ -2329,6 +2433,9 @@ static void __sev_firmware_shutdown(struct sev_de=
vice *sev, bool panic)
> >               snp_range_list =3D NULL;
> >       }
> >
> > +     kfree(sev_asid_data);
> > +     sev_asid_data =3D NULL;
> > +
> >       __sev_snp_shutdown_locked(&error, panic);
> >  }
> >
> > diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.=
h
> > index 3e4e5574e88a3..7d0fdfdda30b6 100644
> > --- a/drivers/crypto/ccp/sev-dev.h
> > +++ b/drivers/crypto/ccp/sev-dev.h
> > @@ -65,4 +65,12 @@ void sev_dev_destroy(struct psp_device *psp);
> >  void sev_pci_init(void);
> >  void sev_pci_exit(void);
> >
> > +struct sev_asid_data {
> > +     void *snp_context;
> > +};
> > +
> > +/* Extern to be shared with firmware_upload API implementation if conf=
igured. */
> > +extern struct sev_asid_data *sev_asid_data;
> > +extern u32 nr_asids, sev_min_asid, sev_max_asid, sev_es_max_asid;
> > +
> >  #endif /* __SEV_DEV_H */
> > diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> > index 903ddfea85850..ac36b5ddf717d 100644
> > --- a/include/linux/psp-sev.h
> > +++ b/include/linux/psp-sev.h
> > @@ -942,6 +942,58 @@ int sev_guest_decommission(struct sev_data_decommi=
ssion *data, int *error);
> >   */
> >  int sev_do_cmd(int cmd, void *data, int *psp_ret);
> >
> > +/**
> > + * sev_snp_create_context - allocates an SNP context firmware page
> > + *
> > + * Associates the created context with the ASID that an activation
> > + * call after SNP_LAUNCH_START will commit. The association is needed
> > + * to track active guest context pages to refresh during firmware hotl=
oad.
> > + *
> > + * @asid:    The ASID allocated to the caller that will be used in a s=
ubsequent SNP_ACTIVATE.
> > + * @psp_ret: sev command return code.
> > + *
> > + * Returns:
> > + * A pointer to the SNP context page, or an ERR_PTR of
> > + * -%ENODEV    if the PSP device is not available
> > + * -%ENOTSUPP  if PSP device does not support SEV
> > + * -%ETIMEDOUT if the SEV command timed out
> > + * -%EIO       if PSP device returned a non-zero return code
> > + */
> > +void *sev_snp_create_context(int asid, int *psp_ret);
> > +
> > +/**
> > + * sev_snp_activate_asid - issues SNP_ACTIVATE for the ASID and associ=
ated guest context page.
> > + *
> > + * @asid:    The ASID to activate.
> > + * @psp_ret: sev command return code.
> > + *
> > + * Returns:
> > + * 0 if the SEV device successfully processed the command
> > + * -%ENODEV    if the PSP device is not available
> > + * -%ENOTSUPP  if PSP device does not support SEV
> > + * -%ETIMEDOUT if the SEV command timed out
> > + * -%EIO       if PSP device returned a non-zero return code
> > + */
> > +int sev_snp_activate_asid(int asid, int *psp_ret);
> > +
> > +/**
> > + * sev_snp_guest_decommission - issues SNP_DECOMMISSION for an ASID's =
guest context page, and frees
> > + * it.
> > + *
> > + * The caller must ensure mutual exclusion with any process that may d=
eactivate ASIDs.
> > + *
> > + * @asid:    The ASID to activate.
> > + * @psp_ret: sev command return code.
> > + *
> > + * Returns:
> > + * 0 if the SEV device successfully processed the command
> > + * -%ENODEV    if the PSP device is not available
> > + * -%ENOTSUPP  if PSP device does not support SEV
> > + * -%ETIMEDOUT if the SEV command timed out
> > + * -%EIO       if PSP device returned a non-zero return code
> > + */
> > +int sev_snp_guest_decommission(int asid, int *psp_ret);
> > +
> >  void *psp_copy_user_blob(u64 uaddr, u32 len);
> >  void *snp_alloc_firmware_page(gfp_t mask);
> >  void snp_free_firmware_page(void *addr);



--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)
