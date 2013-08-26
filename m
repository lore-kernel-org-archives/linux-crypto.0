From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 02/18] asymmetric keys: implement
 EMSA_PKCS1-v1_5-ENCODE in rsa
Date: Mon, 26 Aug 2013 18:17:49 +0800
Message-ID: <1377512269.27967.29.camel__46818.319152999$1377512372$gmane$org@linux-s257.site>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <1377169317-5959-3-git-send-email-jlee@suse.com>
	 <20130825155309.GA5171@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>,
	Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>,
	Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>,
	Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, JKosina-IBi9RG/b67k@public.gmane.org,
	Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>,
	Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130825155309.GA5171-tWAi6jLit6GreWDznjuHag@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Pavel,=20

=46irst, thanks for your review!

=E6=96=BC =E6=97=A5=EF=BC=8C2013-08-25 =E6=96=BC 17:53 +0200=EF=BC=8CPa=
vel Machek =E6=8F=90=E5=88=B0=EF=BC=9A
> On Thu 2013-08-22 19:01:41, Lee, Chun-Yi wrote:
> > Implement EMSA_PKCS1-v1_5-ENCODE [RFC3447 sec 9.2] in rsa.c. It's t=
he
> > first step of signature generation operation
> > (RSASSA-PKCS1-v1_5-SIGN).
>=20
> Is this your own code, or did you copy it from somewhere?
>=20

It's my own code, development base on RSA PKCS#1 spec. So the naming of
variables are match with PKCS#1 spec.

> > +	if (!T)
> > +		goto error_T;
> > +
> > +	memcpy(T, RSA_ASN1_templates[hash_algo].data, RSA_ASN1_templates[=
hash_algo].size);
> > +	memcpy(T + RSA_ASN1_templates[hash_algo].size, pks->digest, pks->=
digest_size);
> > +
> > +	/* 3) check If emLen < tLen + 11, output "intended encoded messag=
e length too short" */
> > +	if (emLen < tLen + 11) {
> > +		ret =3D EINVAL;
> > +		goto error_emLen;
> > +	}
>=20
> Normal kernel calling convention is 0 / -EINVAL.

Yes, here is my mistake, I will modify it.

>=20
> > +	memcpy(EM + 2, PS, emLen - tLen - 3);
> > +	EM[2 + emLen - tLen - 3] =3D 0x00;
> > +	memcpy(EM + 2 + emLen - tLen - 3 + 1, T, tLen);
>=20
> ThisDoesNotLookLikeKernelCode, NoCamelCase, please.
>=20

Thanks for you point out, I will change it.

> > +	*_EM =3D EM;
>=20
> And we don't usually use _ prefix like this.
>=20

Thanks! I will change it.

>=20
> > --- a/include/crypto/public_key.h
> > +++ b/include/crypto/public_key.h
> > @@ -110,6 +110,8 @@ extern void public_key_destroy(void *payload);
> >  struct public_key_signature {
> >  	u8 *digest;
> >  	u8 digest_size;			/* Number of bytes in digest */
> > +	u8 *S;				/* signature S of length k octets */
>=20
> u8 *signature?

Yes, this 'S' is signature. I put the naming full match with spec for
development, I will change it to match kernel rule. e.g. signature_S

>=20
> > +	size_t k;			/* length k of signature S */
>=20
> u8 *signature_length.
>=20

I will use signature_leng_k to also match with PKCS#1 spec, I think it'=
s
better for review source code with the spec for debugging.


Thanks a lot!
Joey Lee
