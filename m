From: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH 01/19] User-space API definition
Date: Sat, 21 Aug 2010 05:11:42 -0400 (EDT)
Message-ID: <88057790.1047131282381902365.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <4C6E79B2.1040309@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-crypto@vger.kernel.org,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C6E79B2.1040309@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

----- "Stefan Richter" <stefanr@s5r6.in-berlin.de> wrote:
> Miloslav Trma=C4=8D wrote:
> > --- /dev/null
> > +++ b/include/linux/ncr.h
> [...]
> > +struct ncr_session_input_data {
> > +	const void __user *data;
> > +	__kernel_size_t data_size;
> > +};
>=20
> Why not using fixed-size fit-all members?
>=20
> struct ncr_session_input_data {
> 	__u64 data;		/* user pointer, cast to/from u64 */
> 	__u32 data_size;	/* or __u64? */
> };
>=20
> And then get rid of all the COMAPT code paths.
That would make the interface less natural, and any architecture that w=
anted to have larger pointers (I understand IBM did this back the '80s,=
 so it can happen again) would result in a significantly worse mess tha=
n the widely used compat_ioctl mechanism.
    Mirek
