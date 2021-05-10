Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E08C433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 20:52:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31926610C9
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 20:52:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbhEJUxb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 16:53:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58390 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231672AbhEJUxb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 16:53:31 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14AKYTFl165991;
        Mon, 10 May 2021 16:52:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Hvy6oFQLwlo09J8gv7obuD2YrdII8J0sp5Rv1jUKYmA=;
 b=a5tCfmq/0LFY+6bpJUsnqYZxStQ27qIY49QchHh4GbTkqYT7/S9d9UJ3jM7nPVK4t/S3
 nkjaDeG1afh7nKuHvymyvjnsz1nZj6WeSES7CVD33Ch+Tr3GsW6MIW+OPV2CAZSNrWsP
 deRc5udK4Ubm4iqiidTKxwJVaS+XXe0Uqy5cAtFXdqH40BntFljPjn5E3rYyxY12PhkT
 +FYqq4omXAK0vaNtLi+HyB62xRzCVlx5wLKppD/0n7IY9aTO1OQ9cUlnabmX/RFehDok
 2fGCKyaourR1NKDszlzKNEGXBFL0LsBZVt+vtDysUDoxlRZfDc9xOj17/Y4JvKjAnMYA wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38fatrtu71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 16:52:16 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14AKYVx0166174;
        Mon, 10 May 2021 16:52:15 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38fatrtu6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 16:52:15 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14AKq2OI027900;
        Mon, 10 May 2021 20:52:15 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03wdc.us.ibm.com with ESMTP id 38dj98s2uk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 20:52:14 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14AKqE6Q15532356
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 20:52:14 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D3DDC605A;
        Mon, 10 May 2021 20:52:14 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96FB1C6055;
        Mon, 10 May 2021 20:52:12 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.194.217])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 20:52:12 +0000 (GMT)
Message-ID: <7c15168a1f29216f5c5bda59028d580c2daee0a4.camel@linux.ibm.com>
Subject: Re: [V3 PATCH 12/16] powerpc/pseries/vas: sysfs interface to export
 capabilities
From:   Haren Myneni <haren@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
Date:   Mon, 10 May 2021 13:52:10 -0700
In-Reply-To: <1620628126.jezp40t2h6.astroid@bobo.none>
References: <a910e5bd3f3398b4bd430b25a856500735b993c3.camel@linux.ibm.com>
         <60176ad795219afbeaf51ad596af4bae710617b7.camel@linux.ibm.com>
         <1620628126.jezp40t2h6.astroid@bobo.none>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UESjA3VvtDSzrjAMrYV93DufohqEC5Gd
X-Proofpoint-ORIG-GUID: yTjW6jCPHQGKGBpPifeZRNMONhC2de5P
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_12:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 spamscore=0 suspectscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105100140
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 2021-05-10 at 16:34 +1000, Nicholas Piggin wrote:
> Excerpts from Haren Myneni's message of April 18, 2021 7:10 am:
> > pHyp provides GZIP default and GZIP QoS capabilities which gives
> > the total number of credits are available in LPAR. This patch
> > creates sysfs entries and exports LPAR credits, the currently used
> > and the available credits for each feature.
> > 
> > /sys/kernel/vas/VasCaps/VDefGzip: (default GZIP capabilities)
> > 	avail_lpar_creds /* Available credits to use */
> > 	target_lpar_creds /* Total credits available which can be
> > 			 /* changed with DLPAR operation */
> > 	used_lpar_creds  /* Used credits */
> 
> /sys/kernel/ is not an appropriate directory to put it in. Also
> camel 
> case is not thought very highly of these days.

These capabilities are VAS specific ones (powerpc kernel), not for the
indicidual coprocessor. Not sure where to add in sysfs. 

> 
> And s/capabs/caps/g applies here (and all other patches).

Thanks, will change. 
> 
> Thanks,
> Nick

