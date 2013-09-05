From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 11/18] Hibernate: introduced RSA key-pair to verify
 signature of snapshot
Date: Thu, 05 Sep 2013 21:28:57 +0800
Message-ID: <1378387737.6193.75.camel__42107.0321383469$1378387740$gmane$org@linux-s257.site>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <1377169317-5959-12-git-send-email-jlee@suse.com>
	 <20130905085348.GJ28598@console-pimps.org>
	 <1378376016.6193.71.camel@linux-s257.site>
	 <20130905103158.GM28598@console-pimps.org>
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
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20130905103158.GM28598@console-pimps.org>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

=E6=96=BC =E5=9B=9B=EF=BC=8C2013-09-05 =E6=96=BC 11:31 +0100=EF=BC=8CMa=
tt Fleming =E6=8F=90=E5=88=B0=EF=BC=9A
> On Thu, 05 Sep, at 06:13:36PM, joeyli wrote:
> > This S4WakeKey is a VOLATILE variable that could not modify by
> > SetVariable() at runtime. So, it's read only even through efivars.=20
> >=20
> > Does it what your concern?
> =20
> No, the UEFI spec probibits certain runtime functions from being
> executed concurrently on separate cpus and the spinlock used in the
> efivars code ensures that we adhere to that restriction. See table 31=
 in
> section 7.1 of the UEFI 2.4 spec for the list of services that are
> non-reentrant.
>=20
> The problem isn't that we want to avoid simultaneous access to
> S4WakeKey, it's that we can't invoke any of the variable runtime serv=
ice
> functions concurrently.
>=20

I see! I will use efivar api to access EFI variable.

Thanks a lot!
Joey Lee

--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
