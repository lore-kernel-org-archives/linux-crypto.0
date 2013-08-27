From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 11/18] Hibernate: introduced RSA key-pair to verify
 signature of snapshot
Date: Tue, 27 Aug 2013 17:04:43 +0800
Message-ID: <1377594283.20140.3.camel__31359.5922584229$1377594385$gmane$org@linux-s257.site>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <1377169317-5959-12-git-send-email-jlee@suse.com>
	 <20130825162554.GH5171@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
	opensuse-kernel@opensuse.org, David Howells <dhowells@redhat.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Len Brown <len.brown@intel.com>,
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
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:59200 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab3H0JGL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Aug 2013 05:06:11 -0400
In-Reply-To: <20130825162554.GH5171@amd.pavel.ucw.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Pavel,=20

=E6=96=BC =E6=97=A5=EF=BC=8C2013-08-25 =E6=96=BC 18:25 +0200=EF=BC=8CPa=
vel Machek =E6=8F=90=E5=88=B0=EF=BC=9A
> On Thu 2013-08-22 19:01:50, Lee, Chun-Yi wrote:
> > Introduced a hibernate_key.c file to query the key pair from EFI va=
riables
> > and maintain key pair for check signature of S4 snapshot image. We
> > loaded the private key when snapshot image stored success.
> >=20
> > This patch introduced 2 EFI variables for store the key to sign S4 =
image and
> > verify signature when S4 wake up. The names and GUID are:
> >   S4SignKey-fe141863-c070-478e-b8a3-878a5dc9ef21
> >   S4WakeKey-fe141863-c070-478e-b8a3-878a5dc9ef21
> >=20
> > S4SignKey is used by EFI bootloader to pass the RSA private key tha=
t packaged
> > by PKCS#8 format, kernel will read and parser it when system boot a=
nd reload
> > it when S4 resume. EFI bootloader need gnerate a new private key wh=
en every
> > time system boot.
> >=20
> > S4WakeKey is used to pass the RSA public key that packaged by X.509
> > certificate, kernel will read and parser it for check the signature=
 of
> > S4 snapshot image when S4 resume.
> >=20
> > The follow-up patch will remove S4SignKey and S4WakeKey after load =
them
> > to kernel for avoid anyone can access it through efivarfs.
> >=20
> > v3:
> > - Load S4 sign key before ExitBootServices.
> >   Load private key before ExitBootServices() then bootloader doesn'=
t need
> >   generate key-pair for each booting:
> >    + Add setup_s4_keys() to eboot.c to load S4 sign key before Exit=
BootServices.
> >    + Reserve the memory block of sign key data blob in efi.c
> > - In Makefile, moved hibernate_keys.o before hibernate.o for load S=
4 sign
> >   key before check hibernate image. It makes sure the new sign key =
will be
> >   transfer to resume target kernel.
> > - Set "depends on EFI_STUB" in Kconfig
> >=20
> > v2:
> > Add CONFIG_SNAPSHOT_VERIFICATION for build of hibernate_keys.c depe=
nd on
> > Kconfig.
> >=20
> > Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> > Cc: Takashi Iwai <tiwai@suse.de>
> > Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
>=20
>=20
> > --- a/arch/x86/boot/compressed/eboot.c
> > +++ b/arch/x86/boot/compressed/eboot.c
> > @@ -368,6 +368,91 @@ free_handle:
> >  	return status;
> >  }
> > =20
> > +#ifdef CONFIG_SNAPSHOT_VERIFICATION
> > +static efi_status_t setup_s4_keys(struct boot_params *params)
> > +{
> > +	struct setup_data *data;
> > +	unsigned long datasize;
> > +	u32 attr;
> > +	struct efi_s4_key *s4key;
> > +	efi_status_t status;
> > +
> > +	data =3D (struct setup_data *)(unsigned long)params->hdr.setup_da=
ta;
>=20
> A bit too many casts.

Thanks.
Yes, here is my mistake, I will remove "unsigned long" cast.

>=20
> > @@ -1205,6 +1290,10 @@ struct boot_params *efi_main(void *handle, e=
fi_system_table_t *_table,
> > =20
> >  	setup_efi_pci(boot_params);
> > =20
> > +#ifdef CONFIG_SNAPSHOT_VERIFICATION
> > +	setup_s4_keys(boot_params);
> > +#endif
> > +
>=20
> Move ifdef inside the function?

OK, I will define a dummy function for non-verification situation.

>=20
> > @@ -729,6 +792,11 @@ void __init efi_init(void)
> > =20
> >  	set_bit(EFI_SYSTEM_TABLES, &x86_efi_facility);
> > =20
> > +#ifdef CONFIG_SNAPSHOT_VERIFICATION
> > +	/* keep s4 key from setup_data */
> > +	efi_reserve_s4_skey_data();
> > +#endif
> > +
>=20
> Here too.
>=20

I will also use dummy function here.=20


Thanks
Joey Lee
