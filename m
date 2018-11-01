Return-Path: <SRS0=waMk=NM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:51371 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728198AbeKAXVg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Nov 2018 19:21:36 -0400
Message-ID: <5BDB0B28.6010106@huawei.com>
Date: Thu, 1 Nov 2018 22:18:16 +0800
From: zhong jiang <zhongjiang@huawei.com>
MIME-Version: 1.0
To: Benjamin Coddington <bcodding@redhat.com>
CC: <herbert@gondor.apana.org.au>, <trond.myklebust@hammerspace.com>,
        <bfields@redhat.com>, <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-nfs@vger.kernel.org>
Subject: Re: [Qestion] Lots of memory leaks when mounting and unmounting nfs
 client to server continuously.
References: <5BD85266.6000301@huawei.com> <1DEE371C-69EB-4D92-8F78-535AA5203007@redhat.com> <5BD86392.7070200@huawei.com> <8975EA60-7C42-426A-ADA3-DEE0E2CEE964@redhat.com>
In-Reply-To: <8975EA60-7C42-426A-ADA3-DEE0E2CEE964@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2018/10/30 22:03, Benjamin Coddington wrote:
> On 30 Oct 2018, at 9:58, zhong jiang wrote:
>
>> On 2018/10/30 21:06, Benjamin Coddington wrote:
>>> Hi zhong jiang,
>>>
>>> Try asking in linux-nfs.. but I'll also note that 3.10-stable may be
>>> missing a number of fixes to leaks in the NFS GSS code.
>>>
>>> I can see a more than a few fixes to memory leaks with: git log
>>> --grep=leak --oneline net/sunrpc/auth_gss/
>>>
>> Thanks for your reply.  I has tested some of them in the upsteam as you
>> have said.  but It fails to solve the issue completely.
> What have you tested?  It is hard to help without specifics.
Hi,  Benjamin

I have tested all of the the following patches in the latest mainline.

git log --grep=leak --oneline net/sunrpc/auth_gss/

Unfortunately,  None of the patches works. 

Could you give some clues?

Thanks,
zhong jiang
