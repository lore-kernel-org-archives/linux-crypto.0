From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: crypto_ahash_setkey
Date: Wed, 23 Nov 2011 07:08:53 +0100
Message-ID: <20111123060853.GH20943@secunet.com>
References: <CALLzPKYbbYV9keL7DAFfHVzn3SqQv3-1X+cJCp2hn2-ey9UpOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:49216 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756421Ab1KWGIz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Nov 2011 01:08:55 -0500
Content-Disposition: inline
In-Reply-To: <CALLzPKYbbYV9keL7DAFfHVzn3SqQv3-1X+cJCp2hn2-ey9UpOw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Wed, Nov 23, 2011 at 12:00:29AM +0200, Kasatkin, Dmitry wrote:
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
>     tfm = crypto_alloc_ahash(...);
> }
> 
> work_task()
> {
>      crypto_ahash_setkey(tfm, key, keylen);
>      crypto_ahash_digest(req);
> }
> 
> HMAC result "sometimes" is incorrect.

Looks like a race. HMAC precalculates the hash of the ipaded/opaded key
and saves this hash on the transform. So the setkey method should be used
just once in the initialization path.

> 
> But when I move crypto_ahash_setkey() do the initialization code then
> HMAC result is always correct...
> (key is the same, so I can initialize it only once)
> 
> int()
> {
>      tfm = crypto_alloc_ahash(...);
>      crypto_ahash_setkey(tfm, key, keylen);
> }

That's how it should be. And in this case it works, as you
already noticed :)
