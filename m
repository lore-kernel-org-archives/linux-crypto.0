From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: New Crypto Hardware
Date: Tue, 13 Nov 2007 09:41:38 +0800
Message-ID: <E1IrkmY-0007gp-00@gondolin.me.apana.org.au>
References: <007c01c82558$9d175180$2005420a@amcc.com>
Cc: linux-crypto@vger.kernel.org
To: locnho@sbcglobal.net (Loc Ho)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4739 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757621AbXKMBlo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Nov 2007 20:41:44 -0500
In-Reply-To: <007c01c82558$9d175180$2005420a@amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Loc Ho <locnho@sbcglobal.net> wrote:
> 
> What is the current state of asynchronous hashing? Will AEAD be changed to

It's on my todo list but it's not the highest priority.

> make use of asynchronous hashing? Is anyone working on #1 and changing AEAD

You mean authenc? AEAD is just an interface which doesn't use
hashing directly.   If you mean the authenc algorithm which combines
encryption and hashing then yes it will be changed.  That would
be a fairly straightforward change too.

> to asychronous interface? In addition, most of the existent device driver

I'm not aware of any ongoing work so any contributions in this
area would definitely be welcome.

> only use  synchronous interface. Are there any one changing them to
> asynchronous crypto interface - such as NETKEY (Linux IPSec)?

That I am working on right now :) See the recent 24 patche set
I posted to netdev.  What's missing now is just the change to
get ESP to actually use AEAD.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
