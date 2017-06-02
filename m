From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: get_random_bytes returns bad randomness before seeding is complete
Date: Fri, 2 Jun 2017 18:48:25 +0200
Message-ID: <CAHmME9oWGm62sNON7M=9rVLcDDNCnWA1i+9PxxRRiaFYpwCP8g@mail.gmail.com>
References: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com>
 <CAHmME9omJTaP1C=yUh3913Cv1gF1pBtpy9cmEMyJG4yw_dnZWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Stephan Mueller <smueller@chronox.de>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:36861 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751140AbdFBQs2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Jun 2017 12:48:28 -0400
In-Reply-To: <CAHmME9omJTaP1C=yUh3913Cv1gF1pBtpy9cmEMyJG4yw_dnZWQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Further investigations: if the whack-a-mole approach is desirable,
perhaps many of those get_random_bytes calls should be converted to
get_blocking_random_bytes. In that case, this commit, which removed
this helpful API, should be reverted:

commit c2719503f5e1e6213d716bb078bdad01e28ebcbf
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Tue Jun 9 18:19:42 2015 +0800

   random: Remove kernel blocking API

   This patch removes the kernel blocking API as it has been completely
   replaced by the callback API.

   Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/char/random.c b/drivers/char/random.c
index a1576ed1d88e..d0da5d852d41 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1265,18 +1265,6 @@ void get_random_bytes(void *buf, int nbytes)
EXPORT_SYMBOL(get_random_bytes);

/*
- * Equivalent function to get_random_bytes with the difference that this
- * function blocks the request until the nonblocking_pool is initialized.
- */
-void get_blocking_random_bytes(void *buf, int nbytes)
-{
-       if (unlikely(nonblocking_pool.initialized == 0))
-               wait_event(urandom_init_wait, nonblocking_pool.initialized);
-       extract_entropy(&nonblocking_pool, buf, nbytes, 0, 0);
-}
-EXPORT_SYMBOL(get_blocking_random_bytes);
-
-/*
