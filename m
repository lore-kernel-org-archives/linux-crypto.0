Return-Path: <SRS0=EtZ3=SR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C739AC10F11
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 09:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F05D2073F
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 09:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfDOJKN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Apr 2019 05:10:13 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:13829 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbfDOJKN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Apr 2019 05:10:13 -0400
Received: from [10.193.190.76] (atul.asicdesigners.com [10.193.190.76])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x3F9A4mZ016552;
        Mon, 15 Apr 2019 02:10:05 -0700
Subject: Re: [crypto 0/4] Inline TLS client and v6 support
To:     David Miller <davem@davemloft.net>, jakub.kicinski@netronome.com
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, dt@chelsio.com
References: <20190411094010.61f93a25@cakuba.netronome.com>
 <ae56c100-d072-bf6b-465a-5136d29b84be@chelsio.com>
 <20190411114506.10d19a40@cakuba.netronome.com>
 <20190411.115228.894374097382770159.davem@davemloft.net>
From:   Atul Gupta <atul.gupta@chelsio.com>
Message-ID: <11ea3b48-4b50-3384-4e43-81248ec812b3@chelsio.com>
Date:   Mon, 15 Apr 2019 14:40:03 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190411.115228.894374097382770159.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 4/12/2019 12:22 AM, David Miller wrote:
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Date: Thu, 11 Apr 2019 11:45:06 -0700
>
>> I think the "netdev community" feels pretty strongly about preventing
>> protocol ossification and bypassing crucial parts of the infrastructure.
> Correct.

I understand the concern, the objective of complete offload of TLS record is an option to kTLS and other solutions. Have taken care to keep code out of netdev into crypto driver and allow user to choose record offload capability. Application buffer from socket is posted to HW for encryption, Segmentation and Tx on wire. The path provides near line-rate [100Gbps] Inline encrypt/decrypt b/w. If community feels this path adds value and can sit in crypto driver then I will work on build comments and resend v1?

Regards

Atul

