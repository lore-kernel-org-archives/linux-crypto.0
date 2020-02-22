Return-Path: <SRS0=tFxg=4K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44CABC35669
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Feb 2020 01:41:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1124820722
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Feb 2020 01:41:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbgBVBlr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Feb 2020 20:41:47 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:52202 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726912AbgBVBlr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Feb 2020 20:41:47 -0500
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1j5JnR-0002uz-Gc; Sat, 22 Feb 2020 12:41:34 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Feb 2020 12:41:33 +1100
Date:   Sat, 22 Feb 2020 12:41:33 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: fix uninitialized return value in
 padata_replace()
Message-ID: <20200222014133.GB19028@gondor.apana.org.au>
References: <20200210181100.1288437-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210181100.1288437-1-daniel.m.jordan@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 10, 2020 at 01:11:00PM -0500, Daniel Jordan wrote:
> According to Geert's report[0],
> 
>   kernel/padata.c: warning: 'err' may be used uninitialized in this
>     function [-Wuninitialized]:  => 539:2
> 
> Warning is seen only with older compilers on certain archs.  The
> runtime effect is potentially returning garbage down the stack when
> padata's cpumasks are modified before any pcrypt requests have run.
> 
> Simplest fix is to initialize err to the success value.
> 
> [0] http://lkml.kernel.org/r/20200210135506.11536-1-geert@linux-m68k.org
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Fixes: bbefa1dd6a6d ("crypto: pcrypt - Avoid deadlock by using per-instance padata queues")
> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  kernel/padata.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
