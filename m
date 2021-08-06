Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92EF4C4338F
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Aug 2021 12:14:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 702ED61102
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Aug 2021 12:14:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343611AbhHFMPF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Aug 2021 08:15:05 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51752 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343589AbhHFMPF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Aug 2021 08:15:05 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mBykS-0003hR-P7; Fri, 06 Aug 2021 20:14:48 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mBykN-0006f0-1k; Fri, 06 Aug 2021 20:14:43 +0800
Date:   Fri, 6 Aug 2021 20:14:43 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        lucas.nussbaum@inria.fr, stable@kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] crypto: ccp: shutdown SEV firmware on kexec
Message-ID: <20210806121442.GB25554@gondor.apana.org.au>
References: <20210728151521.5319-1-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728151521.5319-1-brijesh.singh@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 28, 2021 at 10:15:21AM -0500, Brijesh Singh wrote:
> The commit 97f9ac3db6612 ("crypto: ccp - Add support for SEV-ES to the
> PSP driver") added support to allocate Trusted Memory Region (TMR)
> used during the SEV-ES firmware initialization. The TMR gets locked
> during the firmware initialization and unlocked during the shutdown.
> While the TMR is locked, access to it is disallowed.
> 
> Currently, the CCP driver does not shutdown the firmware during the
> kexec reboot, leaving the TMR memory locked.
> 
> Register a callback to shutdown the SEV firmware on the kexec boot.
> 
> Fixes: 97f9ac3db6612 ("crypto: ccp - Add support for SEV-ES to the PSP driver")
> Reported-by: Lucas Nussbaum <lucas.nussbaum@inria.fr>
> Tested-by: Lucas Nussbaum <lucas.nussbaum@inria.fr>
> Cc: <stable@kernel.org>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David Rientjes <rientjes@google.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 49 +++++++++++++++++-------------------
>  drivers/crypto/ccp/sp-pci.c  | 12 +++++++++
>  2 files changed, 35 insertions(+), 26 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
