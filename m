From: Atul Gupta <atul.gupta@chelsio.com>
Subject: RE: [crypto 6/8] chtls: TCB and Key program
Date: Thu, 7 Dec 2017 14:21:03 +0000
Message-ID: <MWHPR1201MB02382E04C3603A5B5F531CB897330@MWHPR1201MB0238.namprd12.prod.outlook.com>
References: <1512474029-6775-1-git-send-email-atul.gupta@chelsio.com>
 <2083625.RdNrO0bCEz@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "davejwatson@fb.com" <davejwatson@fb.com>,
        Ganesh GR <ganeshgr@chelsio.com>,
        "Harsh Jain" <Harsh@chelsio.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0097.outbound.protection.outlook.com ([104.47.33.97]:6880
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753058AbdLGOVK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Dec 2017 09:21:10 -0500
In-Reply-To: <2083625.RdNrO0bCEz@tauon.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



-----Original Message-----
From: Stephan Mueller [mailto:smueller@chronox.de]=20
Sent: Tuesday, December 5, 2017 6:37 PM
To: Atul Gupta <atul.gupta@chelsio.com>
Cc: herbert@gondor.apana.org.au; linux-crypto@vger.kernel.org; netdev@vger.=
kernel.org; davem@davemloft.net; davejwatson@fb.com; Ganesh GR <ganeshgr@ch=
elsio.com>; Harsh Jain <Harsh@chelsio.com>
Subject: Re: [crypto 6/8] chtls: TCB and Key program

Am Dienstag, 5. Dezember 2017, 12:40:29 CET schrieb Atul Gupta:

Hi Atul,

> program the tx and rx key on chip.
>=20
> Signed-off-by: Atul Gupta <mailto:atul.gupta@chelsio.com>
> ---
>  drivers/crypto/chelsio/chtls/chtls_hw.c | 394
> ++++++++++++++++++++++++++++++++ 1 file changed, 394 insertions(+)
>  create mode 100644 drivers/crypto/chelsio/chtls/chtls_hw.c
>=20
> diff --git a/drivers/crypto/chelsio/chtls/chtls_hw.c
> b/drivers/crypto/chelsio/chtls/chtls_hw.c new file mode 100644 index=20
> 0000000..5e65aa2
> --- /dev/null
> +++ b/drivers/crypto/chelsio/chtls/chtls_hw.c
> @@ -0,0 +1,394 @@
> +/*
> + * Copyright (c) 2017 Chelsio Communications, Inc.
> + *
> + * This program is free software; you can redistribute it and/or=20
> +modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Written by: Atul Gupta (mailto:atul.gupta@chelsio.com)  */
> +
> +#include <linux/module.h>
> +#include <linux/list.h>
> +#include <linux/workqueue.h>
> +#include <linux/skbuff.h>
> +#include <linux/timer.h>
> +#include <linux/notifier.h>
> +#include <linux/inetdevice.h>
> +#include <linux/ip.h>
> +#include <linux/tcp.h>
> +#include <linux/tls.h>
> +#include <net/tls.h>
> +
> +#include "chtls.h"
> +#include "chtls_cm.h"
> +
> +static void __set_tcb_field_direct(struct chtls_sock *csk,
> +				   struct cpl_set_tcb_field *req, u16 word,
> +				   u64 mask, u64 val, u8 cookie, int no_reply) {
> +	struct ulptx_idata *sc;
> +
> +	INIT_TP_WR_CPL(req, CPL_SET_TCB_FIELD, csk->tid);
> +	req->wr.wr_mid |=3D htonl(FW_WR_FLOWID_V(csk->tid));
> +	req->reply_ctrl =3D htons(NO_REPLY_V(no_reply) |
> +				QUEUENO_V(csk->rss_qid));
> +	req->word_cookie =3D htons(TCB_WORD(word) | TCB_COOKIE_V(cookie));
> +	req->mask =3D cpu_to_be64(mask);
> +	req->val =3D cpu_to_be64(val);
> +	sc =3D (struct ulptx_idata *)(req + 1);
> +	sc->cmd_more =3D htonl(ULPTX_CMD_V(ULP_TX_SC_NOOP));
> +	sc->len =3D htonl(0);
> +}
> +
> +void __set_tcb_field(struct sock *sk, struct sk_buff *skb, u16 word,
> +		     u64 mask, u64 val, u8 cookie, int no_reply) {
> +	struct chtls_sock *csk =3D rcu_dereference_sk_user_data(sk);
> +	struct cpl_set_tcb_field *req;
> +	struct ulptx_idata *sc;
> +	unsigned int wrlen =3D roundup(sizeof(*req) + sizeof(*sc), 16);
> +
> +	req =3D (struct cpl_set_tcb_field *)__skb_put(skb, wrlen);
> +	__set_tcb_field_direct(csk, req, word, mask, val, cookie, no_reply);
> +	set_wr_txq(skb, CPL_PRIORITY_CONTROL, csk->port_id); }
> +
> +static int chtls_set_tcb_field(struct sock *sk, u16 word, u64 mask,=20
> +u64
> val) +{
> +	struct chtls_sock *csk =3D rcu_dereference_sk_user_data(sk);
> +	struct sk_buff *skb;
> +	struct cpl_set_tcb_field *req;
> +	struct ulptx_idata *sc;
> +	unsigned int wrlen =3D roundup(sizeof(*req) + sizeof(*sc), 16);
> +	unsigned int credits_needed =3D DIV_ROUND_UP(wrlen, 16);
> +
> +	skb =3D alloc_skb(wrlen, GFP_ATOMIC);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	__set_tcb_field(sk, skb, word, mask, val, 0, 1);
> +	set_queue(skb, (csk->txq_idx << 1) | CPL_PRIORITY_DATA, sk);
> +	csk->wr_credits -=3D credits_needed;
> +	csk->wr_unacked +=3D credits_needed;
> +	enqueue_wr(csk, skb);
> +	cxgb4_ofld_send(csk->egress_dev, skb);
> +	return 0;
> +}
> +
> +/*
> + * Set one of the t_flags bits in the TCB.
> + */
> +int chtls_set_tcb_tflag(struct sock *sk, unsigned int bit_pos, int=20
> +val) {
> +	return chtls_set_tcb_field(sk, 1, 1ULL << bit_pos,
> +			    val << bit_pos);
> +}
> +
> +static int chtls_set_tcb_keyid(struct sock *sk, int keyid) {
> +	return chtls_set_tcb_field(sk, 31, 0xFFFFFFFFULL, keyid); }
> +
> +static int chtls_set_tcb_seqno(struct sock *sk) {
> +	return chtls_set_tcb_field(sk, 28, ~0ULL, 0); }
> +
> +static int chtls_set_tcb_quiesce(struct sock *sk, int val) {
> +	return chtls_set_tcb_field(sk, 1, (1ULL << TF_RX_QUIESCE_S),
> +				   TF_RX_QUIESCE_V(val));
> +}
> +
> +static void *chtls_alloc_mem(unsigned long size) {
> +	void *p =3D kmalloc(size, GFP_KERNEL);
> +
> +	if (!p)
> +		p =3D vmalloc(size);
> +	if (p)
> +		memset(p, 0, size);
> +	return p;
> +}
> +
> +static void chtls_free_mem(void *addr) {
> +	unsigned long p =3D (unsigned long)addr;
> +
> +	if (p >=3D VMALLOC_START && p < VMALLOC_END)
> +		vfree(addr);
> +	else
> +		kfree(addr);
> +}
> +
> +/* TLS Key bitmap processing */
> +int chtls_init_kmap(struct chtls_dev *cdev, struct cxgb4_lld_info=20
> +*lldi) {
> +	unsigned int num_key_ctx, bsize;
> +
> +	num_key_ctx =3D (lldi->vr->key.size / TLS_KEY_CONTEXT_SZ);
> +	bsize =3D BITS_TO_LONGS(num_key_ctx);
> +
> +	cdev->kmap.size =3D num_key_ctx;
> +	cdev->kmap.available =3D bsize;
> +	cdev->kmap.addr =3D chtls_alloc_mem(sizeof(*cdev->kmap.addr) *
> +					  bsize);
> +	if (!cdev->kmap.addr)
> +		return -1;
> +
> +	cdev->kmap.start =3D lldi->vr->key.start;
> +	spin_lock_init(&cdev->kmap.lock);
> +	return 0;
> +}
> +
> +void chtls_free_kmap(struct chtls_dev *cdev) {
> +	if (cdev->kmap.addr)
> +		chtls_free_mem(cdev->kmap.addr);
> +}
> +
> +static int get_new_keyid(struct chtls_sock *csk, u32 optname) {
> +	struct chtls_dev *cdev =3D csk->cdev;
> +	struct chtls_hws *hws =3D &csk->tlshws;
> +	struct net_device *dev =3D csk->egress_dev;
> +	struct adapter *adap =3D netdev2adap(dev);
> +	int keyid;
> +
> +	spin_lock_bh(&cdev->kmap.lock);
> +	keyid =3D find_first_zero_bit(cdev->kmap.addr, cdev->kmap.size);
> +	if (keyid < cdev->kmap.size) {
> +		__set_bit(keyid, cdev->kmap.addr);
> +		if (optname =3D=3D TLS_RX)
> +			hws->rxkey =3D keyid;
> +		else
> +			hws->txkey =3D keyid;
> +		atomic_inc(&adap->chcr_stats.tls_key);
> +	} else {
> +		keyid =3D -1;
> +	}
> +	spin_unlock_bh(&cdev->kmap.lock);
> +	pr_info("keyid:%d\n", keyid);
> +	return keyid;
> +}
> +
> +void free_tls_keyid(struct sock *sk)
> +{
> +	struct chtls_sock *csk =3D rcu_dereference_sk_user_data(sk);
> +	struct chtls_dev *cdev =3D csk->cdev;
> +	struct chtls_hws *hws =3D &csk->tlshws;
> +	struct net_device *dev =3D csk->egress_dev;
> +	struct adapter *adap =3D netdev2adap(dev);
> +
> +	if (!cdev->kmap.addr)
> +		return;
> +
> +	spin_lock_bh(&cdev->kmap.lock);
> +	if (hws->rxkey >=3D 0) {
> +		__clear_bit(hws->rxkey, cdev->kmap.addr);
> +		atomic_dec(&adap->chcr_stats.tls_key);
> +		hws->rxkey =3D -1;
> +	}
> +	if (hws->txkey >=3D 0) {
> +		__clear_bit(hws->txkey, cdev->kmap.addr);
> +		atomic_dec(&adap->chcr_stats.tls_key);
> +		hws->txkey =3D -1;
> +	}
> +	spin_unlock_bh(&cdev->kmap.lock);
> +}
> +
> +static unsigned int keyid_to_addr(int start_addr, int keyid) {
> +	return ((start_addr + (keyid * TLS_KEY_CONTEXT_SZ)) >> 5); }
> +
> +static void chtls_rxkey_ivauth(struct _key_ctx *kctx) {
> +	kctx->iv_to_auth =3D cpu_to_be64(KEYCTX_TX_WR_IV_V(6ULL) |
> +				  KEYCTX_TX_WR_AAD_V(1ULL) |
> +				  KEYCTX_TX_WR_AADST_V(5ULL) |
> +				  KEYCTX_TX_WR_CIPHER_V(14ULL) |
> +				  KEYCTX_TX_WR_CIPHERST_V(0ULL) |
> +				  KEYCTX_TX_WR_AUTH_V(14ULL) |
> +				  KEYCTX_TX_WR_AUTHST_V(16ULL) |
> +				  KEYCTX_TX_WR_AUTHIN_V(16ULL));
> +}
> +
> +static int chtls_key_info(struct chtls_sock *csk,
> +			  struct _key_ctx *kctx,
> +			  void *c_info, u32 keylen, u32 optname) {
> +	struct crypto_cipher *cipher;
> +	struct tls12_crypto_info_aes_gcm_128 *gcm_ctx =3D
> +		(struct tls12_crypto_info_aes_gcm_128 *)
> +		&csk->tlshws.crypto_info;
> +	unsigned char ghash_h[AEAD_H_SIZE];
> +	unsigned char key[CHCR_KEYCTX_CIPHER_KEY_SIZE_256];
> +	int ck_size, key_ctx_size;
> +	int ret;
> +
> +	key_ctx_size =3D sizeof(struct _key_ctx) +
> +		       roundup(keylen, 16) + AEAD_H_SIZE;
> +
> +	if (keylen =3D=3D AES_KEYSIZE_128) {
> +		ck_size =3D CHCR_KEYCTX_CIPHER_KEY_SIZE_128;
> +	} else if (keylen =3D=3D AES_KEYSIZE_192) {
> +		ck_size =3D CHCR_KEYCTX_CIPHER_KEY_SIZE_192;
> +	} else if (keylen =3D=3D AES_KEYSIZE_256) {
> +		ck_size =3D CHCR_KEYCTX_CIPHER_KEY_SIZE_256;
> +	} else {
> +		pr_err("GCM: Invalid key length %d\n", keylen);
> +		return -EINVAL;
> +	}
> +	memcpy(key, gcm_ctx->key, keylen);
> +
> +	/* Calculate the H =3D CIPH(K, 0 repeated 16 times).
> +	 * It will go in key context
> +	 */
> +	cipher =3D crypto_alloc_cipher("aes-generic", 0, 0);

Why not "aes"?
[Atul] AES is also fine, will make the change in v2

> +	if (IS_ERR(cipher)) {
> +		ret =3D -ENOMEM;
> +		goto out;
> +	}
> +
> +	ret =3D crypto_cipher_setkey(cipher, key, keylen);
> +	if (ret)
> +		goto out1;
> +
> +	memset(ghash_h, 0, AEAD_H_SIZE);
> +	crypto_cipher_encrypt_one(cipher, ghash_h, ghash_h);
> +	csk->tlshws.keylen =3D key_ctx_size;
> +
> +	/* Copy the Key context */
> +	if (optname =3D=3D TLS_RX) {
> +		int key_ctx;
> +
> +		key_ctx =3D ((key_ctx_size >> 4) << 3);
> +		kctx->ctx_hdr =3D FILL_KEY_CRX_HDR(ck_size,
> +						 CHCR_KEYCTX_MAC_KEY_SIZE_128,
> +						 0, 0, key_ctx);
> +		chtls_rxkey_ivauth(kctx);
> +	} else {
> +		kctx->ctx_hdr =3D FILL_KEY_CTX_HDR(ck_size,
> +						 CHCR_KEYCTX_MAC_KEY_SIZE_128,
> +						 0, 0, key_ctx_size >> 4);
> +	}
> +
> +	memcpy(kctx->salt, gcm_ctx->salt, TLS_CIPHER_AES_GCM_128_SALT_SIZE);
> +	memcpy(kctx->key, gcm_ctx->key, keylen);
> +	memcpy(kctx->key + keylen, ghash_h, AEAD_H_SIZE);
> +
> +out1:
> +	crypto_free_cipher(cipher);
> +out:
> +	return ret;

memzero_explicit(key)?
[Atul] may not be required as entire info of size keylen and AEAD_H_SIZE is=
 copied onto kctx->key. Key data is received from user, while ghash is mems=
et and locally generated


> +}
> +
> +static void chtls_set_scmd(struct chtls_sock *csk) {
> +	struct chtls_hws *hws =3D &csk->tlshws;
> +
> +	hws->scmd.seqno_numivs =3D
> +		SCMD_SEQ_NO_CTRL_V(3) |
> +		SCMD_PROTO_VERSION_V(0) |
> +		SCMD_ENC_DEC_CTRL_V(0) |
> +		SCMD_CIPH_AUTH_SEQ_CTRL_V(1) |
> +		SCMD_CIPH_MODE_V(2) |
> +		SCMD_AUTH_MODE_V(4) |
> +		SCMD_HMAC_CTRL_V(0) |
> +		SCMD_IV_SIZE_V(4) |
> +		SCMD_NUM_IVS_V(1);
> +
> +	hws->scmd.ivgen_hdrlen =3D
> +		SCMD_IV_GEN_CTRL_V(1) |
> +		SCMD_KEY_CTX_INLINE_V(0) |
> +		SCMD_TLS_FRAG_ENABLE_V(1);
> +}
> +
> +int chtls_setkey(struct chtls_sock *csk, void *c_info,
> +		 u32 keylen, u32 optname)

The current structure of the patch set will break bisect because chtls_setk=
ey is needed in the earlier patch 3. I think this applies to patch 7 as wel=
l.
[Atul] Will take care in v2

> +{
> +	struct sock *sk =3D csk->sk;
> +	struct chtls_dev *cdev =3D csk->cdev;
> +	struct tls_key_req *kwr;
> +	struct _key_ctx *kctx;
> +	struct sk_buff *skb;
> +	int wrlen, klen, len;
> +	int keyid;
> +	int ret =3D 0;
> +
> +	klen =3D roundup((keylen + AEAD_H_SIZE) + sizeof(*kctx), 32);
> +	wrlen =3D roundup(sizeof(*kwr), 16);
> +	len =3D klen + wrlen;
> +
> +	/* Flush out-standing data before new key takes effect */
> +	if (optname =3D=3D TLS_TX) {
> +		lock_sock(sk);
> +		if (skb_queue_len(&csk->txq))
> +			chtls_push_frames(csk, 0);
> +		release_sock(sk);
> +	}
> +
> +	keyid =3D get_new_keyid(csk, optname);
> +	if (keyid < 0)
> +		return -ENOSPC;
> +
> +	skb =3D alloc_skb(len, GFP_KERNEL);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	kwr =3D (struct tls_key_req *)__skb_put_zero(skb, len);
> +	kwr->wr.op_to_compl =3D
> +		cpu_to_be32(FW_WR_OP_V(FW_ULPTX_WR) | FW_WR_COMPL_F |
> +		      FW_WR_ATOMIC_V(1U));
> +	kwr->wr.flowid_len16 =3D
> +		cpu_to_be32(FW_WR_LEN16_V(DIV_ROUND_UP(len, 16) |
> +			    FW_WR_FLOWID_V(csk->tid)));
> +	kwr->wr.protocol =3D 0;
> +	kwr->wr.mfs =3D htons(TLS_MFS);
> +	kwr->wr.reneg_to_write_rx =3D optname;
> +
> +	/* ulptx command */
> +	kwr->req.cmd =3D cpu_to_be32(ULPTX_CMD_V(ULP_TX_MEM_WRITE) |
> +			    T5_ULP_MEMIO_ORDER_V(1) |
> +			    T5_ULP_MEMIO_IMM_V(1));
> +	kwr->req.len16 =3D cpu_to_be32((csk->tid << 8) |
> +			      DIV_ROUND_UP(len - sizeof(kwr->wr), 16));
> +	kwr->req.dlen =3D cpu_to_be32(ULP_MEMIO_DATA_LEN_V(klen >> 5));
> +	kwr->req.lock_addr =3D cpu_to_be32(ULP_MEMIO_ADDR_V(keyid_to_addr
> +					(cdev->kmap.start, keyid)));
> +
> +	/* sub command */
> +	kwr->sc_imm.cmd_more =3D cpu_to_be32(ULPTX_CMD_V(ULP_TX_SC_IMM));
> +	kwr->sc_imm.len =3D cpu_to_be32(klen);
> +
> +	/* key info */
> +	kctx =3D (struct _key_ctx *)(kwr + 1);
> +	ret =3D chtls_key_info(csk, kctx, c_info, keylen, optname);
> +
> +	csk->wr_credits -=3D DIV_ROUND_UP(len, 16);
> +	csk->wr_unacked +=3D DIV_ROUND_UP(len, 16);
> +	enqueue_wr(csk, skb);
> +	cxgb4_ofld_send(csk->egress_dev, skb);
> +
> +	chtls_set_scmd(csk);
> +	/* Clear quiesce for Rx key */
> +	if (optname =3D=3D TLS_RX) {
> +		chtls_set_tcb_keyid(sk, keyid);
> +		chtls_set_tcb_field(sk, 0,
> +				    TCB_ULP_RAW_V(TCB_ULP_RAW_M),
> +				    TCB_ULP_RAW_V((TF_TLS_KEY_SIZE_V(1) |
> +						  TF_TLS_CONTROL_V(1) |
> +						  TF_TLS_ACTIVE_V(1) |
> +						  TF_TLS_ENABLE_V(1))));
> +		chtls_set_tcb_seqno(sk);
> +		chtls_set_tcb_quiesce(sk, 0);
> +		csk->tlshws.rxkey =3D keyid;
> +	} else {
> +		csk->tlshws.tx_seq_no =3D 0;
> +		csk->tlshws.txkey =3D keyid;
> +	}
> +
> +	return ret;

As far as I see, the key is part of the skb (via kctx). This skb is release=
d after being processed. The release calls kfree_skb which does not zeroize=
 the key. Wouldn't it make sense to clear the memory of the key when the sk=
b is released?
[Atul] we should perhaps memset the info received from user so that driver =
has no info on key once its written on chip memory.=20
memset(gcm_ctx->key, 0, keylen);

> +}



Ciao
Stephan
