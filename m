Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 433CAC636C9
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 09:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AE3760BD3
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 09:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234868AbhGSIyR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jul 2021 04:54:17 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:37870 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbhGSIyQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jul 2021 04:54:16 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 00AC2201DD;
        Mon, 19 Jul 2021 08:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626682558; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CkKkEFEO7GL1f2Tc0D1msIDEn+9GjNombpaOwhxqReo=;
        b=0Kz5/3DciuMtfmVX3i2J025Rdv64RJuY/y4pCii9RLuc8EV0W0UL86o9INpBLFq1ZZe+g6
        PMFehwnWeV2HV99znD58YopENcnsdvm94Q4Mp9zdCG2ebYJvud0BgS9LeI8bqaJscz1xm8
        50ClrTyDJyLJadJPVOPW8J7xk6aUglw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626682558;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CkKkEFEO7GL1f2Tc0D1msIDEn+9GjNombpaOwhxqReo=;
        b=D/jyiXNqkrW4yI0zmb+w7ibA9iv+OTO+g3qvDtv/CCLqemKQ9TTSkoJQFZflC0p4aKAwgn
        eNu8kD/GLHu6ItBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E2CF413CA7;
        Mon, 19 Jul 2021 08:15:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hxDhNr009WBsFgAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 19 Jul 2021 08:15:57 +0000
To:     =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <2510347.locV8n3378@positron.chronox.de>
 <a4d4bda0-2bc8-0d0c-3e81-55adecd6ce52@suse.de>
 <6538288.aohFRl0Q45@positron.chronox.de>
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/11] nvmet: Implement basic In-Band Authentication
Message-ID: <59695981-9edc-6b7a-480a-94cca95a0b8c@suse.de>
Date:   Mon, 19 Jul 2021 10:15:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <6538288.aohFRl0Q45@positron.chronox.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/18/21 2:56 PM, Stephan Müller wrote:
> Am Sonntag, 18. Juli 2021, 14:37:34 CEST schrieb Hannes Reinecke:
> 
> Hi Hannes,
> 
>> On 7/17/21 6:49 PM, Stephan Müller wrote:
>>> Am Freitag, 16. Juli 2021, 13:04:26 CEST schrieb Hannes Reinecke:
>>>
>>> Hi Hannes,
>>>
>>>> Implement support for NVMe-oF In-Band authentication. This patch
>>>> adds two additional configfs entries 'dhchap_key' and 'dhchap_hash'
>>>> to the 'host' configfs directory. The 'dhchap_key' needs to be
>>>> specified in the format outlined in the base spec.
>>>> Augmented challenge support is not implemented, and concatenation
>>>> with TLS encryption is not supported.
>>>>
>>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>>> ---
>>>>
>>>>   drivers/nvme/target/Kconfig            |  10 +
>>>>   drivers/nvme/target/Makefile           |   1 +
>>>>   drivers/nvme/target/admin-cmd.c        |   4 +
>>>>   drivers/nvme/target/auth.c             | 352 +++++++++++++++++++
>>>>   drivers/nvme/target/configfs.c         |  71 +++-
>>>>   drivers/nvme/target/core.c             |   8 +
>>>>   drivers/nvme/target/fabrics-cmd-auth.c | 460 +++++++++++++++++++++++++
>>>>   drivers/nvme/target/fabrics-cmd.c      |  30 +-
>>>>   drivers/nvme/target/nvmet.h            |  71 ++++
>>>>   9 files changed, 1004 insertions(+), 3 deletions(-)
>>>>   create mode 100644 drivers/nvme/target/auth.c
>>>>   create mode 100644 drivers/nvme/target/fabrics-cmd-auth.c
>>>>
>>>> diff --git a/drivers/nvme/target/Kconfig b/drivers/nvme/target/Kconfig
>>>> index 4be2ececbc45..d5656ef1559e 100644
>>>> --- a/drivers/nvme/target/Kconfig
>>>> +++ b/drivers/nvme/target/Kconfig
>>>> @@ -85,3 +85,13 @@ config NVME_TARGET_TCP
>>>>
>>>>   	  devices over TCP.
>>>>   	  
>>>>   	  If unsure, say N.
>>>>
>>>> +
>>>> +config NVME_TARGET_AUTH
>>>> +	bool "NVMe over Fabrics In-band Authentication support"
>>>> +	depends on NVME_TARGET
>>>> +	select CRYPTO_SHA256
>>>> +	select CRYPTO_SHA512
>>>> +	help
>>>> +	  This enables support for NVMe over Fabrics In-band Authentication
>>>> +
>>>> +	  If unsure, say N.
>>>> diff --git a/drivers/nvme/target/Makefile b/drivers/nvme/target/Makefile
>>>> index 9837e580fa7e..c66820102493 100644
>>>> --- a/drivers/nvme/target/Makefile
>>>> +++ b/drivers/nvme/target/Makefile
>>>> @@ -13,6 +13,7 @@ nvmet-y		+= core.o configfs.o admin-cmd.o
>>>
>>> fabrics-cmd.o \
>>>
>>>>   			discovery.o io-cmd-file.o io-cmd-bdev.o
>>>>   
>>>>   nvmet-$(CONFIG_NVME_TARGET_PASSTHRU)	+= passthru.o
>>>>   nvmet-$(CONFIG_BLK_DEV_ZONED)		+= zns.o
>>>>
>>>> +nvmet-$(CONFIG_NVME_TARGET_AUTH)	+= fabrics-cmd-auth.o auth.o
>>>>
>>>>   nvme-loop-y	+= loop.o
>>>>   nvmet-rdma-y	+= rdma.o
>>>>   nvmet-fc-y	+= fc.o
>>>>
>>>> diff --git a/drivers/nvme/target/admin-cmd.c
>>>> b/drivers/nvme/target/admin-cmd.c index 0cb98f2bbc8c..320cefc64ee0 100644
>>>> --- a/drivers/nvme/target/admin-cmd.c
>>>> +++ b/drivers/nvme/target/admin-cmd.c
>>>> @@ -1008,6 +1008,10 @@ u16 nvmet_parse_admin_cmd(struct nvmet_req *req)
>>>>
>>>>   	if (nvme_is_fabrics(cmd))
>>>>   	
>>>>   		return nvmet_parse_fabrics_cmd(req);
>>>>
>>>> +
>>>> +	if (unlikely(!nvmet_check_auth_status(req)))
>>>> +		return NVME_SC_AUTH_REQUIRED | NVME_SC_DNR;
>>>> +
>>>>
>>>>   	if (nvmet_req_subsys(req)->type == NVME_NQN_DISC)
>>>>   	
>>>>   		return nvmet_parse_discovery_cmd(req);
>>>>
>>>> diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
>>>> new file mode 100644
>>>> index 000000000000..00c7d051dfb1
>>>> --- /dev/null
>>>> +++ b/drivers/nvme/target/auth.c
>>>> @@ -0,0 +1,352 @@
>>>> +// SPDX-License-Identifier: GPL-2.0
>>>> +/*
>>>> + * NVMe over Fabrics DH-HMAC-CHAP authentication.
>>>> + * Copyright (c) 2020 Hannes Reinecke, SUSE Software Solutions.
>>>> + * All rights reserved.
>>>> + */
>>>> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>>>> +#include <linux/module.h>
>>>> +#include <linux/init.h>
>>>> +#include <linux/slab.h>
>>>> +#include <linux/err.h>
>>>> +#include <crypto/hash.h>
>>>> +#include <crypto/kpp.h>
>>>> +#include <crypto/dh.h>
>>>> +#include <crypto/ffdhe.h>
>>>> +#include <linux/crc32.h>
>>>> +#include <linux/base64.h>
>>>> +#include <linux/ctype.h>
>>>> +#include <linux/random.h>
>>>> +#include <asm/unaligned.h>
>>>> +
>>>> +#include "nvmet.h"
>>>> +#include "../host/auth.h"
>>>> +
>>>> +int nvmet_auth_set_host_key(struct nvmet_host *host, const char *secret)
>>>> +{
>>>> +	if (sscanf(secret, "DHHC-1:%hhd:%*s", &host->dhchap_key_hash) != 1)
>>>> +		return -EINVAL;
>>>> +	if (host->dhchap_key_hash > 3) {
>>>> +		pr_warn("Invalid DH-HMAC-CHAP hash id %d\n",
>>>> +			 host->dhchap_key_hash);
>>>> +		return -EINVAL;
>>>> +	}
>>>> +	if (host->dhchap_key_hash > 0) {
>>>> +		/* Validate selected hash algorithm */
>>>> +		const char *hmac = nvme_auth_hmac_name(host->dhchap_key_hash);
>>>> +
>>>> +		if (!crypto_has_shash(hmac, 0, 0)) {
>>>> +			pr_warn("DH-HMAC-CHAP hash %s unsupported\n", hmac);
>>>> +			host->dhchap_key_hash = -1;
>>>> +			return -EAGAIN;
>>>> +		}
>>>> +		/* Use this hash as default */
>>>> +		if (!host->dhchap_hash_id)
>>>> +			host->dhchap_hash_id = host->dhchap_key_hash;
>>>> +	}
>>>> +	host->dhchap_secret = kstrdup(secret, GFP_KERNEL);
>>>
>>> Just like before - are you sure that the secret is an ASCII string and no
>>> binary blob?
>>
>> That is ensured by the transport encoding (cf NVMe Base Specification
>> version 2.0). Also, this information is being passed in via the configfs
>> interface, so it's bounded by PAGE_SIZE. But yes, we should be inserting
>> a terminating 'NULL' character at the end of the page to ensure we don't
>> incur an buffer overrun. Any other failure will be checked for during
>> base64 decoding.
>>
>>>> +	if (!host->dhchap_secret)
>>>> +		return -ENOMEM;
>>>> +	/* Default to SHA256 */
>>>> +	if (!host->dhchap_hash_id)
>>>> +		host->dhchap_hash_id = NVME_AUTH_DHCHAP_HASH_SHA256;
>>>> +
>>>> +	pr_debug("Using hash %s\n",
>>>> +		 nvme_auth_hmac_name(host->dhchap_hash_id));
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +int nvmet_setup_dhgroup(struct nvmet_ctrl *ctrl, int dhgroup_id)
>>>> +{
>>>> +	int ret = -ENOTSUPP;
>>>> +
>>>> +	if (dhgroup_id == NVME_AUTH_DHCHAP_DHGROUP_NULL)
>>>> +		return 0;
>>>> +
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +int nvmet_setup_auth(struct nvmet_ctrl *ctrl, struct nvmet_req *req)
>>>> +{
>>>> +	int ret = 0;
>>>> +	struct nvmet_host_link *p;
>>>> +	struct nvmet_host *host = NULL;
>>>> +	const char *hash_name;
>>>> +
>>>> +	down_read(&nvmet_config_sem);
>>>> +	if (ctrl->subsys->type == NVME_NQN_DISC)
>>>> +		goto out_unlock;
>>>> +
>>>> +	list_for_each_entry(p, &ctrl->subsys->hosts, entry) {
>>>> +		pr_debug("check %s\n", nvmet_host_name(p->host));
>>>> +		if (strcmp(nvmet_host_name(p->host), ctrl->hostnqn))
>>>> +			continue;
>>>> +		host = p->host;
>>>> +		break;
>>>> +	}
>>>> +	if (!host) {
>>>> +		pr_debug("host %s not found\n", ctrl->hostnqn);
>>>> +		ret = -EPERM;
>>>> +		goto out_unlock;
>>>> +	}
>>>> +	if (!host->dhchap_secret) {
>>>> +		pr_debug("No authentication provided\n");
>>>> +		goto out_unlock;
>>>> +	}
>>>> +
>>>> +	hash_name = nvme_auth_hmac_name(host->dhchap_hash_id);
>>>> +	if (!hash_name) {
>>>> +		pr_debug("Hash ID %d invalid\n", host->dhchap_hash_id);
>>>> +		ret = -EINVAL;
>>>> +		goto out_unlock;
>>>> +	}
>>>> +	ctrl->shash_tfm = crypto_alloc_shash(hash_name, 0,
>>>> +					     CRYPTO_ALG_ALLOCATES_MEMORY);
>>>> +	if (IS_ERR(ctrl->shash_tfm)) {
>>>> +		pr_debug("failed to allocate shash %s\n", hash_name);
>>>> +		ret = PTR_ERR(ctrl->shash_tfm);
>>>> +		ctrl->shash_tfm = NULL;
>>>> +		goto out_unlock;
>>>> +	}
>>>> +
>>>> +	ctrl->dhchap_key = nvme_auth_extract_secret(host->dhchap_secret,
>>>> +						    &ctrl->dhchap_key_len);
>>>> +	if (IS_ERR(ctrl->dhchap_key)) {
>>>> +		pr_debug("failed to extract host key, error %d\n", ret);
>>>> +		ret = PTR_ERR(ctrl->dhchap_key);
>>>> +		ctrl->dhchap_key = NULL;
>>>> +		goto out_free_hash;
>>>> +	}
>>>> +	if (host->dhchap_key_hash) {
>>>> +		struct crypto_shash *key_tfm;
>>>> +
>>>> +		hash_name = nvme_auth_hmac_name(host->dhchap_key_hash);
>>>> +		key_tfm = crypto_alloc_shash(hash_name, 0, 0);
>>>> +		if (IS_ERR(key_tfm)) {
>>>> +			ret = PTR_ERR(key_tfm);
>>>> +			goto out_free_hash;
>>>> +		} else {
>>>> +			SHASH_DESC_ON_STACK(shash, key_tfm);
>>>> +
>>>> +			shash->tfm = key_tfm;
>>>> +			ret = crypto_shash_setkey(key_tfm, ctrl->dhchap_key,
>>>> +						  ctrl->dhchap_key_len);
>>>> +			crypto_shash_init(shash);
>>>> +			crypto_shash_update(shash, ctrl->subsys->subsysnqn,
>>>> +					    strlen(ctrl->subsys->subsysnqn));
>>>> +			crypto_shash_update(shash, "NVMe-over-Fabrics", 17);
>>>> +			crypto_shash_final(shash, ctrl->dhchap_key);
>>>> +			crypto_free_shash(key_tfm);
>>>> +		}
>>>> +	}
>>>> +	pr_debug("%s: using key %*ph\n", __func__,
>>>> +		 (int)ctrl->dhchap_key_len, ctrl->dhchap_key);
>>>> +	ret = crypto_shash_setkey(ctrl->shash_tfm, ctrl->dhchap_key,
>>>
>>> Is it truly necessary to keep the key around in ctrl->dhchap_key? It looks
>>> to me that this buffer is only used here and thus could be turned into a
>>> local variable. Keys flying around in memory is not a good idea. :-)
>>
>> The key is also used when using the ffdhe algorithm.
>> Note: I _think_ that I need to use this key for the ffdhe algorithm,
>> because the implementation I came up with is essentially plain DH with
>> pre-defined 'p', 'q' and 'g' values. But the DH implementation also
>> requires a 'key', and for that I'm using this key here.
>>
>> It might be that I'm completely off, and don't need to use a key for our
>> DH implementation. In that case you are correct.
>> (And that's why I said I'll need a review of the FFDHE implementation).
>> But for now I'll need the key for FFDHE.
> 
> Do I understand you correctly that the dhchap_key is used as the input to the 
> DH - i.e. it is the remote public key then? It looks strange that this is used 
> for DH but then it is changed here by hashing it together with something else 
> to form a new dhchap_key. Maybe that is what the protocol says. But it sounds 
> strange to me, especially when you think that dhchap_key would be, say, 2048 
> bits if it is truly the remote public key and then after the hashing it is 256 
> or 512 bits depending on the HMAC type. This means that after the hashing, 
> this dhchap_key cannot be used for FFC-DH.
> 
> Or are you using the dhchap_key for two different purposes?
> 
> It seems I miss something here.
> 
No, not entirely. It's me who buggered it up.
I got carried away by the fact that there is a crypto_dh_encode_key()
function, and thought I need to use it here.

Which I don't (apparently).
Will be fixing it up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
