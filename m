Return-Path: <SRS0=3pbX=6O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B9F1C83001
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 05:30:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54D8A2073E
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 05:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgD3Fan (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Apr 2020 01:30:43 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60318 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726378AbgD3Fan (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Apr 2020 01:30:43 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jU1kq-0005J4-63; Thu, 30 Apr 2020 15:29:01 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Apr 2020 15:29:53 +1000
Date:   Thu, 30 Apr 2020 15:29:53 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v2] crypto: ccp: Add support for SEV-ES to the PSP driver
Message-ID: <20200430052953.GB11738@gondor.apana.org.au>
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
> ---
>  drivers/crypto/ccp/sev-dev.c | 43 ++++++++++++++++++++++++++++++++++++
>  include/linux/psp-sev.h      |  2 ++
>  include/uapi/linux/psp-sev.h |  2 ++
>  3 files changed, 47 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
