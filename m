From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 03/18] asymmetric keys: separate the length checking of
 octet string from RSA_I2OSP
Date: Mon, 26 Aug 2013 18:25:31 +0800
Message-ID: <1377512731.27967.34.camel__13961.8638241247$1377512828$gmane$org@linux-s257.site>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <1377169317-5959-4-git-send-email-jlee@suse.com>
	 <20130825160147.GB5171@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>,
	Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>,
	Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>,
	Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, JKosina-IBi9RG/b67k@public.gmane.org,
	Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>,
	Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130825160147.GB5171-tWAi6jLit6GreWDznjuHag@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

=E6=96=BC =E6=97=A5=EF=BC=8C2013-08-25 =E6=96=BC 18:01 +0200=EF=BC=8CPa=
vel Machek =E6=8F=90=E5=88=B0=EF=BC=9A
> On Thu 2013-08-22 19:01:42, Lee, Chun-Yi wrote:
> > Due to RSA_I2OSP is not only used by signature verification path bu=
t also used
> > in signature generation path. So, separate the length checking of o=
ctet string
> > because it's not for generate 0x00 0x01 leading string when used in=
 signature
> > generation.
> >=20
> > Reviewed-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
> > Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
>=20
> > +static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
> > +{
> > +	unsigned x_size;
> > +	unsigned X_size;
> > +	u8 *X =3D NULL;
>=20
> Is this kernel code or entry into obfuscated C code contest? This is =
not funny.
>=20
> 									Pavel

The small "x" is the input integer that will transfer to big "X" that i=
s
a octet sting.=20

Sorry for I direct give variable name to match with spec, maybe I need
use big_X or....

Do you have good suggest for the naming?


Thanks a lot!
Joey Lee
