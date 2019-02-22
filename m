Return-Path: <SRS0=rdxF=Q5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D9EC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 12:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3756A20818
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 12:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbfBVMBG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Feb 2019 07:01:06 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:54858 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfBVMBG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Feb 2019 07:01:06 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gx9Vo-0000dh-QY; Fri, 22 Feb 2019 20:01:04 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gx9Vl-0007EZ-7y; Fri, 22 Feb 2019 20:01:01 +0800
Date:   Fri, 22 Feb 2019 20:01:01 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: ccp - Update driver messages to remove some
 confusion
Message-ID: <20190222120101.demmblj6ri4hkckk@gondor.apana.org.au>
References: <155025159161.22636.12469459044882251074.stgit@tlendack-t1.amdoffice.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155025159161.22636.12469459044882251074.stgit@tlendack-t1.amdoffice.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 15, 2019 at 05:26:33PM +0000, Lendacky, Thomas wrote:
> The current content of some of the driver messages and the way that they
> are issued results in some confusion, especially in the area of the PSP
> as it relates to SEV support. If SEV is not supported, a message is issued
> that says "psp initialization failed." This makes it seem like there was
> a problem, when in fact, the PSP support is just disabled if SEV is not
> supported.
> 
> Update the driver to check SEV support a bit earlier and issue a debug-
> level message if SEV is not supported, followed by a debug-level message
> that the PSP is disabled. This way you will only see PSP messages if SEV
> is supported or if debug information is desired. Also, remove the overall
> "enabled" and "disabled" messages for the driver and rely on the CCP and
> PSP support to issue component-specific messages.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  drivers/crypto/ccp/psp-dev.c |   19 ++++++++++++++-----
>  drivers/crypto/ccp/sp-pci.c  |    4 ----
>  2 files changed, 14 insertions(+), 9 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
