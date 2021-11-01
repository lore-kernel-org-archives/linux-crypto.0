Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6110C433EF
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 16:29:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 827BD60EE5
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 16:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbhKAQcM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Nov 2021 12:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbhKAQcM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Nov 2021 12:32:12 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05548C061714
        for <linux-crypto@vger.kernel.org>; Mon,  1 Nov 2021 09:29:39 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id v19-20020a9d69d3000000b00555a7318f31so13941859oto.9
        for <linux-crypto@vger.kernel.org>; Mon, 01 Nov 2021 09:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yMztWhCfAglGK8Jqxt8H7Nu8Sfhj9gYl1BXkqqHvdrI=;
        b=lAYyI2ghDFVS9OBei65Ta5hFe+Z0ZJweRC/wAmqcFmOBwl6ROV11QfgoWgXTbVIpo/
         3fL3otK9p4xv+bxJgry4JL0PERXg2IiYuE19n35+a0L40hZR3yv+kVhSqihA3oNOWqsq
         Gxat2zgmufRGJweJydGDlvbRCXCTGVJOz1pEu71RgZ+zQDYEn/SstiaOtHYmuxyMm99l
         Tik+gYRe4NGeIvGNV+nmU6nbj+kU1QbXQF/hOlBE92e0lm7u25rZaPISY+rkrtPn+Fvc
         qX6E3v7VrL/MSyV12axvnRhh2IdVF169IHX+SiuC1Dr67PvVQUO4sGq4/v/jEUYCJZ17
         5wiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yMztWhCfAglGK8Jqxt8H7Nu8Sfhj9gYl1BXkqqHvdrI=;
        b=XSqxNClV21EpckDyfeRaWg7227Ntb1xY1S68q5VMKN6N739zmdHVBqltOvFERSarw3
         npYE/1w+AhxDXVOY741diPwr8OS9DH+5veeqyzaQRD1c/8vrYgFcjUTn1b+fRqf7ki9B
         t+6KlL5wT/56k12Qoyvj42k+MC89eswMmjWA0zXL5rk+1hLjwJIF9ar7I9A8fTYnnRFY
         TZS+alEle/89248JQUMOMKF0EEVmd38ja3hH89U+JCj50727YGIhtyilC3O+39gHCR5k
         IxSQmgffSpYMn/YMfgwied2wJiFkRmCIesXtscvcvpAGpEqMH5N2RTYZCDFBfHb8Xyu7
         qToA==
X-Gm-Message-State: AOAM533UEyYUHj50IvxpU81XCnAuxc8gb4dJDZ3+bbcpNUZ1GMQuMBmb
        Nv/0wXVEkY21A+yrQWJaMO0I8OkkRX+iwmmKle6OZw==
X-Google-Smtp-Source: ABdhPJy2kvGCpYG33j1mPhUCgVfVhwpEW5luRD+s/g/rEeYuypcAKOAFRoqudgXNk1+DB0HCsuY6IGyfAxvDh2BkGek=
X-Received: by 2002:a9d:171b:: with SMTP id i27mr20596402ota.25.1635784178082;
 Mon, 01 Nov 2021 09:29:38 -0700 (PDT)
MIME-Version: 1.0
References: <20211028175749.1219188-1-pgonda@google.com> <20211028175749.1219188-4-pgonda@google.com>
In-Reply-To: <20211028175749.1219188-4-pgonda@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Mon, 1 Nov 2021 09:29:27 -0700
Message-ID: <CAA03e5FV5FRFJm4K8WyL745B84URz65LVMNagi=LPFKP35xJGg@mail.gmail.com>
Subject: Re: [PATCH 3/4] crypto: ccp - Refactor out sev_fw_alloc()
To:     Peter Gonda <pgonda@google.com>
Cc:     Thomas.Lendacky@amd.com, David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 28, 2021 at 10:58 AM Peter Gonda <pgonda@google.com> wrote:
>
> Creates a helper function sev_fw_alloc() which can be used to allocate
> aligned memory regions for use by the PSP firmware. Currently only used
> for the SEV-ES TMR region but will be used for the SEV_INIT_EX NV memory
> region.
>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David Rientjes <rientjes@google.com>
> Cc: John Allen <john.allen@amd.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Paolo Bonzini <pbonzini@redhat.com> (
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/crypto/ccp/sev-dev.c | 24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index e4bc833949a0..b568ae734857 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -141,6 +141,21 @@ static int sev_cmd_buffer_len(int cmd)
>         return 0;
>  }
>
> +static void *sev_fw_alloc(unsigned long len)
> +{
> +       const int order = get_order(len);
> +       struct page *page;
> +
> +       if (order > MAX_ORDER-1)
> +               return NULL;
> +
> +       page = alloc_pages(GFP_KERNEL, order);
> +       if (!page)
> +               return NULL;
> +
> +       return page_address(page);
> +}
> +
>  static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>  {
>         struct psp_device *psp = psp_master;
> @@ -1076,7 +1091,6 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
>  void sev_pci_init(void)
>  {
>         struct sev_device *sev = psp_master->sev_data;
> -       struct page *tmr_page;
>         int error = 0, rc;
>
>         if (!sev)
> @@ -1092,14 +1106,10 @@ void sev_pci_init(void)
>                 sev_get_api_version();
>
>         /* Obtain the TMR memory area for SEV-ES use */
> -       tmr_page = alloc_pages(GFP_KERNEL, get_order(SEV_ES_TMR_SIZE));
> -       if (tmr_page) {
> -               sev_es_tmr = page_address(tmr_page);
> -       } else {
> -               sev_es_tmr = NULL;
> +       sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
> +       if (!sev_es_tmr)
>                 dev_warn(sev->dev,
>                          "SEV: TMR allocation failed, SEV-ES support unavailable\n");
> -       }
>
>         /* Initialize the platform */
>         rc = sev_platform_init(&error);
> --
> 2.33.1.1089.g2158813163f-goog
>

Reviewed-by: Marc Orr <marcorr@google.com>
