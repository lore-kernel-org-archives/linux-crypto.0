Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 820D7C3DA6F
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Aug 2023 05:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239248AbjHXFSE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Aug 2023 01:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239934AbjHXFRy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Aug 2023 01:17:54 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0871706
        for <linux-crypto@vger.kernel.org>; Wed, 23 Aug 2023 22:17:49 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qZ2j2-007EZF-Po; Thu, 24 Aug 2023 13:17:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Aug 2023 13:17:45 +0800
Date:   Thu, 24 Aug 2023 13:17:45 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [v2 PATCH] wireguard: do not include crypto/algapi.h
Message-ID: <ZObn+Xmyo47wsLGV@gondor.apana.org.au>
References: <ZOXf3JTIqhRLbn5j@gondor.apana.org.au>
 <E1qYlAB-006vJI-Cv@formenos.hmeau.com>
 <CAHmME9qwYhM55he7WyWQZXwSg9Ri6-9K31tHHqaKcMYFEJYxTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9qwYhM55he7WyWQZXwSg9Ri6-9K31tHHqaKcMYFEJYxTw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 23, 2023 at 01:48:47PM +0200, Jason A. Donenfeld wrote:
>
> Small nit - with the exception of the cookie.c reordering, could you
> maintain the existing #include ordering of the other files? No need to
> send a v2 for that if you don't want. And please make the entire
> commit subject lowercase. With those done,
> 
> Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>

Thanks.  As these patches are independent of each other, I'll just
repost this one patch and delete it from the original series.

> As a side note, you may want to eventually do something to make sure
> people don't add back algapi.h, like move it to internal/ or out of
> include/ all together. I figure you've already thought about this, and
> this series is just the first step.

Sure that is the idea.  Although judging from the result of my
grep, it seems most of the external users are due to the utility
functions which hopefully won't be an issue anymore because of the
new crypto/utils.h file.

---8<---
The header file crypto/algapi.h is for internal use only.  Use the
header file crypto/utils.h instead.

Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/net/wireguard/cookie.c  |    2 +-
 drivers/net/wireguard/netlink.c |    2 +-
 drivers/net/wireguard/noise.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireguard/cookie.c b/drivers/net/wireguard/cookie.c
index 4956f0499c19..f89581b5e8cb 100644
--- a/drivers/net/wireguard/cookie.c
+++ b/drivers/net/wireguard/cookie.c
@@ -12,9 +12,9 @@
 
 #include <crypto/blake2s.h>
 #include <crypto/chacha20poly1305.h>
+#include <crypto/utils.h>
 
 #include <net/ipv6.h>
-#include <crypto/algapi.h>
 
 void wg_cookie_checker_init(struct cookie_checker *checker,
 			    struct wg_device *wg)
diff --git a/drivers/net/wireguard/netlink.c b/drivers/net/wireguard/netlink.c
index 6d1bd9f52d02..0a2f225e754a 100644
--- a/drivers/net/wireguard/netlink.c
+++ b/drivers/net/wireguard/netlink.c
@@ -15,7 +15,7 @@
 #include <linux/if.h>
 #include <net/genetlink.h>
 #include <net/sock.h>
-#include <crypto/algapi.h>
+#include <crypto/utils.h>
 
 static struct genl_family genl_family;
 
diff --git a/drivers/net/wireguard/noise.c b/drivers/net/wireguard/noise.c
index 720952b92e78..202a33af5a72 100644
--- a/drivers/net/wireguard/noise.c
+++ b/drivers/net/wireguard/noise.c
@@ -15,7 +15,7 @@
 #include <linux/bitmap.h>
 #include <linux/scatterlist.h>
 #include <linux/highmem.h>
-#include <crypto/algapi.h>
+#include <crypto/utils.h>
 
 /* This implements Noise_IKpsk2:
  *
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
