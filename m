Return-Path: <SRS0=xmdE=25=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E493CC33C9B
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 04:25:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C34922070E
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 04:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgAHEZm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Jan 2020 23:25:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60090 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727154AbgAHEZm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Jan 2020 23:25:42 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0084MIPq082298
        for <linux-crypto@vger.kernel.org>; Tue, 7 Jan 2020 23:25:40 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xd0wjkptq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jan 2020 23:25:40 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <zohar@linux.ibm.com>;
        Wed, 8 Jan 2020 04:25:38 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 Jan 2020 04:25:34 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0084PX7830671218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jan 2020 04:25:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 999AA11C04C;
        Wed,  8 Jan 2020 04:25:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81AB011C054;
        Wed,  8 Jan 2020 04:25:32 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.234.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jan 2020 04:25:32 +0000 (GMT)
Subject: Re: [PATCH] IMA: Defined CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS to
 enable IMA hook to measure keys
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        James.Bottomley@HansenPartnership.com, arnd@arndb.de,
        linux-integrity@vger.kernel.org
Cc:     dhowells@redhat.com, sashal@kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org
Date:   Tue, 07 Jan 2020 23:25:32 -0500
In-Reply-To: <20200108003647.2472-1-nramas@linux.microsoft.com>
References: <20200108003647.2472-1-nramas@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20010804-0020-0000-0000-0000039EB268
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20010804-0021-0000-0000-000021F61077
Message-Id: <1578457532.5222.127.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-07_08:2020-01-07,2020-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 suspectscore=0 spamscore=0 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1011 phishscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001080037
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The subject line is too long.  How about "IMA: fix measuring
asymmetric keys Kconfig"?

On Tue, 2020-01-07 at 16:36 -0800, Lakshmi Ramasubramanian wrote:
> CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is a tristate and not a bool.
> If this config is set to "=m", ima_asymmetric_keys.c is built
> as a kernel module when it is actually not.

Simplify the wording by removing the unnecessary "not a bool" and
"when it is actually not".

> 
> Defined a new config CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS that is
> defined when CONFIG_IMA and CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE
> are defined.

How about using James wording - "intermediate boolean config
variable"?

> Asymmetric key structure is defined only when
> CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is defined. Since the IMA hook
> measures asymmetric keys, the IMA hook is defined in
> ima_asymmetric_keys.c which is built only if
> CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS is defined.
> 
> Signed-off-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>

Please include a "Suggested-by:" tag for James.

thanks,

Mimi

