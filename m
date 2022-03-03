Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8955C433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Mar 2022 02:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiCCCCq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Mar 2022 21:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiCCCCp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Mar 2022 21:02:45 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8FC38AB
        for <linux-crypto@vger.kernel.org>; Wed,  2 Mar 2022 18:02:00 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id p8so3519004pfh.8
        for <linux-crypto@vger.kernel.org>; Wed, 02 Mar 2022 18:02:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8cIobXUGos4eqS6yTcZeG6b/dnVbjGhFoz3W2ZVDn2s=;
        b=pleEBLa8m2cMQ+1uDstwD0gO1ujAkJC8w7JX+czCrNwEkcW9bkeKolv4JBH2kbWED1
         oHA/3CKBiHmeMxHnnzeho4c/9sIh/mPhWU5exgMIHWstHaWw/xYA+XiYWebJr8xjaqsg
         X7Si2rizZdoIr2D8a5142aKNXUXUfrDG6qOQpPR+zcyq5HKDO5kNSDJcG757SjEZNu/B
         OcjGbnDzxHJBTOpukLJBNgGO0SXAX0M63wQbM7cp4tWZ4iNueL8g9NFR6DnvtSOlt1Vo
         IYQ3PsOFmEdcbEuVEqI3HQ87cWES8Rsvp2cWgNCeentZUMnAE8y613pJBOVE6vVSBfjl
         WG9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8cIobXUGos4eqS6yTcZeG6b/dnVbjGhFoz3W2ZVDn2s=;
        b=WBG09mYXCjikctLwB6Rlu4C5xXlWmaCaO6/uFux1Dz+uox5gJr7aWeCVxhcZdQ5f90
         iJbpeBRMOporn45JDa/UNxc1jC8BxxoWon+bqq2ZIAmc66t1/9XMvsX1O0fYNZud3bSY
         /y9kImU9hqVtOm9ekKUaQQqoGmqduF6OYZy64iIJgfxJniJaxTkuTn7qN416yy/7XK7l
         JxUjeoIAxR0kSGyQCNP1Ny0a8fefpVi22ZQjGoQJK/xDi6uBeHfYYG4dmF+cjuRlMLzY
         RlUr5koMF2OHiKQ8mGPmAVjIlG29cUxEAMtPDBIPdlkis6vdyJVLknbbOguhWc56ebMz
         3gbQ==
X-Gm-Message-State: AOAM532rrfxgdjzGxrNEkBhYB/JQgVpIiTpKC1gf/5SNjbrsLrMc6mQo
        DXnrQ7koQU+bF7bIuRU/LR55VA==
X-Google-Smtp-Source: ABdhPJwRB/dmHAgWApB90i9J8EAZVtuLSwQQucQk9VP2MLtTU7Q5qC6rx8boQVavL1CF4KOQf6x0Tg==
X-Received: by 2002:a63:914a:0:b0:36c:70c9:8057 with SMTP id l71-20020a63914a000000b0036c70c98057mr28260012pge.597.1646272920429;
        Wed, 02 Mar 2022 18:02:00 -0800 (PST)
Received: from [10.76.15.169] ([61.120.150.76])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a0023cf00b004e17e11cb17sm474850pfc.111.2022.03.02.18.01.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 18:01:59 -0800 (PST)
Subject: Re: Re: [PATCH v3 0/4] Introduce akcipher service for virtio-crypto
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     arei.gonglei@huawei.com, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, helei.sig11@bytedance.com
References: <20220302033917.1295334-1-pizhenwei@bytedance.com>
 <Yh/WUSBesj/tRncT@gmail.com>
From:   zhenwei pi <pizhenwei@bytedance.com>
Message-ID: <9bb1446c-2ae2-09b0-e7fe-4643567542d1@bytedance.com>
Date:   Thu, 3 Mar 2022 09:59:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <Yh/WUSBesj/tRncT@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/3/22 4:40 AM, Eric Biggers wrote:
> On Wed, Mar 02, 2022 at 11:39:13AM +0800, zhenwei pi wrote:
>> v2 -> v3:
>>    Rename virtio_crypto_algs.c to virtio_crypto_skcipher_algs.c, and
>>      minor changes of function name.
>>    Minor changes in virtio_crypto_akcipher_algs.c: no need to copy from
>>      buffer if opcode is verify.
>>
>> v1 -> v2:
>>    Fix 1 compiling warning reported by kernel test robot <lkp@intel.com>
>>    Put "__le32 akcipher_algo;" instead of "__le32 reserve;" field of
>>      struct virtio_crypto_config directly without size change.
>>    Add padding in struct virtio_crypto_ecdsa_session_para to keep
>>      64-bit alignment.
>>    Remove irrelevant change by code format alignment.
>>
>>    Also CC crypto gurus Herbert and linux-crypto@vger.kernel.org.
>>
>>    Test with QEMU(patched by the v2 version), works fine.
>>
>> v1:
>>    Introduce akcipher service, implement RSA algorithm, and a minor fix.
>>
>> zhenwei pi (4):
>>    virtio_crypto: Introduce VIRTIO_CRYPTO_NOSPC
>>    virtio-crypto: introduce akcipher service
>>    virtio-crypto: implement RSA algorithm
>>    virtio-crypto: rename skcipher algs
>>
>>   drivers/crypto/virtio/Makefile                |   3 +-
>>   .../virtio/virtio_crypto_akcipher_algs.c      | 585 ++++++++++++++++++
>>   drivers/crypto/virtio/virtio_crypto_common.h  |   7 +-
>>   drivers/crypto/virtio/virtio_crypto_core.c    |   6 +-
>>   drivers/crypto/virtio/virtio_crypto_mgr.c     |  15 +-
>>   ...o_algs.c => virtio_crypto_skcipher_algs.c} |   4 +-
>>   include/uapi/linux/virtio_crypto.h            |  82 ++-
>>   7 files changed, 693 insertions(+), 9 deletions(-)
>>   create mode 100644 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
>>   rename drivers/crypto/virtio/{virtio_crypto_algs.c => virtio_crypto_skcipher_algs.c} (99%)
> 
> Why is this patchset useful?  That isn't explained anywhere.
> 
> - Eric
> 
Sorry about this missing part.

This feature provides akcipher service offloading capability for guest 
side. And I also sent a patchset of QEMU:
https://patchwork.kernel.org/project/qemu-devel/cover/20220211084335.1254281-1-pizhenwei@bytedance.com/

The two patchsets work together, guest side sends 
encrypt/decrypt/sign/verify requests to host side, host side handles 
request and return response to the guest.

-- 
zhenwei pi
