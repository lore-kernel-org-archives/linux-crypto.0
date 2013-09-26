From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate
 snapshot
Date: Thu, 26 Sep 2013 09:36:35 +0800
Message-ID: <1380159395.32302.19.camel__8286.87984399057$1380159422$gmane$org@linux-s257.site>
References: <1379206621-18639-1-git-send-email-jlee@suse.com>
	 <29408.1380143073@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
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
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <29408.1380143073-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

=E6=96=BC =E4=B8=89=EF=BC=8C2013-09-25 =E6=96=BC 22:04 +0100=EF=BC=8CDa=
vid Howells =E6=8F=90=E5=88=B0=EF=BC=9A
> I have pushed some keyrings patches that will likely affect this to:
>=20
> 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/lo=
g/?h=3Dkeys-devel
>=20

Thanks for your point out, I will respin my asymmetric keys patch base
on this tree.

> I intend to ask James to pull these into his next branch.  If he's ha=
ppy to do
> so, I can look at pulling at least your asymmetric keys patch on top =
of them.
>=20
> It'd be helpful if you could see if you need to make any updates.
>=20
> David
>=20

In LPC, Alan and Vojtech raised another thinking is using symmetric key
to protect the hash of snapshot. It's simpler then using RSA private ke=
y
to sign it.

Even finally we use the symmetric key solution, I will still respin and
resent the patch for add the leading zero byte:

[PATCH V4 07/15] asymmetric keys: explicitly add the leading zero byte
to encoded message

I think keys-devel tree need it.


Thanks a lot!
Joey Lee
