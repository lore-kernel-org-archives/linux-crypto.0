From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate
 snapshot
Date: Thu, 26 Sep 2013 10:19:17 +0800
Message-ID: <1380161957.32302.42.camel__42511.7061044604$1380161986$gmane$org@linux-s257.site>
References: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>,
	Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>,
	Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>,
	Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>,
	Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, JKosina-IBi9RG/b67k@public.gmane.org,
	Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
	Herbert Xu <herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>,
	Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1309251723001.26508-100000-pYrvlCTfrz9XsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

=E6=96=BC =E4=B8=89=EF=BC=8C2013-09-25 =E6=96=BC 17:25 -0400=EF=BC=8CAl=
an Stern =E6=8F=90=E5=88=B0=EF=BC=9A
> On Wed, 25 Sep 2013, David Howells wrote:
>=20
> > I have pushed some keyrings patches that will likely affect this to=
:
> >=20
> > 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/=
log/?h=3Dkeys-devel
> >=20
> > I intend to ask James to pull these into his next branch.  If he's =
happy to do
> > so, I can look at pulling at least your asymmetric keys patch on to=
p of them.
>=20
> This suggests a point that I raised at the Linux Plumbers conference:
>=20
> Why are asymmetric keys used for verifying the hibernation image?  It
> seems that a symmetric key would work just as well.  And it would be =
a
> lot quicker to generate, because it wouldn't need any high-precision
> integer computations.
>=20
> Alan Stern
>=20
>=20

Per my understood, it's like add salt to snapshot when generate
signature, then remove the salt when store the snapshot to swap. (or
pass snapshot to userland).

Let me explain the symmetric key solution base on my understand:

 + EFI stub kernel generate a hash value from a random seed, then store
it to EFi boot varaible. It should protected by UEFI secure boot
environment.

 + When hibernate launched:
    - Kernel create the snapshot image of memory. It's included the
random hash value(salt) that generated in EFI stub stage.
    - Then kernel hash the snapshot image, put the hash to snapshot
header, just like current asymmetric keys solution.
    - Kernel erase the salt in snapshot image before it go to swap or
pass to userspace tool.

 + When hibernate resume:
    - Kernel or userspace tool load the snapshot(without salt) from swa=
p
to temporary memory space.
    - Kernel fill the salt back to snapshot image in memory, hash it.
    - Kernel compare the hash with the hash that put in snapshot header=
=2E
    - Verification done! The follow-up action as current solution.

Please current me if I missed anything.


Thanks a lot!
Joey Lee
