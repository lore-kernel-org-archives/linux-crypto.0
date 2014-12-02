From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH 01/17] crypto: ansi_cprng - Rename rand_data_valid more sensibly
Date: 2 Dec 2014 12:12:46 -0500
Message-ID: <20141202171246.26376.qmail@ns.horizon.com>
References: <1707797.LWZf6k9llc@tauon>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	nhorman@tuxdriver.com
To: linux@horizon.com, smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:60972 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754063AbaLBRMs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 12:12:48 -0500
In-Reply-To: <1707797.LWZf6k9llc@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>> 	if (byte_count < DEFAULT_BLK_SZ) {
>> empty_rbuf:
>>-		while (ctx->rand_data_valid < DEFAULT_BLK_SZ) {
>>-			*ptr = ctx->rand_data[ctx->rand_data_valid];
>>-			ptr++;
>>-			byte_count--;
>>-			ctx->rand_data_valid++;
>>-			if (byte_count == 0)
>>+		while (ctx->rand_read_pos < DEFAULT_BLK_SZ) {
>>+			*ptr++ = ctx->rand_data[ctx->rand_read_pos++];
>>+			if (--byte_count == 0)
>> 				goto done;

> I am against such collapsing of constructs into one-liners. It is not 
> obvious at first sight, which value gets incremented in what order. Such 
> collapsing was the cause for CVE-2013-4345 as it caused an off-by one.

Given that this turns out to the the exact code where that happened, I can
see the sensitivity of the matter!  But I disagree in this case, and
it took me a while to figure out how to phrase it.

It's a code style issue, which means that it doesn't have a clear
technical answer.  It's more of a "voting on what people think is
clearer" thing.


In the case of "if (--byte_count)" issue, that's not something I feel very
strongly about.

But in the case of "*ptr++ = ctx->rand_data[ctx->rand_read_pos++]", it's
the opposite.  While I'm not going to pick a fight over it, my opinion
is that this form is clearly better.

There are two advantages to the code in this form:

1. "*dst++ = *src++" is a C idiom, like "for (i = 0; i < N; i++)".
   It's very easy to recognize and understand.  A more broken-up form
   less obviously does all the necessary accounting.

2. The original bug was NOT caused by using side effects.  Consider the
   bug fix:

--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -230,11 +230,11 @@ remainder:
 	 */
 	if (byte_count < DEFAULT_BLK_SZ) {
 empty_rbuf:
-		for (; ctx->rand_data_valid < DEFAULT_BLK_SZ;
-			ctx->rand_data_valid++) {
+		while (ctx->rand_data_valid < DEFAULT_BLK_SZ) {
 			*ptr = ctx->rand_data[ctx->rand_data_valid];
 			ptr++;
 			byte_count--;
+			ctx->rand_data_valid++;
 			if (byte_count == 0)
 				goto done;
 		}

The problem was the *separation* of the copy and the associated increment.

In some situations, one was done and not the other, leading to data
duplication.  The fix was to move the increment of ctx->rand_data_valid
to before the "if (byte_count == 0)" loop exit test.

However, putting the increment in the same line as the copy reduces the
separation that caused the original bug, and makes it *more* clear that
the parts always happen together.

This, fundamentally, is the reason that I actually find it preferable:
it's conceptually "one operation" that should always have all of its parts
done together, and putting it on one line makes that easier for
the reader to recognize.

The problem with the original was putting it in the for(), not
using side effect expressions.


The above logic doesn't apply to "if (--byte_count)", which is why I
don't care about it nearly as much.


All that said, there are two significant remaining points:

3. this patch claims it's just a variable rename; perhaps it should stick
   to that, and
4. patch 10/15 totally deletes this code and replaces it with something
   even simpler, so if that is acceptable this entire discussion may be moot.
