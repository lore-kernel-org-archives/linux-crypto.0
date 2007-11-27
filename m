From: "rae l" <crquan@gmail.com>
Subject: Re: [PATCH] [RESEND] crypto test: use print_hex_dump from kernel.h instead
Date: Tue, 27 Nov 2007 13:03:29 +0800
Message-ID: <91b13c310711262103w781b3047k6338acda56837c0@mail.gmail.com>
References: <20071126143939.GB28022@gondor.apana.org.au>
	 <1196098095-8995-1-git-send-email-crquan@gmail.com>
	 <1196100104.31590.11.camel@localhost>
	 <20071127013540.GA793@gondor.apana.org.au>
	 <1196131632-7285-1-git-send-email-crquan@gmail.com>
	 <474B87F1.2060109@student.ltu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	dengxw@163.com, "Randy Dunlap" <randy.dunlap@oracle.com>,
	"Joe Perches" <joe@perches.com>
To: "Richard Knutsson" <ricknu-0@student.ltu.se>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:38432 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbXK0FDb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Nov 2007 00:03:31 -0500
Received: by ug-out-1314.google.com with SMTP id z38so1143682ugc
        for <linux-crypto@vger.kernel.org>; Mon, 26 Nov 2007 21:03:30 -0800 (PST)
In-Reply-To: <474B87F1.2060109@student.ltu.se>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Nov 27, 2007 10:58 AM, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
...
> > +     print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
> > +                     16, 1,
> > +                     buf, len, 0);
> >
> Not important, but why use '0' instead of 'false'?
after read http://lkml.org/lkml/2006/7/27/281, I agreed with you.
this is refreshed patch against the lastest cryptodev tree.

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 crypto/tcrypt.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 1e12b86..ae762c2 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -87,12 +87,11 @@ static char *check[] = {
 	"camellia", "seed", "salsa20", NULL
 };

-static void hexdump(unsigned char *buf, unsigned int len)
+static inline void hexdump(unsigned char *buf, unsigned int len)
 {
-	while (len--)
-		printk("%02x", *buf++);
-
-	printk("\n");
+	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
+			16, 1,
+			buf, len, false);
 }

 static void tcrypt_complete(struct crypto_async_request *req, int err)

-- 
Denis Cheng
