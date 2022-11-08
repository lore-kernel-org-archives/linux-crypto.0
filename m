Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE1BC433FE
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Nov 2022 09:58:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbiKHJ6b (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Nov 2022 04:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232939AbiKHJ6a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Nov 2022 04:58:30 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5EC62DF
        for <linux-crypto@vger.kernel.org>; Tue,  8 Nov 2022 01:58:24 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1osLMW-00BT50-3t; Tue, 08 Nov 2022 17:58:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 08 Nov 2022 17:58:20 +0800
Date:   Tue, 8 Nov 2022 17:58:20 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH v3] hw_random: use add_hwgenerator_randomness() for early
 entropy
Message-ID: <Y2ooPPcqiTgQLDqm@gondor.apana.org.au>
References: <Y2fJy1akGIdQdH95@zx2c4.com>
 <20221106150243.150437-1-Jason@zx2c4.com>
 <Y2hqsz8kjJgwNm0E@gondor.apana.org.au>
 <CAHmME9odRaJYThnkfoss7Zvy8EPahwkk5Ey9J6XiZMgGQevfaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9odRaJYThnkfoss7Zvy8EPahwkk5Ey9J6XiZMgGQevfaQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 07, 2022 at 01:55:53PM +0100, Jason A. Donenfeld wrote:
>
> Okay, will do. But by the way, feel free to change your mind about
> this if need be. For example, I sent another patch that touches core.c
> too (the entropy quality one). It touches different lines, so there
> shouldn't be a conflict, but if it's still annoying for you and you
> want to take them both, just pipe up and I'll drop this one from my
> tree.

They look like they shouldn't really conflict so it should be
fine.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
