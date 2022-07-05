Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A782C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jul 2022 19:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbiGET2i (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jul 2022 15:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbiGET2h (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jul 2022 15:28:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2FB12764;
        Tue,  5 Jul 2022 12:28:36 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 265IiAjw016083;
        Tue, 5 Jul 2022 19:28:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gVviuTdG2skSFcwi7x4b9X1/jBb6c9Z6Uai43/YmWr0=;
 b=LIFQm9jPtpEilL4mxtC9lklAOJuC5whBEe2bKBFgwxbO+CH9eetm52GGDjHQC5f3cnR9
 qdw1V1UrKmgujPrEtW3bngwhVe6mWPcJspB9bkXZFwggqdOhXZLMSn2AIUI/qTn/kYzp
 puy9Sf/FvckC8IxJGgPxqZvBGf8GYS1rmOLZGDU3jdJsZVr3c3jjh4b41dobNQjrhicT
 bx1QqF+vZv18fsCkQrq5mmj24B+uhRXXqzG0wGss7ECEF74vf8B+PcJyRQ6D5HPD9kiS
 WgHJ2CkmMwQOcbBA8y+AxT+dYH1SCuizAR/T4Yicla9/b9eCnCUu/ZDlR7/+XAvTF0+x Og== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4rpa4kww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 19:28:36 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 265JLeiq031957;
        Tue, 5 Jul 2022 19:28:33 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3h2dn8vduf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 19:28:33 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 265JSUGZ22610354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Jul 2022 19:28:30 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6044A42041;
        Tue,  5 Jul 2022 19:28:30 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E61694203F;
        Tue,  5 Jul 2022 19:28:29 +0000 (GMT)
Received: from [9.171.76.195] (unknown [9.171.76.195])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Jul 2022 19:28:29 +0000 (GMT)
Message-ID: <94129ae6-0055-4cc9-dee3-0558cf52b4cb@linux.ibm.com>
Date:   Tue, 5 Jul 2022 21:28:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1 1/1] s390/arch_random: Buffer true random data
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Juergen Christ <jchrist@linux.ibm.com>,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220705112712.4433-1-dengler@linux.ibm.com>
 <20220705112712.4433-2-dengler@linux.ibm.com> <YsQ6OOrOWPhdynoM@zx2c4.com>
 <9a0561c0-68f7-b630-4440-3ca32bf28dc2@linux.ibm.com>
 <YsRUowTs9n98p9EL@zx2c4.com>
 <aafbb400-d0cb-99de-8b10-3c39c7b9bae5@linux.ibm.com>
 <YsRoXObdpCNbtpHS@zx2c4.com>
 <30e681b2-a411-cdb1-4b46-243db25abeef@linux.ibm.com>
 <YsSAn2qXqlFkS5sH@zx2c4.com>
From:   Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <YsSAn2qXqlFkS5sH@zx2c4.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pFCU0pPFcIaH_bPkXrK51wFDHKSwB4t8
X-Proofpoint-ORIG-GUID: pFCU0pPFcIaH_bPkXrK51wFDHKSwB4t8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-05_16,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=847
 lowpriorityscore=0 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 clxscore=1015 adultscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207050083
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Jason,

On 05/07/2022 20:19, Jason A. Donenfeld wrote:
> Hey Holger,
> 
> On Tue, Jul 05, 2022 at 07:47:37PM +0200, Holger Dengler wrote:
>> A trng call runs for minimal ~20-190us for 32 bytes. 20us on newer
>> machine generations, 190us on older ones. These are not 100% exact
>> measurements, but the dimension should be correct.
> 
> Holy smokes. Yea, okay, I see what you're saying. So indeed it sounds
> like the `!in_hardirq()` addition would be a good idea. Let's do that.

:) I'll come up with this in v2.

For the long run, a re-worked API arch_get_random_seed_something() with an arch-dependant variable block length is worth to think about. It seems, that x86 and ppc delivers a long per trng instruction call, while on s390 it would make more sense to fill the block.rdseed in a single call.

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com
