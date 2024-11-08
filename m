Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630B71F26DD
	for <linux-crypto@vger.kernel.org>; Fri,  8 Nov 2024 22:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731104033; cv=none; b=bKHVCanaEI7JS5j1d2w2GlhBAzsunMLl7fUtvf7YCmi5Dl1qlvTRTvR0bNDTWNZSufNr/TgGNub/BuBRJ04Wt57vUTJbUPhJG1IBPKRgqHucihNxH/cWLA1nVuvjlSSx2q/P4xboG63SQXIk2jb1tjSWv1ZdPRpNqEA+Iii79yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731104033; c=relaxed/simple;
	bh=Kn9JvHUZiqTJcoKmoR2whf4gfwBosv9nPCLomyk+IBE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DdFaqrcTJmjjSfkegMUGHiCBfDT5HBRhFokqeOTkPPbTl3PO6qWnGkl6WJeRz1UVeXzGeqCR8V24nkE4RRcZw1dzsxv31BRGM1mZ8bIM2iZOw2TOr4N7d5Lzkxe00HwWwEFUtzv038Q9/wkMNazSmz5jnVoPgY0RJKa/0V+NIS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YIY7exsU; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YIY7exsU"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a99e3b3a411so628503866b.0
        for <linux-crypto@vger.kernel.org>; Fri, 08 Nov 2024 14:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731104030; x=1731708830; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ktESlYtEEKhAfIptSYVOpjX8uFBd+LeVGbqyH4nxjzk=;
        b=YIY7exsUNjXfZ1HCsa3IsHoVS1LujUk/hJpnitMk3e3oWakFBTCrQDjd7pZBCqM+VV
         5kZ2KBNHecGKguZHx1vwVH0akkwp14N3a0ibTDUwyVlnqE9uhQXllHeYrZBHMluScXR8
         qr1f7DcVl1n1aztY7i49IMsKlSNY+VWY1MSDtiEajWGs2YDkUkvwpG84hWGQxOZNfUg3
         8m6PcLMJ2amAhA+nhiPafSk7zFENmC6U7Zh7HIhtrZ75ENqC9zeIqBzK9hSX9PDGNr8Q
         dRj6RtjSB3+2RFf3lNJUupPeqAYZ68oI2BckI/aJeG4UfinHXIOhsG0rfa+RLr0f/qXc
         z8yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731104030; x=1731708830;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ktESlYtEEKhAfIptSYVOpjX8uFBd+LeVGbqyH4nxjzk=;
        b=b+EnjB8Gbv+xJyyitzAwgTBxtnhlna7BX008+8xdPCbhjYR/e80UVgNhZ3KmxkUB/F
         dccOZkYEHSB75DJnmv+7ORHacZemT/Rf0Bvf3duIKTTEH6no2Qd4W7jUtfOGKGpevlQU
         fZwUeEc+aDA6obJHNw4QJ0pzcCJemAK7F1I0zBmg7pK6VleRJz+565nrfIOlN3Gc2oQh
         DvEtZ6beIgqdd76zr74+fCT9vCxXJz5UvbcLeDq8qi0TMuV0Zx+Pw3kTdPECEMXfK9A5
         ulKd9QWVjFg8rmM3xmcY8lTeuuZUywgJIe3Ejkx0oJBClslIFjaGGAUX7YcZLZquKurP
         jGSQ==
X-Forwarded-Encrypted: i=1; AJvYcCU76B/LraZJ8VjPIfLVVsVFNZajFIxLs04eeZn1/keWUFYuxax002zIyt+4q40RlZx2uJfqjnWJynyQKL4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoIL/DqTvR+kwq0sJMm3o3yow43acqo4VwfZF5gRg74povng6L
	58M/dd4xlSjcZ6t3k2GhBeFfpK4hxx8Op/lZQypzPOoByGV0DvK+wkbwoj71gr2LZbsyqsHt630
	TPEDeTjskq+/tMFI5VpTJgKsBP9ldaCjMJTV/
X-Google-Smtp-Source: AGHT+IGVlp6LgoP4+q+xHM+vFERKg77MVWvYTEyNeTpQXgRbhXlELO8CUV9AdWQMqSRuz2GiX15HtIGPR2Jgv4i5RkM=
X-Received: by 2002:a17:907:c09:b0:a9a:6c41:50a8 with SMTP id
 a640c23a62f3a-a9eec9c36fbmr500837866b.17.1731104029507; Fri, 08 Nov 2024
 14:13:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241107232457.4059785-1-dionnaglaze@google.com>
 <20241107232457.4059785-7-dionnaglaze@google.com> <b726e3ba-7218-de96-f986-207fd749955e@amd.com>
In-Reply-To: <b726e3ba-7218-de96-f986-207fd749955e@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Fri, 8 Nov 2024 14:13:38 -0800
Message-ID: <CAAH4kHYiJpbYYRj1KCO5ucQTP3qFw3yJdyQEEVEfhmbskMsQag@mail.gmail.com>
Subject: Re: [PATCH v5 06/10] crypto: ccp: Add DOWNLOAD_FIRMWARE_EX support
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Ashish Kalra <ashish.kalra@amd.com>, linux-coco@lists.linux.dev, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Michael Roth <michael.roth@amd.com>, 
	Luis Chamberlain <mcgrof@kernel.org>, Russ Weight <russ.weight@linux.dev>, 
	Danilo Krummrich <dakr@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Tianfei zhang <tianfei.zhang@intel.com>, 
	Alexey Kardashevskiy <aik@amd.com>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 8, 2024 at 9:44=E2=80=AFAM Tom Lendacky <thomas.lendacky@amd.co=
m> wrote:
>
> On 11/7/24 17:24, Dionna Glaze wrote:
> > In order to support firmware hotloading, the DOWNLOAD_FIRMWARE_EX
> > command must be available.
> >
> > The DOWNLOAD_FIRMWARE_EX command requires cache flushing and introduces
> > new error codes that could be returned to user space.
> >
> > Access to the command is through the firmware_upload API rather than
> > through the ioctl interface to prefer a common interface.
> >
> > On init, the ccp device will make /sys/class/firmware/amd/loading etc
> > firmware upload API attributes available to late-load a SEV-SNP firmwar=
e
> > binary.
> >
> > The firmware_upload API errors reported are actionable in the following
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
> > synthetic_restore_required:
> > Instead of tracking the status of whether an individual GCTX is safe fo=
r
> > use in a firmware command, force all following commands to fail with an
> > error that is indicative of needing a firmware rollback.
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
> > Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> > ---
> >  drivers/crypto/ccp/Kconfig   |  10 ++
> >  drivers/crypto/ccp/Makefile  |   1 +
> >  drivers/crypto/ccp/sev-dev.c |  22 +--
> >  drivers/crypto/ccp/sev-dev.h |  27 ++++
> >  drivers/crypto/ccp/sev-fw.c  | 267 +++++++++++++++++++++++++++++++++++
> >  include/linux/psp-sev.h      |  17 +++
> >  6 files changed, 334 insertions(+), 10 deletions(-)
> >  create mode 100644 drivers/crypto/ccp/sev-fw.c
> >
> > diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
> > index f394e45e11ab4..40be991f15d28 100644
> > --- a/drivers/crypto/ccp/Kconfig
> > +++ b/drivers/crypto/ccp/Kconfig
> > @@ -46,6 +46,16 @@ config CRYPTO_DEV_SP_PSP
> >        along with software-based Trusted Execution Environment (TEE) to
> >        enable third-party trusted applications.
> >
> > +config CRYPTO_DEV_SP_PSP_FW_UPLOAD
> > +     bool "Platform Security Processor (PSP) device with firmware hotl=
oading"
> > +     default y
> > +     depends on CRYPTO_DEV_SP_PSP && FW_LOADER && FW_UPLOAD
> > +     help
> > +      Provide support for AMD Platform Security Processor firmware.
> > +      The PSP firmware can be updated while no SEV or SEV-ES VMs are a=
ctive.
> > +      Users of this feature should be aware of the error modes that in=
dicate
> > +      required manual rollback or reset due to instablity.
> > +
> >  config CRYPTO_DEV_CCP_DEBUGFS
> >       bool "Enable CCP Internals in DebugFS"
> >       default n
> > diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
> > index 394484929dae3..5ce69134ec48b 100644
> > --- a/drivers/crypto/ccp/Makefile
> > +++ b/drivers/crypto/ccp/Makefile
> > @@ -14,6 +14,7 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) +=3D psp-dev.o \
> >                                     platform-access.o \
> >                                     dbc.o \
> >                                     hsti.o
> > +ccp-$(CONFIG_CRYPTO_DEV_SP_PSP_FW_UPLOAD) +=3D sev-fw.o
> >
> >  obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) +=3D ccp-crypto.o
> >  ccp-crypto-objs :=3D ccp-crypto-main.o \
> > diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.=
c
> > index 036e8d5054fcc..498ec8a0deeca 100644
> > --- a/drivers/crypto/ccp/sev-dev.c
> > +++ b/drivers/crypto/ccp/sev-dev.c
> > @@ -227,6 +227,7 @@ static int sev_cmd_buffer_len(int cmd)
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
> > @@ -488,7 +489,7 @@ void snp_free_firmware_page(void *addr)
> >  }
> >  EXPORT_SYMBOL_GPL(snp_free_firmware_page);
> >
> > -static void *sev_fw_alloc(unsigned long len)
> > +void *sev_fw_alloc(unsigned long len)
> >  {
> >       struct page *page;
> >
> > @@ -856,6 +857,10 @@ static int __sev_do_cmd_locked(int cmd, void *data=
, int *psp_ret)
> >       if (WARN_ON_ONCE(!data !=3D !buf_len))
> >               return -EINVAL;
> >
>
> Please put a comment here on the reason for this call being here.
>

Done.


> > +     ret =3D sev_snp_synthetic_error(sev, psp_ret);
> > +     if (ret)
> > +             return ret;
> > +
> >       /*
> >        * Copy the incoming data to driver's scratch buffer as __pa() wi=
ll not
> >        * work for some memory, e.g. vmalloc'd addresses, and @data may =
not be
> > @@ -1632,7 +1637,7 @@ void *psp_copy_user_blob(u64 uaddr, u32 len)
> >  }
> >  EXPORT_SYMBOL_GPL(psp_copy_user_blob);
> >
> > -static int sev_get_api_version(void)
> > +int sev_get_api_version(void)
> >  {
> >       struct sev_device *sev =3D psp_master->sev_data;
> >       struct sev_user_data_status status;
> > @@ -1707,14 +1712,7 @@ static int sev_update_firmware(struct device *de=
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
> > +     data_size =3D ALIGN(sizeof(struct sev_data_download_firmware), SE=
V_FW_ALIGNMENT);
> >
> >       order =3D get_order(firmware->size + data_size);
> >       p =3D alloc_pages(GFP_KERNEL, order);
> > @@ -2378,6 +2376,8 @@ int sev_dev_init(struct psp_device *psp)
> >       if (ret)
> >               goto e_irq;
> >
> > +     sev_snp_dev_init_firmware_upload(sev);
>
> sev_snp_init_firmware_upload
>
> Hmmm... I made these comments before but they haven't been incorporated.
> Please go back and check all the previous series comments and say whether
> you agree or disagree so that I can expect the review changes to be
> present or not.
>

My bad. I thought I had gotten everything.

Amendments in https://github.com/deeglaze/amdese-linux/tree/snp_hotload-v6

> > +
> >       dev_notice(dev, "sev enabled\n");
> >
> >       return 0;
> > @@ -2459,6 +2459,8 @@ void sev_dev_destroy(struct psp_device *psp)
> >               kref_put(&misc_dev->refcount, sev_exit);
> >
> >       psp_clear_sev_irq_handler(psp);
> > +
> > +     sev_snp_dev_init_firmware_upload(sev);
>
> destroy not init, as commented previously.
>

Got it.

> >  }
> >
> >  static int snp_shutdown_on_panic(struct notifier_block *nb,
> > diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.=
h
> > index 7d0fdfdda30b6..db65d2c7afe9b 100644
> > --- a/drivers/crypto/ccp/sev-dev.h
> > +++ b/drivers/crypto/ccp/sev-dev.h
> > @@ -29,6 +29,15 @@
> >  #define SEV_CMD_COMPLETE             BIT(1)
> >  #define SEV_CMDRESP_IOC                      BIT(0)
> >
> > +/*
> > + * SEV FW expects the physical address given to it to be 32
> > + * byte aligned. Memory allocated has structure placed at the
> > + * beginning followed by the firmware being passed to the SEV
> > + * FW. Allocate enough memory for data structure + alignment
> > + * padding + SEV FW.
> > + */
> > +#define SEV_FW_ALIGNMENT       32
> > +
> >  struct sev_misc_dev {
> >       struct kref refcount;
> >       struct miscdevice misc;
> > @@ -57,6 +66,11 @@ struct sev_device {
> >       bool cmd_buf_backup_active;
> >
> >       bool snp_initialized;
> > +
> > +#ifdef CONFIG_FW_UPLOAD
>
> CRYPTO_DEV_SP_PSP_FW_UPLOAD
>
> > +     struct fw_upload *fwl;
> > +     bool fw_cancel;
> > +#endif /* CONFIG_FW_UPLOAD */
> >  };
> >
> >  int sev_dev_init(struct psp_device *psp);
> > @@ -73,4 +87,17 @@ struct sev_asid_data {
> >  extern struct sev_asid_data *sev_asid_data;
> >  extern u32 nr_asids, sev_min_asid, sev_max_asid, sev_es_max_asid;
> >
> > +void *sev_fw_alloc(unsigned long len);
> > +int sev_get_api_version(void);
> > +
> > +#ifdef CONFIG_CRYPTO_DEV_SP_PSP_FW_UPLOAD
> > +void sev_snp_dev_init_firmware_upload(struct sev_device *sev);
> > +void sev_snp_destroy_firmware_upload(struct sev_device *sev);
> > +int sev_snp_synthetic_error(struct sev_device *sev, int *psp_ret);
> > +#else
> > +static inline void sev_snp_dev_init_firmware_upload(struct sev_device =
*sev) { }
> > +static inline void sev_snp_destroy_firmware_upload(struct sev_device *=
sev) { }
> > +static inline int sev_snp_synthetic_error(struct sev_device *sev, int =
*psp_ret) { return 0; }
> > +#endif /* CONFIG_CRYPTO_DEV_SP_PSP_FW_UPLOAD */
> > +
> >  #endif /* __SEV_DEV_H */
> > diff --git a/drivers/crypto/ccp/sev-fw.c b/drivers/crypto/ccp/sev-fw.c
> > new file mode 100644
> > index 0000000000000..6a87872174ee5
> > --- /dev/null
> > +++ b/drivers/crypto/ccp/sev-fw.c
> > @@ -0,0 +1,267 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * AMD Secure Encrypted Virtualization (SEV) firmware upload API
> > + */
> > +
> > +#include <linux/firmware.h>
> > +#include <linux/psp.h>
> > +#include <linux/psp-sev.h>
> > +
> > +#include <asm/sev.h>
> > +
> > +#include "sev-dev.h"
> > +
> > +static bool synthetic_restore_required;
> > +
> > +int sev_snp_synthetic_error(struct sev_device *sev, int *psp_ret)
> > +{
> > +     if (synthetic_restore_required) {
> > +             *psp_ret =3D SEV_RET_RESTORE_REQUIRED;
> > +             return -EIO;
> > +     }
>
> Add a blank line.
>
Done.
> > +     return 0;
> > +}
> > +
> > +static int sev_snp_download_firmware_ex(struct sev_device *sev, const =
u8 *data, u32 size,
> > +                                     int *error)
> > +{
> > +     struct sev_data_download_firmware_ex *data_ex;
> > +     int ret, order;
> > +     struct page *p;
> > +     u64 data_size;
> > +     void *fw_dest;
> > +
> > +     data_size =3D ALIGN(sizeof(struct sev_data_download_firmware_ex),=
 SEV_FW_ALIGNMENT);
> > +
> > +     order =3D get_order(size + data_size);
> > +     p =3D alloc_pages(GFP_KERNEL, order);
> > +     if (!p)
> > +             return -ENOMEM;
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
> > +     data_ex->fw_paddr =3D __psp_pa(fw_dest);
> > +     data_ex->fw_len =3D size;
> > +     data_ex->length =3D sizeof(struct sev_data_download_firmware_ex);
> > +     /* commit is purposefully unset for GCTX update failure to advise=
 rollback */
>
> Move this above the start of the data_ex assignments.
>
Done.
> > +
> > +     ret =3D sev_do_cmd(SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX, data_ex, err=
or);
> > +
>
> Remove blank line.
>
Done.
> > +     if (ret)
> > +             goto free_err;
> > +
> > +     /* Need to do a DF_FLUSH after live firmware update */
> > +     wbinvd_on_all_cpus();
> > +     ret =3D sev_do_cmd(SEV_CMD_SNP_DF_FLUSH, NULL, error);
> > +     if (ret)
> > +             dev_dbg(sev->dev, "DF_FLUSH error %d\n", *error);
> > +
> > +free_err:
> > +     __free_pages(p, order);
> > +     return ret;
> > +}
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
> > +/* Cancel can be called asynchronously, but DOWNLOAD_FIRMWARE_EX is at=
omic and cannot
> > + * be canceled. There is no need to synchronize updates to fw_cancel.
> > + */
> > +static void snp_dlfw_ex_cancel(struct fw_upload *fw_upload)
> > +{
> > +     /* fw_upload not-NULL guaranteed by firmware_upload API */
> > +     struct sev_device *sev =3D fw_upload->dd_handle;
> > +
> > +     sev->fw_cancel =3D true;
>
> How does this ever get set back to false?
>
Good point. Reset to false in the prepare function.

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
> > +static enum fw_upload_err snp_update_guest_statuses(struct sev_device =
*sev)
> > +{
> > +     struct sev_data_snp_guest_status status_data;
> > +     void *snp_guest_status;
> > +     enum fw_upload_err ret;
> > +     int error;
> > +
> > +     /*
> > +      * Force an update of guest context pages after SEV firmware
> > +      * live update by issuing SNP_GUEST_STATUS on all guest
> > +      * context pages.
> > +      */
> > +     snp_guest_status =3D sev_fw_alloc(PAGE_SIZE);
> > +     if (!snp_guest_status)
> > +             return FW_UPLOAD_ERR_INVALID_SIZE;
> > +
> > +     /*
> > +      * After the last bound asid-to-gctx page is snp_unbound_gctx_end=
-many
> > +      * unbound gctx pages that also need updating.
>
> This comment seems stale.
>
> > +      */
> > +     for (int i =3D 1; i <=3D sev_es_max_asid; i++) {
> > +             if (!sev_asid_data[i].snp_context)
> > +                     continue;
> > +
> > +             status_data.gctx_paddr =3D __psp_pa(sev_asid_data[i].snp_=
context);
> > +             status_data.address =3D __psp_pa(snp_guest_status);
> > +             ret =3D sev_do_cmd(SEV_CMD_SNP_GUEST_STATUS, &status_data=
, &error);
> > +             if (ret) {
> > +                     /*
> > +                      * Handle race with SNP VM being destroyed/decomm=
issoned,
> > +                      * if guest context page invalid error is returne=
d,
> > +                      * assume guest has been destroyed.
> > +                      */
> > +                     if (error =3D=3D SEV_RET_INVALID_GUEST)
> > +                             continue;
>
> Add a blank line here.
>
Done.
> > +                     synthetic_restore_required =3D true;
> > +                     dev_err(sev->dev, "SNP GCTX update error requires=
 rollback: %#x\n",
> > +                             error);
> > +                     ret =3D FW_UPLOAD_ERR_RW_ERROR;
> > +                     goto fw_err;
> > +             }
> > +     }
> > +fw_err:
> > +     snp_free_firmware_page(snp_guest_status);
> > +     return ret;
> > +}
> > +
> > +static enum fw_upload_err snp_dlfw_ex_write(struct fw_upload *fwl, con=
st u8 *data,
> > +                                         u32 offset, u32 size, u32 *wr=
itten)
> > +{
> > +     /* fwl not-NULL guaranteed by firmware_upload API */
> > +     struct sev_device *sev =3D fwl->dd_handle;
> > +     u8 api_major, api_minor, build;
> > +     int ret, error;
> > +
> > +     if (!sev)
> > +             return FW_UPLOAD_ERR_HW_ERROR;
> > +
> > +     if (sev->fw_cancel)
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
> > +     ret =3D sev_snp_download_firmware_ex(sev, data, size, &error);
> > +     if (ret)
> > +             return snp_dlfw_ex_err_translate(sev, error);
> > +
> > +     ret =3D snp_update_guest_statuses(sev);
> > +     if (ret)
> > +             return ret;
> > +
> > +     sev_get_api_version();
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
> > +}
> > +
> > +static const struct fw_upload_ops snp_dlfw_ex_ops =3D {
> > +     .prepare =3D snp_dlfw_ex_prepare,
> > +     .write =3D snp_dlfw_ex_write,
> > +     .poll_complete =3D snp_dlfw_ex_poll_complete,
> > +     .cancel =3D snp_dlfw_ex_cancel,
> > +};
> > +
> > +void sev_snp_dev_init_firmware_upload(struct sev_device *sev)
> > +{
> > +     struct fw_upload *fwl;
> > +
> > +     fwl =3D firmware_upload_register(THIS_MODULE, sev->dev, "snp_dlfw=
_ex", &snp_dlfw_ex_ops, sev);
> > +
>
> Remove blank line.
>
Done.
> > +     if (IS_ERR(fwl))
> > +             dev_err(sev->dev, "SEV firmware upload initialization err=
or %ld\n", PTR_ERR(fwl));
> > +     else
> > +             sev->fwl =3D fwl;
> > +}
> > +
> > +void sev_snp_destroy_firmware_upload(struct sev_device *sev)
> > +{
> > +     if (!sev || !sev->fwl)
>
> !sev was previously checked before calling this, so you only really need
> the !sev-fwl check.
Done.

>
> Thanks,
> Tom
>
> > +             return;
> > +
> > +     firmware_upload_unregister(sev->fwl);
> > +}
> > +
> > diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> > index ac36b5ddf717d..b91cbdc208f49 100644
> > --- a/include/linux/psp-sev.h
> > +++ b/include/linux/psp-sev.h
> > @@ -185,6 +185,23 @@ struct sev_data_download_firmware {
> >       u32 len;                                /* In */
> >  } __packed;
> >
> > +/**
> > + * struct sev_data_download_firmware_ex - DOWNLOAD_FIRMWARE_EX command=
 parameters
> > + *
> > + * @length: length of this command buffer
> > + * @fw_paddr: physical address of firmware image
> > + * @fw_len: len of the firmware image
> > + * @commit: automatically commit the newly installed image
> > + */
> > +struct sev_data_download_firmware_ex {
> > +     u32 length;                             /* In */
> > +     u32 reserved;                           /* In */
> > +     u64 fw_paddr;                           /* In */
> > +     u32 fw_len;                             /* In */
> > +     u32 commit:1;                           /* In */
> > +     u32 reserved2:31;                       /* In */
> > +} __packed;
> > +
> >  /**
> >   * struct sev_data_get_id - GET_ID command parameters
> >   *



--
-Dionna Glaze, PhD, CISSP, CCSP (she/her)
