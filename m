From: Nitin Kumbhar <nkumbhar@nvidia.com>
Subject: Re: [PATCH 5/6] crypto: testmgr: add ECDSA tests
Date: Thu, 26 Jan 2017 11:28:24 +0530
Message-ID: <809253f7-284a-d37f-e695-c22bda544b02@nvidia.com>
References: <1484912161-5932-1-git-send-email-nkumbhar@nvidia.com>
 <1484912161-5932-6-git-send-email-nkumbhar@nvidia.com>
 <3632665.JG6sEKLG9p@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8BIT
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7521 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751598AbdAZF6f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Jan 2017 00:58:35 -0500
In-Reply-To: <3632665.JG6sEKLG9p@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Stephan,

On 1/20/2017 6:49 PM, Stephan Müller wrote:
> Am Freitag, 20. Januar 2017, 17:06:00 CET schrieb Nitin Kumbhar:
>
> Hi Nitin,
>
>> Update crypto test manager to include NIST ECDSA
>> test vectors and various ECDSA tests. These include
>> tests for ECDSA signing, ECDSA sign-verification,
>> ECDSA signing and verifying generated signatures and
>> invalidation of incorrect signatures.
>>
>> Signed-off-by: Nitin Kumbhar <nkumbhar@nvidia.com>
>> ---
>>  crypto/testmgr.c |  452
>> +++++++++++++++++++++++++++++++++++++++++++++++++++++- crypto/testmgr.h |
>> 140 +++++++++++++++++
>>  2 files changed, 589 insertions(+), 3 deletions(-)
>>
>> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
>> index 98eb09782db8..a1db28cbc32d 100644
>> --- a/crypto/testmgr.c
>> +++ b/crypto/testmgr.c
>> @@ -5,6 +5,7 @@
>>   * Copyright (c) 2002 Jean-Francois Dive <jef@linuxbe.org>
>>   * Copyright (c) 2007 Nokia Siemens Networks
>>   * Copyright (c) 2008 Herbert Xu <herbert@gondor.apana.org.au>
>> + * Copyright (c) 2017 NVIDIA Corporation
>>   *
>>   * Updated RFC4106 AES-GCM testing.
>>   *    Authors: Aidan O'Mahony (aidan.o.mahony@intel.com)
>> @@ -2085,6 +2086,436 @@ static int alg_test_kpp(const struct alg_test_desc
>> *desc, const char *driver, return err;
>>  }
>>
>> +static int do_test_ecdsa_verify(struct crypto_akcipher *tfm,
>> +			      struct akcipher_testvec *vec)
>> +{
>> +	struct akcipher_request *req = NULL;
>> +	u8 *r_str = NULL, *s_str = NULL;
>> +	u8 *m_str = NULL;
>> +	struct scatterlist src_tab[3], dst;
>> +	struct tcrypt_result result;
>> +	unsigned int outbuf_maxlen;
>> +	u8 *outbuf = NULL;
>> +	unsigned int nbytes;
>> +	int err;
>> +
>> +	/* Alloc akcipher request */
>> +	req = akcipher_request_alloc(tfm, GFP_KERNEL);
>> +	if (!req)
>> +		return -ENOMEM;
>> +
>> +	/* Set private key */
>> +	err = crypto_akcipher_set_pub_key(tfm, vec->key, vec->key_len);
>> +	if (err)
>> +		goto error;
>> +
>> +	/*
>> +	 * vec->c always contains k, R and S in that order. All are
>> +	 * of same size and are equal to n i.e. the order of
>> +	 * an elliptic curve.
>> +	 */
>> +	nbytes = vec->c_size / 3;
>> +
>> +	r_str = kzalloc(nbytes, GFP_KERNEL);
>> +	s_str = kzalloc(nbytes, GFP_KERNEL);
>> +	m_str = kzalloc(vec->m_size, GFP_KERNEL);
>> +	if (!r_str || !s_str || !m_str) {
>> +		err = -ENOMEM;
>> +		goto error;
>> +	}
>> +	memcpy(r_str, (u8 *)vec->c + nbytes, nbytes);
>> +	memcpy(s_str, (u8 *)vec->c + 2 * nbytes, nbytes);
>> +	memcpy(m_str, vec->m, vec->m_size);
>> +
>> +	outbuf_maxlen = crypto_akcipher_maxsize(tfm);
>> +	if (outbuf_maxlen < 0) {
>> +		err = outbuf_maxlen;
>> +		goto error;
>> +	}
>> +	outbuf = kzalloc(outbuf_maxlen, GFP_KERNEL);
>> +	if (!outbuf) {
>> +		err = -ENOMEM;
>> +		goto error;
>> +	}
>> +
>> +	/* Set src and dst buffers */
>> +	sg_init_table(src_tab, 3);
>> +	sg_set_buf(&src_tab[0], m_str, vec->m_size);
>> +	sg_set_buf(&src_tab[1], r_str, nbytes);
>> +	sg_set_buf(&src_tab[2], s_str, nbytes);
>> +	sg_init_one(&dst, outbuf, outbuf_maxlen);
>> +
>> +	akcipher_request_set_crypt(req, src_tab, &dst,
>> +				   vec->m_size + 2 * nbytes, outbuf_maxlen);
>> +
>> +	/* Set up result callback */
>> +	init_completion(&result.completion);
>> +	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>> +				      tcrypt_complete, &result);
>> +
>> +	/* Run ecdsa verify operation on sig (r,s) */
>> +	err = wait_async_op(&result, crypto_akcipher_verify(req));
>> +	if (err) {
>> +		pr_err("alg: ecdsa: verify(rs) test failed. err %d\n", err);
>> +		goto error;
>> +	}
>> +error:
>> +	akcipher_request_free(req);
>> +	kfree(r_str);
>> +	kfree(s_str);
>> +	kfree(m_str);
>> +	kfree(outbuf);
>> +	return err;
>> +}
>> +
>> +static int do_test_ecdsa_invalid_verify(struct crypto_akcipher *tfm,
>> +					struct akcipher_testvec *vec)
>> +{
>> +	struct akcipher_request *req = NULL;
>> +	u8 *r_str = NULL, *s_str = NULL;
>> +	u8 *m_str = NULL;
>> +	struct scatterlist src_tab[3], dst;
>> +	struct tcrypt_result result;
>> +	unsigned int outbuf_maxlen;
>> +	u8 *outbuf = NULL;
>> +	unsigned int nbytes;
>> +	int err;
>> +
>> +	/* Alloc akcipher request */
>> +	req = akcipher_request_alloc(tfm, GFP_KERNEL);
>> +	if (!req)
>> +		return -ENOMEM;
>> +
>> +	/* Set private key */
>> +	err = crypto_akcipher_set_pub_key(tfm, vec->key, vec->key_len);
>> +	if (err)
>> +		goto error;
>> +
>> +	/*
>> +	 * vec->c always contains k, R and S in that order. All are
>> +	 * of same size and are equal to n i.e. the order of
>> +	 * an elliptic curve.
>> +	 */
>> +	nbytes = vec->c_size / 3;
>> +
>> +	r_str = kzalloc(nbytes, GFP_KERNEL);
>> +	s_str = kzalloc(nbytes, GFP_KERNEL);
>> +	m_str = kzalloc(vec->m_size, GFP_KERNEL);
>> +	if (!r_str || !s_str || !m_str) {
>> +		err = -ENOMEM;
>> +		goto error;
>> +	}
>> +	memcpy(r_str, (u8 *)vec->c + 1 * nbytes, nbytes);
>> +	memcpy(s_str, (u8 *)vec->c + 2 * nbytes, nbytes);
>> +	memcpy(m_str, vec->m, vec->m_size);
>> +
>> +	outbuf_maxlen = crypto_akcipher_maxsize(tfm);
>> +	if (outbuf_maxlen < 0) {
>> +		err = outbuf_maxlen;
>> +		goto error;
>> +	}
>> +	outbuf = kzalloc(outbuf_maxlen, GFP_KERNEL);
>> +	if (!outbuf) {
>> +		err = -ENOMEM;
>> +		goto error;
>> +	}
>> +
>> +	/* Set src and dst buffers */
>> +	sg_init_table(src_tab, 3);
>> +	/* Intentionally set m_size to 8 to have invalid hash */
>> +	sg_set_buf(&src_tab[0], m_str, 8);
>> +	sg_set_buf(&src_tab[1], r_str, nbytes);
>> +	sg_set_buf(&src_tab[2], s_str, nbytes);
>> +	sg_init_one(&dst, outbuf, outbuf_maxlen);
>> +
>> +	akcipher_request_set_crypt(req, src_tab, &dst,
>> +				   vec->m_size + 2 * nbytes, outbuf_maxlen);
>> +
>> +	/* Set up result callback */
>> +	init_completion(&result.completion);
>> +	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>> +				      tcrypt_complete, &result);
>> +
>> +	/* Run ecdsa verify operation on sig (r,s) */
>> +	err = wait_async_op(&result, crypto_akcipher_verify(req));
>> +	if (err != -EBADMSG) {
>> +		pr_err("alg: ecdsa: invalid verify test failed. err %d\n", err);
>> +		goto error;
>> +	}
>> +	err = 0;
>> +error:
>> +	akcipher_request_free(req);
>> +	kfree(r_str);
>> +	kfree(s_str);
>> +	kfree(m_str);
>> +	kfree(outbuf);
>> +	return err;
>> +}
>
> There seems to be a lot of code duplication between
> do_test_ecdsa_invalid_verify and do_test_ecdsa_verify -- can this be
> eliminated?

I will reorg the code to reuse test subroutines.

>> +
>> +static int do_test_ecdsa_sign_verify(struct crypto_akcipher *tfm,
>> +				     struct akcipher_testvec *vec)
>> +{
>> +	struct akcipher_request *req = NULL;
>> +	u8 *r_str = NULL, *s_str = NULL;
>> +	u8 *m_str = NULL;
>> +	struct scatterlist src_tab[3];
>> +	struct scatterlist src, dst;
>> +	struct tcrypt_result result;
>> +	unsigned int outbuf_maxlen;
>> +	void *outbuf = NULL;
>> +	unsigned int nbytes;
>> +	int err;
>> +
>> +	/* Alloc akcipher request */
>> +	req = akcipher_request_alloc(tfm, GFP_KERNEL);
>> +	if (!req)
>> +		return -ENOMEM;
>> +
>> +	/* Set private key */
>> +	err = crypto_akcipher_set_priv_key(tfm, vec->key, vec->key_len);
>> +	if (err)
>> +		goto error;
>> +
>> +	/* Set private key */
>> +	err = crypto_akcipher_set_pub_key(tfm, vec->key, vec->key_len);
>> +	if (err)
>> +		goto error;
>> +
>> +	/*
>> +	 * vec->c always contains k, R and S in that order. All are
>> +	 * of same size and are equal to n i.e. the order of
>> +	 * an elliptic curve.
>> +	 */
>> +	nbytes = vec->c_size / 3;
>> +
>> +	m_str = kzalloc(vec->m_size, GFP_KERNEL);
>> +	if (!m_str) {
>> +		err = -ENOMEM;
>> +		goto error;
>> +	}
>> +	memcpy(m_str, vec->m, vec->m_size);
>> +
>> +	outbuf_maxlen = crypto_akcipher_maxsize(tfm);
>> +	if (outbuf_maxlen < 0) {
>> +		err = outbuf_maxlen;
>> +		goto error;
>> +	}
>> +	outbuf = kzalloc(outbuf_maxlen, GFP_KERNEL);
>> +	if (!outbuf) {
>> +		err = -ENOMEM;
>> +		goto error;
>> +	}
>> +
>> +	sg_init_one(&src, m_str, vec->m_size);
>> +	sg_init_one(&dst, outbuf, outbuf_maxlen);
>> +
>> +	akcipher_request_set_crypt(req, &src, &dst,
>> +				   vec->m_size, outbuf_maxlen);
>> +
>> +	/* Set up result callback */
>> +	init_completion(&result.completion);
>> +	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>> +				      tcrypt_complete, &result);
>> +
>> +	/* Run ecdsa sign operation on message digest */
>> +	err = wait_async_op(&result, crypto_akcipher_sign(req));
>> +	if (err) {
>> +		pr_err("alg: ecdsa: sign test failed. err %d\n", err);
>> +		goto error;
>> +	}
>> +
>> +	/* verify that signature (r,s) is valid */
>> +	if (req->dst_len != 2 * nbytes) {
>> +		pr_err("alg: ecdsa: sign test failed. Invalid sig len\n");
>> +		err = -EINVAL;
>> +		goto error;
>> +	}
>> +
>> +	/* output contains r and s */
>> +	r_str = outbuf;
>> +	s_str = (u8 *)outbuf + nbytes;
>> +
>> +	/* Set src and dst buffers */
>> +	sg_init_table(src_tab, 3);
>> +	sg_set_buf(&src_tab[0], m_str, vec->m_size);
>> +	sg_set_buf(&src_tab[1], r_str, nbytes);
>> +	sg_set_buf(&src_tab[2], s_str, nbytes);
>> +	sg_init_one(&dst, outbuf, outbuf_maxlen);
>> +
>> +	akcipher_request_set_crypt(req, src_tab, &dst,
>> +				   vec->m_size + 2 * nbytes, outbuf_maxlen);
>> +
>> +	/* Set up result callback */
>> +	init_completion(&result.completion);
>> +	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>> +				      tcrypt_complete, &result);
>> +
>> +	/* Run ecdsa verify operation on sig (r,s) */
>> +	err = wait_async_op(&result, crypto_akcipher_verify(req));
>> +	if (err) {
>> +		pr_err("alg: ecdsa: verify test failed. err %d\n", err);
>> +		goto error;
>> +	}
>> +error:
>> +	akcipher_request_free(req);
>> +	kfree(m_str);
>> +	kfree(outbuf);
>> +	return err;
>> +}
>> +
>> +static int do_test_ecdsa_sign(struct crypto_akcipher *tfm,
>> +			      struct akcipher_testvec *vec)
>> +{
>> +	struct akcipher_request *req = NULL;
>> +	u8 *r_str = NULL, *s_str = NULL;
>> +	u8 *k_str = NULL, *m_str = NULL;
>> +	struct scatterlist src, dst;
>> +	struct tcrypt_result result;
>> +	unsigned int outbuf_maxlen;
>> +	void *outbuf = NULL;
>> +	unsigned int nbytes;
>> +	int err;
>> +
>> +	/* Alloc akcipher request */
>> +	req = akcipher_request_alloc(tfm, GFP_KERNEL);
>> +	if (!req)
>> +		return -ENOMEM;
>> +
>> +	/* Set private key */
>> +	err = crypto_akcipher_set_priv_key(tfm, vec->key, vec->key_len);
>> +	if (err)
>> +		goto error;
>> +
>> +	/*
>> +	 * vec->c always contains k, R and S in that order. All are
>> +	 * of same size and are equal to n i.e. the order of
>> +	 * an elliptic curve.
>> +	 */
>> +	nbytes = vec->c_size / 3;
>> +
>> +	k_str = kzalloc(nbytes, GFP_KERNEL);
>> +	r_str = kzalloc(nbytes, GFP_KERNEL);
>> +	s_str = kzalloc(nbytes, GFP_KERNEL);
>> +	m_str = kzalloc(vec->m_size, GFP_KERNEL);
>> +	if (!k_str || !r_str || !s_str || !m_str) {
>> +		err = -ENOMEM;
>> +		goto error;
>> +	}
>> +	memcpy(k_str, (u8 *)vec->c + 0 * nbytes, nbytes);
>> +	memcpy(r_str, (u8 *)vec->c + 1 * nbytes, nbytes);
>> +	memcpy(s_str, (u8 *)vec->c + 2 * nbytes, nbytes);
>> +	memcpy(m_str, vec->m, vec->m_size);
>> +
>> +	outbuf_maxlen = crypto_akcipher_maxsize(tfm);
>> +	if (outbuf_maxlen < 0) {
>> +		err = outbuf_maxlen;
>> +		goto error;
>> +	}
>> +	outbuf = kzalloc(outbuf_maxlen, GFP_KERNEL);
>> +	if (!outbuf) {
>> +		err = -ENOMEM;
>> +		goto error;
>> +	}
>> +
>> +	/* Set src and dst buffers */
>> +	sg_init_one(&src, m_str, vec->m_size);
>> +	sg_init_one(&dst, outbuf, outbuf_maxlen);
>> +
>> +	akcipher_request_set_crypt(req, &src, &dst,
>> +				   vec->m_size, outbuf_maxlen);
>> +
>> +	/* Set up result callback */
>> +	init_completion(&result.completion);
>> +	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>> +				      tcrypt_complete, &result);
>> +
>> +	/* Set K in request for signing */
>> +	req->info = k_str;
>> +
>> +	/* Run ecdsa sign operation on message digest */
>> +	err = wait_async_op(&result, crypto_akcipher_sign(req));
>> +	if (err) {
>> +		pr_err("alg: ecdsa: sign(k) test failed. err %d\n", err);
>> +		goto error;
>> +	}
>> +
>> +	/* verify that signature (r,s) is valid */
>> +	if (req->dst_len != 2 * nbytes) {
>> +		pr_err("alg: ecdsa: sign(k) test failed. Invalid sig len\n");
>> +		err = -EINVAL;
>> +		goto error;
>> +	}
>> +
>> +	if (memcmp(r_str, sg_virt(req->dst), nbytes)) {
>> +		pr_err("alg: ecdsa: sign(k) test failed. Invalid sig(r)\n");
>> +		err = -EINVAL;
>> +		goto error;
>> +	}
>> +
>> +	if (memcmp(s_str, (u8 *)sg_virt(req->dst) + nbytes, nbytes)) {
>> +		pr_err("alg: ecdsa: sign(k) test failed. Invalid sig(s)\n");
>> +		err = -EINVAL;
>> +		goto error;
>> +	}
>> +error:
>> +	akcipher_request_free(req);
>> +	kfree(k_str);
>> +	kfree(r_str);
>> +	kfree(s_str);
>> +	kfree(m_str);
>> +	kfree(outbuf);
>> +	return err;
>> +}
>
> Same here -- there seem to be a lot of code duplication -- can this be
> reduced?

Yes. I will update.

>> +
>> +static int test_ecdsa_akcipher(struct crypto_akcipher *tfm, const char
>> *alg, +		       struct akcipher_testvec *vecs, unsigned int tcount)
>> +{
>> +	int i, err = 0;
>> +
>> +	for (i = 0; i < tcount; i++) {
>> +		err = do_test_ecdsa_verify(tfm, &vecs[i]);
>> +		if (!err)
>> +			continue;
>> +
>> +		pr_err("ecdsa: verify failed on vec %d, err=%d\n",
>> +		       i + 1, err);
>
> All of these pr_err logs here and below should be removed as these errors seem
> to be already logged.

Sure. I will remove these error logs.

>
>> +		goto exit;
>> +	}
>> +
>> +	for (i = 0; i < tcount; i++) {
>> +		err = do_test_ecdsa_invalid_verify(tfm, &vecs[i]);
>> +		if (!err)
>> +			continue;
>> +
>> +		pr_err("ecdsa: verify(invl) failed on vec %d, err=%d\n",
>> +		       i + 1, err);
>> +		goto exit;
>> +	}
>> +
>> +	for (i = 0; i < tcount; i++) {
>> +		err = do_test_ecdsa_sign_verify(tfm, &vecs[i]);
>> +		if (!err)
>> +			continue;
>> +
>> +		pr_err("ecdsa: sign/verify failed on vec %d, err=%d\n",
>> +		       i + 1, err);
>> +		goto exit;
>> +	}
>> +
>> +	for (i = 0; i < tcount; i++) {
>> +		err = do_test_ecdsa_sign(tfm, &vecs[i]);
>> +		if (!err)
>> +			continue;
>> +
>> +		pr_err("ecdsa: sign failed on vec %d, err=%d\n",
>> +		       i + 1, err);
>> +		goto exit;
>> +	}
>> + exit:
>> +	pr_info("test_ecdsa: %s\n", err ? "FAILED" : "PASSED");
>
> This log message should go away.

Okay.

>
>> +	return err;
>> +}
>> +
>>  static int test_akcipher_one(struct crypto_akcipher *tfm,
>>  			     struct akcipher_testvec *vecs)
>>  {
>> @@ -2236,9 +2667,17 @@ static int alg_test_akcipher(const struct
>> alg_test_desc *desc, driver, PTR_ERR(tfm));
>>  		return PTR_ERR(tfm);
>>  	}
>> -	if (desc->suite.akcipher.vecs)
>> -		err = test_akcipher(tfm, desc->alg, desc->suite.akcipher.vecs,
>> -				    desc->suite.akcipher.count);
>> +
>> +	if (desc->suite.akcipher.vecs) {
>> +		if (strncmp(desc->alg, "ecdsa", 5) == 0)
>> +			err = test_ecdsa_akcipher(tfm, desc->alg,
>> +						  desc->suite.akcipher.vecs,
>> +						  desc->suite.akcipher.count);
>> +		else
>> +			err = test_akcipher(tfm, desc->alg,
>> +					    desc->suite.akcipher.vecs,
>> +					    desc->suite.akcipher.count);
>> +	}
>>
>>  	crypto_free_akcipher(tfm);
>>  	return err;
>> @@ -2982,6 +3421,13 @@ static int alg_test_null(const struct alg_test_desc
>> *desc, .kpp = __VECS(ecdh_tv_template)
>>  		}
>>  	}, {
>> +		.alg = "ecdsa",
>> +		.test = alg_test_akcipher,
>> +		.fips_allowed = 1,
>> +		.suite = {
>> +			.akcipher = __VECS(ecdsa_tv_template)
>> +		}
>> +	}, {
>
>
>
> Ciao
> Stephan
>

Thanks,
- Nitin
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
