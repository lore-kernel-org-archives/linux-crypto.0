From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 17/18] Hibernate: introduced SNAPSHOT_SIG_HASH config
 for select hash algorithm
Date: Tue, 27 Aug 2013 20:54:57 +0800
Message-ID: <1377608097.20140.30.camel__6220.93303031779$1377608221$gmane$org@linux-s257.site>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <1377169317-5959-18-git-send-email-jlee@suse.com>
	 <20130825164329.GL5171@amd.pavel.ucw.cz>
	 <1377598937.20140.12.camel@linux-s257.site>
	 <20130827113044.GB20527@amd.pavel.ucw.cz>
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
	Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20130827113044.GB20527@amd.pavel.ucw.cz>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

=E6=96=BC =E4=BA=8C=EF=BC=8C2013-08-27 =E6=96=BC 13:30 +0200=EF=BC=8CPa=
vel Machek =E6=8F=90=E5=88=B0=EF=BC=9A
> On Tue 2013-08-27 18:22:17, joeyli wrote:
> > =E6=96=BC =E6=97=A5=EF=BC=8C2013-08-25 =E6=96=BC 18:43 +0200=EF=BC=8C=
Pavel Machek =E6=8F=90=E5=88=B0=EF=BC=9A
> > > On Thu 2013-08-22 19:01:56, Lee, Chun-Yi wrote:
> > > > This patch introduced SNAPSHOT_SIG_HASH config for user to sele=
ct which
> > > > hash algorithm will be used during signature generation of snap=
shot.
> > > >=20
> > > > v2:
> > > > Add define check of oCONFIG_SNAPSHOT_VERIFICATION in snapshot.c=
 before
> > > > declare pkey_hash().
> > > >=20
> > > > Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> > > > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> > > > ---
> > > >  kernel/power/Kconfig    |   46 +++++++++++++++++++++++++++++++=
+++++++++++++++
> > > >  kernel/power/snapshot.c |   27 ++++++++++++++++++++++-----
> > > >  2 files changed, 68 insertions(+), 5 deletions(-)
> > > >=20
> > > > diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> > > > index b592d88..79b34fa 100644
> > > > --- a/kernel/power/Kconfig
> > > > +++ b/kernel/power/Kconfig
> > > > @@ -78,6 +78,52 @@ config SNAPSHOT_VERIFICATION
> > > >  	  dependent on UEFI environment. EFI bootloader should genera=
te the
> > > >  	  key-pair.
> > > > =20
> > > > +choice
> > > > +	prompt "Which hash algorithm should snapshot be signed with?"
> > > > +        depends on SNAPSHOT_VERIFICATION
> > > > +        help
> > > > +          This determines which sort of hashing algorithm will=
 be used during
> > > > +          signature generation of snapshot. This algorithm _mu=
st_ be built into
> > > > +	  the kernel directly so that signature verification can take=
 place.
> > > > +	  It is not possible to load a signed snapshot containing the=
 algorithm
> > > > +	  to check the signature on that module.
> > >=20
> > > Like if 1000 ifdefs you already added to the code are not enough,=
 you
> > > make some new ones?
> > > 									Pavel
> > >=20
> >=20
> > This SNAPSHOT_SIG_HASH kernel config is to select which SHA algorit=
hms
> > used for generate digest of snapshot. The configuration will captur=
ed by
> > a const char* in code:
> >=20
> > +static const char *snapshot_hash =3D CONFIG_SNAPSHOT_SIG_HASH;
> > +
> > +static int pkey_hash(void)
> >=20
> > So, there doesn't have any ifdef block derived from this new config=
=2E
>=20
> I'd say select one hash function, and use it. There's no need to make
> it configurable.
> 									Pavel

There have better performance when SHA algorithm output shorter hash
result. On the other hand, longer hash result provide better security.

And, on 64-bits system, the SHA512 has better performance then SHA256.

Due to user have different use case and different hardware, why not giv=
e
them this option to make decision?


Thanks a lot!
Joey LEe

--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
