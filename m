Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D4E3C433DB
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Mar 2021 19:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0F8D61984
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Mar 2021 19:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbhCVT0w (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Mar 2021 15:26:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29004 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231676AbhCVT0d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Mar 2021 15:26:33 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12MJ3bjF061866;
        Mon, 22 Mar 2021 15:26:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=ZXzOB4AtbWH6ok2w4tbefXFbVHdFar+z3GCtgxuZ1R4=;
 b=tGgzK/ibORyg3Hbr6sj6NsfK3REKIDPR/W6JmfJOj4H/FCMO7W8HqMVdBGxZClQX/spz
 5YcZd3NQm34+AnB3GheG/fe/oJ7RjMKarabESwym/v5bKh1wWRUT875+a2ttRxa1TiU6
 Rl8bmve3qCgoLguXagsIAHMmhJNYcRLiGsb6UNeWNXUBRHHzUjEvjKEEIk/oC8GqVmOh
 Dh/NO6ztWW++3HGsFIUpKKhsehs/4tsbOohjEGqYDu2ydnX3msyfCk8UNwpcVt+u4ExM
 w7uUw1xhgxaUCTmgWGoT+Lj7ZQD1TwbIS4khPYaclR0ss+5eAM+f6jkrY2R44qwM2yeS mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37dxc9t8nv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 15:26:18 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12MJ3vSd062996;
        Mon, 22 Mar 2021 15:26:17 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37dxc9t8nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 15:26:17 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12MJNRlo019308;
        Mon, 22 Mar 2021 19:26:16 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 37df68a85p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 19:26:15 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12MJQDw049021402
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 19:26:13 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 076FB42041;
        Mon, 22 Mar 2021 19:26:13 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90F4942042;
        Mon, 22 Mar 2021 19:26:12 +0000 (GMT)
Received: from osiris (unknown [9.171.41.112])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 22 Mar 2021 19:26:12 +0000 (GMT)
Date:   Mon, 22 Mar 2021 20:26:11 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH] s390/crc32-vx: Couple of typo fixes
Message-ID: <YFjvU0ocfwa9WLA7@osiris>
References: <20210322130533.3805976-1-unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322130533.3805976-1-unixbhaskar@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-22_11:2021-03-22,2021-03-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=816
 lowpriorityscore=0 phishscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103220138
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 22, 2021 at 06:35:33PM +0530, Bhaskar Chowdhury wrote:
> 
> s/defintions/definitions/
> s/intermedate/intermediate/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  arch/s390/crypto/crc32be-vx.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied, thanks.
