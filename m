From: Harsh Jain <harsh@chelsio.com>
Subject: Re: [PATCH] crypto: AF_ALG - inline IV support
Date: Tue, 23 Jan 2018 16:32:07 +0530
Message-ID: <51c57076-4a01-308c-583b-8c34afc3b2e4@chelsio.com>
References: <2118226.LQArbCsRu5@tauon.chronox.de>
 <1972650.zFSS3VNpIS@tauon.chronox.de>
 <2165621.DHQGk8sIp3@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, jonathan.cameron@huawei.com
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:11347 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751234AbeAWLCY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jan 2018 06:02:24 -0500
In-Reply-To: <2165621.DHQGk8sIp3@positron.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 21-01-2018 17:44, Stephan Müller wrote:
> Hi Herbert,
>
> I tried to summarize the use cases of the AIO support at [1].
>
> The use case covering the inline IV support is documented in section [2]. It 
> naturally would depend on this patch to be accepted. What is your take on this 
> use case?
>
> What is your take on the issue outlined at [3]? Should the affected drivers be 
> updated?

Till now driver is using content of req->info as IV for cipher operation and It treats each request independent of previous request.

>From description given at [1]. Following is the new requirement for Driver.
"The cipher implementations ensure that although the IOVECs cause parallel
invocation of the recvmsg handler, they are serialized such that the
one IV sent to the kernel is updated by the first cipher operation and
used as input to the second cipher operation, and so on. This implies,
for example, that the CBC block chaining operation is applied
for all IOVECs."

To make this work how driver will know that it has to delay the processing of current request because previous request is not complete(or IV is not available) .

> Thanks
> Stephan
>
> [1] https://github.com/smuellerDD/libkcapi/commit/
> 29132075b8f045f3f92367c0190add81ccf5da11
>
> [2] https://github.com/smuellerDD/libkcapi/commit/
> 29132075b8f045f3f92367c0190add81ccf5da11#diff-
> dce7a00cbc610df94f0dc27eb769d01dR644
>
> [3] https://github.com/smuellerDD/libkcapi/commit/
> 29132075b8f045f3f92367c0190add81ccf5da11#diff-
> dce7a00cbc610df94f0dc27eb769d01dR575
>
>
