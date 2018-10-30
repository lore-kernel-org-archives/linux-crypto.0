Return-Path: <SRS0=rgpc=NK=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:59098 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728071AbeJ3XX0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Oct 2018 19:23:26 -0400
Message-ID: <5BD86AD3.1070102@huawei.com>
Date: Tue, 30 Oct 2018 22:29:39 +0800
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
In the latest mainline.  we can filter the following result by the key word "leak"
in net/sunrpc/auth_gss.

0070ed3 Fix 16-byte memory leak in gssp_accept_sec_context_upcall   (has been tested,  Fail to work)
78794d1 svcrpc: don't leak contexts on PROC_DESTROY     (has been tested,  Fail to work)
a1d1e9b svcrpc: fix memory leak in gssp_accept_sec_context_upcall  (Not yet)
e9776d0 SUNRPC: Fix a pipe_version reference leak   (Not yet)
cdead7c SUNRPC: Fix a potential memory leak in auth_gss (Not yet)
980e5a4 nfsd: fix rsi_cache reference count leak  (Not yet)
07a2bf1 SUNRPC: Fix a memory leak in gss_create()  (Not yet)
3ab9bb7 SUNRPC: Fix a memory leak in the auth credcache code (existed)
54f9247 knfsd: fix resource leak resulting in module refcount leak for rpcsec_gss_krb5.ko  (existed)
b797b5b [PATCH] knfsd: svcrpc: fix gss krb5i memory leak  (existed)
d4a30e7 RPCSEC_GSS: fix leak in krb5 code caused by superfluous kmalloc (Not yet)


I suspect that  commit d4a30e7 ("RPCSEC_GSS: fix leak in krb5 code caused by superfluous kmalloc")  will solve
the issue.  Further,  I will adjust the patch  to 3.10.  and see what it will happen.  Actually I am not sure. :-[

Thanks,
zhong jiang.
