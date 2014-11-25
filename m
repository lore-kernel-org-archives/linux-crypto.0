From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: algif - Mark sgl end at the end of data.
Date: Tue, 25 Nov 2014 07:53:39 -0800
Message-ID: <5474A603.4040705@intel.com>
References: <20141121171406.1147.31491.stgit@tstruk-mobl1> <20141125144245.GA8278@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:31558 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbaKYP4t (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Nov 2014 10:56:49 -0500
In-Reply-To: <20141125144245.GA8278@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,
On 11/25/2014 06:42 AM, Herbert Xu wrote:
> Please put these clean-ups in a separate patch.
Ok, will do.

> 
>> > @@ -469,6 +464,7 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
>> >  			if (!used)
>> >  				goto free;
>> >  
>> > +			sg_mark_end(&sg[sgl->cur - 1]);
> I don't think this will work as if we only partially use up the
> SGs and MSG_MORE is set then bad things will happen to the next
> send call on the socket.

Yes, I see now. I assumed that the user would want to read the same len
that was first sent and thus the skcipher_pull_sgl() would clean the
whole ctx->tsgl and then skcipher_alloc_sgl() would create a new one.
I'll see if something else can be done to mark the end of data.
Thanks,
Tadeusz
