Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 413D4C4332F
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Nov 2023 23:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235922AbjKAXsr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Nov 2023 19:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345521AbjKAXsh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Nov 2023 19:48:37 -0400
X-Greylist: delayed 387 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 01 Nov 2023 16:48:31 PDT
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A333DFE
        for <linux-crypto@vger.kernel.org>; Wed,  1 Nov 2023 16:48:31 -0700 (PDT)
Message-ID: <6947046d-27e3-90ee-3419-0b480af0abb0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698882116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZZMYinCK5nATTv27ermACPnZcPbsAMm/p92D7mhqgMY=;
        b=QMui0MZxANiw45tOWolfc71QUZDgiJoHtouJaZjQWLYa+MzmIGw0J8Xv/PXToqbIA8mMV1
        KVGXEo/hWM+zRBnI0s52u/UclkKdLwB4Uwc44bxg4rrTRRJg9UiKVBAMLSZuhCWM/kvG5K
        NjPfeErlG1Wy0w+hrt/C/phKmWXKVAg=
Date:   Wed, 1 Nov 2023 16:41:51 -0700
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
>>> +static void *__bpf_dynptr_data_ptr(const struct bpf_dynptr_kern *ptr)
>>> +{
>>> +    enum bpf_dynptr_type type;
>>> +
>>> +    if (!ptr->data)
>>> +        return NULL;
>>> +
>>> +    type = bpf_dynptr_get_type(ptr);
>>> +
>>> +    switch (type) {
>>> +    case BPF_DYNPTR_TYPE_LOCAL:
>>> +    case BPF_DYNPTR_TYPE_RINGBUF:
>>> +        return ptr->data + ptr->offset;
>>> +    case BPF_DYNPTR_TYPE_SKB:
>>> +        return skb_pointer_if_linear(ptr->data, ptr->offset, 
>>> __bpf_dynptr_size(ptr));
>>> +    case BPF_DYNPTR_TYPE_XDP:
>>> +    {
>>> +        void *xdp_ptr = bpf_xdp_pointer(ptr->data, ptr->offset, 
>>> __bpf_dynptr_size(ptr));
>>
>> I suspect what it is doing here (for skb and xdp in particular) is very 
>> similar to bpf_dynptr_slice. Please check if bpf_dynptr_slice(ptr, 0, NULL, 
>> sz) will work.
>>
> 
> Well, yes, it's simplified version of bpf_dynptr_slice. The problem is
> that bpf_dynptr_slice bpf_kfunc which cannot be used in another
> bpf_kfunc. Should I refactor the code to use it in both places? Like

Sorry, scrolled too fast in my earlier reply :(

I am not aware of this limitation. What error does it have?
The bpf_dynptr_slice_rdwr kfunc() is also calling the bpf_dynptr_slice() kfunc.

> create __bpf_dynptr_slice() which will be internal part of bpf_kfunc?






