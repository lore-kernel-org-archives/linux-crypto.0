From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Tue, 17 Apr 2007 21:07:07 +0400
Message-ID: <20070417170707.GA24070@2ka.mipt.ru>
References: <20070417130431.GA8685@2ka.mipt.ru> <E1HdnwX-0005U1-00@gondolin.me.apana.org.au> <38b2ab8a0704170701p69fd547dwe3e2523ba5798b55@mail.gmail.com> <20070417150859.GA9512@2ka.mipt.ru> <38b2ab8a0704170834i1856886nafeeec692f49fea0@mail.gmail.com> <20070417155725.GA18959@2ka.mipt.ru> <38b2ab8a0704170918u72792c0ei591fea98eac2681d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1031227AbXDQRHn@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <38b2ab8a0704170918u72792c0ei591fea98eac2681d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Apr 17, 2007 at 06:18:42PM +0200, Francis Moreau (francis.moro@gmail.com) wrote:
> >If there are no another users, your code already has exclusive access.
> 
> sorry I don't understand that.

Since there are no users except your module, you do have exclusive
access already, i.e. you can stop key reloading and get your gain, but
there is no possibility for crypto module to know that in advance
(without hack like checking reference counter or storing private context
pointer in some internals and check it for each new call for
encrypt/decrypt).

> >One can not know if there will be any additional users at all (consider
> >the case when new encrypted block device or ipsec negotiation started
> >some time after module was loaded).
> >
> 
> well I should say administrator should know.

Yes, admin is a god. I would even say the god.
So it can (if she/he wants to) setup any module with any name so that
other users would never know it.

> -- 
> Francis

-- 
	Evgeniy Polyakov
