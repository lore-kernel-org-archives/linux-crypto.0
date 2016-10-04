From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: Re: [PATCH] crypto: sha1-powerpc: little-endian support
Date: Tue, 4 Oct 2016 09:07:37 -0300
Message-ID: <20161004120737.GA16223@gallifrey>
References: <1474659116-4689-1-git-send-email-marcelo.cerri@canonical.com>
 <20160928131551.GA31082@gallifrey>
 <20160928132015.GA21312@gondor.apana.org.au>
 <20160928132718.GB31082@gallifrey>
 <87pong4oq3.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        George Wilson <gcwilson@us.ibm.com>,
        Claudio Carvalho <cclaudio@br.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@br.ibm.com>,
        joy.latten@canonical.com, "David S. Miller" <davem@davemloft.net>
To: Michael Ellerman <mpe@ellerman.id.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:33473 "EHLO
        mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752594AbcJDMHp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Oct 2016 08:07:45 -0400
Received: by mail-vk0-f50.google.com with SMTP id z126so187581812vkd.0
        for <linux-crypto@vger.kernel.org>; Tue, 04 Oct 2016 05:07:45 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <87pong4oq3.fsf@concordia.ellerman.id.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michael,

On Ubuntu, CRYPTO_MANAGER_DISABLE_TESTS is set by default. So I had to
disable this config in order to make sha1-powerpc fail in the crypto API
tests. However, even with tests disabled, any usage of sha1-powerpc
should result in incorrect results.

--=20
Regards,
Marcelo

On Tue, Oct 04, 2016 at 05:23:16PM +1100, Michael Ellerman wrote:
> Marcelo Cerri <marcelo.cerri@canonical.com> writes:
>=20
> > [ Unknown signature status ]
> > On Wed, Sep 28, 2016 at 09:20:15PM +0800, Herbert Xu wrote:
> >> On Wed, Sep 28, 2016 at 10:15:51AM -0300, Marcelo Cerri wrote:
> >> > Hi Herbert,
> >> >=20
> >> > Any thoughts on this one?
> >>=20
> >> Can this patch wait until the next merge window? On the broken
> >> platforms it should just fail the self-test, right?
> >
> > Yes. It fails on any LE platform (including Ubuntu and RHEL 7.1).
>=20
> How are you testing this? I thought I was running the crypto tests but
> I've never seen this fail.
>=20
> cheers

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJX85uIAAoJEM8aS8c01e1HPcEH/1tDwYlq2+4dg+EF4M384b0B
Q5pPKS74g/5abaoCpxgBflHVvg6nr4XgWgrRIECHqiMBKJWN7rUZ7XigtPnNtq4a
vKAVUP6lYDem1cB1i1p9g1maAAyOYn5LCfETfIqqM3n9qL5Valje8krc8buxVI7R
q0XGMRBSmmqTyk7gW/VDfoZy5TMlfflKYq1E1bPBEEIhMEQFuQS6b9cniThryh0l
WMOKv/mNctP5a9trB/BGceluuhtcoeTBhdFhDEyHNOPvsGsdOL7IDSlGRZcQAxaS
pw8dM465K2JA1y8ZdWqsTSb4UHuhZ+gO/BBNwg+nJjWo5MjXSni3PO0mUM1hzXw=
=Gkyv
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
