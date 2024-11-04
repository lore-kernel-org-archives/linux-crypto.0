Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395EC1CBA1A
	for <linux-crypto@vger.kernel.org>; Mon,  4 Nov 2024 19:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730748650; cv=none; b=Z6ekhe655uKMUU66TNwZkmh5C/obTNMkk6Crt4V47/GtzFXcV2URRlTohJTgK+Eho21s09+SDGeMI/STWWu67gOzd2MT6F176K9g++yjGJzTdaS3Rm8D5Nf92sxEWhEQFV4+LqCO9YvpmVZoa1iuYjdlbcT++wMB0fYNBQsjNdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730748650; c=relaxed/simple;
	bh=1XEM96R1RrTpUKQNmCs3XPkvERYUh6h5G28r2ly+VW4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lAWgqHSQtcP0UfW4D6SdEPG1iOeVAW/kKJTExp8VFnrdatSIyrYN4OQF+jHL2UVv+To6CgsMhdWCVIH/XBzHR7xgMP7SchRLqY0LQKHtpOXC3Y8+GLSXZsbE0V/DHl7idETTgsTqOI3A2hqvGgUsEkRjuyqIWizwhXuIV9oz0z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tCbeyMJ2; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tCbeyMJ2"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a9a16b310f5so747667066b.0
        for <linux-crypto@vger.kernel.org>; Mon, 04 Nov 2024 11:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730748645; x=1731353445; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uOuLTUsu72pS+suoZignR5Yx8MhcASO42PLy0wETKbE=;
        b=tCbeyMJ22M2p3OJ6VMSQG3W98Lnj6L0bfH7ZfA9yVvoHQtmTny5up1oQ1W7rcFfIAM
         dcuexSNFIDWrf7VuoVOtgtapz/+03LuJmNMB/0yp92f0NJ8ox8UjysL4GlJvxhHxLcvv
         3c/hDvg4dvYwu+FzjC6H4rS48IRYp5KRhn+qUt6tVsP5Cg0wyiDfjGnExsX0EP99aAVZ
         oBfA5LuKiyxyWYqFSItSbrnwo7iuu3H7C9LPe5qxjbTMgJ+PmZCJZVyLa3+ix+kRGzu9
         a3TIOiHZfhpv/Py5WSrP2eRNk8v0Qqt3tsrCNrM9qJKY32fEFvOHUyDrvWR+LnwoSDFq
         /bAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730748645; x=1731353445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uOuLTUsu72pS+suoZignR5Yx8MhcASO42PLy0wETKbE=;
        b=sVxt8g9k5aKTUemXL5SU9c4LZGIw2CfeGtmEvlpRh+/6hc9akQqS+Kf6bbdVW8yWL7
         3GhP57KRc4UEKbnEs08p5RcMONiThZ58VWqZT5OeQ44N5a/s3/ExKhaRfxGbIU8q/oqs
         W1kxNgoe11czRLrK8QB7YM43zyLD3MFAMRvCSh8rgyBCkmuqRpiZU9c08wKdt9bP44TJ
         dBMNaY+qaIymMZp6WrBl/lGuj5NIQ50OcvXrwSxbMjY2Utxd275Lq9H43kzYvfHQRoQi
         eSkgMgb8xlsiZ4J3LTdKhWO1nj3JQSq4S0hhQyMLid7ZzciTPNE80BF6ZGsiYJ/ZGVhY
         nTxA==
X-Forwarded-Encrypted: i=1; AJvYcCUu4/YnNyxQlvHeNtozsUtRxHaO3KabvHweixrLvdIvDWltnOVvF5vUSks0UR+9NsxGRidh3aRSUSRsgPM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzB5afjYwiJU+oYdXnSA3tKA0CWfVNMyz2vLjgo5CQScfuNaSoy
	CH3AT4ds8HF0HV8sLsQnS+0eWZM7dZt8dQaoYow9czUhCpQqe3Hi7grqDPj1p+MO7kNNoQnXHF2
	IUjbrU1B0YKJQJt2keKq1xRLxI/dPpAoKFvA5
X-Google-Smtp-Source: AGHT+IG55FsqCh3HBhoJofgGD1Y/OLgncxiIYRlymzAzazjkpB1xWbdhm61XfIoJ0RoR+P8JaV451ruqwN4riGNg+Dg=
X-Received: by 2002:a17:907:7242:b0:a99:ee1c:f62f with SMTP id
 a640c23a62f3a-a9e5094307emr1408121066b.34.1730748645176; Mon, 04 Nov 2024
 11:30:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241102000818.2512612-1-dionnaglaze@google.com>
 <20241102000818.2512612-4-dionnaglaze@google.com> <91984541-504a-f029-47ca-bde538e07436@amd.com>
In-Reply-To: <91984541-504a-f029-47ca-bde538e07436@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Mon, 4 Nov 2024 11:30:30 -0800
Message-ID: <CAAH4kHYqQAkUO8phdQaE=R0qHZjKBB1uXsKR3Nq5yJxeZS-o=A@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] crypto: ccp: Add SNP firmware hotload support
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Ashish Kalra <ashish.kalra@amd.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Michael Roth <michael.roth@amd.com>, 
	Luis Chamberlain <mcgrof@kernel.org>, Russ Weight <russ.weight@linux.dev>, 
	Danilo Krummrich <dakr@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Tianfei zhang <tianfei.zhang@intel.com>, 
	Alexey Kardashevskiy <aik@amd.com>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 4, 2024 at 9:06=E2=80=AFAM Tom Lendacky <thomas.lendacky@amd.co=
m> wrote:
>
> On 11/1/24 19:08, Dionna Glaze wrote:
> > uapi changes: The status values added are defined in AMD's SEV-SNP API
> > documentation as new error modes for the DOWNLOAD_FIRMWARE_EX command.
> >
> > On init, the ccp device will make /sys/class/firmware/amd/loading etc
> > firmware upload API attributes available to late-load a SEV-SNP firmwar=
e
> > binary.
> >
> > The firmware upload api errors reported are actionable in the following
> > ways:
> > * FW_UPLOAD_ERR_HW_ERROR: the machine is in an unstable state and must
> >   be reset.
> > * FW_UPLOAD_ERR_RW_ERROR: the firmware update went bad but can be
> >   recovered by hotloading the previous firmware version.
> >   Also used in the case that the kernel used the API wrong (bug).
> > * FW_UPLOAD_ERR_FW_INVALID: user error with the data provided, but no
> >   instability is expected and no recovery actions are needed.
> > * FW_UPLOAD_ERR_BUSY: upload attempted at a bad time either due to
> >   overload or the machine is in the wrong platform state.
> >
> > snp_asid_to_gctx_page_map:
> > Compliance with SEV-SNP API section 3.3 Firmware Updates and 4.1.1
> > Live Update: before a firmware is committed, all active GCTX pages
> > should be updated with SNP_GUEST_STATUS to ensure their data structure
> > remains consistent for the new firmware version.
> > There can only be cpuid_edx(0x8000001f)-1 many SEV-SNP asids in use at
> > one time, so this map associates asid to gctx in order to track which
> > addresses are active gctx pages that need updating. When an asid and
> > gctx page are decommissioned, the page is removed from tracking for
> > update-purposes.
> > Given that GCTX page creation and binding through the SNP_ACTIVATE
> > command are separate, the creation operation also tracks pages that are
> > yet to be bound to an asid.
> >
> > synthetic_restore_required:
> > Instead of tracking the status of whether an individual GCTX is safe fo=
r
> > use in a firmware command, force all following commands to fail with an
> > error that is indicative of needing a firmware rollback.
> >
> > According to SEV-SNP API section 3.3 Firmware Updates, the
> > DOWNLOAD_FIRMWARE_EX command is usable when the SNP firmware is in
> > either UNINIT or INIT states, but SEV-legacy firmware must be in the
> > UNINIT state. A sev_platform_init call when only SEV-SNP VMs are
> > expected should set supports_download_firmware_ex to delay legacy
> > initialization actions.
> > The firmware can only be hotloaded for SEV VMs when legacy
> > initialization has not happened.
> >
> > To test:
> > 1. Build the kernel enabling SEV-SNP as normal and add CONFIG_FW_UPLOAD=
=3Dy.
> > 2. Add the following to your kernel_cmdline: ccp.psp_init_on_probe=3D0.
> > 3.Get an AMD SEV-SNP firmware sbin appropriate to your Epyc chip model =
at
> > https://www.amd.com/en/developer/sev.html and extract to get a .sbin
> > file.
> > 4. Run the following with your sbinfile in FW:
> >
> > echo 1 > /sys/class/firmware/snp_dlfw_ex/loading
> > cat "${FW?}" > /sys/class/firmware/snp_dlfw_ex/data
> > echo 0 > /sys/class/firmware/snp_dlfw_ex/loading
> >
> > 5. Verify the firmware update message in dmesg.
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
> > Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > Tested-by: Ashish Kalra <ashish.kalra@amd.com>
> > Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> > ---
> >  drivers/crypto/ccp/Kconfig   |   2 +
> >  drivers/crypto/ccp/sev-dev.c | 399 ++++++++++++++++++++++++++++++++++-
> >  drivers/crypto/ccp/sev-dev.h |  14 ++
> >  include/linux/psp-sev.h      |  29 +++
> >  include/uapi/linux/psp-sev.h |   5 +
> >  5 files changed, 441 insertions(+), 8 deletions(-)
>
> This is a big patch. Can you split this up into smaller patches? At a
> minimum, one patch that adds the context tracking and one that adds the
> firmware support.
>

Can do. Would it be appropriate to also add a sysfs attribute group
for sev that makes the firmware version more easily readable? Or
should I put that in a follow-up chain?
The dmesg log about the firmware version isn't the best for writing
automation for managing firmware hotloading at scale, and we're better
set up for working with sysfs generally.

> Also, can the guest context page tracking and new firmware related
> functions be placed in a new file, sev-fw.c or similar, that is
> conditionally built based on CONFIG_FW_UPLOAD. Then a header file can be
> used to provide the different implementations of the new functions
> removing the #ifdefs from the code.
>
> Thanks,
> Tom
>
> >
> > diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
> > index f394e45e11ab4..cd9b667640e7c 100644
> > --- a/drivers/crypto/ccp/Kconfig
> > +++ b/drivers/crypto/ccp/Kconfig
> > @@ -39,6 +39,8 @@ config CRYPTO_DEV_SP_PSP
> >       bool "Platform Security Processor (PSP) device"
> >       default y
> >       depends on CRYPTO_DEV_CCP_DD && X86_64 && AMD_IOMMU
> > +     select FW_LOADER
> > +        select FW_UPLOAD
> >       help
> >        Provide support for the AMD Platform Security Processor (PSP).
> >        The PSP is a dedicated processor that provides support for key
> > diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.=
c
> > index 9810edbb272d2..1da183e8a9ebc 100644
> > --- a/drivers/crypto/ccp/sev-dev.c
> > +++ b/drivers/crypto/ccp/sev-dev.c
> > @@ -223,6 +223,7 @@ static int sev_cmd_buffer_len(int cmd)
> >       case SEV_CMD_SNP_GUEST_REQUEST:         return sizeof(struct sev_=
data_snp_guest_request);
> >       case SEV_CMD_SNP_CONFIG:                return sizeof(struct sev_=
user_data_snp_config);
> >       case SEV_CMD_SNP_COMMIT:                return sizeof(struct sev_=
data_snp_commit);
> > +     case SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX:  return sizeof(struct sev_=
data_download_firmware_ex);
> >       default:                                return 0;
> >       }
> >
> > @@ -829,6 +830,7 @@ static int snp_reclaim_cmd_buf(int cmd, void *cmd_b=
uf)
> >       return 0;
> >  }
> >
> > +static void snp_cmd_bookkeeping_locked(int cmd, struct sev_device *sev=
, void *data);
> >  static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
> >  {
> >       struct cmd_buf_desc desc_list[CMD_BUF_DESC_MAX] =3D {0};
> > @@ -852,6 +854,15 @@ static int __sev_do_cmd_locked(int cmd, void *data=
, int *psp_ret)
> >       if (WARN_ON_ONCE(!data !=3D !buf_len))
> >               return -EINVAL;
> >
> > +     /* The firmware does not coordinate all GCTX page updates. Force =
an
> > +      * error to ensure that no new VM can be started and no active VM=
 makes
> > +      * progress on guest requests until the firmware is rolled back.
> > +      */
> > +     if (sev->synthetic_restore_required) {
> > +             *psp_ret =3D SEV_RET_RESTORE_REQUIRED;
> > +             return -EBUSY;
> > +     }
> > +
> >       /*
> >        * Copy the incoming data to driver's scratch buffer as __pa() wi=
ll not
> >        * work for some memory, e.g. vmalloc'd addresses, and @data may =
not be
> > @@ -982,6 +993,9 @@ static int __sev_do_cmd_locked(int cmd, void *data,=
 int *psp_ret)
> >       print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
> >                            buf_len, false);
> >
> > +     if (!ret)
> > +             snp_cmd_bookkeeping_locked(cmd, sev, data);
> > +
> >       return ret;
> >  }
> >
> > @@ -1082,6 +1096,7 @@ static int snp_filter_reserved_mem_regions(struct=
 resource *rs, void *arg)
> >       return 0;
> >  }
> >
> > +static int sev_snp_platform_init_firmware_upload(struct sev_device *se=
v);
> >  static int __sev_snp_init_locked(int *error)
> >  {
> >       struct psp_device *psp =3D psp_master;
> > @@ -1179,6 +1194,8 @@ static int __sev_snp_init_locked(int *error)
> >
> >       sev_es_tmr_size =3D SNP_TMR_SIZE;
> >
> > +     rc =3D sev_snp_platform_init_firmware_upload(sev);
> > +
> >       return rc;
> >  }
> >
> > @@ -1326,6 +1343,13 @@ static int _sev_platform_init_locked(struct sev_=
platform_init_args *args)
> >       if (args->probe && !psp_init_on_probe)
> >               return 0;
> >
> > +     /*
> > +      * Defer legacy SEV/SEV-ES support if legacy VMs are not being la=
unched
> > +      * and module psp_init_on_probe parameter is false.
> > +      */
> > +     if (args->supports_download_firmware_ex && !psp_init_on_probe)
> > +             return 0;
> > +
> >       return __sev_platform_init_locked(&args->error);
> >  }
> >
> > @@ -1592,14 +1616,8 @@ static int sev_update_firmware(struct device *de=
v)
> >               return -1;
> >       }
> >
> > -     /*
> > -      * SEV FW expects the physical address given to it to be 32
> > -      * byte aligned. Memory allocated has structure placed at the
> > -      * beginning followed by the firmware being passed to the SEV
> > -      * FW. Allocate enough memory for data structure + alignment
> > -      * padding + SEV FW.
> > -      */
> > -     data_size =3D ALIGN(sizeof(struct sev_data_download_firmware), 32=
);
> > +     data_size =3D ALIGN(sizeof(struct sev_data_download_firmware),
> > +                       SEV_FW_ALIGNMENT);
> >
> >       order =3D get_order(firmware->size + data_size);
> >       p =3D alloc_pages(GFP_KERNEL, order);
> > @@ -2224,6 +2242,367 @@ static int sev_misc_init(struct sev_device *sev=
)
> >       return 0;
> >  }
> >
> > +#ifdef CONFIG_FW_UPLOAD
> > +
> > +static enum fw_upload_err snp_dlfw_ex_prepare(struct fw_upload *fw_upl=
oad,
> > +                                           const u8 *data, u32 size)
> > +{
> > +     return FW_UPLOAD_ERR_NONE;
> > +}
> > +
> > +static enum fw_upload_err snp_dlfw_ex_poll_complete(struct fw_upload *=
fw_upload)
> > +{
> > +     return FW_UPLOAD_ERR_NONE;
> > +}
> > +
> > +/*
> > + * This may be called asynchronously with an on-going update.  All oth=
er
> > + * functions are called sequentially in a single thread. To avoid cont=
ention on
> > + * register accesses, only update the cancel_request flag. Other funct=
ions will
> > + * check this flag and handle the cancel request synchronously.
> > + */
> > +static void snp_dlfw_ex_cancel(struct fw_upload *fw_upload)
> > +{
> > +     struct sev_device *sev =3D psp_master->sev_data;
> > +
> > +     mutex_lock(&sev->fw_lock);
> > +     sev->fw_cancel =3D true;
> > +     mutex_unlock(&sev->fw_lock);
> > +}
> > +
> > +static enum fw_upload_err snp_dlfw_ex_err_translate(struct sev_device =
*sev, int psp_ret)
> > +{
> > +     dev_dbg(sev->dev, "Failed to update SEV firmware: %#x\n", psp_ret=
);
> > +     /*
> > +      * Operation error:
> > +      *   HW_ERROR: Critical error. Machine needs repairs now.
> > +      *   RW_ERROR: Severe error. Roll back to the prior version to re=
cover.
> > +      * User error:
> > +      *   FW_INVALID: Bad input for this interface.
> > +      *   BUSY: Wrong machine state to run download_firmware_ex.
> > +      */
> > +     switch (psp_ret) {
> > +     case SEV_RET_RESTORE_REQUIRED:
> > +             dev_warn(sev->dev, "Firmware updated but unusable\n");
> > +             dev_warn(sev->dev, "Need to do manual firmware rollback!!=
!\n");
> > +             return FW_UPLOAD_ERR_RW_ERROR;
> > +     case SEV_RET_SHUTDOWN_REQUIRED:
> > +             /* No state changes made. Not a hardware error. */
> > +             dev_warn(sev->dev, "Firmware image cannot be live updated=
\n");
> > +             return FW_UPLOAD_ERR_FW_INVALID;
> > +     case SEV_RET_BAD_VERSION:
> > +             /* No state changes made. Not a hardware error. */
> > +             dev_warn(sev->dev, "Firmware image is not well formed\n")=
;
> > +             return FW_UPLOAD_ERR_FW_INVALID;
> > +             /* SEV-specific errors that can still happen. */
> > +     case SEV_RET_BAD_SIGNATURE:
> > +             /* No state changes made. Not a hardware error. */
> > +             dev_warn(sev->dev, "Firmware image signature is bad\n");
> > +             return FW_UPLOAD_ERR_FW_INVALID;
> > +     case SEV_RET_INVALID_PLATFORM_STATE:
> > +             /* Calling at the wrong time. Not a hardware error. */
> > +             dev_warn(sev->dev, "Firmware not updated as SEV in INIT s=
tate\n");
> > +             return FW_UPLOAD_ERR_BUSY;
> > +     case SEV_RET_HWSEV_RET_UNSAFE:
> > +             dev_err(sev->dev, "Firmware is unstable. Reset your machi=
ne!!!\n");
> > +             return FW_UPLOAD_ERR_HW_ERROR;
> > +             /* Kernel bug cases. */
> > +     case SEV_RET_INVALID_PARAM:
> > +             dev_err(sev->dev, "Download-firmware-EX invalid parameter=
\n");
> > +             return FW_UPLOAD_ERR_RW_ERROR;
> > +     case SEV_RET_INVALID_ADDRESS:
> > +             dev_err(sev->dev, "Download-firmware-EX invalid address\n=
");
> > +             return FW_UPLOAD_ERR_RW_ERROR;
> > +     default:
> > +             dev_err(sev->dev, "Unhandled download_firmware_ex err %d\=
n", psp_ret);
> > +             return FW_UPLOAD_ERR_HW_ERROR;
> > +     }
> > +}
> > +
> > +static enum fw_upload_err snp_dlfw_ex_write(struct fw_upload *fwl, con=
st u8 *data,
> > +                                         u32 offset, u32 size, u32 *wr=
itten)
> > +{
> > +     struct sev_data_download_firmware_ex *data_ex;
> > +     struct sev_data_snp_guest_status status_data;
> > +     struct sev_device *sev =3D fwl->dd_handle;
> > +     void *snp_guest_status, *fw_dest;
> > +     u8 api_major, api_minor, build;
> > +     int ret, error, order;
> > +     struct page *p;
> > +     u64 data_size;
> > +     bool cancel;
> > +
> > +     if (!sev)
> > +             return FW_UPLOAD_ERR_HW_ERROR;
> > +
> > +     mutex_lock(&sev->fw_lock);
> > +     cancel =3D sev->fw_cancel;
> > +     mutex_unlock(&sev->fw_lock);
> > +
> > +     if (cancel)
> > +             return FW_UPLOAD_ERR_CANCELED;
> > +
> > +     /*
> > +      * SEV firmware update is a one-shot update operation, the write(=
)
> > +      * callback to be invoked multiple times for the same update is
> > +      * unexpected.
> > +      */
> > +     if (offset)
> > +             return FW_UPLOAD_ERR_INVALID_SIZE;
> > +
> > +     if (sev_get_api_version())
> > +             return FW_UPLOAD_ERR_HW_ERROR;
> > +
> > +     api_major =3D sev->api_major;
> > +     api_minor =3D sev->api_minor;
> > +     build     =3D sev->build;
> > +
> > +     data_size =3D ALIGN(sizeof(struct sev_data_download_firmware_ex),
> > +                       SEV_FW_ALIGNMENT);
> > +
> > +     order =3D get_order(size + data_size);
> > +     p =3D alloc_pages(GFP_KERNEL, order);
> > +     if (!p) {
> > +             ret =3D FW_UPLOAD_ERR_INVALID_SIZE;
> > +             goto fw_err;
> > +     }
> > +
> > +     /*
> > +      * Copy firmware data to a kernel allocated contiguous
> > +      * memory region.
> > +      */
> > +     data_ex =3D page_address(p);
> > +     fw_dest =3D page_address(p) + data_size;
> > +     memset(data_ex, 0, data_size);
> > +     memcpy(fw_dest, data, size);
> > +
> > +     data_ex->address =3D __psp_pa(fw_dest);
> > +     data_ex->len =3D size;
> > +     data_ex->cmdlen =3D sizeof(struct sev_data_download_firmware_ex);
> > +
> > +     /*
> > +      * SNP_COMMIT should be issued explicitly to commit the updated
> > +      * firmware after guest context pages have been updated.
> > +      */
> > +
> > +     ret =3D sev_do_cmd(SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX, data_ex, &er=
ror);
> > +
> > +     if (ret) {
> > +             ret =3D snp_dlfw_ex_err_translate(sev, error);
> > +             goto free_err;
> > +     }
> > +
> > +     __free_pages(p, order);
> > +
> > +     /* Need to do a DF_FLUSH after live firmware update */
> > +     wbinvd_on_all_cpus();
> > +     ret =3D __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, &error);
> > +     if (ret) {
> > +             dev_dbg(sev->dev, "DF_FLUSH error %d\n", error);
> > +             ret =3D FW_UPLOAD_ERR_HW_ERROR;
> > +             goto fw_err;
> > +     }
> > +
> > +     sev_get_api_version();
> > +
> > +     /*
> > +      * Force an update of guest context pages after SEV firmware
> > +      * live update by issuing SNP_GUEST_STATUS on all guest
> > +      * context pages.
> > +      */
> > +     snp_guest_status =3D sev_fw_alloc(PAGE_SIZE);
> > +     if (!snp_guest_status) {
> > +             ret =3D FW_UPLOAD_ERR_INVALID_SIZE;
> > +             goto fw_err;
> > +     }
> > +
> > +     /*
> > +      * After the last bound asid-to-gctx page is snp_unbound_gctx_end=
-many
> > +      * unbound gctx pages that also need updating.
> > +      */
> > +     for (int i =3D 1; i <=3D sev->last_snp_asid + sev->snp_unbound_gc=
tx_end; i++) {
> > +             if (sev->snp_asid_to_gctx_pages_map[i]) {
> > +                     status_data.gctx_paddr =3D sev->snp_asid_to_gctx_=
pages_map[i];
> > +                     status_data.address =3D __psp_pa(snp_guest_status=
);
> > +                     ret =3D sev_do_cmd(SEV_CMD_SNP_GUEST_STATUS, &sta=
tus_data, &error);
> > +                     if (ret) {
> > +                             /*
> > +                              * Handle race with SNP VM being destroye=
d/decommissoned,
> > +                              * if guest context page invalid error is=
 returned,
> > +                              * assume guest has been destroyed.
> > +                              */
> > +                             if (error =3D=3D SEV_RET_INVALID_GUEST)
> > +                                     continue;
> > +                             sev->synthetic_restore_required =3D true;
> > +                             dev_err(sev->dev, "SNP GCTX update error:=
 %#x\n", error);
> > +                             dev_err(sev->dev, "Roll back SNP firmware=
!\n");
> > +                             snp_free_firmware_page(snp_guest_status);
> > +                             ret =3D FW_UPLOAD_ERR_RW_ERROR;
> > +                             goto fw_err;
> > +                     }
> > +             }
> > +     }
> > +     snp_free_firmware_page(snp_guest_status);
> > +
> > +     if (api_major !=3D sev->api_major || api_minor !=3D sev->api_mino=
r ||
> > +         build !=3D sev->build) {
> > +             dev_info(sev->dev, "SEV firmware updated from %d.%d.%d to=
 %d.%d.%d\n",
> > +                      api_major, api_minor, build,
> > +                      sev->api_major, sev->api_minor, sev->build);
> > +     } else {
> > +             dev_info(sev->dev, "SEV firmware same as old %d.%d.%d\n",
> > +                      api_major, api_minor, build);
> > +     }
> > +
> > +     *written =3D size;
> > +     return FW_UPLOAD_ERR_NONE;
> > +
> > +free_err:
> > +     __free_pages(p, order);
> > +fw_err:
> > +     return ret;
> > +}
> > +
> > +static const struct fw_upload_ops snp_dlfw_ex_ops =3D {
> > +     .prepare =3D snp_dlfw_ex_prepare,
> > +     .write =3D snp_dlfw_ex_write,
> > +     .poll_complete =3D snp_dlfw_ex_poll_complete,
> > +     .cancel =3D snp_dlfw_ex_cancel,
> > +};
> > +
> > +static void sev_snp_dev_init_firmware_upload(struct sev_device *sev)
> > +{
> > +     struct fw_upload *fwl;
> > +
> > +     fwl =3D firmware_upload_register(THIS_MODULE, sev->dev, "snp_dlfw=
_ex", &snp_dlfw_ex_ops, sev);
> > +
> > +     if (IS_ERR(fwl))
> > +             dev_err(sev->dev, "SEV firmware upload initialization err=
or %ld\n", PTR_ERR(fwl));
> > +
> > +     sev->fwl =3D fwl;
> > +     mutex_init(&sev->fw_lock);
> > +}
> > +
> > +static void sev_snp_destroy_firmware_upload(struct sev_device *sev)
> > +{
> > +     firmware_upload_unregister(sev->fwl);
> > +}
> > +
> > +/*
> > + * After a gctx is created, it is used by snp_launch_start before gett=
ing
> > + * bound to an asid. The launch protocol allocates an asid before crea=
ting a
> > + * matching gctx page, so there should never be more unbound gctx page=
s than
> > + * there are possible SNP asids.
> > + *
> > + * The unbound gctx pages must be updated after executing DOWNLOAD_FIR=
MWARE_EX
> > + * and before committing the firmware.
> > + */
> > +static void snp_gctx_create_track_locked(struct sev_device *sev, void =
*data)
> > +{
> > +     struct sev_data_snp_addr *gctx_create =3D data;
> > +
> > +     /* This condition should never happen, but is needed for memory s=
afety. */
> > +     if (sev->snp_unbound_gctx_end >=3D sev->last_snp_asid) {
> > +             dev_warn(sev->dev, "Too many unbound SNP GCTX pages to tr=
ack\n");
> > +             return;
> > +     }
> > +
> > +     sev->snp_unbound_gctx_pages[sev->snp_unbound_gctx_end] =3D gctx_c=
reate->address;
> > +     sev->snp_unbound_gctx_end++;
> > +}
> > +
> > +/*
> > + * PREREQUISITE: The snp_activate command was successful, meaning the =
asid
> > + * is in the acceptable range 1..sev->last_snp_asid.
> > + *
> > + * The gctx_paddr must be in the unbound gctx buffer.
> > + */
> > +static void snp_activate_track_locked(struct sev_device *sev, void *da=
ta)
> > +{
> > +     struct sev_data_snp_activate *data_activate =3D data;
> > +
> > +     sev->snp_asid_to_gctx_pages_map[data_activate->asid] =3D data_act=
ivate->gctx_paddr;
> > +
> > +     for (int i =3D 0; i < sev->snp_unbound_gctx_end; i++) {
> > +             if (sev->snp_unbound_gctx_pages[i] =3D=3D data_activate->=
gctx_paddr) {
> > +                     /*
> > +                      * Swap the last unbound gctx page with the now-b=
ound
> > +                      * gctx page to shrink the buffer.
> > +                      */
> > +                     sev->snp_unbound_gctx_end--;
> > +                     sev->snp_unbound_gctx_pages[i] =3D
> > +                             sev->snp_unbound_gctx_pages[sev->snp_unbo=
und_gctx_end];
> > +                     sev->snp_unbound_gctx_pages[sev->snp_unbound_gctx=
_end] =3D 0;
> > +                     break;
> > +             }
> > +     }
> > +}
> > +
> > +static void snp_decommission_track_locked(struct sev_device *sev, void=
 *data)
> > +{
> > +     struct sev_data_snp_addr *data_decommission =3D data;
> > +
> > +     for (int i =3D 1; i <=3D sev->last_snp_asid; i++) {
> > +             if (sev->snp_asid_to_gctx_pages_map[i] =3D=3D data_decomm=
ission->address) {
> > +                     sev->snp_asid_to_gctx_pages_map[i] =3D 0;
> > +                     break;
> > +             }
> > +     }
> > +}
> > +
> > +static void snp_cmd_bookkeeping_locked(int cmd, struct sev_device *sev=
, void *data)
> > +{
> > +     if (!sev->snp_asid_to_gctx_pages_map)
> > +             return;
> > +
> > +     switch (cmd) {
> > +     case SEV_CMD_SNP_GCTX_CREATE:
> > +             snp_gctx_create_track_locked(sev, data);
> > +             break;
> > +     case SEV_CMD_SNP_ACTIVATE:
> > +             snp_activate_track_locked(sev, data);
> > +             break;
> > +     case SEV_CMD_SNP_DECOMMISSION:
> > +             snp_decommission_track_locked(sev, data);
> > +             break;
> > +     default:
> > +             break;
> > +     }
> > +}
> > +
> > +static int sev_snp_platform_init_firmware_upload(struct sev_device *se=
v)
> > +{
> > +     u32 max_snp_asid;
> > +
> > +     /*
> > +      * cpuid_edx(0x8000001f) is the minimum SEV ASID, hence the exclu=
sive
> > +      * maximum SEV-SNP ASID. Save the inclusive maximum to avoid conf=
using
> > +      * logic elsewhere.
> > +      */
> > +     max_snp_asid =3D cpuid_edx(0x8000001f);
> > +     sev->last_snp_asid =3D max_snp_asid - 1;
> > +     if (sev->last_snp_asid) {
> > +             sev->snp_asid_to_gctx_pages_map =3D devm_kmalloc_array(
> > +                     sev->dev, max_snp_asid * 2, sizeof(u64), GFP_KERN=
EL | __GFP_ZERO);
> > +             sev->snp_unbound_gctx_pages =3D &sev->snp_asid_to_gctx_pa=
ges_map[max_snp_asid];
> > +             if (!sev->snp_asid_to_gctx_pages_map) {
> > +                     kfree(snp_range_list);
> > +                     dev_err(sev->dev,
> > +                             "SEV-SNP: snp_asid_to_gctx_pages_map memo=
ry allocation failed\n");
> > +                     return -ENOMEM;
> > +             }
> > +     }
> > +     return 0;
> > +}
> > +
> > +#else
> > +
> > +static int sev_snp_platform_init_firmware_upload(struct sev_device *se=
v) { return 0; }
> > +static void sev_snp_dev_init_firmware_upload(struct sev_device *sev) {=
 }
> > +static void sev_snp_destroy_firmware_upload(struct sev_device *sev) { =
}
> > +static void snp_cmd_bookkeeping_locked(int cmd, struct sev_device *sev=
, void *data) { }
> > +#endif
> > +
> >  int sev_dev_init(struct psp_device *psp)
> >  {
> >       struct device *dev =3D psp->dev;
> > @@ -2265,6 +2644,8 @@ int sev_dev_init(struct psp_device *psp)
> >       if (ret)
> >               goto e_irq;
> >
> > +     sev_snp_dev_init_firmware_upload(sev);
> > +
> >       dev_notice(dev, "sev enabled\n");
> >
> >       return 0;
> > @@ -2343,6 +2724,8 @@ void sev_dev_destroy(struct psp_device *psp)
> >               kref_put(&misc_dev->refcount, sev_exit);
> >
> >       psp_clear_sev_irq_handler(psp);
> > +
> > +     sev_snp_destroy_firmware_upload(sev);
> >  }
> >
> >  static int snp_shutdown_on_panic(struct notifier_block *nb,
> > diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.=
h
> > index 3e4e5574e88a3..d6280688675d9 100644
> > --- a/drivers/crypto/ccp/sev-dev.h
> > +++ b/drivers/crypto/ccp/sev-dev.h
> > @@ -57,6 +57,20 @@ struct sev_device {
> >       bool cmd_buf_backup_active;
> >
> >       bool snp_initialized;
> > +
> > +#ifdef CONFIG_FW_UPLOAD
> > +     /* Lock to protect fw_cancel */
> > +     struct mutex fw_lock;
> > +     struct fw_upload *fwl;
> > +     bool fw_cancel;
> > +
> > +     /* Firmware update management. */
> > +     u32 last_snp_asid;
> > +     bool synthetic_restore_required;
> > +     u64 *snp_asid_to_gctx_pages_map;
> > +     u64 *snp_unbound_gctx_pages;
> > +     u32 snp_unbound_gctx_end;
> > +#endif /* CONFIG_FW_UPLOAD */
> >  };
> >
> >  int sev_dev_init(struct psp_device *psp);
> > diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> > index 903ddfea85850..ff7f9e33f3335 100644
> > --- a/include/linux/psp-sev.h
> > +++ b/include/linux/psp-sev.h
> > @@ -16,6 +16,15 @@
> >
> >  #define SEV_FW_BLOB_MAX_SIZE 0x4000  /* 16KB */
> >
> > +/*
> > + * SEV FW expects the physical address given to it to be 32
> > + * byte aligned. Memory allocated has structure placed at the
> > + * beginning followed by the firmware being passed to the SEV
> > + * FW. Allocate enough memory for data structure + alignment
> > + * padding + SEV FW.
> > + */
> > +#define SEV_FW_ALIGNMENT     32
> > +
> >  /**
> >   * SEV platform state
> >   */
> > @@ -185,6 +194,23 @@ struct sev_data_download_firmware {
> >       u32 len;                                /* In */
> >  } __packed;
> >
> > +/**
> > + * struct sev_data_download_firmware_ex - DOWNLOAD_FIRMWARE_EX command=
 parameters
> > + *
> > + * @length: length of this command buffer
> > + * @address: physical address of firmware image
> > + * @len: len of the firmware image
> > + * @commit: automatically commit the newly installed image
> > + */
> > +struct sev_data_download_firmware_ex {
> > +     u32 cmdlen;                             /* In */
> > +     u32 reserved;                           /* in */
> > +     u64 address;                            /* In */
> > +     u32 len;                                /* In */
> > +     u32 commit:1;                           /* In */
> > +     u32 reserved2:31;                       /* In */
> > +} __packed;
> > +
> >  /**
> >   * struct sev_data_get_id - GET_ID command parameters
> >   *
> > @@ -797,10 +823,13 @@ struct sev_data_snp_shutdown_ex {
> >   * @probe: True if this is being called as part of CCP module probe, w=
hich
> >   *  will defer SEV_INIT/SEV_INIT_EX firmware initialization until need=
ed
> >   *  unless psp_init_on_probe module param is set
> > + * @supports_download_firmware_ex: True if legacy SEV/SEV-ES guests ar=
e not
> > + *  being launched via KVM
> >   */
> >  struct sev_platform_init_args {
> >       int error;
> >       bool probe;
> > +     bool supports_download_firmware_ex;
> >  };
> >
> >  /**
> > diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.=
h
> > index 832c15d9155bd..936464d4f282a 100644
> > --- a/include/uapi/linux/psp-sev.h
> > +++ b/include/uapi/linux/psp-sev.h
> > @@ -80,6 +80,11 @@ typedef enum {
> >       SEV_RET_INVALID_PAGE_OWNER,
> >       SEV_RET_INVALID_PAGE_AEAD_OFLOW,
> >       SEV_RET_RMP_INIT_REQUIRED,
> > +     SEV_RET_BAD_SVN,
> > +     SEV_RET_BAD_VERSION,
> > +     SEV_RET_SHUTDOWN_REQUIRED,
> > +     SEV_RET_UPDATE_FAILED,
> > +     SEV_RET_RESTORE_REQUIRED,
> >       SEV_RET_MAX,
> >  } sev_ret_code;
> >



--
-Dionna Glaze, PhD, CISSP, CCSP (she/her)
