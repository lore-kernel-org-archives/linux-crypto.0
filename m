Return-Path: <SRS0=SZPK=6N=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 843A7C83003
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Apr 2020 11:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FB41206B8
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Apr 2020 11:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgD2LXS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Apr 2020 07:23:18 -0400
Received: from 8bytes.org ([81.169.241.247]:39474 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbgD2LXS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Apr 2020 07:23:18 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 8EDA22E2; Wed, 29 Apr 2020 13:23:16 +0200 (CEST)
Date:   Wed, 29 Apr 2020 13:23:15 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Borislav Petkov <bp@alien8.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v2] crypto: ccp: Add support for SEV-ES to the PSP driver
Message-ID: <20200429112315.GO21900@8bytes.org>
References: <9530369b1f0be211ae2512a1ab9f54281a4420d9.1587491088.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9530369b1f0be211ae2512a1ab9f54281a4420d9.1587491088.git.thomas.lendacky@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 21, 2020 at 12:44:49PM -0500, Tom Lendacky wrote:
> To provide support for SEV-ES, the hypervisor must provide an area of
> memory to the PSP. Once this Trusted Memory Region (TMR) is provided to
> the PSP, the contents of this area of memory are no longer available to
> the x86.
> 
> Update the PSP driver to allocate a 1MB region for the TMR that is 1MB
> aligned and then provide it to the PSP through the SEV INIT command.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> ---
> 
> Changes since v1:
> - No need to over-allocate the memory area to obtain the required
>   alignment when using the page allocator.

Reviewed-by: Joerg Roedel <jroedel@suse.de>

