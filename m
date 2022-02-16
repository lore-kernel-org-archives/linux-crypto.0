Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8DB6C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Feb 2022 01:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238878AbiBPBjU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Feb 2022 20:39:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235134AbiBPBjU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Feb 2022 20:39:20 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE58237EB
        for <linux-crypto@vger.kernel.org>; Tue, 15 Feb 2022 17:39:08 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id y9so1105882pjf.1
        for <linux-crypto@vger.kernel.org>; Tue, 15 Feb 2022 17:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4IkDugObOHw/CxlumnAa9V9g2g9OJVY9HrD6pEfE2lM=;
        b=P61cP+b5/QdSjJQm9e3zgGhGrgdXFH3lfZfyCCnrtJvrS2+7Cgg/dK89cqyX5yiXdM
         aRg6deIkdutkpSXDRfq1SNB/AVdg67oJTEfGuZzvMRJv/p9e6KRJLEXzcrjwLer7bRSl
         5Hqbc6Y4GJ7wXys6sEIq6kO2AwpaP3Ih1QhqmQi2Ibob5FqsJtnc7XS9CJrZc/tNAlgN
         jpKWExv6vcU/EcHtH4LDz+fQj1sM9wpY6DQprEJuyOb0+OgqwL842EHBvA+fLBpyfLcO
         VgwsmOlwkj6aVXkg+59IM7suM4/u86uaKECJ+K6z9bKeydZ0ploCky1eRev1yrcrzvLq
         wZTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4IkDugObOHw/CxlumnAa9V9g2g9OJVY9HrD6pEfE2lM=;
        b=AGcs/ROEeQWsi51AFsYVNFTOPOGlfG8NkbfknqTAlHUWys5KRPGP1EzKB/hpL1jLP9
         FHAVKLc4VebmPdV9kKpr2bxIEqa0t94Y50NJuhqHI3Wn8AJwWebVfLdYhRb8FYAR94uo
         WODmss6OBXqEM+WAcFm9eeGGgZWh+8POgWYfMEpLZZ2/hfk5IXCTsoYpqCltvQ9LV+Yr
         CVXnecyEA0Yf8rYwchC3SoVpWw/L4ecsX3y/EDxHSra0qBWWc947GD8mCfabEtNfF5qC
         peeuGjbKXIxCY4yaA2wdnrC8cCoMtdI5g92rsUkLWWOpff2J35ELIh4zFM9nS/ZEr4eM
         S3cw==
X-Gm-Message-State: AOAM530/EXpwknnbQRUzzO/w5HdPRcFU9oLhDGpiZ8KC6d3Z2bwNTNLQ
        OxbLTu4NyG8M4n16025OYhAL9g==
X-Google-Smtp-Source: ABdhPJyVcEQPG2VDaGKPFncTObF/Wmp+3tHQlHV4luaY2AjnKJkKFGfI/nUrfIAuuNsLJkHuYb42pA==
X-Received: by 2002:a17:90b:2390:b0:1b9:c392:ab8d with SMTP id mr16-20020a17090b239000b001b9c392ab8dmr293672pjb.30.1644975548318;
        Tue, 15 Feb 2022 17:39:08 -0800 (PST)
Received: from [10.76.15.169] ([61.120.150.76])
        by smtp.gmail.com with ESMTPSA id j12sm35873328pfu.79.2022.02.15.17.39.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 17:39:07 -0800 (PST)
Subject: PING: [PATCH v2 0/3] Introduce akcipher service for virtio-crypto
To:     arei.gonglei@huawei.com
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        helei.sig11@bytedance.com, herbert@gondor.apana.org.au,
        mst@redhat.com
References: <20220211084108.1254218-1-pizhenwei@bytedance.com>
From:   zhenwei pi <pizhenwei@bytedance.com>
Message-ID: <cf1c6a2e-92a1-06f7-8f1b-be823c21ab5a@bytedance.com>
Date:   Wed, 16 Feb 2022 09:36:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220211084108.1254218-1-pizhenwei@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Lei

Could you please review the V2 version?

On 2/11/22 4:41 PM, zhenwei pi wrote:
> v1 -> v2:
> - Fix 1 compiling warning reported by kernel test robot <lkp@intel.com>
> - Put "__le32 akcipher_algo;" instead of "__le32 reserve;" field of
>     struct virtio_crypto_config directly without size change.
> - Add padding in struct virtio_crypto_ecdsa_session_para to keep
>     64-bit alignment.
> - Remove irrelevant change by code format alignment.
> 
> - Also CC crypto gurus Herbert and linux-crypto@vger.kernel.org.
> 
> - Test with QEMU(patched by the v2 version), works fine.
> 
> v1:
> - Introduce akcipher service, implement RSA algorithm, and a minor fix.
> 
> zhenwei pi (3):
>    virtio_crypto: Introduce VIRTIO_CRYPTO_NOSPC
>    virtio-crypto: introduce akcipher service
>    virtio-crypto: implement RSA algorithm
> 
>   drivers/crypto/virtio/Makefile                |   1 +
>   .../virtio/virtio_crypto_akcipher_algo.c      | 584 ++++++++++++++++++
>   drivers/crypto/virtio/virtio_crypto_common.h  |   3 +
>   drivers/crypto/virtio/virtio_crypto_core.c    |   6 +-
>   drivers/crypto/virtio/virtio_crypto_mgr.c     |  11 +
>   include/uapi/linux/virtio_crypto.h            |  82 ++-
>   6 files changed, 685 insertions(+), 2 deletions(-)
>   create mode 100644 drivers/crypto/virtio/virtio_crypto_akcipher_algo.c
> 

-- 
zhenwei pi
