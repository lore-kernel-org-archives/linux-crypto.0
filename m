From: Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
Subject: Re: [RESEND RFC PATCH 1/2] Bluetooth: move ecdh allocation outside of
 ecdh_helper
Date: Mon, 25 Sep 2017 15:02:14 +0200
Message-ID: <F95FB3E8-B1A5-4EB5-ABB5-50C8BD16D51C@holtmann.org>
References: <20170925102356.4427-1-tudor.ambarus@microchip.com>
 <20170925102356.4427-2-tudor.ambarus@microchip.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tudor Ambarus <tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
Return-path: <linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170925102356.4427-2-tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
Sender: linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Tudor,

> This change is a prerequisite for letting the crypto subsystem generate
> the ecc private key for ecdh. Before this change, a new crypto tfm was
> allocated, each time, for both key generation and shared secret
> computation. With this change, we allocate a single tfm for both cases.
> We need to bind the key pair generation with the shared secret
> computation via the same crypto tfm. Once the key is set, we can
> compute the shared secret without referring to the private key.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
> ---
> net/bluetooth/ecdh_helper.c | 32 ++++---------------
> net/bluetooth/ecdh_helper.h |  8 +++--
> net/bluetooth/selftest.c    | 29 ++++++++++++-----
> net/bluetooth/smp.c         | 77 +++++++++++++++++++++++++++++++++++++--------
> 4 files changed, 96 insertions(+), 50 deletions(-)
> 
> diff --git a/net/bluetooth/ecdh_helper.c b/net/bluetooth/ecdh_helper.c
> index c7b1a9a..ac2c708 100644
> --- a/net/bluetooth/ecdh_helper.c
> +++ b/net/bluetooth/ecdh_helper.c
> @@ -23,7 +23,6 @@
> #include "ecdh_helper.h"
> 
> #include <linux/scatterlist.h>
> -#include <crypto/kpp.h>
> #include <crypto/ecdh.h>
> 
> struct ecdh_completion {
> @@ -50,10 +49,9 @@ static inline void swap_digits(u64 *in, u64 *out, unsigned int ndigits)
> 		out[i] = __swab64(in[ndigits - 1 - i]);
> }
> 
> -bool compute_ecdh_secret(const u8 public_key[64], const u8 private_key[32],
> -			 u8 secret[32])
> +bool compute_ecdh_secret(struct crypto_kpp *tfm, const u8 public_key[64],
> +			 const u8 private_key[32], u8 secret[32])
> {
> -	struct crypto_kpp *tfm;
> 	struct kpp_request *req;
> 	struct ecdh p;
> 	struct ecdh_completion result;
> @@ -66,16 +64,9 @@ bool compute_ecdh_secret(const u8 public_key[64], const u8 private_key[32],
> 	if (!tmp)
> 		return false;
> 
> -	tfm = crypto_alloc_kpp("ecdh", CRYPTO_ALG_INTERNAL, 0);
> -	if (IS_ERR(tfm)) {
> -		pr_err("alg: kpp: Failed to load tfm for kpp: %ld\n",
> -		       PTR_ERR(tfm));
> -		goto free_tmp;
> -	}
> -
> 	req = kpp_request_alloc(tfm, GFP_KERNEL);
> 	if (!req)
> -		goto free_kpp;
> +		goto free_tmp;
> 
> 	init_completion(&result.completion);
> 
> @@ -126,16 +117,14 @@ bool compute_ecdh_secret(const u8 public_key[64], const u8 private_key[32],
> 	kzfree(buf);
> free_req:
> 	kpp_request_free(req);
> -free_kpp:
> -	crypto_free_kpp(tfm);
> free_tmp:
> 	kfree(tmp);
> 	return (err == 0);
> }
> 
> -bool generate_ecdh_keys(u8 public_key[64], u8 private_key[32])
> +bool generate_ecdh_keys(struct crypto_kpp *tfm, u8 public_key[64],
> +			u8 private_key[32])
> {
> -	struct crypto_kpp *tfm;
> 	struct kpp_request *req;
> 	struct ecdh p;
> 	struct ecdh_completion result;
> @@ -150,16 +139,9 @@ bool generate_ecdh_keys(u8 public_key[64], u8 private_key[32])
> 	if (!tmp)
> 		return false;
> 
> -	tfm = crypto_alloc_kpp("ecdh", CRYPTO_ALG_INTERNAL, 0);
> -	if (IS_ERR(tfm)) {
> -		pr_err("alg: kpp: Failed to load tfm for kpp: %ld\n",
> -		       PTR_ERR(tfm));
> -		goto free_tmp;
> -	}
> -
> 	req = kpp_request_alloc(tfm, GFP_KERNEL);
> 	if (!req)
> -		goto free_kpp;
> +		goto free_tmp;
> 
> 	init_completion(&result.completion);
> 
> @@ -218,8 +200,6 @@ bool generate_ecdh_keys(u8 public_key[64], u8 private_key[32])
> 	kzfree(buf);
> free_req:
> 	kpp_request_free(req);
> -free_kpp:
> -	crypto_free_kpp(tfm);
> free_tmp:
> 	kfree(tmp);
> 	return (err == 0);
> diff --git a/net/bluetooth/ecdh_helper.h b/net/bluetooth/ecdh_helper.h
> index 7a423fa..5cde37d 100644
> --- a/net/bluetooth/ecdh_helper.h
> +++ b/net/bluetooth/ecdh_helper.h
> @@ -20,8 +20,10 @@
>  * COPYRIGHTS, TRADEMARKS OR OTHER RIGHTS, RELATING TO USE OF THIS
>  * SOFTWARE IS DISCLAIMED.
>  */
> +#include <crypto/kpp.h>
> #include <linux/types.h>
> 
> -bool compute_ecdh_secret(const u8 pub_a[64], const u8 priv_b[32],
> -			 u8 secret[32]);
> -bool generate_ecdh_keys(u8 public_key[64], u8 private_key[32]);
> +bool compute_ecdh_secret(struct crypto_kpp *tfm, const u8 pub_a[64],
> +			 const u8 priv_b[32], u8 secret[32]);
> +bool generate_ecdh_keys(struct crypto_kpp *tfm, u8 public_key[64],
> +			u8 private_key[32]);
> diff --git a/net/bluetooth/selftest.c b/net/bluetooth/selftest.c
> index 34a1227..126bdc5 100644
> --- a/net/bluetooth/selftest.c
> +++ b/net/bluetooth/selftest.c
> @@ -138,9 +138,9 @@ static const u8 dhkey_3[32] __initconst = {
> 	0x7c, 0x1c, 0xf9, 0x49, 0xe6, 0xd7, 0xaa, 0x70,
> };
> 
> -static int __init test_ecdh_sample(const u8 priv_a[32], const u8 priv_b[32],
> -				   const u8 pub_a[64], const u8 pub_b[64],
> -				   const u8 dhkey[32])
> +static int __init test_ecdh_sample(struct crypto_kpp *tfm, const u8 priv_a[32],
> +				   const u8 priv_b[32], const u8 pub_a[64],
> +				   const u8 pub_b[64], const u8 dhkey[32])
> {
> 	u8 *tmp, *dhkey_a, *dhkey_b;
> 	int ret = 0;
> @@ -152,8 +152,8 @@ static int __init test_ecdh_sample(const u8 priv_a[32], const u8 priv_b[32],
> 	dhkey_a = &tmp[0];
> 	dhkey_b = &tmp[32];
> 
> -	compute_ecdh_secret(pub_b, priv_a, dhkey_a);
> -	compute_ecdh_secret(pub_a, priv_b, dhkey_b);
> +	compute_ecdh_secret(tfm, pub_b, priv_a, dhkey_a);
> +	compute_ecdh_secret(tfm, pub_a, priv_b, dhkey_b);
> 
> 	if (memcmp(dhkey_a, dhkey, 32)) {
> 		ret = -EINVAL;
> @@ -185,30 +185,43 @@ static const struct file_operations test_ecdh_fops = {
> 
> static int __init test_ecdh(void)
> {
> +	struct crypto_kpp *tfm;
> 	ktime_t calltime, delta, rettime;
> 	unsigned long long duration;
> 	int err;
> 
> 	calltime = ktime_get();
> 
> -	err = test_ecdh_sample(priv_a_1, priv_b_1, pub_a_1, pub_b_1, dhkey_1);
> +	tfm = crypto_alloc_kpp("ecdh", CRYPTO_ALG_INTERNAL, 0);
> +	if (IS_ERR(tfm)) {
> +		BT_ERR("Unable to create ECDH crypto context");
> +		err = PTR_ERR(tfm);
> +		goto done;
> +	}
> +
> +	err = test_ecdh_sample(tfm, priv_a_1, priv_b_1, pub_a_1, pub_b_1,
> +			       dhkey_1);
> 	if (err) {
> 		BT_ERR("ECDH sample 1 failed");
> 		goto done;
> 	}
> 
> -	err = test_ecdh_sample(priv_a_2, priv_b_2, pub_a_2, pub_b_2, dhkey_2);
> +	err = test_ecdh_sample(tfm, priv_a_2, priv_b_2, pub_a_2, pub_b_2,
> +			       dhkey_2);
> 	if (err) {
> 		BT_ERR("ECDH sample 2 failed");
> 		goto done;
> 	}
> 
> -	err = test_ecdh_sample(priv_a_3, priv_a_3, pub_a_3, pub_a_3, dhkey_3);
> +	err = test_ecdh_sample(tfm, priv_a_3, priv_a_3, pub_a_3, pub_a_3,
> +			       dhkey_3);
> 	if (err) {
> 		BT_ERR("ECDH sample 3 failed");
> 		goto done;
> 	}
> 
> +	crypto_free_kpp(tfm);
> +
> 	rettime = ktime_get();
> 	delta = ktime_sub(rettime, calltime);
> 	duration = (unsigned long long) ktime_to_ns(delta) >> 10;
> diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
> index a0ef897..6532689 100644
> --- a/net/bluetooth/smp.c
> +++ b/net/bluetooth/smp.c
> @@ -26,6 +26,7 @@
> #include <crypto/algapi.h>
> #include <crypto/b128ops.h>
> #include <crypto/hash.h>
> +#include <crypto/kpp.h>
> 
> #include <net/bluetooth/bluetooth.h>
> #include <net/bluetooth/hci_core.h>
> @@ -92,6 +93,7 @@ struct smp_dev {
> 
> 	struct crypto_cipher	*tfm_aes;
> 	struct crypto_shash	*tfm_cmac;
> +	struct crypto_kpp	*tfm_ecdh;
> };
> 
> struct smp_chan {
> @@ -131,6 +133,7 @@ struct smp_chan {
> 
> 	struct crypto_cipher	*tfm_aes;
> 	struct crypto_shash	*tfm_cmac;
> +	struct crypto_kpp	*tfm_ecdh;
> };
> 
> /* These debug key values are defined in the SMP section of the core
> @@ -574,7 +577,8 @@ int smp_generate_oob(struct hci_dev *hdev, u8 hash[16], u8 rand[16])
> 			get_random_bytes(smp->local_sk, 32);
> 
> 			/* Generate local key pair for Secure Connections */
> -			if (!generate_ecdh_keys(smp->local_pk, smp->local_sk))
> +			if (!generate_ecdh_keys(smp->tfm_ecdh, smp->local_pk,
> +						smp->local_sk))
> 				return -EIO;
> 
> 			/* This is unlikely, but we need to check that
> @@ -771,6 +775,7 @@ static void smp_chan_destroy(struct l2cap_conn *conn)
> 
> 	crypto_free_cipher(smp->tfm_aes);
> 	crypto_free_shash(smp->tfm_cmac);
> +	crypto_free_kpp(smp->tfm_ecdh);
> 
> 	/* Ensure that we don't leave any debug key around if debug key
> 	 * support hasn't been explicitly enabled.
> @@ -1391,16 +1396,19 @@ static struct smp_chan *smp_chan_create(struct l2cap_conn *conn)
> 	smp->tfm_aes = crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);
> 	if (IS_ERR(smp->tfm_aes)) {
> 		BT_ERR("Unable to create AES crypto context");
> -		kzfree(smp);
> -		return NULL;
> +		goto zfree_smp;
> 	}
> 
> 	smp->tfm_cmac = crypto_alloc_shash("cmac(aes)", 0, 0);
> 	if (IS_ERR(smp->tfm_cmac)) {
> 		BT_ERR("Unable to create CMAC crypto context");
> -		crypto_free_cipher(smp->tfm_aes);
> -		kzfree(smp);
> -		return NULL;
> +		goto free_cipher;
> +	}
> +
> +	smp->tfm_ecdh = crypto_alloc_kpp("ecdh", CRYPTO_ALG_INTERNAL, 0);
> +	if (IS_ERR(smp->tfm_ecdh)) {
> +		BT_ERR("Unable to create ECDH crypto context");
> +		goto free_shash;
> 	}
> 
> 	smp->conn = conn;
> @@ -1413,6 +1421,14 @@ static struct smp_chan *smp_chan_create(struct l2cap_conn *conn)
> 	hci_conn_hold(conn->hcon);
> 
> 	return smp;
> +
> +free_shash:
> +	crypto_free_shash(smp->tfm_cmac);
> +free_cipher:
> +	crypto_free_cipher(smp->tfm_aes);
> +zfree_smp:
> +	kzfree(smp);
> +	return NULL;
> }
> 
> static int sc_mackey_and_ltk(struct smp_chan *smp, u8 mackey[16], u8 ltk[16])
> @@ -1903,7 +1919,8 @@ static u8 sc_send_public_key(struct smp_chan *smp)
> 			get_random_bytes(smp->local_sk, 32);
> 
> 			/* Generate local key pair for Secure Connections */
> -			if (!generate_ecdh_keys(smp->local_pk, smp->local_sk))
> +			if (!generate_ecdh_keys(smp->tfm_ecdh, smp->local_pk,
> +						smp->local_sk))
> 				return SMP_UNSPECIFIED;
> 
> 			/* This is unlikely, but we need to check that
> @@ -2645,6 +2662,7 @@ static int smp_cmd_public_key(struct l2cap_conn *conn, struct sk_buff *skb)
> 	struct l2cap_chan *chan = conn->smp;
> 	struct smp_chan *smp = chan->data;
> 	struct hci_dev *hdev = hcon->hdev;
> +	struct crypto_kpp *tfm;
> 	struct smp_cmd_pairing_confirm cfm;
> 	int err;
> 
> @@ -2677,7 +2695,16 @@ static int smp_cmd_public_key(struct l2cap_conn *conn, struct sk_buff *skb)
> 	SMP_DBG("Remote Public Key X: %32phN", smp->remote_pk);
> 	SMP_DBG("Remote Public Key Y: %32phN", smp->remote_pk + 32);
> 
> -	if (!compute_ecdh_secret(smp->remote_pk, smp->local_sk, smp->dhkey))
> +	if (test_bit(SMP_FLAG_LOCAL_OOB, &smp->flags)) {
> +		struct smp_dev *smp_dev = chan->data;
> +
> +		tfm = smp_dev->tfm_ecdh;
> +	} else {
> +		tfm = smp->tfm_ecdh;
> +	}

this looks all good, but I do not understand the need of this extra if clause here. Can you explain why OOB case is different or maybe add some comment in the code to make this clear.

Regards

Marcel
