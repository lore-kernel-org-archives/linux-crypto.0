From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v2 1/2] crypto: add PKE API
Date: Sat, 23 May 2015 07:20:15 -0700
Message-ID: <55608C9F.7040500@intel.com>
References: <20150506193643.9329.75351.stgit@tstruk-mobl1> <20150506193648.9329.27232.stgit@tstruk-mobl1> <20150511063222.GB2316@gondor.apana.org.au> <555F777D.1030509@intel.com> <20150523054734.GA14239@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	keescook@chromium.org, jwboyer@redhat.com, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61668 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbbEWOXr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 23 May 2015 10:23:47 -0400
In-Reply-To: <20150523054734.GA14239@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/22/2015 10:47 PM, Herbert Xu wrote:
>> struct akcipher_request {
>> > 	struct crypto_async_request base;
>> > 	struct scatterlist *inparams;
>> > 	struct scatterlist *outparams;
>> > 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
>> > };
> I think you should rename them to src/dst and add a length argument.
> Limiting them to one entry also seems strange.  When do you need more
> one parameter?

The length would be redundant. It can be obtained by sg_nents(reg->inparams)
I don't limit the number of parameters. You can pass as many as you want. For instance to pass 3 in and 2 out you do:

	struct scatterlist in[3];
	struct scatterlist out[2];

	sg_init_table(in, 3);
	sg_init_table(out, 2);

	sg_set_buf(in, first_in_param, len_of_first_in_param);
	sg_set_buf(in + 1, second_in_param, len_of_second_in_param);
	sg_set_buf(in + 2, third_in_param, len_of_third_in_param);
		
	sg_set_buf(out, first_out_param, len_of_first_out_param);
	sg_set_buf(out + 1, second_out_param, len_of_second_out_param);

	akcipher_request_set_crypt(req, &in, &out);

The limitation here is that one parameter can not span multiple sgs. This should be ok as they will never be bigger than one page.
In fact MPI limits it to 2K max with #define MAX_EXTERN_MPI_BITS 16384.
I'm ok to rename it to src and dst.

> 
>> struct akcipher_alg {
>> > 	int (*sign)(struct akcipher_request *req);
>> > 	int (*verify)(struct akcipher_request *req);
>> > 	int (*encrypt)(struct akcipher_request *req);
>> > 	int (*decrypt)(struct akcipher_request *req);
> Looks good.  You'll also need a setkey (or perhaps two) function.

I have these two:

/**
 * crypto_akcipher_setkey() -- assign a public key to an AKCIPHER tfm handle
 *
 * @tfm: AKCIPHER tfm handle allocated with crypto_alloc_akcipher()
 * @pkey: public key
 */
static inline void crypto_akcipher_setkey(struct crypto_akcipher *tfm,
					  const struct public_key *pkey);

/**
 * crypto_akcipher_getkey() -- obtain a public key from an AKCIPHER tfm handle
 *
 * @tfm: AKCIPHER tfm handle allocated with crypto_alloc_akcipher()
 *
 * Return: public key
 */
static inline const struct public_key *crypto_akcipher_getkey(
	struct crypto_akcipher *tfm);
