Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50389C4332F
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Nov 2023 13:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbjKBNoi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Nov 2023 09:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjKBNoh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Nov 2023 09:44:37 -0400
X-Greylist: delayed 164772 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 02 Nov 2023 06:44:31 PDT
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54AF8A6;
        Thu,  2 Nov 2023 06:44:31 -0700 (PDT)
Message-ID: <4258aabd-5f7b-4b7f-ab43-408b69bfdc58@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698932669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DTwsvEmzpAhkFeS3ka+z/7oD+5A+b+o8OiW8/532NK8=;
        b=mmRYxBfTPMqUnOevJs2i2n/PQ2FSWXnoLZCAPkqb9GifUye+mw9JQnOpVepQ2pc1PZJpMG
        pfhMcilABjbX0HwQ7maZZoGrTWGQ9YvLfCD3LyflGCjlJ9/KoqG8XeBAwUs1f8xh16zQzf
        z3x7MMzpz6wTy02+tXcoku2JycRmiek=
Date:   Thu, 2 Nov 2023 13:44:24 +0000
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v3 1/2] bpf: add skcipher API support to TC/XDP
 programs
Content-Language: en-US
To:     Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>
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
 <6947046d-27e3-90ee-3419-0b480af0abb0@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <6947046d-27e3-90ee-3419-0b480af0abb0@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 01/11/2023 23:41, Martin KaFai Lau wrote:
> On 11/1/23 3:50 PM, Vadim Fedorenko wrote:
>>>> +static void *__bpf_dynptr_data_ptr(const struct bpf_dynptr_kern *ptr)
>>>> +{
>>>> +    enum bpf_dynptr_type type;
>>>> +
>>>> +    if (!ptr->data)
>>>> +        return NULL;
>>>> +
>>>> +    type = bpf_dynptr_get_type(ptr);
>>>> +
>>>> +    switch (type) {
>>>> +    case BPF_DYNPTR_TYPE_LOCAL:
>>>> +    case BPF_DYNPTR_TYPE_RINGBUF:
>>>> +        return ptr->data + ptr->offset;
>>>> +    case BPF_DYNPTR_TYPE_SKB:
>>>> +        return skb_pointer_if_linear(ptr->data, ptr->offset, 
>>>> __bpf_dynptr_size(ptr));
>>>> +    case BPF_DYNPTR_TYPE_XDP:
>>>> +    {
>>>> +        void *xdp_ptr = bpf_xdp_pointer(ptr->data, ptr->offset, 
>>>> __bpf_dynptr_size(ptr));
>>>
>>> I suspect what it is doing here (for skb and xdp in particular) is 
>>> very similar to bpf_dynptr_slice. Please check if 
>>> bpf_dynptr_slice(ptr, 0, NULL, sz) will work.
>>>
>>
>> Well, yes, it's simplified version of bpf_dynptr_slice. The problem is
>> that bpf_dynptr_slice bpf_kfunc which cannot be used in another
>> bpf_kfunc. Should I refactor the code to use it in both places? Like
> 
> Sorry, scrolled too fast in my earlier reply :(
> 
> I am not aware of this limitation. What error does it have?
> The bpf_dynptr_slice_rdwr kfunc() is also calling the bpf_dynptr_slice() 
> kfunc.
> 
>> create __bpf_dynptr_slice() which will be internal part of bpf_kfunc?

Apparently Song has a patch to expose these bpf_dynptr_slice* functions
ton in-kernel users.

https://lore.kernel.org/bpf/20231024235551.2769174-2-song@kernel.org/

Should I wait for it to be merged before sending next version?
