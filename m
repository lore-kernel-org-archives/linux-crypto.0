Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84999C433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 19:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BE9561154
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 19:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhKATVM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Nov 2021 15:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbhKATVL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Nov 2021 15:21:11 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E90C061714
        for <linux-crypto@vger.kernel.org>; Mon,  1 Nov 2021 12:18:37 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id bi35so38218004lfb.9
        for <linux-crypto@vger.kernel.org>; Mon, 01 Nov 2021 12:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pcmgdTkqqlQdXChG+9ejeANODx0vmSrAmlRO74ef2eM=;
        b=UmlurNPgQ3L5U6ETXtCIZ5OxAMWm0GmNAvfcH2I6YnUTG857KNPPTgN5ZxTyek3CRv
         QXkyEIH+AyjqhKBXj3BY4ybNtki2T5LY1Qlh/LDZgcpObDAs11IZilSciWIj0Ti4rA5H
         yyrCU9DZ+vdLd8injMzOQEYt9mTl0uRusPdkhN4o2JZgKvm3/c8QJoJGk9hYFa4p1FWz
         gJMiFIAJZvonIYXKUD3Gz+Zl9mKO6rQw219g9UVxdcQI6vDuZduZ0yrI1TdEs0GgUksk
         wttUctmoCEfKhGnIrthth7ro6BZPjTsxq1uPstk3ipF7Sb73+NUzc2LVguQ7D9n8q6Vo
         I0ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pcmgdTkqqlQdXChG+9ejeANODx0vmSrAmlRO74ef2eM=;
        b=i4UmbFR00SdO1I54lCcIXEqC3KaD+8BZ+Iy7Bvqxe3fKTkmN9OGMjPnzVI0xiASuQ2
         Wj85O4GVaWwos7TUXMejIEd1EV8iAlkmTfcHBHHYAdDaXcaIc0A5wG70Gt9hBr9Qpgl/
         PaBl6G83VkbIdjKVwCt8fi0bbqZUdDOeo9Bq9C1c2+lahxHBT7T7atUZ6Icey+osAvUe
         9RGt3VxCOdaRAq5O46T1s6L+dFgNgipYgmCB2pJ7xzzQSKTiRgYSN6+1Wt14HU5XcDvG
         oYkYkd1yJ+qX9qWW6PJvKCUi1nOzy+z5AJsktVQp71TN/eTxra/hgy0cyZHMvebAmHI1
         50dA==
X-Gm-Message-State: AOAM5317iJplVKOrhPUTBWH/YfLjpvmn0ROB7PkiJAHW5ib+c1ePP93Z
        Pe5g1jfqlRLeCK9mPM6wTX5oNxniMBs/PpTIGoaReA==
X-Google-Smtp-Source: ABdhPJx44FNijSeYUYEf10rRcpXYbXmOg58qrB6Jro97dsONGgEtdHWbJyhESUYSH5anklEF/xrFtr0jA1I92mOpnYI=
X-Received: by 2002:a19:ad4d:: with SMTP id s13mr30395968lfd.373.1635794315555;
 Mon, 01 Nov 2021 12:18:35 -0700 (PDT)
MIME-Version: 1.0
References: <20211101172127.3060453-1-pgonda@google.com> <20211101172127.3060453-5-pgonda@google.com>
 <952fa937-d139-bd90-825c-f7dfca8d8cb9@amd.com>
In-Reply-To: <952fa937-d139-bd90-825c-f7dfca8d8cb9@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 1 Nov 2021 13:18:23 -0600
Message-ID: <CAMkAt6qdNWP-Ka1N=0d16Q1TrbHPXPEkdLoxC8ndsyid-dqA6Q@mail.gmail.com>
Subject: Re: [PATCH V2 4/4] crypto: ccp - Add SEV_INIT_EX support
To:     Tom Lendacky <Thomas.Lendacky@amd.com>
Cc:     David Rientjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 1, 2021 at 12:41 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 11/1/21 12:21 PM, Peter Gonda wrote:
> > From: David Rientjes <rientjes@google.com>
> >
> > Add new module parameter to allow users to use SEV_INIT_EX instead of
> > SEV_INIT. This helps users who lock their SPI bus to use the PSP for SEV
> > functionality. The 'init_ex_path' parameter defaults to NULL which means
> > the kernel will use SEV_INIT, if a path is specified SEV_INIT_EX will be
> > used with the data found at the path. On certain PSP commands this
> > file is written to as the PSP updates the NV memory region. Depending on
> > file system initialization this file open may fail during module init
> > but the CCP driver for SEV already has sufficient retries for platform
> > initialization. During normal operation of PSP system and SEV commands
> > if the PSP has not been initialized it is at run time. If the file at
> > 'init_ex_path' does not exist the PSP will not be initialized. The user
> > must create the file prior to use with 32Kb of 0xFFs per spec.
> >
> > Signed-off-by: David Rientjes <rientjes@google.com>
> > Co-developed-by: Peter Gonda <pgonda@google.com>
> > Signed-off-by: Peter Gonda <pgonda@google.com>
> > Reviewed-by: Marc Orr <marcorr@google.com>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: Brijesh Singh <brijesh.singh@amd.com>
> > Cc: Marc Orr <marcorr@google.com>
> > Cc: Joerg Roedel <jroedel@suse.de>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: John Allen <john.allen@amd.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: linux-crypto@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >   .../virt/kvm/amd-memory-encryption.rst        |   4 +
> >   drivers/crypto/ccp/sev-dev.c                  | 185 ++++++++++++++++--
> >   include/linux/psp-sev.h                       |  21 ++
> >   3 files changed, 196 insertions(+), 14 deletions(-)
> >
> > diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> > index 5c081c8c7164..6d906a47e568 100644
> > --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> > +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> > @@ -84,6 +84,10 @@ guests, such as launching, running, snapshotting, migrating and decommissioning.
> >
> >   The KVM_SEV_INIT command is used by the hypervisor to initialize the SEV platform
> >   context. In a typical workflow, this command should be the first command issued.
>
> Add a blank line here.
>
> > +The AMD-SP can be initialized either by using its own non-volatile storage or
>
> Just to be consistent within the document, s/AMD-SP/firmware/
>
> > +the system can manage the NV storage for the AMD-SP using the module parameter
>
> s/system/OS/
> s/AMD-SP/firmware/
>
> > +``init_ex_path``. This file must exist, to create a new NV storage file allocate
>
> s/This file must exist/The file specified by ``init_ex_path`` must exist./
> s/, to create/ To create/
>
> > +a the file with 32Kb of 0xFF as required by the SEV FW spec.
>
> s/a the/the/
> s/32Kb/32KB bytes/
>
> Just to be consistent within the document, s/SEV FW spec/SEV spec/

Updated documentation.

>
> >
> >   Returns: 0 on success, -negative on error
> >
> > diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> > index 00ca74dd7b3c..1bbb9c3dd1ce 100644
> > --- a/drivers/crypto/ccp/sev-dev.c
> > +++ b/drivers/crypto/ccp/sev-dev.c
> > @@ -22,6 +22,7 @@
> >   #include <linux/firmware.h>
> >   #include <linux/gfp.h>
> >   #include <linux/cpufeature.h>
> > +#include <linux/fs.h>
> >
> >   #include <asm/smp.h>
> >
> > @@ -43,6 +44,10 @@ static int psp_probe_timeout = 5;
> >   module_param(psp_probe_timeout, int, 0644);
> >   MODULE_PARM_DESC(psp_probe_timeout, " default timeout value, in seconds, during PSP device probe");
> >
> > +static char *init_ex_path;
> > +module_param(init_ex_path, charp, 0660);
> > +MODULE_PARM_DESC(init_ex_path, " Path for INIT_EX data; if set try INIT_EX");
> > +
> >   MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
> >   MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
> >   MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
> > @@ -58,6 +63,14 @@ static int psp_timeout;
> >   #define SEV_ES_TMR_SIZE             (1024 * 1024)
> >   static void *sev_es_tmr;
> >
> > +/* INIT_EX NV Storage:
> > + *   The NV Storage is a 32Kb area and must be 4Kb page aligned.  Use the page
> > + *   allocator to allocate the memory, which will return aligned memory for the
> > + *   specified allocation order.
> > + */
> > +#define NV_LENGTH (32 * 1024)
> > +static void *sev_init_ex_nv_address;
> > +
> >   static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
> >   {
> >       struct sev_device *sev = psp_master->sev_data;
> > @@ -107,6 +120,7 @@ static int sev_cmd_buffer_len(int cmd)
> >   {
> >       switch (cmd) {
> >       case SEV_CMD_INIT:                      return sizeof(struct sev_data_init);
> > +     case SEV_CMD_INIT_EX:                   return sizeof(struct sev_data_init_ex);
> >       case SEV_CMD_PLATFORM_STATUS:           return sizeof(struct sev_user_data_status);
> >       case SEV_CMD_PEK_CSR:                   return sizeof(struct sev_data_pek_csr);
> >       case SEV_CMD_PEK_CERT_IMPORT:           return sizeof(struct sev_data_pek_cert_import);
> > @@ -152,6 +166,89 @@ static void *sev_fw_alloc(unsigned long len)
> >       return page_address(page);
> >   }
> >
> > +static int sev_read_nv_memory(void)
> > +{
> > +     struct file *fp;
> > +     ssize_t nread;
> > +
> > +     if (!sev_init_ex_nv_address)
> > +             return -EOPNOTSUPP;
> > +
> > +     fp = filp_open(init_ex_path, O_RDONLY, 0);
> > +     if (IS_ERR(fp)) {
> > +             const int ret = PTR_ERR(fp);
>
> I don't think you need the "const" here.

Sounds good, removed. I normally default to consting a variable if I
don't expect/want it to change. What guidance should I be following
here?

>
> > +
> > +             dev_err(psp_master->dev,
> > +                     "sev could not open file for read, error %d\n",
> > +                     ret);
>
> Maybe "SEV: could not open %s for read, ret=%d\n"
>
> > +             return ret;
> > +     }
> > +
> > +     nread = kernel_read(fp, sev_init_ex_nv_address, NV_LENGTH, NULL);
>
> kernel_read can return an error, you should check nread before continuing.
>
> > +     dev_dbg(psp_master->dev, "sev NV read %d bytes\n", nread);
>
> "SEV: read %ld bytes from NV file\n"
>
> > +     filp_close(fp, NULL);
> > +
> > +     return 0;
> > +}
> > +
> > +static int sev_write_nv_memory(void)
>
> The return code is never checked by the caller. Is it expected that any
> error is not supposed to stop SEV for the current boot? Should you make
> this void, then?

Changed to void.

>
> > +{
> > +     struct sev_device *sev = psp_master->sev_data;
> > +     struct file *fp;
> > +     loff_t offset = 0;
> > +     int ret;
> > +
> > +     if (!sev_init_ex_nv_address)
> > +             return -EOPNOTSUPP;
> > +
> > +     fp = filp_open(init_ex_path, O_CREAT | O_WRONLY, 0600);
> > +     if (IS_ERR(fp)) {
> > +             dev_err(sev->dev, "sev NV data could not be created\n");
>
> You should output a message similar to what is in sev_read_nv_memory().
>
> > +             return PTR_ERR(fp);
> > +     }
> > +
> > +     ret = kernel_write(fp, sev_init_ex_nv_address, NV_LENGTH, &offset);
>
> kernel_write returns a ssize_t, but ret is an int. and maybe use nwrite
> similar to nread in sev_read_nv_memory()?

Done.
>
> > +     vfs_fsync(fp, 0);
> > +     filp_close(fp, NULL);
> > +
> > +     if (ret != NV_LENGTH) {
> > +             dev_err(sev->dev,
> > +                     "failed to write %d bytes to non volatile memory area, ret=%lu\n",
>
> "SEV: failed to write %u bytes to NV file, ret=%ld\n"
>
> > +                     NV_LENGTH, ret); > +            if (ret >= 0)
> > +                     return -EIO;
> > +             return ret;
> > +     }
> > +
> > +     dev_dbg(sev->dev, "wrote to non volatile memory area\n");
>
> "SEV: write successful to NV file\n"

Updated all messages. Should have noted the "SEV: .." format.

>
> > +
> > +     return 0;
> > +}
> > +
> > +static void sev_write_nv_memory_if_required(int cmd_id)
> > +{
> > +     if (!sev_init_ex_nv_address)
> > +             return;
> > +
> > +     /*
> > +      * Only a few platform commands modify the SPI/NV area, but none of the
> > +      * non-platform commands do. Only INIT(_EX), PLATFORM_RESET, PEK_GEN,
> > +      * PEK_CERT_IMPORT, and PDH_GEN do.
> > +      */
> > +     switch (cmd_id) {
> > +     case SEV_CMD_FACTORY_RESET:
> > +     case SEV_CMD_INIT_EX:
> > +     case SEV_CMD_PDH_GEN:
> > +     case SEV_CMD_PEK_CERT_IMPORT:
> > +     case SEV_CMD_PEK_GEN:
> > +             break;
> > +     default:
> > +             return;
> > +     };
> > +
> > +     sev_write_nv_memory();
> > +}
> > +
> >   static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
> >   {
> >       struct psp_device *psp = psp_master;
> > @@ -221,6 +318,8 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
> >               dev_dbg(sev->dev, "sev command %#x failed (%#010x)\n",
> >                       cmd, reg & PSP_CMDRESP_ERR_MASK);
> >               ret = -EIO;
> > +     } else {
> > +             sev_write_nv_memory_if_required(cmd);
> >       }
> >
> >       print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
> > @@ -247,22 +346,42 @@ static int sev_do_cmd(int cmd, void *data, int *psp_ret)
> >       return rc;
> >   }
> >
> > -static int __sev_platform_init_locked(int *error)
> > +static int __sev_init_locked(int *error)
> >   {
> > -     struct psp_device *psp = psp_master;
> >       struct sev_data_init data;
> > -     struct sev_device *sev;
> > -     int rc = 0;
> >
> > -     if (!psp || !psp->sev_data)
> > -             return -ENODEV;
> > +     memset(&data, 0, sizeof(data));
> > +     if (sev_es_tmr) {
> > +             u64 tmr_pa;
> >
> > -     sev = psp->sev_data;
> > +             /*
> > +              * Do not include the encryption mask on the physical
> > +              * address of the TMR (firmware should clear it anyway).
> > +              */
> > +             tmr_pa = __pa(sev_es_tmr);
> >
> > -     if (sev->state == SEV_STATE_INIT)
> > -             return 0;
> > +             data.flags |= SEV_INIT_FLAGS_SEV_ES;
> > +             data.tmr_address = tmr_pa;
> > +             data.tmr_len = SEV_ES_TMR_SIZE;
> > +     }
> > +
> > +     return __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> > +}
> > +
> > +static int __sev_init_ex_locked(int *error)
> > +{
> > +     struct sev_data_init_ex data;
> > +     int ret;
> >
> >       memset(&data, 0, sizeof(data));
> > +     data.length = sizeof(data);
> > +     data.nv_address = __psp_pa(sev_init_ex_nv_address);
> > +     data.nv_len = NV_LENGTH;
> > +
> > +     ret = sev_read_nv_memory();
> > +     if (ret)
> > +             return ret;
> > +
> >       if (sev_es_tmr) {
> >               u64 tmr_pa;
> >
> > @@ -277,7 +396,27 @@ static int __sev_platform_init_locked(int *error)
> >               data.tmr_len = SEV_ES_TMR_SIZE;
> >       }
> >
> > -     rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> > +     return __sev_do_cmd_locked(SEV_CMD_INIT_EX, &data, error);
> > +}
> > +
> > +static int __sev_platform_init_locked(int *error)
> > +{
> > +     struct psp_device *psp = psp_master;
> > +     struct sev_device *sev;
> > +     int rc;
> > +     int (*init_function)(int *error);
> > +
> > +     if (!psp || !psp->sev_data)
> > +             return -ENODEV;
> > +
> > +     sev = psp->sev_data;
> > +
> > +     if (sev->state == SEV_STATE_INIT)
> > +             return 0;
> > +
> > +     init_function = sev_init_ex_nv_address ? __sev_init_ex_locked :
> > +         __sev_init_locked;
> > +     rc = init_function(error);
> >       if (rc && *error == SEV_RET_SECURE_DATA_INVALID) {
> >               /*
> >                * INIT command returned an integrity check failure
> > @@ -286,8 +425,8 @@ static int __sev_platform_init_locked(int *error)
> >                * failed and persistent state has been erased.
> >                * Retrying INIT command here should succeed.
> >                */
> > -             dev_dbg(sev->dev, "SEV: retrying INIT command");
> > -             rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> > +             dev_notice(sev->dev, "SEV: retrying INIT command");
> > +             rc = init_function(error);
> >       }
> >
> >       if (rc)
> > @@ -303,7 +442,7 @@ static int __sev_platform_init_locked(int *error)
> >
> >       dev_dbg(sev->dev, "SEV firmware initialized\n");
> >
> > -     return rc;
> > +     return 0;
> >   }
> >
> >   int sev_platform_init(int *error)
> > @@ -1057,6 +1196,12 @@ static void sev_firmware_shutdown(struct sev_device *sev)
> >                          get_order(SEV_ES_TMR_SIZE));
> >               sev_es_tmr = NULL;
> >       }
> > +
> > +     if (sev_init_ex_nv_address) {
> > +             free_pages((unsigned long)sev_init_ex_nv_address,
> > +                        get_order(NV_LENGTH));
> > +             sev_init_ex_nv_address = NULL;
> > +     }
> >   }
> >
> >   void sev_dev_destroy(struct psp_device *psp)
> > @@ -1101,11 +1246,23 @@ void sev_pci_init(void)
> >           sev_update_firmware(sev->dev) == 0)
> >               sev_get_api_version();
> >
> > +     /* If an init_ex_path is provided rely on INIT_EX for PSP initialization
> > +      * instead of INIT.
> > +      */
> > +     if (init_ex_path) {
> > +             sev_init_ex_nv_address = sev_fw_alloc(NV_LENGTH);
> > +             if (!sev_init_ex_nv_address) {
> > +                     dev_err(sev->dev,
> > +                             "SEV: INIT_EX NV storage allocation failed, INIT-EX support unavailable\n");
>
> Since this is a file, maybe s/storage/memory/ ?

Done.

>
> At this point, SEV will fail to initialize, it won't fall back to the INIT
> support. So I think the ", INIT-EX support unavailable" can be removed
> from the message.
>
> > +                     goto err;
> > +             }
> > +     }
> > +
> >       /* Obtain the TMR memory area for SEV-ES use */
> >       sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
> >       if (!sev_es_tmr)
> >               dev_warn(sev->dev,
> > -                      "SEV: TMR allocation failed, SEV-ES support unavailable\n");
> > +                      "SEV: TMR allocation failed\n");
>
> This message shouldn't be changed.

Oops I deleted the wrong "... support unavailable". Fixed.
>
>
> I should have made some of these comments on the first version, sorry
> about that.

No worries! I appreciate the reviews.

>
> Thanks,
> Tom
>
> >
> >       /* Initialize the platform */
> >       rc = sev_platform_init(&error);
> > diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> > index d48a7192e881..1595088c428b 100644
> > --- a/include/linux/psp-sev.h
> > +++ b/include/linux/psp-sev.h
> > @@ -52,6 +52,7 @@ enum sev_cmd {
> >       SEV_CMD_DF_FLUSH                = 0x00A,
> >       SEV_CMD_DOWNLOAD_FIRMWARE       = 0x00B,
> >       SEV_CMD_GET_ID                  = 0x00C,
> > +     SEV_CMD_INIT_EX                 = 0x00D,
> >
> >       /* Guest commands */
> >       SEV_CMD_DECOMMISSION            = 0x020,
> > @@ -102,6 +103,26 @@ struct sev_data_init {
> >       u32 tmr_len;                    /* In */
> >   } __packed;
> >
> > +/**
> > + * struct sev_data_init_ex - INIT_EX command parameters
> > + *
> > + * @length: len of the command buffer read by the PSP
> > + * @flags: processing flags
> > + * @tmr_address: system physical address used for SEV-ES
> > + * @tmr_len: len of tmr_address
> > + * @nv_address: system physical address used for PSP NV storage
> > + * @nv_len: len of nv_address
> > + */
> > +struct sev_data_init_ex {
> > +     u32 length;                     /* In */
> > +     u32 flags;                      /* In */
> > +     u64 tmr_address;                /* In */
> > +     u32 tmr_len;                    /* In */
> > +     u32 reserved;                   /* In */
> > +     u64 nv_address;                 /* In/Out */
> > +     u32 nv_len;                     /* In */
> > +} __packed;
> > +
> >   #define SEV_INIT_FLAGS_SEV_ES       0x01
> >
> >   /**
> >
