From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH RFC 1/2] crypto: add PKE API
Date: Fri, 01 May 2015 17:04:00 +0100
Message-ID: <4227.1430496240@warthog.procyon.org.uk>
References: <20150430223652.10157.86151.stgit@tstruk-mobl1> <20150430223647.10157.82156.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, herbert@gondor.apana.org.au, corbet@lwn.net,
	keescook@chromium.org, qat-linux@intel.com, jwboyer@redhat.com,
	richard@nod.at, d.kasatkin@samsung.com,
	linux-kernel@vger.kernel.org, steved@redhat.com, vgoyal@redhat.com,
	james.l.morris@oracle.com, jkosina@suse.cz,
	zohar@linux.vnet.ibm.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030365AbbEAQEd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 May 2015 12:04:33 -0400
In-Reply-To: <20150430223652.10157.86151.stgit@tstruk-mobl1>
Content-ID: <4226.1430496240.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tadeusz Struk <tadeusz.struk@intel.com> wrote:

> +config CRYPTO_PKE

I would prefer CRYPTO_PKEY and pkey rather than pke generally and algo rather
than alg where possible - this will have more consistency with what we have
now.

I understand, however, that in core crypto code, 'alg' is used.

+	seq_printf(m, "can encrypt  : %s\n", cap & PKEY_CAN_ENCRYPT ?
+		   "yes" : "no");

Please split the line after the comma.

>  #define CRYPTO_ALG_TYPE_AHASH		0x0000000a
> +#define CRYPTO_ALG_TYPE_PKE		0x0000000b
>  #define CRYPTO_ALG_TYPE_RNG		0x0000000c

Will filling a hole cause a problem with something that got obsoleted?

> +struct pke_request {
> +	struct crypto_async_request base;
> +	const struct public_key *pk;
> +	const struct public_key_signature *pks;
> +};

I recommend:

	pk -> key or pkey
	pks -> sig or signature

> +	u8 pub_mpis;	/* Number of MPIs in public key */
> +	u8 sec_mpis;	/* Number of MPIs in secret key */
> +	u8 sig_mpis;	/* Number of MPIs in a signature */

Keep member names as:

	u8		n_pub_mpi;	/* Number of MPIs in public key */
	u8		n_sec_mpi;	/* Number of MPIs in secret key */
	u8		n_sig_mpi;	/* Number of MPIs in a signature */

please.

David
