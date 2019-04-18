Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0051DC10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:27:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD079206B6
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388879AbfDRO1K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 10:27:10 -0400
Received: from [5.180.42.13] ([5.180.42.13]:55192 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388819AbfDRO1J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 10:27:09 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hH80K-0004of-AD; Thu, 18 Apr 2019 22:27:08 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hH80H-0004EB-0v; Thu, 18 Apr 2019 22:27:05 +0800
Date:   Thu, 18 Apr 2019 22:27:05 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-crypto@vger.kernel.org,
        tglx@linutronix.de
Subject: Re: [PATCH] crypto: scompress - initialize per-CPU variables on each
 CPU
Message-ID: <20190418142704.xucqdfgei6jjge7s@gondor.apana.org.au>
References: <20190412151415.de33mytvtga6ihvi@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190412151415.de33mytvtga6ihvi@linutronix.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 12, 2019 at 05:14:15PM +0200, Sebastian Andrzej Siewior wrote:
> In commit 71052dcf4be70 ("crypto: scompress - Use per-CPU struct instead
> multiple variables") I accidentally initialized multiple times the memory on a
> random CPU. I should have initialize the memory on every CPU like it has
> been done earlier. I didn't notice this because the scheduler didn't
> move the task to another CPU.
> Guenter managed to do that and the code crashed as expected.
> 
> Allocate / free per-CPU memory on each CPU.
> 
> Fixes: 71052dcf4be70 ("crypto: scompress - Use per-CPU struct instead multiple variables")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> Guenter, this should cure that.
> 
>  crypto/scompress.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
