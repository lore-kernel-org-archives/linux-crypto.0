From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 06/19] Add ioctl() argument and attribute handling utils
Date: Fri, 20 Aug 2010 14:59:06 +0200
Message-ID: <4C6E7C1A.1070203@s5r6.in-berlin.de>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com> <1282293963-27807-7-git-send-email-mitr@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-crypto@vger.kernel.org,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org
To: =?UTF-8?B?TWlsb3NsYXYgVHJtYcSN?= <mitr@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1282293963-27807-7-git-send-email-mitr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Miloslav Trma=C4=8D wrote:
> --- /dev/null
> +++ b/crypto/userspace/utils.c
[...]
> +#ifdef CONFIG_COMPAT
> +/* max() is too clever for compile-time constants */
> +#define CONST_MAX(A, B) ((A) > (B) ? (A) : (B))
> +
> +#define MAX_SESSION_INPUT_DATA_SIZE					\
> +	(CONST_MAX(sizeof(struct ncr_session_input_data),		\
> +		   sizeof(struct compat_ncr_session_input_data)))
> +#define MAX_SESSION_OUTPUT_BUFFER_SIZE					\
> +	(CONST_MAX(sizeof(struct ncr_session_output_buffer),		\
> +		   sizeof(struct compat_ncr_session_output_buffer)))
> +
> +#else /* !CONFIG_COMPAT */
> +
> +#define MAX_SESSION_INPUT_DATA_SIZE (sizeof(struct ncr_session_input=
_data))
> +#define MAX_SESSION_OUTPUT_BUFFER_SIZE			\
> +	(sizeof(struct ncr_session_output_buffer))
> +
> +#endif /* !CONFIG_COMPAT */

struct compat_xyz cannot be bigger than struct xyz, can it?
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D=3D-=3D- =3D--- =3D-=3D--
http://arcgraph.de/sr/
