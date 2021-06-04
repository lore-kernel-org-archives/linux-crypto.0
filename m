Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E073AC47097
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jun 2021 01:20:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA49F613F1
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jun 2021 01:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhFDBV5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Jun 2021 21:21:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17142 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229820AbhFDBV5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jun 2021 21:21:57 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15414PUW049713;
        Thu, 3 Jun 2021 21:20:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=7+4rIRJCn1srmqye4r5/bIsTsqPy2bPsVUG68/2esDk=;
 b=VuzQim8nVUh8rPmf9O0XglJeQhJtbgqdsgqIcbXccy7wCS4EH2a3nT19aKitZoftQR3z
 D4KUidBIucMsQooLfE8ZfWh49heTjyEEfuwtFo8O57o/0LubUbDqUor9Au7Xy5otkwyC
 nCOGFONzxSK3897uVsXi2sFoQ2bMzkqJOK5vXl7UkZn5FZC99DEu5fUOxlrCGR7jM3PA
 iGj20lLjALWk1sOi5Pi4Sfh2+Lb6pachF6v6ylZScGvF4T6PiOE+zBny9dK2MZrp8tJd
 jG+hcvrucn46ngsk/ZggXQxhrrEy+9ugf4rzhU2E+FFRy/7Kcd4yXoRV2su0Kz5tzeRf Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38y8betkm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Jun 2021 21:20:02 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 154161w3055475;
        Thu, 3 Jun 2021 21:20:01 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38y8betkkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Jun 2021 21:20:01 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1541ClAd006369;
        Fri, 4 Jun 2021 01:20:00 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01dal.us.ibm.com with ESMTP id 38ud8a7b5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Jun 2021 01:20:00 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1541Jx4S11928184
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Jun 2021 01:19:59 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FAA213605E;
        Fri,  4 Jun 2021 01:19:59 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D557136060;
        Fri,  4 Jun 2021 01:19:58 +0000 (GMT)
Received: from sig-9-77-136-17.ibm.com (unknown [9.77.136.17])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  4 Jun 2021 01:19:57 +0000 (GMT)
Message-ID: <ab831a47cae65c67e1fae41acd9dcb8f3c55ac76.camel@linux.ibm.com>
Subject: Re: [PATCH v4 12/16] powerpc/pseries/vas: Setup IRQ and fault
 handling
From:   Haren Myneni <haren@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
Date:   Thu, 03 Jun 2021 18:19:55 -0700
In-Reply-To: <1622697882.lu1gj10oe8.astroid@bobo.none>
References: <8d219c0816133a8643d650709066cf04c9c77322.camel@linux.ibm.com>
         <5ac32e4d07bd048e3d687354501d36c334f1c8e0.camel@linux.ibm.com>
         <1622697882.lu1gj10oe8.astroid@bobo.none>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iyhTveem1hZR2YvrQ1wuQOWmUYKFz4O1
X-Proofpoint-ORIG-GUID: 7oqxD9MsOLBg3nZYN3la-9eBgHn51sVT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-03_15:2021-06-03,2021-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 clxscore=1015 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106040005
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 2021-06-03 at 15:48 +1000, Nicholas Piggin wrote:
> Excerpts from Haren Myneni's message of May 21, 2021 7:39 pm:
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
> >  arch/powerpc/platforms/pseries/vas.c | 111
> > +++++++++++++++++++++++++++
> >  1 file changed, 111 insertions(+)
> > 
> > diff --git a/arch/powerpc/platforms/pseries/vas.c
> > b/arch/powerpc/platforms/pseries/vas.c
> > index ef0c455f6e93..31dc17573f50 100644
> > --- a/arch/powerpc/platforms/pseries/vas.c
> > +++ b/arch/powerpc/platforms/pseries/vas.c
> > @@ -224,6 +224,62 @@ int plpar_vas_query_capabilities(const u64
> > hcall, u8 query_type,
> >  }
> >  EXPORT_SYMBOL_GPL(plpar_vas_query_capabilities);
> >  
> > +/*
> > + * HCALL to get fault CRB from pHyp.
> > + */
> > +static int plpar_get_nx_fault(u32 winid, u64 buffer)
> > +{
> > +	int64_t rc;
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
> > +	case H_STATE:
> > +		pr_err("HCALL(%x): No outstanding faults for window ID
> > %u\n",
> > +		       H_GET_NX_FAULT, winid);
> > +		return -EINVAL;
> > +	case H_PRIVILEGE:
> > +		pr_err("HCALL(%x): Window(%u): Invalid fault buffer
> > 0x%llx\n",
> > +		       H_GET_NX_FAULT, winid, buffer);
> > +		return -EACCES;
> > +	default:
> > +		pr_err("HCALL(%x): Unexpected error %lld for
> > window(%u)\n",
> > +		       H_GET_NX_FAULT, rc, winid);
> > +		return -EIO;
> > +	}
> > +}
> 
> Out of curiosity, you get one of these errors and it just drops the
> interrupt on the floor. Then what happens, I assume everything
> stops. Should it put some error in the csb, or signal the process or
> something? Or is there nothing very sane that can be done?

The user space polls on CSB with timout interval. If the kernel or NX
does not return, the request will be timeout.

The hypervisor returns the credit after H_GET_NX_FAULT HCALL is
successful. Also one credit is assigned for each window. So in this
case, the error is coming from the hypervisor and the application can
not issue another request on the same window. 

> 
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
> > +	struct vas_window *txwin = data;
> > +	struct coprocessor_request_block crb;
> > +	struct vas_user_win_ref *tsk_ref;
> > +	int rc;
> > +
> > +	rc = plpar_get_nx_fault(txwin->winid, (u64)virt_to_phys(&crb));
> > +	if (!rc) {
> > +		tsk_ref = &txwin->task_ref;
> > +		vas_dump_crb(&crb);
> 
> This (and existing powernv vas code) is printk()ing a lot of lines
> per 
> fault. This should be pretty normal operation I think? It should
> avoid
> filling the kernel logs, if so. Particularly if it can be triggered
> by 
> userspace.
> 
> I know it's existing code, so could be fixed separately from the
> series.

printk messages are only if HCALL returns failure or kernel issue (ex:
not valid window and etc on powerNV). These errors should not be
depending on the iser space requests. So generally we should not get
these errors.  

> 
> 
> > +		vas_update_csb(&crb, tsk_ref);
> > +	}
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +

