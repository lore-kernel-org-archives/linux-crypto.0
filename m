From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH RFC v4 2/4] crypto: add PKE API
Date: Fri, 12 Jun 2015 03:00:42 +0200
Message-ID: <2901639.xlpED6EpBc@tauon.atsec.com>
References: <20150611190533.31826.13956.stgit@tstruk-mobl1> <20150611190543.31826.357.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	keescook@chromium.org, jwboyer@redhat.com, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46225 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbbFLBDC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2015 21:03:02 -0400
In-Reply-To: <20150611190543.31826.357.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Thursday 11 June 2015, 12:05:44 schrieb Tadeusz Struk:

Hi Tadeusz,

>+
>+static int akcipher_clone_key(struct crypto_akcipher *tfm,
>+			      const struct public_key *pkey)
>+{
>+	int i, ret = 0;
>+
>+	tfm->pkey = kzalloc(sizeof(*tfm->pkey), GFP_KERNEL);
>+
>+	if (!tfm->pkey)
>+		return -ENOMEM;
>+
>+	for (i = 0; i < ARRAY_SIZE(tfm->pkey->mpi); i++) {
>+		if (!pkey->mpi[i])
>+			continue;
>+
>+		if (mpi_copy(&tfm->pkey->mpi[i], pkey->mpi[i])) {
>+			akcipher_free_key(tfm->pkey);
>+			tfm->pkey = NULL;
>+			ret = -ENOMEM;
>+			break;
>+		}
>+	}
>+	return ret;
>+}

The testmgr code can mark an entire cipher implementation as fips_allowed=1 as 
already done for RSA. However, unlike with the other ciphers, that flag must 
go in conjunction with the used key sizes.

For FIPS mode, the following restrictions apply:

- RSA: 2048/3072

- DSA: L 2048 / N 224; L 2048 / N 256; L 3072 / N 256

- ECDSA: only the NIST curves

Any other key sizes for the given ciphers is not allowed in FIPS mode.

Should that constraint be considered here?

Ciao
Stephan
