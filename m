From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [PATCH V2 0/6] Enable NX 842 compression engine on Power9
Date: Tue, 18 Jul 2017 11:06:00 -0700
Message-ID: <20170718180600.GB21838@us.ibm.com>
References: <1500334999.995.6.camel@hbabu-laptop>
 <20170718161444.72252c9c@roar.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Haren Myneni <haren@linux.vnet.ibm.com>, mikey@neuling.org,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, ddstreet@ieee.org
To: Nicholas Piggin <nicholas.piggin@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58444 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751392AbdGRSGH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 14:06:07 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6II5Plk001803
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jul 2017 14:06:07 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bsdcfxs77-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jul 2017 14:06:06 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <sukadev@linux.vnet.ibm.com>;
        Tue, 18 Jul 2017 12:06:05 -0600
Content-Disposition: inline
In-Reply-To: <20170718161444.72252c9c@roar.ozlabs.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Nicholas Piggin [nicholas.piggin@gmail.com] wrote:
> On Mon, 17 Jul 2017 16:43:19 -0700
> Haren Myneni <haren@linux.vnet.ibm.com> wrote:
> 
> > [PATCH V2 0/6] Enable NX 842 compression engine on Power9
> > This patchset depends on VAS kernel changes:
> > https://lists.ozlabs.org/pipermail/linuxppc-dev/2017-May/158178.html
> 
> Just a question, we no longer invalidate the copy buffer on context
> switch after this patch:
> 
> 07d2a628bc ("powerpc/64s: Avoid cpabort in context switch when possible")
> 
> If your vas address mappings are visible only to kernel, only used in
> process / kthread context, and only used with kernel preemption disabled,
> this is okay.

Kernel preemption is not explicitly disabled in the NX driver I think
and

> 
> If userspace can possibly copy/paste to the mappings or if you need to
> sleep or call this from interrupt context, we need to work out how to
> invalidate the copy buffer.

user space cannot copy/paste to the mappings yet (that mechanism is
further out).

NX driver calls:

	vas_copy(&crb, ...);
	vas_paste(addr, ...);

but not from an interrupt context. Can/should we disable premption between
the copy/paste and to avoid having to invalidate the copy buffer?

Sukadev
