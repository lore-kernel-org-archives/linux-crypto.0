From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 01/10] crypto: rsa - generalize ASN.1 sequences
Date: Sun, 20 Mar 2016 07:53:40 -0700
Message-ID: <56EEB974.2030702@intel.com>
References: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, smueller@chronox.de,
	horia.geanta@nxp.com
To: Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47523 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480AbcCTO6Y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 20 Mar 2016 10:58:24 -0400
In-Reply-To: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Tudor,
On 03/18/2016 11:31 AM, Tudor Ambarus wrote:
> Use common ASN.1 sequences for all RSA implementations.
> 
> Give hardware RSA implementations the chance to use
> the RSA's software implementation parser even if they
> are likely to want to use raw integers.
> 
> The parser expects a context that contains at the first address
> a struct rsa_asn1_action with function pointers to specific
> parser actions (return MPI or raw integer keys), followed by
> a key representation structure (for MPI or raw integers).
> 
> This approach has the advantage that users can select specific
> parser actions by using a general parser with function pointers
> to specific actions.
> 
> Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>

I like the rsa_asn1_action idea, but I have some comments regarding
the proposed implementation.

> -int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
> -		      unsigned int key_len);
> +struct rsa_asn1_action {
> +	int (*get_n)(void *context, size_t hdrlen, unsigned char tag,
> +		     const void *value, size_t vlen);
> +	int (*get_e)(void *context, size_t hdrlen, unsigned char tag,
> +		     const void *value, size_t vlen);
> +	int (*get_d)(void *context, size_t hdrlen, unsigned char tag,
> +		     const void *value, size_t vlen);
> +};

To be able to take advantage of the Chinese remainder algorithm the
generic rsa_asn1_action should allow to provide handlers to obtain all
components of the private key i.e. handlers for p,q,dp,dq,qinv should
also be provided.
Also I think we don't need the size_t hdrlen and unsigned char tag here.

> +
> +struct rsa_ctx {
> +	struct rsa_asn1_action action;

This should be a pointer to struct rsa_asn1_action *action;
There is no need to have a separate instance per tfm. 
Drives should be able to use similar concept to how struct file_operations
is used. Instead of set_rsa_priv_action they should do
 
static const struct rsa_asn1_action impl_action = {
	.get_n = impl_get_n;
	.get_e = impl_get_e;
.....
};

and then:

static int rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
 			    unsigned int keylen)
 {
	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
	struct rsa_mpi_key *pkey = &ctx->key;
 	int ret;

	ctx->action = &impl_action;
 
	ret = rsa_parse_mpi_priv_key(ctx, key, keylen);
	return ret;
}

and the parser for each component will look as follows:

int rsa_get_<X>(void *context, size_t hdrlen, unsigned char tag,
	      const void *value, size_t vlen)
{
	struct rsa_ctx *ctx = context;
	struct const rsa_asn1_action *action = ctx->action;

	if (action->get_<X>)
		return action->get_<X>(context, value, vlen);

	return 0;
}

This will allow all the drivers to get what then need.
Thanks,
-- 
TS
