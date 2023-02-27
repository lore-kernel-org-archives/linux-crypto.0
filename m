Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB2B3C64ED6
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Feb 2023 09:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjB0JXz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Feb 2023 04:23:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB0JXu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Feb 2023 04:23:50 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FACB9
        for <linux-crypto@vger.kernel.org>; Mon, 27 Feb 2023 01:23:49 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pWZ0M-00FyPW-FM; Mon, 27 Feb 2023 16:37:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 27 Feb 2023 16:37:06 +0800
Date:   Mon, 27 Feb 2023 16:37:06 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Mark Brown <broonie@kernel.org>
Cc:     Michael Walle <michael@walle.cc>, kernelci-results@groups.io,
        bot@kernelci.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org
Subject: Re: mainline/master bisection: baseline.dmesg.emerg on
 kontron-pitx-imx8m
Message-ID: <Y/xrsjc6RKa/o3hi@gondor.apana.org.au>
References: <63f7cbc9.170a0220.3200f.5d74@mx.google.com>
 <Y/i1tX6th2I8hY0o@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/i1tX6th2I8hY0o@sirena.org.uk>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 24, 2023 at 01:03:49PM +0000, Mark Brown wrote:
>
> The algorithms selftests are failing:
> 
>   alg: self-tests for cbc(aes) using cbc-aes-caam failed (rc=-22)
>   alg: self-tests for cbc(des3_ede) using cbc-3des-caam failed (rc=-22)
>   alg: self-tests for cbc(des) using  failed (rc=-22)

Thanks for the report.  I'm aware of the problem and a v2 patch will
be available soon on the thread at

https://lore.kernel.org/linux-crypto/DU0PR04MB9563F6D1EFBC6165087D51EF8EAF9@DU0PR04MB9563.eurprd04.prod.outlook.com/T/#u

Unfortunately due to vger issues the patch is still in the mail
queue.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
