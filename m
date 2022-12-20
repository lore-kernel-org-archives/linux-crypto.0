Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB23C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Dec 2022 03:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbiLTDzx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Dec 2022 22:55:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiLTDzu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Dec 2022 22:55:50 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB008B1DD;
        Mon, 19 Dec 2022 19:55:48 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1p7TjE-008kHh-3m; Tue, 20 Dec 2022 11:55:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 20 Dec 2022 11:55:44 +0800
Date:   Tue, 20 Dec 2022 11:55:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Robert Elliott <elliott@hpe.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] crypto: tcrypt - yield at end of test
Message-ID: <Y6EyQOBeUT9/PvJT@gondor.apana.org.au>
References: <20221219203733.3063192-1-elliott@hpe.com>
 <20221219203733.3063192-4-elliott@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219203733.3063192-4-elliott@hpe.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 19, 2022 at 02:37:33PM -0600, Robert Elliott wrote:
> Call cond_resched() to let the scheduler reschedule the
> CPU at the end of each test pass.
> 
> If the kernel is configured with CONFIG_PREEMPT_NONE=y (or
> preempt=none is used on the kernel command line), the only
> time the scheduler will intervene is when cond_resched()
> is called. So, repeated calls to
> 	modprobe tcrypt mode=<something>
> 
> hold the CPU for a long time.
> 
> Signed-off-by: Robert Elliott <elliott@hpe.com>
> ---
>  crypto/tcrypt.c | 1 +
>  1 file changed, 1 insertion(+)

I don't really see the point of this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
