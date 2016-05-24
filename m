From: Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>
Subject: Re: [PATCH 2/4] hwrng: bcm2835: Support Broadcom NSP SoC rng
Date: Mon, 23 May 2016 19:14:09 -0700
Message-ID: <87oa7w2oem.fsf@eliezer.anholt.net>
References: <1464020451-16520-1-git-send-email-yendapally.reddy@broadcom.com> <1464020451-16520-3-git-send-email-yendapally.reddy@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rpi-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Yendapally Reddy Dhananjaya Reddy
	<yendapally.reddy-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
To: Yendapally Reddy Dhananjaya Reddy <yendapally.reddy-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
	Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>,
	Lee Jones <lee-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>,
	Ray Jui <rjui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
	Scott Branden <sbranden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
	Jon Mason <jonmason-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
	Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
	Kieran Bingham <kieranbingham-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Pankaj Dev <pankaj.dev-qxv4g6HH51o@public.gmane.org>,
	Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, noltari-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	Joshua Henderson <joshua.henderson-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464020451-16520-3-git-send-email-yendapally.reddy-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

--=-=-=
Content-Type: text/plain

Yendapally Reddy Dhananjaya Reddy <yendapally.reddy-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
writes:

> This supports the random number generator available in NSP SoC.
> Masks the rng interrupt for NSP.

The interrupt reg is also present on the 2835.  I would prefer for
simplicity if you also initialized the register to the same value on the
Pi, even though the firmware has presumably been setting it for us
already.

However, this patch is still correct and I'm fine with it, so it's:

Acked-by: Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJXQ7jxAAoJELXWKTbR/J7o18gP/3kYayocI6eOHIEdG++/KOHi
jjBG6Z6q6ttcGLegMhugNdjcznwLrTT6dR/RSf62pdi8on+2cXZaFttwAlhiamO/
DHIMYBFE/qpMtom20SMffy/CwAKzL0SMMVpcnbZ4b5lnBjAw97rNC495wrly+tDa
Uxw9S0VZQcsrx35CcuMXOUe4Har2u/GL++4nZ3nR4H1LS8ryrOn/ydrQ77UI2UZ9
VJjnDOmbVehj1xfiOQLgwHRqhfKY9xKemaeA2bmT44qHd/+zMPPzSR9q9fsrytA7
yjOQa6SxHGySj/JpoXxYw/kK6EPo7/Kw9EuPu2FtYahtAKOBUVQ5p9yr4mb1yzfx
9yZH160yKbeqz4R24o/zUMn2jWci9W0dJ2TCxvvXq6jykTi2fxLpu2Dyx5nHJr8E
lqXSt4UnRz+zjn4zjK2+CIcXRmzUTavrRKBsxofP77op9qAhESFtLox0J9oGt1Oi
445SY+uaf0Z7JquW23GD/2A1yn4F8hD9bpEuVpLz8CTixF/+jr0ej1E4uA3yCJ3N
8Ql+13UsxDGdnitzTRTZ+zkr5ST7T3TNAeAr4le2m8omiHwRqDKSKzXvkqWqq853
frfgvUIIe3tQ9oU5L/3nF6zkKS97VX1b502lL9xfOdqTCL9dgfmp6d0CUq8SfBBC
J6YgCA54aq3EpSlS0ylI
=KoxT
-----END PGP SIGNATURE-----
--=-=-=--
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
