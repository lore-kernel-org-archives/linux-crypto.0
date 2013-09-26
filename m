From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate
 snapshot
Date: Thu, 26 Sep 2013 20:56:10 +0800
Message-ID: <1380200170.32302.85.camel__23158.3762252287$1380200241$gmane$org@linux-s257.site>
References: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>
	 <1380161957.32302.42.camel@linux-s257.site>
	 <1380192218.32302.69.camel@linux-s257.site>
	 <20130926120621.GA7537@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>,
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
	James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>,
	Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, JKosina-IBi9RG/b67k@public.gmane.org,
	Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
	Herbert Xu <herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>,
	Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130926120621.GA7537-tWAi6jLit6GreWDznjuHag@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

=E6=96=BC =E5=9B=9B=EF=BC=8C2013-09-26 =E6=96=BC 14:06 +0200=EF=BC=8CPa=
vel Machek =E6=8F=90=E5=88=B0=EF=BC=9A
> Hi!
>=20
> > For the symmetric key solution, I will try HMAC (Hash Message
> > Authentication Code). It's already used in networking, hope the
> > performance is not too bad to a big image.
>=20
> Kernel already supports crc32 of the hibernation image, you may want
> to take a look how that is done.

In current kernel design, The crc32 is only for the LZO in-kernel
hibernate, doesn't apply to non-compress hibernate and userspace
hibernate.

Put signature to snapshot header can support any kind of caller that's
trigger hibernate. Any userspace hibernate tool will take the snapshot
image from kernel, so, we need put the signature(or hash result) to
snapshot header before userspace write it to anywhere.=20

>=20
> Maybe you want to replace crc32 with cryptographics hash (sha1?) and
> then use only hash for more crypto? That way speed of whatever crypto
> you do should not be an issue.

That speed of hash is calculated from non-compress snapshot image, does
not overlap with crc32.

>=20
> Actually...
>=20
> Is not it as simple as storing hash of hibernation image into NVRAM
> and then verifying the hash matches the value in NVRAM on next
> startup? No encryption needed.=20
>=20
> And that may even be useful for non-secure-boot people, as it ensures
> you boot right image after resume, boot it just once, etc...
>=20
> 									Pavel

The HMAC approach will not encrypt, just put the key of HMAC to boottim=
e
variable.=20

If user doesn't enable UEFI secure boot, that's fine, the key of HMAC
still cannot access in OS runtime.=20
If user enable UEFI secure boot, then that's better! Because all EFI
file will signed by the manufacturers or OSVs to make sure the code is
secure, will not pass the key to runtime.


Thanks a lot!
Joey Lee
