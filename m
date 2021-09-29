Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24216C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Sep 2021 12:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BC5D613A9
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Sep 2021 12:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343900AbhI2MiV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Sep 2021 08:38:21 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:45019 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343864AbhI2MiS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Sep 2021 08:38:18 -0400
Received: by mail-wr1-f53.google.com with SMTP id d6so3963747wrc.11
        for <linux-crypto@vger.kernel.org>; Wed, 29 Sep 2021 05:36:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0cxUxORQ8qto0exNXuVLuvCPw7k2OOLWIR2ZT4ZNSr4=;
        b=w8Lxpt+6ygq3sthJuOlJpDqHxe9MPsHlmtHTLBaDROmTJJTIvDMEJjoZKRbViEIhU4
         VrJ9htt7FRNIeNpVbTuJVWlys7ibLY8PDryW5T0vHO2OlNMvwFv56LtLo9XYx/U5+OfR
         Hp7+N8tFoTQ9OAAUeAvgdDJnk3UFBbf3nZsmfOofwBN8psYHI35edMRIX3QH7SdgM1oY
         9FT88eqcHWO0XCd5Fyej9Z2OPCohzS9TryvYdSJvyhHmQwO6bwmdt4U/uBTISTcsE9wM
         O+UKS9PV7A/s2w5NC4sAoMHRQB7wDVWsgRIP2vtQsi4pU9emSuvDlyOKBX2dE1P/IkEF
         /oLA==
X-Gm-Message-State: AOAM533uhTXGmeaBMYqjPaaRiuCRF24vPtghZs40+1raF5xK/dpC27EF
        NFscWNvDM1dUrWsBV4qZWKdyHSK9qXg=
X-Google-Smtp-Source: ABdhPJwJf+5eY8EB0WcJjJ648ZLZoZVuWBj+kbNAg6ILYX69AmIOd7JBsTo/y/Xz7SnAkRuCbTHQsQ==
X-Received: by 2002:adf:bb11:: with SMTP id r17mr6529712wrg.285.1632918996305;
        Wed, 29 Sep 2021 05:36:36 -0700 (PDT)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id s13sm1443236wmj.9.2021.09.29.05.36.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 05:36:35 -0700 (PDT)
Subject: Re: [PATCH 10/12] nvmet: Implement basic In-Band Authentication
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20210928060356.27338-1-hare@suse.de>
 <20210928060356.27338-11-hare@suse.de>
 <d8827017-f8a7-c1fc-1950-8ac6c5997103@grimberg.me>
 <d1f4cd0c-1d53-6eff-83e2-d1b4d04b7221@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <e876b96a-e24b-d0de-0c62-d4345c4f8714@grimberg.me>
Date:   Wed, 29 Sep 2021 15:36:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <d1f4cd0c-1d53-6eff-83e2-d1b4d04b7221@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 9/29/21 3:26 PM, Hannes Reinecke wrote:
> On 9/29/21 12:37 PM, Sagi Grimberg wrote:
>>
>>
>> On 9/28/21 9:03 AM, Hannes Reinecke wrote:
>>> Implement NVMe-oF In-Band authentication according to NVMe TPAR 8006.
>>> This patch adds three additional configfs entries 'dhchap_key',
>>> 'dhchap_ctrl_key',
>>> and 'dhchap_hash' to the 'host' configfs directory. The 'dhchap_key' and
>>> 'dhchap_ctrl_key' entries need to be in the ASCII format as specified in
>>> NVMe Base Specification v2.0 section 8.13.5.8 'Secret representation'.
>>> 'dhchap_hash' defaults to 'hmac(sha256)', and can be changed to switch to
>>> a different HMAC algorithm.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>> ---
>>>    drivers/nvme/target/Kconfig            |  11 +
>>>    drivers/nvme/target/Makefile           |   1 +
>>>    drivers/nvme/target/admin-cmd.c        |   4 +
>>>    drivers/nvme/target/auth.c             | 345 ++++++++++++++++++
>>>    drivers/nvme/target/configfs.c         | 102 +++++-
>>>    drivers/nvme/target/core.c             |   8 +
>>>    drivers/nvme/target/fabrics-cmd-auth.c | 466 +++++++++++++++++++++++++
>>>    drivers/nvme/target/fabrics-cmd.c      |  30 +-
>>>    drivers/nvme/target/nvmet.h            |  67 ++++
>>>    9 files changed, 1031 insertions(+), 3 deletions(-)
>>>    create mode 100644 drivers/nvme/target/auth.c
>>>    create mode 100644 drivers/nvme/target/fabrics-cmd-auth.c
>>>
>>> diff --git a/drivers/nvme/target/Kconfig b/drivers/nvme/target/Kconfig
>>> index 973561c93888..70f3c385fc9f 100644
>>> --- a/drivers/nvme/target/Kconfig
>>> +++ b/drivers/nvme/target/Kconfig
>>> @@ -83,3 +83,14 @@ config NVME_TARGET_TCP
>>>          devices over TCP.
>>>            If unsure, say N.
>>> +
>>> +config NVME_TARGET_AUTH
>>> +    bool "NVMe over Fabrics In-band Authentication support"
>>> +    depends on NVME_TARGET
>>> +    select CRYPTO_HMAC
>>> +    select CRYPTO_SHA256
>>> +    select CRYPTO_SHA512
>>> +    help
>>> +      This enables support for NVMe over Fabrics In-band Authentication
>>> +
>>> +      If unsure, say N.
>>> diff --git a/drivers/nvme/target/Makefile b/drivers/nvme/target/Makefile
>>> index 9837e580fa7e..c66820102493 100644
>>> --- a/drivers/nvme/target/Makefile
>>> +++ b/drivers/nvme/target/Makefile
>>> @@ -13,6 +13,7 @@ nvmet-y        += core.o configfs.o admin-cmd.o
>>> fabrics-cmd.o \
>>>                discovery.o io-cmd-file.o io-cmd-bdev.o
>>>    nvmet-$(CONFIG_NVME_TARGET_PASSTHRU)    += passthru.o
>>>    nvmet-$(CONFIG_BLK_DEV_ZONED)        += zns.o
>>> +nvmet-$(CONFIG_NVME_TARGET_AUTH)    += fabrics-cmd-auth.o auth.o
>>>    nvme-loop-y    += loop.o
>>>    nvmet-rdma-y    += rdma.o
>>>    nvmet-fc-y    += fc.o
>>> diff --git a/drivers/nvme/target/admin-cmd.c
>>> b/drivers/nvme/target/admin-cmd.c
>>> index aa6d84d8848e..868d65c869cd 100644
>>> --- a/drivers/nvme/target/admin-cmd.c
>>> +++ b/drivers/nvme/target/admin-cmd.c
>>> @@ -1008,6 +1008,10 @@ u16 nvmet_parse_admin_cmd(struct nvmet_req *req)
>>>          if (nvme_is_fabrics(cmd))
>>>            return nvmet_parse_fabrics_cmd(req);
>>> +
>>> +    if (unlikely(!nvmet_check_auth_status(req)))
>>> +        return NVME_SC_AUTH_REQUIRED | NVME_SC_DNR;
>>> +
>>>        if (nvmet_req_subsys(req)->type == NVME_NQN_DISC)
>>>            return nvmet_parse_discovery_cmd(req);
>>>    diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
>>> new file mode 100644
>>> index 000000000000..7247a7b97644
>>> --- /dev/null
>>> +++ b/drivers/nvme/target/auth.c
>>> @@ -0,0 +1,345 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/*
>>> + * NVMe over Fabrics DH-HMAC-CHAP authentication.
>>> + * Copyright (c) 2020 Hannes Reinecke, SUSE Software Solutions.
>>> + * All rights reserved.
>>> + */
>>> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>>> +#include <linux/module.h>
>>> +#include <linux/init.h>
>>> +#include <linux/slab.h>
>>> +#include <linux/err.h>
>>> +#include <crypto/hash.h>
>>> +#include <linux/crc32.h>
>>> +#include <linux/base64.h>
>>> +#include <linux/ctype.h>
>>> +#include <linux/random.h>
>>> +#include <asm/unaligned.h>
>>> +
>>> +#include "nvmet.h"
>>> +#include "../host/auth.h"
>>> +
>>> +int nvmet_auth_set_host_key(struct nvmet_host *host, const char *secret)
>>> +{
>>> +    if (sscanf(secret, "DHHC-1:%hhd:%*s", &host->dhchap_key_hash) != 1)
>>> +        return -EINVAL;
>>> +    if (host->dhchap_key_hash > 3) {
>>> +        pr_warn("Invalid DH-HMAC-CHAP hash id %d\n",
>>> +             host->dhchap_key_hash);
>>> +        return -EINVAL;
>>> +    }
>>> +    if (host->dhchap_key_hash > 0) {
>>> +        /* Validate selected hash algorithm */
>>> +        const char *hmac = nvme_auth_hmac_name(host->dhchap_key_hash);
>>> +
>>> +        if (!crypto_has_shash(hmac, 0, 0)) {
>>> +            pr_err("DH-HMAC-CHAP hash %s unsupported\n", hmac);
>>> +            host->dhchap_key_hash = -1;
>>> +            return -ENOTSUPP;
>>> +        }
>>> +        /* Use this hash as default */
>>> +        if (!host->dhchap_hash_id)
>>> +            host->dhchap_hash_id = host->dhchap_key_hash;
>>> +    }
>>> +    host->dhchap_secret = kstrdup(secret, GFP_KERNEL);
>>> +    if (!host->dhchap_secret)
>>> +        return -ENOMEM;
>>> +    /* Default to SHA256 */
>>> +    if (!host->dhchap_hash_id)
>>> +        host->dhchap_hash_id = NVME_AUTH_DHCHAP_SHA256;
>>> +
>>> +    pr_debug("Using hash %s\n",
>>> +         nvme_auth_hmac_name(host->dhchap_hash_id));
>>> +    return 0;
>>> +}
>>> +
>>> +int nvmet_auth_set_ctrl_key(struct nvmet_host *host, const char *secret)
>>> +{
>>> +    unsigned char dhchap_key_hash;
>>> +
>>> +    if (sscanf(secret, "DHHC-1:%hhd:%*s", &dhchap_key_hash) != 1)
>>> +        return -EINVAL;
>>> +    if (dhchap_key_hash > 3) {
>>> +        pr_warn("Invalid DH-HMAC-CHAP hash id %d\n",
>>> +             dhchap_key_hash);
>>> +        return -EINVAL;
>>> +    }
>>> +    if (dhchap_key_hash > 0) {
>>> +        /* Validate selected hash algorithm */
>>> +        const char *hmac = nvme_auth_hmac_name(dhchap_key_hash);
>>> +
>>> +        if (!crypto_has_shash(hmac, 0, 0)) {
>>> +            pr_err("DH-HMAC-CHAP hash %s unsupported\n", hmac);
>>> +            return -ENOTSUPP;
>>> +        }
>>> +    }
>>> +    host->dhchap_ctrl_secret = kstrdup(secret, GFP_KERNEL);
>>> +    return host->dhchap_ctrl_secret ? 0 : -ENOMEM;
>>> +}
>>> +
>>> +int nvmet_setup_auth(struct nvmet_ctrl *ctrl)
>>> +{
>>> +    int ret = 0;
>>> +    struct nvmet_host_link *p;
>>> +    struct nvmet_host *host = NULL;
>>> +    const char *hash_name;
>>> +
>>> +    down_read(&nvmet_config_sem);
>>> +    if (ctrl->subsys->type == NVME_NQN_DISC)
>>> +        goto out_unlock;
>>> +
>>> +    if (ctrl->subsys->allow_any_host)
>>> +        goto out_unlock;
>>> +
>>> +    list_for_each_entry(p, &ctrl->subsys->hosts, entry) {
>>> +        pr_debug("check %s\n", nvmet_host_name(p->host));
>>> +        if (strcmp(nvmet_host_name(p->host), ctrl->hostnqn))
>>> +            continue;
>>> +        host = p->host;
>>> +        break;
>>> +    }
>>> +    if (!host) {
>>> +        pr_debug("host %s not found\n", ctrl->hostnqn);
>>> +        ret = -EPERM;
>>> +        goto out_unlock;
>>> +    }
>>> +    if (!host->dhchap_secret) {
>>> +        pr_debug("No authentication provided\n");
>>> +        goto out_unlock;
>>> +    }
>>> +
>>> +    if (ctrl->shash_tfm) {
>>> +        if (host->dhchap_hash_id == ctrl->shash_id) {
>>> +            pr_debug("Re-use existing hash ID %d\n",
>>> +                 ctrl->shash_id);
>>> +            goto out_unlock;
>>> +        }
>>> +        crypto_free_shash(ctrl->shash_tfm);
>>> +        ctrl->shash_tfm = NULL;
>>> +    }
>>> +
>>> +    hash_name = nvme_auth_hmac_name(host->dhchap_hash_id);
>>> +    if (!hash_name) {
>>> +        pr_warn("Hash ID %d invalid\n", host->dhchap_hash_id);
>>> +        ret = -EINVAL;
>>> +        goto out_unlock;
>>> +    }
>>> +    ctrl->shash_tfm = crypto_alloc_shash(hash_name, 0,
>>> +                         CRYPTO_ALG_ALLOCATES_MEMORY);
>>> +    if (IS_ERR(ctrl->shash_tfm)) {
>>> +        pr_err("failed to allocate shash %s\n", hash_name);
>>> +        ret = PTR_ERR(ctrl->shash_tfm);
>>> +        ctrl->shash_tfm = NULL;
>>> +        goto out_unlock;
>>> +    }
>>> +    ctrl->shash_id = host->dhchap_hash_id;
>>> +
>>> +    /* Skip the 'DHHC-1:XX:' prefix */
>>> +    ctrl->dhchap_key = nvme_auth_extract_secret(host->dhchap_secret +
>>> 10,
>>> +                            &ctrl->dhchap_key_len);
>>> +    if (IS_ERR(ctrl->dhchap_key)) {
>>> +        ret = PTR_ERR(ctrl->dhchap_key);
>>> +        pr_debug("failed to extract host key, error %d\n", ret);
>>> +        ctrl->dhchap_key = NULL;
>>> +        goto out_free_hash;
>>> +    }
>>> +    pr_debug("%s: using key %*ph\n", __func__,
>>> +         (int)ctrl->dhchap_key_len, ctrl->dhchap_key);
>>> +
>>> +    if (!host->dhchap_ctrl_secret)
>>> +        goto out_unlock;
>>> +
>>> +    ctrl->dhchap_ctrl_key =
>>> nvme_auth_extract_secret(host->dhchap_ctrl_secret + 10,
>>> +                             &ctrl->dhchap_ctrl_key_len);
>>> +    if (IS_ERR(ctrl->dhchap_ctrl_key)) {
>>> +        ret = PTR_ERR(ctrl->dhchap_ctrl_key);
>>> +        pr_debug("failed to extract ctrl key, error %d\n", ret);
>>> +        ctrl->dhchap_ctrl_key = NULL;
>>> +    }
>>> +
>>> +out_free_hash:
>>> +    if (ret) {
>>> +        if (ctrl->dhchap_key) {
>>> +            kfree_sensitive(ctrl->dhchap_key);
>>> +            ctrl->dhchap_key = NULL;
>>> +        }
>>> +        crypto_free_shash(ctrl->shash_tfm);
>>> +        ctrl->shash_tfm = NULL;
>>> +        ctrl->shash_id = 0;
>>> +    }
>>> +out_unlock:
>>> +    up_read(&nvmet_config_sem);
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +void nvmet_auth_sq_free(struct nvmet_sq *sq)
>>> +{
>>> +    kfree(sq->dhchap_c1);
>>> +    sq->dhchap_c1 = NULL;
>>> +    kfree(sq->dhchap_c2);
>>> +    sq->dhchap_c2 = NULL;
>>> +    kfree(sq->dhchap_skey);
>>> +    sq->dhchap_skey = NULL;
>>> +}
>>> +
>>> +void nvmet_destroy_auth(struct nvmet_ctrl *ctrl)
>>> +{
>>> +    if (ctrl->shash_tfm) {
>>> +        crypto_free_shash(ctrl->shash_tfm);
>>> +        ctrl->shash_tfm = NULL;
>>> +        ctrl->shash_id = 0;
>>> +    }
>>> +    if (ctrl->dhchap_key) {
>>> +        kfree_sensitive(ctrl->dhchap_key);
>>> +        ctrl->dhchap_key = NULL;
>>> +    }
>>> +    if (ctrl->dhchap_ctrl_key) {
>>> +        kfree_sensitive(ctrl->dhchap_ctrl_key);
>>> +        ctrl->dhchap_ctrl_key = NULL;
>>> +    }
>>> +}
>>> +
>>> +bool nvmet_check_auth_status(struct nvmet_req *req)
>>> +{
>>> +    if (req->sq->ctrl->shash_tfm &&
>>> +        !req->sq->authenticated)
>>> +        return false;
>>> +    return true;
>>> +}
>>> +
>>> +int nvmet_auth_host_hash(struct nvmet_req *req, u8 *response,
>>> +             unsigned int shash_len)
>>> +{
>>> +    struct nvmet_ctrl *ctrl = req->sq->ctrl;
>>> +    SHASH_DESC_ON_STACK(shash, ctrl->shash_tfm);
>>> +    u8 *challenge = req->sq->dhchap_c1, *host_response;
>>> +    u8 buf[4];
>>> +    int ret;
>>> +
>>> +    if (shash_len != ctrl->dhchap_key_len)
>>> +        return -EINVAL;
>>
>> Is this condition correct? the shash_len is sent by the host
>> and afaict the host is setting it by what the controller sent
>> in the challenge. the ctrl->dhchap_key_len is taken from
>> nvme_auth_extract_secret.
>>
> Ideally, but shash_len is actually sent by the host, so it _might_ be
> different (as it's picked up from the command sent by the host).
> 
>> In other words, if the nvmet host is set to use hmac(sha512) then
>> authentication fails, regardless of the key.
>>
> Nope. The hash algorithm is figured out the 'negotiation' step,
> so the host _should_ have set the correct hash length.
> But as this is networking you should be validating each field in the
> received packet to ensure it matches what you expect.

On the target:
# grep -r '' 
/sys/kernel/config/nvmet/hosts/nqn.2014-08.org.nvmexpress\:uuid\:b73ff014-2723-4114-aa8d-2f784ecba4f4/
/sys/kernel/config/nvmet/hosts/nqn.2014-08.org.nvmexpress:uuid:b73ff014-2723-4114-aa8d-2f784ecba4f4/dhchap_dhgroup:null
/sys/kernel/config/nvmet/hosts/nqn.2014-08.org.nvmexpress:uuid:b73ff014-2723-4114-aa8d-2f784ecba4f4/dhchap_hash:hmac(sha512)
/sys/kernel/config/nvmet/hosts/nqn.2014-08.org.nvmexpress:uuid:b73ff014-2723-4114-aa8d-2f784ecba4f4/dhchap_ctrl_key:
/sys/kernel/config/nvmet/hosts/nqn.2014-08.org.nvmexpress:uuid:b73ff014-2723-4114-aa8d-2f784ecba4f4/dhchap_key:DHHC-1:03:KUwVlIUo627Pn05W/lRL2XD57kzIs1yZzJWdd2vgZJUC74kr:

On the host:
# ./nvme connect-all 
--dhchap-secret="DHHC-1:03:KUwVlIUo627Pn05W/lRL2XD57kzIs1yZzJWdd2vgZJUC74kr:"
failed to connect controller, error 5

On the target dmesg:
[ 8695.716117] nvmet: creating controller 1 for subsystem 
nqn.2014-08.org.nvmexpress.discovery for NQN 
nqn.2014-08.org.nvmexpress:uuid:b73ff014-2723-4114-aa8d-2f784ecba4f4.
[ 8695.749996] nvmet: creating controller 2 for subsystem testnqn1 for 
NQN nqn.2014-08.org.nvmexpress:uuid:b73ff014-2723-4114-aa8d-2f784ecba4f4 
with DH-HMAC-CHAP.
[ 8695.755361] nvmet: ctrl 2 qid 0 failure1 (1)
[ 8695.755449] nvmet: ctrl 2 fatal error occurred!

On the host dmesg:
[ 8781.616712] nvme nvme1: new ctrl: NQN 
"nqn.2014-08.org.nvmexpress.discovery", addr 192.168.123.1:8009
[ 8781.637954] nvme nvme2: qid 0: authentication failed
[ 8781.638084] nvme nvme2: failed to connect queue: 0 ret=401

If I change the dhchap_hash to hmac(sha256) authentication succeeds.
The failure with hmac(sha512) comes from the above condition as the
host is sending key length 64 and nvmet is expecting 32.
