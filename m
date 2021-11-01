Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A747EC433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 17:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7247C60232
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 17:18:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhKARVI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Nov 2021 13:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhKARVI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Nov 2021 13:21:08 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32079C061764
        for <linux-crypto@vger.kernel.org>; Mon,  1 Nov 2021 10:18:34 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id d23so29171724ljj.10
        for <linux-crypto@vger.kernel.org>; Mon, 01 Nov 2021 10:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7UjSYnKbnp/ijNsJoJ6hZZ1J8dHg1o70XSaedRAo+yQ=;
        b=ba9rT1mLSmky84yQGFsIzgtZFthpzi/01lTCXQ24K2f2Y2SKGHqZaUv0vOc/5okQdC
         h66IxJRTFVTp/30nZipJiX8bOE0WIluIBS/c+HC9M0LEbJsQ3ZHwXd00Cvwb91zqDOyn
         itKDLCkkCVrqeYmkK9lHLWE1Rfc+/WBp2Mm3fr7wkewSujRqL4SoPm1U4oHgaKpsjO+t
         RkPtKcJZno4dgSZK2o3GH650MqyoYj/Aev0orWvFIerO+Cl1arCCP0SH0+WlZ62szWGL
         Ncini84QOHxYoes9WSZcreuWA7e4gPQxSELqC9oVf6SFQUWaKY3T+0jGp/z7zJm7uF12
         DSEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7UjSYnKbnp/ijNsJoJ6hZZ1J8dHg1o70XSaedRAo+yQ=;
        b=OJ/G6u2SDPATA3OinP1nTpWvtwsQBpnXHo+kgB/YQqR0QT+zWR/ae9BvDcpgnlbT/p
         nAfKIDxS2rcMxlwck1h5DIfBRLnKNR6gDLDnCKU+o9DYXUTx23wlG55Mbfrsl5i/RRsq
         c3OloxiQzssbOhubxZ54gSaBZsQvOldisIw8Zm7Wr+zypQOvumqdSD61Gn+8xKbdWEj/
         KgWdVnsfTUKhDCv++mQaZ+Sgb7WtOw4Zzt9D2pdg1dO6tZ+5aQzqr3DKAoTN4fPEbcu4
         FY9rDItd7ctrq8KMjf3I9MWAzHNr5n/JIRzJiV68WF+qOxPIyRJGD/aRiGoNYMrqvrFk
         WWYQ==
X-Gm-Message-State: AOAM53322Ox6/yzrDXcKaDqvYg+L17NGMgpQd+nbz7nNntU16Jss+ZUI
        AXdhkBPcJISahxQQgb9XlpR8JhgaGEtB+/7EFfwWHw==
X-Google-Smtp-Source: ABdhPJyAjNEaAbUPPhfF88aAZ+O8As3VeIzlmCj7+neZisEO2u2Qb3RdgSEd0s7wlLPSm3Z2YB6sf8xE9LSUJTDhwQA=
X-Received: by 2002:a2e:9ca:: with SMTP id 193mr32640971ljj.83.1635787111885;
 Mon, 01 Nov 2021 10:18:31 -0700 (PDT)
MIME-Version: 1.0
References: <20211028175749.1219188-1-pgonda@google.com> <20211028175749.1219188-5-pgonda@google.com>
 <c2076ecf-8b30-c96e-2169-bc1f031d309e@amd.com> <CAMkAt6rKZx=S7tRuNo-dnHw_iJ2uiDp1nzL-WiAgD+uQo+aCyA@mail.gmail.com>
 <50889d7c-67ee-ba17-faa4-e930b7c18a09@amd.com>
In-Reply-To: <50889d7c-67ee-ba17-faa4-e930b7c18a09@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 1 Nov 2021 11:18:20 -0600
Message-ID: <CAMkAt6r1M=ob0Um4iQDQN6c1EXj364eS-M8H9tx1ySGpwqXHXA@mail.gmail.com>
Subject: Re: [PATCH 4/4] crypto: ccp - Add SEV_INIT_EX support
To:     Tom Lendacky <Thomas.Lendacky@amd.com>
Cc:     "Relph, Richard" <Richard.Relph@amd.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 29, 2021 at 11:56 AM Tom Lendacky <thomas.lendacky@amd.com> wro=
te:
>
> On 10/29/21 12:26 PM, Peter Gonda wrote:
> > On Fri, Oct 29, 2021 at 8:45 AM Tom Lendacky <thomas.lendacky@amd.com> =
wrote:
> >>
> >> On 10/28/21 12:57 PM, Peter Gonda wrote:
> >>> From: David Rientjes <rientjes@google.com>
> >>>
> >>> Add new module parameter to allow users to use SEV_INIT_EX instead of
> >>> SEV_INIT. This helps users who lock their SPI bus to use the PSP for =
SEV
> >>> functionality. The 'init_ex_path' parameter defaults to NULL which me=
ans
> >>> the kernel will use SEV_INIT, if a path is specified SEV_INIT_EX will=
 be
> >>> used with the data found at the path. On certain PSP commands this
> >>> file is written to as the PSP updates the NV memory region. Depending=
 on
> >>> file system initialization this file open may fail during module init
> >>> but the CCP driver for SEV already has sufficient retries for platfor=
m
> >>> initialization. During normal operation of PSP system and SEV command=
s
> >>> if the PSP has not been initialized it is at run time.
> >>
> >> IIUC, it looks as though the file has to exist before the very first u=
se,
> >> otherwise the initialization will fail. Did you consider checking for =
the
> >> presence of the file first and, if not there, just using a memory area=
 of
> >> all f's (as documented in the SEV API)? Then on successful INIT, the
> >> memory would be written and the file created.
> >
> > Thats a great idea. I'll add that functionality.
>
> It all depends on how you want to treat the absence of the file. I can se=
e
> use cases for both creating automatically or failing (e.g. there was a
> typo in the path).
>
> >
> >>
> >> Either way, probably worth adding to the commit message. And if you st=
ay
> >> with having to pre-allocate the file, it's worth adding to the SEV
> >> documentation what is required to be done to initialize the file.
> >>
> >> Although, INIT_EX is probably worth adding to the SEV documentation in
> >> general.
> >
> > Is this (https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A=
%2F%2Fwww.kernel.org%2Fdoc%2FDocumentation%2Fvirt%2Fkvm%2Famd-memory-encryp=
tion.rst&amp;data=3D04%7C01%7CThomas.Lendacky%40amd.com%7Cd9723c44ea764cc75=
40e08d99b013bbb%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C63771125188047=
5091%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik=
1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3DWJtwak6F%2Bn7PC8R1ohsC%2FNKGi7oDWFT=
i72NJDteyQoM%3D&amp;reserved=3D0)
> > the documentation you were referring too? If so I can add another
> > patch before this one to document INIT, then add the INIT_EX
> > documentation here. Or were you thinking something else?
>
> Yes, that's the documentation I was referring to. I think you can just ad=
d
> something to the KVM_SEV_INIT entry that talks about the new module
> parameter and a bit about the file and how that file will be used. If you
> decide to stay with a pre-created file, some details about how to create
> the file would then be appropriate.
>

I've updated the doc and the commit message. I went with the do not
auto create option since it keeps the patch simpler, fixes typos as
you've said, and its pretty easy for users to create with a dd command
or something.

> Thanks,
> Tom
>
> >
> >>
> >>>
> >>> Signed-off-by: David Rientjes <rientjes@google.com>
> >>> Co-developed-by: Peter Gonda <pgonda@google.com>
> >>> Signed-off-by: Peter Gonda <pgonda@google.com>
> >>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> >>> Cc: Brijesh Singh <brijesh.singh@amd.com>
> >>> Cc: Marc Orr <marcorr@google.com>
> >>> Cc: Joerg Roedel <jroedel@suse.de>
> >>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> >>> Cc: David Rientjes <rientjes@google.com>
> >>> Cc: John Allen <john.allen@amd.com>
> >>> Cc: "David S. Miller" <davem@davemloft.net>
> >>> Cc: Paolo Bonzini <pbonzini@redhat.com> (
> >>> Cc: linux-crypto@vger.kernel.org
> >>> Cc: linux-kernel@vger.kernel.org
> >>> ---
> >>>    drivers/crypto/ccp/sev-dev.c | 186 +++++++++++++++++++++++++++++++=
+---
> >>>    include/linux/psp-sev.h      |  21 ++++
> >>>    2 files changed, 192 insertions(+), 15 deletions(-)
> >>>
> >>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-de=
v.c
> >>> index b568ae734857..c8718b4cbc93 100644
> >>> --- a/drivers/crypto/ccp/sev-dev.c
> >>> +++ b/drivers/crypto/ccp/sev-dev.c
> >>> @@ -22,6 +22,7 @@
> >>>    #include <linux/firmware.h>
> >>>    #include <linux/gfp.h>
> >>>    #include <linux/cpufeature.h>
> >>> +#include <linux/fs.h>
> >>>
> >>>    #include <asm/smp.h>
> >>>
> >>> @@ -43,6 +44,10 @@ static int psp_probe_timeout =3D 5;
> >>>    module_param(psp_probe_timeout, int, 0644);
> >>>    MODULE_PARM_DESC(psp_probe_timeout, " default timeout value, in se=
conds, during PSP device probe");
> >>>
> >>> +static char *init_ex_path;
> >>> +module_param(init_ex_path, charp, 0660);
> >>> +MODULE_PARM_DESC(init_ex_path, " Path for INIT_EX data; if set try I=
NIT_EX");
> >>> +
> >>>    MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EP=
YC */
> >>>    MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EP=
YC */
> >>>    MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EP=
YC */
> >>> @@ -58,6 +63,14 @@ static int psp_timeout;
> >>>    #define SEV_ES_TMR_SIZE             (1024 * 1024)
> >>>    static void *sev_es_tmr;
> >>>
> >>> +/* INIT_EX NV Storage:
> >>> + *   The NV Storage is a 32Kb area and must be 4Kb page aligned.  Us=
e the page
> >>> + *   allocator to allocate the memory, which will return aligned mem=
ory for the
> >>> + *   specified allocation order.
> >>> + */
> >>> +#define NV_LENGTH (32 << 10)
> >>
> >> Just me, but I think '32 * 1024' would be a bit clearer.
> >
> > SGTM and more consistent with SEV_ES_TMR_SIZE.
> >
> >>
> >>> +static void *sev_init_ex_nv_address;
> >>> +
> >>>    static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
> >>>    {
> >>>        struct sev_device *sev =3D psp_master->sev_data;
> >>> @@ -135,6 +148,7 @@ static int sev_cmd_buffer_len(int cmd)
> >>>        case SEV_CMD_GET_ID:                    return sizeof(struct s=
ev_data_get_id);
> >>>        case SEV_CMD_ATTESTATION_REPORT:        return sizeof(struct s=
ev_data_attestation_report);
> >>>        case SEV_CMD_SEND_CANCEL:                       return sizeof(=
struct sev_data_send_cancel);
> >>> +     case SEV_CMD_INIT_EX:                   return sizeof(struct se=
v_data_init_ex);
> >>
> >> Maybe move this to just under the SEV_CMD_INIT: case statement?
> >>
> >>>        default:                                return 0;
> >>>        }
> >>>
> >>> @@ -156,6 +170,89 @@ static void *sev_fw_alloc(unsigned long len)
> >>>        return page_address(page);
> >>>    }
> >>>
> >>> +static int sev_read_nv_memory(void)
> >>> +{
> >>> +     struct file *fp;
> >>> +     ssize_t nread;
> >>> +
> >>> +     if (!sev_init_ex_nv_address)
> >>> +             return -EOPNOTSUPP;
> >>> +
> >>> +     fp =3D filp_open(init_ex_path, O_RDONLY, 0);
> >>> +     if (IS_ERR(fp)) {
> >>> +             dev_err(psp_master->dev, "sev could not open file for r=
ead\n");
> >>> +             return PTR_ERR(fp);
> >>> +     }
> >>> +
> >>> +     nread =3D kernel_read(fp, sev_init_ex_nv_address, NV_LENGTH, 0)=
;
> >>> +     dev_dbg(psp_master->dev, "sev NV read %d bytes\n", nread);
> >>> +     filp_close(fp, NULL);
> >>
> >> Add a blank line here.
> >>
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static int sev_write_nv_memory(void)
> >>> +{
> >>> +     struct sev_device *sev =3D psp_master->sev_data;
> >>> +     struct file *fp;
> >>> +     loff_t offset =3D 0;
> >>> +     int ret;
> >>> +
> >>> +     if (!sev_init_ex_nv_address)
> >>> +             return -EOPNOTSUPP;
> >>> +
> >>> +     fp =3D filp_open(init_ex_path, O_CREAT | O_WRONLY, 0600);
> >>> +     if (IS_ERR(fp)) {
> >>> +             dev_err(sev->dev, "sev NV data could not be created\n")=
;
> >>> +             return PTR_ERR(fp);
> >>> +     }
> >>
> >> Add a blank line here.
> >>
> >>> +     ret =3D kernel_write(fp, sev_init_ex_nv_address, NV_LENGTH, &of=
fset);
> >>> +     vfs_fsync(fp, 0);
> >>> +     filp_close(fp, NULL);
> >>> +
> >>> +     if (ret !=3D NV_LENGTH) {
> >>> +             dev_err(sev->dev,
> >>> +                     "failed to write %d bytes to non volatile memor=
y area, ret=3D%lu\n",
> >>> +                     NV_LENGTH, ret);
> >>> +             if (ret >=3D 0)
> >>> +                     return -EIO;
> >>> +             return ret;
> >>> +     }
> >>> +
> >>> +     dev_dbg(sev->dev, "wrote to non volatile memory area\n");
> >>
> >> Add a blank line here.
> >
> > Added all these blank lines.
> >
> >>
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static void sev_write_nv_memory_if_required(int cmd_id)
> >>> +{
> >>> +     struct sev_device *sev =3D psp_master->sev_data;
> >>> +     int ret;
> >>> +
> >>> +     if (!sev_init_ex_nv_address)
> >>> +             return;
> >>> +
> >>> +     /*
> >>> +      * Only a few platform commands modify the SPI/NV area,
> >>> +      * but none of the non-platform commands do. Only INIT,
> >>
> >> maybe say INIT(_EX)?
> >
> > Done.
> >
> >>
> >>> +      * PLATFORM_RESET, PEK_GEN, PEK_CERT_IMPORT, and
> >>> +      * PDH_GEN do.
> >>
> >> Does SHUTDOWN modify the SPI/NV area? Otherwise a separate comment abo=
ut
> >> why it is included below.
> >
> > Double checked the FW doc looks like it does not. Richard can you
> > confirm? If it doesn't I'll remove this case.
> >
> >   >
> >>> +      */
> >>> +     switch (cmd_id) {
> >>> +     case SEV_CMD_FACTORY_RESET:
> >>> +     case SEV_CMD_INIT_EX:
> >>> +     case SEV_CMD_PDH_GEN:
> >>> +     case SEV_CMD_PEK_CERT_IMPORT:
> >>> +     case SEV_CMD_PEK_GEN:
> >>> +     case SEV_CMD_SHUTDOWN:
> >>> +             break;
> >>> +     default:
> >>> +             return;
> >>> +     };
> >>> +
> >>> +     ret =3D sev_write_nv_memory();
> >>> +     if (ret)
> >>> +             dev_err(sev->dev, "sev NV write failed %d\n", ret);
> >>
> >> You already have error messages in the sev_write_nv_memory() function,
> >> this one probably isn't needed.
> >
> > Removed.
> >
> >>
> >>> +}
> >>> +
> >>>    static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
> >>>    {
> >>>        struct psp_device *psp =3D psp_master;
> >>> @@ -225,6 +322,8 @@ static int __sev_do_cmd_locked(int cmd, void *dat=
a, int *psp_ret)
> >>>                dev_dbg(sev->dev, "sev command %#x failed (%#010x)\n",
> >>>                        cmd, reg & PSP_CMDRESP_ERR_MASK);
> >>>                ret =3D -EIO;
> >>> +     } else {
> >>> +             sev_write_nv_memory_if_required(cmd);
> >>>        }
> >>>
> >>>        print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, dat=
a,
> >>> @@ -251,22 +350,42 @@ static int sev_do_cmd(int cmd, void *data, int =
*psp_ret)
> >>>        return rc;
> >>>    }
> >>>
> >>> -static int __sev_platform_init_locked(int *error)
> >>> +static int __sev_init_locked(int *error)
> >>>    {
> >>> -     struct psp_device *psp =3D psp_master;
> >>>        struct sev_data_init data;
> >>> -     struct sev_device *sev;
> >>> -     int rc =3D 0;
> >>>
> >>> -     if (!psp || !psp->sev_data)
> >>> -             return -ENODEV;
> >>> +     memset(&data, 0, sizeof(data));
> >>> +     if (sev_es_tmr) {
> >>> +             u64 tmr_pa;
> >>>
> >>> -     sev =3D psp->sev_data;
> >>> +             /*
> >>> +              * Do not include the encryption mask on the physical
> >>> +              * address of the TMR (firmware should clear it anyway)=
.
> >>> +              */
> >>> +             tmr_pa =3D __pa(sev_es_tmr);
> >>>
> >>> -     if (sev->state =3D=3D SEV_STATE_INIT)
> >>> -             return 0;
> >>> +             data.flags |=3D SEV_INIT_FLAGS_SEV_ES;
> >>> +             data.tmr_address =3D tmr_pa;
> >>> +             data.tmr_len =3D SEV_ES_TMR_SIZE;
> >>> +     }
> >>> +
> >>> +     return __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> >>> +}
> >>> +
> >>> +static int __sev_init_ex_locked(int *error)
> >>> +{
> >>> +     struct sev_data_init_ex data;
> >>> +     int ret;
> >>>
> >>>        memset(&data, 0, sizeof(data));
> >>> +     data.length =3D sizeof(data);
> >>> +     data.nv_address =3D __psp_pa(sev_init_ex_nv_address);
> >>> +     data.nv_len =3D NV_LENGTH;
> >>> +
> >>> +     ret =3D sev_read_nv_memory();
> >>> +     if (ret)
> >>> +             return ret;
> >>> +
> >>>        if (sev_es_tmr) {
> >>>                u64 tmr_pa;
> >>>
> >>> @@ -276,12 +395,30 @@ static int __sev_platform_init_locked(int *erro=
r)
> >>>                 */
> >>>                tmr_pa =3D __pa(sev_es_tmr);
> >>>
> >>> -             data.flags |=3D SEV_INIT_FLAGS_SEV_ES;
> >>
> >> Inadvertant deletion?
> >
> > Oops only testing with SEV guests. Will test with ES too. Fixed.
> >
> >>
> >>>                data.tmr_address =3D tmr_pa;
> >>>                data.tmr_len =3D SEV_ES_TMR_SIZE;
> >>>        }
> >>
> >> Add a blank line here.
> >>
> >>> +     return __sev_do_cmd_locked(SEV_CMD_INIT_EX, &data, error);
> >>> +}
> >>> +
> >>> +static int __sev_platform_init_locked(int *error)
> >>> +{
> >>> +     struct psp_device *psp =3D psp_master;
> >>> +     struct sev_device *sev;
> >>> +     int rc;
> >>> +     int (*init_function)(int *error) =3D sev_init_ex_nv_address ?
> >>> +                     __sev_init_ex_locked :
> >>> +                     __sev_init_locked;
> >>
> >> This seems a bit much in the declaration. How about moving the assignm=
ent
> >> down to just before the first call?
> >
> > Done.
> >
> >>
> >>> +
> >>> +     if (!psp || !psp->sev_data)
> >>> +             return -ENODEV;
> >>> +
> >>> +     sev =3D psp->sev_data;
> >>>
> >>> -     rc =3D __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> >>> +     if (sev->state =3D=3D SEV_STATE_INIT)
> >>> +             return 0;
> >>> +
> >>> +     rc =3D init_function(error);
> >>>        if (rc && *error =3D=3D SEV_RET_SECURE_DATA_INVALID) {
> >>>                /*
> >>>                 * INIT command returned an integrity check failure
> >>> @@ -290,8 +427,8 @@ static int __sev_platform_init_locked(int *error)
> >>>                 * failed and persistent state has been erased.
> >>>                 * Retrying INIT command here should succeed.
> >>>                 */
> >>> -             dev_dbg(sev->dev, "SEV: retrying INIT command");
> >>> -             rc =3D __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> >>> +             dev_err(sev->dev, "SEV: retrying INIT command");
> >>
> >> Maybe dev_notice() instead of dev_err()?
> >
> > Done.,
> >
> >>
> >>> +             rc =3D init_function(error);
> >>>        }
> >>>
> >>>        if (rc)
> >>> @@ -307,7 +444,7 @@ static int __sev_platform_init_locked(int *error)
> >>>
> >>>        dev_dbg(sev->dev, "SEV firmware initialized\n");
> >>>
> >>> -     return rc;
> >>> +     return 0;
> >>>    }
> >>>
> >>>    int sev_platform_init(int *error)
> >>> @@ -987,7 +1124,7 @@ static int sev_misc_init(struct sev_device *sev)
> >>>
> >>>        init_waitqueue_head(&sev->int_queue);
> >>>        sev->misc =3D misc_dev;
> >>> -     dev_dbg(dev, "registered SEV device\n");
> >>> +     dev_err(dev, "registered SEV device\n");
> >>
> >> Not sure this is a necessary change... but, if you don't want this as =
a
> >> dev_dbg() then it should be a dev_info(), because it is not an error.
> >
> > Oops this was my debugging. Reverted.
> >
> >>
> >>>
> >>>        return 0;
> >>>    }
> >>> @@ -1061,6 +1198,12 @@ static void sev_firmware_shutdown(struct sev_d=
evice *sev)
> >>>                           get_order(SEV_ES_TMR_SIZE));
> >>>                sev_es_tmr =3D NULL;
> >>>        }
> >>> +
> >>> +     if (sev_init_ex_nv_address) {
> >>> +             free_pages((unsigned long)sev_init_ex_nv_address,
> >>> +                        get_order(NV_LENGTH));
> >>> +             sev_init_ex_nv_address =3D NULL;
> >>> +     }
> >>>    }
> >>>
> >>>    void sev_dev_destroy(struct psp_device *psp)
> >>> @@ -1105,6 +1248,19 @@ void sev_pci_init(void)
> >>>            sev_update_firmware(sev->dev) =3D=3D 0)
> >>>                sev_get_api_version();
> >>>
> >>> +     /* If an init_ex_path is provided rely on INIT_EX for PSP initi=
alization
> >>> +      * instead of INIT.
> >>> +      */
> >>> +     if (init_ex_path) {
> >>> +             sev_init_ex_nv_address =3D sev_fw_alloc(NV_LENGTH);
> >>> +             if (!sev_init_ex_nv_address) {
> >>> +                     dev_warn(
> >>
> >> Shouldn't this be a dev_err(), since you are erroring out?
> >>
> >>> +                             sev->dev,
> >>
> >> Move this up to the previous line, i.e.: dev_err(sev->dev,
> >>
> >>> +                             "SEV: INIT_EX NV storage allocation fai=
led, INIT-EX support unavailable\n");
> >>
> >> Since you're erroring out, probably enough to just have the first part=
 of
> >> that message. But if not:
> >>
> >> s/INIT-EX/INIT_EX/
> >
> > Fixed this log line.
> >
> >>
> >> Thanks,
> >> Tom
> >>
> >>> +                     goto err;
> >>> +             }
> >>> +     }
> >>> +
> >>>        /* Obtain the TMR memory area for SEV-ES use */
> >>>        sev_es_tmr =3D sev_fw_alloc(SEV_ES_TMR_SIZE);
> >>>        if (!sev_es_tmr)
> >>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> >>> index d48a7192e881..1595088c428b 100644
> >>> --- a/include/linux/psp-sev.h
> >>> +++ b/include/linux/psp-sev.h
> >>> @@ -52,6 +52,7 @@ enum sev_cmd {
> >>>        SEV_CMD_DF_FLUSH                =3D 0x00A,
> >>>        SEV_CMD_DOWNLOAD_FIRMWARE       =3D 0x00B,
> >>>        SEV_CMD_GET_ID                  =3D 0x00C,
> >>> +     SEV_CMD_INIT_EX                 =3D 0x00D,
> >>>
> >>>        /* Guest commands */
> >>>        SEV_CMD_DECOMMISSION            =3D 0x020,
> >>> @@ -102,6 +103,26 @@ struct sev_data_init {
> >>>        u32 tmr_len;                    /* In */
> >>>    } __packed;
> >>>
> >>> +/**
> >>> + * struct sev_data_init_ex - INIT_EX command parameters
> >>> + *
> >>> + * @length: len of the command buffer read by the PSP
> >>> + * @flags: processing flags
> >>> + * @tmr_address: system physical address used for SEV-ES
> >>> + * @tmr_len: len of tmr_address
> >>> + * @nv_address: system physical address used for PSP NV storage
> >>> + * @nv_len: len of nv_address
> >>> + */
> >>> +struct sev_data_init_ex {
> >>> +     u32 length;                     /* In */
> >>> +     u32 flags;                      /* In */
> >>> +     u64 tmr_address;                /* In */
> >>> +     u32 tmr_len;                    /* In */
> >>> +     u32 reserved;                   /* In */
> >>> +     u64 nv_address;                 /* In/Out */
> >>> +     u32 nv_len;                     /* In */
> >>> +} __packed;
> >>> +
> >>>    #define SEV_INIT_FLAGS_SEV_ES       0x01
> >>>
> >>>    /**
> >>>
