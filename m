From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v2 1/2] crypto: add PKE API
Date: Fri, 22 May 2015 11:37:49 -0700
Message-ID: <555F777D.1030509@intel.com>
References: <20150506193643.9329.75351.stgit@tstruk-mobl1> <20150506193648.9329.27232.stgit@tstruk-mobl1> <20150511063222.GB2316@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	keescook@chromium.org, jwboyer@redhat.com, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:52030 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945919AbbEVSlU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 May 2015 14:41:20 -0400
In-Reply-To: <20150511063222.GB2316@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/10/2015 11:32 PM, Herbert Xu wrote:
> On Wed, May 06, 2015 at 12:36:48PM -0700, Tadeusz Struk wrote:
>>
>> +	const struct public_key_signature *signature;
> 
> Doing this means that you aren't adding it to the crypto API
> properly.  You need to start from scratch and design a proper
> interface and not just wrap some existing opaque data strcture.
> 
> Cheers,
> 

Hi Herbert,
Thanks for your feedback.
How about this:

/**
 * struct akcipher_request - public key request
 *
 * @base:	Common attributes for async crypto requests
 * @inparams:	scatterlist of input parameters (one ent per parameter)
 *		for the operation as defined in RFC.
 *		For instance for rsa encrypt only one input param is required,
 *		(i.e. 'm' - message) as specified in RFC3447 sec 5.1.1
 *		(Note: the key belongs to the tfm)
 * @outparams:	scatterlist of output parameters (one ent per parameter)
 *		for the operation as defined in RFC.
 *		For instance for rsa encrypt only one output param will be
 *		produced (i.e. 'c' - cipher text) as specified in
 *		RFC3447 sec 5.1.1
 *
 * @__ctx:	Start of private context data
 */
struct akcipher_request {
	struct crypto_async_request base;
	struct scatterlist *inparams;
	struct scatterlist *outparams;
	void *__ctx[] CRYPTO_MINALIGN_ATTR;
};

/**
 * struct akcipher_alg - generic public key algorithm
 *
 * @sign:	Function performs a sign operation as defined by public key
 *		algorithm
 * @verify:	Function performs a sign operation as defined by public key
 *		algorithm
 * @encrypt:	Function performs an encrypt operation as defined by public key
 *		algorithm
 * @decrypt:	Function performs a decrypt operation as defined by public key
 *		algorithm
 * @reqsize:	Request context size required by algorithm implementation
 *
 * @base:	Common crypto API algorithm data structure
 */
struct akcipher_alg {
	int (*sign)(struct akcipher_request *req);
	int (*verify)(struct akcipher_request *req);
	int (*encrypt)(struct akcipher_request *req);
	int (*decrypt)(struct akcipher_request *req);

	unsigned int reqsize;
	struct crypto_alg base;
};

/**
 * struct crypto_akcipher - user-instantiated objects which encapsulate
 * algorithms and core processing logic
 *
 * @base:	Common crypto API algorithm data structure
 * @pkey:	Key representation. Note: this can be both public or private
 *		key, depending on the operation.
 * @__ctx:	Start of private context data
 */
struct crypto_akcipher {
	struct crypto_tfm base;
	const struct public_key *pkey;
	void *__ctx[] CRYPTO_MINALIGN_ATTR;
};
