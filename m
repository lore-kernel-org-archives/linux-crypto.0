Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12ADEC4332F
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Nov 2023 23:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbjKAXAI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Nov 2023 19:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbjKAXAI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Nov 2023 19:00:08 -0400
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F48C1;
        Wed,  1 Nov 2023 16:00:02 -0700 (PDT)
Message-ID: <4adea710-72ca-0908-d280-625bc3682aa1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698879600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4sqmgjsG0HKRXnINDdYX/GSWOxBGCUrEHbZ1VjS0FC4=;
        b=UeXfnVc5fsyHfh7/ucNFUm88AL8HoePIFTrZsJJLU1YbNBrHxbwRAyHXUiSu5/xXrVGsI4
        ZFs14FsopunycDLUKVS17m9wafWnjM7KVC2PYGN6Rzzz2T4ffkXqkpi057NtyHdYLq0N9W
        GrZagU6f2MplQdgw/ZVciLirdx3ggKQ=
Date:   Wed, 1 Nov 2023 15:59:56 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v3 1/2] bpf: add skcipher API support to TC/XDP
 programs
Content-Language: en-US
To:     Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Vadim Fedorenko <vadfed@meta.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20231031134900.1432945-1-vadfed@meta.com>
 <dac97b74-5ff1-172b-9cd5-4cdcf07386ec@linux.dev>
 <91a6d5a7-7b18-48a2-9a74-7c00509467f8@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <91a6d5a7-7b18-48a2-9a74-7c00509467f8@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/1/23 3:50 PM, Vadim Fedorenko wrote:
>>> +static int bpf_crypto_skcipher_crypt(struct crypto_sync_skcipher *tfm,
>>> +                     const struct bpf_dynptr_kern *src,
>>> +                     struct bpf_dynptr_kern *dst,
>>> +                     const struct bpf_dynptr_kern *iv,
>>> +                     bool decrypt)
>>> +{
>>> +    struct skcipher_request *req = NULL;
>>> +    struct scatterlist sgin, sgout;
>>> +    int err;
>>> +
>>> +    if (crypto_sync_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
>>> +        return -EINVAL;
>>> +
>>> +    if (__bpf_dynptr_is_rdonly(dst))
>>> +        return -EINVAL;
>>> +
>>> +    if (!__bpf_dynptr_size(dst) || !__bpf_dynptr_size(src))
>>> +        return -EINVAL;
>>> +
>>> +    if (__bpf_dynptr_size(iv) != crypto_sync_skcipher_ivsize(tfm))
>>> +        return -EINVAL;
>>> +
>>> +    req = skcipher_request_alloc(&tfm->base, GFP_ATOMIC);
>>
>> Doing alloc per packet may kill performance. Is it possible to optimize it 
>> somehow? What is the usual size of the req (e.g. the example in the selftest)?
>>
> 
> In ktls code aead_request is allocated every time encryption is invoked, see 
> tls_decrypt_sg(), apparently per skb. Doesn't look like performance
> killer. For selftest it's only sizeof(struct skcipher_request).

ktls is doing the en/decrypt on the userspace behalf to compensate the cost.

When this kfunc is used in xdp to decrypt a few bytes for each packet and then 
XDP_TX out, this extra alloc will be quite noticeable. If the size is usually 
small, can it be done in the stack memory?

