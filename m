From: Neil Horman <nhorman@redhat.com>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Fri, 9 Sep 2011 15:12:39 -0400
Message-ID: <20110909191239.GE22810@hmsreliant.think-freely.org>
References: <4E67E1B0.2040309@atsec.com>
 <20110908084420.GC4032@infradead.org>
 <201109080748.27750.sgrubb@redhat.com>
 <20110908.121347.1753630996526838840.davem@davemloft.net>
 <CACLa4ptAYEieckVLz+qs9PGfDrw9QjExUx+EMn9tqiCoQ4aqfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Miller <davem@davemloft.net>, sgrubb@redhat.com,
	hch@infradead.org, stephan.mueller@atsec.com, tytso@mit.edu,
	jarod@redhat.com, levinsasha928@gmail.com,
	linux-crypto@vger.kernel.org, mpm@selenic.com,
	herbert.xu@redhat.com, linux-kernel@vger.kernel.org
To: Eric Paris <eparis@parisplace.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759629Ab1IITM6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Sep 2011 15:12:58 -0400
Content-Disposition: inline
In-Reply-To: <CACLa4ptAYEieckVLz+qs9PGfDrw9QjExUx+EMn9tqiCoQ4aqfg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 09, 2011 at 03:08:03PM -0400, Eric Paris wrote:
> On Thu, Sep 8, 2011 at 12:13 PM, David Miller <davem@davemloft.net> w=
rote:
> > From: Steve Grubb <sgrubb@redhat.com>
>=20
> >> This patch does not _break_ all existing applications. If a system=
 were under attack,
> >> they might pause momentarily, but they do not break. Please, try t=
he patch and use a
> >> nice large number like 2000000 and see for yourself. Right now, ev=
eryone arguing about
> >> this breaking things have not tried it to see if in fact things do=
 break and how they
> >> break if they do.
> >
> > If the application holds a critical resource other threads want whe=
n it
> > blocks on /dev/urandom, then your change breaks things. =A0I can co=
me up
> > with more examples if you like.
> >
> > Please get off this idea that you can just change the blocking beha=
vior
> > for a file descriptor and nothing of consequence will happen.
>=20
> I know it's work porting userspace, but would anyone think that a new
> char device to do this would be a good enough idea?  You obviously
> already worked out methods to port things which normally use urandom
> to use random to discover the problem, so most of the work should be
> done.  I suggest /dev/jkrandom (since this is half way between
> /dev/random and /dev/urandom and 'u' is the 21st letter it seemed
> appropriate to use letters 10 and 11)
>=20
I was going to suggest /dev/sourandom (for sort-of-urandom) :)
Neil

> Thus userspace can decide what matters.  Always with entropy and
> blocks often (random).  From good enough entropy and rarely blocks
> (jkrandom).  Possibly from some entropy and never block (urandom).
>=20
> -Eric
