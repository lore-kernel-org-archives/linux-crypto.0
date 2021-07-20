Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 706EBC07E95
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 13:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57689610CC
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 13:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbhGTMb5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jul 2021 08:31:57 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:55918 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235863AbhGTMbz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jul 2021 08:31:55 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6F1A122300;
        Tue, 20 Jul 2021 13:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626786750; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9eR+WjSdcBoT6zbG81ii390OkQNDDG/K2eBr8xtCknA=;
        b=N/3Io942/jaoWfNfL6yD2Uez7MS2tM4wPqPQ9KVwFaBVvm0KGUZV085GYTYNbSPNq7+UV5
        wCxlZfkZnjeJWbc/2xBpL337QtWIMZAoN7J27CS6h91wbAnXdNGcwDADtLMNY8MEIoIyS5
        WyVe01GqhZLwreu3DhK6s+bU92+BBNM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626786750;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9eR+WjSdcBoT6zbG81ii390OkQNDDG/K2eBr8xtCknA=;
        b=/kovbmeO54PgzSsLmTqdyC5Zxsfw8yrRI/LEhpk2U6N8s2uYGvI1tR4dFbnaxPeyJrvI+Y
        K8cmTxdOFn1jvhAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5E48313D68;
        Tue, 20 Jul 2021 13:12:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9cjFFr7L9mA4dQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 20 Jul 2021 13:12:30 +0000
To:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>, linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <20210716110428.9727-8-hare@suse.de>
 <3681598b-436a-5f25-f61f-f09c6ec077a3@grimberg.me>
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/11] nvme-auth: augmented challenge support
Message-ID: <7aacc3ea-fad5-78c6-1bd5-22fec11ee32e@suse.de>
Date:   Tue, 20 Jul 2021 15:12:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3681598b-436a-5f25-f61f-f09c6ec077a3@grimberg.me>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/19/21 11:21 AM, Sagi Grimberg wrote:
> 
> 
> On 7/16/21 4:04 AM, Hannes Reinecke wrote:
>> Implement support for augmented challenge using FFDHE groups.
> 
> Please some more info for the change log...
> 
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/nvme/host/auth.c | 403 +++++++++++++++++++++++++++++++++++----
>>   1 file changed, 371 insertions(+), 32 deletions(-)
>>
>> diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
>> index 448a3adebea6..754343aced19 100644
>> --- a/drivers/nvme/host/auth.c
>> +++ b/drivers/nvme/host/auth.c
[ .. ]
>> @@ -290,10 +382,24 @@ static int nvme_auth_dhchap_challenge(struct
>> nvme_ctrl *ctrl,
>>           return -EPROTO;
>>       }
>>       if (data->dhgid != NVME_AUTH_DHCHAP_DHGROUP_NULL) {
>> -        chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
>> -        return -EPROTO;
>> -    }
>> -    if (data->dhgid == NVME_AUTH_DHCHAP_DHGROUP_NULL && data->dhvlen
>> != 0) {
>> +        if (data->dhvlen == 0) {
>> +            dev_warn(ctrl->device,
>> +                 "qid %d: DH-HMAC-CHAP: empty DH value\n",
>> +                 chap->qid);
>> +            chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
>> +            return -EPROTO;
>> +        }
>> +        chap->dh_tfm = crypto_alloc_kpp(gid_name, 0, 0);
>> +        if (IS_ERR(chap->dh_tfm)) {
>> +            dev_warn(ctrl->device,
>> +                 "qid %d: DH-HMAC-CHAP: failed to initialize %s\n",
>> +                 chap->qid, gid_name);
>> +            chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
>> +            chap->dh_tfm = NULL;
>> +            return -EPROTO;
> 
> Why not propogate the error?
> 

Will be doing so.

>> +        }
>> +        chap->dhgroup_id = data->dhgid;
>> +    } else if (data->dhvlen != 0) {
>>           dev_warn(ctrl->device,
>>                "qid %d: DH-HMAC-CHAP: invalid DH value for NULL DH\n",
>>               chap->qid);
>> @@ -313,6 +419,16 @@ static int nvme_auth_dhchap_challenge(struct
>> nvme_ctrl *ctrl,
>>       chap->hash_len = data->hl;
>>       chap->s1 = le32_to_cpu(data->seqnum);
>>       memcpy(chap->c1, data->cval, chap->hash_len);
>> +    if (data->dhvlen) {
>> +        chap->ctrl_key = kmalloc(data->dhvlen, GFP_KERNEL);
>> +        if (!chap->ctrl_key)
>> +            return -ENOMEM;
>> +        chap->ctrl_key_len = data->dhvlen;
>> +        memcpy(chap->ctrl_key, data->cval + chap->hash_len,
>> +               data->dhvlen);
>> +        dev_dbg(ctrl->device, "ctrl public key %*ph\n",
>> +             (int)chap->ctrl_key_len, chap->ctrl_key);
>> +    }
>>         return 0;
>>   }
>> @@ -353,10 +469,13 @@ static int nvme_auth_dhchap_reply(struct
>> nvme_ctrl *ctrl,
>>           memcpy(data->rval + chap->hash_len, chap->c2,
>>                  chap->hash_len);
>>       }
>> -    if (chap->host_key_len)
>> +    if (chap->host_key_len) {
>> +        dev_dbg(ctrl->device, "%s: qid %d host public key %*ph\n",
>> +            __func__, chap->qid,
>> +            chap->host_key_len, chap->host_key);
>>           memcpy(data->rval + 2 * chap->hash_len, chap->host_key,
>>                  chap->host_key_len);
>> -
>> +    }
> 
> Is this change only adding the debug print?
> 

Might. I'll check.

>>       return size;
>>   }
>>   @@ -440,23 +559,10 @@ static int nvme_auth_dhchap_failure2(struct
>> nvme_ctrl *ctrl,
>>   int nvme_auth_select_hash(struct nvme_ctrl *ctrl,
>>                 struct nvme_dhchap_context *chap)
>>   {
>> -    char *hash_name;
>> +    const char *hash_name, *digest_name;
>>       int ret;
>>   -    switch (chap->hash_id) {
>> -    case NVME_AUTH_DHCHAP_HASH_SHA256:
>> -        hash_name = "hmac(sha256)";
>> -        break;
>> -    case NVME_AUTH_DHCHAP_HASH_SHA384:
>> -        hash_name = "hmac(sha384)";
>> -        break;
>> -    case NVME_AUTH_DHCHAP_HASH_SHA512:
>> -        hash_name = "hmac(sha512)";
>> -        break;
>> -    default:
>> -        hash_name = NULL;
>> -        break;
>> -    }
>> +    hash_name = nvme_auth_hmac_name(chap->hash_id);
>>       if (!hash_name) {
>>           chap->status = NVME_AUTH_DHCHAP_FAILURE_NOT_USABLE;
>>           return -EPROTO;
>> @@ -468,26 +574,100 @@ int nvme_auth_select_hash(struct nvme_ctrl *ctrl,
>>           chap->shash_tfm = NULL;
>>           return -EPROTO;
>>       }
>> +    digest_name = nvme_auth_digest_name(chap->hash_id);
>> +    if (!digest_name) {
>> +        crypto_free_shash(chap->shash_tfm);
>> +        chap->shash_tfm = NULL;
>> +        return -EPROTO;
>> +    }
>> +    chap->digest_tfm = crypto_alloc_shash(digest_name, 0, 0);
>> +    if (IS_ERR(chap->digest_tfm)) {
>> +        chap->status = NVME_AUTH_DHCHAP_FAILURE_NOT_USABLE;
>> +        crypto_free_shash(chap->shash_tfm);
>> +        chap->shash_tfm = NULL;
>> +        chap->digest_tfm = NULL;
>> +        return -EPROTO;
>> +    }
>>       if (!chap->key) {
>>           dev_warn(ctrl->device, "qid %d: cannot select hash, no key\n",
>>                chap->qid);
>>           chap->status = NVME_AUTH_DHCHAP_FAILURE_NOT_USABLE;
>> +        crypto_free_shash(chap->digest_tfm);
>>           crypto_free_shash(chap->shash_tfm);
>>           chap->shash_tfm = NULL;
>> +        chap->digest_tfm = NULL;
>>           return -EINVAL;
> 
> Please have a structured goto targets in reverse order, this repeated
> cleanup is a mess...
> 

Already done.

>>       }
>>       ret = crypto_shash_setkey(chap->shash_tfm, chap->key,
>> chap->key_len);
>>       if (ret) {
>>           chap->status = NVME_AUTH_DHCHAP_FAILURE_NOT_USABLE;
>> +        crypto_free_shash(chap->digest_tfm);
>>           crypto_free_shash(chap->shash_tfm);
>>           chap->shash_tfm = NULL;
>> +        chap->digest_tfm = NULL;
>>           return ret;
>>       }
>> -    dev_info(ctrl->device, "qid %d: DH-HMAC_CHAP: selected hash %s\n",
>> -         chap->qid, hash_name);
>> +    dev_dbg(ctrl->device, "qid %d: DH-HMAC_CHAP: selected hash %s\n",
>> +        chap->qid, hash_name);
>>       return 0;
>>   }
>>   +static int nvme_auth_augmented_challenge(struct nvme_dhchap_context
>> *chap,
>> +                     u8 *challenge, u8 *aug)
>> +{
>> +    struct crypto_shash *tfm;
>> +    struct shash_desc *desc;
>> +    u8 *hashed_key;
>> +    const char *hash_name;
>> +    int ret;
>> +
>> +    hashed_key = kmalloc(chap->hash_len, GFP_KERNEL);
>> +    if (!hashed_key)
>> +        return -ENOMEM;
>> +
>> +    ret = crypto_shash_tfm_digest(chap->digest_tfm, chap->sess_key,
>> +                      chap->sess_key_len, hashed_key);
>> +    if (ret < 0) {
>> +        pr_debug("failed to hash session key, err %d\n", ret);
>> +        kfree(hashed_key);
> 
> Same here...
> 
>> +        return ret;
>> +    }
> 
> Spaces between if conditions please?
> 
>> +    hash_name = crypto_shash_alg_name(chap->shash_tfm);
>> +    if (!hash_name) {
>> +        pr_debug("Invalid hash algoritm\n");
>> +        return -EINVAL;
>> +    }
>> +    tfm = crypto_alloc_shash(hash_name, 0, 0);
>> +    if (IS_ERR(tfm)) {
>> +        ret = PTR_ERR(tfm);
>> +        goto out_free_key;
>> +    }
>> +    desc = kmalloc(sizeof(struct shash_desc) +
>> crypto_shash_descsize(tfm),
>> +               GFP_KERNEL);
>> +    if (!desc) {
>> +        ret = -ENOMEM;
>> +        goto out_free_hash;
>> +    }
>> +    desc->tfm = tfm;
>> +
>> +    ret = crypto_shash_setkey(tfm, hashed_key, chap->hash_len);
>> +    if (ret)
>> +        goto out_free_desc;
>> +    ret = crypto_shash_init(desc);
>> +    if (ret)
>> +        goto out_free_desc;
>> +    crypto_shash_update(desc, challenge, chap->hash_len);
>> +    crypto_shash_final(desc, aug);
>> +
>> +out_free_desc:
>> +    kfree_sensitive(desc);
>> +out_free_hash:
>> +    crypto_free_shash(tfm);
>> +out_free_key:
>> +    kfree(hashed_key);
>> +    return ret;
>> +}
>> +
>>   static int nvme_auth_dhchap_host_response(struct nvme_ctrl *ctrl,
>>                         struct nvme_dhchap_context *chap)
>>   {
>> @@ -497,6 +677,16 @@ static int nvme_auth_dhchap_host_response(struct
>> nvme_ctrl *ctrl,
>>         dev_dbg(ctrl->device, "%s: qid %d host response seq %d
>> transaction %d\n",
>>           __func__, chap->qid, chap->s1, chap->transaction);
>> +    if (chap->dh_tfm) {
>> +        challenge = kmalloc(chap->hash_len, GFP_KERNEL);
>> +        if (!challenge) {
>> +            ret = -ENOMEM;
>> +            goto out;
>> +        }
>> +        ret = nvme_auth_augmented_challenge(chap, chap->c1, challenge);
>> +        if (ret)
>> +            goto out;
>> +    }
>>       shash->tfm = chap->shash_tfm;
>>       ret = crypto_shash_init(shash);
>>       if (ret)
>> @@ -532,6 +722,8 @@ static int nvme_auth_dhchap_host_response(struct
>> nvme_ctrl *ctrl,
>>           goto out;
>>       ret = crypto_shash_final(shash, chap->response);
>>   out:
>> +    if (challenge != chap->c1)
>> +        kfree(challenge);
>>       return ret;
>>   }
>>   @@ -542,6 +734,17 @@ static int
>> nvme_auth_dhchap_ctrl_response(struct nvme_ctrl *ctrl,
>>       u8 buf[4], *challenge = chap->c2;
>>       int ret;
>>   +    if (chap->dh_tfm) {
>> +        challenge = kmalloc(chap->hash_len, GFP_KERNEL);
>> +        if (!challenge) {
>> +            ret = -ENOMEM;
>> +            goto out;
>> +        }
>> +        ret = nvme_auth_augmented_challenge(chap, chap->c2,
>> +                            challenge);
>> +        if (ret)
>> +            goto out;
>> +    }
>>       dev_dbg(ctrl->device, "%s: qid %d host response seq %d
>> transaction %d\n",
>>           __func__, chap->qid, chap->s2, chap->transaction);
>>       dev_dbg(ctrl->device, "%s: qid %d challenge %*ph\n",
>> @@ -585,6 +788,8 @@ static int nvme_auth_dhchap_ctrl_response(struct
>> nvme_ctrl *ctrl,
>>           goto out;
>>       ret = crypto_shash_final(shash, chap->response);
>>   out:
>> +    if (challenge != chap->c2)
>> +        kfree(challenge);
> 
> Just free ?! what about failing?
> 

This is not an error condition, but rather the case when we need to
construct an augmented challenge; in that case we'll allocate a
temporary buffer in 'challenge', and copy it over into 'c2'.

>>       return ret;
>>   }
>>   @@ -644,10 +849,134 @@ int nvme_auth_generate_key(struct nvme_ctrl
>> *ctrl,
>>       return 0;
>>   }
>>   +static int nvme_auth_dhchap_exponential(struct nvme_ctrl *ctrl,
>> +                    struct nvme_dhchap_context *chap)
>> +{
>> +    struct kpp_request *req;
>> +    struct crypto_wait wait;
>> +    struct scatterlist src, dst;
>> +    u8 *pkey;
>> +    int ret, pkey_len;
>> +
>> +    if (chap->dhgroup_id == NVME_AUTH_DHCHAP_DHGROUP_2048 ||
>> +        chap->dhgroup_id == NVME_AUTH_DHCHAP_DHGROUP_3072 ||
>> +        chap->dhgroup_id == NVME_AUTH_DHCHAP_DHGROUP_4096 ||
>> +        chap->dhgroup_id == NVME_AUTH_DHCHAP_DHGROUP_6144 ||
>> +        chap->dhgroup_id == NVME_AUTH_DHCHAP_DHGROUP_8192) {
>> +        struct dh p = {0};
>> +        int pubkey_size =
>> nvme_auth_dhgroup_pubkey_size(chap->dhgroup_id);
>> +
>> +        ret = crypto_ffdhe_params(&p, pubkey_size << 3);
>> +        if (ret) {
>> +            dev_dbg(ctrl->device,
>> +                "failed to generate ffdhe params, error %d\n",
>> +                ret);
>> +            return ret;
>> +        }
>> +        p.key = chap->key;
>> +        p.key_size = chap->key_len;
>> +
>> +        pkey_len = crypto_dh_key_len(&p);
>> +        pkey = kzalloc(pkey_len, GFP_KERNEL);
>> +
>> +        get_random_bytes(pkey, pkey_len);
>> +        ret = crypto_dh_encode_key(pkey, pkey_len, &p);
>> +        if (ret) {
>> +            dev_dbg(ctrl->device,
>> +                "failed to encode pkey, error %d\n", ret);
>> +            kfree(pkey);
>> +            return ret;
>> +        }
>> +        chap->host_key_len = pubkey_size;
>> +        chap->sess_key_len = pubkey_size;
>> +    } else {
>> +        dev_warn(ctrl->device, "Invalid DH group id %d\n",
>> +             chap->dhgroup_id);
>> +        chap->status = NVME_AUTH_DHCHAP_FAILURE_INVALID_PAYLOAD;
>> +        return -EINVAL;
>> +    }
>> +
>> +    ret = crypto_kpp_set_secret(chap->dh_tfm, pkey, pkey_len);
>> +    if (ret) {
>> +        dev_dbg(ctrl->dev, "failed to set secret, error %d\n", ret);
>> +        kfree(pkey);
>> +        return ret;
>> +    }
>> +    req = kpp_request_alloc(chap->dh_tfm, GFP_KERNEL);
>> +    if (!req) {
>> +        ret = -ENOMEM;
>> +        goto out_free_exp;
>> +    }
>> +
>> +    chap->host_key = kzalloc(chap->host_key_len, GFP_KERNEL);
>> +    if (!chap->host_key) {
>> +        ret = -ENOMEM;
>> +        goto out_free_req;
>> +    }
>> +    crypto_init_wait(&wait);
>> +    kpp_request_set_input(req, NULL, 0);
>> +    sg_init_one(&dst, chap->host_key, chap->host_key_len);
>> +    kpp_request_set_output(req, &dst, chap->host_key_len);
>> +    kpp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>> +                 crypto_req_done, &wait);
>> +
>> +    ret = crypto_wait_req(crypto_kpp_generate_public_key(req), &wait);
>> +    if (ret == -EOVERFLOW) {
>> +        dev_dbg(ctrl->dev,
>> +            "public key buffer too small, wants %d is %d\n",
>> +            crypto_kpp_maxsize(chap->dh_tfm), chap->host_key_len);
>> +        goto out_free_host;
> 
> Is this a specific retcode of intereset? Why did you specifically add
> special casing here?
> 

Because that's the specific error code from the DH code, indicating that
the length isn't correct. And I needed that during development of the
FFDHE code.
But yeah, it can be removed.


Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
