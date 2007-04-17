From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Tue, 17 Apr 2007 19:57:25 +0400
Message-ID: <20070417155725.GA18959@2ka.mipt.ru>
References: <20070417130431.GA8685@2ka.mipt.ru> <E1HdnwX-0005U1-00@gondolin.me.apana.org.au> <38b2ab8a0704170701p69fd547dwe3e2523ba5798b55@mail.gmail.com> <20070417150859.GA9512@2ka.mipt.ru> <38b2ab8a0704170834i1856886nafeeec692f49fea0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:44740 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031105AbXDQP57 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Apr 2007 11:57:59 -0400
Content-Disposition: inline
In-Reply-To: <38b2ab8a0704170834i1856886nafeeec692f49fea0@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Apr 17, 2007 at 05:34:12PM +0200, Francis Moreau (francis.moro@gmail.com) wrote:
> >Preventing anyone from using the module is incorrect.
> >How will you handle the case when you have only one algo registered and
> >it will be exclusively used by ecryptfs?
> >
> 
> As I tried to explain, in that case the admin must load the module
> without the exclusive flag.

If there are another users, then flag should not be set.
If there are no another users, your code already has exclusive access.
One can not know if there will be any additional users at all (consider
the case when new encrypted block device or ipsec negotiation started
some time after module was loaded).

> >Herbert proposes to register _second_ algo (say aes-generic(prio_100)
> >and aes_for_ecryptfs(prio_1)) with lower prio, so generic access will
> >never try to catch aes_for_ecryptfs, but your code still can access it
> >using full name.
> >
> 
> yes but my worries with this approach is that nothing prevent an admin
> to load others modules that will use aes_for_ecryptfs. And an admin is
> not always aware about a module implementation.

Some module is not allowed to force such restrictions, since it does not
know if there are other users or other algorithms.
You can call your algo with private company name hashed with author's
birtday, so no one in the world will be able to request such algo.
Actually its name can be read from /proc/crypto, but that is another
story.

> Thanks
> -- 
> Francis

-- 
	Evgeniy Polyakov
