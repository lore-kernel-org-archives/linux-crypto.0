From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH RFC 0/2] crypto: Introduce Public Key Encryption API
Date: Mon, 4 May 2015 16:16:01 +0300
Message-ID: <55477111.2050803@freescale.com>
References: <20150430223647.10157.82156.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <corbet@lwn.net>, <keescook@chromium.org>, <qat-linux@intel.com>,
	<jwboyer@redhat.com>, <richard@nod.at>, <d.kasatkin@samsung.com>,
	<linux-kernel@vger.kernel.org>, <steved@redhat.com>,
	<dhowells@redhat.com>, <vgoyal@redhat.com>,
	<james.l.morris@oracle.com>, <jkosina@suse.cz>,
	<zohar@linux.vnet.ibm.com>, <davem@davemloft.net>,
	<jdelvare@suse.de>, <linux-crypto@vger.kernel.org>
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	<herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150430223647.10157.82156.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 5/1/2015 1:36 AM, Tadeusz Struk wrote:
> This patch set introduces a Public Key Encryption API.
> What is proposed is a new crypto type called crypto_pke_type
> plus new struct pke_alg and struct pke_tfm together with number
> of helper functions to register pke type algorithms and allocate
> tfm instances. This is to make it similar to how the existing crypto
> API works for the ablkcipher, ahash, and aead types.
> The operations the new interface will allow to provide are:
> 
> 	int (*sign)(struct pke_request *pkereq);
> 	int (*verify)(struct pke_request *pkereq);
> 	int (*encrypt)(struct pke_request *pkereq);
> 	int (*decrypt)(struct pke_request *pkereq);

Where would be the proper place for keygen operation?

> 
> The benefits it gives comparing to the struct public_key_algorithm
> interface are:
> - drivers can add many implementations of RSA or DSA
>   algorithms and user will allocate instances (tfms) of these, base on
>   algorithm priority, in the same way as it is with the symmetric ciphers.
> - the new interface allows for asynchronous implementations that
>   can use crypto hardware to offload the calculations to.
> - integrating it with linux crypto api allows using all its benefits
>   i.e. managing algorithms using NETLINK_CRYPTO, monitoring implementations
>   using /proc/crypto. etc
> 
> New helper functions have been added to allocate pke_tfm instances
> and invoke the operations to make it easier to use.
> For instance to verify a public_signature against a public_key using
> the RSA algorithm a user would do:
> 
> 	struct crypto_pke *tfm = crypto_alloc_pke("rsa", 0, 0);
> 	struct pke_request *req = pke_request_alloc(tfm, GFP_KERNEL);
> 	pke_request_set_crypt(req, pub_key, signature);
> 	int ret = crypto_pke_verify(req);
> 	pke_request_free(req);
> 	crypto_free_pke(tfm);
> 	return ret;
> 
> Additionally existing public_key and rsa code have been reworked to
> use the new interface for verifying signed modules.
> As part of the rework the enum pkey_algo has been removed as the algorithm
> to allocate will be indicated by a string - for instance "rsa" or "dsa",
> similarly as it is with the symmetric algs e.g. "aes".
> It will also make it easier to extend in the future when new algorithms
> will be added.

AFAICT algorithms currently map to primitives + encoding methods, which
is not flexible. For e.g. current RSA implementation hardcodes the
PKCS1-v1_5 encoding method, making it hard to add OAEP(+) etc.

One solution would be to map algorithms to primitives only. Encoding
methods need to be abstracted somehow, maybe using templates to wrap the
algorithms.

Regards,
Horia
