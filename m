Return-Path: <SRS0=EVKT=6F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C49DDC54FD0
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 12:33:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1FA72070B
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 12:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbgDUMdR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Apr 2020 08:33:17 -0400
Received: from 8bytes.org ([81.169.241.247]:36602 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728576AbgDUMdQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Apr 2020 08:33:16 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id CB4602B0; Tue, 21 Apr 2020 14:33:14 +0200 (CEST)
Date:   Tue, 21 Apr 2020 14:33:11 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Borislav Petkov <bp@alien8.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH] crypto: ccp: Add support for SEV-ES to the PSP driver
Message-ID: <20200421123311.GJ21900@8bytes.org>
References: <134926f3bcd38e51d5d0b0919afc7a16311d9c0f.1587412498.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <134926f3bcd38e51d5d0b0919afc7a16311d9c0f.1587412498.git.thomas.lendacky@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Tom,

On Mon, Apr 20, 2020 at 02:54:58PM -0500, Tom Lendacky wrote:
>  static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> @@ -214,6 +226,21 @@ static int __sev_platform_init_locked(int *error)
>  	if (sev->state == SEV_STATE_INIT)
>  		return 0;
>  
> +	if (sev_es_tmr) {
> +		u64 tmr_pa;
> +
> +		/*
> +		 * Do not include the encryption mask on the physical
> +		 * address of the TMR (firmware should clear it anyway).
> +		 */
> +		tmr_pa = __pa(sev_es_tmr);
> +		tmr_pa = ALIGN(tmr_pa, SEV_ES_TMR_ALIGN);

No need to manually align the region, see below.

> +	/* Obtain the TMR memory area for SEV-ES use */
> +	tmr_page = alloc_pages(GFP_KERNEL, get_order(SEV_ES_TMR_LEN));
> +	if (tmr_page) {
> +		sev_es_tmr = page_address(tmr_page);
> +	} else {
> +		sev_es_tmr = NULL;
> +		dev_warn(sev->dev,
> +			 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
> +	}

This allocates a 2M region where 1M is needed. The page allocator gives
you naturally aligned region for any allocation order, so when you
allocate 1M, it will automatically be 1M aligned.

Other than that this patch looks good to me.

Regards,

	Joerg
