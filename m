From: Paul Burton <paul.burton@imgtec.com>
Subject: Re: [PATCH 2/6] crypto: jz4780-rng: Make ingenic CGU driver use syscon
Date: Mon, 21 Aug 2017 09:04:16 -0700
Message-ID: <45556677.8n3yGzOkJs@np-p-burton>
References: <20170817182520.20102-1-prasannatsmkumar@gmail.com> <3563032.h0vdzx9HfC@np-p-burton> <CANc+2y6tRe_kkWyGX+-BT-ugb5JiZhKpPoHWkAn=2ZC6cb6uKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart8306877.L2Sq6hHNpB";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Cc: <linux-mips@linux-mips.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Michael Turquette <mturquette@baylibre.com>,
        <sboyd@codeaurora.org>, "David S . Miller" <davem@davemloft.net>,
        Paul Cercueil <paul@crapouillou.net>,
        <linux-crypto@vger.kernel.org>
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:6272 "EHLO
        mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754270AbdHUQEY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Aug 2017 12:04:24 -0400
In-Reply-To: <CANc+2y6tRe_kkWyGX+-BT-ugb5JiZhKpPoHWkAn=2ZC6cb6uKA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--nextPart8306877.L2Sq6hHNpB
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi PrasannaKumar,

On Sunday, 20 August 2017 09:12:12 PDT PrasannaKumar Muralidharan wrote:
> > Could you instead perhaps:
> >  - Just add "syscon" as a second compatible string to the CGU node in the
> >  
> >    device tree, but otherwise leave it as-is without the extra
> >    cgu_registers
> >    node.
> >  
> >  - Have your RNG device node as a child of the CGU node, which should let
> >  it
> >  
> >    pick up the regmap via syscon_node_to_regmap() as it already does.
> >  
> >  - Leave the CGU driver as-is, so it can continue accessing memory
> >  directly
> >  
> >    rather than via regmap.
> 
> As per my understanding, CGU driver and syscon will map the same
> register set. Is that fine?

That should work fine.

It's only risky if you have 2 drivers using the same registers in ways that 
might race with one another or clobber one another's data. In this case each 
of the 2 drivers is using a different subset of registers that just happen to 
be in the same address range, so there shouldn't be an issue.

Thanks,
    Paul
--nextPart8306877.L2Sq6hHNpB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEELIGR03D5+Fg+69wPgiDZ+mk8HGUFAlmbBIAACgkQgiDZ+mk8
HGVe1Q/6Au2TClXs/W79i3QnmUiwaV9otdtoqCPYhvX6pFQ3vlrPt+Dn1FsvoRwL
dccm/fueHvkdYvueUbkqmjUDuiWrt3tv4YoVnih81gtmBWVeF9hQ9hLqd3nlZhbS
9aFryozQ8mO6AHP4N58Iv8aPubtoYunDasCdMZ72cq9T3SxIaAl9B2AEQEls5JO8
mgESbB7kGrv5d484ktOGGRr4KjNlCxFxOVWxZq7zPQxuCMRbsIAZEnpW9ei1OXuV
b2VGa/o8oz3WnPiCrxwgNHH7ckp6LBjdtv4Rq+oxiOs9ONWRZoXXC0ygvdc1Pv6a
9Y1DCZWzQrzali8g1YAytuEQgql+i/xId9uoNxQy3Fw0SGIRsNkEXjqASFzUF/wb
Z/8jvxuia4EQEUsgb5UWlDP2zy2q7zCCj/IB3pvAn9u4vD8WtQRrZIhR7W0qOd3f
P8Q1Eq/u4rnyPdNV9x7TrFSRlIJ90FTytYCfKDu0qeGcsfYi39vrVPEEESgzSPmM
UVD4/biG80szEmkCNeGFsaViNoUCE1/5sw4nvCmStsH0IIYaXHV3hLDi4J0L90JY
PsDssx1NUF+ySLeaNYLfIfg5ySRJlnFRN7kdC2fcp85D1bx4xBc5qqDuo2MIXR5K
G9jZOj2H2DzoVI22SW2mbRJYSwTWIApkMzyfBXPcGUByUm1QCQM=
=fpS/
-----END PGP SIGNATURE-----

--nextPart8306877.L2Sq6hHNpB--
