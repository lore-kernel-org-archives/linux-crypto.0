From: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH] crypto: Fix test in get_prng_bytes()
Date: Mon, 12 Oct 2009 16:22:05 +0200
Message-ID: <4AD33B8D.4030708@gmail.com>
References: <4AD32A75.5030706@gmail.com> <20091012135142.GB8885@hmsreliant.think-freely.org> <20091012140753.GA30300@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Neil Horman <nhorman@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:60414 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625AbZJLON2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Oct 2009 10:13:28 -0400
Received: by ewy4 with SMTP id 4so2482349ewy.37
        for <linux-crypto@vger.kernel.org>; Mon, 12 Oct 2009 07:12:51 -0700 (PDT)
In-Reply-To: <20091012140753.GA30300@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Op 12-10-09 16:07, Herbert Xu schreef:
> On Mon, Oct 12, 2009 at 09:51:42AM -0400, Neil Horman wrote:
> .
>>> Or should this test be removed?
>>>
>>> diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
>>> index 3aa6e38..9162456 100644
>>> --- a/crypto/ansi_cprng.c
>>> +++ b/crypto/ansi_cprng.c
>>> @@ -192,7 +192,7 @@ static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx)
>>>  	int err;
>>>  
>>>  
>>> -	if (nbytes < 0)
>>> +	if ((ssize_t)nbytes < 0)
>>>  		return -EINVAL;
>>>  
>>>  	spin_lock_bh(&ctx->prng_lock);
>> No, you're quite right, its a harmless, but unneeded check.  Herbert, could you
>> pull this into cryptodev please?  Thank you.
> 
> Hmm, if it's unneeded why don't we just kill it instead?

In that case:
-------------------------->8------------------8<-------------------------
size_t nbytes cannot be less than 0 and the test was redundant.

Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 3aa6e38..47995ae 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -192,9 +192,6 @@ static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx)
 	int err;
 
 
-	if (nbytes < 0)
-		return -EINVAL;
