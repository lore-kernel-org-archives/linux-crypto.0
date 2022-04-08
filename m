Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EBEDC433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Apr 2022 08:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbiDHI0i (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Apr 2022 04:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbiDHI0h (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Apr 2022 04:26:37 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0916A1A5D7B;
        Fri,  8 Apr 2022 01:24:33 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ncjul-000S71-SA; Fri, 08 Apr 2022 18:24:21 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 08 Apr 2022 16:24:20 +0800
Date:   Fri, 8 Apr 2022 16:24:20 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     jernej.skrabec@gmail.com, samuel@sholland.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        clabbe@baylibre.com
Subject: Re: [PATCH 00/19] crypto: allwinner: lots of fixes
Message-ID: <Yk/xNIjjINj9Hvki@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317205605.3924836-1-clabbe@baylibre.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Corentin Labbe <clabbe@baylibre.com> wrote:
> Hello
> 
> This series is all fixes which I found on allwinner crypto drivers.

This doesn't compile cleanly with sparse.  Please fix and resubmit.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
