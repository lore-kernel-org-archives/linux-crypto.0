Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F1F1E0E0B
	for <linux-crypto@vger.kernel.org>; Fri,  8 Nov 2024 22:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731104006; cv=none; b=mKcpu/IQx4tfa0RkBukvRbpLbRUYVXtMycV35i/mdx1kHHirufuueVJ8p+Wt/ft229m6t7WoFVjAQiDR5MbzUhFWpf6brIYJ2J4SfOQ9APNH43nkYC/pf59gNbcxESi3y+I24/1RkG+QoHZLVytAYa+0lTvlJaLGWe46yCfC+n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731104006; c=relaxed/simple;
	bh=LkpX578FMH8l8x30Ft7X2HOv+xrEWAqzChBOVin90E4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FejRPyJb0yGn2yRMDLop4Prgm8rELD2okfZDOhvhZa8xQj6ymhAFF012CMYQLkpzk2M8clznf2vVAq4ao9ZqKFnuPBBV2+kDhNNNt71WjRcCbH+yVMKS/kkCq4SahZRlD9q5qVEwMsKUOPa0Ucfv90c/u9BrCXznakWRKIMw+z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4orL3lCB; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4orL3lCB"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a9ec86a67feso437616866b.1
        for <linux-crypto@vger.kernel.org>; Fri, 08 Nov 2024 14:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731104002; x=1731708802; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G+uwh4iGNwqoJyK+lSF90F2FlIqfyYv9bHOWsmJTTrQ=;
        b=4orL3lCB3YrgKScvyWBHvfX3nirCsQByFy9ucM6iRObZJ7aZF9itjtXdcPJlKEEtfT
         fPnYfB6DnBYzBPvCKLQHT7Qy5jIm2laTMeydaQ7FF/iDYKnQF7OiwNrClym/5lVxEl1e
         rwaUfdNy4kJ8M14aMCIImfUnbUzuc4uOOJjWxZD8pzqSvCpS/lh9zwV2SIOgM3JUJIa9
         JNbqAnP7C4aPzjrpxWePajNu4IIROKnkqRbZfdTL/h+S5o9JZj7jtAuPRFqAmA/qkfqO
         Nxh5YPLYqBDNtaLd2vZoCFMyHInIAB0zZK0sgMwgvxQ8VLjesn/egnKOtJ5nf79eRbMB
         3GGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731104002; x=1731708802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G+uwh4iGNwqoJyK+lSF90F2FlIqfyYv9bHOWsmJTTrQ=;
        b=a9hdhuUX/4Fb9bRbhodffSp76Ld8g+/7c0uJwgIP7XX7nXPYU0F2a1AYXSU+f5RKoZ
         LxFThTu3OjkqEbaf8Ir32D6+ZkbTIkNJ/q4XqUAJdz81gR5wAmPBIoP9GCJhkaGYHu6i
         2VYlHenK/DarFZa/mR4i09THwg0DSoXM/lwnFMWhxc+fGU7rKFsGUjT+be2N/8BOLt7q
         IQ1mfmZgRlj2U3pZjXNxf3jkXfRBrV75X8pYFc1jekZIrBa2JSwLoylw52dx3nqQ3bd8
         87hwQWc/3LtthW1DxP1PEDQajwN+1pjtIIX2oVT8U7WamQ7zLihYN1H9HolagLP51r3W
         R+xQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfxgVZ+TVI6KRfxqLH7LA55Ub3iVIS5lI/AVPG5vWH/oHjdigacFDg35UYcNF95CUeprdUWr61ZA342BA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj7YzHthah81oOw/MlIq5JWEyeQ9BGm4s2jpAlFivZPdnc08SD
	NOyAC2UqKrFqiUllpueyb6w0HXFHkLT6rJT4bOMdyvDK4VDGf4Zed/Qdv0t1df8KCvAvc+7YPHw
	Scnn8a8jiLDc2F0sSfGkGTh9zQcYHS7f7FybX
X-Google-Smtp-Source: AGHT+IGeMDPyk7D7Nc3orlZ44f5u8K3H33G2zFM3HVIC/PNnyBFWUOGTgIjvfR4frXAAWH9LtZLaR0xxUQE8Qigqdp8=
X-Received: by 2002:a17:907:9411:b0:a99:f466:a87a with SMTP id
 a640c23a62f3a-a9eefebd146mr436575266b.3.1731104001515; Fri, 08 Nov 2024
 14:13:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241107232457.4059785-1-dionnaglaze@google.com>
 <20241107232457.4059785-6-dionnaglaze@google.com> <71db9119-a667-96c1-7aaa-4f0241f203ea@amd.com>
In-Reply-To: <71db9119-a667-96c1-7aaa-4f0241f203ea@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Fri, 8 Nov 2024 14:13:09 -0800
Message-ID: <CAAH4kHaVDTokOR9BBbinXkw=Hk3ztYoiZOK_77JahmQ64vjK_g@mail.gmail.com>
Subject: Re: [PATCH v5 05/10] crypto: ccp: Add GCTX API to track ASID assignment
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ashish Kalra <ashish.kalra@amd.com>, John Allen <john.allen@amd.com>, 
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

On Fri, Nov 8, 2024 at 9:24=E2=80=AFAM Tom Lendacky <thomas.lendacky@amd.co=
m> wrote:
>
> On 11/7/24 17:24, Dionna Glaze wrote:
> > In preparation for SEV firmware hotloading support, introduce a new way
> > to create, activate, and decommission GCTX pages such that ccp is has
>
> s/is has/has/
>
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
>
> You should be consistent with capitalization of gctx and also capitalize =
ASID.
>
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
>
> Should this be a WARN_ON_ONCE() check since we should really never
> encounter this situation if things are programmed correctly, right?
>
> Also, should the ASID value be vetted to ensure you don't go beyond the
> end of the array?
>
> > +             return ERR_PTR(-EBUSY);
> > +
> > +     /* Allocate memory for context page */
> > +     context =3D snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
> > +     if (!context)
> > +             return ERR_PTR(-ENOMEM);
> > +
> > +     data.address =3D __psp_pa(context);
> > +     rc =3D sev_do_cmd(SEV_CMD_SNP_GCTX_CREATE, &data, psp_ret);
>
> Since psp_ret could be NULL, maybe use a local int variable "error" that
> can be supplied and then used below in the message unconditionally.
>
> Then check check if psp_ret is non-NULL and assign "error" to it.
>
> > +     if (rc) {
> > +             pr_warn("Failed to create SEV-SNP context, rc %d fw_error=
 %d",
>
> I know this is replicating what snp_context_create() does, but the SEV an=
d
> SNP specs specify error codes in hex, so we could simplify the lookup
> process by outputting a hex value for fw_error here. Not completely
> necessary, but would be nice.
>
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
>
> Ditto on the ASID value vetting here.
>
> > +     if (!context)
>
> Ditto on the WARN_ON_ONCE since we should always have a context when this
> is called.
>
> > +             return -EINVAL;
> > +
> > +     data.gctx_paddr =3D __psp_pa(context);
> > +     data.asid =3D asid;
> > +     return sev_do_cmd(SEV_CMD_SNP_ACTIVATE, &data, psp_ret);
> > +}
>
> But, I don't think that SEV_CMD_SNP_ACTIVATE needs to be here since it
> doesn't change anything related to the sev_asid_data struct. KVM has the
> guest context and can issue the commands similar to the other commands KV=
M
> issues that use the guest context. So this function can be removed and
> still performed in KVM.

My intention for adding it was for safety, not raw capability.
Is it not safer to ensure that the GCTX used for activation is the one
that is tracked?

>
> > +
> > +int sev_snp_guest_decommission(int asid, int *psp_ret)
> > +{
> > +     struct sev_data_snp_addr addr =3D {};
> > +     struct sev_asid_data *data =3D &sev_asid_data[asid];
>
> Should do ASID value checking before assigning.
>

Done.

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
>
> Ditto on the psp_ret thing here, too.
>

Done.

> > +
> > +     if (WARN_ONCE(ret, "Failed to release guest context, ret %d", ret=
))
>
> And then this message can include the fw error for better debugging outpu=
t.
>

Done.

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
>
> No need for the double underscore at the start of the function name.
>
Done.

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
>
> Can we get rid of sev_max_asid and then just use nr_asids or sev_asids in
> the cpuid() call and adjust by 1 after the above check.
>
I'm not sure I know what you mean.
> > +     sev_es_max_asid =3D sev_min_asid - 1;
> > +
> > +     sev_asid_data =3D kcalloc(nr_asids, sizeof(*sev_asid_data), GFP_K=
ERNEL);
>
> Is this using the full ASID range in case we want to track non-SNP relate=
d
> contexts in the future?
>

Correct. It's to prepare for sev_asid_data to become

struct sev_asid_data {
    union {
        void *snp_context;
        struct {
            u32 handle;
            u32 reserved:31;
            u32 legacy:1;
        } sev;
    };
};

This way we can introduce an ASID api that owns allocation and
synchronization of flushing.

/* allocates an asid, and if SEV-SNP, creates a GCTX page and returns
its physical address in gctx_paddr. */
int sev_alloc_asid(enum sev_asid_kind asid_kind, u64 *gtx_paddr, int *psp_r=
et)

/* legacy asids free the handle first if not already unbound. SEV-SNP
asids decommission the GCTX page and free the page first. */
int sev_free_asid(int asid, void (*cleanup)(int asid), int *psp_ret);

/* associates ASID with legacy handle and binds it */
int sev_bind_asid_handle(int asid, u32 handle, int *psp_ret);

/* frees a legacy handle associated with the given ASID [deactivate +
decommission] */
int sev_unbind_asid_handle(int asid, int *psp_ret);

Note that the activate / decommission GCTX API additions here are the
SEV-SNP analogy to the bind/unbind for legacy guests.

The sev_unbind_asid_handle function is needed for launch_start's or
receive_start's copy_to_user's failure to undo the successful bind
that preceded it.

This would move all the bitmap and locking onus onto ccp and out of
KVM. I don't see a way to not coordinate deactivation across drivers
awkwardly without also taking ownership of bind/unbind.

> > +     if (!sev_asid_data)
> > +             return -ENOMEM;
> > +
> > +     return 0;
> > +}
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
>
> Move this to the patch that needs them made extern.
>
> Thanks,
> Tom
>
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



--
-Dionna Glaze, PhD, CISSP, CCSP (she/her)
