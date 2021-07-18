Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15AC0C636C8
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Jul 2021 12:43:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1CDF61006
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Jul 2021 12:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhGRMqo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 18 Jul 2021 08:46:44 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47464 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbhGRMqn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 18 Jul 2021 08:46:43 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A1C912014D;
        Sun, 18 Jul 2021 12:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626612224; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7yjDNFb82tGNjfY2qM2Ae31LXERlSv4h1URJE4pQ5t8=;
        b=Tqg3TAbEuae+DTK9MxbJl3u/FSE0wJzZYWS/G7nfZqMeJUNAh5R5L84/qHyi481UVcSfoj
        BLdzz4f95zab4w/7B2ZYbpnbYRuD12cZWBRWBp9U0yQXnWitokiZfRCZLy+yIIp/1fx99D
        G6kCarJo3juQUTsuu9CAvS1xbmoiPcM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626612224;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7yjDNFb82tGNjfY2qM2Ae31LXERlSv4h1URJE4pQ5t8=;
        b=0hGuVJsQXPm8ca17FSbj/gwvRC1HLTnSI+F5BeVYoHdiOBUuzbHuIoIsgZ7RwYGnUJyfEa
        c3YRK61L0/gdqXDQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 742C613AD2;
        Sun, 18 Jul 2021 12:43:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id Eke0GgAi9GBgPgAAGKfGzw
        (envelope-from <hare@suse.de>); Sun, 18 Jul 2021 12:43:44 +0000
Subject: Re: [PATCH 06/11] nvme: Implement In-Band authentication
To:     =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <20210716110428.9727-7-hare@suse.de> <5959906.z61SFhVlds@positron.chronox.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <b90298b5-28e7-1a9a-6a8a-5ae3562c1bfa@suse.de>
Date:   Sun, 18 Jul 2021 14:43:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <5959906.z61SFhVlds@positron.chronox.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/17/21 6:49 PM, Stephan Müller wrote:
> Am Freitag, 16. Juli 2021, 13:04:23 CEST schrieb Hannes Reinecke:
> 
> Hi Hannes,
> 
>> Implement NVMe-oF In-Band authentication. This patch adds two new
>> fabric options 'dhchap_key' to specify the PSK and 'dhchap_authenticate'
>> to request bi-directional authentication of both the host and the
>> controller.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/nvme/host/Kconfig   |  11 +
>>   drivers/nvme/host/Makefile  |   1 +
>>   drivers/nvme/host/auth.c    | 813 ++++++++++++++++++++++++++++++++++++
>>   drivers/nvme/host/auth.h    |  23 +
>>   drivers/nvme/host/core.c    |  77 +++-
>>   drivers/nvme/host/fabrics.c |  65 ++-
>>   drivers/nvme/host/fabrics.h |   8 +
>>   drivers/nvme/host/nvme.h    |  15 +
>>   drivers/nvme/host/trace.c   |  32 ++
>>   9 files changed, 1041 insertions(+), 4 deletions(-)
>>   create mode 100644 drivers/nvme/host/auth.c
>>   create mode 100644 drivers/nvme/host/auth.h
>>
>> diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
>> index c3f3d77f1aac..853c546305e9 100644
>> --- a/drivers/nvme/host/Kconfig
>> +++ b/drivers/nvme/host/Kconfig
>> @@ -85,3 +85,14 @@ config NVME_TCP
>>   	  from https://github.com/linux-nvme/nvme-cli.
>>
>>   	  If unsure, say N.
>> +
>> +config NVME_AUTH
>> +	bool "NVM Express over Fabrics In-Band Authentication"
>> +	depends on NVME_TCP
>> +	select CRYPTO_SHA256
>> +	select CRYPTO_SHA512
> 
> What about adding CRYPTO_HMAC here?
> 

Yes, you are correct. Will be fixing it.

>> +	help
>> +	  This provides support for NVMe over Fabrics In-Band Authentication
>> +	  for the NVMe over TCP transport.
>> +
>> +	  If unsure, say N.
>> diff --git a/drivers/nvme/host/Makefile b/drivers/nvme/host/Makefile
>> index cbc509784b2e..03748a55a12b 100644
>> --- a/drivers/nvme/host/Makefile
>> +++ b/drivers/nvme/host/Makefile
>> @@ -20,6 +20,7 @@ nvme-core-$(CONFIG_NVME_HWMON)		+= hwmon.o
>>   nvme-y					+= pci.o
>>
>>   nvme-fabrics-y				+= fabrics.o
>> +nvme-fabrics-$(CONFIG_NVME_AUTH)	+= auth.o
>>
>>   nvme-rdma-y				+= rdma.o
>>
>> diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
>> new file mode 100644
>> index 000000000000..448a3adebea6
>> --- /dev/null
>> +++ b/drivers/nvme/host/auth.c
>> @@ -0,0 +1,813 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (c) 2020 Hannes Reinecke, SUSE Linux
>> + */
>> +
>> +#include <linux/crc32.h>
>> +#include <linux/base64.h>
>> +#include <asm/unaligned.h>
>> +#include <crypto/hash.h>
>> +#include <crypto/kpp.h>
>> +#include "nvme.h"
>> +#include "fabrics.h"
>> +#include "auth.h"
>> +
>> +static u32 nvme_dhchap_seqnum;
>> +
>> +struct nvme_dhchap_context {
>> +	struct crypto_shash *shash_tfm;
>> +	unsigned char *key;
>> +	size_t key_len;
>> +	int qid;
>> +	u32 s1;
>> +	u32 s2;
>> +	u16 transaction;
>> +	u8 status;
>> +	u8 hash_id;
>> +	u8 hash_len;
>> +	u8 c1[64];
>> +	u8 c2[64];
>> +	u8 response[64];
>> +	u8 *ctrl_key;
>> +	int ctrl_key_len;
>> +	u8 *host_key;
>> +	int host_key_len;
>> +	u8 *sess_key;
>> +	int sess_key_len;
>> +};
>> +
>> +struct nvmet_dhchap_hash_map {
>> +	int id;
>> +	int hash_len;
>> +	const char hmac[15];
>> +	const char digest[15];
>> +} hash_map[] = {
>> +	{.id = NVME_AUTH_DHCHAP_HASH_SHA256,
>> +	 .hash_len = 32,
>> +	 .hmac = "hmac(sha256)", .digest = "sha256" },
>> +	{.id = NVME_AUTH_DHCHAP_HASH_SHA384,
>> +	 .hash_len = 48,
>> +	 .hmac = "hmac(sha384)", .digest = "sha384" },
>> +	{.id = NVME_AUTH_DHCHAP_HASH_SHA512,
>> +	 .hash_len = 64,
>> +	 .hmac = "hmac(sha512)", .digest = "sha512" },
>> +};
>> +
>> +const char *nvme_auth_hmac_name(int hmac_id)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(hash_map); i++) {
>> +		if (hash_map[i].id == hmac_id)
>> +			return hash_map[i].hmac;
>> +	}
>> +	return NULL;
>> +}
>> +EXPORT_SYMBOL_GPL(nvme_auth_hmac_name);
>> +
>> +const char *nvme_auth_digest_name(int hmac_id)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(hash_map); i++) {
>> +		if (hash_map[i].id == hmac_id)
>> +			return hash_map[i].digest;
>> +	}
>> +	return NULL;
>> +}
>> +EXPORT_SYMBOL_GPL(nvme_auth_digest_name);
>> +
>> +int nvme_auth_hmac_len(int hmac_id)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(hash_map); i++) {
>> +		if (hash_map[i].id == hmac_id)
>> +			return hash_map[i].hash_len;
>> +	}
>> +	return -1;
>> +}
>> +EXPORT_SYMBOL_GPL(nvme_auth_hmac_len);
>> +
>> +int nvme_auth_hmac_id(const char *hmac_name)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(hash_map); i++) {
>> +		if (!strncmp(hash_map[i].hmac, hmac_name,
>> +			     strlen(hash_map[i].hmac)))
>> +			return hash_map[i].id;
>> +	}
>> +	return -1;
>> +}
>> +EXPORT_SYMBOL_GPL(nvme_auth_hmac_id);
>> +
>> +unsigned char *nvme_auth_extract_secret(unsigned char *dhchap_secret,
>> +					size_t *dhchap_key_len)
>> +{
>> +	unsigned char *dhchap_key;
>> +	u32 crc;
>> +	int key_len;
>> +	size_t allocated_len;
>> +
>> +	allocated_len = strlen(dhchap_secret) - 10;
> 
> Are you sure that the string is always at least 10 bytes long? If so, can you
> please add a comment to it?
> 
> Also, is it guaranteed that we have an ASCII string? Note, a secret sounds to
> be like a binary string which may contain \0 as an appropriate value.
> 

The string will always be in the transport encoding as specified in the 
NVMe Base specification v2.0. Any other string will be rejected by the 
ioctl interface.

>> +	dhchap_key = kzalloc(allocated_len, GFP_KERNEL);
> 
> What about aligning it to CRYPTO_MINALIGN_ATTR to save a memcpy in
> shash_final?
> 

Wasn't aware that I need to do that. Will be fixing it up.

>> +	if (!dhchap_key)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	key_len = base64_decode(dhchap_secret + 10,
>> +				allocated_len, dhchap_key);
>> +	if (key_len != 36 && key_len != 52 &&
>> +	    key_len != 68) {
>> +		pr_debug("Invalid DH-HMAC-CHAP key len %d\n",
>> +			 key_len);
>> +		kfree(dhchap_key);
>> +		return ERR_PTR(-EINVAL);
>> +	}
>> +	pr_debug("DH-HMAC-CHAP Key: %*ph\n",
>> +		 (int)key_len, dhchap_key);
>> +
>> +	/* The last four bytes is the CRC in little-endian format */
>> +	key_len -= 4;
>> +	/*
>> +	 * The linux implementation doesn't do pre- and post-increments,
>> +	 * so we have to do it manually.
>> +	 */
>> +	crc = ~crc32(~0, dhchap_key, key_len);
>> +
>> +	if (get_unaligned_le32(dhchap_key + key_len) != crc) {
>> +		pr_debug("DH-HMAC-CHAP crc mismatch (key %08x, crc %08x)\n",
>> +		       get_unaligned_le32(dhchap_key + key_len), crc);
>> +		kfree(dhchap_key);
>> +		return ERR_PTR(-EKEYREJECTED);
>> +	}
>> +	*dhchap_key_len = key_len;
>> +	return dhchap_key;
>> +}
>> +EXPORT_SYMBOL_GPL(nvme_auth_extract_secret);
>> +
>> +static int nvme_auth_send(struct nvme_ctrl *ctrl, int qid,
>> +			  void *data, size_t tl)
>> +{
>> +	struct nvme_command cmd = {};
>> +	blk_mq_req_flags_t flags = qid == NVME_QID_ANY ?
>> +		0 : BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_RESERVED;
>> +	struct request_queue *q = qid == NVME_QID_ANY ?
>> +		ctrl->fabrics_q : ctrl->connect_q;
>> +	int ret;
>> +
>> +	cmd.auth_send.opcode = nvme_fabrics_command;
>> +	cmd.auth_send.fctype = nvme_fabrics_type_auth_send;
>> +	cmd.auth_send.secp = NVME_AUTH_DHCHAP_PROTOCOL_IDENTIFIER;
>> +	cmd.auth_send.spsp0 = 0x01;
>> +	cmd.auth_send.spsp1 = 0x01;
>> +	cmd.auth_send.tl = tl;
>> +
>> +	ret = __nvme_submit_sync_cmd(q, &cmd, NULL, data, tl, 0, qid,
>> +				     0, flags);
>> +	if (ret)
>> +		dev_dbg(ctrl->device,
>> +			"%s: qid %d error %d\n", __func__, qid, ret);
>> +	return ret;
>> +}
>> +
>> +static int nvme_auth_receive(struct nvme_ctrl *ctrl, int qid,
>> +			     void *buf, size_t al,
>> +			     u16 transaction, u8 expected_msg )
>> +{
>> +	struct nvme_command cmd = {};
>> +	struct nvmf_auth_dhchap_failure_data *data = buf;
>> +	blk_mq_req_flags_t flags = qid == NVME_QID_ANY ?
>> +		0 : BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_RESERVED;
>> +	struct request_queue *q = qid == NVME_QID_ANY ?
>> +		ctrl->fabrics_q : ctrl->connect_q;
>> +	int ret;
>> +
>> +	cmd.auth_receive.opcode = nvme_fabrics_command;
>> +	cmd.auth_receive.fctype = nvme_fabrics_type_auth_receive;
>> +	cmd.auth_receive.secp = NVME_AUTH_DHCHAP_PROTOCOL_IDENTIFIER;
>> +	cmd.auth_receive.spsp0 = 0x01;
>> +	cmd.auth_receive.spsp1 = 0x01;
>> +	cmd.auth_receive.al = al;
>> +
>> +	ret = __nvme_submit_sync_cmd(q, &cmd, NULL, buf, al, 0, qid,
>> +				     0, flags);
>> +	if (ret > 0) {
>> +		dev_dbg(ctrl->device, "%s: qid %d nvme status %x\n",
>> +			__func__, qid, ret);
>> +		ret = -EIO;
>> +	}
>> +	if (ret < 0) {
>> +		dev_dbg(ctrl->device, "%s: qid %d error %d\n",
>> +			__func__, qid, ret);
>> +		return ret;
>> +	}
>> +	dev_dbg(ctrl->device, "%s: qid %d auth_type %d auth_id %x\n",
>> +		__func__, qid, data->auth_type, data->auth_id);
>> +	if (data->auth_type == NVME_AUTH_COMMON_MESSAGES &&
>> +	    data->auth_id == NVME_AUTH_DHCHAP_MESSAGE_FAILURE1) {
>> +		return data->reason_code_explanation;
>> +	}
>> +	if (data->auth_type != NVME_AUTH_DHCHAP_MESSAGES ||
>> +	    data->auth_id != expected_msg) {
>> +		dev_warn(ctrl->device,
>> +			 "qid %d invalid message %02x/%02x\n",
>> +			 qid, data->auth_type, data->auth_id);
>> +		return NVME_AUTH_DHCHAP_FAILURE_INVALID_PAYLOAD;
>> +	}
>> +	if (le16_to_cpu(data->t_id) != transaction) {
>> +		dev_warn(ctrl->device,
>> +			 "qid %d invalid transaction ID %d\n",
>> +			 qid, le16_to_cpu(data->t_id));
>> +		return NVME_AUTH_DHCHAP_FAILURE_INVALID_PAYLOAD;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int nvme_auth_dhchap_negotiate(struct nvme_ctrl *ctrl,
>> +				      struct nvme_dhchap_context *chap,
>> +				      void *buf, size_t buf_size)
>> +{
>> +	struct nvmf_auth_dhchap_negotiate_data *data = buf;
>> +	size_t size = sizeof(*data) + sizeof(union nvmf_auth_protocol);
>> +
>> +	if (buf_size < size)
>> +		return -EINVAL;
>> +
>> +	memset((u8 *)buf, 0, size);
>> +	data->auth_type = NVME_AUTH_COMMON_MESSAGES;
>> +	data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE;
>> +	data->t_id = cpu_to_le16(chap->transaction);
>> +	data->sc_c = 0; /* No secure channel concatenation */
>> +	data->napd = 1;
>> +	data->auth_protocol[0].dhchap.authid = NVME_AUTH_DHCHAP_AUTH_ID;
>> +	data->auth_protocol[0].dhchap.halen = 3;
>> +	data->auth_protocol[0].dhchap.dhlen = 1;
>> +	data->auth_protocol[0].dhchap.idlist[0] = NVME_AUTH_DHCHAP_HASH_SHA256;
>> +	data->auth_protocol[0].dhchap.idlist[1] = NVME_AUTH_DHCHAP_HASH_SHA384;
>> +	data->auth_protocol[0].dhchap.idlist[2] = NVME_AUTH_DHCHAP_HASH_SHA512;
>> +	data->auth_protocol[0].dhchap.idlist[3] = NVME_AUTH_DHCHAP_DHGROUP_NULL;
>> +
>> +	return size;
>> +}
>> +
>> +static int nvme_auth_dhchap_challenge(struct nvme_ctrl *ctrl,
>> +				      struct nvme_dhchap_context *chap,
>> +				      void *buf, size_t buf_size)
>> +{
>> +	struct nvmf_auth_dhchap_challenge_data *data = buf;
>> +	size_t size = sizeof(*data) + data->hl + data->dhvlen;
>> +	const char *gid_name;
>> +
>> +	if (buf_size < size) {
>> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_INVALID_PAYLOAD;
>> +		return -ENOMSG;
>> +	}
>> +
>> +	if (data->hashid != NVME_AUTH_DHCHAP_HASH_SHA256 &&
>> +	    data->hashid != NVME_AUTH_DHCHAP_HASH_SHA384 &&
>> +	    data->hashid != NVME_AUTH_DHCHAP_HASH_SHA512) {
>> +		dev_warn(ctrl->device,
>> +			 "qid %d: DH-HMAC-CHAP: invalid HASH ID %d\n",
>> +			 chap->qid, data->hashid);
>> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE;
>> +		return -EPROTO;
>> +	}
>> +	switch (data->dhgid) {
>> +	case NVME_AUTH_DHCHAP_DHGROUP_NULL:
>> +		gid_name = "null";
>> +		break;
>> +	default:
>> +		gid_name = NULL;
>> +		break;
>> +	}
>> +	if (!gid_name) {
>> +		dev_warn(ctrl->device,
>> +			 "qid %d: DH-HMAC-CHAP: invalid DH group id %d\n",
>> +			 chap->qid, data->dhgid);
>> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
>> +		return -EPROTO;
>> +	}
>> +	if (data->dhgid != NVME_AUTH_DHCHAP_DHGROUP_NULL) {
>> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
>> +		return -EPROTO;
>> +	}
>> +	if (data->dhgid == NVME_AUTH_DHCHAP_DHGROUP_NULL && data->dhvlen != 0) {
>> +		dev_warn(ctrl->device,
>> +			 "qid %d: DH-HMAC-CHAP: invalid DH value for NULL DH\n",
>> +			chap->qid);
>> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
>> +		return -EPROTO;
>> +	}
>> +	dev_dbg(ctrl->device, "%s: qid %d requested hash id %d\n",
>> +		__func__, chap->qid, data->hashid);
>> +	if (nvme_auth_hmac_len(data->hashid) != data->hl) {
>> +		dev_warn(ctrl->device,
>> +			 "qid %d: DH-HMAC-CHAP: invalid hash length\n",
>> +			chap->qid);
>> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE;
>> +		return -EPROTO;
>> +	}
>> +	chap->hash_id = data->hashid;
>> +	chap->hash_len = data->hl;
>> +	chap->s1 = le32_to_cpu(data->seqnum);
>> +	memcpy(chap->c1, data->cval, chap->hash_len);
>> +
>> +	return 0;
>> +}
>> +
>> +static int nvme_auth_dhchap_reply(struct nvme_ctrl *ctrl,
>> +				  struct nvme_dhchap_context *chap,
>> +				  void *buf, size_t buf_size)
>> +{
>> +	struct nvmf_auth_dhchap_reply_data *data = buf;
>> +	size_t size = sizeof(*data);
>> +
>> +	size += 2 * chap->hash_len;
>> +	if (ctrl->opts->dhchap_auth) {
>> +		get_random_bytes(chap->c2, chap->hash_len);
> 
> Why are you using CRYPTO_RNG_DEFAULT when you are using get_random_bytes here?
> 

Errm ... do I?
Seems that my crypto ignorance is showing here; 'get_random_bytes()' is 
the usual function we're using for drivers; if there is another way for 
crypto please enlighten me.

>> +		chap->s2 = nvme_dhchap_seqnum++;
>> +	} else
>> +		memset(chap->c2, 0, chap->hash_len);
>> +
>> +	if (chap->host_key_len)
>> +		size += chap->host_key_len;
>> +
>> +	if (buf_size < size)
>> +		return -EINVAL;
>> +
>> +	memset(buf, 0, size);
>> +	data->auth_type = NVME_AUTH_DHCHAP_MESSAGES;
>> +	data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_REPLY;
>> +	data->t_id = cpu_to_le16(chap->transaction);
>> +	data->hl = chap->hash_len;
>> +	data->dhvlen = chap->host_key_len;
>> +	data->seqnum = cpu_to_le32(chap->s2);
>> +	memcpy(data->rval, chap->response, chap->hash_len);
>> +	if (ctrl->opts->dhchap_auth) {
>> +		dev_dbg(ctrl->device, "%s: qid %d ctrl challenge %*ph\n",
>> +			__func__, chap->qid,
>> +			chap->hash_len, chap->c2);
>> +		data->cvalid = 1;
>> +		memcpy(data->rval + chap->hash_len, chap->c2,
>> +		       chap->hash_len);
>> +	}
>> +	if (chap->host_key_len)
>> +		memcpy(data->rval + 2 * chap->hash_len, chap->host_key,
>> +		       chap->host_key_len);
>> +
>> +	return size;
>> +}
>> +
>> +static int nvme_auth_dhchap_success1(struct nvme_ctrl *ctrl,
>> +				     struct nvme_dhchap_context *chap,
>> +				     void *buf, size_t buf_size)
>> +{
>> +	struct nvmf_auth_dhchap_success1_data *data = buf;
>> +	size_t size = sizeof(*data);
>> +
>> +	if (ctrl->opts->dhchap_auth)
>> +		size += chap->hash_len;
>> +
>> +
>> +	if (buf_size < size) {
>> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_INVALID_PAYLOAD;
>> +		return -ENOMSG;
>> +	}
>> +
>> +	if (data->hl != chap->hash_len) {
>> +		dev_warn(ctrl->device,
>> +			 "qid %d: DH-HMAC-CHAP: invalid hash length %d\n",
>> +			 chap->qid, data->hl);
>> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE;
>> +		return -EPROTO;
>> +	}
>> +
>> +	if (!data->rvalid)
>> +		return 0;
>> +
>> +	/* Validate controller response */
>> +	if (memcmp(chap->response, data->rval, data->hl)) {
>> +		dev_dbg(ctrl->device, "%s: qid %d ctrl response %*ph\n",
>> +			__func__, chap->qid, chap->hash_len, data->rval);
>> +		dev_dbg(ctrl->device, "%s: qid %d host response %*ph\n",
>> +			__func__, chap->qid, chap->hash_len, chap->response);
>> +		dev_warn(ctrl->device,
>> +			 "qid %d: DH-HMAC-CHAP: controller authentication failed\n",
>> +			 chap->qid);
>> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_INVALID_PAYLOAD;
>> +		return -EPROTO;
>> +	}
>> +	dev_info(ctrl->device,
>> +		 "qid %d: DH-HMAC-CHAP: controller authenticated\n",
>> +		chap->qid);
>> +	return 0;
>> +}
>> +
>> +static int nvme_auth_dhchap_success2(struct nvme_ctrl *ctrl,
>> +				     struct nvme_dhchap_context *chap,
>> +				     void *buf, size_t buf_size)
>> +{
>> +	struct nvmf_auth_dhchap_success2_data *data = buf;
>> +	size_t size = sizeof(*data);
>> +
>> +	memset(buf, 0, size);
>> +	data->auth_type = NVME_AUTH_DHCHAP_MESSAGES;
>> +	data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_SUCCESS2;
>> +	data->t_id = cpu_to_le16(chap->transaction);
>> +
>> +	return size;
>> +}
>> +
>> +static int nvme_auth_dhchap_failure2(struct nvme_ctrl *ctrl,
>> +				     struct nvme_dhchap_context *chap,
>> +				     void *buf, size_t buf_size)
>> +{
>> +	struct nvmf_auth_dhchap_failure_data *data = buf;
>> +	size_t size = sizeof(*data);
>> +
>> +	memset(buf, 0, size);
>> +	data->auth_type = NVME_AUTH_DHCHAP_MESSAGES;
>> +	data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_FAILURE2;
>> +	data->t_id = cpu_to_le16(chap->transaction);
>> +	data->reason_code = 1;
>> +	data->reason_code_explanation = chap->status;
>> +
>> +	return size;
>> +}
>> +
>> +int nvme_auth_select_hash(struct nvme_ctrl *ctrl,
>> +			  struct nvme_dhchap_context *chap)
>> +{
>> +	char *hash_name;
>> +	int ret;
>> +
>> +	switch (chap->hash_id) {
>> +	case NVME_AUTH_DHCHAP_HASH_SHA256:
>> +		hash_name = "hmac(sha256)";
>> +		break;
>> +	case NVME_AUTH_DHCHAP_HASH_SHA384:
>> +		hash_name = "hmac(sha384)";
>> +		break;
>> +	case NVME_AUTH_DHCHAP_HASH_SHA512:
>> +		hash_name = "hmac(sha512)";
>> +		break;
>> +	default:
>> +		hash_name = NULL;
>> +		break;
>> +	}
>> +	if (!hash_name) {
>> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_NOT_USABLE;
>> +		return -EPROTO;
>> +	}
>> +	chap->shash_tfm = crypto_alloc_shash(hash_name, 0,
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY);
>> +	if (IS_ERR(chap->shash_tfm)) {
>> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_NOT_USABLE;
>> +		chap->shash_tfm = NULL;
>> +		return -EPROTO;
>> +	}
>> +	if (!chap->key) {
>> +		dev_warn(ctrl->device, "qid %d: cannot select hash, no key\n",
>> +			 chap->qid);
>> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_NOT_USABLE;
>> +		crypto_free_shash(chap->shash_tfm);
>> +		chap->shash_tfm = NULL;
>> +		return -EINVAL;
>> +	}
>> +	ret = crypto_shash_setkey(chap->shash_tfm, chap->key, chap->key_len);
>> +	if (ret) {
>> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_NOT_USABLE;
>> +		crypto_free_shash(chap->shash_tfm);
>> +		chap->shash_tfm = NULL;
>> +		return ret;
>> +	}
>> +	dev_info(ctrl->device, "qid %d: DH-HMAC_CHAP: selected hash %s\n",
>> +		 chap->qid, hash_name);
>> +	return 0;
>> +}
>> +
>> +static int nvme_auth_dhchap_host_response(struct nvme_ctrl *ctrl,
>> +					  struct nvme_dhchap_context *chap)
>> +{
>> +	SHASH_DESC_ON_STACK(shash, chap->shash_tfm);
>> +	u8 buf[4], *challenge = chap->c1;
>> +	int ret;
>> +
>> +	dev_dbg(ctrl->device, "%s: qid %d host response seq %d transaction
> %d\n",
>> +		__func__, chap->qid, chap->s1, chap->transaction);
>> +	shash->tfm = chap->shash_tfm;
>> +	ret = crypto_shash_init(shash);
>> +	if (ret)
>> +		goto out;
>> +	ret = crypto_shash_update(shash, challenge, chap->hash_len);
>> +	if (ret)
>> +		goto out;
>> +	put_unaligned_le32(chap->s1, buf);
>> +	ret = crypto_shash_update(shash, buf, 4);
>> +	if (ret)
>> +		goto out;
>> +	put_unaligned_le16(chap->transaction, buf);
>> +	ret = crypto_shash_update(shash, buf, 2);
>> +	if (ret)
>> +		goto out;
>> +	memset(buf, 0, sizeof(buf));
>> +	ret = crypto_shash_update(shash, buf, 1);
>> +	if (ret)
>> +		goto out;
>> +	ret = crypto_shash_update(shash, "HostHost", 8);
>> +	if (ret)
>> +		goto out;
>> +	ret = crypto_shash_update(shash, ctrl->opts->host->nqn,
>> +				  strlen(ctrl->opts->host->nqn));
>> +	if (ret)
>> +		goto out;
>> +	ret = crypto_shash_update(shash, buf, 1);
>> +	if (ret)
>> +		goto out;
>> +	ret = crypto_shash_update(shash, ctrl->opts->subsysnqn,
>> +			    strlen(ctrl->opts->subsysnqn));
>> +	if (ret)
>> +		goto out;
>> +	ret = crypto_shash_final(shash, chap->response);
>> +out:
>> +	return ret;
>> +}
>> +
>> +static int nvme_auth_dhchap_ctrl_response(struct nvme_ctrl *ctrl,
>> +					  struct nvme_dhchap_context *chap)
>> +{
>> +	SHASH_DESC_ON_STACK(shash, chap->shash_tfm);
>> +	u8 buf[4], *challenge = chap->c2;
>> +	int ret;
>> +
>> +	dev_dbg(ctrl->device, "%s: qid %d host response seq %d transaction
> %d\n",
>> +		__func__, chap->qid, chap->s2, chap->transaction);
>> +	dev_dbg(ctrl->device, "%s: qid %d challenge %*ph\n",
>> +		__func__, chap->qid, chap->hash_len, challenge);
>> +	dev_dbg(ctrl->device, "%s: qid %d subsysnqn %s\n",
>> +		__func__, chap->qid, ctrl->opts->subsysnqn);
>> +	dev_dbg(ctrl->device, "%s: qid %d hostnqn %s\n",
>> +		__func__, chap->qid, ctrl->opts->host->nqn);
>> +	shash->tfm = chap->shash_tfm;
>> +	ret = crypto_shash_init(shash);
>> +	if (ret)
>> +		goto out;
>> +	ret = crypto_shash_update(shash, challenge, chap->hash_len);
>> +	if (ret)
>> +		goto out;
>> +	put_unaligned_le32(chap->s2, buf);
>> +	ret = crypto_shash_update(shash, buf, 4);
>> +	if (ret)
>> +		goto out;
>> +	put_unaligned_le16(chap->transaction, buf);
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
>> +	ret = crypto_shash_update(shash, ctrl->opts->subsysnqn,
>> +				  strlen(ctrl->opts->subsysnqn));
>> +	if (ret)
>> +		goto out;
>> +	ret = crypto_shash_update(shash, buf, 1);
>> +	if (ret)
>> +		goto out;
>> +	ret = crypto_shash_update(shash, ctrl->opts->host->nqn,
>> +				  strlen(ctrl->opts->host->nqn));
>> +	if (ret)
>> +		goto out;
>> +	ret = crypto_shash_final(shash, chap->response);
>> +out:
>> +	return ret;
>> +}
>> +
>> +int nvme_auth_generate_key(struct nvme_ctrl *ctrl,
>> +			   struct nvme_dhchap_context *chap)
>> +{
>> +	int ret;
>> +	u8 key_hash;
>> +	const char *hmac_name;
>> +	struct crypto_shash *key_tfm;
>> +
>> +	if (sscanf(ctrl->opts->dhchap_secret, "DHHC-1:%hhd:%*s:",
>> +		   &key_hash) != 1)
>> +		return -EINVAL;
>> +
>> +	chap->key = nvme_auth_extract_secret(ctrl->opts->dhchap_secret,
>> +					     &chap->key_len);
>> +	if (IS_ERR(chap->key)) {
>> +		ret = PTR_ERR(chap->key);
>> +		chap->key = NULL;
>> +		return ret;
>> +	}
>> +
>> +	if (key_hash == 0)
>> +		return 0;
>> +
>> +	hmac_name = nvme_auth_hmac_name(key_hash);
>> +	if (!hmac_name) {
>> +		pr_debug("Invalid key hash id %d\n", key_hash);
>> +		return -EKEYREJECTED;
>> +	}
>> +
>> +	key_tfm = crypto_alloc_shash(hmac_name, 0, 0);
>> +	if (IS_ERR(key_tfm)) {
>> +		kfree(chap->key);
>> +		chap->key = NULL;
>> +		ret = PTR_ERR(key_tfm);
>> +	} else {
>> +		SHASH_DESC_ON_STACK(shash, key_tfm);
>> +
>> +		shash->tfm = key_tfm;
>> +		ret = crypto_shash_setkey(key_tfm, chap->key,
>> +					  chap->key_len);
>> +		if (ret < 0) {
>> +			crypto_free_shash(key_tfm);
>> +			kfree(chap->key);
>> +			chap->key = NULL;
>> +			return ret;
>> +		}
>> +		crypto_shash_init(shash);
>> +		crypto_shash_update(shash, ctrl->opts->host->nqn,
>> +				    strlen(ctrl->opts->host->nqn));
>> +		crypto_shash_update(shash, "NVMe-over-Fabrics", 17);
>> +		crypto_shash_final(shash, chap->key);
>> +		crypto_free_shash(key_tfm);
>> +	}
>> +	return 0;
>> +}
>> +
>> +void nvme_auth_free(struct nvme_dhchap_context *chap)
>> +{
>> +	if (chap->shash_tfm)
>> +		crypto_free_shash(chap->shash_tfm);
>> +	if (chap->key)
>> +		kfree(chap->key);
>> +	if (chap->ctrl_key)
>> +		kfree(chap->ctrl_key);
>> +	if (chap->host_key)
>> +		kfree(chap->host_key);
>> +	if (chap->sess_key)
>> +		kfree(chap->sess_key);
>> +	kfree(chap);
> 
> kfree_sensitive in all cases as all buffers have sensitive data?
> 

Yes, will be fixing it up.

>> +}
>> +
>> +int nvme_auth_negotiate(struct nvme_ctrl *ctrl, int qid)
>> +{
>> +	struct nvme_dhchap_context *chap;
>> +	void *buf;
>> +	size_t buf_size, tl;
>> +	int ret = 0;
>> +
>> +	chap = kzalloc(sizeof(*chap), GFP_KERNEL);
> 
> Suggestion: make sure that chap->response is aligned to CRYPTO_MINALIGN_ATTR -
> then you would save a memcpy in crypto_shash_final
> 

Ok.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
