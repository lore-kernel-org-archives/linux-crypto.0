Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94747C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Sep 2021 03:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75D54610CE
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Sep 2021 03:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhIJDbs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Sep 2021 23:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbhIJDbr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Sep 2021 23:31:47 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FD7C061756
        for <linux-crypto@vger.kernel.org>; Thu,  9 Sep 2021 20:30:37 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id 6so1076973oiy.8
        for <linux-crypto@vger.kernel.org>; Thu, 09 Sep 2021 20:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NNboQ/FR4h0376TGbPOg84fczWq1c0viqJFh4kJpLOo=;
        b=DOWVLWOxYph3rCExJ6yJTlcc1s6U/I3mbRtoHPSRkXdkWwTcFm3mjoOrRLkY4fytA9
         0MyW+YeqXjf9HXZv7TJPKSd7UE3UcCWj+cYfQcBX6vbFByevBmZEuafXo9MXazkUmO5+
         6dwbOE/QzI0XGmZsV3K79MBvd6Y15aDLFALfeAF7kLvp7FeK0AOE2nC30749dih4elGu
         uyZmD0f2M+RK4S7/7YjQaGhoIzOl+g/b1xOBsJ9VA1Fjo2i7MYPJz2Nr3o02fdQOy8SD
         7e3bc8KeQMkMqxK4xNykHuuIxmQoYlWgk6Q2sp0Vb5IG+XeVopue08zLomU9bzVjK+J1
         S4zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NNboQ/FR4h0376TGbPOg84fczWq1c0viqJFh4kJpLOo=;
        b=rHRAtuj8f410S29Eolx4FykOiYSep0UvAA8bAZ8ZEWM6pKHm6OyrHOURO8OtDEhvz/
         +1QU54plbQUGRKCvzVFH9aChtnnBiyfm4+tTy602w/7ZaGPr/+iLzqVU6PcnDGmiYnm0
         UncACogYl7Y7MeuhpXYek8OLS8kCGdlQG1gjQrcojcxvZrKqbL5yA3zFZwAhkP5dRcwq
         S6kgOEQvQTQAT+YPaWtRa2HNsfga1gLaK8HfRc9PJZY++SsKrX4syxsOE7aExPXKT2PW
         2eeGbuLepGHI1e/wMtRJ5MpX3Cy0Cpm+rYnKuNUdY2+2PtamXTv/uJIjcDch6JoFIqy6
         bhjA==
X-Gm-Message-State: AOAM5337AFFFsJo16xYT+nFPAQSCkwY6QSnnKLub/BIxC3iLj29m4T0Z
        lwf7yD4XgCM+7I2ZL7pLIglhq80NTjUKLhI9Y9PgUw==
X-Google-Smtp-Source: ABdhPJyMHOEn4H9rfV4O2+PMzf0ccVbYklwH5xFOd06p1a88RXslpULKUsmN2vs6tHJbgkdkc/h+sJIlfaTplJ4cEtw=
X-Received: by 2002:a05:6808:909:: with SMTP id w9mr2624314oih.164.1631244636311;
 Thu, 09 Sep 2021 20:30:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <20210820155918.7518-19-brijesh.singh@amd.com>
In-Reply-To: <20210820155918.7518-19-brijesh.singh@amd.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 9 Sep 2021 20:30:25 -0700
Message-ID: <CAA03e5FMCp7cZLXKPZ53SOUK-cOF+WmGRj256K9=+wivHvTA0Q@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 18/45] crypto: ccp: Provide APIs to query
 extended attestation report
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 20, 2021 at 9:00 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
> Version 2 of the GHCB specification defines VMGEXIT that is used to get
> the extended attestation report. The extended attestation report includes
> the certificate blobs provided through the SNP_SET_EXT_CONFIG.
>
> The snp_guest_ext_guest_request() will be used by the hypervisor to get
> the extended attestation report. See the GHCB specification for more
> details.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 43 ++++++++++++++++++++++++++++++++++++
>  include/linux/psp-sev.h      | 24 ++++++++++++++++++++
>  2 files changed, 67 insertions(+)
>
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 9ba194acbe85..e2650c3d0d0a 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -22,6 +22,7 @@
>  #include <linux/firmware.h>
>  #include <linux/gfp.h>
>  #include <linux/cpufeature.h>
> +#include <linux/sev-guest.h>
>
>  #include <asm/smp.h>
>
> @@ -1677,6 +1678,48 @@ int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error)
>  }
>  EXPORT_SYMBOL_GPL(snp_guest_dbg_decrypt);
>
> +int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
> +                               unsigned long vaddr, unsigned long *npages, unsigned long *fw_err)
> +{
> +       unsigned long expected_npages;
> +       struct sev_device *sev;
> +       int rc;
> +
> +       if (!psp_master || !psp_master->sev_data)
> +               return -ENODEV;
> +
> +       sev = psp_master->sev_data;
> +
> +       if (!sev->snp_inited)
> +               return -EINVAL;
> +
> +       /*
> +        * Check if there is enough space to copy the certificate chain. Otherwise
> +        * return ERROR code defined in the GHCB specification.
> +        */
> +       expected_npages = sev->snp_certs_len >> PAGE_SHIFT;

Is this calculation for `expected_npages` correct? Assume that
`sev->snp_certs_len` is less than a page (e.g., 2000). Then, this
calculation will return `0` for `expected_npages`, rather than round
up to 1.

> +       if (*npages < expected_npages) {
> +               *npages = expected_npages;
> +               *fw_err = SNP_GUEST_REQ_INVALID_LEN;
> +               return -EINVAL;
> +       }
> +
> +       rc = sev_do_cmd(SEV_CMD_SNP_GUEST_REQUEST, data, (int *)&fw_err);
> +       if (rc)
> +               return rc;
> +
> +       /* Copy the certificate blob */
> +       if (sev->snp_certs_data) {
> +               *npages = expected_npages;
> +               memcpy((void *)vaddr, sev->snp_certs_data, *npages << PAGE_SHIFT);
> +       } else {
> +               *npages = 0;
> +       }
> +
> +       return rc;
> +}
> +EXPORT_SYMBOL_GPL(snp_guest_ext_guest_request);
> +
>  static void sev_exit(struct kref *ref)
>  {
>         misc_deregister(&misc_dev->misc);
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 00bd684dc094..ea94ce4d834a 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -924,6 +924,23 @@ void *psp_copy_user_blob(u64 uaddr, u32 len);
>  void *snp_alloc_firmware_page(gfp_t mask);
>  void snp_free_firmware_page(void *addr);
>
> +/**
> + * snp_guest_ext_guest_request - perform the SNP extended guest request command
> + *  defined in the GHCB specification.
> + *
> + * @data: the input guest request structure
> + * @vaddr: address where the certificate blob need to be copied.
> + * @npages: number of pages for the certificate blob.
> + *    If the specified page count is less than the certificate blob size, then the
> + *    required page count is returned with error code defined in the GHCB spec.
> + *    If the specified page count is more than the certificate blob size, then
> + *    page count is updated to reflect the amount of valid data copied in the
> + *    vaddr.
> + */
> +int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
> +                               unsigned long vaddr, unsigned long *npages,
> +                               unsigned long *error);
> +
>  #else  /* !CONFIG_CRYPTO_DEV_SP_PSP */
>
>  static inline int
> @@ -971,6 +988,13 @@ static inline void *snp_alloc_firmware_page(gfp_t mask)
>
>  static inline void snp_free_firmware_page(void *addr) { }
>
> +static inline int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
> +                                             unsigned long vaddr, unsigned long *n,
> +                                             unsigned long *error)
> +{
> +       return -ENODEV;
> +}
> +
>  #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
>
>  #endif /* __PSP_SEV_H__ */
> --
> 2.17.1
>
