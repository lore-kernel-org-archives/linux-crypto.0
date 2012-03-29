From: "roosa, william MAJ RES" <william-roosa@us.army.mil>
Subject: Re: Status of aes in Debian/Ubuntu? (UNCLASSIFIED)
Date: Thu, 29 Mar 2012 07:00:36 -0400
Message-ID: <7540e2c9ee52.4f740894@us.army.mil>
References: <20120328121744.GY32725@vnl.com>
 <1332952631.8994.44.camel@foxtrot.cjac.ntr.f5net.com>
 <20120328190322.GA16113@greengrey.org>
 <20120328204234.GD10584@vnl.com> <4F737F41.1090309@redhat.com>
 <20120328213305.GG10584@vnl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	"C.J. Adams-Collier KF7BMP" <cjac@colliertech.org>,
	Ryan Corder <ryanc@greengrey.org>
To: Milan Broz <mbroz@redhat.com>, Dale Amon <amon@vnl.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mxoutdr1.us.army.mil ([143.69.242.38]:44048 "EHLO
	mxoutdr1.us.army.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab2C2LAh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Mar 2012 07:00:37 -0400
Content-Language: en
In-Reply-To: <20120328213305.GG10584@vnl.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Classification: UNCLASSIFIED

Seems to hang when it can't find the kernel headers.
If you forget that they can come with the package for a moment and just=
 install them directly.  If you've been away for some time you probably=
 did not get the memo that systems don't come with the headers or kerne=
l source code by default so you have to go get that package.......
Such is the brave new world where things are done for us by others.

Bill

William Roosa
MAJ, SF
703-268-8311 (cell)
703-545-1509 (w)
william-roosa@us.army.mil
De Oppreso Liber
=EF=BA=97=EF=BA=A4=EF=BA=AD=EF=BB=B4=EF=BA=AE =EF=BA=81=EF=BB=9E =D9=85=
=D8=B6=D8=B7=D9=87=D8=AF=EF=BB=B4=EF=BB=A6

On 03/28/12, Dale Amon  <amon@vnl.com> wrote:

> On Wed, Mar 28, 2012 at 11:14:41PM +0200, Milan Broz wrote:
> > If you want something simple, use LUKS. cryptsetup
> > and dmcrypt is in all distributions by default.
> > Truecrypt uses dmcrypt by default as backend as well.
>=20
> Looking around a bit, it appears that cryptsetup is in
> the ubuntu server set up disk.
>=20
> > Of course, if you want use loop-aes, you have to
> > patch all utilities and kernel, it is not so complicated.
>=20
> I'm not wedded to it... as I noted I have been out of
> the loop, crypt or otherwise, for half a decade.
>=20
> > (cryptsetup can run loop-aes compatible mode as well and
> > can allocate loop device as well. But it is your
> > choice what encryption and utility to use to use
> > of course.)
> >=20
> > For default losetup from util-linux, encryption option
> > is in fact deprecated in favor to cryptsetup.
>=20
> Okay. Now do cryptsetup and the others work in a pretty
> standard way? ie, put them in your /etc/fstab and
> just feed them a password when you want to mount? Or if
> it is a loopback image, you just do the usual
>=20
> 	mount -o loop file /mnt
>=20
> ?
--=20

Classification: UNCLASSIFIED
