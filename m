From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 06/19] Add ioctl() argument and attribute handling utils
Date: Sat, 21 Aug 2010 09:15:57 +0200
Message-ID: <4C6F7D2D.6060101@s5r6.in-berlin.de>
References: <1833173750.1044971282356941800.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-crypto@vger.kernel.org,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org
To: Miloslav Trmac <mitr@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:57292 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab0HUHQP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 21 Aug 2010 03:16:15 -0400
In-Reply-To: <1833173750.1044971282356941800.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Miloslav Trmac wrote:
> ----- "Stefan Richter" <stefanr@s5r6.in-berlin.de> wrote:
>> Miloslav Trma=C4=8D wrote:
>>> --- /dev/null
>>> +++ b/crypto/userspace/utils.c
>> [...]
>>> +#ifdef CONFIG_COMPAT
>>> +/* max() is too clever for compile-time constants */
>>> +#define CONST_MAX(A, B) ((A) > (B) ? (A) : (B))
>>> +
>>> +#define MAX_SESSION_INPUT_DATA_SIZE					\
>>> +	(CONST_MAX(sizeof(struct ncr_session_input_data),		\
>>> +		   sizeof(struct compat_ncr_session_input_data)))
>>> +#define MAX_SESSION_OUTPUT_BUFFER_SIZE					\
>>> +	(CONST_MAX(sizeof(struct ncr_session_output_buffer),		\
>>> +		   sizeof(struct compat_ncr_session_output_buffer)))
>>> +
>>> +#else /* !CONFIG_COMPAT */
>>> +
>>> +#define MAX_SESSION_INPUT_DATA_SIZE (sizeof(struct ncr_session_inp=
ut_data))
>>> +#define MAX_SESSION_OUTPUT_BUFFER_SIZE			\
>>> +	(sizeof(struct ncr_session_output_buffer))
>>> +
>>> +#endif /* !CONFIG_COMPAT */
>>=20
>> struct compat_xyz cannot be bigger than struct xyz, can it?
>
> Perhaps not, but the code has been written and it's easier to keep it=
 than to
> speculate :)

What's there to speculate? :-)  COMPAT =3D 32bit user on 64bit kernel. =
 The
latter has larger long and pointers and possibly different alignment of=
 64bit
data.

> It also helps document the fact that the data format depends on prope=
rties of
> the userspace.

Since it is a new ABI, it can be written to not need COMPAT ifdef'ery n=
or
compat handlers.
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D=3D-=3D- =3D--- =3D-=3D-=3D
http://arcgraph.de/sr/
