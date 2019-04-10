Return-Path: <SRS0=kwSW=SM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F52C10F11
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 05:27:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B6C62083E
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 05:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfDJF1D (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Apr 2019 01:27:03 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:23489 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfDJF1D (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Apr 2019 01:27:03 -0400
Received: from [10.193.190.76] (atul.asicdesigners.com [10.193.190.76])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x3A5QcW9018745;
        Tue, 9 Apr 2019 22:26:39 -0700
Subject: Re: [crypto 0/4] Inline TLS client and v6 support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        dt@chelsio.com
References: <20190409152234.11100-1-atul.gupta@chelsio.com>
 <20190409110137.1ff359e0@cakuba.netronome.com>
From:   Atul Gupta <atul.gupta@chelsio.com>
Message-ID: <a443baa3-a192-2d3d-d3bf-20b0f12e53a4@chelsio.com>
Date:   Wed, 10 Apr 2019 10:56:37 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190409110137.1ff359e0@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 4/9/2019 11:31 PM, Jakub Kicinski wrote:
> On Tue,  9 Apr 2019 08:22:34 -0700, Atul Gupta wrote:
>> Extends Inline TLS record processing to TLS client. connect
>> API is added to tls_context to setup hardware for TLS
>> connection and handshake. Functionality wise, this makes the solution
>> end-to-end Inline TLS capable. TLS server and client
>> can operate in Inline mode and leverage hardware for complete
>> TLS record offload.
>> [0004] Adds the IPv6 support for Inline TLS server/client.
>>
>> RFC series for this patch was created against net-next and 
>> submitted on 18 Jan'2019.
>> This series is created against Herbert branch.
> Sorry if someone already asked this, but is your HW doing full ToE 
> for all this TLS "record offload" stuff?

Yes Jakub

Thanks

