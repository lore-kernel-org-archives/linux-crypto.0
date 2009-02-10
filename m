From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH] Export symbol ksize()
Date: Tue, 10 Feb 2009 15:46:51 +0200
Message-ID: <20090210134651.GA5115@epbyminw8406h.minsk.epam.com>
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name> <84144f020902100535i4d626a9fj8cbb305120cf332a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Cc: Christoph Lameter <cl@linux-foundation.org>,
	Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <84144f020902100535i4d626a9fj8cbb305120cf332a@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 10, 2009 at 03:35:03PM +0200, Pekka Enberg wrote:
> On Tue, Feb 10, 2009 at 3:21 PM, Kirill A. Shutemov
> <kirill@shutemov.name> wrote:
> > It needed for crypto.ko
> >
> > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
>=20
> That's bit terse for a changelog. I did a quick grep but wasn't able
> to find the offending call-site. Where is it?

Commit 7b2cd92a in lastest Linus's git.

>=20
> We unexported ksize() because it's a problematic interface and you
> almost certainly want to use the alternatives (e.g. krealloc). I think
> I need bit more convincing to apply this patch...

It just a quick fix. If anybody knows better solution, I have no
objections.

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.org/

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmRhUsACgkQbWYnhzC5v6o8UwCbBcicdfN0bGo5cs+ZSePGQkH+
JtcAn3X5K3KvvFxoWhtG4vG/IdiQtGg7
=SgDw
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
