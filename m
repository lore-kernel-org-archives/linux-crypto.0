From: Phil Sutter <phil@nwl.cc>
Subject: Re: RFC: kcrypto - (yet another) user space interface
Date: Fri, 11 Jun 2010 12:51:34 +0200
Message-ID: <20100611105142.230FC4CD45@orbit.nwl.cc>
References: <20100610182237.1B48E4CD45@orbit.nwl.cc>
 <20100610211433.GA25864@Chamillionaire.breakpoint.cc>
 <4C11EA03.50505@gnutls.org>
 <20100611090856.GA31092@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nikos Mavrogiannopoulos <nmav@gnutls.org>,
	linux-crypto@vger.kernel.org,
	Nico Erfurth <nico.erfurth@viprinet.com>,
	Simon Kissel <simon.kissel@viprinet.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orbit.nwl.cc ([91.121.169.95]:45223 "EHLO orbit.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab0FKKvn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jun 2010 06:51:43 -0400
Content-Disposition: inline
In-Reply-To: <20100611090856.GA31092@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hey,

Seems like I'm stabbing into open wounds. :) First of all, thanks a lot
for your comments.

On Fri, Jun 11, 2010 at 11:08:56AM +0200, Sebastian Andrzej Siewior wrote:
> * Nikos Mavrogiannopoulos | 2010-06-11 09:47:15 [+0200]:
> 
> >Sebastian Andrzej Siewior wrote:
> >> * Phil Sutter | 2010-06-10 20:22:29 [+0200]:
> >
> >The problem with right or wrong is that they are only known afterwards.
> >For me the right way to go is _to go_. I can see discussions in this
> >least, years ago on talks about the "perfect" userspace crypto api and
> >rejections implementations because they are not perfect enough. I don't
> >believe there is such thing as a perfect crypto api. Other operating
> >systems have a userspace crypto API (maybe not perfect) but linux
> >hasn't. I don't think this is the way to go.
> 
> Phil asked me for my opinion and he got it. The fundumention problems
> from what I've seen was the interface:
> - kernel structs which are exposed to userland which limit the
>   parameters. For instance the iv was limited to 16 bytes while we have
>   allready algos with a much longer iv.
> - the interface was using write()/poll()/read() and get_user_pages(). I
>   pointed out Herbert's opinion about this and the alternative. So this
>   _was_ allready discsussed.

For me, this project is a rather pragmatical one - this just needs to
get done, and it has to be just perfect enough so my employer finds it
usable. Nice to have if I happen to create the perfect CryptoAPI user
space interface ever (yeah, right ...) but this is unlikely to happen.
For me it's enough to first get the concept right and next make it
stable and functional. After that I'm sure we all can tell better if
it's worth pushing it towards the kernel or leave it as (yet another)
niche product.

Greetings, Phil
