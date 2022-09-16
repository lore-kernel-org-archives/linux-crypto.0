Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59AFBECAAD8
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Sep 2022 06:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiIPGYK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Sep 2022 02:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiIPGYJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2022 02:24:09 -0400
Received: from isilmar-4.linta.de (isilmar-4.linta.de [136.243.71.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D5774371;
        Thu, 15 Sep 2022 23:24:08 -0700 (PDT)
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
Received: from owl.dominikbrodowski.net (owl.brodo.linta [10.2.0.111])
        by isilmar-4.linta.de (Postfix) with ESMTPSA id A8E6C201373;
        Fri, 16 Sep 2022 06:24:05 +0000 (UTC)
Received: by owl.dominikbrodowski.net (Postfix, from userid 1000)
        id E647F806E7; Fri, 16 Sep 2022 08:22:53 +0200 (CEST)
Date:   Fri, 16 Sep 2022 08:22:53 +0200
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     Sven van Ashbrook <svenva@chromium.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Olivia Mackall <olivia@selenic.com>,
        Alex Levin <levinale@google.com>,
        Andrey Pronin <apronin@google.com>,
        Stephen Boyd <swboyd@google.com>,
        Rajat Jain <rajatja@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Petr Mladek <pmladek@suse.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Theodore Ts'o <tytso@mit.edu>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 1/2] random: move add_hwgenerator_randomness()'s wait
 outside function
Message-ID: <YyQWPcxG1Xc1qRWE@owl.dominikbrodowski.net>
References: <20220915002235.v2.1.I7c0a79e9b3c52584f5b637fde5f1d6f807605806@changeid>
 <YyNIOg1mtnzQz1H7@zx2c4.com>
 <CAG-rBijUSQ-kA0-pS=JCVX9ydeaSCd9Ub=yryGk4zsbcv3dTzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG-rBijUSQ-kA0-pS=JCVX9ydeaSCd9Ub=yryGk4zsbcv3dTzQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Thu, Sep 15, 2022 at 02:54:24PM -0400 schrieb Sven van Ashbrook:
> Dominik, Jason,
> 
> On Thu, Sep 15, 2022 at 11:44 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > Isn't Dominik working on the same thing, but slightly different?
> 
> I don't believe Dominik is working on quite the same thing, but his
> work will conflict with mine for sure:
> https://lore.kernel.org/lkml/YxiXEJ6up6XEW8SM@zx2c4.com/T/
> 
> What are the odds that two people are making changes to the hwrng
> kthread at the same time?
> 
> I see two possible ways forward:
> 1. Dominik rebases his patch against mine (iff mine finds favour).
> This may simplify his patch
> quite a bit, because the delayed_work abstraction tends to have fewer
> footguns than
> kthread.
> 
> or
> 
> 2. I rebase against Dominik's.
> 
> Both are fine with me, just let me know what you think.

Indeed, our patches address different issues. I'm fine with both approaches,
i.e. my patches to be based on Sven's, or the other way round.

Best,
	Dominik
