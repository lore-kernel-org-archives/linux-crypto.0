Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77789C636C9
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 16:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5715E61159
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 16:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbhGQQwR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Jul 2021 12:52:17 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:19475 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbhGQQwQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Jul 2021 12:52:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1626540557;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=yog90uBfWrhBRB3frpUh461zInEfL1UtKskay6WgV94=;
    b=gmXye0LVI+WxyoPhmYmGcXuLiQpICCDrYPvSl7LXqvklOIkHukQjt0S19iPQP45Zba
    zovHUZU5RxvsXCWQQ58LWgm4DXmPlCIfZlKbvjGNWzxGFgh56oStxxlI/HzXLAEacGNi
    vEnoMjsMpKTs4TxfQnu4SpmuWSdcy6eTrYqXeeIVWgzhGB4z0mfkqmCBFrrgIjOV1OMg
    MvzJSrngwL4kdSxs1ctvW0ChuZLEom+tzT5ufStjFqrfjbjoR/nGney0eE8rY2Z3JAKK
    IeCPvmKwJjCGfKVhPoYXy6nM32Ssw6qjRM0S1PG4WtoEDFS5u/0rfjX+WNgUr6RgQVc1
    uh3g==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIvSZEqc="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.28.1 DYNA|AUTH)
    with ESMTPSA id 9043bbx6HGnFCK2
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sat, 17 Jul 2021 18:49:15 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/11] nvmet-auth: implement support for augmented challenge
Date:   Sat, 17 Jul 2021 18:49:15 +0200
Message-ID: <2653184.5eqXJjyf2G@positron.chronox.de>
In-Reply-To: <20210716110428.9727-11-hare@suse.de>
References: <20210716110428.9727-1-hare@suse.de> <20210716110428.9727-11-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 16. Juli 2021, 13:04:27 CEST schrieb Hannes Reinecke:

Hi Hannes,

> Implement support for augmented challenge with FFDHE groups.
> This patch adds a new configfs attribute 'dhchap_dhgroup' to
> select the DH group to use.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/nvme/target/auth.c             | 241 ++++++++++++++++++++++++-
>  drivers/nvme/target/configfs.c         |  31 ++++
>  drivers/nvme/target/fabrics-cmd-auth.c |  14 +-
>  3 files changed, 281 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
> index 00c7d051dfb1..cc7f12a7c8bf 100644
> --- a/drivers/nvme/target/auth.c
> +++ b/drivers/nvme/target/auth.c
> @@ -58,11 +58,56 @@ int nvmet_auth_set_host_key(struct nvmet_host *host,
> const char *secret)
> 
>  int nvmet_setup_dhgroup(struct nvmet_ctrl *ctrl, int dhgroup_id)
>  {
> +	struct nvmet_host_link *p;
> +	struct nvmet_host *host = NULL;
> +	const char *dhgroup_kpp;
>  	int ret = -ENOTSUPP;
> 
>  	if (dhgroup_id == NVME_AUTH_DHCHAP_DHGROUP_NULL)
>  		return 0;
> 
> +	down_read(&nvmet_config_sem);
> +	if (ctrl->subsys->type == NVME_NQN_DISC)
> +		goto out_unlock;
> +
> +	list_for_each_entry(p, &ctrl->subsys->hosts, entry) {
> +		if (strcmp(nvmet_host_name(p->host), ctrl->hostnqn))
> +			continue;
> +		host = p->host;
> +		break;
> +	}
> +	if (!host) {
> +		pr_debug("host %s not found\n", ctrl->hostnqn);
> +		ret = -ENXIO;
> +		goto out_unlock;
> +	}
> +
> +	if (host->dhchap_dhgroup_id != dhgroup_id) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +	dhgroup_kpp = nvme_auth_dhgroup_kpp(dhgroup_id);
> +	if (!dhgroup_kpp) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +	ctrl->dh_tfm = crypto_alloc_kpp(dhgroup_kpp, 0, 0);
> +	if (IS_ERR(ctrl->dh_tfm)) {
> +		pr_debug("failed to setup DH group %d, err %ld\n",
> +			 dhgroup_id, PTR_ERR(ctrl->dh_tfm));
> +		ret = PTR_ERR(ctrl->dh_tfm);
> +		ctrl->dh_tfm = NULL;
> +	} else {
> +		ctrl->dh_gid = dhgroup_id;
> +		ctrl->dh_keysize = nvme_auth_dhgroup_pubkey_size(dhgroup_id);
> +		pr_debug("select DH group %d keysize %d\n",
> +			 ctrl->dh_gid, ctrl->dh_keysize);
> +		ret = 0;
> +	}
> +
> +out_unlock:
> +	up_read(&nvmet_config_sem);
> +
>  	return ret;
>  }
> 
> @@ -192,6 +237,101 @@ bool nvmet_check_auth_status(struct nvmet_req *req)
>  	return true;
>  }
> 
> +static int nvmet_auth_hash_sesskey(struct nvmet_req *req, u8 *hashed_key)
> +{
> +	struct nvmet_ctrl *ctrl = req->sq->ctrl;
> +	const char *hmac_name, *digest_name;
> +	struct crypto_shash *tfm;
> +	int hmac_id, ret;
> +
> +	if (!ctrl->shash_tfm) {
> +		pr_debug("%s: hash alg not set\n", __func__);
> +		return -EINVAL;
> +	}
> +	hmac_name = crypto_shash_alg_name(ctrl->shash_tfm);
> +	hmac_id = nvme_auth_hmac_id(hmac_name);
> +	if (hmac_id < 0) {
> +		pr_debug("%s: unsupported hmac %s\n", __func__,
> +			 hmac_name);
> +		return -EINVAL;
> +	}
> +	digest_name = nvme_auth_digest_name(hmac_id);
> +	if (!digest_name) {
> +		pr_debug("%s: failed to get digest for %s\n", __func__,
> +			 hmac_name);
> +		return -EINVAL;
> +	}
> +	tfm = crypto_alloc_shash(digest_name, 0, 0);
> +	if (IS_ERR(tfm))
> +		return -ENOMEM;
> +
> +	ret = crypto_shash_tfm_digest(tfm, req->sq->dhchap_skey,
> +				      req->sq->dhchap_skey_len, hashed_key);
> +	if (ret < 0)
> +		pr_debug("%s: Failed to hash digest len %d\n", __func__,
> +			 req->sq->dhchap_skey_len);
> +
> +	crypto_free_shash(tfm);
> +	return ret;
> +}
> +
> +static int nvmet_auth_augmented_challenge(struct nvmet_req *req,
> +					  u8 *challenge, u8 *aug)
> +{
> +	struct nvmet_ctrl *ctrl = req->sq->ctrl;
> +	struct crypto_shash *tfm;
> +	struct shash_desc *desc;
> +	u8 *hashed_key;
> +	const char *hash_name;
> +	int hash_len = req->sq->dhchap_hash_len;
> +	int ret;
> +
> +	hashed_key = kmalloc(hash_len, GFP_KERNEL);
> +	if (!hashed_key)
> +		return -ENOMEM;
> +
> +	ret = nvmet_auth_hash_sesskey(req, hashed_key);
> +	if (ret < 0) {
> +		pr_debug("failed to hash session key, err %d\n", ret);
> +		kfree(hashed_key);
> +		return ret;
> +	}
> +	hash_name = crypto_shash_alg_name(ctrl->shash_tfm);
> +	if (!hash_name) {
> +		pr_debug("Invalid hash algoritm\n");
> +		return -EINVAL;
> +	}
> +	tfm = crypto_alloc_shash(hash_name, 0, 0);
> +	if (IS_ERR(tfm)) {
> +		ret = PTR_ERR(tfm);
> +		goto out_free_key;
> +	}
> +	desc = kmalloc(sizeof(struct shash_desc) + crypto_shash_descsize(tfm),
> +		       GFP_KERNEL);
> +	if (!desc) {
> +		ret = -ENOMEM;
> +		goto out_free_hash;
> +	}
> +	desc->tfm = tfm;
> +
> +	ret = crypto_shash_setkey(tfm, hashed_key, hash_len);
> +	if (ret)
> +		goto out_free_desc;
> +	ret = crypto_shash_init(desc);
> +	if (ret)
> +		goto out_free_desc;
> +	crypto_shash_update(desc, challenge, hash_len);
> +	crypto_shash_final(desc, aug);
> +
> +out_free_desc:
> +	kfree_sensitive(desc);
> +out_free_hash:
> +	crypto_free_shash(tfm);
> +out_free_key:
> +	kfree(hashed_key);
> +	return ret;
> +}
> +
>  int nvmet_auth_host_hash(struct nvmet_req *req, u8 *response,
>  			 unsigned int shash_len)
>  {
> @@ -202,8 +342,15 @@ int nvmet_auth_host_hash(struct nvmet_req *req, u8
> *response, int ret;
> 
>  	if (ctrl->dh_gid != NVME_AUTH_DHCHAP_DHGROUP_NULL) {
> -		ret = -ENOTSUPP;
> -		goto out;
> +		challenge = kmalloc(shash_len, GFP_KERNEL);

Alignment?

> +		if (!challenge) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +		ret = nvmet_auth_augmented_challenge(req, req->sq->dhchap_c1,
> +						     challenge);
> +		if (ret)
> +			goto out;
>  	}
> 
>  	shash->tfm = ctrl->shash_tfm;
> @@ -264,8 +411,15 @@ int nvmet_auth_ctrl_hash(struct nvmet_req *req, u8
> *response, ctrl->cntlid, ctrl->hostnqn);
> 
>  	if (ctrl->dh_gid != NVME_AUTH_DHCHAP_DHGROUP_NULL) {
> -		ret = -ENOTSUPP;
> -		goto out;
> +		challenge = kmalloc(shash_len, GFP_KERNEL);

dto.
> +		if (!challenge) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +		ret = nvmet_auth_augmented_challenge(req, req->sq->dhchap_c2,
> +						     challenge);
> +		if (ret)
> +			goto out;
>  	}
> 
>  	shash->tfm = ctrl->shash_tfm;
> @@ -307,6 +461,85 @@ int nvmet_auth_ctrl_hash(struct nvmet_req *req, u8
> *response, return 0;
>  }
> 
> +int nvmet_auth_ctrl_exponential(struct nvmet_req *req,
> +				u8 *buf, int buf_size)
> +{
> +	struct nvmet_ctrl *ctrl = req->sq->ctrl;
> +	struct kpp_request *kpp_req;
> +	struct crypto_wait wait;
> +	char *pkey;
> +	struct scatterlist dst;
> +	int ret, pkey_len;
> +
> +	if (ctrl->dh_gid == NVME_AUTH_DHCHAP_DHGROUP_2048 ||
> +	    ctrl->dh_gid == NVME_AUTH_DHCHAP_DHGROUP_3072 ||
> +	    ctrl->dh_gid == NVME_AUTH_DHCHAP_DHGROUP_4096 ||
> +	    ctrl->dh_gid == NVME_AUTH_DHCHAP_DHGROUP_6144 ||
> +	    ctrl->dh_gid == NVME_AUTH_DHCHAP_DHGROUP_8192) {
> +		struct dh p = {0};
> +		int bits = nvme_auth_dhgroup_pubkey_size(ctrl->dh_gid) << 3;
> +
> +		ret = crypto_ffdhe_params(&p, bits);
> +		if (ret)
> +			return ret;
> +
> +		p.key = ctrl->dhchap_key;
> +		p.key_size = ctrl->dhchap_key_len;
> +
> +		pkey_len = crypto_dh_key_len(&p);
> +		pkey = kmalloc(pkey_len, GFP_KERNEL);
> +		if (!pkey)
> +			return -ENOMEM;
> +
> +		get_random_bytes(pkey, pkey_len);
> +		ret = crypto_dh_encode_key(pkey, pkey_len, &p);
> +		if (ret) {
> +			pr_debug("failed to encode private key, error %d\n",
> +				 ret);
> +			goto out;
> +		}
> +	} else {
> +		pr_warn("invalid dh group %d\n", ctrl->dh_gid);
> +		return -EINVAL;
> +	}
> +	ret = crypto_kpp_set_secret(ctrl->dh_tfm, pkey, pkey_len);
> +	if (ret) {
> +		pr_debug("failed to set private key, error %d\n", ret);
> +		goto out;
> +	}
> +
> +	kpp_req = kpp_request_alloc(ctrl->dh_tfm, GFP_KERNEL);
> +	if (!kpp_req) {
> +		pr_debug("cannot allocate kpp request\n");
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	crypto_init_wait(&wait);
> +	kpp_request_set_input(kpp_req, NULL, 0);
> +	sg_init_one(&dst, buf, buf_size);
> +	kpp_request_set_output(kpp_req, &dst, buf_size);
> +	kpp_request_set_callback(kpp_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +				 crypto_req_done, &wait);
> +
> +	ret = crypto_wait_req(crypto_kpp_generate_public_key(kpp_req), &wait);
> +	kpp_request_free(kpp_req);
> +	if (ret == -EOVERFLOW) {
> +		pr_debug("public key buffer too small, need %d is %d\n",
> +			 crypto_kpp_maxsize(ctrl->dh_tfm), buf_size);
> +		ret = -ENOKEY;
> +	} else if (ret) {
> +		pr_debug("failed to generate public key, err %d\n", ret);
> +		ret = -ENOKEY;
> +	} else
> +		pr_debug("%s: ctrl public key %*ph\n", __func__,
> +			 (int)buf_size, buf);
> +
> +out:
> +	kfree_sensitive(pkey);
> +	return ret;
> +}

In general: the target/host authentication code looks very similar. Is there 
no way to have a common code base?
> +
>  int nvmet_auth_ctrl_sesskey(struct nvmet_req *req,
>  			    u8 *pkey, int pkey_size)
>  {
> diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
> index e0760911a761..e9b8884a83b0 100644
> --- a/drivers/nvme/target/configfs.c
> +++ b/drivers/nvme/target/configfs.c
> @@ -1712,9 +1712,40 @@ static ssize_t nvmet_host_dhchap_hash_store(struct
> config_item *item,
> 
>  CONFIGFS_ATTR(nvmet_host_, dhchap_hash);
> 
> +static ssize_t nvmet_host_dhchap_dhgroup_show(struct config_item *item,
> +		char *page)
> +{
> +	struct nvmet_host *host = to_host(item);
> +	const char *dhgroup = nvme_auth_dhgroup_name(host->dhchap_dhgroup_id);
> +
> +	return sprintf(page, "%s\n", dhgroup ? dhgroup : "none");
> +}
> +
> +static ssize_t nvmet_host_dhchap_dhgroup_store(struct config_item *item,
> +		const char *page, size_t count)
> +{
> +	struct nvmet_host *host = to_host(item);
> +	int dhgroup_id;
> +
> +	dhgroup_id = nvme_auth_dhgroup_id(page);
> +	if (dhgroup_id < 0)
> +		return -EINVAL;
> +	if (dhgroup_id != NVME_AUTH_DHCHAP_DHGROUP_NULL) {
> +		const char *kpp = nvme_auth_dhgroup_kpp(dhgroup_id);
> +
> +		if (!crypto_has_kpp(kpp, 0, 0))
> +			return -EINVAL;
> +	}
> +	host->dhchap_dhgroup_id = dhgroup_id;
> +	return count;
> +}
> +
> +CONFIGFS_ATTR(nvmet_host_, dhchap_dhgroup);
> +
>  static struct configfs_attribute *nvmet_host_attrs[] = {
>  	&nvmet_host_attr_dhchap_key,
>  	&nvmet_host_attr_dhchap_hash,
> +	&nvmet_host_attr_dhchap_dhgroup,
>  	NULL,
>  };
>  #endif /* CONFIG_NVME_TARGET_AUTH */
> diff --git a/drivers/nvme/target/fabrics-cmd-auth.c
> b/drivers/nvme/target/fabrics-cmd-auth.c index 962f9f5e9d89..478ac351c645
> 100644
> --- a/drivers/nvme/target/fabrics-cmd-auth.c
> +++ b/drivers/nvme/target/fabrics-cmd-auth.c
> @@ -98,7 +98,11 @@ static u16 nvmet_auth_reply(struct nvmet_req *req, void
> *d) return NVME_AUTH_DHCHAP_FAILURE_INVALID_PAYLOAD;
> 
>  	if (data->dhvlen) {
> -		return NVME_AUTH_DHCHAP_FAILURE_INVALID_PAYLOAD;
> +		if (!ctrl->dh_tfm)
> +			return NVME_AUTH_DHCHAP_FAILURE_INVALID_PAYLOAD;
> +		if (nvmet_auth_ctrl_sesskey(req, data->rval + 2 * data->hl,
> +					    data->dhvlen) < 0)
> +			return NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
>  	}
> 
>  	response = kmalloc(data->hl, GFP_KERNEL);
> @@ -299,6 +303,8 @@ static int nvmet_auth_challenge(struct nvmet_req *req,
> void *d, int al) int ret = 0;
>  	int data_size = sizeof(*d) + req->sq->dhchap_hash_len;
> 
> +	if (ctrl->dh_tfm)
> +		data_size += ctrl->dh_keysize;
>  	if (al < data_size) {
>  		pr_debug("%s: buffer too small (al %d need %d)\n", __func__,
>  			 al, data_size);
> @@ -317,6 +323,12 @@ static int nvmet_auth_challenge(struct nvmet_req *req,
> void *d, int al) return -ENOMEM;
>  	get_random_bytes(req->sq->dhchap_c1, data->hl);
>  	memcpy(data->cval, req->sq->dhchap_c1, data->hl);
> +	if (ctrl->dh_tfm) {
> +		data->dhgid = ctrl->dh_gid;
> +		data->dhvlen = ctrl->dh_keysize;
> +		ret = nvmet_auth_ctrl_exponential(req, data->cval + data->hl,
> +						  data->dhvlen);
> +	}
>  	pr_debug("%s: ctrl %d qid %d seq %d transaction %d hl %d dhvlen %d\n",
>  		 __func__, ctrl->cntlid, req->sq->qid, req->sq->dhchap_s1,
>  		 req->sq->dhchap_tid, data->hl, data->dhvlen);


Ciao
Stephan


