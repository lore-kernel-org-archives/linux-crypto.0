Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C8DC636CA
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Jul 2021 12:27:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C45D610D1
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Jul 2021 12:27:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbhGRMat (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 18 Jul 2021 08:30:49 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:46078 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbhGRMas (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 18 Jul 2021 08:30:48 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B131C20129;
        Sun, 18 Jul 2021 12:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626611269; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bF437qDon+0mcBIZdCtdl2ECTIcVLieR71GzYXNx828=;
        b=e+JhxoSfmLdSGn3Dvn9RLceXjq4r7WV5VYQY40DZhJJ1SNMTvT4es6HXtlfelXqsHEVeit
        yDe8FItNtpfWjCklu+HrgRLlowpD744W3Z0rPFzY23nJRLykFxb8Cyr4ZOcaaIRLdprda9
        8cPUJqDq67teYpNOHsX2df+wxFC2plY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626611269;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bF437qDon+0mcBIZdCtdl2ECTIcVLieR71GzYXNx828=;
        b=ktMlvhzcX7WC8J4326KEHPOLGwtoxeXpN6J7hvfXOGms/f2B/Ia4I2PkqinGhj4rgnqgkt
        /iWLB2IUiuGCKzDQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 829E213AD2;
        Sun, 18 Jul 2021 12:27:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id G/VDHkUe9GDUOwAAGKfGzw
        (envelope-from <hare@suse.de>); Sun, 18 Jul 2021 12:27:49 +0000
Subject: Re: [PATCH 07/11] nvme-auth: augmented challenge support
To:     =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <20210716110428.9727-8-hare@suse.de> <2165597.y8bdKqVMXX@positron.chronox.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <f50f019c-2cf9-c91c-1ef7-e20df8eb0204@suse.de>
Date:   Sun, 18 Jul 2021 14:27:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <2165597.y8bdKqVMXX@positron.chronox.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/17/21 6:49 PM, Stephan Müller wrote:
> Am Freitag, 16. Juli 2021, 13:04:24 CEST schrieb Hannes Reinecke:
> 
> Hi Hannes,
> 
>> Implement support for augmented challenge using FFDHE groups.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/nvme/host/auth.c | 403 +++++++++++++++++++++++++++++++++++----
>>   1 file changed, 371 insertions(+), 32 deletions(-)
>>
>> diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
>> index 448a3adebea6..754343aced19 100644
>> --- a/drivers/nvme/host/auth.c
>> +++ b/drivers/nvme/host/auth.c
>> @@ -8,6 +8,8 @@
>>   #include <asm/unaligned.h>
>>   #include <crypto/hash.h>
>>   #include <crypto/kpp.h>
>> +#include <crypto/dh.h>
>> +#include <crypto/ffdhe.h>
>>   #include "nvme.h"
>>   #include "fabrics.h"
>>   #include "auth.h"
>> @@ -16,6 +18,8 @@ static u32 nvme_dhchap_seqnum;
>>
>>   struct nvme_dhchap_context {
>>   	struct crypto_shash *shash_tfm;
>> +	struct crypto_shash *digest_tfm;
>> +	struct crypto_kpp *dh_tfm;
>>   	unsigned char *key;
>>   	size_t key_len;
>>   	int qid;
>> @@ -25,6 +29,8 @@ struct nvme_dhchap_context {
>>   	u8 status;
>>   	u8 hash_id;
>>   	u8 hash_len;
>> +	u8 dhgroup_id;
>> +	u16 dhgroup_size;
>>   	u8 c1[64];
>>   	u8 c2[64];
>>   	u8 response[64];
>> @@ -36,6 +42,94 @@ struct nvme_dhchap_context {
>>   	int sess_key_len;
>>   };
>>
>> +struct nvme_auth_dhgroup_map {
>> +	int id;
>> +	const char name[16];
>> +	const char kpp[16];
>> +	int privkey_size;
>> +	int pubkey_size;
>> +} dhgroup_map[] = {
>> +	{ .id = NVME_AUTH_DHCHAP_DHGROUP_NULL,
>> +	  .name = "NULL", .kpp = "NULL",
>> +	  .privkey_size = 0, .pubkey_size = 0 },
>> +	{ .id = NVME_AUTH_DHCHAP_DHGROUP_2048,
>> +	  .name = "ffdhe2048", .kpp = "dh",
>> +	  .privkey_size = 256, .pubkey_size = 256 },
>> +	{ .id = NVME_AUTH_DHCHAP_DHGROUP_3072,
>> +	  .name = "ffdhe3072", .kpp = "dh",
>> +	  .privkey_size = 384, .pubkey_size = 384 },
>> +	{ .id = NVME_AUTH_DHCHAP_DHGROUP_4096,
>> +	  .name = "ffdhe4096", .kpp = "dh",
>> +	  .privkey_size = 512, .pubkey_size = 512 },
>> +	{ .id = NVME_AUTH_DHCHAP_DHGROUP_6144,
>> +	  .name = "ffdhe6144", .kpp = "dh",
>> +	  .privkey_size = 768, .pubkey_size = 768 },
>> +	{ .id = NVME_AUTH_DHCHAP_DHGROUP_8192,
>> +	  .name = "ffdhe8192", .kpp = "dh",
>> +	  .privkey_size = 1024, .pubkey_size = 1024 },
>> +};
>> +
>> +const char *nvme_auth_dhgroup_name(int dhgroup_id)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(dhgroup_map); i++) {
>> +		if (dhgroup_map[i].id == dhgroup_id)
>> +			return dhgroup_map[i].name;
>> +	}
>> +	return NULL;
>> +}
>> +EXPORT_SYMBOL_GPL(nvme_auth_dhgroup_name);
>> +
>> +int nvme_auth_dhgroup_pubkey_size(int dhgroup_id)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(dhgroup_map); i++) {
>> +		if (dhgroup_map[i].id == dhgroup_id)
>> +			return dhgroup_map[i].pubkey_size;
>> +	}
>> +	return -1;
>> +}
>> +EXPORT_SYMBOL_GPL(nvme_auth_dhgroup_pubkey_size);
>> +
>> +int nvme_auth_dhgroup_privkey_size(int dhgroup_id)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(dhgroup_map); i++) {
>> +		if (dhgroup_map[i].id == dhgroup_id)
>> +			return dhgroup_map[i].privkey_size;
>> +	}
>> +	return -1;
>> +}
>> +EXPORT_SYMBOL_GPL(nvme_auth_dhgroup_privkey_size);
>> +
>> +const char *nvme_auth_dhgroup_kpp(int dhgroup_id)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(dhgroup_map); i++) {
>> +		if (dhgroup_map[i].id == dhgroup_id)
>> +			return dhgroup_map[i].kpp;
>> +	}
>> +	return NULL;
>> +}
>> +EXPORT_SYMBOL_GPL(nvme_auth_dhgroup_kpp);
>> +
>> +int nvme_auth_dhgroup_id(const char *dhgroup_name)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(dhgroup_map); i++) {
>> +		if (!strncmp(dhgroup_map[i].name, dhgroup_name,
>> +			     strlen(dhgroup_map[i].name)))
>> +			return dhgroup_map[i].id;
>> +	}
>> +	return -1;
>> +}
>> +EXPORT_SYMBOL_GPL(nvme_auth_dhgroup_id);
>> +
>>   struct nvmet_dhchap_hash_map {
>>   	int id;
>>   	int hash_len;
>> @@ -243,11 +337,16 @@ static int nvme_auth_dhchap_negotiate(struct nvme_ctrl
>> *ctrl, data->napd = 1;
>>   	data->auth_protocol[0].dhchap.authid = NVME_AUTH_DHCHAP_AUTH_ID;
>>   	data->auth_protocol[0].dhchap.halen = 3;
>> -	data->auth_protocol[0].dhchap.dhlen = 1;
>> +	data->auth_protocol[0].dhchap.dhlen = 6;
>>   	data->auth_protocol[0].dhchap.idlist[0] = NVME_AUTH_DHCHAP_HASH_SHA256;
>>   	data->auth_protocol[0].dhchap.idlist[1] = NVME_AUTH_DHCHAP_HASH_SHA384;
>>   	data->auth_protocol[0].dhchap.idlist[2] = NVME_AUTH_DHCHAP_HASH_SHA512;
>>   	data->auth_protocol[0].dhchap.idlist[3] = NVME_AUTH_DHCHAP_DHGROUP_NULL;
>> +	data->auth_protocol[0].dhchap.idlist[4] = NVME_AUTH_DHCHAP_DHGROUP_2048;
>> +	data->auth_protocol[0].dhchap.idlist[5] = NVME_AUTH_DHCHAP_DHGROUP_3072;
>> +	data->auth_protocol[0].dhchap.idlist[6] = NVME_AUTH_DHCHAP_DHGROUP_4096;
>> +	data->auth_protocol[0].dhchap.idlist[7] = NVME_AUTH_DHCHAP_DHGROUP_6144;
>> +	data->auth_protocol[0].dhchap.idlist[8] = NVME_AUTH_DHCHAP_DHGROUP_8192;
>>
>>   	return size;
>>   }
>> @@ -274,14 +373,7 @@ static int nvme_auth_dhchap_challenge(struct nvme_ctrl
>> *ctrl, chap->status = NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE;
>>   		return -EPROTO;
>>   	}
>> -	switch (data->dhgid) {
>> -	case NVME_AUTH_DHCHAP_DHGROUP_NULL:
>> -		gid_name = "null";
>> -		break;
>> -	default:
>> -		gid_name = NULL;
>> -		break;
>> -	}
>> +	gid_name = nvme_auth_dhgroup_kpp(data->dhgid);
>>   	if (!gid_name) {
>>   		dev_warn(ctrl->device,
>>   			 "qid %d: DH-HMAC-CHAP: invalid DH group id %d\n",
>> @@ -290,10 +382,24 @@ static int nvme_auth_dhchap_challenge(struct nvme_ctrl
>> *ctrl, return -EPROTO;
>>   	}
>>   	if (data->dhgid != NVME_AUTH_DHCHAP_DHGROUP_NULL) {
>> -		chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
>> -		return -EPROTO;
>> -	}
>> -	if (data->dhgid == NVME_AUTH_DHCHAP_DHGROUP_NULL && data->dhvlen != 0) {
>> +		if (data->dhvlen == 0) {
>> +			dev_warn(ctrl->device,
>> +				 "qid %d: DH-HMAC-CHAP: empty DH value\n",
>> +				 chap->qid);
>> +			chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
>> +			return -EPROTO;
>> +		}
>> +		chap->dh_tfm = crypto_alloc_kpp(gid_name, 0, 0);
>> +		if (IS_ERR(chap->dh_tfm)) {
>> +			dev_warn(ctrl->device,
>> +				 "qid %d: DH-HMAC-CHAP: failed to initialize %s\n",
>> +				 chap->qid, gid_name);
>> +			chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
>> +			chap->dh_tfm = NULL;
>> +			return -EPROTO;
>> +		}
>> +		chap->dhgroup_id = data->dhgid;
>> +	} else if (data->dhvlen != 0) {
>>   		dev_warn(ctrl->device,
>>   			 "qid %d: DH-HMAC-CHAP: invalid DH value for NULL DH\n",
>>   			chap->qid);
>> @@ -313,6 +419,16 @@ static int nvme_auth_dhchap_challenge(struct nvme_ctrl
>> *ctrl, chap->hash_len = data->hl;
>>   	chap->s1 = le32_to_cpu(data->seqnum);
>>   	memcpy(chap->c1, data->cval, chap->hash_len);
>> +	if (data->dhvlen) {
>> +		chap->ctrl_key = kmalloc(data->dhvlen, GFP_KERNEL);
>> +		if (!chap->ctrl_key)
>> +			return -ENOMEM;
>> +		chap->ctrl_key_len = data->dhvlen;
>> +		memcpy(chap->ctrl_key, data->cval + chap->hash_len,
>> +		       data->dhvlen);
>> +		dev_dbg(ctrl->device, "ctrl public key %*ph\n",
>> +			 (int)chap->ctrl_key_len, chap->ctrl_key);
>> +	}
>>
>>   	return 0;
>>   }
>> @@ -353,10 +469,13 @@ static int nvme_auth_dhchap_reply(struct nvme_ctrl
>> *ctrl, memcpy(data->rval + chap->hash_len, chap->c2,
>>   		       chap->hash_len);
>>   	}
>> -	if (chap->host_key_len)
>> +	if (chap->host_key_len) {
>> +		dev_dbg(ctrl->device, "%s: qid %d host public key %*ph\n",
>> +			__func__, chap->qid,
>> +			chap->host_key_len, chap->host_key);
>>   		memcpy(data->rval + 2 * chap->hash_len, chap->host_key,
>>   		       chap->host_key_len);
>> -
>> +	}
>>   	return size;
>>   }
>>
>> @@ -440,23 +559,10 @@ static int nvme_auth_dhchap_failure2(struct nvme_ctrl
>> *ctrl, int nvme_auth_select_hash(struct nvme_ctrl *ctrl,
>>   			  struct nvme_dhchap_context *chap)
>>   {
>> -	char *hash_name;
>> +	const char *hash_name, *digest_name;
>>   	int ret;
>>
>> -	switch (chap->hash_id) {
>> -	case NVME_AUTH_DHCHAP_HASH_SHA256:
>> -		hash_name = "hmac(sha256)";
>> -		break;
>> -	case NVME_AUTH_DHCHAP_HASH_SHA384:
>> -		hash_name = "hmac(sha384)";
>> -		break;
>> -	case NVME_AUTH_DHCHAP_HASH_SHA512:
>> -		hash_name = "hmac(sha512)";
>> -		break;
>> -	default:
>> -		hash_name = NULL;
>> -		break;
>> -	}
>> +	hash_name = nvme_auth_hmac_name(chap->hash_id);
>>   	if (!hash_name) {
>>   		chap->status = NVME_AUTH_DHCHAP_FAILURE_NOT_USABLE;
>>   		return -EPROTO;
>> @@ -468,26 +574,100 @@ int nvme_auth_select_hash(struct nvme_ctrl *ctrl,
>>   		chap->shash_tfm = NULL;
>>   		return -EPROTO;
>>   	}
>> +	digest_name = nvme_auth_digest_name(chap->hash_id);
>> +	if (!digest_name) {
>> +		crypto_free_shash(chap->shash_tfm);
>> +		chap->shash_tfm = NULL;
>> +		return -EPROTO;
>> +	}
>> +	chap->digest_tfm = crypto_alloc_shash(digest_name, 0, 0);
>> +	if (IS_ERR(chap->digest_tfm)) {
>> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_NOT_USABLE;
>> +		crypto_free_shash(chap->shash_tfm);
>> +		chap->shash_tfm = NULL;
>> +		chap->digest_tfm = NULL;
>> +		return -EPROTO;
>> +	}
>>   	if (!chap->key) {
>>   		dev_warn(ctrl->device, "qid %d: cannot select hash, no key\n",
>>   			 chap->qid);
>>   		chap->status = NVME_AUTH_DHCHAP_FAILURE_NOT_USABLE;
>> +		crypto_free_shash(chap->digest_tfm);
>>   		crypto_free_shash(chap->shash_tfm);
>>   		chap->shash_tfm = NULL;
>> +		chap->digest_tfm = NULL;
>>   		return -EINVAL;
>>   	}
>>   	ret = crypto_shash_setkey(chap->shash_tfm, chap->key, chap->key_len);
>>   	if (ret) {
>>   		chap->status = NVME_AUTH_DHCHAP_FAILURE_NOT_USABLE;
>> +		crypto_free_shash(chap->digest_tfm);
>>   		crypto_free_shash(chap->shash_tfm);
>>   		chap->shash_tfm = NULL;
>> +		chap->digest_tfm = NULL;
>>   		return ret;
>>   	}
>> -	dev_info(ctrl->device, "qid %d: DH-HMAC_CHAP: selected hash %s\n",
>> -		 chap->qid, hash_name);
>> +	dev_dbg(ctrl->device, "qid %d: DH-HMAC_CHAP: selected hash %s\n",
>> +		chap->qid, hash_name);
>>   	return 0;
>>   }
>>
>> +static int nvme_auth_augmented_challenge(struct nvme_dhchap_context *chap,
>> +					 u8 *challenge, u8 *aug)
>> +{
>> +	struct crypto_shash *tfm;
>> +	struct shash_desc *desc;
>> +	u8 *hashed_key;
>> +	const char *hash_name;
>> +	int ret;
>> +
>> +	hashed_key = kmalloc(chap->hash_len, GFP_KERNEL);
>> +	if (!hashed_key)
>> +		return -ENOMEM;
>> +
>> +	ret = crypto_shash_tfm_digest(chap->digest_tfm, chap->sess_key,
>> +				      chap->sess_key_len, hashed_key);
>> +	if (ret < 0) {
>> +		pr_debug("failed to hash session key, err %d\n", ret);
>> +		kfree(hashed_key);
>> +		return ret;
>> +	}
>> +	hash_name = crypto_shash_alg_name(chap->shash_tfm);
>> +	if (!hash_name) {
>> +		pr_debug("Invalid hash algoritm\n");
>> +		return -EINVAL;
>> +	}
>> +	tfm = crypto_alloc_shash(hash_name, 0, 0);
>> +	if (IS_ERR(tfm)) {
>> +		ret = PTR_ERR(tfm);
>> +		goto out_free_key;
>> +	}
>> +	desc = kmalloc(sizeof(struct shash_desc) + crypto_shash_descsize(tfm),
>> +		       GFP_KERNEL);
>> +	if (!desc) {
>> +		ret = -ENOMEM;
>> +		goto out_free_hash;
>> +	}
>> +	desc->tfm = tfm;
>> +
>> +	ret = crypto_shash_setkey(tfm, hashed_key, chap->hash_len);
>> +	if (ret)
>> +		goto out_free_desc;
>> +	ret = crypto_shash_init(desc);
>> +	if (ret)
>> +		goto out_free_desc;
>> +	crypto_shash_update(desc, challenge, chap->hash_len);
>> +	crypto_shash_final(desc, aug);
>> +
>> +out_free_desc:
>> +	kfree_sensitive(desc);
>> +out_free_hash:
>> +	crypto_free_shash(tfm);
>> +out_free_key:
>> +	kfree(hashed_key);
>> +	return ret;
>> +}
>> +
>>   static int nvme_auth_dhchap_host_response(struct nvme_ctrl *ctrl,
>>   					  struct nvme_dhchap_context *chap)
>>   {
>> @@ -497,6 +677,16 @@ static int nvme_auth_dhchap_host_response(struct
>> nvme_ctrl *ctrl,
>>
>>   	dev_dbg(ctrl->device, "%s: qid %d host response seq %d transaction
> %d\n",
>>   		__func__, chap->qid, chap->s1, chap->transaction);
>> +	if (chap->dh_tfm) {
>> +		challenge = kmalloc(chap->hash_len, GFP_KERNEL);
> 
> Again, alignment?
> 

Again, why?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
