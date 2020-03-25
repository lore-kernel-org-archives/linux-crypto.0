Return-Path: <SRS0=6fPk=5K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE7EFC1975A
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 03:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA1AD206F6
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 03:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgCYDtP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Mar 2020 23:49:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41972 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727259AbgCYDtO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Mar 2020 23:49:14 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02P3XqOJ101823;
        Tue, 24 Mar 2020 23:49:00 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywf0pr2wh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Mar 2020 23:48:59 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02P3jm0Y030763;
        Tue, 24 Mar 2020 23:48:59 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywf0pr2wb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Mar 2020 23:48:59 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02P3kl8d007174;
        Wed, 25 Mar 2020 03:48:58 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 2ywawfwt9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 03:48:58 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02P3mvSB40239406
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 03:48:57 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 292496A051;
        Wed, 25 Mar 2020 03:48:57 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B1616A04D;
        Wed, 25 Mar 2020 03:48:56 +0000 (GMT)
Received: from [9.70.82.143] (unknown [9.70.82.143])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 25 Mar 2020 03:48:56 +0000 (GMT)
Subject: Re: [PATCH v4 3/9] powerpc/vas: Add VAS user space API
From:   Haren Myneni <haren@linux.ibm.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Daniel Axtens <dja@axtens.net>, herbert@gondor.apana.org.au,
        mikey@neuling.org, sukadev@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        npiggin@gmail.com
In-Reply-To: <87zhc6xvuk.fsf@mpe.ellerman.id.au>
References: <1584934879.9256.15321.camel@hbabu-laptop>
         <1584936142.9256.15325.camel@hbabu-laptop>
         <878sjrwm72.fsf@dja-thinkpad.axtens.net>
         <878sjrclmz.fsf@mpe.ellerman.id.au>
         <875zevw61j.fsf@dja-thinkpad.axtens.net>
         <87zhc6xvuk.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
Date:   Tue, 24 Mar 2020 20:48:23 -0700
Message-ID: <1585108103.10664.391.camel@hbabu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_10:2020-03-23,2020-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 impostorscore=0 malwarescore=0 mlxlogscore=772 spamscore=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250030
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 2020-03-24 at 14:41 +1100, Michael Ellerman wrote:
> Daniel Axtens <dja@axtens.net> writes:
> > Michael Ellerman <mpe@ellerman.id.au> writes:
> >> Daniel Axtens <dja@axtens.net> writes:
> >>> Haren Myneni <haren@linux.ibm.com> writes:
> >>>> diff --git a/arch/powerpc/platforms/powernv/vas-api.c b/arch/powerpc/platforms/powernv/vas-api.c
> >>>> new file mode 100644
> >>>> index 0000000..7d049af
> >>>> --- /dev/null
> >>>> +++ b/arch/powerpc/platforms/powernv/vas-api.c
> >>>> @@ -0,0 +1,257 @@
> >> ...
> >>>> +
> >>>> +static int coproc_mmap(struct file *fp, struct vm_area_struct *vma)
> >>>> +{
> >>>> +	struct vas_window *txwin = fp->private_data;
> >>>> +	unsigned long pfn;
> >>>> +	u64 paste_addr;
> >>>> +	pgprot_t prot;
> >>>> +	int rc;
> >>>> +
> >>>> +	if ((vma->vm_end - vma->vm_start) > PAGE_SIZE) {
> >>>
> >>> I think you said this should be 4096 rather than 64k, regardless of what
> >>> PAGE_SIZE you are compiled with?
> >>
> >> You can't mmap less than a page, a page is PAGE_SIZE bytes.
> >>
> >> So if that checked for 4K explicitly it would prevent mmap on 64K
> >> kernels always, which seems like not what you want?
> >
> > Ah. My bad. Carry on then :)
> 
> Well you were just quoting something from Haren, so I think it's over to
> him.

Sorry my mistake. 

I should change in documentation. vas_win_paste_addr() always returns 1
page. Restriction should be PAGE_SIZE. 

> 
> cheers


