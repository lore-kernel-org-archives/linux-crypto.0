From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] SP800-38F / RFC3394 key wrapping
Date: Tue, 28 Apr 2015 04:58:31 +0200
Message-ID: <1906826.TjaHhvv93b@myon.chronox.de>
References: <1515730.LIeS5qas5m@myon.chronox.de> <1742335.S7ujyfP8MQ@myon.chronox.de> <20150428025402.GB29738@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34584 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964771AbbD1DDU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2015 23:03:20 -0400
In-Reply-To: <20150428025402.GB29738@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 28. April 2015, 10:54:02 schrieb Herbert Xu:

Hi Herbert,

> On Tue, Apr 28, 2015 at 04:45:17AM +0200, Stephan Mueller wrote:
> > The use case I see goes along the lines of dm-crypt and Ext4 crypto, or
> > ecryptfs:
> > 
> > For the key wrapping they all do, I am thinking about suggesting KW as it
> > has one advantage no other cipher currently has: it is an authenticated
> > decryption where I still only need one symmetric key. Yes, KW is
> > inefficient compared to other ciphers, but for handling small data blobs,
> > it should be just fine.
> > 
> > For example, dm-crypt: dm-crypt currently uses the same cipher used for
> > the
> > bulk encryption to wrap the LUKS header. Obviously we miss the
> > authentication check of the data blob. So, we could use other
> > authenticated schemas, like GCM or authenc(). But they all need either
> > two keys or AAD for which the common mechanisms typically have no
> > provisions. Therefore, KW is a drop-in replacement for standard symmetric
> > ciphers where one want authentication as well.
> 
> If it's for cases where the data is always linear, we could always
> do this outside the crypto API.  You can still use AES from the crypto
> API to do the actual crypto of course.
> 
> By keeping it out of the crypto API you wouldn't have to worry about
> SG lists and can simply require the input to be linear u8 * buffers.
> 
> However, because this is an algorithm that is not otherwise useful
> you'll need to ensure that at least one user is going to be accepted
> into the kernel.
> 
> The implementation could go into lib.

Hm, in case of dm-crypt, that is not really possible, because this is fully 
driven by user space: libcryptsetup sets up a temporary dm-crypt container for 
the LUKS header space. Then user space accesses the data it needs and re-
injects it into the kernel for the bulk encryption dm-crypt component.

-- 
Ciao
Stephan
