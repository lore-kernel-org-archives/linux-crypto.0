From: Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
Subject: Re: [v2 PATCH 5/5] Bluetooth: let the crypto subsystem generate the
 ecc privkey
Date: Fri, 29 Sep 2017 13:55:35 +0200
Message-ID: <8FDB3B89-9F12-4AAB-B056-BB09AA10FCAC@holtmann.org>
References: <20170928141455.15336-1-tudor.ambarus@microchip.com>
 <20170928141455.15336-6-tudor.ambarus@microchip.com>
 <5E848FF1-C029-4F16-AE9B-10D71C05E1F0@holtmann.org>
 <bb7544d4-a6e1-47bd-e6ed-04c6c8d4bfd5@microchip.com>
Mime-Version: 1.0 (Mac OS X Mail 11.0 \(3445.1.6\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "bluez mailin list (linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)"
        <linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tudor Ambarus <tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
Return-path: <linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bb7544d4-a6e1-47bd-e6ed-04c6c8d4bfd5-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
Sender: linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Tudor,

>>> That Bluetooth SMP knows about the private key is pointless, since the
>>> detection of debug key usage is actually via the public key portion.
>>> With this patch, the Bluetooth SMP will stop keeping a copy of the
>>> ecdh private key and will let the crypto subsystem to generate and
>>> handle the ecdh private key, potentially benefiting of hardware
>>> ecc private key generation and retention.
>>> 
>>> The loop that tries to generate a correct private key is now removed and
>>> we trust the crypto subsystem to generate a correct private key. This
>>> backup logic should be done in crypto, if really needed.
>>> 
>>> Signed-off-by: Tudor Ambarus <tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
>>> ---
>>> net/bluetooth/ecdh_helper.c | 186 ++++++++++++++++++++++++--------------------
>>> net/bluetooth/ecdh_helper.h |   9 ++-
>>> net/bluetooth/selftest.c    |  14 +++-
>>> net/bluetooth/smp.c         |  66 +++++++---------
>>> 4 files changed, 147 insertions(+), 128 deletions(-)
>>> 
>>> diff --git a/net/bluetooth/ecdh_helper.c b/net/bluetooth/ecdh_helper.c
>>> index 16e022f..2155ce8 100644
>>> --- a/net/bluetooth/ecdh_helper.c
>>> +++ b/net/bluetooth/ecdh_helper.c
>>> @@ -49,15 +49,21 @@ static inline void swap_digits(u64 *in, u64 *out, unsigned int ndigits)
>>> 		out[i] = __swab64(in[ndigits - 1 - i]);
>>> }
>>> 
>>> +/* compute_ecdh_secret() - function assumes that the private key was
>>> + *                         already set.
>>> + * @tfm:          KPP tfm handle allocated with crypto_alloc_kpp().
>>> + * @public_key:   pair's ecc public key.
>>> + * secret:        memory where the ecdh computed shared secret will be saved.
>>> + *
>>> + * Return: zero on success; error code in case of error.
>>> + */
>>> int compute_ecdh_secret(struct crypto_kpp *tfm, const u8 public_key[64],
>>> -			const u8 private_key[32], u8 secret[32])
>>> +			u8 secret[32])
>>> {
>>> 	struct kpp_request *req;
>>> -	struct ecdh p;
>>> +	u8 *tmp;
>>> 	struct ecdh_completion result;
>>> 	struct scatterlist src, dst;
>>> -	u8 *tmp, *buf;
>>> -	unsigned int buf_len;
>>> 	int err;
>>> 
>>> 	tmp = kmalloc(64, GFP_KERNEL);
>>> @@ -72,28 +78,6 @@ int compute_ecdh_secret(struct crypto_kpp *tfm, const u8 public_key[64],
>>> 
>>> 	init_completion(&result.completion);
>>> 
>>> -	/* Security Manager Protocol holds digits in litte-endian order
>>> -	 * while ECC API expect big-endian data
>>> -	 */
>>> -	swap_digits((u64 *)private_key, (u64 *)tmp, 4);
>>> -	p.key = (char *)tmp;
>>> -	p.key_size = 32;
>>> -	/* Set curve_id */
>>> -	p.curve_id = ECC_CURVE_NIST_P256;
>>> -	buf_len = crypto_ecdh_key_len(&p);
>>> -	buf = kmalloc(buf_len, GFP_KERNEL);
>>> -	if (!buf) {
>>> -		err = -ENOMEM;
>>> -		goto free_req;
>>> -	}
>>> -
>>> -	crypto_ecdh_encode_key(buf, buf_len, &p);
>>> -
>>> -	/* Set A private Key */
>>> -	err = crypto_kpp_set_secret(tfm, (void *)buf, buf_len);
>>> -	if (err)
>>> -		goto free_all;
>>> -
>>> 	swap_digits((u64 *)public_key, (u64 *)tmp, 4); /* x */
>>> 	swap_digits((u64 *)&public_key[32], (u64 *)&tmp[32], 4); /* y */
>>> 
>>> @@ -118,26 +102,76 @@ int compute_ecdh_secret(struct crypto_kpp *tfm, const u8 public_key[64],
>>> 	memcpy(secret, tmp, 32);
>>> 
>>> free_all:
>>> -	kzfree(buf);
>>> -free_req:
>>> 	kpp_request_free(req);
>>> free_tmp:
>>> 	kzfree(tmp);
>>> 	return err;
>>> }
>>> 
>>> -int generate_ecdh_keys(struct crypto_kpp *tfm, u8 public_key[64],
>>> -		       u8 private_key[32])
>>> +/* set_ecdh_privkey() - set or generate ecc private key.
>>> + *
>>> + * Function generates an ecc private key in the crypto subsystem when receiving
>>> + * a NULL private key or sets the received key when not NULL.
>>> + *
>>> + * @tfm:           KPP tfm handle allocated with crypto_alloc_kpp().
>>> + * @private_key:   user's ecc private key. When not NULL, the key is expected
>>> + *                 in little endian format.
>>> + *
>>> + * Return: zero on success; error code in case of error.
>>> + */
>>> +int set_ecdh_privkey(struct crypto_kpp *tfm, const u8 private_key[32])
>>> +{
>>> +	u8 *buf, *tmp = NULL;
>>> +	unsigned int buf_len;
>>> +	int err;
>>> +	struct ecdh p = {0};
>>> +
>>> +	p.curve_id = ECC_CURVE_NIST_P256;
>>> +
>>> +	if (private_key) {
>>> +		tmp = kmalloc(32, GFP_KERNEL);
>>> +		if (!tmp)
>>> +			return -ENOMEM;
>>> +		swap_digits((u64 *)private_key, (u64 *)tmp, 4);
>>> +		p.key = tmp;
>>> +		p.key_size = 32;
>>> +	}
>>> +
>>> +	buf_len = crypto_ecdh_key_len(&p);
>>> +	buf = kmalloc(buf_len, GFP_KERNEL);
>>> +	if (!buf) {
>>> +		err = -ENOMEM;
>>> +		goto free_tmp;
>>> +	}
>>> +
>>> +	err = crypto_ecdh_encode_key(buf, buf_len, &p);
>>> +	if (err)
>>> +		goto free_all;
>>> +
>>> +	err = crypto_kpp_set_secret(tfm, buf, buf_len);
>>> +	/* fall through */
>>> +free_all:
>>> +	kzfree(buf);
>>> +free_tmp:
>>> +	kzfree(tmp);
>>> +	return err;
>>> +}
>>> +
>>> +/* generate_ecdh_public_key() - function assumes that the private key was
>>> + *                              already set.
>>> + *
>>> + * @tfm:          KPP tfm handle allocated with crypto_alloc_kpp().
>>> + * @public_key:   memory where the computed ecc public key will be saved.
>>> + *
>>> + * Return: zero on success; error code in case of error.
>>> + */
>>> +int generate_ecdh_public_key(struct crypto_kpp *tfm, u8 public_key[64])
>>> {
>>> 	struct kpp_request *req;
>>> -	struct ecdh p;
>>> +	u8 *tmp;
>>> 	struct ecdh_completion result;
>>> 	struct scatterlist dst;
>>> -	u8 *tmp, *buf;
>>> -	unsigned int buf_len;
>>> 	int err;
>>> -	const unsigned short max_tries = 16;
>>> -	unsigned short tries = 0;
>>> 
>>> 	tmp = kmalloc(64, GFP_KERNEL);
>>> 	if (!tmp)
>>> @@ -150,63 +184,47 @@ int generate_ecdh_keys(struct crypto_kpp *tfm, u8 public_key[64],
>>> 	}
>>> 
>>> 	init_completion(&result.completion);
>>> +	sg_init_one(&dst, tmp, 64);
>>> +	kpp_request_set_input(req, NULL, 0);
>>> +	kpp_request_set_output(req, &dst, 64);
>>> +	kpp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>>> +				 ecdh_complete, &result);
>>> 
>>> -	/* Set curve_id */
>>> -	p.curve_id = ECC_CURVE_NIST_P256;
>>> -	p.key_size = 32;
>>> -	buf_len = crypto_ecdh_key_len(&p);
>>> -	buf = kmalloc(buf_len, GFP_KERNEL);
>>> -	if (!buf)
>>> -		goto free_req;
>>> -
>>> -	do {
>>> -		if (tries++ >= max_tries)
>>> -			goto free_all;
>>> -
>>> -		/* Set private Key */
>>> -		p.key = (char *)private_key;
>>> -		crypto_ecdh_encode_key(buf, buf_len, &p);
>>> -		err = crypto_kpp_set_secret(tfm, buf, buf_len);
>>> -		if (err)
>>> -			goto free_all;
>>> -
>>> -		sg_init_one(&dst, tmp, 64);
>>> -		kpp_request_set_input(req, NULL, 0);
>>> -		kpp_request_set_output(req, &dst, 64);
>>> -		kpp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>>> -					 ecdh_complete, &result);
>>> -
>>> -		err = crypto_kpp_generate_public_key(req);
>>> -
>>> -		if (err == -EINPROGRESS) {
>>> -			wait_for_completion(&result.completion);
>>> -			err = result.err;
>>> -		}
>>> -
>>> -		/* Private key is not valid. Regenerate */
>>> -		if (err == -EINVAL)
>>> -			continue;
>>> -
>>> -		if (err < 0)
>>> -			goto free_all;
>>> -		else
>>> -			break;
>>> -
>>> -	} while (true);
>>> -
>>> -	/* Keys are handed back in little endian as expected by Security
>>> -	 * Manager Protocol
>>> +	err = crypto_kpp_generate_public_key(req);
>>> +	if (err == -EINPROGRESS) {
>>> +		wait_for_completion(&result.completion);
>>> +		err = result.err;
>>> +	}
>>> +	if (err < 0)
>>> +		goto free_all;
>>> +
>>> +	/* The public key is handed back in little endian as expected by
>>> +	 * the Security Manager Protocol.
>>> 	 */
>>> 	swap_digits((u64 *)tmp, (u64 *)public_key, 4); /* x */
>>> 	swap_digits((u64 *)&tmp[32], (u64 *)&public_key[32], 4); /* y */
>>> -	swap_digits((u64 *)private_key, (u64 *)tmp, 4);
>>> -	memcpy(private_key, tmp, 32);
>>> 
>>> free_all:
>>> -	kzfree(buf);
>>> -free_req:
>>> 	kpp_request_free(req);
>>> free_tmp:
>>> 	kfree(tmp);
>>> 	return err;
>>> }
>>> +
>>> +/* generate_ecdh_keys() - generate ecc key pair.
>>> + *
>>> + * @tfm:          KPP tfm handle allocated with crypto_alloc_kpp().
>>> + * @public_key:   memory where the computed ecc public key will be saved.
>>> + *
>>> + * Return: zero on success; error code in case of error.
>>> + */
>>> +int generate_ecdh_keys(struct crypto_kpp *tfm, u8 public_key[64])
>>> +{
>>> +	int err;
>>> +
>>> +	err = set_ecdh_privkey(tfm, NULL);
>>> +	if (err)
>>> +		return err;
>>> +
>>> +	return generate_ecdh_public_key(tfm, public_key);
>>> +}
>>> diff --git a/net/bluetooth/ecdh_helper.h b/net/bluetooth/ecdh_helper.h
>>> index 50e6676..a6f8d03 100644
>>> --- a/net/bluetooth/ecdh_helper.h
>>> +++ b/net/bluetooth/ecdh_helper.h
>>> @@ -23,7 +23,8 @@
>>> #include <crypto/kpp.h>
>>> #include <linux/types.h>
>>> 
>>> -int compute_ecdh_secret(struct crypto_kpp *tfm, const u8 pub_a[64],
>>> -			const u8 priv_b[32], u8 secret[32]);
>>> -int generate_ecdh_keys(struct crypto_kpp *tfm, u8 public_key[64],
>>> -		       u8 private_key[32]);
>>> +int compute_ecdh_secret(struct crypto_kpp *tfm, const u8 pair_public_key[64],
>>> +			u8 secret[32]);
>>> +int set_ecdh_privkey(struct crypto_kpp *tfm, const u8 *private_key);
>>> +int generate_ecdh_public_key(struct crypto_kpp *tfm, u8 public_key[64]);
>>> +int generate_ecdh_keys(struct crypto_kpp *tfm, u8 public_key[64]);
>>> diff --git a/net/bluetooth/selftest.c b/net/bluetooth/selftest.c
>>> index ce99648..2d1519d 100644
>>> --- a/net/bluetooth/selftest.c
>>> +++ b/net/bluetooth/selftest.c
>>> @@ -152,11 +152,11 @@ static int __init test_ecdh_sample(struct crypto_kpp *tfm, const u8 priv_a[32],
>>> 	dhkey_a = &tmp[0];
>>> 	dhkey_b = &tmp[32];
>>> 
>>> -	ret = compute_ecdh_secret(tfm, pub_b, priv_a, dhkey_a);
>>> +	ret = set_ecdh_privkey(tfm, priv_a);
>>> 	if (ret)
>>> 		goto out;
>>> 
>>> -	ret = compute_ecdh_secret(tfm, pub_a, priv_b, dhkey_b);
>>> +	ret = compute_ecdh_secret(tfm, pub_b, dhkey_a);
>>> 	if (ret)
>>> 		goto out;
>>> 
>>> @@ -165,9 +165,17 @@ static int __init test_ecdh_sample(struct crypto_kpp *tfm, const u8 priv_a[32],
>>> 		goto out;
>>> 	}
>>> 
>>> +	ret = set_ecdh_privkey(tfm, priv_b);
>>> +	if (ret)
>>> +		goto out;
>>> +
>>> +	ret = compute_ecdh_secret(tfm, pub_a, dhkey_b);
>>> +	if (ret)
>>> +		goto out;
>>> +
>>> 	if (memcmp(dhkey_b, dhkey, 32))
>>> 		ret = -EINVAL;
>>> -
>>> +	/* fall through*/
>>> out:
>>> 	kfree(tmp);
>>> 	return ret;
>>> diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
>>> index af7e610..d41449b 100644
>>> --- a/net/bluetooth/smp.c
>>> +++ b/net/bluetooth/smp.c
>>> @@ -84,7 +84,6 @@ enum {
>>> struct smp_dev {
>>> 	/* Secure Connections OOB data */
>>> 	u8			local_pk[64];
>>> -	u8			local_sk[32];
>>> 	u8			local_rand[16];
>>> 	bool			debug_key;
>>> 
>>> @@ -126,7 +125,6 @@ struct smp_chan {
>>> 
>>> 	/* Secure Connections variables */
>>> 	u8			local_pk[64];
>>> -	u8			local_sk[32];
>>> 	u8			remote_pk[64];
>>> 	u8			dhkey[32];
>>> 	u8			mackey[16];
>>> @@ -568,24 +566,22 @@ int smp_generate_oob(struct hci_dev *hdev, u8 hash[16], u8 rand[16])
>>> 
>>> 	if (hci_dev_test_flag(hdev, HCI_USE_DEBUG_KEYS)) {
>>> 		BT_DBG("Using debug keys");
>>> +		err = set_ecdh_privkey(smp->tfm_ecdh, debug_sk);
>>> +		if (err)
>>> +			return err;
>>> 		memcpy(smp->local_pk, debug_pk, 64);
>>> -		memcpy(smp->local_sk, debug_sk, 32);
>>> 		smp->debug_key = true;
>> this all looks good, but I do wonder why not have a helper function here.
>> 	err = generate_ecdh_debug_keys(smp->tfm_ecdh, smp->local_pk);
>> And then have that function defined like this:
>> 	int generate_ecdh_debug_keys(struct crypto_kpp *tfm, u8 public_key[64])
>> 	{
>> 		int err;
>> 		err = set_ecdh_privkey(tfm, debug_sk);
>> 		if (err)
>> 			return err;
>> 		memcpy(public_key, debug_pk, 64);
>> 		return 0;
>> 	}
>> I know this seems duplicate, but I wonder if that reduces the number of functions that have to be public. I prefer having most function static if possible.
> 
> You want set_ecdh_privkey() to be static in ecdh_helper.c?
> test_ecdh_sample() and test_debug_key() don't need to copy the public
> key, so they need set_ecdh_privkey() as public.
> 
> I can make generate_ecdh_debug_keys() static to smp.c, but we will be
> mixing helpers in smp.c and ecdh_helper.c.

would it make sense to just include the code from ecdh_helper.c in smp.c? I think that due to the usage of KPP it has shrunk a lot now. However we can do that in a follow up cleanup series. For now I am going to apply your patches.

Regards

Marcel
