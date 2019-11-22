Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95DBFC432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 11:10:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DB7D2071C
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 11:10:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbfKVLKE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 06:10:04 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:53228 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730998AbfKVLCb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 06:02:31 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iY6hq-0004Pj-P9; Fri, 22 Nov 2019 19:02:30 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iY6hp-0002cq-Gh; Fri, 22 Nov 2019 19:02:29 +0800
Date:   Fri, 22 Nov 2019 19:02:29 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     linux-crypto@vger.kernel.org, Gary Hook <gary.hook@amd.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] crypto: ccp: add SEV command privilege separation
Message-ID: <20191122110229.dui2iqfys7z5rbwz@gondor.apana.org.au>
References: <20191112195834.7795-1-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112195834.7795-1-brijesh.singh@amd.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 12, 2019 at 01:58:34PM -0600, Brijesh Singh wrote:
> Currently, there is no privilege separation of the SEV command; you can
> run them all or none of them. This is less than ideal because it means
> that a compromise of the code which launches VMs could make permanent
> change to the SEV certifcate chain which will affect others.
> 
> These commands are required to attest the VM environment:
>  - SEV_PDH_CERT_EXPORT
>  - SEV_PLATFORM_STATUS
>  - SEV_GET_{ID,ID2}
> 
> These commands manage the SEV certificate chain:
>  - SEV_PEK_CERR_IMPORT
>  - SEV_FACTORY_RESET
>  - SEV_PEK_GEN
>  - SEV_PEK_CSR
>  - SEV_PDH_GEN
> 
> Lets add the CAP_SYS_ADMIN check for the group of the commands which alters
> the SEV certificate chain to provide some level of privilege separation.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Gary Hook <gary.hook@amd.com>
> Cc: Erdem Aktas <erdemaktas@google.com>
> Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
> Tested-by: David Rientjes <rientjes@google.com>
> Co-developed-by: David Rientjes <rientjes@google.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  drivers/crypto/ccp/psp-dev.c | 29 ++++++++++++++++++++++-------
>  drivers/crypto/ccp/psp-dev.h |  1 +
>  2 files changed, 23 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
