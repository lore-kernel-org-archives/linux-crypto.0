From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: [PATCH] crypto: Add a flag allowing the self-tests to be
 disabled at runtime.
Date: Fri, 29 Apr 2016 12:04:46 +0100
Message-ID: <20160429110446.GD28599@redhat.com>
References: <1461924463-1678-1-git-send-email-rjones@redhat.com>
 <1461924463-1678-2-git-send-email-rjones@redhat.com>
 <1716181.h8M5zx62aT@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, corbet@lwn.net,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <sm@eperm.de>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1716181.h8M5zx62aT@tauon.atsec.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Apr 29, 2016 at 12:59:57PM +0200, Stephan Mueller wrote:
> Am Freitag, 29. April 2016, 11:07:43 schrieb Richard W.M. Jones:
>=20
> Hi Richard,
[...]
> > +	if (notests) {
>=20
> What about if (!fips_enabled && notests) ?
>
> I am not sure whether the kernel should prevent mistakes in user spac=
e. A=20
> mistake would be when setting fips=3D1 and notests=3D1 as the FIPS mo=
de mandates=20
> the self tests.

(Sorry, I just posted v2 before I saw this message.)  I saw the FIPS
stuff and thought about that.  Should we prevent mistakes like that?
I really don't know.

Rich.

> > +		pr_info("alg: self-tests disabled\n");
> > +		return 0;
> > +	}
> > +
> >  	alg_test_descs_check_order();
> >=20
> >  	if ((type & CRYPTO_ALG_TYPE_MASK) =3D=3D CRYPTO_ALG_TYPE_CIPHER) =
{
>=20
>=20
> Ciao
> Stephan
> --=20
> | Nimm das Recht weg -                                             |
> |  was ist dann der Staat noch anderes als eine gro=DFe R=E4uberbande=
? |

--=20
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~=
rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://people.redhat.com/~rjones/virt-df/
