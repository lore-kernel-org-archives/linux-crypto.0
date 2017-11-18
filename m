From: Pierre <pinaraf@pinaraf.info>
Subject: Re: [PATCH] Fix NULL pointer deref. on no default_rng
Date: Sat, 18 Nov 2017 18:18:19 +0100
Message-ID: <1611020.Ca7VyhhiKU@peanuts2>
References: <20171112142432.20186-1-pinaraf@pinaraf.info> <CANc+2y70xppF_wZAi4urVtKGGdn4-GzVHkqEh82rxCS_pD7BDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart7445310.ZMAl3vrWKW"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:58986 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967008AbdKRRSw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 Nov 2017 12:18:52 -0500
In-Reply-To: <CANc+2y70xppF_wZAi4urVtKGGdn4-GzVHkqEh82rxCS_pD7BDA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--nextPart7445310.ZMAl3vrWKW
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Sunday, November 12, 2017 8:16:27 PM CET PrasannaKumar Muralidharan wrote:
> Hi Pierre,
> 
> On 12 November 2017 at 19:54, Pierre Ducroquet <pinaraf@pinaraf.info> wrote:
> > If crypto_get_default_rng returns an error, the
> > function ecc_gen_privkey should return an error.
> > Instead, it currently tries to use the default_rng
> > nevertheless, thus creating a kernel panic with a
> > NULL pointer dereference.
> > Returning the error directly, as was supposedly
> > intended when looking at the code, fixes this.
> > 
> > Signed-off-by: Pierre Ducroquet <pinaraf@pinaraf.info>
> > ---
> > 
> >  crypto/ecc.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/crypto/ecc.c b/crypto/ecc.c
> > index 633a9bcdc574..18f32f2a5e1c 100644
> > --- a/crypto/ecc.c
> > +++ b/crypto/ecc.c
> > @@ -964,7 +964,7 @@ int ecc_gen_privkey(unsigned int curve_id, unsigned
> > int ndigits, u64 *privkey)> 
> >          * DRBG with a security strength of 256.
> >          */
> >         
> >         if (crypto_get_default_rng())
> > 
> > -               err = -EFAULT;
> > +               return -EFAULT;
> > 
> >         err = crypto_rng_get_bytes(crypto_default_rng, (u8 *)priv,
> >         nbytes);
> >         crypto_put_default_rng();
> > 
> > --
> > 2.15.0
> 
> Looks good to me.
> 
> Reviewed-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
> 
> Regards,
> PrasannaKumar

Hi

Thanks for your review.
Is there anything I should do to have this merged ? It fixes a kernel panic at 
boot on my computer, so I suppose other people may have that too.

Regards
 Pierre


--nextPart7445310.ZMAl3vrWKW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEds3aTMo5n1dvXH/GYkPWy+GpSGUFAloQa1sACgkQYkPWy+Gp
SGUbjg//Zd9xAU9sZvUazEHWO++Y6m7tjQTn9x7vRNQNv7Ciskf6t1n9hoN8FGFv
yO03HhYauyoJWsdB3ZAfDwlxdmTMV4hUCvRj9pbAVDTHfRPcqzxL4UhqodPjDWS+
h5FRkl6+wlPoCmkXVZ15ihqjtMd9jkXjWP3AXP1wz8ru/RtLbpkJuaPkGshbotJ5
Hitg0AgzGuPJYLZ7n3us/KncD9i4KWRuD1UP2EF6Fjm5tH0r5gd5aqmoE0VlPqeg
Ah+UVJ70Bmjk+ZvhTx4E5F9GsYf90FBgCQ+DWnpB4udz6vsa7Hq9dWH8IYFTd2Et
o7TC699cU46bOrbbalxW3Q8sJTOkNMOY16jJHjj0YocLotbyER5xJqAV6gPWoZYH
Op90XcPwfbem2JcASSVig3ry8qIkcZLkEPWxa0DktCHXsFfJZZ8hJ+ZPsRUvAU7h
n8zCzYH1h5zysi9AnrDIF6BgLrD+SHMUEcCBF6T4k8h8y50kFsmespW5Jpd9UHmk
wkvBVvB16F1l0eB7/+fK1rEEyxyxfyo58+Fs0XLi1ACMZOxSJ8uAPt/tVNiRKi4I
WCLStUvb4mxWs6iAMSaFsLWXR7dP6DYuwPWEZuSfH1l9r/SgU/tSXYOE+yWh2RLT
dz149WF+F7RX6H9oQq26mWPQP7h53Tp2xFtzoWR/GhYwMB5zt2Q=
=qasB
-----END PGP SIGNATURE-----

--nextPart7445310.ZMAl3vrWKW--
