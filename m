From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 01/19] User-space API definition
Date: Fri, 20 Aug 2010 10:12:46 -0700
Message-ID: <20100820101246.6c7a3729.randy.dunlap@oracle.com>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
	<1282293963-27807-2-git-send-email-mitr@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-crypto@vger.kernel.org,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org
To: Miloslav =?UTF-8?B?VHJtYcSN?= <mitr@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:33415 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab0HTRNK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Aug 2010 13:13:10 -0400
In-Reply-To: <1282293963-27807-2-git-send-email-mitr@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 20 Aug 2010 10:45:44 +0200 Miloslav Trma=C4=8D wrote:

> +#define NCRIO_KEY_INIT			_IO('c', 204)
> +/* generate a secret key */
> +#define NCRIO_KEY_GENERATE     	_IOWR('c', 205, struct ncr_key_gener=
ate)
> +/* generate a public key pair */
> +#define NCRIO_KEY_GENERATE_PAIR _IOWR('c', 206, struct ncr_key_gener=
ate_pair)
> +/* derive a new key from an old one */
> +#define NCRIO_KEY_DERIVE        _IOWR('c', 207, struct ncr_key_deriv=
e)
> +/* return information on a key */
> +#define NCRIO_KEY_GET_INFO      _IOWR('c', 208, struct ncr_key_get_i=
nfo)
> +/* export a secret key */
> +#define NCRIO_KEY_EXPORT       	_IOWR('c', 209, struct ncr_key_expor=
t)
> +/* import a secret key */
> +#define NCRIO_KEY_IMPORT       	_IOWR('c', 210, struct ncr_key_impor=
t)
> +
> +#define NCRIO_KEY_DEINIT       _IOR ('c', 215, ncr_key_t)


Please add (another) 'c' entry to Documentation/ioctl/ioctl-number.txt.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***
