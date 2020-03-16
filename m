Return-Path: <SRS0=DGAQ=5B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 543E2C0044D
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 21:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3052A20658
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 21:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732702AbgCPVvZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Mar 2020 17:51:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26426 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732636AbgCPVvZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Mar 2020 17:51:25 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02GLfWm7078990;
        Mon, 16 Mar 2020 17:51:12 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ytb3nndj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Mar 2020 17:51:11 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02GLoWrP009983;
        Mon, 16 Mar 2020 21:51:11 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 2yrpw6fx34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Mar 2020 21:51:11 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02GLpAMr53608832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 21:51:10 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25EE1B2064;
        Mon, 16 Mar 2020 21:51:10 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 800D0B205F;
        Mon, 16 Mar 2020 21:51:09 +0000 (GMT)
Received: from [9.70.82.143] (unknown [9.70.82.143])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 16 Mar 2020 21:51:09 +0000 (GMT)
Subject: Re: [PATCH 0/5] selftests/powerpc: Add NX-GZIP engine testcase
From:   Haren Myneni <haren@linux.ibm.com>
To:     Raphael Moreira Zinsly <rzinsly@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, mpe@ellerman.id.au, abali@us.ibm.com
In-Reply-To: <20200316180714.18631-1-rzinsly@linux.ibm.com>
References: <20200316180714.18631-1-rzinsly@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date:   Mon, 16 Mar 2020 14:50:50 -0700
Message-ID: <1584395450.9256.14334.camel@hbabu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-16_10:2020-03-12,2020-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 spamscore=0 adultscore=0 phishscore=0 clxscore=1015 malwarescore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160088
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 2020-03-16 at 15:07 -0300, Raphael Moreira Zinsly wrote:
> This patch series are intended to test the power8 and power9 Nest
> Accelerator (NX) GZIP engine that is being introduced by
> https://lists.ozlabs.org/pipermail/linuxppc-dev/2020-March/205659.html
> More information about how to access the NX can be found in that patch, also a
> complete userspace library and more documentation can be found at:
> https://github.com/libnxz/power-gzip
> 
Raphael, Please delete power8 reference. NX-GZIP engine and user space
support (with VAS) are introduced in P9. 

> 
> Thanks,
> Raphael
> 
> 


