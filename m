Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C782C11F68
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jun 2021 12:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58BB9619A0
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jun 2021 12:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234480AbhF3MQI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Jun 2021 08:16:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40212 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234606AbhF3MQG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Jun 2021 08:16:06 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15UC4KXD057734;
        Wed, 30 Jun 2021 08:13:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to; s=pp1;
 bh=9dhjKqz1rsXAQo8OlwkySPH/3Pt+cnwJ5HuLFbrEPUQ=;
 b=SHHc+7PAF0hrePFgWJkvpSlSm8dSBquT1giP6tbELQRhbusUf8q/TtNt2ZS6D/QQbKuJ
 3cnXa8extTvRONcJQee1YyNAgS4OF0bYGK0pde3AfhAmkJTGzmuj6GkeUXm6NlQoWZW8
 SMh7+6KcFSQaS6qLWazkxJGd9yNF8rIx0SB1BTpZrFp1gVcR8frJqgZHSB3GfbfnMbv/
 ThwsQ6GRTyjGIoASbgBGjpe6uyX7SFihakQNR8zSL6Aj4ZeNTFZrInTdLUOND6/JZfj0
 WTiI+Uy6/0Ez/RD12EB7Peg3RFIPva2pzB0luTntbnzAd79gOVFBnXijNsB1Z7ZekjS2 SQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39gqbsj5yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 08:13:31 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15UBvNt1009345;
        Wed, 30 Jun 2021 12:13:29 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 39g91yrb4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 12:13:29 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15UCDQrX19005810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Jun 2021 12:13:27 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32B2D52094;
        Wed, 30 Jun 2021 12:13:26 +0000 (GMT)
Received: from smtpclient.apple (unknown [9.85.88.152])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8B4A55205A;
        Wed, 30 Jun 2021 12:13:25 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH] crypto: DRBG - select SHA512
From:   Sachin Sant <sachinp@linux.vnet.ibm.com>
In-Reply-To: <304ee0376383d9ceecddbfd216c035215bbff861.camel@chronox.de>
Date:   Wed, 30 Jun 2021 17:43:24 +0530
Cc:     linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Content-Transfer-Encoding: 7bit
Message-Id: <1F974727-E27C-43FA-8CCB-36091B27EDF1@linux.vnet.ibm.com>
References: <73D2DF91-CC7A-46CD-8D48-63FFB1857D24@linux.vnet.ibm.com>
 <304ee0376383d9ceecddbfd216c035215bbff861.camel@chronox.de>
To:     Stephan Mueller <smueller@chronox.de>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uSz3If72F5DqPxUWRTv-MwMDTF5Atdew
X-Proofpoint-ORIG-GUID: uSz3If72F5DqPxUWRTv-MwMDTF5Atdew
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-30_05:2021-06-29,2021-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0 mlxscore=0
 impostorscore=0 spamscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106300076
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> On 30-Jun-2021, at 4:02 PM, Stephan Mueller <smueller@chronox.de> wrote:
> 
> With the swtich to use HMAC(SHA-512) as the default DRBG type, the
> configuration must now also select SHA-512.
> 
> Fixes: 9b7b94683a9b "crypto: DRBG - switch to HMAC SHA512 DRBG as default
> DRBG"
> Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.com>
> ---

Thanks Stephan. This patch fixes the reported problem.

Tested-by: Sachin Sant <sachinp@linux.vnet.ibm.com>

-Sachin

