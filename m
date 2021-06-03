Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59633C47082
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 20:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30C6F610A8
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 20:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhFCU1E (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Jun 2021 16:27:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12848 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229640AbhFCU1D (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jun 2021 16:27:03 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 153K3xZ6060043;
        Thu, 3 Jun 2021 16:25:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=7ZTy10TVkl2nzkd3atwG7H7DcUr3ggbSaJmzOgWJ7zs=;
 b=LIOYT/H8MvzCsFapFqfjsedw+T52RniKcyDWwAjhUsiQUBIZbOqqDJiY58p6F1YJOSwC
 kwkHAlHwPreevUoSxzv3TmEpbEwOKp8Cr5zHyjHMBqP+DDbSpjf8h29cq+XBqeDPJdfC
 OFU78La6pLgltO/iEtEXUHxWEyi3cs3fxAq7a/qvEtXCcWFGS9HFQPczBQz9sWA7Yncl
 LI81iMD+MTJYkHIbjQEgaJZDw6Zg28UN0DWesa3H5ZX6aXL5BI+x04YIWXLNb+Q4cO4l
 HOnNwkX04sFC4+WLsQjoNSwuS2PD4U1qMS5jatu7GJLd3v+YqIIhwXsnl/UItWUZihMV +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38y576hake-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Jun 2021 16:25:09 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 153K5LPg064941;
        Thu, 3 Jun 2021 16:25:09 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38y576hak4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Jun 2021 16:25:09 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 153KCtAw006729;
        Thu, 3 Jun 2021 20:25:08 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02wdc.us.ibm.com with ESMTP id 38ud8a2msf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Jun 2021 20:25:08 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 153KP7tU18350482
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Jun 2021 20:25:07 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1F0C7805F;
        Thu,  3 Jun 2021 20:25:07 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C1E27805E;
        Thu,  3 Jun 2021 20:25:06 +0000 (GMT)
Received: from sig-9-77-136-17.ibm.com (unknown [9.77.136.17])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  3 Jun 2021 20:25:06 +0000 (GMT)
Message-ID: <27331a61f5f94b90748e60984a53cf8928e2d185.camel@linux.ibm.com>
Subject: Re: [PATCH v4 03/16] powerpc/vas: Add platform specific user window
 operations
From:   Haren Myneni <haren@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
Date:   Thu, 03 Jun 2021 13:25:04 -0700
In-Reply-To: <1622692598.4iphcb4vdf.astroid@bobo.none>
References: <8d219c0816133a8643d650709066cf04c9c77322.camel@linux.ibm.com>
         <f4fb4b7bb98580ae3c025d83148a6406541de892.camel@linux.ibm.com>
         <1622692598.4iphcb4vdf.astroid@bobo.none>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7sYm6qw9fIzpp8f-aO0u75M8ED43yfhn
X-Proofpoint-ORIG-GUID: WRJvWK--uW319J6223mZTsTecYhn2rOY
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-03_13:2021-06-03,2021-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 adultscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106030132
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 2021-06-03 at 14:05 +1000, Nicholas Piggin wrote:
> Excerpts from Haren Myneni's message of May 21, 2021 7:30 pm:
> > PowerNV uses registers to open/close VAS windows, and getting the
> > paste address. Whereas the hypervisor calls are used on PowerVM.
> > 
> > This patch adds the platform specific user space window operations
> > and register with the common VAS user space interface.
> 
> Basic idea makes sense. I don't understand this code in detail
> though.
> A couple of things,
> 
> > Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> > ---
> >  arch/powerpc/include/asm/vas.h              | 14 +++++-
> >  arch/powerpc/platforms/book3s/vas-api.c     | 52 ++++++++++++-----
> > ----
> >  arch/powerpc/platforms/powernv/vas-window.c | 46
> > +++++++++++++++++-
> >  3 files changed, 89 insertions(+), 23 deletions(-)
> > 
> > diff --git a/arch/powerpc/include/asm/vas.h
> > b/arch/powerpc/include/asm/vas.h
> > index 6076adf9ab4f..668303198772 100644
> > --- a/arch/powerpc/include/asm/vas.h
> > +++ b/arch/powerpc/include/asm/vas.h
> > @@ -5,6 +5,7 @@
> >  
> >  #ifndef _ASM_POWERPC_VAS_H
> >  #define _ASM_POWERPC_VAS_H
> > +#include <uapi/asm/vas-api.h>
> >  
> >  struct vas_window;
> >  
> > @@ -48,6 +49,16 @@ enum vas_cop_type {
> >  	VAS_COP_TYPE_MAX,
> >  };
> >  
> > +/*
> > + * User space window operations used for powernv and powerVM
> > + */
> > +struct vas_user_win_ops {
> > +	struct vas_window * (*open_win)(struct vas_tx_win_open_attr *,
> > +				enum vas_cop_type);
> > +	u64 (*paste_addr)(void *);
> > +	int (*close_win)(void *);
> 
> Without looking further into the series, why do these two take void
> * 
> when the first returns a vas_window * which appears to be the
> required
> argument to these?

Yes, vas_window * should be passed instead of void * for paste_addr() /
close_win()

> 
> > +static struct vas_user_win_ops vops =  {
> > +	.open_win	=	vas_user_win_open,
> > +	.paste_addr	=	vas_user_win_paste_addr,
> > +	.close_win	=	vas_user_win_close,
> > +};
> 
> const?
> 
> Thanks,
> Nick

