From: "Francis Moreau" <francis.moro@gmail.com>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Tue, 17 Apr 2007 17:34:12 +0200
Message-ID: <38b2ab8a0704170834i1856886nafeeec692f49fea0@mail.gmail.com>
References: <20070417130431.GA8685@2ka.mipt.ru>
	 <E1HdnwX-0005U1-00@gondolin.me.apana.org.au>
	 <38b2ab8a0704170701p69fd547dwe3e2523ba5798b55@mail.gmail.com>
	 <20070417150859.GA9512@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.238]:25745 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030582AbXDQPeN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Apr 2007 11:34:13 -0400
Received: by nz-out-0506.google.com with SMTP id s1so1512207nze
        for <linux-crypto@vger.kernel.org>; Tue, 17 Apr 2007 08:34:12 -0700 (PDT)
In-Reply-To: <20070417150859.GA9512@2ka.mipt.ru>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 4/17/07, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> On Tue, Apr 17, 2007 at 04:01:51PM +0200, Francis Moreau (francis.moro@gmail.com) wrote:
> > On 4/17/07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > >
> > >Yep.  We don't need such a flag anyway.  All we need is a way to tweak
> > >the priority and Bob's your uncle.
> > >
> >
> > Could you elaborate please, I don't see how you prevent others users
> > to use this module with priority.
> >
> > Priority is a stuff that tells you which aes implementation to use but
> > it does not prevent an implementation to be used several times...
>
> Preventing anyone from using the module is incorrect.
> How will you handle the case when you have only one algo registered and
> it will be exclusively used by ecryptfs?
>

As I tried to explain, in that case the admin must load the module
without the exclusive flag.

> Herbert proposes to register _second_ algo (say aes-generic(prio_100)
> and aes_for_ecryptfs(prio_1)) with lower prio, so generic access will
> never try to catch aes_for_ecryptfs, but your code still can access it
> using full name.
>

yes but my worries with this approach is that nothing prevent an admin
to load others modules that will use aes_for_ecryptfs. And an admin is
not always aware about a module implementation.

Thanks
-- 
Francis
