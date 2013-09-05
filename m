From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 11/18] Hibernate: introduced RSA key-pair to verify
 signature of snapshot
Date: Thu, 05 Sep 2013 18:13:36 +0800
Message-ID: <1378376016.6193.71.camel__4517.02884533933$1378376015$gmane$org@linux-s257.site>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <1377169317-5959-12-git-send-email-jlee@suse.com>
	 <20130905085348.GJ28598@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>,
	Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>,
	Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>,
	Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>,
	Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, JKosina-IBi9RG/b67k@public.gmane.org,
	Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>,
	Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130905085348.GJ28598-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Matt,=20

=46irst, thanks for your review!

=E6=96=BC =E5=9B=9B=EF=BC=8C2013-09-05 =E6=96=BC 09:53 +0100=EF=BC=8CMa=
tt Fleming =E6=8F=90=E5=88=B0=EF=BC=9A
> On Thu, 22 Aug, at 07:01:50PM, Lee, Chun-Yi wrote:
> > +static int efi_status_to_err(efi_status_t status)
> > +{
> > +	int err;
> > +
> > +	switch (status) {
> > +	case EFI_INVALID_PARAMETER:
> > +		err =3D -EINVAL;
> > +		break;
> > +	case EFI_OUT_OF_RESOURCES:
> > +		err =3D -ENOSPC;
> > +		break;
> > +	case EFI_DEVICE_ERROR:
> > +		err =3D -EIO;
> > +		break;
> > +	case EFI_WRITE_PROTECTED:
> > +		err =3D -EROFS;
> > +		break;
> > +	case EFI_SECURITY_VIOLATION:
> > +		err =3D -EACCES;
> > +		break;
> > +	case EFI_NOT_FOUND:
> > +		err =3D -ENODATA;
> > +		break;
> > +	default:
> > +		err =3D -EINVAL;
> > +	}
> > +
> > +	return err;
> > +}
>=20
> Please don't reimplement this. Instead make the existing function
> global.
>=20

OK, I will make the function to global.

> [...]
>=20
> > +static void *load_wake_key_data(unsigned long *datasize)
> > +{
> > +	u32 attr;
> > +	void *wkey_data;
> > +	efi_status_t status;
> > +
> > +	if (!efi_enabled(EFI_RUNTIME_SERVICES))
> > +		return ERR_PTR(-EPERM);
> > +
> > +	/* obtain the size */
> > +	*datasize =3D 0;
> > +	status =3D efi.get_variable(EFI_S4_WAKE_KEY_NAME, &EFI_HIBERNATE_=
GUID,
> > +				  NULL, datasize, NULL);
> > +	if (status !=3D EFI_BUFFER_TOO_SMALL) {
> > +		wkey_data =3D ERR_PTR(efi_status_to_err(status));
> > +		pr_err("PM: Couldn't get wake key data size: 0x%lx\n", status);
> > +		goto error;
> > +	}
>=20
> Is it safe to completely bypass the efivars interface and access
> efi.get_variable() directly? I wouldn't have thought so, unless you c=
an
> guarantee that the kernel isn't going to access any of the EFI runtim=
e
> services while you execute this function.
>=20

This S4WakeKey is a VOLATILE variable that could not modify by
SetVariable() at runtime. So, it's read only even through efivars.=20

Does it what your concern?


Thanks a lot!
Joey Lee
