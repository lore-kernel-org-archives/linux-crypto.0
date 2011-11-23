From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto_ahash_setkey
Date: Wed, 23 Nov 2011 15:44:56 +0800
Message-ID: <20111123074456.GA7875@gondor.apana.org.au>
References: <CALLzPKYbbYV9keL7DAFfHVzn3SqQv3-1X+cJCp2hn2-ey9UpOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:50858 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab1KWHpC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Nov 2011 02:45:02 -0500
Content-Disposition: inline
In-Reply-To: <CALLzPKYbbYV9keL7DAFfHVzn3SqQv3-1X+cJCp2hn2-ey9UpOw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Kasatkin, Dmitry <dmitry.kasatkin@intel.com> wrote:
> Hi,
> 
> I have noticed very odd behavior with hmac calculation on my dual
> core, 4 HTs PC.
> I am using async hash API to to calculate hmac over the page.
> I am using "hmac(sha1)" and the same key to calculate different pages.
> 
> I have a work queue, which calculates the hmac like...
> 
> int()
> {
>    tfm = crypto_alloc_ahash(...);
> }
> 
> work_task()
> {
>     crypto_ahash_setkey(tfm, key, keylen);
>     crypto_ahash_digest(req);
> }
> 
> HMAC result "sometimes" is incorrect.

Is your tfm shared by multiple instances of work_task? The key
is a property of the tfm, so you cannot have multiple users of a
tfm all changing keys at the same time.

The correct usage model allowing parallel use is to dedicate a
tfm to each key.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
