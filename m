From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] crypto: compress - Add pcomp interface
Date: Thu, 19 Feb 2009 10:12:18 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0902191005110.27630@vixen.sonytel.be>
References: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090114031613.GA7429@gondor.apana.org.au> <Pine.LNX.4.64.0901141528010.31703@vixen.sonytel.be>
 <20090115030526.GA27726@gondor.apana.org.au> <alpine.LRH.2.00.0902051703150.4290@vixen.sonytel.be> <20090210061822.GA19774@gondor.apana.org.au> <alpine.LRH.2.00.0902121613580.29413@vixen.sonytel.be> <20090219040847.GA973@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:37912 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752214AbZBSJMU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Feb 2009 04:12:20 -0500
In-Reply-To: <20090219040847.GA973@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 19 Feb 2009, Herbert Xu wrote:
> On Thu, Feb 12, 2009 at 04:19:40PM +0100, Geert Uytterhoeven wrote:
> > On Tue, 10 Feb 2009, Herbert Xu wrote:
> > > On Thu, Feb 05, 2009 at 05:24:51PM +0100, Geert Uytterhoeven wrot=
e:
> > > > > Well with the netlink parameters these can have variable leng=
ths
> > > > > depending on how many parameters the user supplies.
> > > >=20
> > > > How can this be exported to userspace?
> > > > How does this variable length parameter passing work? Do you ha=
ve an example?
> > >=20
> > > See how we use it for rtnetlink, e.g., in net/ipv4/ip_gre.c.
> > >=20
> > > > Nothing in crypto/ seems to already use nla_*?
> > >=20
> > > Well we don't have a user-space API yet :) But checkout the
> > > discussions on this list.
> >=20
> > I'm sorry, but this is a totally separate change, so I'm not going =
to do it
> > right now.
>=20
> Sorry but I disagree.  We're working on the user-space API right
> now and having to redo the compression parameters API later because
> we didn't take take user-space into account is just not acceptable.

OK, I'll give it a try...

> In any case, the nla stuff is not as hard is it looks.  It's
> going to add tens of lines to the setup code and that's it.
>=20
> In order to get started, all you need to do is call nla_parse.
> You don't even need a policy for the simple attributes.
>=20
> Please let me know if you need more help in getting nla_parse
> going.

IIUC, my setup() routines should decode the parameters using nla_parse(=
)?
And the caller of a setup() routine should encode the data. But how? Al=
l the
nla_put*() routines seem to be targeted at skb's.

The only place where nla_parse() is called with a void */length pair is
net/sched/em_meta.c:em_meta_change(). But I can find no place where the=
 actual
TCA_EM_META_* fields are encoded.

Can you please explain? Thanks!

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =B7 Da Vincilaan 7-D1 =B7 B-1935 Zaventem =B7 Bel=
gium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =B7 RPR Brussels
=46ortis =B7 BIC GEBABEBB =B7 IBAN BE41293037680010
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
