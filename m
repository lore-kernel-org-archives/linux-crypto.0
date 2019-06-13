Return-Path: <SRS0=nMY8=UM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D4A6C31E45
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 16:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D2A320449
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 16:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730929AbfFMQef (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Jun 2019 12:34:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41158 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730768AbfFMHv0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jun 2019 03:51:26 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5D7lqC2126877
        for <linux-crypto@vger.kernel.org>; Thu, 13 Jun 2019 03:51:24 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t3jcfg8jg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Thu, 13 Jun 2019 03:51:24 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
        Thu, 13 Jun 2019 08:51:22 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 13 Jun 2019 08:51:20 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5D7pJMr42270804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jun 2019 07:51:19 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A80BA4053;
        Thu, 13 Jun 2019 07:51:19 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6F43A4040;
        Thu, 13 Jun 2019 07:51:18 +0000 (GMT)
Received: from osiris (unknown [9.152.212.21])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 13 Jun 2019 07:51:18 +0000 (GMT)
Date:   Thu, 13 Jun 2019 09:51:17 +0200
From:   Heiko Carstens <heiko.carstens@de.ibm.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v3 0/4] s390/crypto: Use -ENODEV instead of -EOPNOTSUPP
References: <20190612133306.10231-1-david@redhat.com>
 <20190612150850.GA4038@osiris>
 <20190613031355.7vya4vwhr3eia5g4@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613031355.7vya4vwhr3eia5g4@gondor.apana.org.au>
X-TM-AS-GCONF: 00
x-cbid: 19061307-0012-0000-0000-00000328BBCE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061307-0013-0000-0000-00002161C685
Message-Id: <20190613075117.GA4292@osiris>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=871 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906130062
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 13, 2019 at 11:13:55AM +0800, Herbert Xu wrote:
> On Wed, Jun 12, 2019 at 05:08:50PM +0200, Heiko Carstens wrote:
> > On Wed, Jun 12, 2019 at 03:33:02PM +0200, David Hildenbrand wrote:
> > > s390x crypto is one of the rare modules that returns -EOPNOTSUPP instead of
> > > -ENODEV in case HW support is not available.
> > > 
> > > Convert to -ENODEV, so e.g., systemd's systemd-modules-load.service
> > > ignores this error properly.
> > > 
> > > v2 -> v3:
> > > - "s390/pkey: Use -ENODEV instead of -EOPNOTSUPP"
> > > -- Also convert pkey_clr2protkey() as requested by Harald
> > > - Add r-b's (thanks!)
> > > 
> > > v1 -> v2:
> > > - Include
> > > -- "s390/crypto: ghash: Use -ENODEV instead of -EOPNOTSUPP"
> > > -- "s390/crypto: prng: Use -ENODEV instead of -EOPNOTSUPP"
> > > -- "s390/crypto: sha: Use -ENODEV instead of -EOPNOTSUPP"
> > > 
> > > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> > > Cc: Vasily Gorbik <gor@linux.ibm.com>
> > > Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> > > Cc: Harald Freudenberger <freude@linux.ibm.com>
> > > Cc: Cornelia Huck <cohuck@redhat.com>
> > > 
> > > David Hildenbrand (4):
> > >   s390/pkey: Use -ENODEV instead of -EOPNOTSUPP
> > >   s390/crypto: ghash: Use -ENODEV instead of -EOPNOTSUPP
> > >   s390/crypto: prng: Use -ENODEV instead of -EOPNOTSUPP
> > >   s390/crypto: sha: Use -ENODEV instead of -EOPNOTSUPP
> > 
> > Should I pick these up so they can go upstream via the s390 tree?
> 
> Sure Heiko.  Thanks!

Ok, all applied. Thanks!

