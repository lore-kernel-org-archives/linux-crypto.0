Return-Path: <SRS0=LUcm=VV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1929C7618B
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Jul 2019 07:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB6582190F
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Jul 2019 07:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725826AbfGXHmv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Jul 2019 03:42:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47322 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725776AbfGXHmv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Jul 2019 03:42:51 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6O7fkF3016424;
        Wed, 24 Jul 2019 03:42:21 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2txhdnct6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Jul 2019 03:42:21 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6O7fnO3016760;
        Wed, 24 Jul 2019 03:42:20 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2txhdnct6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Jul 2019 03:42:20 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6O7eJpm002862;
        Wed, 24 Jul 2019 07:42:19 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04dal.us.ibm.com with ESMTP id 2tx61mvr0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Jul 2019 07:42:19 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6O7gIwG29688148
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 07:42:18 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63BC6BE051;
        Wed, 24 Jul 2019 07:42:18 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 407C4BE04F;
        Wed, 24 Jul 2019 07:42:16 +0000 (GMT)
Received: from birb.localdomain (unknown [9.81.210.128])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with SMTP;
        Wed, 24 Jul 2019 07:42:15 +0000 (GMT)
Received: by birb.localdomain (Postfix, from userid 1000)
        id 71965478272; Wed, 24 Jul 2019 17:42:11 +1000 (AEST)
From:   Stewart Smith <stewart@linux.ibm.com>
To:     Nishka Dasgupta <nishkadg.linux@gmail.com>, haren@us.ibm.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nishka Dasgupta <nishkadg.linux@gmail.com>
Subject: Re: [PATCH] crypto: nx: nx-842-powernv: Add of_node_put() before return
In-Reply-To: <20190723080851.7648-1-nishkadg.linux@gmail.com>
References: <20190723080851.7648-1-nishkadg.linux@gmail.com>
Date:   Wed, 24 Jul 2019 17:42:11 +1000
Message-ID: <874l3b7ub0.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-24_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907240086
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Nishka Dasgupta <nishkadg.linux@gmail.com> writes:
> Each iteration of for_each_child_of_node puts the previous node, but

This is for_each_compatible_node.

otherwise looks okay,

Acked-by: Stewart Smith <stewart@linux.ibm.com>

-- 
Stewart Smith
OPAL Architect, IBM.
