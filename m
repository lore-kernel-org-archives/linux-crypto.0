Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA434C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Feb 2022 18:04:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbiBYSEa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Feb 2022 13:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbiBYSE1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Feb 2022 13:04:27 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BAF2510FD
        for <linux-crypto@vger.kernel.org>; Fri, 25 Feb 2022 10:03:55 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id i1so4904423ila.7
        for <linux-crypto@vger.kernel.org>; Fri, 25 Feb 2022 10:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nxVYU0Y/GX1SztxwLmOsWDvnyHY9aIhX+L7yaSSKSyA=;
        b=iT2Ku5SRK/+MrntnqGD8a7Hrq8vnN/uWl0vlnMPbnwOkqua7BA+0Q3PtNH+UNpuTBU
         XPI9heL5fA7lCT+6vt7ocs2GdRAuZIPBZ5mHoioV2PC1+F49hCDfL2pFWLGhvYoViJqm
         xtJXHhoInvmOpf+W8u8n0v2UhobZpXZXV9jNB8u+KU4IIcM5YKsA8VWBq/P0kS2dT0nS
         1LToYoUo20javOTYbvaEaxRef8Ju8YI1MwaBrLMEFuQzr7s7uHyTzTAhyQwUunkEECPy
         oLenMYy8BRmMGxL9VMzKCLGHFIMl0n240NtSkomLvDsHBCdrDYG5Cpgm6nQfsTkcc7oZ
         EXoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nxVYU0Y/GX1SztxwLmOsWDvnyHY9aIhX+L7yaSSKSyA=;
        b=cUPw3PUx0ibGkLd81MaG0V00JwX2AADh9Qmrk2uJTAjijgKM6kDWAIWgcdEpBhyJFn
         C1Ag8IfVT4mxbAOm3v1uBtuymlmmnYMcHl/i8vCiPhNPsMtU4q5/yoW2k9BEfv2IVC7T
         S3h6s+s8jKGZv6+icAgKv6a5DtiduJ4VEM+om6xO3Ql6vNzgIMqs8vyHJmxU9X4fk+Hy
         xXrtF6ToUb4VOuBq9udQid+FlS0rnSKUBwTplixR357+NEi5gFYlkVBiFfCYtKxXUhYE
         hdDB6wkvXR0qzYN18zMr7yA8WicSDSg95DLg1SvbWzgxSTV/1t7eIg1/Ggmkt6iHaI7y
         gI6g==
X-Gm-Message-State: AOAM532i+Yphxg2jYnww+WN9lOKmhYRKCOr8wveVwd8zJpKTSWmWl/ND
        e0mKUnjYAbZRZQUA4Y8v7FE3CIS3cb0kRAjsNx/MHg==
X-Google-Smtp-Source: ABdhPJwrKVAUmn1Ancbw20/NQBK86nBHASxQkJw/VYqDyFsL1Tiy5QWwoyWW5QGl4lF1cRGJJ2F4lsbV+aodx11kXDo=
X-Received: by 2002:a05:6e02:1529:b0:2c1:e960:9d4 with SMTP id
 i9-20020a056e02152900b002c1e96009d4mr7458780ilu.115.1645812234218; Fri, 25
 Feb 2022 10:03:54 -0800 (PST)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <20210820155918.7518-15-brijesh.singh@amd.com>
In-Reply-To: <20210820155918.7518-15-brijesh.singh@amd.com>
From:   Alper Gun <alpergun@google.com>
Date:   Fri, 25 Feb 2022 10:03:42 -0800
Message-ID: <CABpDEu=jm43jHhv2mA+C1Sz00xuzH_C-Cn9fRYrFkOCM_em1Fw@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 14/45] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
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
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 20, 2021 at 9:00 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
> The behavior and requirement for the SEV-legacy command is altered when
> the SNP firmware is in the INIT state. See SEV-SNP firmware specification
> for more details.
>
> Allocate the Trusted Memory Region (TMR) as a 2mb sized/aligned region
> when SNP is enabled to satify new requirements for the SNP. Continue
> allocating a 1mb region for !SNP configuration.
>
> While at it, provide API that can be used by others to allocate a page
> that can be used by the firmware. The immediate user for this API will
> be the KVM driver. The KVM driver to need to allocate a firmware context
> page during the guest creation. The context page need to be updated
> by the firmware. See the SEV-SNP specification for further details.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 169 ++++++++++++++++++++++++++++++++++-
>  include/linux/psp-sev.h      |  11 +++
>  2 files changed, 176 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 01edad9116f2..34dc358b13b9 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -62,6 +62,14 @@ static int psp_timeout;
>  #define SEV_ES_TMR_SIZE                (1024 * 1024)
>  static void *sev_es_tmr;
>
> +/* When SEV-SNP is enabled the TMR needs to be 2MB aligned and 2MB size. */
> +#define SEV_SNP_ES_TMR_SIZE    (2 * 1024 * 1024)
> +
> +static size_t sev_es_tmr_size = SEV_ES_TMR_SIZE;
> +
> +static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret);
> +static int sev_do_cmd(int cmd, void *data, int *psp_ret);
> +
>  static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>  {
>         struct sev_device *sev = psp_master->sev_data;
> @@ -159,6 +167,156 @@ static int sev_cmd_buffer_len(int cmd)
>         return 0;
>  }
>
> +static void snp_leak_pages(unsigned long pfn, unsigned int npages)
> +{
> +       WARN(1, "psc failed, pfn 0x%lx pages %d (leaking)\n", pfn, npages);
> +       while (npages--) {
> +               memory_failure(pfn, 0);
> +               dump_rmpentry(pfn);
> +               pfn++;
> +       }
> +}
> +
> +static int snp_reclaim_pages(unsigned long pfn, unsigned int npages, bool locked)
> +{
> +       struct sev_data_snp_page_reclaim data;
> +       int ret, err, i, n = 0;
> +
> +       for (i = 0; i < npages; i++) {
> +               memset(&data, 0, sizeof(data));
> +               data.paddr = pfn << PAGE_SHIFT;
> +
> +               if (locked)
> +                       ret = __sev_do_cmd_locked(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
> +               else
> +                       ret = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
> +               if (ret)
> +                       goto cleanup;
> +
> +               ret = rmp_make_shared(pfn, PG_LEVEL_4K);
> +               if (ret)
> +                       goto cleanup;
> +
> +               pfn++;
> +               n++;
> +       }
> +
> +       return 0;
> +
> +cleanup:
> +       /*
> +        * If failed to reclaim the page then page is no longer safe to
> +        * be released, leak it.
> +        */
> +       snp_leak_pages(pfn, npages - n);
> +       return ret;
> +}
> +
> +static inline int rmp_make_firmware(unsigned long pfn, int level)
> +{
> +       return rmp_make_private(pfn, 0, level, 0, true);
> +}
> +
> +static int snp_set_rmp_state(unsigned long paddr, unsigned int npages, bool to_fw, bool locked,
> +                            bool need_reclaim)
> +{
> +       unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT; /* Cbit maybe set in the paddr */
> +       int rc, n = 0, i;
> +
> +       for (i = 0; i < npages; i++) {
> +               if (to_fw)
> +                       rc = rmp_make_firmware(pfn, PG_LEVEL_4K);
> +               else
> +                       rc = need_reclaim ? snp_reclaim_pages(pfn, 1, locked) :
> +                                           rmp_make_shared(pfn, PG_LEVEL_4K);
> +               if (rc)
> +                       goto cleanup;
> +
> +               pfn++;
> +               n++;
> +       }
> +
> +       return 0;
> +
> +cleanup:
> +       /* Try unrolling the firmware state changes */
> +       if (to_fw) {
> +               /*
> +                * Reclaim the pages which were already changed to the
> +                * firmware state.
> +                */
> +               snp_reclaim_pages(paddr >> PAGE_SHIFT, n, locked);
> +
> +               return rc;
> +       }
> +
> +       /*
> +        * If failed to change the page state to shared, then its not safe
> +        * to release the page back to the system, leak it.
> +        */
> +       snp_leak_pages(pfn, npages - n);
> +
> +       return rc;
> +}
> +
> +static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order, bool locked)
> +{
> +       unsigned long npages = 1ul << order, paddr;
> +       struct sev_device *sev;
> +       struct page *page;
> +
> +       if (!psp_master || !psp_master->sev_data)
> +               return ERR_PTR(-EINVAL);
> +
> +       page = alloc_pages(gfp_mask, order);
> +       if (!page)
> +               return NULL;
> +
> +       /* If SEV-SNP is initialized then add the page in RMP table. */
> +       sev = psp_master->sev_data;
> +       if (!sev->snp_inited)
> +               return page;
> +
> +       paddr = __pa((unsigned long)page_address(page));
> +       if (snp_set_rmp_state(paddr, npages, true, locked, false))
> +               return NULL;
> +
> +       return page;
> +}
> +
> +void *snp_alloc_firmware_page(gfp_t gfp_mask)
> +{
> +       struct page *page;
> +
> +       page = __snp_alloc_firmware_pages(gfp_mask, 0, false);
> +
> +       return page ? page_address(page) : NULL;
> +}
> +EXPORT_SYMBOL_GPL(snp_alloc_firmware_page);
> +
> +static void __snp_free_firmware_pages(struct page *page, int order, bool locked)
> +{
> +       unsigned long paddr, npages = 1ul << order;
> +
> +       if (!page)
> +               return;
> +
> +       paddr = __pa((unsigned long)page_address(page));
> +       if (snp_set_rmp_state(paddr, npages, false, locked, true))
> +               return;
> +
> +       __free_pages(page, order);
> +}
> +
> +void snp_free_firmware_page(void *addr)
> +{
> +       if (!addr)
> +               return;
> +
> +       __snp_free_firmware_pages(virt_to_page(addr), 0, false);
> +}
> +EXPORT_SYMBOL(snp_free_firmware_page);
> +
>  static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>  {
>         struct psp_device *psp = psp_master;
> @@ -281,7 +439,7 @@ static int __sev_platform_init_locked(int *error)
>
>                 data.flags |= SEV_INIT_FLAGS_SEV_ES;
>                 data.tmr_address = tmr_pa;
> -               data.tmr_len = SEV_ES_TMR_SIZE;
> +               data.tmr_len = sev_es_tmr_size;
>         }
>
>         rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> @@ -638,6 +796,8 @@ static int __sev_snp_init_locked(int *error)
>         sev->snp_inited = true;
>         dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
>
> +       sev_es_tmr_size = SEV_SNP_ES_TMR_SIZE;
> +
>         return rc;
>  }
>
> @@ -1161,8 +1321,9 @@ static void sev_firmware_shutdown(struct sev_device *sev)
>                 /* The TMR area was encrypted, flush it from the cache */
>                 wbinvd_on_all_cpus();
>
> -               free_pages((unsigned long)sev_es_tmr,
> -                          get_order(SEV_ES_TMR_SIZE));
> +               __snp_free_firmware_pages(virt_to_page(sev_es_tmr),
> +                                         get_order(sev_es_tmr_size),
> +                                         false);
Shouldn't there be a check here for snp_inited before calling rmpupdate.
TMR page can exist even if the SNP is not supported.

>                 sev_es_tmr = NULL;
>         }
>
> @@ -1233,7 +1394,7 @@ void sev_pci_init(void)
>         }
>
>         /* Obtain the TMR memory area for SEV-ES use */
> -       tmr_page = alloc_pages(GFP_KERNEL, get_order(SEV_ES_TMR_SIZE));
> +       tmr_page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(sev_es_tmr_size), false);
>         if (tmr_page) {
>                 sev_es_tmr = page_address(tmr_page);
>         } else {
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index f2105a8755f9..00bd684dc094 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -12,6 +12,8 @@
>  #ifndef __PSP_SEV_H__
>  #define __PSP_SEV_H__
>
> +#include <linux/sev.h>
> +
>  #include <uapi/linux/psp-sev.h>
>
>  #ifdef CONFIG_X86
> @@ -919,6 +921,8 @@ int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error);
>  int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error);
>
>  void *psp_copy_user_blob(u64 uaddr, u32 len);
> +void *snp_alloc_firmware_page(gfp_t mask);
> +void snp_free_firmware_page(void *addr);
>
>  #else  /* !CONFIG_CRYPTO_DEV_SP_PSP */
>
> @@ -960,6 +964,13 @@ static inline int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *erro
>         return -ENODEV;
>  }
>
> +static inline void *snp_alloc_firmware_page(gfp_t mask)
> +{
> +       return NULL;
> +}
> +
> +static inline void snp_free_firmware_page(void *addr) { }
> +
>  #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
>
>  #endif /* __PSP_SEV_H__ */
> --
> 2.17.1
>
>
