From: Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>
Subject: Re: [PATCH v2 08/12] hwrng: bcm2835-rng: Abstract I/O accessors
Date: Wed, 08 Nov 2017 10:33:40 -0800
Message-ID: <87efp8y60r.fsf@anholt.net>
References: <20171108004449.32730-1-f.fainelli@gmail.com> <20171108004449.32730-9-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Ray Jui <rjui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Scott Branden <sbranden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        "maintainer\:BROADCOM BCM281XX\/BCM11XXX\/BCM216XX ARM ARCHITE..."
        <bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>,
        PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Russell King <rmk+kernel-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>,
        Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Harald Freudenberger <freude-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
        Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>,
        Martin Kaiser <martin-XxZfDwE/svGeZLLa646FqQ@public.gmane.org>,
        Steffen Trumtrar <s.trumtrar-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>,
        "open list\:HARDWARE RANDOM NUMBER GENERATOR CORE"
To: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171108004449.32730-9-f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

--=-=-=
Content-Type: text/plain

Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> In preparation for allowing BCM63xx to use this driver, we abstract I/O
> accessors such that we can easily change those later on.

This may even be a fix on rpi, since i/o from different devices can get
reordered and you're using the barrier variants now!

Reviewed-by: Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAloDTgQACgkQtdYpNtH8
nujcmQ/+LFm4dMsax2aokq/aBRnjzbrJxzz8wxb460dQrrT8VDKypLia1q+PjnOG
k1rZH3bnfnUe3SbzTQtXpTjf8VXvCSEN0KvoO2MVSrhdK4ZpA7rHE2gvTGDTqUTe
6zRglcK074EK4nqY37cztQqBkm3EcFZJgN/8agAkq2/0VkTyrZ+GMkWt13VFgEuJ
5UdhYfvyuW+j1SyrkvKKLrVDFEPdQ+ouqSMHOL6JMNcqfPjXyvf6iQvnvcOosMNl
Ipw5e0TFYW33BX1McTOL5AvJEVnMfUzFTT2jTcyfGoE3pjG58hlXikX9KEt/+xg1
OcdS7HrE2q6G0uWLSywLJwvjrH/iishGncT45INIJKC39jx02CzQNczPWg1FfElY
K62MmpkrcNv3bsCOJN415HFN8I709XdMCcA3KOanFXxARLzDDi0ujUvCigTaLVbW
1DPZTB7JhgJadeVTTfvQ7ylp6GwnZxiogExO3+w8boC63IcsuqyIdKeyRlYaLPWQ
sJ54LJmEcTPvR9FT0ZMDaU7R+CTiuUEJMAClOFY0NLLbLtSHAVlBtH3NTa3ksMop
kSsB9gerT8NhZd5oXgLXV8SGp/L0ZqPq2h5iOg/vM8eqVzAmECD3OeWY3xAB8eob
aFzh5/2U4bIQlKDcvYz2CC1t+K/Pxn9h7XSEefSO/gOWtismEUI=
=XzIS
-----END PGP SIGNATURE-----
--=-=-=--
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
