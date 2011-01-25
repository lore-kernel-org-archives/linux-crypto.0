From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: hash finup() issue
Date: Tue, 25 Jan 2011 15:44:47 +0200
Message-ID: <4D3ED3CF.4080205@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
To: <linux-crypto@vger.kernel.org>,
	ext Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:47121 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab1AYNow (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Jan 2011 08:44:52 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

It is often very important to know for implementation or optimization if
we get more data to process or not.

New user space crypto API uses socket MSG_MORE flag to know if more data
is coming.

>From kernel crypto API it is also may be very important to know if more
data is coming.

OMAP SHA1 accelerator is designed in such a way that it requires to
submit last request (data) with special control bit
CLOSE_HASH.

Using OLD crypto API driver cannot know it until it get hash_final() call...

hash_init()
hash_update()
...
hash_update()
hash_final()

So basically on every hash_update() call driver must store a tail =
(data_len % block_len)
So basically that tail would be handled from hash_final() call...
For example if we have update call with size of one page 4096, then we
need to hash only 4032 bytes and leave 64 bytes
to hash in final() call...
It makes DMA impossible or inefficient, because on next update calls we
need to fill the buffer by copying data and then run DMA.
So extra copying is involved.

Similar case is also when we also use new crypto API and hash_finup()
with current implementation....
hash_init()
hash_update()
...
hash_finup()


Basically what is important is that driver on hash_update() call would
know that more data is coming.
If consider that client will use hash_finup() for last update then
driver could consider that hash_update() is not a final update and more
data will come (until hash_finup()).
But that assumption will break old API to work....

For that reason I guess it would be great to have some way to tell the
driver if we use old or new API - I mean
update+final or finup...

What we have done in our system is introduced a new flag which is set to
request.
flags |= CRYPTO_TFM_REQ_USE_FINUP;
ahash_request_set_callback(req, flags,  tcrypt_complete, &tresult);

Then the driver has just one extra check

            if (!tail && !(dd->req->base.flags & CRYPTO_TFM_REQ_USE_FINUP))
                tail = SHA1_MD5_BLOCK_SIZE;

Basically when hashing a page 4096, it is goes via DMA without extra
copying...


What do you think about it?
Some other ways to do the same?

- Dmitry
