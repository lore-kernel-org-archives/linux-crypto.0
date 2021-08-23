Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB9A1C4338F
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Aug 2021 07:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E99F61356
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Aug 2021 07:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234976AbhHWHeH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Aug 2021 03:34:07 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:53767 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234861AbhHWHeG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Aug 2021 03:34:06 -0400
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3A7eIjsakUEYwYax48EGTddVtgDVTpDfIL3DAb?=
 =?us-ascii?q?v31ZSRFFG/Fw9vre4cjzuiWVtN98YhwdcJW7Scy9qBDnhOJICOsqTNSftWDd0Q?=
 =?us-ascii?q?PCRr2Kr7GSoQEIcBeQygcp78Zdmt9FZuEYY2IXsS/S2njeLz57qOP3lpxAzt2u?=
 =?us-ascii?q?q0uFBTsaEp2Jum9Ce32m+mUffng9OXIRfKDsnvZ6mw=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.84,326,1620684000"; 
   d="scan'208";a="524806179"
Received: from xanadu.blop.info ([178.79.145.134])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2021 09:33:22 +0200
Date:   Mon, 23 Aug 2021 09:32:56 +0200
From:   Lucas Nussbaum <lucas.nussbaum@inria.fr>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] crypto: ccp: shutdown SEV firmware on kexec
Message-ID: <YSNPKPPjEFxGT0Dc@xanadu.blop.info>
References: <20210728151521.5319-1-brijesh.singh@amd.com>
 <20210806121442.GB25554@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210806121442.GB25554@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 06/08/21 at 20:14 +0800, Herbert Xu wrote:
> On Wed, Jul 28, 2021 at 10:15:21AM -0500, Brijesh Singh wrote:
> > The commit 97f9ac3db6612 ("crypto: ccp - Add support for SEV-ES to the
> > PSP driver") added support to allocate Trusted Memory Region (TMR)
> > used during the SEV-ES firmware initialization. The TMR gets locked
> > during the firmware initialization and unlocked during the shutdown.
> > While the TMR is locked, access to it is disallowed.
> > 
> > Currently, the CCP driver does not shutdown the firmware during the
> > kexec reboot, leaving the TMR memory locked.
> > 
> > Register a callback to shutdown the SEV firmware on the kexec boot.
> > 
> > Fixes: 97f9ac3db6612 ("crypto: ccp - Add support for SEV-ES to the PSP driver")
> > Reported-by: Lucas Nussbaum <lucas.nussbaum@inria.fr>
> > Tested-by: Lucas Nussbaum <lucas.nussbaum@inria.fr>
> > Cc: <stable@kernel.org>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: Joerg Roedel <jroedel@suse.de>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: David Rientjes <rientjes@google.com>
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > ---
> >  drivers/crypto/ccp/sev-dev.c | 49 +++++++++++++++++-------------------
> >  drivers/crypto/ccp/sp-pci.c  | 12 +++++++++
> >  2 files changed, 35 insertions(+), 26 deletions(-)
> 
> Patch applied.  Thanks.

Could this be backported to 5.10 as well?

Thanks
-- 
Lucas Nussbaum   <lucas.nussbaum@inria.fr>   +33 3 54 95 86 19
Responsable du programme plateformes d'expérimentation
DDO-SDT - Direction Générale Déléguée à l'Innovation - Inria
