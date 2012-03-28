From: "roosa, william MAJ RES" <william-roosa@us.army.mil>
Subject: Re: Status of aes in Debian/Ubuntu? (UNCLASSIFIED)
Date: Wed, 28 Mar 2012 14:06:51 -0400
Message-ID: <76109811eb7d.4f731afb@us.army.mil>
References: <20120328121744.GY32725@vnl.com>
 <1332952631.8994.44.camel@foxtrot.cjac.ntr.f5net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, ryanc <ryanc@greengrey.org>
To: Dale Amon <amon@vnl.com>,
	"C.J. Adams-Collier KF7BMP" <cjac@colliertech.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mxoutdr1.us.army.mil ([143.69.242.38]:10195 "EHLO
	mxoutdr1.us.army.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302Ab2C1SQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Mar 2012 14:16:31 -0400
Content-Language: en
In-Reply-To: <1332952631.8994.44.camel@foxtrot.cjac.ntr.f5net.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Classification: UNCLASSIFIED
I've used AES before.  Came on a disk, popped it in, self started and a=
sked me to supply a password (initial setup stuff), about 3 hours later=
 I had an encryped hard disk.  This was for my corp laptop though, I do=
n't use it on my home Debian laptop.  My current work desktop had encry=
ption also that uses the CAC cert to encrypt.  I don't know the name th=
ough as it is all managed from the ivory tower folks in the IT shop.  I=
t works well from the user standpoint right up to the point where your =
CAC cert expires.  You then get a take your new CAC and a live chicken =
to our provisioners.  There is a blood sacrifice and some internet wiza=
rd stuff that goes on then a guy/gal has to touch your desktop and type=
 in the "magic text" in the (horror of horrors) command prompt (Yes mar=
tha it is winders vista).  About an hour later your disk is encrypted w=
ith the new cert.

What is the situation that is calling for a "data at rest" encryption s=
olution?

Bill
SOF Imperative #8 Apply capabilities indirectly

William Roosa
MAJ, SF
703-268-8311 (cell)
703-545-1509 (w)
william-roosa@us.army.mil
De Oppreso Liber
=EF=BA=97=EF=BA=A4=EF=BA=AD=EF=BB=B4=EF=BA=AE =EF=BA=81=EF=BB=9E =D9=85=
=D8=B6=D8=B7=D9=87=D8=AF=EF=BB=B4=EF=BB=A6

On 03/28/12, "C.J. Adams-Collier KF7BMP"  <cjac@colliertech.org> wrote:

> Hey there Dale & List,
>=20
> I believe Ryan and Bill (CC'd) are using AES full disk crypto on thei=
r
> systems.  It seems complicated to me, but they can probably give you
> tips.  I think Bill is using Debian and Ryan is using Arch.  Bill's
> (DISA's) policies are pretty strict and probably require that his sma=
rt
> card be inserted at boot time.  Ryan's history administering the
> intranet for a company in the medical field have set his bar probably
> higher than DISA's in many ways, but may not require that the physica=
l
> token be inserted at boot.
>=20
> Cheers && 73,
>=20
> C.J.
>=20
> On Wed, 2012-03-28 at 13:17 +0100, Dale Amon wrote:
> > Been away from the list for awhile and you went
> > and moved the list on me!
> >=20
> > Yesterday I pulled out my notes from the last time
> > I set up a crypto disk and found that basically,
> > nothing worked.
> >=20
> > The losetup lists all the appropriate crypto types
> > in its Man page but when I try to actually use AES256,
> > it throws a fit. When I look in modules for the
> > current kernel, I do not see a module for aes at all.
> >=20
> > I might also note that I was surprised to find the -k
> > switch for specifying key size is gone.
> >=20
> > I tried downloading a package with aes in it, but it
> > turns out to require local build. So... I tried that.
> >=20
> > I discovered that the module failed to declare kpkg
> > as a prerequisite. I eventually figured that error out
> > and selected it manually.
> >=20
> > And then I tried everything I could think of short of
> > going 'all the way in': I tried module-assistant; I
> > tried m-a; I tried the commands from the INSTALL file
> > one at a time. All of them failed.
> >=20
> > This is just SOOooo 1999... aren't things supposed to
> > get better with time? ;-)
> >=20
> > I would be happy to supply any information required
> > or to run a few tests in between other work. Test=20
> > server is an ancient (perhaps 2003) box with Ubuntu
> > Oneiric, fully up to date.
> >=20
> > If I want to use something like this for a production
> > environment, it has to be solid and update and work
> > forever into the future.=20
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cry=
pto" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
--=20

Classification: UNCLASSIFIED
