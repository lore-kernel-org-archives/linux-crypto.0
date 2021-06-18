Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4684BC48BDF
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Jun 2021 07:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28D7B613B9
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Jun 2021 07:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbhFRHwI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Jun 2021 03:52:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57958 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231449AbhFRHwI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jun 2021 03:52:08 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15I7XnRa161809;
        Fri, 18 Jun 2021 03:49:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=dTIZ5axw1NujsOwjATMsWE2BYptzs1vQcDRoq+UzODc=;
 b=iKTGuRJGcMJlsSjyQ0h1w3xc7lYS2wKMe3kBH0g51YT1ORK8ddRKk8kUwQNWD28iGms9
 tCw4KcBSZvm+uOSsImlHkayo9CEwGpsHx9lViY58WjJG0xvKsNrIfcEG0xemV6Pkllst
 RDuzs8PAYtDkxwFThFec4ahLG28Xkns/+B4d1Ke+kyHSoeOaU8D4jzl5cjeS2VFIH75k
 T9nBRkSEow12WzUEk8vHEw6skUD0Zp546jgmOCUKwK6r3t99RpKgM10JwvIEQ8Q1VPh/
 Cj/gc6eiuhFNfNdlgYQaDgQLRLUqH0uYNkvL/1OjelOA8pQxbldNVljttrsQBBSBj2+S pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 398nktkaxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Jun 2021 03:49:46 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15I7YpSB168121;
        Fri, 18 Jun 2021 03:49:46 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 398nktkaxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Jun 2021 03:49:46 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15I7haP4005960;
        Fri, 18 Jun 2021 07:49:45 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01wdc.us.ibm.com with ESMTP id 394mj9yk4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Jun 2021 07:49:45 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15I7niNQ32833936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 07:49:44 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 252D5C605D;
        Fri, 18 Jun 2021 07:49:44 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADA21C605B;
        Fri, 18 Jun 2021 07:49:42 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.160.180.39])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 18 Jun 2021 07:49:42 +0000 (GMT)
Message-ID: <0d6ca1ec553a61b219f42ebf6699dd6c56e2e978.camel@linux.ibm.com>
Subject: Re: [PATCH v6 12/17] powerpc/pseries/vas: Integrate API with
 open/close windows
From:   Haren Myneni <haren@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
Date:   Fri, 18 Jun 2021 00:49:40 -0700
In-Reply-To: <1623971609.844odc55aw.astroid@bobo.none>
References: <827bf56dce09620ebecd8a00a5f97105187a6205.camel@linux.ibm.com>
         <e8d956bace3f182c4d2e66e343ff37cb0391d1fd.camel@linux.ibm.com>
         <1623971609.844odc55aw.astroid@bobo.none>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: S-sC37TKa9kPXiwhITFGlx0mpRHLq70M
X-Proofpoint-ORIG-GUID: q7BpOxNwB48C9HNNG4XB9yOINExUJ77G
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-17_17:2021-06-15,2021-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 lowpriorityscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106180042
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 2021-06-18 at 09:22 +1000, Nicholas Piggin wrote:
> Excerpts from Haren Myneni's message of June 18, 2021 6:36 am:
> > This patch adds VAS window allocatioa/close with the corresponding
> > hcalls. Also changes to integrate with the existing user space VAS
> > API and provide register/unregister functions to NX pseries driver.
> > 
> > The driver register function is used to create the user space
> > interface (/dev/crypto/nx-gzip) and unregister to remove this
> > entry.
> > 
> > The user space process opens this device node and makes an ioctl
> > to allocate VAS window. The close interface is used to deallocate
> > window.
> > 
> > Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> 
> Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
> 
> Unless there is some significant performance reason it might be
> simplest
> to take the mutex for the duration of the allocate and frees rather
> than 
> taking it several times, covering the atomic with the lock instead.
> 
> You have a big lock, might as well use it and not have to wonder what
> if 
> things race here or there.

Using mutex to protect allocate/deallocate window and setup/free IRQ,
also to protect updating the list. We do not need lock for modify
window hcall and other things. Hence taking mutex several times. Also
used atomic for counters (used_lpar_creds) which can be exported in
sysfs (this patch will be added later in next enhancement seris). 

Genarlly applications open window initially, do continuous copy/paste
operations and close window later. But possible that the library /
application to open/close window for each request. Also may be opening
or closing multiple windows (say 1000 depends on cores on the system)
at the same time. These cases may affect the application performance.

Thanks
Haren

> 
> But don't rework that now, maybe just something to consider for
> later.
> 
> Thanks,
> Nick
> 

