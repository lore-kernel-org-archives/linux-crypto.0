From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH] nvmem: sunxi-sid: SID content is not a valid source of
 randomness
Date: Mon, 24 Oct 2016 22:10:20 +0200
Message-ID: <20161024201020.h6akyqad2o42xkhq@lukather>
References: <1477144408-15896-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mezsqkracvhwbkav"
Cc: srinivas.kandagatla@linaro.org, wens@csie.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from up.free-electrons.com ([163.172.77.33]:54370 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933409AbcJXUKd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Oct 2016 16:10:33 -0400
Content-Disposition: inline
In-Reply-To: <1477144408-15896-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--mezsqkracvhwbkav
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 22, 2016 at 03:53:28PM +0200, Corentin Labbe wrote:
> Since SID's content is constant over reboot,

That's not true, at least not across all the Allwinner SoCs, and
especially not on the A10 and A20 that this driver supports.

> it must not be used as source of randomness.

And I don't think that's true either. A constant entropy provider will
not add any entropy, but will not remove any, would it?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--mezsqkracvhwbkav
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYDmqnAAoJEBx+YmzsjxAg7bEP/1keYQW58yTyODkQs6Q0RtMB
SSg9u6M4JWqlQN8QA+wnaSZMsjDUnFpQQAy1WRwaNjwVhXZul6oZOMF8FuH7a0Di
gVQMFXi0iJRn8gtxEoQ8UvrILeDcNuu1SkV1o6dIBKDPq8nMTGAi8CoX7kCjvGww
osj3MGOh7I/JVyziuS9jnKHqL7ZoWAgUL/gdr69lu76VhYxxmVaUS5TUY70dzfi0
GhpfVunzH7O13LGX/V2Vq4cmgt5ISASt4u+kQ5MoiAfJpQn0FWyQty2eGyIbVmQd
mLUQsBTN/S7R12jO5XgfxUPbYM3GrRj6Jav/NshRja8PMVQfMpcDw/aBlQgjskfC
s7HAo9Nsk98CzTvQpggZgnqCi3FQLUrW3HsjKobTUp0wYHdIEsWk4ouaTi/D3Q3N
NDV+lNUN3zZgvWZMQreyOoF8fpy2Rlo/CcmuzxgEXHiDDd26AtBMelP/NeE8LTkw
EpZvgz5zdmZgoNrJnb3i6YAaGf8RAsA2ehw2rvQvpK/C2vD4eDFWovKvTxF9hUaJ
6dEt9biYjGXeDGW9ySHQCXqYj63XfM6Sl9q1yFPuQ539fzcpla5XseL+jHEykDzU
carecqIkUBWqdZT/DOmFayohCmUmvopmjlDK96nZ9KKlPhc+aqcM9r5c85e/J5lU
tp3Jst4olg8qEuGFvX1R
=K39i
-----END PGP SIGNATURE-----

--mezsqkracvhwbkav--
