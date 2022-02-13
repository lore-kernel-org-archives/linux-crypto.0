Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 938F5C433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Feb 2022 19:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234776AbiBMTr2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Feb 2022 14:47:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiBMTr1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Feb 2022 14:47:27 -0500
Received: from isilmar-4.linta.de (isilmar-4.linta.de [136.243.71.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F29CC48;
        Sun, 13 Feb 2022 11:47:20 -0800 (PST)
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
Received: from owl.dominikbrodowski.net (owl.brodo.linta [10.2.0.111])
        by isilmar-4.linta.de (Postfix) with ESMTPSA id AF2A520140E;
        Sun, 13 Feb 2022 19:47:18 +0000 (UTC)
Received: by owl.dominikbrodowski.net (Postfix, from userid 1000)
        id 88D6A80727; Sun, 13 Feb 2022 20:42:00 +0100 (CET)
Date:   Sun, 13 Feb 2022 20:42:00 +0100
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Kalle Valo <kvalo@kernel.org>, ath9k-devel@qca.qualcomm.com,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] random: pull add_hwgenerator_randomness() declaration
 into random.h
Message-ID: <YglfCDoerzbaviDP@owl.dominikbrodowski.net>
References: <20220213152522.816777-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220213152522.816777-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Sun, Feb 13, 2022 at 04:25:22PM +0100 schrieb Jason A. Donenfeld:
> add_hwgenerator_randomness() is a function implemented and documented
> inside of random.c. It is the way that hardware RNGs push data into it.
> Therefore, it should be declared in random.h. Otherwise sparse complains
> with:
> 
> random.c:1137:6: warning: symbol 'add_hwgenerator_randomness' was not declared. Should it be static?
> 
> The alternative would be to include hw_random.h into random.c, but that
> wouldn't really be good for anything except slowing down compile time.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
