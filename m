From: joeyli <jlee@suse.com>
Subject: Re: [RFC PATCH 00/18 v3] Signature verification of hibernate
 snapshot
Date: Thu, 29 Aug 2013 08:01:45 +0800
Message-ID: <1377734505.19568.39.camel__47837.6409308568$1377734621$gmane$org@linux-s257.site>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <87eh9dzg00.fsf@mid.deneb.enyo.de>
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
	Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>
To: Florian Weimer <fw@deneb.enyo.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87eh9dzg00.fsf@mid.deneb.enyo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Florian,=20

Thanks for your response.

=E6=96=BC =E4=B8=89=EF=BC=8C2013-08-28 =E6=96=BC 23:01 +0200=EF=BC=8CFl=
orian Weimer =E6=8F=90=E5=88=B0=EF=BC=9A
> * Chun-Yi Lee:
>=20
> >  + EFI bootloader must generate RSA key-pair when system boot:

I should add more information on this sentence for mention need GenS4Ke=
y
runtime variable then re-generate key-pair.

Thanks!

> >    - Bootloader store the public key to EFI boottime variable by it=
self
> >    - Bootloader put The private key to S4SignKey EFI variable for f=
orward to
> >      kernel.
>=20
> Is the UEFI NVRAM really suited for such regular updates?
>=20

Yes, Matthew raised this concern at before. I modified patch to load
private key in efi stub kernel, before ExitBootServices(), that means w=
e
don't need generate key-pair at every system boot. So, the above
procedure of efi bootloader will only run one time.=20

User can enable SNAPSHOT_REGEN_KEYS kernel config to notify efi
booloader regenerate key-pair for every S4 to improve security if he
want. So, the key-pair re-generate procedure will only launched when S4
resume, not every system boot.


Thanks a lot!
Joey Lee
