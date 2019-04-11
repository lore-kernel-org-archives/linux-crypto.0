Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D83C10F13
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 17:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AB502084D
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 17:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfDKRlA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 13:41:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51976 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726633AbfDKRlA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 13:41:00 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3BHeICb123038
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 13:40:59 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2rt7ymfy1f-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 13:40:58 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <nayna@linux.vnet.ibm.com>;
        Thu, 11 Apr 2019 18:40:57 +0100
Received: from b03cxnp08027.gho.boulder.ibm.com (9.17.130.19)
        by e34.co.us.ibm.com (192.168.1.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 11 Apr 2019 18:40:53 +0100
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3BHeqf658458334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Apr 2019 17:40:52 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA3E2136061;
        Thu, 11 Apr 2019 17:40:51 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03B7E136063;
        Thu, 11 Apr 2019 17:40:49 +0000 (GMT)
Received: from swastik.ibm.com (unknown [9.80.221.85])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 11 Apr 2019 17:40:49 +0000 (GMT)
Subject: Re: [PATCH] crypto: vmx - fix copy-paste error in CTR mode
To:     Daniel Axtens <dja@axtens.net>, Eric Biggers <ebiggers@kernel.org>
Cc:     omosnacek@gmail.com, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        marcelo.cerri@canonical.com, Stephan Mueller <smueller@chronox.de>,
        leo.barbosa@canonical.com, linuxppc-dev@lists.ozlabs.org,
        nayna@linux.ibm.com, pfsmorigo@gmail.com, leitao@debian.org,
        George Wilson <gcwilson@linux.ibm.com>
References: <20190315020901.16509-1-dja@axtens.net>
 <20190315022414.GA1671@sol.localdomain>
 <875zsku5mk.fsf@dja-thinkpad.axtens.net>
 <20190315043433.GC1671@sol.localdomain>
 <8736nou2x5.fsf@dja-thinkpad.axtens.net>
 <20190410070234.GA12406@sol.localdomain>
 <87imvkwqdh.fsf@dja-thinkpad.axtens.net>
From:   Nayna <nayna@linux.vnet.ibm.com>
Date:   Thu, 11 Apr 2019 13:40:49 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <87imvkwqdh.fsf@dja-thinkpad.axtens.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19041117-0016-0000-0000-0000099F7DBD
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010910; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000284; SDB=6.01187630; UDB=6.00622104; IPR=6.00968393;
 MB=3.00026396; MTD=3.00000008; XFM=3.00000015; UTC=2019-04-11 17:40:56
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19041117-0017-0000-0000-000042C712BD
Message-Id: <2c8b042f-c7df-cb8b-3fcd-15d6bb274d08@linux.vnet.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-11_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904110118
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 04/11/2019 10:47 AM, Daniel Axtens wrote:
> Eric Biggers <ebiggers@kernel.org> writes:
>
>> Are you still planning to fix the remaining bug?  I booted a ppc64le VM, and I
>> see the same test failure (I think) you were referring to:
>>
>> alg: skcipher: p8_aes_ctr encryption test failed (wrong result) on test vector 3, cfg="uneven misaligned splits, may sleep"
>>
> Yes, that's the one I saw. I don't have time to follow it up at the
> moment, but Nayna is aware of it.
>

Yes Eric, we identified this as a separate issue of misalignment and 
plan to post a separate patch to address it.

Thanks & Regards,
       - Nayna

