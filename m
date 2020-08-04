Return-Path: <SRS0=wb3S=BO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A103C433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Aug 2020 04:20:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 705BE2067C
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Aug 2020 04:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgHDEUh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Aug 2020 00:20:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:55090 "EHLO
        mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgHDEUh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Aug 2020 00:20:37 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail.windriver.com (8.15.2/8.15.2) with ESMTPS id 0744KOsq006063
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Mon, 3 Aug 2020 21:20:25 -0700 (PDT)
Received: from [128.224.162.157] (128.224.162.157) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.50) with Microsoft SMTP Server id 14.3.487.0; Mon, 3 Aug 2020
 21:20:24 -0700
Subject: Re: [PATCH] crypto: ccp - zero the cmd data after use it
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>, David <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200803075858.3561-1-liwei.song@windriver.com>
 <20200803125242.GA7689@gondor.apana.org.au>
 <87ae939b-4983-4e96-cc3d-1aa1d1b3d3ae@windriver.com>
 <20200804040420.GA10850@gondor.apana.org.au>
From:   Liwei Song <liwei.song@windriver.com>
Message-ID: <1b6be879-8449-b519-046f-0312e57aa9a4@windriver.com>
Date:   Tue, 4 Aug 2020 12:20:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200804040420.GA10850@gondor.apana.org.au>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 8/4/20 12:04, Herbert Xu wrote:
> On Tue, Aug 04, 2020 at 11:51:47AM +0800, Liwei Song wrote:
>>
>> On 8/3/20 20:52, Herbert Xu wrote:
>>> On Mon, Aug 03, 2020 at 03:58:58PM +0800, Liwei Song wrote:
>>>> exist the following assignment in ccp(ignore the force
>>>> convert of the struct) by list_del in ccp_dequeue_cmd():
>>>> req->__ctx->cmd->entry->next = LIST_POISON1;
>>>>
>>>> after use the req, kzfree(req) can not zero the entry
>>>> entry->next = LIST_POISON1 of the ccp_cmd(cmd) struct
>>>> when this address available as slub freelist pointer, this will cause
>>>> the following "general protection fault" error if some process meet
>>>> this LIST_POISON1 value address when request memory:
>>>
>>> Your description makes no sense.  Please rewrite it and explain
>>> the problem properly.
>>
>> The problem here is that the entry of struct ccp_cmd is not zeroed after we use it,
>> If the other process got this address by kmalloc(), this illegal value "LIST_POISON1"
>> will cause "general protection fault" error.
> 
> If that's the case surely the other process should be zeroing
> the memory? Your explanation still makes no sense.

Yes, the other process should do this zero work, but the case I met is
this address will appear in the slab_alloc_node() as freelist pointer of slub,
and before slub do zero wrok, even kzalloc() doesn't work with this address.

Thanks,
Liwei.


> 
> Thanks,
> 
