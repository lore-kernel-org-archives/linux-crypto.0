From: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH 06/19] Add ioctl() argument and attribute handling utils
Date: Fri, 20 Aug 2010 22:15:41 -0400 (EDT)
Message-ID: <1833173750.1044971282356941800.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <4C6E7C1A.1070203@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-crypto@vger.kernel.org,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:41063 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751027Ab0HUCP4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Aug 2010 22:15:56 -0400
In-Reply-To: <4C6E7C1A.1070203@s5r6.in-berlin.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

----- "Stefan Richter" <stefanr@s5r6.in-berlin.de> wrote:
> Miloslav Trma=C4=8D wrote:
> > --- /dev/null
> > +++ b/crypto/userspace/utils.c
> [...]
> > +#ifdef CONFIG_COMPAT
> > +/* max() is too clever for compile-time constants */
> > +#define CONST_MAX(A, B) ((A) > (B) ? (A) : (B))
> > +
> > +#define MAX_SESSION_INPUT_DATA_SIZE					\
> > +	(CONST_MAX(sizeof(struct ncr_session_input_data),		\
> > +		   sizeof(struct compat_ncr_session_input_data)))
> > +#define MAX_SESSION_OUTPUT_BUFFER_SIZE					\
> > +	(CONST_MAX(sizeof(struct ncr_session_output_buffer),		\
> > +		   sizeof(struct compat_ncr_session_output_buffer)))
> > +
> > +#else /* !CONFIG_COMPAT */
> > +
> > +#define MAX_SESSION_INPUT_DATA_SIZE (sizeof(struct ncr_session_inp=
ut_data))
> > +#define MAX_SESSION_OUTPUT_BUFFER_SIZE			\
> > +	(sizeof(struct ncr_session_output_buffer))
> > +
> > +#endif /* !CONFIG_COMPAT */
>=20
> struct compat_xyz cannot be bigger than struct xyz, can it?
Perhaps not, but the code has been written and it's easier to keep it t=
han to speculate :)  It also helps document the fact that the data form=
at depends on properties of the userspace.
    Mirek
