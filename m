Return-Path: <SRS0=0S/Q=4G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97BD4C34031
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 01:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79D7C214D8
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 01:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgBRBd3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Feb 2020 20:33:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35732 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726107AbgBRBd2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Feb 2020 20:33:28 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01I1V0lF100810
        for <linux-crypto@vger.kernel.org>; Mon, 17 Feb 2020 20:33:28 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y6d6170b2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Mon, 17 Feb 2020 20:33:27 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <zohar@linux.ibm.com>;
        Tue, 18 Feb 2020 01:33:25 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 18 Feb 2020 01:33:22 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01I1XLFl45023244
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Feb 2020 01:33:21 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DF3F52051;
        Tue, 18 Feb 2020 01:33:21 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.165.167])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 080315204F;
        Tue, 18 Feb 2020 01:33:18 +0000 (GMT)
Subject: Re: [PATCH v2 1/2] crypto: fix mismatched hash algorithm name
 sm3-256 to sm3
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        jarkko.sakkinen@linux.intel.com, ebiggers@kernel.org,
        dmitry.kasatkin@gmail.com, jmorris@namei.org, serge@hallyn.com
Cc:     linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 17 Feb 2020 20:33:18 -0500
In-Reply-To: <20200217093649.97938-2-tianjia.zhang@linux.alibaba.com>
References: <20200217093649.97938-1-tianjia.zhang@linux.alibaba.com>
         <20200217093649.97938-2-tianjia.zhang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20021801-4275-0000-0000-000003A2F334
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021801-4276-0000-0000-000038B6F8A5
Message-Id: <1581989598.8515.233.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_14:2020-02-17,2020-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 adultscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 phishscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002180009
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 2020-02-17 at 17:36 +0800, Tianjia Zhang wrote:
> The name sm3-256 is defined in hash_algo_name in hash_info, but the
> algorithm name implemented in sm3_generic.c is sm3, which will cause
> the sm3-256 algorithm to be not found in some application scenarios of
> the hash algorithm, and an ENOENT error will occur. For example,
> IMA, keys, and other subsystems that reference hash_algo_name all use
> the hash algorithm of sm3.
> 
> According to https://tools.ietf.org/id/draft-oscca-cfrg-sm3-01.html,
> SM3 always produces a 256-bit hash value and there are no plans for
> other length development, so there is no ambiguity in the name of sm3.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

The previous version of this patch set is queued in the next-
integrity-testing branch.  That version of this patch didn't
change TPM_ALG_SM3_256.  Unless the TPM standard was modified, the TPM
spec refers to it as TPM_ALG_SM3_256.  Has that changed?

Mimi

