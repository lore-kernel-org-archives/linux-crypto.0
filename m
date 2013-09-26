From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate
 snapshot
Date: Thu, 26 Sep 2013 12:40:03 +0800
Message-ID: <1380170403.32302.52.camel__42561.7252862596$1380170422$gmane$org@linux-s257.site>
References: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>
	 <1380147414.18835.36.camel@dabdike.int.hansenpartnership.com>
	 <20130926002730.GA26857@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>,
	Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>,
	Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>,
	Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, JKosina-IBi9RG/b67k@public.gmane.org,
	Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
	Herbert Xu <herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>,
	Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130926002730.GA26857-tWAi6jLit6GreWDznjuHag@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

=E6=96=BC =E5=9B=9B=EF=BC=8C2013-09-26 =E6=96=BC 02:27 +0200=EF=BC=8CPa=
vel Machek =E6=8F=90=E5=88=B0=EF=BC=9A
> On Wed 2013-09-25 15:16:54, James Bottomley wrote:
> > On Wed, 2013-09-25 at 17:25 -0400, Alan Stern wrote:
> > > On Wed, 25 Sep 2013, David Howells wrote:
> > >=20
> > > > I have pushed some keyrings patches that will likely affect thi=
s to:
> > > >=20
> > > > 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.=
git/log/?h=3Dkeys-devel
> > > >=20
> > > > I intend to ask James to pull these into his next branch.  If h=
e's happy to do
> > > > so, I can look at pulling at least your asymmetric keys patch o=
n top of them.
> > >=20
> > > This suggests a point that I raised at the Linux Plumbers confere=
nce:
> > >=20
> > > Why are asymmetric keys used for verifying the hibernation image?=
  It
> > > seems that a symmetric key would work just as well.  And it would=
 be a
> > > lot quicker to generate, because it wouldn't need any high-precis=
ion
> > > integer computations.
> >=20
> > The reason is the desire to validate that the previous kernel creat=
ed
> > something which it passed on to the current kernel (in this case, t=
he
> > hibernation image) untampered with.  To do that, something must be
> > passed to the prior kernel that can be validated but *not* recreate=
d by
> > the current kernel.
>=20
> I don't get this. Why is it important that current kernel can't
> recreate the signature?
>=20
> Current kernel is not considered malicious (if it were, you have wors=
e
> problems).
>=20

Current boot kernel should not malicious especially when UEFI secure
boot enabled.

> 								Pavel
>=20
> PS: And yes, it would be nice to have
> Documentation/power/swsusp-uefi.txt (or something) explaining the
> design.
>=20

Thanks for your suggestion, I will write the swsusp-uefi.txt to
explaining the design in next version.


Thanks a lot!
Joey Lee
