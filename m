From: Jason <jason@lakedaemon.net>
Subject: Re: [PATCH] crypto: fix build failure in mv_cesa.c (missing of
 header)
Date: Sun, 11 Mar 2012 22:32:44 -0400
Message-ID: <20120312023244.GV5050@titan.lakedaemon.net>
References: <1331323105-21034-1-git-send-email-paul.gortmaker@windriver.com>
 <20120311014226.GU5050@titan.lakedaemon.net>
 <CAP=VYLpm9B7i9MSGTc4ogVPACmC3J1SVtNDugoYop5mJ8gLb9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: michael@walle.cc, linux-crypto@vger.kernel.org,
	linux-next@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:56944 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab2CLCcs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 11 Mar 2012 22:32:48 -0400
Content-Disposition: inline
In-Reply-To: <CAP=VYLpm9B7i9MSGTc4ogVPACmC3J1SVtNDugoYop5mJ8gLb9g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Mar 11, 2012 at 12:17:29PM -0400, Paul Gortmaker wrote:
> On Sat, Mar 10, 2012 at 8:42 PM, Jason Cooper <jason@lakedaemon.net> =
wrote:
> > On Fri, Mar 09, 2012 at 02:58:25PM -0500, Paul Gortmaker wrote:
> >> Commit 737b75872487f560397ba34846a19823b1addf88 (linux-next)
> >>
> >> =A0 =A0 "ARM: kirkwood: mv_cesa devicetree bindings"
> >>
> >> fails to compile as follows:
> >>
> >> =A0CC =A0 =A0 =A0drivers/crypto/mv_cesa.o
> >> =A0drivers/crypto/mv_cesa.c:1139: error: implicit declaration of f=
unction 'of_match_ptr'
> >> =A0drivers/crypto/mv_cesa.c:1139: error: 'mv_cesa_dt_ids' undeclar=
ed here (not in a function)
> >> =A0drivers/crypto/mv_cesa.c:1139: error: initializer element is no=
t constant
> >> =A0drivers/crypto/mv_cesa.c:1139: error: (near initialization for =
'marvell_crypto.driver.of_match_table')
> >>
> >> because it is missing the linux/of.h header file.
> >>
> >> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> >
> > Paul,
> >
> > Thanks for the patch. =A0Unfortunately, I'm not learning fast enoug=
h. =A0;-)
> > This series has been in a lot of flux lately, as you've experienced=
=2E
> >
> > The good news is, after talking with Olaf and Arnd, I think I have =
a
> > good workflow figured out. =A0Hopefully, failures like this won't h=
appen
> > in the future.
>=20
> Sounds good -- don't be too hard on yourself wrt. a minor breakage.
> Feel free to just squish the above patch into whatever updates you
> have going.  I don't see it needing to exist as a standalone commit.

Thanks, it's definitely better that it be squashed into the existing
commit.  I wouldn't want a bisect to land in between it down the road.

thx,

Jason.
