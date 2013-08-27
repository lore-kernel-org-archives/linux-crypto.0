From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 11/18] Hibernate: introduced RSA key-pair to verify
 signature of snapshot
Date: Tue, 27 Aug 2013 21:12:39 +0800
Message-ID: <1377609159.20140.32.camel__33179.8053849072$1377609283$gmane$org@linux-s257.site>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <1377169317-5959-12-git-send-email-jlee@suse.com>
	 <20130825162554.GH5171@amd.pavel.ucw.cz>
	 <1377594283.20140.3.camel@linux-s257.site>
	 <20130827112943.GA20527@amd.pavel.ucw.cz>
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
Received: from smtp.nue.novell.com ([195.135.221.5]:45932 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab3H0NOQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Aug 2013 09:14:16 -0400
In-Reply-To: <20130827112943.GA20527@amd.pavel.ucw.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=E6=96=BC =E4=BA=8C=EF=BC=8C2013-08-27 =E6=96=BC 13:29 +0200=EF=BC=8CPa=
vel Machek =E6=8F=90=E5=88=B0=EF=BC=9A
> > > > @@ -1205,6 +1290,10 @@ struct boot_params *efi_main(void *handl=
e, efi_system_table_t *_table,
> > > > =20
> > > >  	setup_efi_pci(boot_params);
> > > > =20
> > > > +#ifdef CONFIG_SNAPSHOT_VERIFICATION
> > > > +	setup_s4_keys(boot_params);
> > > > +#endif
> > > > +
> > >=20
> > > Move ifdef inside the function?
> >=20
> > OK, I will define a dummy function for non-verification situation.
>=20
> IIRC you can just put the #ifdef inside the function body.=20
> 									Pavel

I want use inline dummy function like saveable_highmem_page() in
snapshot.c, maybe it's	 better then additional function call?


Thanks a lot!
Joey Lee
