Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E74C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 06:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbiBJG6d (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 01:58:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiBJG6a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 01:58:30 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E792DFC0
        for <linux-crypto@vger.kernel.org>; Wed,  9 Feb 2022 22:58:31 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id d187so8579881pfa.10
        for <linux-crypto@vger.kernel.org>; Wed, 09 Feb 2022 22:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qubtFSL5pffuSE96y3KeDZ8ATTHDcApsGYblihKFKlM=;
        b=EJVUaU8FgXsLEg4U3EZPRn43bEa9gR+0klojCs/EluWwEY+HOcMpGt8mz0MLTWfDli
         qauc/PGRY033F8Tl9tbpzf+m9yWO/hW8G4GSAAiN5tbaLEyyIpGoU9fV/rM4rQ7ZZQsx
         dDewofAx3MwRkM8+5kbNA4zzIMcgaKOsgeNnwEofmay4MTy70hEmofAKysX/3wQUHa6b
         IUmexz1cnwAIYlI1mhnqzUeXVhDUT4cn/83Nys6l3ClEbfRVXJ5m5h76IVWeSSDOqf0T
         GMiE60mDEldQ0KK4Q4cZILLx5jPwXRN9TXmIhfZIYYA9GnGmzdJLnmybBl+FM4hsne0X
         4/Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qubtFSL5pffuSE96y3KeDZ8ATTHDcApsGYblihKFKlM=;
        b=1r1P3p4Wx6QbrgBC3eLGIZCAvw3cgfURvbXz99QgSUnNJ+OnCPR1eL+RSNc55hjXfY
         eNt4VD7qNWsE0GtMSJIpQJKG31DzbX0ANceqcQSdsOel9RuvXUBzus9frfhoASkEhUUk
         gNZoQQQlZruFJETna+Lonbqq/MRCNskfFO/p5KR1bYjCaJwg2RL2q3vrDa+zmRvgNkKj
         wg33VJfgOuAtIsYFoG/T+v4zZ9kLnXHNGilC/7fzfft6gkkP3TOWmviqjfvxFOlVQ2nG
         tI/aT2CPu8cRPbCK7ZDh7zdeVa41rKb9ySwYJtJTf6lQM0NuAOw4I1Cgqmv+fRvKMnel
         4qsg==
X-Gm-Message-State: AOAM530Rmk2tYLVJlz85Sb9kmRKmtCdayyjbHslvSudrcKHvgZxjX9fF
        mug2iGva832FQ4B328opUPFdOQ==
X-Google-Smtp-Source: ABdhPJz1WhCuTVXHDD6QOhULgG9i8OXhz4OWau8w2cQgW4jcTWpQlOcKDdkF6kfkaUkIxBX/nFR0qA==
X-Received: by 2002:a63:b141:: with SMTP id g1mr5087167pgp.269.1644476311381;
        Wed, 09 Feb 2022 22:58:31 -0800 (PST)
Received: from [10.76.15.169] ([61.120.150.76])
        by smtp.gmail.com with ESMTPSA id h10sm22807072pfc.103.2022.02.09.22.58.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 22:58:30 -0800 (PST)
Subject: PING: [PATCH 0/3] Introduce akcipher service for virtio-crypto
To:     mst@redhat.com, arei.gonglei@huawei.com
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        helei.sig11@bytedance.com
References: <20220121022438.1042547-1-pizhenwei@bytedance.com>
From:   zhenwei pi <pizhenwei@bytedance.com>
Message-ID: <9d07cc9d-b3f1-6fc9-eca1-6124f7baf7e0@bytedance.com>
Date:   Thu, 10 Feb 2022 14:55:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220121022438.1042547-1-pizhenwei@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PING!

PS: Please ignore the warning from kernel test robot, I'll fix it in 
next version.

On 1/21/22 10:24 AM, zhenwei pi wrote:
> Introduce akcipher service, implement RSA algorithm, and a minor fix.
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
>   include/uapi/linux/virtio_crypto.h            |  98 ++-
>   6 files changed, 693 insertions(+), 10 deletions(-)
>   create mode 100644 drivers/crypto/virtio/virtio_crypto_akcipher_algo.c
> 

-- 
zhenwei pi
