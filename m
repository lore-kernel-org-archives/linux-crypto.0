Return-Path: <SRS0=7O7/=CT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 693C1C433E2
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 01:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27A3720708
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 01:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbgIJB7W (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Sep 2020 21:59:22 -0400
Received: from smtprelay0215.hostedemail.com ([216.40.44.215]:43108 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728663AbgIJBic (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Sep 2020 21:38:32 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave07.hostedemail.com (Postfix) with ESMTP id 08BE2180255BD;
        Thu, 10 Sep 2020 00:20:47 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 4D665182CED34;
        Thu, 10 Sep 2020 00:20:45 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: smoke24_341571c270e1
X-Filterd-Recvd-Size: 13205
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Thu, 10 Sep 2020 00:20:43 +0000 (UTC)
Message-ID: <c50014e57e77842e4c710231dff829f3f67bbe59.camel@perches.com>
Subject: Re: [trivial PATCH] treewide: Convert switch/case fallthrough; to
 break;
From:   Joe Perches <joe@perches.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Keith Busch <kbusch@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jiri Kosina <trivial@kernel.org>,
        Kees Cook <kees.cook@canonical.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 09 Sep 2020 17:20:42 -0700
In-Reply-To: <20200909223540.GA27590@gondor.apana.org.au>
References: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
         <20200909205558.GA3384631@dhcp-10-100-145-180.wdl.wdc.com>
         <b0c31cbb82aa64027569dff69803ca3ec2f65501.camel@perches.com>
         <20200909223540.GA27590@gondor.apana.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 2020-09-10 at 08:35 +1000, Herbert Xu wrote:
> On Wed, Sep 09, 2020 at 02:09:32PM -0700, Joe Perches wrote:
> > On Wed, 2020-09-09 at 13:55 -0700, Keith Busch wrote:
> > > On Wed, Sep 09, 2020 at 01:06:39PM -0700, Joe Perches wrote:
> > > > diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> > > > index eea0f453cfb6..8aac5bc60f4c 100644
> > > > --- a/crypto/tcrypt.c
> > > > +++ b/crypto/tcrypt.c
> > > > @@ -2464,7 +2464,7 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
> > > >  		test_hash_speed("streebog512", sec,
> > > >  				generic_hash_speed_template);
> > > >  		if (mode > 300 && mode < 400) break;
> > > > -		fallthrough;
> > > > +		break;
> > > >  	case 399:
> > > >  		break;
> > > 
> > > Just imho, this change makes the preceding 'if' look even more
> > > pointless. Maybe the fallthrough was a deliberate choice? Not that my
> > > opinion matters here as I don't know this module, but it looked a bit
> > > odd to me.
> > 
> > It does look odd to me too.
> > 
> > It's also just a test module though so the
> > code isn't particularly crucial.
> > 
> > Herbert/David? thoughts?
> 
> Please read the function as a whole, that fallthrough (and every other
> one in do_test) needs to stay.

Hi Herbert.

OK, I did.  I think it's odd code.

The do_test function could start at any 3xx or 4xx mode
and then do all the next tests to the highest 99
for ranges from 301-399 and 401-499.

ie: Pass mode 312, it'll execute test 312 and every
other test to 399.

Not the same for the 500-599 or 600-699 range.

I probably would've hoisted the code for all of the 0,
any value from 300-399, and any value from 400-499
out of the do_test function and into tcrypt_mod_init
not used fallthrough in do_test at all.

cheers, Joe

Perhaps something like:
---
 crypto/tcrypt.c | 190 +++++++++++++++++++++-----------------------------------
 1 file changed, 72 insertions(+), 118 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index eea0f453cfb6..aeb089f6ee27 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1660,7 +1660,6 @@ static inline int tcrypt_test(const char *alg)
 
 static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 {
-	int i;
 	int ret = 0;
 
 	switch (m) {
@@ -1672,8 +1671,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 			break;
 		}
 
-		for (i = 1; i < 200; i++)
-			ret += do_test(NULL, 0, 0, i, num_mb);
 		break;
 
 	case 1:
@@ -2349,123 +2346,93 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 			test_hash_speed(alg, sec, generic_hash_speed_template);
 			break;
 		}
-		fallthrough;
+		break;
 	case 301:
 		test_hash_speed("md4", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 302:
 		test_hash_speed("md5", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 303:
 		test_hash_speed("sha1", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 304:
 		test_hash_speed("sha256", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 305:
 		test_hash_speed("sha384", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 306:
 		test_hash_speed("sha512", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 307:
 		test_hash_speed("wp256", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 308:
 		test_hash_speed("wp384", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 309:
 		test_hash_speed("wp512", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 310:
 		test_hash_speed("tgr128", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 311:
 		test_hash_speed("tgr160", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 312:
 		test_hash_speed("tgr192", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 313:
 		test_hash_speed("sha224", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 314:
 		test_hash_speed("rmd128", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 315:
 		test_hash_speed("rmd160", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 316:
 		test_hash_speed("rmd256", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 317:
 		test_hash_speed("rmd320", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 318:
 		klen = 16;
 		test_hash_speed("ghash", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 319:
 		test_hash_speed("crc32c", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 320:
 		test_hash_speed("crct10dif", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 321:
 		test_hash_speed("poly1305", sec, poly1305_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 322:
 		test_hash_speed("sha3-224", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 323:
 		test_hash_speed("sha3-256", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 324:
 		test_hash_speed("sha3-384", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 325:
 		test_hash_speed("sha3-512", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 326:
 		test_hash_speed("sm3", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 327:
 		test_hash_speed("streebog256", sec,
 				generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 328:
 		test_hash_speed("streebog512", sec,
 				generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
-	case 399:
 		break;
 
 	case 400:
@@ -2473,122 +2440,93 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 			test_ahash_speed(alg, sec, generic_hash_speed_template);
 			break;
 		}
-		fallthrough;
+		break;
 	case 401:
 		test_ahash_speed("md4", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 402:
 		test_ahash_speed("md5", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 403:
 		test_ahash_speed("sha1", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 404:
 		test_ahash_speed("sha256", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 405:
 		test_ahash_speed("sha384", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 406:
 		test_ahash_speed("sha512", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 407:
 		test_ahash_speed("wp256", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 408:
 		test_ahash_speed("wp384", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 409:
 		test_ahash_speed("wp512", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 410:
 		test_ahash_speed("tgr128", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 411:
 		test_ahash_speed("tgr160", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 412:
 		test_ahash_speed("tgr192", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 413:
 		test_ahash_speed("sha224", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 414:
 		test_ahash_speed("rmd128", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 415:
 		test_ahash_speed("rmd160", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 416:
 		test_ahash_speed("rmd256", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 417:
 		test_ahash_speed("rmd320", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 418:
 		test_ahash_speed("sha3-224", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 419:
 		test_ahash_speed("sha3-256", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 420:
 		test_ahash_speed("sha3-384", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 421:
 		test_ahash_speed("sha3-512", sec, generic_hash_speed_template);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 422:
 		test_mb_ahash_speed("sha1", sec, generic_hash_speed_template,
 				    num_mb);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 423:
 		test_mb_ahash_speed("sha256", sec, generic_hash_speed_template,
 				    num_mb);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 424:
 		test_mb_ahash_speed("sha512", sec, generic_hash_speed_template,
 				    num_mb);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 425:
 		test_mb_ahash_speed("sm3", sec, generic_hash_speed_template,
 				    num_mb);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 426:
 		test_mb_ahash_speed("streebog256", sec,
 				    generic_hash_speed_template, num_mb);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 427:
 		test_mb_ahash_speed("streebog512", sec,
 				    generic_hash_speed_template, num_mb);
-		if (mode > 400 && mode < 500) break;
-		fallthrough;
-	case 499:
 		break;
 
 	case 500:
@@ -3034,7 +2972,23 @@ static int __init tcrypt_mod_init(void)
 			goto err_free_tv;
 	}
 
-	err = do_test(alg, type, mask, mode, num_mb);
+	if (mode == 0) {
+		err = do_test(alg, type, mask, mode, num_mb);
+		if (!err) {
+			for (i = 1; i < 200; i++)
+				err |= do_test(NULL, 0, 0, i, num_mb);
+		}
+	} else if (mode >= 300 && mode < 400) {
+		err = 0;
+		for (i = mode; i < 400; i++)
+			err |= do_test(alg, type, mask, i, num_mb);
+	} else if (mode >= 400 && mode < 500) {
+		err = 0;
+		for (i = mode; i < 500; i++)
+			err |= do_test(alg, type, mask, i, num_mb);
+	} else {
+		err = do_test(alg, type, mask, mode, num_mb);
+	}
 
 	if (err) {
 		printk(KERN_ERR "tcrypt: one or more tests failed!\n");


