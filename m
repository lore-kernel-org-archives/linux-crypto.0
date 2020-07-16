Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CD04C433E8
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 07:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 069D22071B
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 07:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgGPHam (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 03:30:42 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:39686 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727768AbgGPHam (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 03:30:42 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jvyLg-0003eF-K6; Thu, 16 Jul 2020 17:30:33 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Jul 2020 17:30:32 +1000
Date:   Thu, 16 Jul 2020 17:30:32 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, nhorman@redhat.com, simo@redhat.com
Subject: Re: [PATCH v2 2/5] lib/mpi: Add mpi_sub_ui()
Message-ID: <20200716073032.GA28173@gondor.apana.org.au>
References: <2543601.mvXUDI8C0e@positron.chronox.de>
 <5722559.lOV4Wx5bFT@positron.chronox.de>
 <4650810.GXAFRqVoOG@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4650810.GXAFRqVoOG@positron.chronox.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Jul 12, 2020 at 06:39:54PM +0200, Stephan Müller wrote:
>
> diff --git a/lib/mpi/mpi-sub-ui.c b/lib/mpi/mpi-sub-ui.c
> new file mode 100644
> index 000000000000..fa6b085bac36
> --- /dev/null
> +++ b/lib/mpi/mpi-sub-ui.c
> @@ -0,0 +1,60 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/* mpi-sub-ui.c  -  MPI functions
> + *      Copyright 1991, 1993, 1994, 1996, 1999-2002, 2004, 2012, 2013, 2015
> + *      Free Software Foundation, Inc.
> + *
> + * This file is part of GnuPG.
> + *
> + * Note: This code is heavily based on the GNU MP Library.
> + *	 Actually it's the same code with only minor changes in the
> + *	 way the data is stored; this is to support the abstraction
> + *	 of an optional secure memory allocation which may be used
> + *	 to avoid revealing of sensitive data due to paging etc.
> + *	 The GNU MP Library itself is published under the LGPL;
> + *	 however I decided to publish this code under the plain GPL.
> + */

Hmm, you said that this code is from GNU MP.  But this notice clearly
says that it's part of GnuPG and is under GPL.  Though it doesn't
clarify what version of GPL it is.  Can you please clarify this with
the author?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
