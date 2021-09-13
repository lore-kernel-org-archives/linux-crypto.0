Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-24.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB6EC433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Sep 2021 14:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C89060E08
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Sep 2021 14:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344643AbhIMOgz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Sep 2021 10:36:55 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:36814 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347620AbhIMOfI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Sep 2021 10:35:08 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6B7E61FFF3;
        Mon, 13 Sep 2021 14:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1631543629; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m+cKYDqbN1hfJpxPVdUZwY4A4uTNJ4ohno+8htWkd/Q=;
        b=uHrDxLgGlWP2uf5nSgEmqGZb59v/LyptRLeMWN5mAbkNnty5aX/Mg/4FkZ+krWgGhjauNo
        LLiWBob6/6IZWl+Su9UJ7fLO0wmqCWahnO4LIDLcoNyzbvzmJRRiPXvT1CpGKmTmVvX3LM
        G/FIGxqPxmoQEq/PF+IO5N1oz/ug9s8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1631543629;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m+cKYDqbN1hfJpxPVdUZwY4A4uTNJ4ohno+8htWkd/Q=;
        b=1d5S6Wch0ovgUBHK0pyzW4uEPB8xbbO2obMowCdtXqgaZtu8F7x/mKy6felDN4P5NaiXjz
        CAapje14+qoi/PAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 49A3313AB9;
        Mon, 13 Sep 2021 14:33:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6IS3EU1hP2H8ZwAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 13 Sep 2021 14:33:49 +0000
To:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210910064322.67705-1-hare@suse.de>
 <20210910064322.67705-8-hare@suse.de>
 <99cbf790-c276-b3d0-6140-1f5bfa8665eb@grimberg.me>
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/12] nvme: Implement In-Band authentication
Message-ID: <8bff9a88-a5d4-d7bb-8ce9-81d30438bfbb@suse.de>
Date:   Mon, 13 Sep 2021 16:33:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <99cbf790-c276-b3d0-6140-1f5bfa8665eb@grimberg.me>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/13/21 3:55 PM, Sagi Grimberg wrote:
> 
> 
> On 9/10/21 9:43 AM, Hannes Reinecke wrote:
>> Implement NVMe-oF In-Band authentication according to NVMe TPAR 8006.
>> This patch adds two new fabric options 'dhchap_secret' to specify the
>> pre-shared key (in ASCII respresentation according to NVMe 2.0 section
>> 8.13.5.8 'Secret representation') and 'dhchap_bidi' to request
>> bi-directional
>> authentication of both the host and the controller.
>> Re-authentication can be triggered by writing the PSK into the new
>> controller sysfs attribute 'dhchap_secret'.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/nvme/host/Kconfig   |   12 +
>>   drivers/nvme/host/Makefile  |    1 +
>>   drivers/nvme/host/auth.c    | 1285 +++++++++++++++++++++++++++++++++++
>>   drivers/nvme/host/auth.h    |   25 +
>>   drivers/nvme/host/core.c    |   79 ++-
>>   drivers/nvme/host/fabrics.c |   73 +-
>>   drivers/nvme/host/fabrics.h |    6 +
>>   drivers/nvme/host/nvme.h    |   30 +
>>   drivers/nvme/host/trace.c   |   32 +
>>   9 files changed, 1537 insertions(+), 6 deletions(-)
>>   create mode 100644 drivers/nvme/host/auth.c
>>   create mode 100644 drivers/nvme/host/auth.h
>>
>> diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
>> index dc0450ca23a3..97e8412dc42d 100644
>> --- a/drivers/nvme/host/Kconfig
>> +++ b/drivers/nvme/host/Kconfig
>> @@ -83,3 +83,15 @@ config NVME_TCP
>>         from https://github.com/linux-nvme/nvme-cli.
>>           If unsure, say N.
>> +
>> +config NVME_AUTH
>> +    bool "NVM Express over Fabrics In-Band Authentication"
>> +    depends on NVME_CORE
>> +    select CRYPTO_HMAC
>> +    select CRYPTO_SHA256
>> +    select CRYPTO_SHA512
>> +    help
>> +      This provides support for NVMe over Fabrics In-Band Authentication
>> +      for the NVMe over TCP transport.
> 
> Not tcp specific...
> 
>> diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
>> new file mode 100644
>> index 000000000000..5393ac16a002
>> --- /dev/null
>> +++ b/drivers/nvme/host/auth.c
>> @@ -0,0 +1,1285 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (c) 2020 Hannes Reinecke, SUSE Linux
>> + */
>> +
>> +#include <linux/crc32.h>
>> +#include <linux/base64.h>
>> +#include <asm/unaligned.h>
>> +#include <crypto/hash.h>
>> +#include <crypto/dh.h>
>> +#include <crypto/ffdhe.h>
>> +#include "nvme.h"
>> +#include "fabrics.h"
>> +#include "auth.h"
>> +
>> +static u32 nvme_dhchap_seqnum;
>> +
>> +struct nvme_dhchap_queue_context {
>> +    struct list_head entry;
>> +    struct work_struct auth_work;
>> +    struct nvme_ctrl *ctrl;
>> +    struct crypto_shash *shash_tfm;
>> +    struct crypto_kpp *dh_tfm;
>> +    void *buf;
>> +    size_t buf_size;
>> +    int qid;
>> +    int error;
>> +    u32 s1;
>> +    u32 s2;
>> +    u16 transaction;
>> +    u8 status;
>> +    u8 hash_id;
>> +    u8 hash_len;
>> +    u8 dhgroup_id;
>> +    u8 c1[64];
>> +    u8 c2[64];
>> +    u8 response[64];
>> +    u8 *host_response;
>> +};
>> +
>> +static struct nvme_auth_dhgroup_map {
>> +    int id;
>> +    const char name[16];
>> +    const char kpp[16];
>> +    int privkey_size;
>> +    int pubkey_size;
>> +} dhgroup_map[] = {
>> +    { .id = NVME_AUTH_DHCHAP_DHGROUP_NULL,
>> +      .name = "NULL", .kpp = "NULL",
> 
> Nit, no need for all-caps, can do "null"
> 
Right. Will be doing so.

[ .. ]
>> +unsigned char *nvme_auth_extract_secret(unsigned char *secret, size_t
>> *out_len)
>> +{
>> +    unsigned char *key;
>> +    u32 crc;
>> +    int key_len;
>> +    size_t allocated_len;
>> +
>> +    allocated_len = strlen(secret);
> 
> Can move to declaration initializer.
> 
Sure.

>> +    key = kzalloc(allocated_len, GFP_KERNEL);
>> +    if (!key)
>> +        return ERR_PTR(-ENOMEM);
>> +
>> +    key_len = base64_decode(secret, allocated_len, key);
>> +    if (key_len != 36 && key_len != 52 &&
>> +        key_len != 68) {
>> +        pr_debug("Invalid DH-HMAC-CHAP key len %d\n",
>> +             key_len);
>> +        kfree_sensitive(key);
>> +        return ERR_PTR(-EINVAL);
>> +    }
>> +
>> +    /* The last four bytes is the CRC in little-endian format */
>> +    key_len -= 4;
>> +    /*
>> +     * The linux implementation doesn't do pre- and post-increments,
>> +     * so we have to do it manually.
>> +     */
>> +    crc = ~crc32(~0, key, key_len);
>> +
>> +    if (get_unaligned_le32(key + key_len) != crc) {
>> +        pr_debug("DH-HMAC-CHAP key crc mismatch (key %08x, crc %08x)\n",
>> +               get_unaligned_le32(key + key_len), crc);
>> +        kfree_sensitive(key);
>> +        return ERR_PTR(-EKEYREJECTED);
>> +    }
>> +    *out_len = key_len;
>> +    return key;
>> +}
>> +EXPORT_SYMBOL_GPL(nvme_auth_extract_secret);
>> +
>> +u8 *nvme_auth_transform_key(u8 *key, size_t key_len, u8 key_hash,
>> char *nqn)
>> +{
>> +    const char *hmac_name = nvme_auth_hmac_name(key_hash);
>> +    struct crypto_shash *key_tfm;
>> +    struct shash_desc *shash;
>> +    u8 *transformed_key;
>> +    int ret;
>> +
>> +    /* No key transformation required */
>> +    if (key_hash == 0)
>> +        return 0;
>> +
>> +    hmac_name = nvme_auth_hmac_name(key_hash);
>> +    if (!hmac_name) {
>> +        pr_warn("Invalid key hash id %d\n", key_hash);
>> +        return ERR_PTR(-EKEYREJECTED);
>> +    }
> 
> newline here.
> 
>> +    key_tfm = crypto_alloc_shash(hmac_name, 0, 0);
>> +    if (IS_ERR(key_tfm))
>> +        return (u8 *)key_tfm;
>> +
>> +    shash = kmalloc(sizeof(struct shash_desc) +
>> +            crypto_shash_descsize(key_tfm),
>> +            GFP_KERNEL);
>> +    if (!shash) {
>> +        crypto_free_shash(key_tfm);
>> +        return ERR_PTR(-ENOMEM);
>> +    }
> 
> newline here.
> 
>> +    transformed_key = kzalloc(crypto_shash_digestsize(key_tfm),
>> GFP_KERNEL);
>> +    if (!transformed_key) {
>> +        ret = -ENOMEM;
>> +        goto out_free_shash;
>> +    }
>> +
>> +    shash->tfm = key_tfm;
>> +    ret = crypto_shash_setkey(key_tfm, key, key_len);
>> +    if (ret < 0)
>> +        goto out_free_shash;
>> +    ret = crypto_shash_init(shash);
>> +    if (ret < 0)
>> +        goto out_free_shash;
>> +    ret = crypto_shash_update(shash, nqn, strlen(nqn));
>> +    if (ret < 0)
>> +        goto out_free_shash;
>> +    ret = crypto_shash_update(shash, "NVMe-over-Fabrics", 17);
>> +    if (ret < 0)
>> +        goto out_free_shash;
>> +    ret = crypto_shash_final(shash, transformed_key);
>> +out_free_shash:
>> +    kfree(shash);
>> +    crypto_free_shash(key_tfm);
>> +    if (ret < 0) {
>> +        kfree_sensitive(transformed_key);
>> +        return ERR_PTR(ret);
>> +    }
> 
> Any reason why this is not a reverse cleanup with goto call-sites
> standard style?
> 
None in particular.
Will be doing so.

>> +    return transformed_key;
>> +}
>> +EXPORT_SYMBOL_GPL(nvme_auth_transform_key);
>> +
>> +static int nvme_auth_hash_skey(int hmac_id, u8 *skey, size_t
>> skey_len, u8 *hkey)
>> +{
>> +    const char *digest_name;
>> +    struct crypto_shash *tfm;
>> +    int ret;
>> +
>> +    digest_name = nvme_auth_digest_name(hmac_id);
>> +    if (!digest_name) {
>> +        pr_debug("%s: failed to get digest for %d\n", __func__,
>> +             hmac_id);
>> +        return -EINVAL;
>> +    }
>> +    tfm = crypto_alloc_shash(digest_name, 0, 0);
>> +    if (IS_ERR(tfm))
>> +        return -ENOMEM;
>> +
>> +    ret = crypto_shash_tfm_digest(tfm, skey, skey_len, hkey);
>> +    if (ret < 0)
>> +        pr_debug("%s: Failed to hash digest len %zu\n", __func__,
>> +             skey_len);
>> +
>> +    crypto_free_shash(tfm);
>> +    return ret;
>> +}
>> +
>> +int nvme_auth_augmented_challenge(u8 hmac_id, u8 *skey, size_t skey_len,
>> +        u8 *challenge, u8 *aug, size_t hlen)
>> +{
>> +    struct crypto_shash *tfm;
>> +    struct shash_desc *desc;
>> +    u8 *hashed_key;
>> +    const char *hmac_name;
>> +    int ret;
>> +
>> +    hashed_key = kmalloc(hlen, GFP_KERNEL);
>> +    if (!hashed_key)
>> +        return -ENOMEM;
>> +
>> +    ret = nvme_auth_hash_skey(hmac_id, skey,
>> +                  skey_len, hashed_key);
>> +    if (ret < 0)
>> +        goto out_free_key;
>> +
>> +    hmac_name = nvme_auth_hmac_name(hmac_id);
>> +    if (!hmac_name) {
>> +        pr_warn("%s: invalid hash algoritm %d\n",
>> +            __func__, hmac_id);
>> +        ret = -EINVAL;
>> +        goto out_free_key;
>> +    }
> 
> newline.
> 
>> +    tfm = crypto_alloc_shash(hmac_name, 0, 0);
>> +    if (IS_ERR(tfm)) {
>> +        ret = PTR_ERR(tfm);
>> +        goto out_free_key;
>> +    }
> 
> newline
> 
>> +    desc = kmalloc(sizeof(struct shash_desc) +
>> crypto_shash_descsize(tfm),
>> +               GFP_KERNEL);
>> +    if (!desc) {
>> +        ret = -ENOMEM;
>> +        goto out_free_hash;
>> +    }
>> +    desc->tfm = tfm;
>> +
>> +    ret = crypto_shash_setkey(tfm, hashed_key, hlen);
>> +    if (ret)
>> +        goto out_free_desc;
>> +
>> +    ret = crypto_shash_init(desc);
>> +    if (ret)
>> +        goto out_free_desc;
>> +
>> +    ret = crypto_shash_update(desc, challenge, hlen);
>> +    if (ret)
>> +        goto out_free_desc;
>> +
>> +    ret = crypto_shash_final(desc, aug);
>> +out_free_desc:
>> +    kfree_sensitive(desc);
>> +out_free_hash:
>> +    crypto_free_shash(tfm);
>> +out_free_key:
>> +    kfree_sensitive(hashed_key);
>> +    return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(nvme_auth_augmented_challenge);
>> +
>> +int nvme_auth_gen_privkey(struct crypto_kpp *dh_tfm, int dh_gid)
>> +{
>> +    char *pkey;
>> +    int ret, pkey_len;
>> +
>> +    if (dh_gid == NVME_AUTH_DHCHAP_DHGROUP_2048 ||
>> +        dh_gid == NVME_AUTH_DHCHAP_DHGROUP_3072 ||
>> +        dh_gid == NVME_AUTH_DHCHAP_DHGROUP_4096 ||
>> +        dh_gid == NVME_AUTH_DHCHAP_DHGROUP_6144 ||
>> +        dh_gid == NVME_AUTH_DHCHAP_DHGROUP_8192) {
>> +        struct dh p = {0};
>> +        int bits = nvme_auth_dhgroup_pubkey_size(dh_gid) << 3;
>> +        int dh_secret_len = 64;
>> +        u8 *dh_secret = kzalloc(dh_secret_len, GFP_KERNEL);
>> +
>> +        if (!dh_secret)
>> +            return -ENOMEM;
>> +
>> +        /*
>> +         * NVMe base spec v2.0: The DH value shall be set to the value
>> +         * of g^x mod p, where 'x' is a random number selected by the
>> +         * host that shall be at least 256 bits long.
>> +         *
>> +         * We will be using a 512 bit random number as private key.
>> +         * This is large enough to provide adequate security, but
>> +         * small enough such that we can trivially conform to
>> +         * NIST SB800-56A section 5.6.1.1.4 if
>> +         * we guarantee that the random number is not either
>> +         * all 0xff or all 0x00. But that should be guaranteed
>> +         * by the in-kernel RNG anyway.
>> +         */
>> +        get_random_bytes(dh_secret, dh_secret_len);
>> +
>> +        ret = crypto_ffdhe_params(&p, bits);
>> +        if (ret) {
>> +            kfree_sensitive(dh_secret);
>> +            return ret;
>> +        }
>> +
>> +        p.key = dh_secret;
>> +        p.key_size = dh_secret_len;
>> +
>> +        pkey_len = crypto_dh_key_len(&p);
>> +        pkey = kmalloc(pkey_len, GFP_KERNEL);
>> +        if (!pkey) {
>> +            kfree_sensitive(dh_secret);
>> +            return -ENOMEM;
>> +        }
>> +
>> +        get_random_bytes(pkey, pkey_len);
>> +        ret = crypto_dh_encode_key(pkey, pkey_len, &p);
>> +        if (ret) {
>> +            pr_debug("failed to encode private key, error %d\n",
>> +                 ret);
>> +            kfree_sensitive(dh_secret);
>> +            goto out;
>> +        }
>> +    } else {
>> +        pr_warn("invalid dh group %d\n", dh_gid);
>> +        return -EINVAL;
>> +    }
>> +    ret = crypto_kpp_set_secret(dh_tfm, pkey, pkey_len);
>> +    if (ret)
>> +        pr_debug("failed to set private key, error %d\n", ret);
>> +out:
>> +    kfree_sensitive(pkey);
> 
> pkey can be unset here.
> 
Okay.

>> +    return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(nvme_auth_gen_privkey);
>> +
>> +int nvme_auth_gen_pubkey(struct crypto_kpp *dh_tfm,
>> +        u8 *host_key, size_t host_key_len)
>> +{
>> +    struct kpp_request *req;
>> +    struct crypto_wait wait;
>> +    struct scatterlist dst;
>> +    int ret;
>> +
>> +    req = kpp_request_alloc(dh_tfm, GFP_KERNEL);
>> +    if (!req)
>> +        return -ENOMEM;
>> +
>> +    crypto_init_wait(&wait);
>> +    kpp_request_set_input(req, NULL, 0);
>> +    sg_init_one(&dst, host_key, host_key_len);
>> +    kpp_request_set_output(req, &dst, host_key_len);
>> +    kpp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>> +                 crypto_req_done, &wait);
>> +
>> +    ret = crypto_wait_req(crypto_kpp_generate_public_key(req), &wait);
>> +
> 
> no need for this newline
> 
>> +    kpp_request_free(req);
>> +    return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(nvme_auth_gen_pubkey);
>> +
>> +int nvme_auth_gen_shared_secret(struct crypto_kpp *dh_tfm,
>> +        u8 *ctrl_key, size_t ctrl_key_len,
>> +        u8 *sess_key, size_t sess_key_len)
>> +{
>> +    struct kpp_request *req;
>> +    struct crypto_wait wait;
>> +    struct scatterlist src, dst;
>> +    int ret;
>> +
>> +    req = kpp_request_alloc(dh_tfm, GFP_KERNEL);
>> +    if (!req)
>> +        return -ENOMEM;
>> +
>> +    crypto_init_wait(&wait);
>> +    sg_init_one(&src, ctrl_key, ctrl_key_len);
>> +    kpp_request_set_input(req, &src, ctrl_key_len);
>> +    sg_init_one(&dst, sess_key, sess_key_len);
>> +    kpp_request_set_output(req, &dst, sess_key_len);
>> +    kpp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>> +                 crypto_req_done, &wait);
>> +
>> +    ret = crypto_wait_req(crypto_kpp_compute_shared_secret(req), &wait);
>> +
>> +    kpp_request_free(req);
>> +    return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(nvme_auth_gen_shared_secret);
>> +
>> +static int nvme_auth_send(struct nvme_ctrl *ctrl, int qid,
>> +        void *data, size_t tl)
>> +{
>> +    struct nvme_command cmd = {};
>> +    blk_mq_req_flags_t flags = qid == NVME_QID_ANY ?
>> +        0 : BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_RESERVED;
>> +    struct request_queue *q = qid == NVME_QID_ANY ?
>> +        ctrl->fabrics_q : ctrl->connect_q;
>> +    int ret;
>> +
>> +    cmd.auth_send.opcode = nvme_fabrics_command;
>> +    cmd.auth_send.fctype = nvme_fabrics_type_auth_send;
>> +    cmd.auth_send.secp = NVME_AUTH_DHCHAP_PROTOCOL_IDENTIFIER;
>> +    cmd.auth_send.spsp0 = 0x01;
>> +    cmd.auth_send.spsp1 = 0x01;
>> +    cmd.auth_send.tl = tl;
>> +
>> +    ret = __nvme_submit_sync_cmd(q, &cmd, NULL, data, tl, 0, qid,
>> +                     0, flags);
>> +    if (ret > 0)
>> +        dev_dbg(ctrl->device,
>> +            "%s: qid %d nvme status %d\n", __func__, qid, ret);
>> +    else if (ret < 0)
>> +        dev_dbg(ctrl->device,
>> +            "%s: qid %d error %d\n", __func__, qid, ret);
>> +    return ret;
>> +}
>> +
>> +static int nvme_auth_receive(struct nvme_ctrl *ctrl, int qid,
>> +        void *buf, size_t al)
>> +{
>> +    struct nvme_command cmd = {};
>> +    blk_mq_req_flags_t flags = qid == NVME_QID_ANY ?
>> +        0 : BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_RESERVED;
>> +    struct request_queue *q = qid == NVME_QID_ANY ?
>> +        ctrl->fabrics_q : ctrl->connect_q;
>> +    int ret;
>> +
>> +    cmd.auth_receive.opcode = nvme_fabrics_command;
>> +    cmd.auth_receive.fctype = nvme_fabrics_type_auth_receive;
>> +    cmd.auth_receive.secp = NVME_AUTH_DHCHAP_PROTOCOL_IDENTIFIER;
>> +    cmd.auth_receive.spsp0 = 0x01;
>> +    cmd.auth_receive.spsp1 = 0x01;
>> +    cmd.auth_receive.al = al;
>> +
>> +    ret = __nvme_submit_sync_cmd(q, &cmd, NULL, buf, al, 0, qid,
>> +                     0, flags);
>> +    if (ret > 0) {
>> +        dev_dbg(ctrl->device, "%s: qid %d nvme status %x\n",
>> +            __func__, qid, ret);
>> +        ret = -EIO;
> 
> Why EIO?
> 
See next comment.

>> +    }
>> +    if (ret < 0) {
>> +        dev_dbg(ctrl->device, "%s: qid %d error %d\n",
>> +            __func__, qid, ret);
>> +        return ret;
>> +    }
> 
> Why did you choose to do these error conditionals differently for the
> send and receive functions?
> 
Because we have _three_ kinds of errors here: error codes, NVMe status,
and authentication status.
And of course the authentication status is _not_ an NVMe status, so we
can't easily overload both into a single value.
As the authentication status will be set from the received data I chose
to fold all NVMe status onto -EIO, leaving the positive value free for
authentication status.

>> +
>> +    return 0;
>> +}
>> +
>> +static int nvme_auth_receive_validate(struct nvme_ctrl *ctrl, int qid,
>> +        struct nvmf_auth_dhchap_failure_data *data,
>> +        u16 transaction, u8 expected_msg)
>> +{
>> +    dev_dbg(ctrl->device, "%s: qid %d auth_type %d auth_id %x\n",
>> +        __func__, qid, data->auth_type, data->auth_id);
>> +
>> +    if (data->auth_type == NVME_AUTH_COMMON_MESSAGES &&
>> +        data->auth_id == NVME_AUTH_DHCHAP_MESSAGE_FAILURE1) {
>> +        return data->rescode_exp;
>> +    }
>> +    if (data->auth_type != NVME_AUTH_DHCHAP_MESSAGES ||
>> +        data->auth_id != expected_msg) {
>> +        dev_warn(ctrl->device,
>> +             "qid %d invalid message %02x/%02x\n",
>> +             qid, data->auth_type, data->auth_id);
>> +        return NVME_AUTH_DHCHAP_FAILURE_INCORRECT_MESSAGE;
>> +    }
>> +    if (le16_to_cpu(data->t_id) != transaction) {
>> +        dev_warn(ctrl->device,
>> +             "qid %d invalid transaction ID %d\n",
>> +             qid, le16_to_cpu(data->t_id));
>> +        return NVME_AUTH_DHCHAP_FAILURE_INCORRECT_MESSAGE;
>> +    }
>> +    return 0;
>> +}
>> +
>> +static int nvme_auth_set_dhchap_negotiate_data(struct nvme_ctrl *ctrl,
>> +        struct nvme_dhchap_queue_context *chap)
>> +{
>> +    struct nvmf_auth_dhchap_negotiate_data *data = chap->buf;
>> +    size_t size = sizeof(*data) + sizeof(union nvmf_auth_protocol);
>> +
>> +    if (chap->buf_size < size) {
>> +        chap->status = NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
> 
> Is this an internal error? not sure I understand setting of this status
> 
As mentioned above, we now have three possible status codes to content
with. So yes, this is an internal error, expressed as authentication
error code.

The spec insists on using an authentication error here; it would be
possible to use a normal NVMe status, but that's not what the spec wants ...

>> +        return -EINVAL;
>> +    }
>> +    memset((u8 *)chap->buf, 0, size);
>> +    data->auth_type = NVME_AUTH_COMMON_MESSAGES;
>> +    data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE;
>> +    data->t_id = cpu_to_le16(chap->transaction);
>> +    data->sc_c = 0; /* No secure channel concatenation */
>> +    data->napd = 1;
>> +    data->auth_protocol[0].dhchap.authid = NVME_AUTH_DHCHAP_AUTH_ID;
>> +    data->auth_protocol[0].dhchap.halen = 3;
>> +    data->auth_protocol[0].dhchap.dhlen = 6;
>> +    data->auth_protocol[0].dhchap.idlist[0] = NVME_AUTH_DHCHAP_SHA256;
>> +    data->auth_protocol[0].dhchap.idlist[1] = NVME_AUTH_DHCHAP_SHA384;
>> +    data->auth_protocol[0].dhchap.idlist[2] = NVME_AUTH_DHCHAP_SHA512;
>> +    data->auth_protocol[0].dhchap.idlist[3] =
>> NVME_AUTH_DHCHAP_DHGROUP_NULL;
>> +    data->auth_protocol[0].dhchap.idlist[4] =
>> NVME_AUTH_DHCHAP_DHGROUP_2048;
>> +    data->auth_protocol[0].dhchap.idlist[5] =
>> NVME_AUTH_DHCHAP_DHGROUP_3072;
>> +    data->auth_protocol[0].dhchap.idlist[6] =
>> NVME_AUTH_DHCHAP_DHGROUP_4096;
>> +    data->auth_protocol[0].dhchap.idlist[7] =
>> NVME_AUTH_DHCHAP_DHGROUP_6144;
>> +    data->auth_protocol[0].dhchap.idlist[8] =
>> NVME_AUTH_DHCHAP_DHGROUP_8192;
>> +
>> +    return size;
>> +}
>> +
>> +static int nvme_auth_process_dhchap_challenge(struct nvme_ctrl *ctrl,
>> +        struct nvme_dhchap_queue_context *chap)
>> +{
>> +    struct nvmf_auth_dhchap_challenge_data *data = chap->buf;
>> +    size_t size = sizeof(*data) + data->hl + data->dhvlen;
>> +    const char *hmac_name;
>> +
>> +    if (chap->buf_size < size) {
>> +        chap->status = NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
>> +        return NVME_SC_INVALID_FIELD;
>> +    }
>> +
>> +    hmac_name = nvme_auth_hmac_name(data->hashid);
>> +    if (!hmac_name) {
>> +        dev_warn(ctrl->device,
>> +             "qid %d: invalid HASH ID %d\n",
>> +             chap->qid, data->hashid);
>> +        chap->status = NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE;
>> +        return -EPROTO;
>> +    }
>> +    if (chap->hash_id == data->hashid && chap->shash_tfm &&
>> +        !strcmp(crypto_shash_alg_name(chap->shash_tfm), hmac_name) &&
>> +        crypto_shash_digestsize(chap->shash_tfm) == data->hl) {
>> +        dev_dbg(ctrl->device,
>> +            "qid %d: reuse existing hash %s\n",
>> +            chap->qid, hmac_name);
>> +        goto select_kpp;
>> +    }
> 
> newline
> 
>> +    if (chap->shash_tfm) {
>> +        crypto_free_shash(chap->shash_tfm);
>> +        chap->hash_id = 0;
>> +        chap->hash_len = 0;
>> +    }
> 
> newline
> 
>> +    chap->shash_tfm = crypto_alloc_shash(hmac_name, 0,
>> +                         CRYPTO_ALG_ALLOCATES_MEMORY);
>> +    if (IS_ERR(chap->shash_tfm)) {
>> +        dev_warn(ctrl->device,
>> +             "qid %d: failed to allocate hash %s, error %ld\n",
>> +             chap->qid, hmac_name, PTR_ERR(chap->shash_tfm));
>> +        chap->shash_tfm = NULL;
>> +        chap->status = NVME_AUTH_DHCHAP_FAILURE_FAILED;
>> +        return NVME_SC_AUTH_REQUIRED;
>> +    }
> 
> newline
> 
>> +    if (crypto_shash_digestsize(chap->shash_tfm) != data->hl) {
>> +        dev_warn(ctrl->device,
>> +             "qid %d: invalid hash length %d\n",
>> +             chap->qid, data->hl);
>> +        crypto_free_shash(chap->shash_tfm);
>> +        chap->shash_tfm = NULL;
>> +        chap->status = NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE;
>> +        return NVME_SC_AUTH_REQUIRED;
>> +    }
> 
> newline
> 
>> +    if (chap->hash_id != data->hashid) {
>> +        kfree(chap->host_response);
> 
> kfree_sensitive? also why is is freed here? where was it allocated?
> 
This is generated when calculating the host response in
nvme_auth_dhchap_host_response().

>> +        chap->host_response = NULL;
>> +    }
>> +    chap->hash_id = data->hashid;
>> +    chap->hash_len = data->hl;
>> +    dev_dbg(ctrl->device, "qid %d: selected hash %s\n",
>> +        chap->qid, hmac_name);
>> +
>> +    gid_name = nvme_auth_dhgroup_kpp(data->dhgid);
>> +    if (!gid_name) {
>> +        dev_warn(ctrl->device,
>> +             "qid %d: invalid DH group id %d\n",
>> +             chap->qid, data->dhgid);
>> +        chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
>> +        return -EPROTO;
> 
> No need for all the previous frees?
> Maybe we can rework these such that we first do all the checks and then
> go and allocate stuff?
> 

Hmm. Will have a look if that is feasible.

>> +    }
>> +
>> +    if (data->dhgid != NVME_AUTH_DHCHAP_DHGROUP_NULL) {
>> +        if (data->dhvlen == 0) {
>> +            dev_warn(ctrl->device,
>> +                 "qid %d: empty DH value\n",
>> +                 chap->qid);
>> +            chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
>> +            return -EPROTO;
>> +        }
>> +        chap->dh_tfm = crypto_alloc_kpp(gid_name, 0, 0);
>> +        if (IS_ERR(chap->dh_tfm)) {
>> +            int ret = PTR_ERR(chap->dh_tfm);
>> +
>> +            dev_warn(ctrl->device,
>> +                 "qid %d: failed to initialize %s\n",
>> +                 chap->qid, gid_name);
>> +            chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
>> +            chap->dh_tfm = NULL;
>> +            return ret;
>> +        }
>> +        chap->dhgroup_id = data->dhgid;
>> +    } else if (data->dhvlen != 0) {
>> +        dev_warn(ctrl->device,
>> +             "qid %d: invalid DH value for NULL DH\n",
>> +            chap->qid);
>> +        chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
>> +        return -EPROTO;
>> +    }
>> +    dev_dbg(ctrl->device, "qid %d: selected DH group %s\n",
>> +        chap->qid, gid_name);
>> +
>> +select_kpp:
>> +    chap->s1 = le32_to_cpu(data->seqnum);
>> +    memcpy(chap->c1, data->cval, chap->hash_len);
>> +
>> +    return 0;
>> +}
>> +
>> +static int nvme_auth_set_dhchap_reply_data(struct nvme_ctrl *ctrl,
>> +        struct nvme_dhchap_queue_context *chap)
>> +{
>> +    struct nvmf_auth_dhchap_reply_data *data = chap->buf;
>> +    size_t size = sizeof(*data);
>> +
>> +    size += 2 * chap->hash_len;
>> +    if (ctrl->opts->dhchap_bidi) {
>> +        get_random_bytes(chap->c2, chap->hash_len);
>> +        chap->s2 = nvme_dhchap_seqnum++;
> 
> Any serialization needed on nvme_dhchap_seqnum?
> 

Maybe; will be switching to atomic here.
Have been lazy ...

>> +    } else
>> +        memset(chap->c2, 0, chap->hash_len);
>> +
>> +
>> +    if (chap->buf_size < size) {
>> +        chap->status = NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
>> +        return -EINVAL;
>> +    }
>> +    memset(chap->buf, 0, size);
>> +    data->auth_type = NVME_AUTH_DHCHAP_MESSAGES;
>> +    data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_REPLY;
>> +    data->t_id = cpu_to_le16(chap->transaction);
>> +    data->hl = chap->hash_len;
>> +    data->dhvlen = 0;
>> +    data->seqnum = cpu_to_le32(chap->s2);
>> +    memcpy(data->rval, chap->response, chap->hash_len);
>> +    if (ctrl->opts->dhchap_bidi) {
> 
> Can we unite the "if (ctrl->opts->dhchap_bidi)"
> conditionals?
> 

Sure.

[ .. ]
>> +int nvme_auth_negotiate(struct nvme_ctrl *ctrl, int qid)
>> +{
>> +    struct nvme_dhchap_queue_context *chap;
>> +
>> +    if (!ctrl->dhchap_key || !ctrl->dhchap_key_len) {
>> +        dev_warn(ctrl->device, "qid %d: no key\n", qid);
>> +        return -ENOKEY;
>> +    }
>> +
>> +    mutex_lock(&ctrl->dhchap_auth_mutex);
>> +    /* Check if the context is already queued */
>> +    list_for_each_entry(chap, &ctrl->dhchap_auth_list, entry) {
>> +        if (chap->qid == qid) {
>> +            mutex_unlock(&ctrl->dhchap_auth_mutex);
>> +            queue_work(nvme_wq, &chap->auth_work);
>> +            return 0;
>> +        }
>> +    }
>> +    chap = kzalloc(sizeof(*chap), GFP_KERNEL);
>> +    if (!chap) {
>> +        mutex_unlock(&ctrl->dhchap_auth_mutex);
>> +        return -ENOMEM;
>> +    }
>> +    chap->qid = qid;
>> +    chap->ctrl = ctrl;
>> +
>> +    /*
>> +     * Allocate a large enough buffer for the entire negotiation:
>> +     * 4k should be enough to ffdhe8192.
>> +     */
>> +    chap->buf_size = 4096;
>> +    chap->buf = kzalloc(chap->buf_size, GFP_KERNEL);
>> +    if (!chap->buf) {
>> +        mutex_unlock(&ctrl->dhchap_auth_mutex);
>> +        kfree(chap);
>> +        return -ENOMEM;
>> +    }
>> +
>> +    INIT_WORK(&chap->auth_work, __nvme_auth_work);
>> +    list_add(&chap->entry, &ctrl->dhchap_auth_list);
>> +    mutex_unlock(&ctrl->dhchap_auth_mutex);
>> +    queue_work(nvme_wq, &chap->auth_work);
> 
> Why is the auth in a work? e.g. it won't fail the connect?
> 
For re-authentication.
Re-authentication should _not_ fail the connection if it stops in some
intermediate step, only once the the protocol ran to completion the
status is updated.
Meaning that we will have additional I/O ongoing while re-authentication
is in progress, so we can't stop all I/O here but rather need to shift
it onto a workqueue.

>> +    return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(nvme_auth_negotiate);
>> +
>> +int nvme_auth_wait(struct nvme_ctrl *ctrl, int qid)
>> +{
>> +    struct nvme_dhchap_queue_context *chap;
>> +    int ret;
>> +
>> +    mutex_lock(&ctrl->dhchap_auth_mutex);
>> +    list_for_each_entry(chap, &ctrl->dhchap_auth_list, entry) {
>> +        if (chap->qid != qid)
>> +            continue;
>> +        mutex_unlock(&ctrl->dhchap_auth_mutex);
>> +        flush_work(&chap->auth_work);
>> +        ret = chap->error;
>> +        nvme_auth_reset(chap);
>> +        return ret;
>> +    }
>> +    mutex_unlock(&ctrl->dhchap_auth_mutex);
>> +    return -ENXIO;
>> +}
>> +EXPORT_SYMBOL_GPL(nvme_auth_wait);
>> +
>> +/* Assumes that the controller is in state RESETTING */
>> +static void nvme_dhchap_auth_work(struct work_struct *work)
>> +{
>> +    struct nvme_ctrl *ctrl =
>> +        container_of(work, struct nvme_ctrl, dhchap_auth_work);
>> +    int ret, q;
>> +
>> +    nvme_stop_queues(ctrl);
>> +    /* Authenticate admin queue first */
>> +    ret = nvme_auth_negotiate(ctrl, NVME_QID_ANY);
>> +    if (ret) {
>> +        dev_warn(ctrl->device,
>> +             "qid 0: error %d setting up authentication\n", ret);
>> +        goto out;
>> +    }
>> +    ret = nvme_auth_wait(ctrl, NVME_QID_ANY);
>> +    if (ret) {
>> +        dev_warn(ctrl->device,
>> +             "qid 0: authentication failed\n");
>> +        goto out;
>> +    }
>> +    dev_info(ctrl->device, "qid 0: authenticated\n");
>> +
>> +    for (q = 1; q < ctrl->queue_count; q++) {
>> +        ret = nvme_auth_negotiate(ctrl, q);
>> +        if (ret) {
>> +            dev_warn(ctrl->device,
>> +                 "qid %d: error %d setting up authentication\n",
>> +                 q, ret);
>> +            goto out;
>> +        }
>> +    }
>> +out:
>> +    /*
>> +     * Failure is a soft-state; credentials remain valid until
>> +     * the controller terminates the connection.
>> +     */
>> +    if (nvme_change_ctrl_state(ctrl, NVME_CTRL_LIVE))
>> +        nvme_start_queues(ctrl);
>> +}
>> +
>> +void nvme_auth_init_ctrl(struct nvme_ctrl *ctrl)
>> +{
>> +    INIT_LIST_HEAD(&ctrl->dhchap_auth_list);
>> +    INIT_WORK(&ctrl->dhchap_auth_work, nvme_dhchap_auth_work);
>> +    mutex_init(&ctrl->dhchap_auth_mutex);
>> +    nvme_auth_generate_key(ctrl);
>> +}
>> +EXPORT_SYMBOL_GPL(nvme_auth_init_ctrl);
>> +
>> +void nvme_auth_stop(struct nvme_ctrl *ctrl)
>> +{
>> +    struct nvme_dhchap_queue_context *chap = NULL, *tmp;
>> +
>> +    cancel_work_sync(&ctrl->dhchap_auth_work);
>> +    mutex_lock(&ctrl->dhchap_auth_mutex);
>> +    list_for_each_entry_safe(chap, tmp, &ctrl->dhchap_auth_list, entry)
>> +        cancel_work_sync(&chap->auth_work);
>> +    mutex_unlock(&ctrl->dhchap_auth_mutex);
>> +}
>> +EXPORT_SYMBOL_GPL(nvme_auth_stop);
>> +
>> +void nvme_auth_free(struct nvme_ctrl *ctrl)
>> +{
>> +    struct nvme_dhchap_queue_context *chap = NULL, *tmp;
>> +
>> +    mutex_lock(&ctrl->dhchap_auth_mutex);
>> +    list_for_each_entry_safe(chap, tmp, &ctrl->dhchap_auth_list,
>> entry) {
>> +        list_del_init(&chap->entry);
>> +        flush_work(&chap->auth_work);
>> +        __nvme_auth_free(chap);
>> +    }
>> +    mutex_unlock(&ctrl->dhchap_auth_mutex);
>> +    kfree(ctrl->dhchap_key);
>> +    ctrl->dhchap_key = NULL;
>> +    ctrl->dhchap_key_len = 0;
>> +}
>> +EXPORT_SYMBOL_GPL(nvme_auth_free);
>> diff --git a/drivers/nvme/host/auth.h b/drivers/nvme/host/auth.h
>> new file mode 100644
>> index 000000000000..cf1255f9db6d
>> --- /dev/null
>> +++ b/drivers/nvme/host/auth.h
>> @@ -0,0 +1,25 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (c) 2021 Hannes Reinecke, SUSE Software Solutions
>> + */
>> +
>> +#ifndef _NVME_AUTH_H
>> +#define _NVME_AUTH_H
>> +
>> +#include <crypto/kpp.h>
>> +
>> +const char *nvme_auth_dhgroup_name(int dhgroup_id);
>> +int nvme_auth_dhgroup_pubkey_size(int dhgroup_id);
>> +int nvme_auth_dhgroup_privkey_size(int dhgroup_id);
>> +const char *nvme_auth_dhgroup_kpp(int dhgroup_id);
>> +int nvme_auth_dhgroup_id(const char *dhgroup_name);
>> +
>> +const char *nvme_auth_hmac_name(int hmac_id);
>> +const char *nvme_auth_digest_name(int hmac_id);
>> +int nvme_auth_hmac_id(const char *hmac_name);
>> +
>> +unsigned char *nvme_auth_extract_secret(unsigned char *dhchap_secret,
>> +                    size_t *dhchap_key_len);
>> +u8 *nvme_auth_transform_key(u8 *key, size_t key_len, u8 key_hash,
>> char *nqn);
>> +
>> +#endif /* _NVME_AUTH_H */
>> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
>> index 7efb31b87f37..f669b054790b 100644
>> --- a/drivers/nvme/host/core.c
>> +++ b/drivers/nvme/host/core.c
>> @@ -24,6 +24,7 @@
>>     #include "nvme.h"
>>   #include "fabrics.h"
>> +#include "auth.h"
>>     #define CREATE_TRACE_POINTS
>>   #include "trace.h"
>> @@ -322,6 +323,7 @@ enum nvme_disposition {
>>       COMPLETE,
>>       RETRY,
>>       FAILOVER,
>> +    AUTHENTICATE,
>>   };
>>     static inline enum nvme_disposition nvme_decide_disposition(struct
>> request *req)
>> @@ -329,6 +331,9 @@ static inline enum nvme_disposition
>> nvme_decide_disposition(struct request *req)
>>       if (likely(nvme_req(req)->status == 0))
>>           return COMPLETE;
>>   +    if ((nvme_req(req)->status & 0x7ff) == NVME_SC_AUTH_REQUIRED)
>> +        return AUTHENTICATE;
>> +
>>       if (blk_noretry_request(req) ||
>>           (nvme_req(req)->status & NVME_SC_DNR) ||
>>           nvme_req(req)->retries >= nvme_max_retries)
>> @@ -361,11 +366,13 @@ static inline void nvme_end_req(struct request
>> *req)
>>     void nvme_complete_rq(struct request *req)
>>   {
>> +    struct nvme_ctrl *ctrl = nvme_req(req)->ctrl;
>> +
>>       trace_nvme_complete_rq(req);
>>       nvme_cleanup_cmd(req);
>>   -    if (nvme_req(req)->ctrl->kas)
>> -        nvme_req(req)->ctrl->comp_seen = true;
>> +    if (ctrl->kas)
>> +        ctrl->comp_seen = true;
>>         switch (nvme_decide_disposition(req)) {
>>       case COMPLETE:
>> @@ -377,6 +384,15 @@ void nvme_complete_rq(struct request *req)
>>       case FAILOVER:
>>           nvme_failover_req(req);
>>           return;
>> +    case AUTHENTICATE:
>> +#ifdef CONFIG_NVME_AUTH
>> +        if (nvme_change_ctrl_state(ctrl, NVME_CTRL_RESETTING))
>> +            queue_work(nvme_wq, &ctrl->dhchap_auth_work);
> 
> Why is the state change here and not in nvme_dhchap_auth_work?
> 
Because switching to 'resetting' is an easy way to synchronize with the
admin queue.

>> +        nvme_retry_req(req);
>> +#else
>> +        nvme_end_req(req);
>> +#endif
>> +        return;
>>       }
>>   }
>>   EXPORT_SYMBOL_GPL(nvme_complete_rq);
>> @@ -707,7 +723,9 @@ bool __nvme_check_ready(struct nvme_ctrl *ctrl,
>> struct request *rq,
>>           switch (ctrl->state) {
>>           case NVME_CTRL_CONNECTING:
>>               if (blk_rq_is_passthrough(rq) &&
>> nvme_is_fabrics(req->cmd) &&
>> -                req->cmd->fabrics.fctype == nvme_fabrics_type_connect)
>> +                (req->cmd->fabrics.fctype ==
>> nvme_fabrics_type_connect ||
>> +                 req->cmd->fabrics.fctype ==
>> nvme_fabrics_type_auth_send ||
>> +                 req->cmd->fabrics.fctype ==
>> nvme_fabrics_type_auth_receive))
> 
> What happens if the auth command comes before the connect (say in case
> of ctrl reset when auth was already queued but not yet executed?
> 
See below.

>>                   return true;
>>               break;
>>           default:
>> @@ -3458,6 +3476,51 @@ static ssize_t
>> nvme_ctrl_fast_io_fail_tmo_store(struct device *dev,
>>   static DEVICE_ATTR(fast_io_fail_tmo, S_IRUGO | S_IWUSR,
>>       nvme_ctrl_fast_io_fail_tmo_show, nvme_ctrl_fast_io_fail_tmo_store);
>>   +#ifdef CONFIG_NVME_AUTH
>> +static ssize_t nvme_ctrl_dhchap_secret_show(struct device *dev,
>> +        struct device_attribute *attr, char *buf)
>> +{
>> +    struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
>> +    struct nvmf_ctrl_options *opts = ctrl->opts;
>> +
>> +    if (!opts->dhchap_secret)
>> +        return sysfs_emit(buf, "none\n");
>> +    return sysfs_emit(buf, "%s\n", opts->dhchap_secret);
> 
> Should we actually show this? don't know enough how much the secret
> should be kept a secret...
> 
I found it logical, as we need the 'store' functionality to trigger
re-authentication.
But sure, we can make this a write-only attribute.

>> +}
>> +
>> +static ssize_t nvme_ctrl_dhchap_secret_store(struct device *dev,
>> +        struct device_attribute *attr, const char *buf, size_t count)
>> +{
>> +    struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
>> +    struct nvmf_ctrl_options *opts = ctrl->opts;
>> +    char *dhchap_secret;
>> +
>> +    if (!ctrl->opts->dhchap_secret)
>> +        return -EINVAL;
>> +    if (count < 7)
>> +        return -EINVAL;
>> +    if (memcmp(buf, "DHHC-1:", 7))
>> +        return -EINVAL;
>> +
>> +    dhchap_secret = kzalloc(count + 1, GFP_KERNEL);
>> +    if (!dhchap_secret)
>> +        return -ENOMEM;
>> +    memcpy(dhchap_secret, buf, count);
>> +    if (strcmp(dhchap_secret, opts->dhchap_secret)) {
>> +        kfree(opts->dhchap_secret);
>> +        opts->dhchap_secret = dhchap_secret;
>> +        /* Key has changed; reset authentication data */
>> +        nvme_auth_free(ctrl);
>> +        nvme_auth_generate_key(ctrl);
>> +    }
> 
> Nice, worth a comment "/* Re-authentication with new secret */"
> 
Right, will do.

Thanks for the review!

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
