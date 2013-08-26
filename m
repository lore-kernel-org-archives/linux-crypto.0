From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 03/18] asymmetric keys: separate the length checking of
 octet string from RSA_I2OSP
Date: Mon, 26 Aug 2013 18:25:31 +0800
Message-ID: <1377512731.27967.34.camel__36414.7554072135$1377512845$gmane$org@linux-s257.site>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <1377169317-5959-4-git-send-email-jlee@suse.com>
	 <20130825160147.GB5171@amd.pavel.ucw.cz>
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
In-Reply-To: <20130825160147.GB5171@amd.pavel.ucw.cz>
Sender: linux-security-module-owner@vger.kernel.org
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
> > Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
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


--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
