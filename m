From: James Morris <jmorris@namei.org>
Subject: Re: [RFC v1.1 2/5] crypto: ksign - digital signature verification
 support
Date: Tue, 16 Aug 2011 11:00:39 +1000 (EST)
Message-ID: <alpine.LRH.2.00.1108161059260.7706@tundra.namei.org>
References: <cover.1313082284.git.dmitry.kasatkin@intel.com> <8abcf5f23fc65590340f51399fc2d60cf4e62f30.1313082284.git.dmitry.kasatkin@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	zohar@linux.vnet.ibm.com
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tundra.namei.org ([65.99.196.166]:50206 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab1HPBAt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Aug 2011 21:00:49 -0400
In-Reply-To: <8abcf5f23fc65590340f51399fc2d60cf4e62f30.1313082284.git.dmitry.kasatkin@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 11 Aug 2011, Dmitry Kasatkin wrote:

> +static int ksign_verify_rsa(struct key *key,
> +		    const char *sig, int siglen,
> +		       const char *h, int hlen)
> +{
> +	int err = -ENOMEM;
> +	unsigned long len;
> +	unsigned long mlen, mblen;
> +	unsigned nret, l;
> +	int valid, head, i;
> +	unsigned char *out1 = NULL, *out2 = NULL;
> +	MPI in = NULL, res = NULL, pkey[2];
> +	uint8_t *p, *datap, *endp;
> +	struct user_key_payload *ukp;
> +	struct pubkey_hdr *pkh;
> +
> +	down_read(&key->sem);
> +	ukp = key->payload.data;
> +	pkh = (struct pubkey_hdr *)ukp->data;
> +
> +	if (pkh->version != 1)
> +		return -EINVAL;
> +
> +	if (pkh->algo != PUBKEY_ALGO_RSA)
> +		return -EINVAL;

Are you supposed to be still holding key->sem here?

-- 
James Morris
<jmorris@namei.org>
