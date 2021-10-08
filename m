Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A324FC433FE
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Oct 2021 11:37:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8780C60F3A
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Oct 2021 11:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240691AbhJHLjN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Oct 2021 07:39:13 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55906 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240990AbhJHLgk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Oct 2021 07:36:40 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mYo9D-0002PM-0x; Fri, 08 Oct 2021 19:34:43 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mYo99-0006ye-PD; Fri, 08 Oct 2021 19:34:39 +0800
Date:   Fri, 8 Oct 2021 19:34:39 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] crypto: testmgr - Only disable migration in
 crypto_disable_simd_for_test()
Message-ID: <20211008113439.GA26495@gondor.apana.org.au>
References: <20210928115401.441339-1-bigeasy@linutronix.de>
 <YVyWrKUk81e10zM7@gmail.com>
 <20211007094224.owhdgujcln2zh2eg@linutronix.de>
 <YV8z/9WVdq3gM8rw@gmail.com>
 <20211007190332.3gijssg4lbwfxv6j@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007190332.3gijssg4lbwfxv6j@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 07, 2021 at 09:03:32PM +0200, Sebastian Andrzej Siewior wrote:
>
> Now that you bring it up, I was under the impression that the
> "SIMD-disabled" flag is only changed by the tcrypt module not by the
> individual tests which are performed at the algorithm lookup time. If it
> is the latter than yes, it will be painful. If it is just tcrypt then
> you could wrap the whole test-suite (at module init's time) into the
> kworker and bind it to one CPU).
> 
> Maybe Peter can bring light into the temporary workaround but it does
> look like simplest thing here.

Let's use migrate_disable for now.  If something better comes along
we can always change again.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
