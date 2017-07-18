From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: Re: [PATCH V2 0/6] Enable NX 842 compression engine on Power9
Date: Tue, 18 Jul 2017 11:53:52 -0700
Message-ID: <596E5940.7000207@linux.vnet.ibm.com>
References: <1500334999.995.6.camel@hbabu-laptop> <20170718161444.72252c9c@roar.ozlabs.ibm.com> <20170718180600.GB21838@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Nicholas Piggin <nicholas.piggin@gmail.com>, mikey@neuling.org,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, ddstreet@ieee.org
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58583 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751392AbdGRSyD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 14:54:03 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6IIpCde142259
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jul 2017 14:54:02 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bsm69at35-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jul 2017 14:54:02 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
        Tue, 18 Jul 2017 12:54:01 -0600
In-Reply-To: <20170718180600.GB21838@us.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/18/2017 11:06 AM, Sukadev Bhattiprolu wrote:
> Nicholas Piggin [nicholas.piggin@gmail.com] wrote:
>> On Mon, 17 Jul 2017 16:43:19 -0700
>> Haren Myneni <haren@linux.vnet.ibm.com> wrote:
>>
>>> [PATCH V2 0/6] Enable NX 842 compression engine on Power9
>>> This patchset depends on VAS kernel changes:
>>> https://lists.ozlabs.org/pipermail/linuxppc-dev/2017-May/158178.html
>>
>> Just a question, we no longer invalidate the copy buffer on context
>> switch after this patch:
>>
>> 07d2a628bc ("powerpc/64s: Avoid cpabort in context switch when possible")
>>
>> If your vas address mappings are visible only to kernel, only used in
>> process / kthread context, and only used with kernel preemption disabled,
>> this is okay.
> 
> Kernel preemption is not explicitly disabled in the NX driver I think
> and
> 
>>
>> If userspace can possibly copy/paste to the mappings or if you need to
>> sleep or call this from interrupt context, we need to work out how to
>> invalidate the copy buffer.
> 
> user space cannot copy/paste to the mappings yet (that mechanism is
> further out).
> 
> NX driver calls:
> 
> 	vas_copy(&crb, ...);
> 	vas_paste(addr, ...);
> 
> but not from an interrupt context. Can/should we disable premption between
> the copy/paste and to avoid having to invalidate the copy buffer?

Nick, Also we do not support 842 in user space. Only future NX gzip compression module.

If OK, will add disable premption for copy/paste. Thanks for review, 
 
> 
> Sukadev
> 
