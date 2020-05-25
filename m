Return-Path: <SRS0=4LZm=7H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E1B0C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 07:13:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 573E92071A
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 07:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388961AbgEYHNh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 May 2020 03:13:37 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59298 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388951AbgEYHNh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 May 2020 03:13:37 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 40DA53E6F75ED8ACB62E;
        Mon, 25 May 2020 15:13:34 +0800 (CST)
Received: from [10.174.151.115] (10.174.151.115) by smtp.huawei.com
 (10.3.19.214) with Microsoft SMTP Server (TLS) id 14.3.487.0; Mon, 25 May
 2020 15:13:25 +0800
Subject: Re: [PATCH 2/2] crypto: virtio: Fix use-after-free in
 virtio_crypto_skcipher_finalize_req()
To:     Markus Elfring <Markus.Elfring@web.de>,
        <linux-crypto@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>
CC:     Arei Gonglei <arei.gonglei@huawei.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        <linux-kernel@vger.kernel.org>
References: <a5ef5d51-e35c-983f-8e7f-5f19552abe9e@web.de>
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Message-ID: <a17850bb-f70d-1f77-3823-afd70816ce57@huawei.com>
Date:   Mon, 25 May 2020 15:13:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <a5ef5d51-e35c-983f-8e7f-5f19552abe9e@web.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.151.115]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Markus,

On 2020/5/25 14:30, Markus Elfring wrote:
>> … So the system will crash
>> at last when this memory be used again.
> 
> I would prefer a wording with less typos here.
> 
Could you help me to make the sentence better?

> 
>> We can free the resources before calling ->complete to fix this issue.
> 
> * An imperative wording can be nicer.
>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?id=9cb1fd0efd195590b828b9b865421ad345a4a145#n151
> 
I'll try.

> * You proposed to move a call of the function “crypto_finalize_skcipher_request”.
>   How does this change fit to the mentioned position?
> 
The resources which need to be freed is not used anymore, but the pointers
of these resources may be changed in the function
"crypto_finalize_skcipher_request", so free these resources before call the
function is suitable.

> * Would you like to add the tag “Fixes” to the commit message?
>
OK.

> Regards,
> Markus
> 

-- 
---
Regards,
Longpeng(Mike)
