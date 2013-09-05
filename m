From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 11/18] Hibernate: introduced RSA key-pair to verify
 signature of snapshot
Date: Thu, 05 Sep 2013 18:13:36 +0800
Message-ID: <1378376016.6193.71.camel__9593.76681498743$1378376015$gmane$org@linux-s257.site>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <1377169317-5959-12-git-send-email-jlee@suse.com>
	 <20130905085348.GJ28598@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
	opensuse-kernel@opensuse.org, David Howells <dhowells@redhat.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
	Josh Boyer <jwboyer@redhat.com>,
	Vojtech Pavlik <vojtech@suse.cz>,
	Matt Fleming <matt.fleming@intel.com>,
	James Bottomley <james.bottomley@hansenpartnership.com>,
	Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
	Rusty Russell <rusty@rustcorp.com.au>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
	Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
	Takashi Iwai <tiwai@suse.de>
To: Matt Fleming <matt@console-pimps.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:47911 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935552Ab3IEKNA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Sep 2013 06:13:00 -0400
In-Reply-To: <20130905085348.GJ28598@console-pimps.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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
