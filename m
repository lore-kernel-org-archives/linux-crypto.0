Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 412C9C636C8
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Jul 2021 12:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19C29600D3
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Jul 2021 12:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbhGRMkf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 18 Jul 2021 08:40:35 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:46802 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbhGRMke (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 18 Jul 2021 08:40:34 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id EC16D2014E;
        Sun, 18 Jul 2021 12:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626611854; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=12QxCntc46zGkMjFzhnXFSG1Ib64ny5ns5DTZhrNIrk=;
        b=SG9Xr/Jh0oxqP3J5NHVfuR78M/oUJrCD17nHm4gY71mrrJ1Z76TqlrYrbsuS+vP7hk1Pra
        iuVkxo4mmvbDcZaUwemPoVR4Bq5gBXU5zbWq+uUKD2CCvF9bRKGZVooodCylUORNsqBzm2
        3kWym0KLDL/YSzJdK/j17WL1i1ao6bk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626611854;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=12QxCntc46zGkMjFzhnXFSG1Ib64ny5ns5DTZhrNIrk=;
        b=yPg+dwvtnWmdxJlKXPestX6YiYGamM1vLUWHQYD0Tzp1Zda26V3XGgCoLxmKWa5M3kT7xg
        RWvVWIOFKWDalPDQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 9D10813AD2;
        Sun, 18 Jul 2021 12:37:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id 237OJI4g9GBuPQAAGKfGzw
        (envelope-from <hare@suse.de>); Sun, 18 Jul 2021 12:37:34 +0000
Subject: Re: [PATCH 09/11] nvmet: Implement basic In-Band Authentication
To:     =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <20210716110428.9727-10-hare@suse.de>
 <2510347.locV8n3378@positron.chronox.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <a4d4bda0-2bc8-0d0c-3e81-55adecd6ce52@suse.de>
Date:   Sun, 18 Jul 2021 14:37:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <2510347.locV8n3378@positron.chronox.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/17/21 6:49 PM, Stephan Müller wrote:
> Am Freitag, 16. Juli 2021, 13:04:26 CEST schrieb Hannes Reinecke:
> 
> Hi Hannes,
> 
>> Implement support for NVMe-oF In-Band authentication. This patch
>> adds two additional configfs entries 'dhchap_key' and 'dhchap_hash'
>> to the 'host' configfs directory. The 'dhchap_key' needs to be
>> specified in the format outlined in the base spec.
>> Augmented challenge support is not implemented, and concatenation
>> with TLS encryption is not supported.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/nvme/target/Kconfig            |  10 +
>>   drivers/nvme/target/Makefile           |   1 +
>>   drivers/nvme/target/admin-cmd.c        |   4 +
>>   drivers/nvme/target/auth.c             | 352 +++++++++++++++++++
>>   drivers/nvme/target/configfs.c         |  71 +++-
>>   drivers/nvme/target/core.c             |   8 +
>>   drivers/nvme/target/fabrics-cmd-auth.c | 460 +++++++++++++++++++++++++
>>   drivers/nvme/target/fabrics-cmd.c      |  30 +-
>>   drivers/nvme/target/nvmet.h            |  71 ++++
>>   9 files changed, 1004 insertions(+), 3 deletions(-)
>>   create mode 100644 drivers/nvme/target/auth.c
>>   create mode 100644 drivers/nvme/target/fabrics-cmd-auth.c
>>
>> diff --git a/drivers/nvme/target/Kconfig b/drivers/nvme/target/Kconfig
>> index 4be2ececbc45..d5656ef1559e 100644
>> --- a/drivers/nvme/target/Kconfig
>> +++ b/drivers/nvme/target/Kconfig
>> @@ -85,3 +85,13 @@ config NVME_TARGET_TCP
>>   	  devices over TCP.
>>
>>   	  If unsure, say N.
>> +
>> +config NVME_TARGET_AUTH
>> +	bool "NVMe over Fabrics In-band Authentication support"
>> +	depends on NVME_TARGET
>> +	select CRYPTO_SHA256
>> +	select CRYPTO_SHA512
>> +	help
>> +	  This enables support for NVMe over Fabrics In-band Authentication
>> +
>> +	  If unsure, say N.
>> diff --git a/drivers/nvme/target/Makefile b/drivers/nvme/target/Makefile
>> index 9837e580fa7e..c66820102493 100644
>> --- a/drivers/nvme/target/Makefile
>> +++ b/drivers/nvme/target/Makefile
>> @@ -13,6 +13,7 @@ nvmet-y		+= core.o configfs.o admin-cmd.o
> fabrics-cmd.o \
>>   			discovery.o io-cmd-file.o io-cmd-bdev.o
>>   nvmet-$(CONFIG_NVME_TARGET_PASSTHRU)	+= passthru.o
>>   nvmet-$(CONFIG_BLK_DEV_ZONED)		+= zns.o
>> +nvmet-$(CONFIG_NVME_TARGET_AUTH)	+= fabrics-cmd-auth.o auth.o
>>   nvme-loop-y	+= loop.o
>>   nvmet-rdma-y	+= rdma.o
>>   nvmet-fc-y	+= fc.o
>> diff --git a/drivers/nvme/target/admin-cmd.c
>> b/drivers/nvme/target/admin-cmd.c index 0cb98f2bbc8c..320cefc64ee0 100644
>> --- a/drivers/nvme/target/admin-cmd.c
>> +++ b/drivers/nvme/target/admin-cmd.c
>> @@ -1008,6 +1008,10 @@ u16 nvmet_parse_admin_cmd(struct nvmet_req *req)
>>
>>   	if (nvme_is_fabrics(cmd))
>>   		return nvmet_parse_fabrics_cmd(req);
>> +
>> +	if (unlikely(!nvmet_check_auth_status(req)))
>> +		return NVME_SC_AUTH_REQUIRED | NVME_SC_DNR;
>> +
>>   	if (nvmet_req_subsys(req)->type == NVME_NQN_DISC)
>>   		return nvmet_parse_discovery_cmd(req);
>>
>> diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
>> new file mode 100644
>> index 000000000000..00c7d051dfb1
>> --- /dev/null
>> +++ b/drivers/nvme/target/auth.c
>> @@ -0,0 +1,352 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * NVMe over Fabrics DH-HMAC-CHAP authentication.
>> + * Copyright (c) 2020 Hannes Reinecke, SUSE Software Solutions.
>> + * All rights reserved.
>> + */
>> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> +#include <linux/module.h>
>> +#include <linux/init.h>
>> +#include <linux/slab.h>
>> +#include <linux/err.h>
>> +#include <crypto/hash.h>
>> +#include <crypto/kpp.h>
>> +#include <crypto/dh.h>
>> +#include <crypto/ffdhe.h>
>> +#include <linux/crc32.h>
>> +#include <linux/base64.h>
>> +#include <linux/ctype.h>
>> +#include <linux/random.h>
>> +#include <asm/unaligned.h>
>> +
>> +#include "nvmet.h"
>> +#include "../host/auth.h"
>> +
>> +int nvmet_auth_set_host_key(struct nvmet_host *host, const char *secret)
>> +{
>> +	if (sscanf(secret, "DHHC-1:%hhd:%*s", &host->dhchap_key_hash) != 1)
>> +		return -EINVAL;
>> +	if (host->dhchap_key_hash > 3) {
>> +		pr_warn("Invalid DH-HMAC-CHAP hash id %d\n",
>> +			 host->dhchap_key_hash);
>> +		return -EINVAL;
>> +	}
>> +	if (host->dhchap_key_hash > 0) {
>> +		/* Validate selected hash algorithm */
>> +		const char *hmac = nvme_auth_hmac_name(host->dhchap_key_hash);
>> +
>> +		if (!crypto_has_shash(hmac, 0, 0)) {
>> +			pr_warn("DH-HMAC-CHAP hash %s unsupported\n", hmac);
>> +			host->dhchap_key_hash = -1;
>> +			return -EAGAIN;
>> +		}
>> +		/* Use this hash as default */
>> +		if (!host->dhchap_hash_id)
>> +			host->dhchap_hash_id = host->dhchap_key_hash;
>> +	}
>> +	host->dhchap_secret = kstrdup(secret, GFP_KERNEL);
> 
> Just like before - are you sure that the secret is an ASCII string and no
> binary blob?
> 

That is ensured by the transport encoding (cf NVMe Base Specification 
version 2.0). Also, this information is being passed in via the configfs 
interface, so it's bounded by PAGE_SIZE. But yes, we should be inserting 
a terminating 'NULL' character at the end of the page to ensure we don't 
incur an buffer overrun. Any other failure will be checked for during 
base64 decoding.

>> +	if (!host->dhchap_secret)
>> +		return -ENOMEM;
>> +	/* Default to SHA256 */
>> +	if (!host->dhchap_hash_id)
>> +		host->dhchap_hash_id = NVME_AUTH_DHCHAP_HASH_SHA256;
>> +
>> +	pr_debug("Using hash %s\n",
>> +		 nvme_auth_hmac_name(host->dhchap_hash_id));
>> +	return 0;
>> +}
>> +
>> +int nvmet_setup_dhgroup(struct nvmet_ctrl *ctrl, int dhgroup_id)
>> +{
>> +	int ret = -ENOTSUPP;
>> +
>> +	if (dhgroup_id == NVME_AUTH_DHCHAP_DHGROUP_NULL)
>> +		return 0;
>> +
>> +	return ret;
>> +}
>> +
>> +int nvmet_setup_auth(struct nvmet_ctrl *ctrl, struct nvmet_req *req)
>> +{
>> +	int ret = 0;
>> +	struct nvmet_host_link *p;
>> +	struct nvmet_host *host = NULL;
>> +	const char *hash_name;
>> +
>> +	down_read(&nvmet_config_sem);
>> +	if (ctrl->subsys->type == NVME_NQN_DISC)
>> +		goto out_unlock;
>> +
>> +	list_for_each_entry(p, &ctrl->subsys->hosts, entry) {
>> +		pr_debug("check %s\n", nvmet_host_name(p->host));
>> +		if (strcmp(nvmet_host_name(p->host), ctrl->hostnqn))
>> +			continue;
>> +		host = p->host;
>> +		break;
>> +	}
>> +	if (!host) {
>> +		pr_debug("host %s not found\n", ctrl->hostnqn);
>> +		ret = -EPERM;
>> +		goto out_unlock;
>> +	}
>> +	if (!host->dhchap_secret) {
>> +		pr_debug("No authentication provided\n");
>> +		goto out_unlock;
>> +	}
>> +
>> +	hash_name = nvme_auth_hmac_name(host->dhchap_hash_id);
>> +	if (!hash_name) {
>> +		pr_debug("Hash ID %d invalid\n", host->dhchap_hash_id);
>> +		ret = -EINVAL;
>> +		goto out_unlock;
>> +	}
>> +	ctrl->shash_tfm = crypto_alloc_shash(hash_name, 0,
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY);
>> +	if (IS_ERR(ctrl->shash_tfm)) {
>> +		pr_debug("failed to allocate shash %s\n", hash_name);
>> +		ret = PTR_ERR(ctrl->shash_tfm);
>> +		ctrl->shash_tfm = NULL;
>> +		goto out_unlock;
>> +	}
>> +
>> +	ctrl->dhchap_key = nvme_auth_extract_secret(host->dhchap_secret,
>> +						    &ctrl->dhchap_key_len);
>> +	if (IS_ERR(ctrl->dhchap_key)) {
>> +		pr_debug("failed to extract host key, error %d\n", ret);
>> +		ret = PTR_ERR(ctrl->dhchap_key);
>> +		ctrl->dhchap_key = NULL;
>> +		goto out_free_hash;
>> +	}
>> +	if (host->dhchap_key_hash) {
>> +		struct crypto_shash *key_tfm;
>> +
>> +		hash_name = nvme_auth_hmac_name(host->dhchap_key_hash);
>> +		key_tfm = crypto_alloc_shash(hash_name, 0, 0);
>> +		if (IS_ERR(key_tfm)) {
>> +			ret = PTR_ERR(key_tfm);
>> +			goto out_free_hash;
>> +		} else {
>> +			SHASH_DESC_ON_STACK(shash, key_tfm);
>> +
>> +			shash->tfm = key_tfm;
>> +			ret = crypto_shash_setkey(key_tfm, ctrl->dhchap_key,
>> +						  ctrl->dhchap_key_len);
>> +			crypto_shash_init(shash);
>> +			crypto_shash_update(shash, ctrl->subsys->subsysnqn,
>> +					    strlen(ctrl->subsys->subsysnqn));
>> +			crypto_shash_update(shash, "NVMe-over-Fabrics", 17);
>> +			crypto_shash_final(shash, ctrl->dhchap_key);
>> +			crypto_free_shash(key_tfm);
>> +		}
>> +	}
>> +	pr_debug("%s: using key %*ph\n", __func__,
>> +		 (int)ctrl->dhchap_key_len, ctrl->dhchap_key);
>> +	ret = crypto_shash_setkey(ctrl->shash_tfm, ctrl->dhchap_key,
> 
> Is it truly necessary to keep the key around in ctrl->dhchap_key? It looks to
> me that this buffer is only used here and thus could be turned into a local
> variable. Keys flying around in memory is not a good idea. :-)
> 
The key is also used when using the ffdhe algorithm.
Note: I _think_ that I need to use this key for the ffdhe algorithm, 
because the implementation I came up with is essentially plain DH with 
pre-defined 'p', 'q' and 'g' values. But the DH implementation also 
requires a 'key', and for that I'm using this key here.

It might be that I'm completely off, and don't need to use a key for our 
DH implementation. In that case you are correct.
(And that's why I said I'll need a review of the FFDHE implementation).
But for now I'll need the key for FFDHE.

>> +				  ctrl->dhchap_key_len);
>> +out_free_hash:
>> +	if (ret) {
>> +		if (ctrl->dhchap_key) {
>> +			kfree(ctrl->dhchap_key);
> 
> kfree_sensitive?
> 

Yes, will be fixing it.

>> +			ctrl->dhchap_key = NULL;
>> +		}
>> +		crypto_free_shash(ctrl->shash_tfm);
>> +		ctrl->shash_tfm = NULL;
>> +	}
>> +out_unlock:
>> +	up_read(&nvmet_config_sem);
>> +
>> +	return ret;
>> +}
>> +
>> +void nvmet_auth_sq_free(struct nvmet_sq *sq)
>> +{
>> +	if (sq->dhchap_c1)
>> +		kfree(sq->dhchap_c1);
>> +	if (sq->dhchap_c2)
>> +		kfree(sq->dhchap_c2);
>> +	if (sq->dhchap_skey)
>> +		kfree(sq->dhchap_skey);
> 
> kfree_sensitive?
> 

Yes.

>> +}
>> +
>> +void nvmet_reset_auth(struct nvmet_ctrl *ctrl)
>> +{
>> +	if (ctrl->shash_tfm) {
>> +		crypto_free_shash(ctrl->shash_tfm);
>> +		ctrl->shash_tfm = NULL;
>> +	}
>> +	if (ctrl->dh_tfm) {
>> +		crypto_free_kpp(ctrl->dh_tfm);
>> +		ctrl->dh_tfm = NULL;
>> +	}
>> +	if (ctrl->dhchap_key) {
>> +		kfree(ctrl->dhchap_key);
> 
> kfree_sensitive?
> 

Yes.

>> +		ctrl->dhchap_key = NULL;
>> +	}
>> +}
>> +
>> +bool nvmet_check_auth_status(struct nvmet_req *req)
>> +{
>> +	if (req->sq->ctrl->shash_tfm &&
>> +	    !req->sq->authenticated)
>> +		return false;
>> +	return true;
>> +}
>> +
>> +int nvmet_auth_host_hash(struct nvmet_req *req, u8 *response,
>> +			 unsigned int shash_len)
>> +{
>> +	struct nvmet_ctrl *ctrl = req->sq->ctrl;
>> +	SHASH_DESC_ON_STACK(shash, ctrl->shash_tfm);
>> +	u8 *challenge = req->sq->dhchap_c1;
>> +	u8 buf[4];
>> +	int ret;
>> +
>> +	if (ctrl->dh_gid != NVME_AUTH_DHCHAP_DHGROUP_NULL) {
>> +		ret = -ENOTSUPP;
>> +		goto out;
>> +	}
>> +
>> +	shash->tfm = ctrl->shash_tfm;
>> +	ret = crypto_shash_init(shash);
>> +	if (ret)
>> +		goto out;
>> +	ret = crypto_shash_update(shash, challenge, shash_len);
>> +	if (ret)
>> +		goto out;
>> +	put_unaligned_le32(req->sq->dhchap_s1, buf);
>> +	ret = crypto_shash_update(shash, buf, 4);
>> +	if (ret)
>> +		goto out;
>> +	put_unaligned_le16(req->sq->dhchap_tid, buf);
>> +	ret = crypto_shash_update(shash, buf, 2);
>> +	if (ret)
>> +		goto out;
>> +	memset(buf, 0, 4);
>> +	ret = crypto_shash_update(shash, buf, 1);
>> +	if (ret)
>> +		goto out;
>> +	ret = crypto_shash_update(shash, "HostHost", 8);
>> +	if (ret)
>> +		goto out;
>> +	ret = crypto_shash_update(shash, ctrl->hostnqn, strlen(ctrl->hostnqn));
>> +	if (ret)
>> +		goto out;
>> +	ret = crypto_shash_update(shash, buf, 1);
>> +	if (ret)
>> +		goto out;
>> +	ret = crypto_shash_update(shash, ctrl->subsysnqn,
>> +				  strlen(ctrl->subsysnqn));
>> +	if (ret)
>> +		goto out;
>> +	ret = crypto_shash_final(shash, response);
>> +out:
>> +	if (challenge != req->sq->dhchap_c1)
>> +		kfree(challenge);
>> +	return 0;
>> +}
>> +
>> +int nvmet_auth_ctrl_hash(struct nvmet_req *req, u8 *response,
>> +			 unsigned int shash_len)
>> +{
>> +	struct nvmet_ctrl *ctrl = req->sq->ctrl;
>> +	SHASH_DESC_ON_STACK(shash, ctrl->shash_tfm);
>> +	u8 *challenge = req->sq->dhchap_c2;
>> +	u8 buf[4];
>> +	int ret;
>> +
>> +	pr_debug("%s: ctrl %d hash seq %d transaction %u\n", __func__,
>> +		 ctrl->cntlid, req->sq->dhchap_s2, req->sq->dhchap_tid);
>> +	pr_debug("%s: ctrl %d challenge %*ph\n", __func__,
>> +		 ctrl->cntlid, shash_len, req->sq->dhchap_c2);
>> +	pr_debug("%s: ctrl %d subsysnqn %s\n", __func__,
>> +		 ctrl->cntlid, ctrl->subsysnqn);
>> +	pr_debug("%s: ctrl %d hostnqn %s\n", __func__,
>> +		 ctrl->cntlid, ctrl->hostnqn);
>> +
>> +	if (ctrl->dh_gid != NVME_AUTH_DHCHAP_DHGROUP_NULL) {
>> +		ret = -ENOTSUPP;
>> +		goto out;
>> +	}
>> +
>> +	shash->tfm = ctrl->shash_tfm;
>> +	ret = crypto_shash_init(shash);
>> +	if (ret)
>> +		goto out;
>> +	ret = crypto_shash_update(shash, challenge, shash_len);
>> +	if (ret)
>> +		goto out;
>> +	put_unaligned_le32(req->sq->dhchap_s2, buf);
>> +	ret = crypto_shash_update(shash, buf, 4);
>> +	if (ret)
>> +		goto out;
>> +	put_unaligned_le16(req->sq->dhchap_tid, buf);
>> +	ret = crypto_shash_update(shash, buf, 2);
>> +	if (ret)
>> +		goto out;
>> +	memset(buf, 0, 4);
>> +	ret = crypto_shash_update(shash, buf, 1);
>> +	if (ret)
>> +		goto out;
>> +	ret = crypto_shash_update(shash, "Controller", 10);
>> +	if (ret)
>> +		goto out;
>> +	ret = crypto_shash_update(shash, ctrl->subsysnqn,
>> +			    strlen(ctrl->subsysnqn));
>> +	if (ret)
>> +		goto out;
>> +	ret = crypto_shash_update(shash, buf, 1);
>> +	if (ret)
>> +		goto out;
>> +	ret = crypto_shash_update(shash, ctrl->hostnqn, strlen(ctrl->hostnqn));
>> +	if (ret)
>> +		goto out;
>> +	ret = crypto_shash_final(shash, response);
>> +out:
>> +	if (challenge != req->sq->dhchap_c2)
>> +		kfree(challenge);
>> +	return 0;
>> +}
>> +
>> +int nvmet_auth_ctrl_sesskey(struct nvmet_req *req,
>> +			    u8 *pkey, int pkey_size)
>> +{
>> +	struct nvmet_ctrl *ctrl = req->sq->ctrl;
>> +	struct kpp_request *kpp_req;
>> +	struct crypto_wait wait;
>> +	struct scatterlist src, dst;
>> +	int ret;
>> +
>> +	req->sq->dhchap_skey_len =
>> +		nvme_auth_dhgroup_privkey_size(ctrl->dh_gid);
>> +	req->sq->dhchap_skey = kzalloc(req->sq->dhchap_skey_len, GFP_KERNEL);
>> +	if (!req->sq->dhchap_skey)
>> +		return -ENOMEM;
>> +	kpp_req = kpp_request_alloc(ctrl->dh_tfm, GFP_KERNEL);
>> +	if (!kpp_req) {
>> +		kfree(req->sq->dhchap_skey);
>> +		req->sq->dhchap_skey = NULL;
>> +		return -ENOMEM;
>> +	}
>> +
>> +	pr_debug("%s: host public key %*ph\n", __func__,
>> +		 (int)pkey_size, pkey);
>> +	crypto_init_wait(&wait);
>> +	sg_init_one(&src, pkey, pkey_size);
>> +	kpp_request_set_input(kpp_req, &src, pkey_size);
>> +	sg_init_one(&dst, req->sq->dhchap_skey,
>> +		req->sq->dhchap_skey_len);
>> +	kpp_request_set_output(kpp_req, &dst, req->sq->dhchap_skey_len);
>> +	kpp_request_set_callback(kpp_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>> +				 crypto_req_done, &wait);
>> +
>> +	ret = crypto_wait_req(crypto_kpp_compute_shared_secret(kpp_req), &wait);
>> +	kpp_request_free(kpp_req);
>> +	if (ret)
>> +		pr_debug("failed to compute shared secred, err %d\n", ret);
>> +	else
>> +		pr_debug("%s: shared secret %*ph\n", __func__,
>> +			 (int)req->sq->dhchap_skey_len,
>> +			 req->sq->dhchap_skey);
>> +
>> +	return ret;
>> +}
>> diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
>> index 273555127188..e0760911a761 100644
>> --- a/drivers/nvme/target/configfs.c
>> +++ b/drivers/nvme/target/configfs.c
>> @@ -11,8 +11,13 @@
>>   #include <linux/ctype.h>
>>   #include <linux/pci.h>
>>   #include <linux/pci-p2pdma.h>
>> +#include <crypto/hash.h>
>> +#include <crypto/kpp.h>
>>
>>   #include "nvmet.h"
>> +#ifdef CONFIG_NVME_TARGET_AUTH
>> +#include "../host/auth.h"
>> +#endif
>>
>>   static const struct config_item_type nvmet_host_type;
>>   static const struct config_item_type nvmet_subsys_type;
>> @@ -1656,10 +1661,71 @@ static const struct config_item_type
>> nvmet_ports_type = { static struct config_group nvmet_subsystems_group;
>>   static struct config_group nvmet_ports_group;
>>
>> -static void nvmet_host_release(struct config_item *item)
>> +#ifdef CONFIG_NVME_TARGET_AUTH
>> +static ssize_t nvmet_host_dhchap_key_show(struct config_item *item,
>> +		char *page)
>> +{
>> +	u8 *dhchap_secret = to_host(item)->dhchap_secret;
>> +
>> +	if (!dhchap_secret)
>> +		return sprintf(page, "\n");
>> +	return sprintf(page, "%s\n", dhchap_secret);
>> +}
>> +
>> +static ssize_t nvmet_host_dhchap_key_store(struct config_item *item,
>> +		const char *page, size_t count)
>>   {
>>   	struct nvmet_host *host = to_host(item);
>> +	int ret;
>>
>> +	ret = nvmet_auth_set_host_key(host, page);
>> +	if (ret < 0)
>> +		return ret;
>> +	return count;
>> +}
>> +
>> +CONFIGFS_ATTR(nvmet_host_, dhchap_key);
>> +
>> +static ssize_t nvmet_host_dhchap_hash_show(struct config_item *item,
>> +		char *page)
>> +{
>> +	struct nvmet_host *host = to_host(item);
>> +	const char *hash_name = nvme_auth_hmac_name(host->dhchap_hash_id);
>> +
>> +	return sprintf(page, "%s\n", hash_name ? hash_name : "none");
>> +}
>> +
>> +static ssize_t nvmet_host_dhchap_hash_store(struct config_item *item,
>> +		const char *page, size_t count)
>> +{
>> +	struct nvmet_host *host = to_host(item);
>> +	int hmac_id;
>> +
>> +	hmac_id = nvme_auth_hmac_id(page);
>> +	if (hmac_id < 0)
>> +		return -EINVAL;
>> +	if (!crypto_has_shash(nvme_auth_hmac_name(hmac_id), 0, 0))
>> +		return -ENOTSUPP;
>> +	host->dhchap_hash_id = hmac_id;
>> +	return count;
>> +}
>> +
>> +CONFIGFS_ATTR(nvmet_host_, dhchap_hash);
>> +
>> +static struct configfs_attribute *nvmet_host_attrs[] = {
>> +	&nvmet_host_attr_dhchap_key,
>> +	&nvmet_host_attr_dhchap_hash,
>> +	NULL,
>> +};
>> +#endif /* CONFIG_NVME_TARGET_AUTH */
>> +
>> +static void nvmet_host_release(struct config_item *item)
>> +{
>> +	struct nvmet_host *host = to_host(item);
>> +#ifdef CONFIG_NVME_TARGET_AUTH
>> +	if (host->dhchap_secret)
>> +		kfree(host->dhchap_secret);
>> +#endif
>>   	kfree(host);
>>   }
>>
>> @@ -1669,6 +1735,9 @@ static struct configfs_item_operations
>> nvmet_host_item_ops = {
>>
>>   static const struct config_item_type nvmet_host_type = {
>>   	.ct_item_ops		= &nvmet_host_item_ops,
>> +#ifdef CONFIG_NVME_TARGET_AUTH
>> +	.ct_attrs		= nvmet_host_attrs,
>> +#endif
>>   	.ct_owner		= THIS_MODULE,
>>   };
>>
>> diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
>> index 163f7dc1a929..b5d7971f566b 100644
>> --- a/drivers/nvme/target/core.c
>> +++ b/drivers/nvme/target/core.c
>> @@ -793,6 +793,7 @@ void nvmet_sq_destroy(struct nvmet_sq *sq)
>>   	wait_for_completion(&sq->confirm_done);
>>   	wait_for_completion(&sq->free_done);
>>   	percpu_ref_exit(&sq->ref);
>> +	nvmet_auth_sq_free(sq);
>>
>>   	if (ctrl) {
>>   		/*
>> @@ -1264,6 +1265,11 @@ u16 nvmet_check_ctrl_status(struct nvmet_req *req)
>>   		       req->cmd->common.opcode, req->sq->qid);
>>   		return NVME_SC_CMD_SEQ_ERROR | NVME_SC_DNR;
>>   	}
>> +
>> +	if (unlikely(!nvmet_check_auth_status(req))) {
>> +		pr_warn("qid %d not authenticated\n", req->sq->qid);
>> +		return NVME_SC_AUTH_REQUIRED | NVME_SC_DNR;
>> +	}
>>   	return 0;
>>   }
>>
>> @@ -1456,6 +1462,8 @@ static void nvmet_ctrl_free(struct kref *ref)
>>   	flush_work(&ctrl->async_event_work);
>>   	cancel_work_sync(&ctrl->fatal_err_work);
>>
>> +	nvmet_reset_auth(ctrl);
>> +
>>   	ida_simple_remove(&cntlid_ida, ctrl->cntlid);
>>
>>   	nvmet_async_events_free(ctrl);
>> diff --git a/drivers/nvme/target/fabrics-cmd-auth.c
>> b/drivers/nvme/target/fabrics-cmd-auth.c new file mode 100644
>> index 000000000000..962f9f5e9d89
>> --- /dev/null
>> +++ b/drivers/nvme/target/fabrics-cmd-auth.c
>> @@ -0,0 +1,460 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * NVMe over Fabrics DH-HMAC-CHAP authentication command handling.
>> + * Copyright (c) 2020 Hannes Reinecke, SUSE Software Solutions.
>> + * All rights reserved.
>> + */
>> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> +#include <linux/blkdev.h>
>> +#include <linux/random.h>
>> +#include <crypto/hash.h>
>> +#include <crypto/kpp.h>
>> +#include "nvmet.h"
>> +#include "../host/auth.h"
>> +
>> +void nvmet_init_auth(struct nvmet_ctrl *ctrl, struct nvmet_req *req)
>> +{
>> +	/* Initialize in-band authentication */
>> +	req->sq->authenticated = false;
>> +	req->sq->dhchap_step = NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE;
>> +	req->cqe->result.u32 |= 0x2 << 16;
>> +}
>> +
>> +static u16 nvmet_auth_negotiate(struct nvmet_req *req, void *d)
>> +{
>> +	struct nvmet_ctrl *ctrl = req->sq->ctrl;
>> +	struct nvmf_auth_dhchap_negotiate_data *data = d;
>> +	int i, hash_id, null_dh = -1;
>> +
>> +	pr_debug("%s: ctrl %d qid %d: data sc_d %d napd %d authid %d halen %d
>> dhlen %d\n", +		 __func__, ctrl->cntlid, req->sq->qid,
>> +		 data->sc_c, data->napd, data->auth_protocol[0].dhchap.authid,
>> +		 data->auth_protocol[0].dhchap.halen,
>> +		 data->auth_protocol[0].dhchap.dhlen);
>> +	req->sq->dhchap_tid = le16_to_cpu(data->t_id);
>> +	if (data->sc_c)
>> +		return NVME_AUTH_DHCHAP_FAILURE_CONCAT_MISMATCH;
>> +
>> +	if (data->napd != 1)
>> +		return NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE;
>> +
>> +	if (data->auth_protocol[0].dhchap.authid != 0x01)
>> +		return NVME_AUTH_DHCHAP_FAILURE_INVALID_PAYLOAD;
>> +
>> +	hash_id = nvme_auth_hmac_id(crypto_shash_alg_name(ctrl->shash_tfm));
>> +	for (i = 0; i < data->auth_protocol[0].dhchap.halen; i++) {
>> +		pr_debug("%s: ctrl %d qid %d checking hash %d for %d\n",
>> +			 __func__, ctrl->cntlid, req->sq->qid,
>> +			 data->auth_protocol[0].dhchap.idlist[i], hash_id);
>> +		if (hash_id != data->auth_protocol[0].dhchap.idlist[i])
>> +			continue;
>> +		req->sq->dhchap_hash_id = hash_id;
>> +		req->sq->dhchap_hash_len = crypto_shash_digestsize(ctrl-
>> shash_tfm);
>> +		break;
>> +	}
>> +	if (req->sq->dhchap_hash_id == 0) {
>> +		pr_debug("%s: ctrl %d qid %d: no usable hash found\n",
>> +			 __func__, ctrl->cntlid, req->sq->qid);
>> +		return NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE;
>> +	}
>> +
>> +	for (i = data->auth_protocol[0].dhchap.halen;
>> +	     i < data->auth_protocol[0].dhchap.halen +
>> +		     data->auth_protocol[0].dhchap.dhlen; i++) {
>> +		int dhgid = data->auth_protocol[0].dhchap.idlist[i];
>> +
>> +		if (dhgid == NVME_AUTH_DHCHAP_DHGROUP_NULL) {
>> +			null_dh = dhgid;
>> +			continue;
>> +		}
>> +		if (nvmet_setup_dhgroup(ctrl, dhgid) == 0)
>> +			break;
>> +	}
>> +	if (!ctrl->dh_tfm && null_dh < 0) {
>> +		pr_debug("%s: ctrl %d qid %d: no DH group selected\n",
>> +			 __func__, ctrl->cntlid, req->sq->qid);
>> +		return NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
>> +	}
>> +	if (ctrl->dh_gid == -1) {
>> +		ctrl->dh_gid = null_dh;
>> +		ctrl->dh_tfm = NULL;
>> +	}
>> +	pr_debug("%s: ctrl %d qid %d: DH group %s (%d)\n",
>> +		 __func__, ctrl->cntlid, req->sq->qid,
>> +		 nvme_auth_dhgroup_name(ctrl->dh_gid), ctrl->dh_gid);
>> +	return 0;
>> +}
>> +
>> +static u16 nvmet_auth_reply(struct nvmet_req *req, void *d)
>> +{
>> +	struct nvmet_ctrl *ctrl = req->sq->ctrl;
>> +	struct nvmf_auth_dhchap_reply_data *data = d;
>> +	u8 *response;
>> +
>> +	pr_debug("%s: ctrl %d qid %d: data hl %d cvalid %d dhvlen %d\n",
>> +		 __func__, ctrl->cntlid, req->sq->qid,
>> +		 data->hl, data->cvalid, data->dhvlen);
>> +	if (data->hl != req->sq->dhchap_hash_len)
>> +		return NVME_AUTH_DHCHAP_FAILURE_INVALID_PAYLOAD;
>> +
>> +	if (data->dhvlen) {
>> +		return NVME_AUTH_DHCHAP_FAILURE_INVALID_PAYLOAD;
>> +	}
>> +
>> +	response = kmalloc(data->hl, GFP_KERNEL);
> 
> Again, align to CRYPTO_MINALIGN_ATTR?
> 

Ah, _that_ alignment.
Wasn't aware that I need to align to anything.
But if that's required, sure, I'll be fixing it.

>> +	if (!response)
>> +		return NVME_AUTH_DHCHAP_FAILURE_FAILED;
>> +
>> +	if (nvmet_auth_host_hash(req, response, data->hl) < 0) {
>> +		pr_debug("ctrl %d qid %d DH-HMAC-CHAP hash failed\n",
>> +			 ctrl->cntlid, req->sq->qid);
>> +		kfree(response);
>> +		return NVME_AUTH_DHCHAP_FAILURE_FAILED;
>> +	}
>> +
>> +	if (memcmp(data->rval, response, data->hl)) {
>> +		pr_info("ctrl %d qid %d DH-HMAC-CHAP response mismatch\n",
>> +			ctrl->cntlid, req->sq->qid);
>> +		kfree(response);
>> +		return NVME_AUTH_DHCHAP_FAILURE_FAILED;
>> +	}
>> +	kfree(response);
>> +	pr_info("ctrl %d qid %d DH-HMAC-CHAP host authenticated\n",
>> +		ctrl->cntlid, req->sq->qid);
>> +	if (data->cvalid) {
>> +		req->sq->dhchap_c2 = kmalloc(data->hl, GFP_KERNEL);
>> +		if (!req->sq->dhchap_c2)
>> +			return NVME_AUTH_DHCHAP_FAILURE_FAILED;
>> +		memcpy(req->sq->dhchap_c2, data->rval + data->hl, data->hl);
>> +
>> +		pr_debug("ctrl %d qid %d challenge %*ph\n",
>> +			 ctrl->cntlid, req->sq->qid, data->hl,
>> +			 req->sq->dhchap_c2);
>> +		req->sq->dhchap_s2 = le32_to_cpu(data->seqnum);
>> +	} else
>> +		req->sq->dhchap_c2 = NULL;
>> +
>> +	return 0;
>> +}
>> +
>> +static u16 nvmet_auth_failure2(struct nvmet_req *req, void *d)
>> +{
>> +	struct nvmf_auth_dhchap_failure_data *data = d;
>> +
>> +	return data->reason_code_explanation;
>> +}
>> +
>> +void nvmet_execute_auth_send(struct nvmet_req *req)
>> +{
>> +	struct nvmet_ctrl *ctrl = req->sq->ctrl;
>> +	struct nvmf_auth_dhchap_success2_data *data;
>> +	void *d;
>> +	u32 tl;
>> +	u16 status = 0;
>> +
>> +	if (req->cmd->auth_send.secp != NVME_AUTH_DHCHAP_PROTOCOL_IDENTIFIER) {
>> +		status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
>> +		req->error_loc =
>> +			offsetof(struct nvmf_auth_send_command, secp);
>> +		goto done;
>> +	}
>> +	if (req->cmd->auth_send.spsp0 != 0x01) {
>> +		status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
>> +		req->error_loc =
>> +			offsetof(struct nvmf_auth_send_command, spsp0);
>> +		goto done;
>> +	}
>> +	if (req->cmd->auth_send.spsp1 != 0x01) {
>> +		status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
>> +		req->error_loc =
>> +			offsetof(struct nvmf_auth_send_command, spsp1);
>> +		goto done;
>> +	}
>> +	tl = le32_to_cpu(req->cmd->auth_send.tl);
>> +	if (!tl) {
>> +		status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
>> +		req->error_loc =
>> +			offsetof(struct nvmf_auth_send_command, tl);
>> +		goto done;
>> +	}
>> +	if (!nvmet_check_transfer_len(req, tl)) {
>> +		pr_debug("%s: transfer length mismatch (%u)\n", __func__, tl);
>> +		return;
>> +	}
>> +
>> +	d = kmalloc(tl, GFP_KERNEL);
>> +	if (!d) {
>> +		status = NVME_SC_INTERNAL;
>> +		goto done;
>> +	}
>> +
>> +	status = nvmet_copy_from_sgl(req, 0, d, tl);
>> +	if (status) {
>> +		kfree(d);
>> +		goto done;
>> +	}
>> +
>> +	data = d;
>> +	pr_debug("%s: ctrl %d qid %d type %d id %d step %x\n", __func__,
>> +		 ctrl->cntlid, req->sq->qid, data->auth_type, data->auth_id,
>> +		 req->sq->dhchap_step);
>> +	if (data->auth_type != NVME_AUTH_COMMON_MESSAGES &&
>> +	    data->auth_type != NVME_AUTH_DHCHAP_MESSAGES) {
>> +		req->sq->dhchap_step = NVME_AUTH_DHCHAP_MESSAGE_FAILURE1;
>> +		req->sq->dhchap_status = NVME_AUTH_DHCHAP_FAILURE_INVALID_MESSAGE;
>> +	} else if (data->auth_type == NVME_AUTH_COMMON_MESSAGES) {
>> +		if (data->auth_id != req->sq->dhchap_step) {
>> +			req->sq->dhchap_step = NVME_AUTH_DHCHAP_MESSAGE_FAILURE1;
>> +			req->sq->dhchap_status =
> NVME_AUTH_DHCHAP_FAILURE_INVALID_MESSAGE;
>> +		} else if (data->auth_id != NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE) {
>> +			req->sq->dhchap_step = NVME_AUTH_DHCHAP_MESSAGE_FAILURE1;
>> +			req->sq->dhchap_status =
> NVME_AUTH_DHCHAP_FAILURE_INVALID_MESSAGE;
>> +		} else {
>> +			/* Validate negotiation parameters */
>> +			status = nvmet_auth_negotiate(req, d);
>> +			if (status == 0)
>> +				req->sq->dhchap_step =
> NVME_AUTH_DHCHAP_MESSAGE_CHALLENGE;
>> +			else {
>> +				req->sq->dhchap_step =
> NVME_AUTH_DHCHAP_MESSAGE_FAILURE1;
>> +				req->sq->dhchap_status = status;
>> +				status = 0;
>> +			}
>> +		}
>> +	} else if (data->auth_type == NVME_AUTH_DHCHAP_MESSAGES) {
>> +		if (data->auth_id != req->sq->dhchap_step) {
>> +			pr_debug("%s: ctrl %d qid %d step mismatch (%d != %d)\n",
>> +				 __func__, ctrl->cntlid, req->sq->qid,
>> +				 data->auth_id, req->sq->dhchap_step);
>> +			req->sq->dhchap_step = NVME_AUTH_DHCHAP_MESSAGE_FAILURE1;
>> +			req->sq->dhchap_status =
> NVME_AUTH_DHCHAP_FAILURE_INVALID_MESSAGE;
>> +		} else if (le16_to_cpu(data->t_id) != req->sq->dhchap_tid) {
>> +			pr_debug("%s: ctrl %d qid %d invalid transaction %d
> (expected %d)\n",
>> +				 __func__, ctrl->cntlid, req->sq->qid,
>> +				 le16_to_cpu(data->t_id),
>> +				 req->sq->dhchap_tid);
>> +			req->sq->dhchap_step = NVME_AUTH_DHCHAP_MESSAGE_FAILURE1;
>> +			req->sq->dhchap_status =
> NVME_AUTH_DHCHAP_FAILURE_INVALID_PAYLOAD;
>> +		} else {
>> +			switch (data->auth_id) {
>> +			case NVME_AUTH_DHCHAP_MESSAGE_REPLY:
>> +				status = nvmet_auth_reply(req, d);
>> +				if (status == 0)
>> +					req->sq->dhchap_step =
> NVME_AUTH_DHCHAP_MESSAGE_SUCCESS1;
>> +				else {
>> +					req->sq->dhchap_step =
> NVME_AUTH_DHCHAP_MESSAGE_FAILURE1;
>> +					req->sq->dhchap_status = status;
>> +					status = 0;
>> +				}
>> +				break;
>> +			case NVME_AUTH_DHCHAP_MESSAGE_SUCCESS2:
>> +				req->sq->authenticated = true;
>> +				pr_debug("%s: ctrl %d qid %d authenticated\n",
>> +					 __func__, ctrl->cntlid, req->sq->qid);
>> +				break;
>> +			case NVME_AUTH_DHCHAP_MESSAGE_FAILURE2:
>> +				status = nvmet_auth_failure2(req, d);
>> +				if (status) {
>> +					pr_warn("ctrl %d qid %d: DH-HMAC-CHAP
> negotiation failed (%d)\n",
>> +						ctrl->cntlid, req->sq->qid,
>> +						status);
>> +					req->sq->dhchap_status = status;
>> +					status = 0;
>> +				}
>> +				break;
>> +			default:
>> +				req->sq->dhchap_status =
> NVME_AUTH_DHCHAP_FAILURE_INVALID_MESSAGE;
>> +				req->sq->dhchap_step =
> NVME_AUTH_DHCHAP_MESSAGE_FAILURE2;
>> +				break;
>> +			}
>> +		}
>> +	} else {
>> +		req->sq->dhchap_status = NVME_AUTH_DHCHAP_FAILURE_INVALID_MESSAGE;
>> +		req->sq->dhchap_step = NVME_AUTH_DHCHAP_MESSAGE_FAILURE2;
>> +	}
>> +	kfree(d);
>> +done:
>> +	pr_debug("%s: ctrl %d qid %d dhchap status %x step %x\n", __func__,
>> +		 ctrl->cntlid, req->sq->qid,
>> +		 req->sq->dhchap_status, req->sq->dhchap_step);
>> +	if (status)
>> +		pr_debug("%s: ctrl %d qid %d nvme status %x error loc %d\n",
>> +			 __func__, ctrl->cntlid, req->sq->qid,
>> +			 status, req->error_loc);
>> +	req->cqe->result.u64 = 0;
>> +	nvmet_req_complete(req, status);
>> +	if (req->sq->dhchap_step != NVME_AUTH_DHCHAP_MESSAGE_SUCCESS2 &&
>> +	    req->sq->dhchap_step != NVME_AUTH_DHCHAP_MESSAGE_FAILURE2)
>> +		return;
>> +	/* Final states, clear up variables */
>> +	kfree(req->sq->dhchap_c1);
>> +	kfree(req->sq->dhchap_c2);
>> +	if (req->sq->dhchap_step == NVME_AUTH_DHCHAP_MESSAGE_FAILURE2)
>> +		nvmet_ctrl_fatal_error(ctrl);
>> +}
>> +
>> +static int nvmet_auth_challenge(struct nvmet_req *req, void *d, int al)
>> +{
>> +	struct nvmf_auth_dhchap_challenge_data *data = d;
>> +	struct nvmet_ctrl *ctrl = req->sq->ctrl;
>> +	int ret = 0;
>> +	int data_size = sizeof(*d) + req->sq->dhchap_hash_len;
>> +
>> +	if (al < data_size) {
>> +		pr_debug("%s: buffer too small (al %d need %d)\n", __func__,
>> +			 al, data_size);
>> +		return -EINVAL;
>> +	}
>> +	memset(data, 0, data_size);
>> +	req->sq->dhchap_s1 = ctrl->dhchap_seqnum++;
>> +	data->auth_type = NVME_AUTH_DHCHAP_MESSAGES;
>> +	data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_CHALLENGE;
>> +	data->t_id = cpu_to_le16(req->sq->dhchap_tid);
>> +	data->hashid = req->sq->dhchap_hash_id;
>> +	data->hl = req->sq->dhchap_hash_len;
>> +	data->seqnum = cpu_to_le32(req->sq->dhchap_s1);
>> +	req->sq->dhchap_c1 = kmalloc(data->hl, GFP_KERNEL);
>> +	if (!req->sq->dhchap_c1)
>> +		return -ENOMEM;
>> +	get_random_bytes(req->sq->dhchap_c1, data->hl);
>> +	memcpy(data->cval, req->sq->dhchap_c1, data->hl);
>> +	pr_debug("%s: ctrl %d qid %d seq %d transaction %d hl %d dhvlen %d\n",
>> +		 __func__, ctrl->cntlid, req->sq->qid, req->sq->dhchap_s1,
>> +		 req->sq->dhchap_tid, data->hl, data->dhvlen);
>> +	return ret;
>> +}
>> +
>> +static int nvmet_auth_success1(struct nvmet_req *req, void *d, int al)
>> +{
>> +	struct nvmf_auth_dhchap_success1_data *data = d;
>> +	struct nvmet_ctrl *ctrl = req->sq->ctrl;
>> +
>> +	WARN_ON(al < sizeof(*data));
>> +	memset(data, 0, sizeof(*data));
>> +	data->auth_type = NVME_AUTH_DHCHAP_MESSAGES;
>> +	data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_SUCCESS1;
>> +	data->t_id = cpu_to_le16(req->sq->dhchap_tid);
>> +	data->hl = req->sq->dhchap_hash_len;
>> +	if (req->sq->dhchap_c2) {
>> +		if (nvmet_auth_ctrl_hash(req, data->rval, data->hl))
>> +			return NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE;
>> +		data->rvalid = 1;
>> +		pr_debug("ctrl %d qid %d response %*ph\n",
>> +			 ctrl->cntlid, req->sq->qid, data->hl, data->rval);
>> +	}
>> +	return 0;
>> +}
>> +
>> +static void nvmet_auth_failure1(struct nvmet_req *req, void *d, int al)
>> +{
>> +	struct nvmf_auth_dhchap_failure_data *data = d;
>> +
>> +	WARN_ON(al < sizeof(*data));
>> +	data->auth_type = NVME_AUTH_COMMON_MESSAGES;
>> +	data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_FAILURE1;
>> +	data->t_id = cpu_to_le32(req->sq->dhchap_tid);
>> +	data->reason_code = NVME_AUTH_DHCHAP_FAILURE_REASON_FAILED;
>> +	data->reason_code_explanation = req->sq->dhchap_status;
>> +}
>> +
>> +void nvmet_execute_auth_receive(struct nvmet_req *req)
>> +{
>> +	struct nvmet_ctrl *ctrl = req->sq->ctrl;
>> +	void *d;
>> +	u32 al;
>> +	u16 status = 0;
>> +
>> +	if (req->cmd->auth_receive.secp != NVME_AUTH_DHCHAP_PROTOCOL_IDENTIFIER)
> {
>> +		status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
>> +		req->error_loc =
>> +			offsetof(struct nvmf_auth_receive_command, secp);
>> +		goto done;
>> +	}
>> +	if (req->cmd->auth_receive.spsp0 != 0x01) {
>> +		status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
>> +		req->error_loc =
>> +			offsetof(struct nvmf_auth_receive_command, spsp0);
>> +		goto done;
>> +	}
>> +	if (req->cmd->auth_receive.spsp1 != 0x01) {
>> +		status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
>> +		req->error_loc =
>> +			offsetof(struct nvmf_auth_receive_command, spsp1);
>> +		goto done;
>> +	}
>> +	al = le32_to_cpu(req->cmd->auth_receive.al);
>> +	if (!al) {
>> +		status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
>> +		req->error_loc =
>> +			offsetof(struct nvmf_auth_receive_command, al);
>> +		goto done;
>> +	}
>> +	if (!nvmet_check_transfer_len(req, al)) {
>> +		pr_debug("%s: transfer length mismatch (%u)\n", __func__, al);
>> +		return;
>> +	}
>> +
>> +	d = kmalloc(al, GFP_KERNEL);
>> +	if (!d) {
>> +		status = NVME_SC_INTERNAL;
>> +		goto done;
>> +	}
>> +	pr_debug("%s: ctrl %d qid %d step %x\n", __func__,
>> +		 ctrl->cntlid, req->sq->qid, req->sq->dhchap_step);
>> +	switch (req->sq->dhchap_step) {
>> +	case NVME_AUTH_DHCHAP_MESSAGE_CHALLENGE:
>> +		status = nvmet_auth_challenge(req, d, al);
>> +		if (status < 0) {
>> +			pr_warn("ctrl %d qid %d: challenge error (%d)\n",
>> +				ctrl->cntlid, req->sq->qid, status);
>> +			status = NVME_SC_INTERNAL;
>> +			break;
>> +		}
>> +		if (status) {
>> +			req->sq->dhchap_status = status;
>> +			nvmet_auth_failure1(req, d, al);
>> +			pr_warn("ctrl %d qid %d: challenge status (%x)\n",
>> +				ctrl->cntlid, req->sq->qid,
>> +				req->sq->dhchap_status);
>> +			status = 0;
>> +			break;
>> +		}
>> +		req->sq->dhchap_step = NVME_AUTH_DHCHAP_MESSAGE_REPLY;
>> +		break;
>> +	case NVME_AUTH_DHCHAP_MESSAGE_SUCCESS1:
>> +		status = nvmet_auth_success1(req, d, al);
>> +		if (status) {
>> +			req->sq->dhchap_status = status;
>> +			nvmet_auth_failure1(req, d, al);
>> +			pr_warn("ctrl %d qid %d: success1 status (%x)\n",
>> +				ctrl->cntlid, req->sq->qid,
>> +				req->sq->dhchap_status);
>> +			break;
>> +		}
>> +		req->sq->dhchap_step = NVME_AUTH_DHCHAP_MESSAGE_SUCCESS2;
>> +		break;
>> +	case NVME_AUTH_DHCHAP_MESSAGE_FAILURE1:
>> +		nvmet_auth_failure1(req, d, al);
>> +		pr_warn("ctrl %d qid %d failure1 (%x)\n",
>> +			ctrl->cntlid, req->sq->qid, req->sq->dhchap_status);
>> +		break;
>> +	default:
>> +		pr_warn("ctrl %d qid %d unhandled step (%d)\n",
>> +			ctrl->cntlid, req->sq->qid, req->sq->dhchap_step);
>> +		req->sq->dhchap_step = NVME_AUTH_DHCHAP_MESSAGE_FAILURE1;
>> +		req->sq->dhchap_status = NVME_AUTH_DHCHAP_FAILURE_FAILED;
>> +		nvmet_auth_failure1(req, d, al);
>> +		status = 0;
>> +		break;
>> +	}
>> +
>> +	status = nvmet_copy_to_sgl(req, 0, d, al);
>> +	kfree(d);
>> +done:
>> +	req->cqe->result.u64 = 0;
>> +	nvmet_req_complete(req, status);
>> +	if (req->sq->dhchap_step == NVME_AUTH_DHCHAP_MESSAGE_FAILURE1) {
>> +		kfree(req->sq->dhchap_c1);
>> +		kfree(req->sq->dhchap_c2);
>> +		nvmet_ctrl_fatal_error(ctrl);
>> +	}
>> +}
>> diff --git a/drivers/nvme/target/fabrics-cmd.c
>> b/drivers/nvme/target/fabrics-cmd.c index 7d0f3523fdab..53fb853cd8fe 100644
>> --- a/drivers/nvme/target/fabrics-cmd.c
>> +++ b/drivers/nvme/target/fabrics-cmd.c
>> @@ -93,6 +93,14 @@ u16 nvmet_parse_fabrics_cmd(struct nvmet_req *req)
>>   	case nvme_fabrics_type_property_get:
>>   		req->execute = nvmet_execute_prop_get;
>>   		break;
>> +#ifdef CONFIG_NVME_TARGET_AUTH
>> +	case nvme_fabrics_type_auth_send:
>> +		req->execute = nvmet_execute_auth_send;
>> +		break;
>> +	case nvme_fabrics_type_auth_receive:
>> +		req->execute = nvmet_execute_auth_receive;
>> +		break;
>> +#endif
>>   	default:
>>   		pr_debug("received unknown capsule type 0x%x\n",
>>   			cmd->fabrics.fctype);
>> @@ -155,6 +163,7 @@ static void nvmet_execute_admin_connect(struct nvmet_req
>> *req) struct nvmf_connect_data *d;
>>   	struct nvmet_ctrl *ctrl = NULL;
>>   	u16 status = 0;
>> +	int ret;
>>
>>   	if (!nvmet_check_transfer_len(req, sizeof(struct nvmf_connect_data)))
>>   		return;
>> @@ -197,17 +206,31 @@ static void nvmet_execute_admin_connect(struct
>> nvmet_req *req)
>>
>>   	uuid_copy(&ctrl->hostid, &d->hostid);
>>
>> +	ret = nvmet_setup_auth(ctrl, req);
>> +	if (ret < 0) {
>> +		pr_err("Failed to setup authentication, error %d\n", ret);
>> +		nvmet_ctrl_put(ctrl);
>> +		if (ret == -EPERM)
>> +			status = (NVME_SC_CONNECT_INVALID_HOST | NVME_SC_DNR);
>> +		else
>> +			status = NVME_SC_INTERNAL;
>> +		goto out;
>> +	}
>> +
>>   	status = nvmet_install_queue(ctrl, req);
>>   	if (status) {
>>   		nvmet_ctrl_put(ctrl);
>>   		goto out;
>>   	}
>>
>> -	pr_info("creating controller %d for subsystem %s for NQN %s%s.\n",
>> +	pr_info("creating controller %d for subsystem %s for NQN %s%s%s.\n",
>>   		ctrl->cntlid, ctrl->subsys->subsysnqn, ctrl->hostnqn,
>> -		ctrl->pi_support ? " T10-PI is enabled" : "");
>> +		ctrl->pi_support ? " T10-PI is enabled" : "",
>> +		nvmet_has_auth(ctrl) ? " with DH-HMAC-CHAP" : "");
>>   	req->cqe->result.u16 = cpu_to_le16(ctrl->cntlid);
>>
>> +	if (nvmet_has_auth(ctrl))
>> +		nvmet_init_auth(ctrl, req);
>>   out:
>>   	kfree(d);
>>   complete:
>> @@ -267,6 +290,9 @@ static void nvmet_execute_io_connect(struct nvmet_req
>> *req) }
>>
>>   	pr_debug("adding queue %d to ctrl %d.\n", qid, ctrl->cntlid);
>> +	req->cqe->result.u16 = cpu_to_le16(ctrl->cntlid);
>> +	if (nvmet_has_auth(ctrl))
>> +		nvmet_init_auth(ctrl, req);
>>
>>   out:
>>   	kfree(d);
>> diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
>> index 06dd3d537f07..ef8815e137d7 100644
>> --- a/drivers/nvme/target/nvmet.h
>> +++ b/drivers/nvme/target/nvmet.h
>> @@ -108,6 +108,20 @@ struct nvmet_sq {
>>   	u16			size;
>>   	u32			sqhd;
>>   	bool			sqhd_disabled;
>> +#ifdef CONFIG_NVME_TARGET_AUTH
>> +	bool			authenticated;
>> +	u16			dhchap_tid;
>> +	u16			dhchap_status;
>> +	int			dhchap_step;
>> +	u8			dhchap_hash_id;
>> +	u8			dhchap_hash_len;
>> +	u8			*dhchap_c1;
>> +	u8			*dhchap_c2;
>> +	u32			dhchap_s1;
>> +	u32			dhchap_s2;
>> +	u8			*dhchap_skey;
>> +	int			dhchap_skey_len;
>> +#endif
>>   	struct completion	free_done;
>>   	struct completion	confirm_done;
>>   };
>> @@ -209,6 +223,15 @@ struct nvmet_ctrl {
>>   	u64			err_counter;
>>   	struct nvme_error_slot	slots[NVMET_ERROR_LOG_SLOTS];
>>   	bool			pi_support;
>> +#ifdef CONFIG_NVME_TARGET_AUTH
>> +	u32			dhchap_seqnum;
>> +	u8			*dhchap_key;
>> +	size_t			dhchap_key_len;
>> +	struct crypto_shash	*shash_tfm;
>> +	struct crypto_kpp	*dh_tfm;
>> +	u32			dh_gid;
>> +	u32			dh_keysize;
>> +#endif
>>   };
>>
>>   struct nvmet_subsys {
>> @@ -270,6 +293,10 @@ static inline struct nvmet_subsys
>> *namespaces_to_subsys(
>>
>>   struct nvmet_host {
>>   	struct config_group	group;
>> +	u8			*dhchap_secret;
>> +	u8			dhchap_key_hash;
>> +	u8			dhchap_hash_id;
>> +	u8			dhchap_dhgroup_id;
>>   };
>>
>>   static inline struct nvmet_host *to_host(struct config_item *item)
>> @@ -659,4 +686,48 @@ static inline void nvmet_req_bio_put(struct nvmet_req
>> *req, struct bio *bio) bio_put(bio);
>>   }
>>
>> +#ifdef CONFIG_NVME_TARGET_AUTH
>> +void nvmet_execute_auth_send(struct nvmet_req *req);
>> +void nvmet_execute_auth_receive(struct nvmet_req *req);
>> +int nvmet_auth_set_host_key(struct nvmet_host *host, const char *secret);
>> +int nvmet_auth_set_host_hash(struct nvmet_host *host, const char *hash);
>> +int nvmet_setup_auth(struct nvmet_ctrl *ctrl, struct nvmet_req *req);
>> +void nvmet_init_auth(struct nvmet_ctrl *ctrl, struct nvmet_req *req);
>> +void nvmet_reset_auth(struct nvmet_ctrl *ctrl);
>> +void nvmet_auth_sq_free(struct nvmet_sq *sq);
>> +int nvmet_setup_dhgroup(struct nvmet_ctrl *ctrl, int dhgroup_id);
>> +bool nvmet_check_auth_status(struct nvmet_req *req);
>> +int nvmet_auth_host_hash(struct nvmet_req *req, u8 *response,
>> +			 unsigned int hash_len);
>> +int nvmet_auth_ctrl_hash(struct nvmet_req *req, u8 *response,
>> +			 unsigned int hash_len);
>> +static inline bool nvmet_has_auth(struct nvmet_ctrl *ctrl)
>> +{
>> +	return ctrl->shash_tfm != NULL;
>> +}
>> +int nvmet_auth_ctrl_exponential(struct nvmet_req *req,
>> +				u8 *buf, int buf_size);
>> +int nvmet_auth_ctrl_sesskey(struct nvmet_req *req,
>> +			    u8 *buf, int buf_size);
>> +#else
>> +static inline int nvmet_setup_auth(struct nvmet_ctrl *ctrl,
>> +				   struct nvmet_req *req)
>> +{
>> +	return 0;
>> +}
>> +static inline void nvmet_init_auth(struct nvmet_ctrl *ctrl,
>> +				   struct nvmet_req *req) {};
>> +static inline void nvmet_reset_auth(struct nvmet_ctrl *ctrl) {};
>> +static inline void nvmet_auth_sq_free(struct nvmet_sq *sq) {};
>> +static inline bool nvmet_check_auth_status(struct nvmet_req *req)
>> +{
>> +	return true;
>> +}
>> +static inline bool nvmet_has_auth(struct nvmet_ctrl *ctrl)
>> +{
>> +	return false;
>> +}
>> +static inline const char *nvmet_dhchap_dhgroup_name(int dhgid) { return
>> NULL; } +#endif
>> +
>>   #endif /* _NVMET_H */

Thanks for the review!

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
