From: Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
Subject: Re: [RESEND RFC PATCH 2/2] Bluetooth: let the crypto subsystem
 generate the ecc privkey
Date: Mon, 25 Sep 2017 15:15:43 +0200
Message-ID: <BCB6F8AF-19AE-4F66-89E9-775545C3FB12@holtmann.org>
References: <20170925102356.4427-1-tudor.ambarus@microchip.com>
 <20170925102356.4427-3-tudor.ambarus@microchip.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tudor Ambarus <tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
Return-path: <linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170925102356.4427-3-tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
Sender: linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Tudor,

> That Bluetooth SMP knows about the private key is pointless, since the
> detection of debug key usage is actually via the public key portion.
> With this patch, the Bluetooth SMP will stop keeping a copy of the
> ecdh private key, except when using debug keys. This way we let the
> crypto subsystem to generate and handle the ecdh private key,
> potentially benefiting of hardware ecc private key generation and
> retention.
> 
> The loop that tries to generate a correct private key is now removed and
> we trust the crypto subsystem to generate a correct private key. This
> backup logic should be done in crypto, if really needed.
> 
> Keeping the private key in the crypto subsystem implies that we can't
> check if we accidentally generated a debug key. As this event is
> unlikely we can live with it when comparing with the benefit of the
> overall change: hardware private key generation and retention.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
> ---
> net/bluetooth/ecdh_helper.c | 102 +++++++++++++++++++++-----------------------
> net/bluetooth/smp.c         |  55 +++++++++---------------
> 2 files changed, 67 insertions(+), 90 deletions(-)
> 
> diff --git a/net/bluetooth/ecdh_helper.c b/net/bluetooth/ecdh_helper.c
> index ac2c708..56e9374 100644
> --- a/net/bluetooth/ecdh_helper.c
> +++ b/net/bluetooth/ecdh_helper.c
> @@ -53,10 +53,10 @@ bool compute_ecdh_secret(struct crypto_kpp *tfm, const u8 public_key[64],
> 			 const u8 private_key[32], u8 secret[32])
> {
> 	struct kpp_request *req;
> -	struct ecdh p;
> +	struct ecdh p = {0};
> 	struct ecdh_completion result;
> 	struct scatterlist src, dst;
> -	u8 *tmp, *buf;
> +	u8 *tmp, *buf = NULL;
> 	unsigned int buf_len;
> 	int err = -ENOMEM;
> 
> @@ -70,25 +70,29 @@ bool compute_ecdh_secret(struct crypto_kpp *tfm, const u8 public_key[64],
> 
> 	init_completion(&result.completion);
> 
> -	/* Security Manager Protocol holds digits in litte-endian order
> -	 * while ECC API expect big-endian data
> -	 */
> -	swap_digits((u64 *)private_key, (u64 *)tmp, 4);
> -	p.key = (char *)tmp;
> -	p.key_size = 32;
> 	/* Set curve_id */
> 	p.curve_id = ECC_CURVE_NIST_P256;
> -	buf_len = crypto_ecdh_key_len(&p);
> -	buf = kmalloc(buf_len, GFP_KERNEL);
> -	if (!buf)
> -		goto free_req;
> 
> -	crypto_ecdh_encode_key(buf, buf_len, &p);
> +	if (private_key) {
> +		/* Security Manager Protocol holds digits in little-endian order
> +		 * while ECC API expect big-endian data.
> +		 */
> +		swap_digits((u64 *)private_key, (u64 *)tmp, 4);
> +		p.key = (char *)tmp;
> +		p.key_size = 32;
> 
> -	/* Set A private Key */
> -	err = crypto_kpp_set_secret(tfm, (void *)buf, buf_len);
> -	if (err)
> -		goto free_all;
> +		buf_len = crypto_ecdh_key_len(&p);
> +		buf = kmalloc(buf_len, GFP_KERNEL);
> +		if (!buf)
> +			goto free_req;
> +
> +		crypto_ecdh_encode_key(buf, buf_len, &p);
> +
> +		/* Set A private Key */
> +		err = crypto_kpp_set_secret(tfm, (void *)buf, buf_len);
> +		if (err)
> +			goto free_all;
> +	}
> 
> 	swap_digits((u64 *)public_key, (u64 *)tmp, 4); /* x */
> 	swap_digits((u64 *)&public_key[32], (u64 *)&tmp[32], 4); /* y */
> @@ -126,14 +130,12 @@ bool generate_ecdh_keys(struct crypto_kpp *tfm, u8 public_key[64],
> 			u8 private_key[32])
> {
> 	struct kpp_request *req;
> -	struct ecdh p;
> +	struct ecdh p = {0};
> 	struct ecdh_completion result;
> 	struct scatterlist dst;
> 	u8 *tmp, *buf;
> 	unsigned int buf_len;
> 	int err = -ENOMEM;
> -	const unsigned short max_tries = 16;
> -	unsigned short tries = 0;
> 
> 	tmp = kmalloc(64, GFP_KERNEL);
> 	if (!tmp)
> @@ -145,56 +147,48 @@ bool generate_ecdh_keys(struct crypto_kpp *tfm, u8 public_key[64],
> 
> 	init_completion(&result.completion);
> 
> +	/* Set private Key */
> +	if (private_key) {
> +		p.key = (char *)private_key;
> +		p.key_size = 32;
> +	}
> +
> 	/* Set curve_id */
> 	p.curve_id = ECC_CURVE_NIST_P256;
> -	p.key_size = 32;
> 	buf_len = crypto_ecdh_key_len(&p);
> 	buf = kmalloc(buf_len, GFP_KERNEL);
> 	if (!buf)
> 		goto free_req;
> 
> -	do {
> -		if (tries++ >= max_tries)
> -			goto free_all;
> -
> -		/* Set private Key */
> -		p.key = (char *)private_key;
> -		crypto_ecdh_encode_key(buf, buf_len, &p);
> -		err = crypto_kpp_set_secret(tfm, buf, buf_len);
> -		if (err)
> -			goto free_all;
> -
> -		sg_init_one(&dst, tmp, 64);
> -		kpp_request_set_input(req, NULL, 0);
> -		kpp_request_set_output(req, &dst, 64);
> -		kpp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> -					 ecdh_complete, &result);
> -
> -		err = crypto_kpp_generate_public_key(req);
> -
> -		if (err == -EINPROGRESS) {
> -			wait_for_completion(&result.completion);
> -			err = result.err;
> -		}
> +	crypto_ecdh_encode_key(buf, buf_len, &p);
> +	err = crypto_kpp_set_secret(tfm, buf, buf_len);
> +	if (err)
> +		goto free_all;
> 
> -		/* Private key is not valid. Regenerate */
> -		if (err == -EINVAL)
> -			continue;
> +	sg_init_one(&dst, tmp, 64);
> +	kpp_request_set_input(req, NULL, 0);
> +	kpp_request_set_output(req, &dst, 64);
> +	kpp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +				 ecdh_complete, &result);
> 
> -		if (err < 0)
> -			goto free_all;
> -		else
> -			break;
> +	err = crypto_kpp_generate_public_key(req);
> 
> -	} while (true);
> +	if (err == -EINPROGRESS) {
> +		wait_for_completion(&result.completion);
> +		err = result.err;
> +	}
> +	if (err < 0)
> +		goto free_all;
> 
> 	/* Keys are handed back in little endian as expected by Security
> 	 * Manager Protocol
> 	 */
> 	swap_digits((u64 *)tmp, (u64 *)public_key, 4); /* x */
> 	swap_digits((u64 *)&tmp[32], (u64 *)&public_key[32], 4); /* y */
> -	swap_digits((u64 *)private_key, (u64 *)tmp, 4);
> -	memcpy(private_key, tmp, 32);
> +	if (private_key) {
> +		swap_digits((u64 *)private_key, (u64 *)tmp, 4);
> +		memcpy(private_key, tmp, 32);
> +	}
> 
> free_all:
> 	kzfree(buf);
> diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
> index 6532689..9a8e826 100644
> --- a/net/bluetooth/smp.c
> +++ b/net/bluetooth/smp.c
> @@ -571,28 +571,16 @@ int smp_generate_oob(struct hci_dev *hdev, u8 hash[16], u8 rand[16])
> 		memcpy(smp->local_pk, debug_pk, 64);
> 		memcpy(smp->local_sk, debug_sk, 32);
> 		smp->debug_key = true;
> +		SMP_DBG("OOB Private Key:  %32phN", smp->local_sk);
> 	} else {
> -		while (true) {
> -			/* Seed private key with random number */
> -			get_random_bytes(smp->local_sk, 32);
> -
> -			/* Generate local key pair for Secure Connections */
> -			if (!generate_ecdh_keys(smp->tfm_ecdh, smp->local_pk,
> -						smp->local_sk))
> -				return -EIO;
> -
> -			/* This is unlikely, but we need to check that
> -			 * we didn't accidentially generate a debug key.
> -			 */
> -			if (crypto_memneq(smp->local_sk, debug_sk, 32))
> -				break;

I would prefer if we do not loose this part. I mean if the crypto hardware accidentally generated the same private key as the private debug key, then we want to just redo it. We opted for comparing the private key instead of the public key because it is shorter, however just comparing the public key against the debug_pk is also just fine.

This is really just some sort of paranoia, but it would be bad if we locally classify the generated long term key as real key and the remote side declares it as debug key.

> -		}
> +		/* Generate local key pair for Secure Connections */
> +		if (!generate_ecdh_keys(smp->tfm_ecdh, smp->local_pk, NULL))
> +			return -EIO;
> 		smp->debug_key = false;
> 	}
> 
> 	SMP_DBG("OOB Public Key X: %32phN", smp->local_pk);
> 	SMP_DBG("OOB Public Key Y: %32phN", smp->local_pk + 32);
> -	SMP_DBG("OOB Private Key:  %32phN", smp->local_sk);
> 
> 	get_random_bytes(smp->local_rand, 16);
> 
> @@ -1899,11 +1887,13 @@ static u8 sc_send_public_key(struct smp_chan *smp)
> 		smp_dev = chan->data;
> 
> 		memcpy(smp->local_pk, smp_dev->local_pk, 64);
> -		memcpy(smp->local_sk, smp_dev->local_sk, 32);
> 		memcpy(smp->lr, smp_dev->local_rand, 16);
> 
> -		if (smp_dev->debug_key)
> +		if (smp_dev->debug_key) {
> 			set_bit(SMP_FLAG_DEBUG_KEY, &smp->flags);
> +			memcpy(smp->local_sk, smp_dev->local_sk, 32);
> +			SMP_DBG("Local Private Key:  %32phN", smp->local_sk);
> +		}

Do we need to keep the smp->local_sk variable at all? I would prefer that this is hidden the KPP. Since even in case of debug key generation (software fallback), we really do not care about it either. The only thing we tell the KPP is that we want it to use debug_sk as its private key and debug_pk as public key. So essentially key generation with fixed a fixed key-pair. I think it would make the Bluetooth SMP code a lot simpler.

> 
> 		goto done;
> 	}
> @@ -1913,28 +1903,16 @@ static u8 sc_send_public_key(struct smp_chan *smp)
> 		memcpy(smp->local_pk, debug_pk, 64);
> 		memcpy(smp->local_sk, debug_sk, 32);
> 		set_bit(SMP_FLAG_DEBUG_KEY, &smp->flags);
> +		SMP_DBG("Local Private Key:  %32phN", smp->local_sk);
> 	} else {
> -		while (true) {
> -			/* Seed private key with random number */
> -			get_random_bytes(smp->local_sk, 32);
> -
> -			/* Generate local key pair for Secure Connections */
> -			if (!generate_ecdh_keys(smp->tfm_ecdh, smp->local_pk,
> -						smp->local_sk))
> -				return SMP_UNSPECIFIED;
> -
> -			/* This is unlikely, but we need to check that
> -			 * we didn't accidentially generate a debug key.
> -			 */
> -			if (crypto_memneq(smp->local_sk, debug_sk, 32))
> -				break;
> -		}
> +		/* Generate local key pair for Secure Connections */
> +		if (!generate_ecdh_keys(smp->tfm_ecdh, smp->local_pk, NULL))
> +			return SMP_UNSPECIFIED;
> 	}
> 
> done:
> 	SMP_DBG("Local Public Key X: %32phN", smp->local_pk);
> 	SMP_DBG("Local Public Key Y: %32phN", smp->local_pk + 32);
> -	SMP_DBG("Local Private Key:  %32phN", smp->local_sk);
> 
> 	smp_send_cmd(smp->conn, SMP_CMD_PUBLIC_KEY, 64, smp->local_pk);
> 
> @@ -2663,6 +2641,7 @@ static int smp_cmd_public_key(struct l2cap_conn *conn, struct sk_buff *skb)
> 	struct smp_chan *smp = chan->data;
> 	struct hci_dev *hdev = hcon->hdev;
> 	struct crypto_kpp *tfm;
> +	const u8 *local_sk;
> 	struct smp_cmd_pairing_confirm cfm;
> 	int err;
> 
> @@ -2703,8 +2682,12 @@ static int smp_cmd_public_key(struct l2cap_conn *conn, struct sk_buff *skb)
> 		tfm = smp->tfm_ecdh;
> 	}
> 
> -	if (!compute_ecdh_secret(tfm, smp->remote_pk, smp->local_sk,
> -				 smp->dhkey))
> +	if (hci_dev_test_flag(hdev, HCI_USE_DEBUG_KEYS))
> +		local_sk = smp->local_sk;
> +	else
> +		local_sk = NULL;
> +
> +	if (!compute_ecdh_secret(tfm, smp->remote_pk, local_sk, smp->dhkey))
> 		return SMP_UNSPECIFIED;

As with my comment above, should we make the practice a lot simpler here to make code less complex. I mean the difference is really in the key generation portion.

	if (debug_key)
		genarate_ecdh_debug_keys(tfm_ecdh, smp->local_pk)
	else
		generate_ecdh_keys(tfm_ecdh, smp->local_pk)

And here the generate_ecdh_debug_keys is really just a dumb tfm_ecdh that we already know the private and public key pair. We do not have to actually generate anything.

However now the secret computation can become simpler.

	compute_ecdh_secret(tfm_ecdh, smp->remote_pk, smp->dhkey)

No matter if it is a debug key or operational key usage, the tfm_ecdh has all the key information. If that private key is in hardware or not, or if hardware can be used or not, that is a KPP detail.

Regards

Marcel
