Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD545C33CB1
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 07:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9E3C20748
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 07:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbgAPH5f (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 02:57:35 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:3402 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729241AbgAPH5e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 02:57:34 -0500
Received: from [10.193.191.49] (ayushsawal.asicdesigners.com [10.193.191.49])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 00G7vQgF004987;
        Wed, 15 Jan 2020 23:57:27 -0800
Cc:     linux-crypto@vger.kernel.org, manojmalviya@chelsio.com,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: Re: Advertise maximum number of sg supported by driver in single
 request
To:     herbert@gondor.apana.org.au
References: <20200115060234.4mm6fsmsrryzpymi@gondor.apana.org.au>
 <9fd07805-8e2e-8c3f-6e5e-026ad2102c5a@chelsio.com>
From:   Ayush Sawal <ayush.sawal@asicdesigners.com>
Message-ID: <c8d64068-a87b-36dd-910d-fb98e09c7e4b@asicdesigners.com>
Date:   Thu, 16 Jan 2020 13:27:24 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <9fd07805-8e2e-8c3f-6e5e-026ad2102c5a@chelsio.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

Sorry for the late reply

On 15/01/2020 14:02:34 +0800, Herbert Xu wrote:

> On Tue, Jan 14, 2020 at 03:23:30PM +0530, Ayush Sawal wrote
>> Hi all,
>>
>> The hardware crypto drivers have a limit on max number of sgs they can
>> handle per crypto request.If data size in one crypto request is
>> huge,hardware crypto driver may not be able to send the request in single
>> shot to hardware and end up using fallback to software.
>>
>> Does it make sense to have a new API for crypto drivers using that 
>> drivers
>> can advertise the max number of sg it can handle in one crypto request?
>>
>> and then  crypto framework may also have to include the similar API which
>> crypto framework user can use while forming the crypto request .
>>
>> Does this implementation make sense?
>
> What is the actual limit? Are you running into this limit with
> real-life requests?

The max data limit is 15 sgs where each sg contains data of mtu size .
we are running a netperf udp stream test over ipsec tunnel .The ipsec 
tunnel is established between two hosts which are directly connected

Thanks,

Ayush

