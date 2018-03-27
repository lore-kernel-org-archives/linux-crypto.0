From: Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [PATCH v13 net-next 07/12] crypto: chtls - Program the TLS
 session Key
Date: Tue, 27 Mar 2018 20:16:17 +0200
Message-ID: <20180327201617.7c573b8d@epycfail>
References: <1522172201-7629-1-git-send-email-atul.gupta@chelsio.com>
        <1522172201-7629-8-git-send-email-atul.gupta@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        davejwatson@fb.com, sd@queasysnail.net,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        werner@chelsio.com, leedom@chelsio.com,
        swise@opengridcomputing.com, indranil@chelsio.com,
        ganeshgr@chelsio.com
To: Atul Gupta <atul.gupta@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1522172201-7629-8-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 27 Mar 2018 23:06:36 +0530
Atul Gupta <atul.gupta@chelsio.com> wrote:

> +static void __set_tcb_field(struct sock *sk, struct sk_buff *skb, u16 word,
> +			    u64 mask, u64 val, u8 cookie, int no_reply)
> +{
> +	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
> +	struct cpl_set_tcb_field *req;
> +	struct ulptx_idata *sc;
> +	unsigned int wrlen = roundup(sizeof(*req) + sizeof(*sc), 16);

Please use reverse christmas tree style for variable declarations. If
needed, do the assignments later on.

> [...]
>
> +static int chtls_set_tcb_field(struct sock *sk, u16 word, u64 mask, u64 val)
> +{
> +	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
> +	struct cpl_set_tcb_field *req;
> +	struct ulptx_idata *sc;
> +	struct sk_buff *skb;
> +	int ret;
> +	unsigned int wrlen = roundup(sizeof(*req) + sizeof(*sc), 16);
> +	unsigned int credits_needed = DIV_ROUND_UP(wrlen, 16);

Same here.

> [...]
>
> +static int get_new_keyid(struct chtls_sock *csk, u32 optname)
> +{
> +	struct chtls_hws *hws = &csk->tlshws;
> +	struct net_device *dev = csk->egress_dev;
> +	struct adapter *adap = netdev2adap(dev);
> +	struct chtls_dev *cdev = csk->cdev;
> +	int keyid;

Same here.

> +
> +	spin_lock_bh(&cdev->kmap.lock);
> +	keyid = find_first_zero_bit(cdev->kmap.addr, cdev->kmap.size);
> +	if (keyid < cdev->kmap.size) {
> +		__set_bit(keyid, cdev->kmap.addr);
> +		if (optname == TLS_RX)
> +			hws->rxkey = keyid;
> +		else
> +			hws->txkey = keyid;
> +		atomic_inc(&adap->chcr_stats.tls_key);
> +	} else {
> +		keyid = -1;
> +	}
> +	spin_unlock_bh(&cdev->kmap.lock);
> +	return keyid;
> +}
> +
> +void free_tls_keyid(struct sock *sk)
> +{
> +	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
> +	struct net_device *dev = csk->egress_dev;
> +	struct adapter *adap = netdev2adap(dev);
> +	struct chtls_dev *cdev = csk->cdev;
> +	struct chtls_hws *hws = &csk->tlshws;

Same here.

> [...]
>
> +static int chtls_key_info(struct chtls_sock *csk,
> +			  struct _key_ctx *kctx,
> +			  u32 keylen, u32 optname)
> +{
> +	unsigned char key[CHCR_KEYCTX_CIPHER_KEY_SIZE_256];
> +	struct crypto_cipher *cipher;
> +	struct tls12_crypto_info_aes_gcm_128 *gcm_ctx =
> +		(struct tls12_crypto_info_aes_gcm_128 *)
> +		&csk->tlshws.crypto_info;
> +	unsigned char ghash_h[AEAD_H_SIZE];
> +	int ck_size, key_ctx_size;
> +	int ret;

Same here.

> [...]
>
> +int chtls_setkey(struct chtls_sock *csk, u32 keylen, u32 optname)
> +{
> +	struct chtls_dev *cdev = csk->cdev;
> +	struct sock *sk = csk->sk;
> +	struct tls_key_req *kwr;
> +	struct _key_ctx *kctx;
> +	struct sk_buff *skb;
> +	int wrlen, klen, len;
> +	int keyid;
> +	int kaddr;
> +	int ret = 0;

Same here.

> [...]

-- 
Stefano
