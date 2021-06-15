Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9860EC48BE5
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Jun 2021 09:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FBE9610CD
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Jun 2021 09:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhFOJDg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Jun 2021 05:03:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27314 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231243AbhFOJDf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Jun 2021 05:03:35 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15F8XvEK175759;
        Tue, 15 Jun 2021 05:01:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=1QXn0DRR/E8VxqdKD7SQVXeoDlJZb9XOvfDDurNWDYY=;
 b=eAdJ4UXIGU5M/nMRn+OisLkUO6AZeCMBvsmtL/AcLzvjlJQwLRBVp81K1YEmfsZq2Zxg
 gAh9C0jNnO1gYWLrF4ZvrQV3/61oDPcte68myvPOCi34/+h4Aj1ugI1Dp5g109cThWs8
 1q/t6gVaQyTsK4bvCoO5igEciHMCMVcJ3X/iK48759JswWLy2vXV2q0Mic2nqXVNWhU6
 fQDEqWXZVu/epUUutcOLADqbaK/BjQ+FW/rprPRO0QjHXPyPdOAq1nSnFjooBZw4w9T3
 8/7ZKDs3pdimMy0gIFk1dyBe9oBV/mnkb20/TDGt15rahPmRrazseKJ0R94KyS0+6M2v Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 396q7v3v0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Jun 2021 05:01:16 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15F8Y4BB176506;
        Tue, 15 Jun 2021 05:01:15 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 396q7v3v0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Jun 2021 05:01:15 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15F8w9hQ008014;
        Tue, 15 Jun 2021 09:01:15 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04dal.us.ibm.com with ESMTP id 3965yth8e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Jun 2021 09:01:15 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15F91EGs24641996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Jun 2021 09:01:14 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22724B2064;
        Tue, 15 Jun 2021 09:01:14 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21268B205F;
        Tue, 15 Jun 2021 09:01:13 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.160.180.39])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Jun 2021 09:01:12 +0000 (GMT)
Message-ID: <09992f14d25b9212686acfa85e8e4cab93b6b1fc.camel@linux.ibm.com>
Subject: Re: [PATCH v5 13/17] powerpc/pseries/vas: Setup IRQ and fault
 handling
From:   Haren Myneni <haren@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
Date:   Tue, 15 Jun 2021 02:01:11 -0700
In-Reply-To: <1623639403.054wgu233i.astroid@bobo.none>
References: <ed7a09822cf3a2e463f942e5a37309a2365c9d79.camel@linux.ibm.com>
         <8a9fe47a17d1f89cc43885d2ef8c2f09e4e90d7a.camel@linux.ibm.com>
         <1623639403.054wgu233i.astroid@bobo.none>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lLoIccTf1gtvk6P8Yi52fVUjUb6vQ5y9
X-Proofpoint-GUID: 6ZyYZ8DOKysSol7dfI2GEujj9LGQfNYf
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-15_04:2021-06-14,2021-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106150051
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 2021-06-14 at 13:07 +1000, Nicholas Piggin wrote:
> Excerpts from Haren Myneni's message of June 13, 2021 9:02 pm:
> > NX generates an interrupt when sees a fault on the user space
> > buffer and the hypervisor forwards that interrupt to OS. Then
> > the kernel handles the interrupt by issuing H_GET_NX_FAULT hcall
> > to retrieve the fault CRB information.
> > 
> > This patch also adds changes to setup and free IRQ per each
> > window and also handles the fault by updating the CSB.
> > 
> > Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> > ---
> >  arch/powerpc/platforms/pseries/vas.c | 108
> > +++++++++++++++++++++++++++
> >  1 file changed, 108 insertions(+)
> > 
> > diff --git a/arch/powerpc/platforms/pseries/vas.c
> > b/arch/powerpc/platforms/pseries/vas.c
> > index fe375f7a7029..55185bdd3776 100644
> > --- a/arch/powerpc/platforms/pseries/vas.c
> > +++ b/arch/powerpc/platforms/pseries/vas.c
> > @@ -11,6 +11,7 @@
> >  #include <linux/types.h>
> >  #include <linux/delay.h>
> >  #include <linux/slab.h>
> > +#include <linux/interrupt.h>
> >  #include <asm/machdep.h>
> >  #include <asm/hvcall.h>
> >  #include <asm/plpar_wrappers.h>
> > @@ -190,6 +191,58 @@ int h_query_vas_capabilities(const u64 hcall,
> > u8 query_type, u64 result)
> >  }
> >  EXPORT_SYMBOL_GPL(h_query_vas_capabilities);
> >  
> > +/*
> > + * hcall to get fault CRB from pHyp.
> > + */
> > +static int h_get_nx_fault(u32 winid, u64 buffer)
> > +{
> > +	long rc;
> > +
> > +	rc = plpar_hcall_norets(H_GET_NX_FAULT, winid, buffer);
> > +
> > +	switch (rc) {
> > +	case H_SUCCESS:
> > +		return 0;
> > +	case H_PARAMETER:
> > +		pr_err("HCALL(%x): Invalid window ID %u\n",
> > H_GET_NX_FAULT,
> > +		       winid);
> > +		return -EINVAL;
> > +	case H_PRIVILEGE:
> > +		pr_err("HCALL(%x): Window(%u): Invalid fault buffer
> > 0x%llx\n",
> > +		       H_GET_NX_FAULT, winid, buffer);
> > +		return -EACCES;
> > +	default:
> > +		pr_err("HCALL(%x): Failed with error %ld for
> > window(%u)\n",
> > +		       H_GET_NX_FAULT, rc, winid);
> > +		return -EIO;
> 
> 3 error messages have 3 different formats for window ID.
> 
> I agree with Michael you could just have one error message that
> reports 
> the return value. Also "H_GET_NX_FAULT: " would be nicer than
> "HCALL(380): "

yes, Added just one printk for all error codes except for errors which
depend on arguments to HCALL (Ex: WinID).

Sure, I will add just one error message and print all arguments passed
to HCALL. 

pr_err("H_GET_NX_FAULT: window(%u), fault buffer(0x%llx) Failed with
error %ld\n", rc, winid, buffer);


> 
> Check how some other hcall failures are reported, "hcall failed: 
> H_CALL_NAME" seems to have a few takers.
> 
> > +	}
> > +}
> > +
> > +/*
> > + * Handle the fault interrupt.
> > + * When the fault interrupt is received for each window, query
> > pHyp to get
> > + * the fault CRB on the specific fault. Then process the CRB by
> > updating
> > + * CSB or send signal if the user space CSB is invalid.
> > + * Note: pHyp forwards an interrupt for each fault request. So one
> > fault
> > + *	CRB to process for each H_GET_NX_FAULT HCALL.
> > + */
> > +irqreturn_t pseries_vas_fault_thread_fn(int irq, void *data)
> > +{
> > +	struct pseries_vas_window *txwin = data;
> > +	struct coprocessor_request_block crb;
> > +	struct vas_user_win_ref *tsk_ref;
> > +	int rc;
> > +
> > +	rc = h_get_nx_fault(txwin->vas_win.winid,
> > (u64)virt_to_phys(&crb));
> > +	if (!rc) {
> > +		tsk_ref = &txwin->vas_win.task_ref;
> > +		vas_dump_crb(&crb);
> > +		vas_update_csb(&crb, tsk_ref);
> > +	}
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> >  /*
> >   * Allocate window and setup IRQ mapping.
> >   */
> > @@ -201,10 +254,51 @@ static int allocate_setup_window(struct
> > pseries_vas_window *txwin,
> >  	rc = h_allocate_vas_window(txwin, domain, wintype,
> > DEF_WIN_CREDS);
> >  	if (rc)
> >  		return rc;
> > +	/*
> > +	 * On powerVM, pHyp setup and forwards the fault interrupt per
> 
>            The hypervisor forwards the fault interrupt per-window...
> 
> > +	 * window. So the IRQ setup and fault handling will be done for
> > +	 * each open window separately.
> > +	 */
> > +	txwin->fault_virq = irq_create_mapping(NULL, txwin->fault_irq);
> > +	if (!txwin->fault_virq) {
> > +		pr_err("Failed irq mapping %d\n", txwin->fault_irq);
> > +		rc = -EINVAL;
> > +		goto out_win;
> > +	}
> > +
> > +	txwin->name = kasprintf(GFP_KERNEL, "vas-win-%d",
> > +				txwin->vas_win.winid);
> > +	if (!txwin->name) {
> > +		rc = -ENOMEM;
> > +		goto out_irq;
> > +	}
> > +
> > +	rc = request_threaded_irq(txwin->fault_virq, NULL,
> > +				  pseries_vas_fault_thread_fn,
> > IRQF_ONESHOT,
> > +				  txwin->name, txwin);
> > +	if (rc) {
> > +		pr_err("VAS-Window[%d]: Request IRQ(%u) failed with
> > %d\n",
> > +		       txwin->vas_win.winid, txwin->fault_virq, rc);
> > +		goto out_free;
> > +	}
> >  
> >  	txwin->vas_win.wcreds_max = DEF_WIN_CREDS;
> >  
> >  	return 0;
> > +out_free:
> > +	kfree(txwin->name);
> > +out_irq:
> > +	irq_dispose_mapping(txwin->fault_virq);
> > +out_win:
> > +	h_deallocate_vas_window(txwin->vas_win.winid);
> > +	return rc;
> > +}
> > +
> > +static inline void free_irq_setup(struct pseries_vas_window
> > *txwin)
> > +{
> > +	free_irq(txwin->fault_virq, txwin);
> > +	irq_dispose_mapping(txwin->fault_virq);
> > +	kfree(txwin->name);
> 
> Nit, but this freeing is in a different order than the error handling
> in 
> the function does. I'd just keep it the same unless there is a reason
> to 
> be different, in which case it could use a comment.

shouldn't matter, I can change it to:
static inline void free_irq_setup(struct pseries_vas_window *txwin)
{
        free_irq(txwin->fault_virq, txwin);
        kfree(txwin->name);
        irq_dispose_mapping(txwin->fault_virq);
}

Thanks
Haren

> 
> So long as the irq can't somehow fire and try to use txwin->name,
> you 
> might be okay.
> 
> Otherwise I _think_ it's okay, but I don't know the irq APIs well.
> 
> Thanks,
> Nick
> 
> >  }
> >  
> >  static struct vas_window *vas_allocate_window(struct
> > vas_tx_win_open_attr *uattr,
> > @@ -320,6 +414,11 @@ static struct vas_window
> > *vas_allocate_window(struct vas_tx_win_open_attr *uattr
> >  	return &txwin->vas_win;
> >  
> >  out_free:
> > +	/*
> > +	 * Window is not operational. Free IRQ before closing
> > +	 * window so that do not have to hold mutex.
> > +	 */
> 
> Why don't you have to hold the mutex in that case?
> 
> > +	free_irq_setup(txwin);
> >  	h_deallocate_vas_window(txwin->vas_win.winid);
> >  out:
> >  	atomic_dec(&ct_caps->used_lpar_creds);
> > @@ -339,7 +438,16 @@ static int deallocate_free_window(struct
> > pseries_vas_window *win)
> >  {
> >  	int rc = 0;
> >  
> > +	/*
> > +	 * Free IRQ after executing H_DEALLOCATE_VAS_WINDOW HCALL
> > +	 * to close the window. pHyp waits for all requests including
> > +	 * faults are processed before closing the window - Means all
> > +	 * credits are returned. In the case of fault request, credit
> > +	 * is returned after OS issues H_GET_NX_FAULT HCALL.
> > +	 */
> >  	rc = h_deallocate_vas_window(win->vas_win.winid);
> > +	if (!rc)
> > +		free_irq_setup(win);
> >  
> >  	return rc;
> >  }
> > -- 
> > 2.18.2
> > 
> > 
> > 

