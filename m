Return-Path: <SRS0=rgpc=NK=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35084 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728092AbeJ3W5F (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Oct 2018 18:57:05 -0400
From: "Benjamin Coddington" <bcodding@redhat.com>
To: "zhong jiang" <zhongjiang@huawei.com>
Cc: herbert@gondor.apana.org.au, trond.myklebust@hammerspace.com,
        bfields@redhat.com, linux-crypto@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org
Subject: Re: [Qestion] Lots of memory leaks when mounting and unmounting nfs
 client to server continuously.
Date: Tue, 30 Oct 2018 10:03:29 -0400
Message-ID: <8975EA60-7C42-426A-ADA3-DEE0E2CEE964@redhat.com>
In-Reply-To: <5BD86392.7070200@huawei.com>
References: <5BD85266.6000301@huawei.com>
 <1DEE371C-69EB-4D92-8F78-535AA5203007@redhat.com>
 <5BD86392.7070200@huawei.com>
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 30 Oct 2018, at 9:58, zhong jiang wrote:

> On 2018/10/30 21:06, Benjamin Coddington wrote:
>> Hi zhong jiang,
>>
>> Try asking in linux-nfs.. but I'll also note that 3.10-stable may be
>> missing a number of fixes to leaks in the NFS GSS code.
>>
>> I can see a more than a few fixes to memory leaks with: git log
>> --grep=leak --oneline net/sunrpc/auth_gss/
>>
> Thanks for your reply.  I has tested some of them in the upsteam as you
> have said.  but It fails to solve the issue completely.

What have you tested?  It is hard to help without specifics.
