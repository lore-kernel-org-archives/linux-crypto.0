From: Milan Broz <mbroz@redhat.com>
Subject: Re: Bug of dm-crypt?
Date: Fri, 27 Feb 2009 09:41:02 +0100
Message-ID: <49A7A71E.50702@redhat.com>
References: <1235712716.6204.100.camel@yhuang-dev.sh.intel.com> <20090227054147.GA22159@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59737 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbZB0IlI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Feb 2009 03:41:08 -0500
In-Reply-To: <20090227054147.GA22159@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
> On Fri, Feb 27, 2009 at 01:31:56PM +0800, Huang Ying wrote:
>> I had ever heard from you that the only thing guaranteed in the
>> completion function of async ablkcipher cryption is the req->data has
>> the value you set before. The request pointer itself may be changed. But
>> in dm-crypt, I found they rely on request pointer in completion
>> function: kcryptd_async_done. This makes my AES-NI cryptd usage panic.
>>
>> Do you think that is a bug?
> 
> Absolutely.
> 
> It should use cc->req instead.

ok, I'll check it and try to fix that. 

Can you send me backtrace from that panic?

What's wrong in async callback now - mempool_free using async_req directly?

(Btw in some previous discussuion I asked if cryptd can be used
for some kind of parallel speedup for dm-crypt in async mode and response
was that cryptd "is only meant to be a demo showing how an async
implementation should be written".

So this changed to real working thread for AES-NI?)

Milan
--
mbroz@redhat.com

