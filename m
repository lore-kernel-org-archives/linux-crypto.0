Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B0A3C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Mar 2022 07:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiCWHhf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Mar 2022 03:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242260AbiCWHhe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Mar 2022 03:37:34 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAEDD74609
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 00:36:04 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mr5-20020a17090b238500b001c67366ae93so5592793pjb.4
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 00:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zvylfPpDD9P7LaVoOftyiAyZ4rjtzB+zBl0Umv/tVM8=;
        b=DRpcKWazqF/j9WlI8wmS2svwLYoi3ZrvlWHtWFCRpaYYQad4aGM5+KqGDh3unwJKNO
         nCeZrxwS//AlUXG0MZGTCWTc4MzpKlyri/EZR9aT7g3aCDodJUtmoGKvkeVOhaojjptD
         qaQ8/hZO2wpgYFHGvwBzmYLTwT9+opQ/Xo8maJo6ZJGGYb2OsGEVYcWY9hOdRDGwtTyg
         299GeeOXfEOrc5ZO6Ho/0skuS/yEe19FHUJcd/9qxKH1j92hWH7vNqgg/nGTjini/NkZ
         fRLTFYZuk4xfRIYoel7PdNUz1GXEGZkwUtiOl/CyTIBv2TW8tTATGeNYaKUkmgqejH/U
         qz3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zvylfPpDD9P7LaVoOftyiAyZ4rjtzB+zBl0Umv/tVM8=;
        b=PmyAuPqIWKg2rGU6/G/B+vF2zXAz4wQyVRWVAMONkWkwR7Q3RHbQjwSax5vEnR02A6
         vK1lYqjhbqyNQM2hUiMRhvNF9FaeKkpWbEBdZ9JgNbwSAh4ATym8+J8FVNv8RK7c5q1Z
         S4xS26UBWw77qIsMDazILbF+9ilHY9W3VrsrgWEJVLNtxHgGL2Jgea+yO/cugZRYmuP+
         yL7ILBho2PgN0/Ywv1euYiSRife7ipl7buz84V3J2VQkpJKgMlaD227IXKtUZ6s9j6K/
         O8RM1LnnZKPNxVHEumNMxCjDTSbZh+B2L5vIGzaPSKVZclzhfpVtsdpn7N90W+nWPzmd
         XsJg==
X-Gm-Message-State: AOAM532/d2tQClp1/B56/FbM5f8vLCKyBnQuG1eBxLriiqMboBmdY4P7
        KcppUmDkwIdDo1QqVrDAviT2Vg==
X-Google-Smtp-Source: ABdhPJyiRm/ds9KsWZNW+LTcMfpWdOU27E0yNqDGEitACnD7dqxgZWBF8j1F3DZKQNh5UngmIs8tgw==
X-Received: by 2002:a17:90a:4581:b0:1bc:d215:8722 with SMTP id v1-20020a17090a458100b001bcd2158722mr9837129pjg.149.1648020964224;
        Wed, 23 Mar 2022 00:36:04 -0700 (PDT)
Received: from [10.255.146.117] ([139.177.225.224])
        by smtp.gmail.com with ESMTPSA id il3-20020a17090b164300b001c6d5ed3cacsm5713618pjb.1.2022.03.23.00.36.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 00:36:03 -0700 (PDT)
Message-ID: <f806c17c-cc7e-e2eb-e187-e83148160322@bytedance.com>
Date:   Wed, 23 Mar 2022 15:32:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Re: [PATCH v3 0/6] Support akcipher for virtio-crypto
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     arei.gonglei@huawei.com, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        "helei.sig11@bytedance.com" <helei.sig11@bytedance.com>
References: <20220323024912.249789-1-pizhenwei@bytedance.com>
 <YjqtXFvfDq0kELl7@sol.localdomain>
From:   zhenwei pi <pizhenwei@bytedance.com>
In-Reply-To: <YjqtXFvfDq0kELl7@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 3/23/22 13:17, Eric Biggers wrote:
> On Wed, Mar 23, 2022 at 10:49:06AM +0800, zhenwei pi wrote:
>> v2 -> v3:
>> - Introduce akcipher types to qapi
>> - Add test/benchmark suite for akcipher class
>> - Seperate 'virtio_crypto: Support virtio crypto asym operation' into:
>>    - crypto: Introduce akcipher crypto class
>>    - virtio-crypto: Introduce RSA algorithm
>>
>> v1 -> v2:
>> - Update virtio_crypto.h from v2 version of related kernel patch.
>>
>> v1:
>> - Support akcipher for virtio-crypto.
>> - Introduce akcipher class.
>> - Introduce ASN1 decoder into QEMU.
>> - Implement RSA backend by nettle/hogweed.
>>
>> Lei He (3):
>>    crypto-akcipher: Introduce akcipher types to qapi
>>    crypto: Implement RSA algorithm by hogweed
>>    tests/crypto: Add test suite for crypto akcipher
>>
>> Zhenwei Pi (3):
>>    virtio-crypto: header update
>>    crypto: Introduce akcipher crypto class
>>    virtio-crypto: Introduce RSA algorithm
> 
> You forgot to describe the point of this patchset and what its use case is.
> Like any other Linux kernel patchset, that needs to be in the cover letter.
> 
> - Eric
Thanks Eric for pointing this missing part.

This feature provides akcipher service offloading capability. QEMU side 
handles asymmetric requests via virtio-crypto devices from guest side, 
do encrypt/decrypt/sign/verify operations on host side, and return the 
result to guest.

This patchset implements a RSA backend by hogweed from nettle, it works 
together with guest patch:
https://lkml.org/lkml/2022/3/1/1425

-- 
zhenwei pi
