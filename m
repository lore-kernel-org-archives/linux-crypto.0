From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Tue, 17 Apr 2007 19:08:59 +0400
Message-ID: <20070417150859.GA9512@2ka.mipt.ru>
References: <20070417130431.GA8685@2ka.mipt.ru> <E1HdnwX-0005U1-00@gondolin.me.apana.org.au> <38b2ab8a0704170701p69fd547dwe3e2523ba5798b55@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:51205 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964974AbXDQPJO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Apr 2007 11:09:14 -0400
Content-Disposition: inline
In-Reply-To: <38b2ab8a0704170701p69fd547dwe3e2523ba5798b55@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Apr 17, 2007 at 04:01:51PM +0200, Francis Moreau (francis.moro@gmail.com) wrote:
> On 4/17/07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> >Yep.  We don't need such a flag anyway.  All we need is a way to tweak
> >the priority and Bob's your uncle.
> >
> 
> Could you elaborate please, I don't see how you prevent others users
> to use this module with priority.
> 
> Priority is a stuff that tells you which aes implementation to use but
> it does not prevent an implementation to be used several times...

Preventing anyone from using the module is incorrect.
How will you handle the case when you have only one algo registered and
it will be exclusively used by ecryptfs?

Herbert proposes to register _second_ algo (say aes-generic(prio_100)
and aes_for_ecryptfs(prio_1)) with lower prio, so generic access will
never try to catch aes_for_ecryptfs, but your code still can access it
using full name.

> Thanks
> -- 
> Francis

-- 
	Evgeniy Polyakov
