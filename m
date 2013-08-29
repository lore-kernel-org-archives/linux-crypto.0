From: joeyli <jlee@suse.com>
Subject: Re: [RFC PATCH 00/18 v3] Signature verification of hibernate
 snapshot
Date: Fri, 30 Aug 2013 06:30:17 +0800
Message-ID: <1377815417.7080.28.camel__32935.8000810773$1377815619$gmane$org@linux-s257.site>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <87eh9dzg00.fsf@mid.deneb.enyo.de>
	 <1377734505.19568.39.camel@linux-s257.site>
	 <20130829213249.GA25940@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Weimer <fw@deneb.enyo.de>, linux-kernel@vger.kernel.org,
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
	Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>
To: Pavel Machek <pavel@denx.de>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20130829213249.GA25940@amd.pavel.ucw.cz>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

=E6=96=BC =E5=9B=9B=EF=BC=8C2013-08-29 =E6=96=BC 23:32 +0200=EF=BC=8CPa=
vel Machek =E6=8F=90=E5=88=B0=EF=BC=9A
> Hi!
>=20
> > > >    - Bootloader store the public key to EFI boottime variable b=
y itself
> > > >    - Bootloader put The private key to S4SignKey EFI variable f=
or forward to
> > > >      kernel.
> > >=20
> > > Is the UEFI NVRAM really suited for such regular updates?
> > >=20
> >=20
> > Yes, Matthew raised this concern at before. I modified patch to loa=
d
> > private key in efi stub kernel, before ExitBootServices(), that mea=
ns we
> > don't need generate key-pair at every system boot. So, the above
> > procedure of efi bootloader will only run one time.=20
> >=20
> > User can enable SNAPSHOT_REGEN_KEYS kernel config to notify efi
> > booloader regenerate key-pair for every S4 to improve security if h=
e
> > want. So, the key-pair re-generate procedure will only launched whe=
n S4
> > resume, not every system boot.
>=20
> How many writes can UEFI NVRAM survive? (Is it NOR?)

Currently doesn't have enough information for normal. Yes, I don't know=
=2E

>=20
> "every S4 resume" may be approximately "every boot" for some users...
> 									Pavel

Yes, it's possible.

So, this option will be disabled by default. Default will only generate
one key-pair for every hibernate.
If "re-generate key-pair for every S4" is still hurt lift of UEFI NVRAM
too much, then another thinking for re-generate key-pair are:
=20
 + Re-generate key-pair after a number of hibernates.
   e.g. after 5, 10, 20... times
or
 + Random re-generate key-pair?


On the other hand...
In current design, GenS4Key EFI variable could be write by userland
hibernate tool, kernel will respect GenS4Key value from userland when
hibernate launch. So, userland can tell bootloader to lunch the key-pai=
r
regeneration procedure.


Thanks a lot!
Joey LEe

--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
