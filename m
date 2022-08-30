Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 344B7ECAAA1
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Aug 2022 09:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiH3JAZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Aug 2022 05:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiH3JAY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Aug 2022 05:00:24 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403862127E;
        Tue, 30 Aug 2022 02:00:18 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oSx6T-00GeWo-DQ; Tue, 30 Aug 2022 19:00:14 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 30 Aug 2022 17:00:13 +0800
Date:   Tue, 30 Aug 2022 17:00:13 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ignat Korchagin <ignat@cloudflare.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Subject: Re: [PATCH] crypto: akcipher - default implementations for setting
 private/public keys
Message-ID: <Yw3Rneo6Ik1QEfbG@gondor.apana.org.au>
References: <20220729165954.991-1-ignat@cloudflare.com>
 <Yv9dvvy0rK/1T0sU@gondor.apana.org.au>
 <CALrw=nEh7LX3DSCa3FTu8BYr4QWx+W2h3Jei9Qo67+XXH-Vegw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALrw=nEh7LX3DSCa3FTu8BYr4QWx+W2h3Jei9Qo67+XXH-Vegw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 29, 2022 at 11:48:23AM +0100, Ignat Korchagin wrote:
>
> I can only elaborate here as I didn't encounter any real-world
> use-cases, but may assume some limited crypto hardware device, which
> may somehow "encourage" doing public key operations in software and
> providing only "private-key" operations due to its limited resources.

In general if a hardware is missing a piece of the functinoality
required by the API then it should implement a software fallback.

The only time such a NULL helper would make sense if an algorithm
had no public key.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
