Return-Path: <SRS0=6JMd=BC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA09C433E4
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 07:57:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83366206C1
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 07:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgGWH5R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jul 2020 03:57:17 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:34716 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgGWH5Q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jul 2020 03:57:16 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jyW6H-0005w1-NE; Thu, 23 Jul 2020 17:57:10 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 23 Jul 2020 17:57:09 +1000
Date:   Thu, 23 Jul 2020 17:57:09 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] padata cleanups
Message-ID: <20200723075709.GC14246@gondor.apana.org.au>
References: <20200714201356.889176-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714201356.889176-1-daniel.m.jordan@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 14, 2020 at 04:13:50PM -0400, Daniel Jordan wrote:
> These cleanups save ~5% of the padata text/data and make it a little
> easier to use and develop going forward.
> 
> In particular, they pave the way to extend padata's multithreading support to
> VFIO, a work-in-progress version of which can be found here:
> 
>     https://oss.oracle.com/git/gitweb.cgi?p=linux-dmjordan.git;a=shortlog;h=refs/heads/padata-mt-wip-v0.5
> 
> Based on v5.8-rc5.  As always, feedback is welcome.
> 
> Daniel
> 
> Daniel Jordan (6):
>   padata: remove start function
>   padata: remove stop function
>   padata: inline single call of pd_setup_cpumasks()
>   padata: remove effective cpumasks from the instance
>   padata: fold padata_alloc_possible() into padata_alloc()
>   padata: remove padata_parallel_queue
> 
>  Documentation/core-api/padata.rst |  18 +--
>  crypto/pcrypt.c                   |  17 +--
>  include/linux/padata.h            |  21 +---
>  kernel/padata.c                   | 177 ++++++------------------------
>  4 files changed, 46 insertions(+), 187 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
