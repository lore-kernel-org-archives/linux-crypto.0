Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7281BC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Mar 2022 09:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiCQJCX convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Mar 2022 05:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbiCQJCX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Mar 2022 05:02:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DFB1D08C3
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 02:01:05 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nUm0B-0002l7-6O; Thu, 17 Mar 2022 10:00:59 +0100
Received: from [2a0a:edc0:0:900:1d::4e] (helo=lupine)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nUm0A-001DY9-Hf; Thu, 17 Mar 2022 10:00:57 +0100
Received: from pza by lupine with local (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nUm08-0002xO-1q; Thu, 17 Mar 2022 10:00:56 +0100
Message-ID: <fec066f8f289be21f9d374eda93a4c75a11f2e15.camel@pengutronix.de>
Subject: Re: [PATCH] crypto: algapi - Remove test larvals to fix error paths
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        kernel@pengutronix.de, "David S. Miller" <davem@davemloft.net>
Date:   Thu, 17 Mar 2022 10:00:56 +0100
In-Reply-To: <YjJgR2FxAaXNHhTa@gondor.apana.org.au>
References: <20220126145322.646723-1-p.zabel@pengutronix.de>
         <c572bf6f0b0a5d7fd3f8f0744a85eb5660a003d4.camel@pengutronix.de>
         <YjE5UCeoziA8f+Q4@gondor.apana.org.au>
         <CAMj1kXF-BdRCN-239cRHgSGM3K9EPSrRFEDJu+e6Gtri2pONaA@mail.gmail.com>
         <YjJgR2FxAaXNHhTa@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Do, 2022-03-17 at 10:10 +1200, Herbert Xu wrote:
> On Wed, Mar 16, 2022 at 08:23:24AM +0100, Ard Biesheuvel wrote:
> > 
> > According to the bisect log in the other thread,
> > adad556efcdd42a1d9e060cb is the culprit, which does not seem
> > surprising, at is would result in the SIMD skcipher being
> > encapsulated
> > to not be available yet when the SIMD helper tries to take a
> > reference
> > to it.
> 
> It's supposed to work because any use of an algorithm prior to
> the tests starting will automatically trigger the test right away.
> I confirmed this by booting the kernel in qemu with AES_ARM_BS=y
> and it successfully registered those algorithms and passed the
> self-tests.
> 
> Someone else has already sent me a complete kconfig file which
> hopefully should reproduce the crash for me.

It seems you already did. I can confirm that [1] fixes the crash for
me, as I had CRYPTO_CBC disabled. After enabling it, aes_init() doesn't
hit the error path anymore, hiding the BUG() again.

[1] https://lore.kernel.org/all/YjJq0RLIHvN7YWaT@gondor.apana.org.au/

regards
Philipp
