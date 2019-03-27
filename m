Return-Path: <SRS0=PdDN=R6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 678F6C10F00
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Mar 2019 20:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D28921734
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Mar 2019 20:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbfC0UV3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Mar 2019 16:21:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58878 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727328AbfC0UVR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Mar 2019 16:21:17 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2RK93Ob011357
        for <linux-crypto@vger.kernel.org>; Wed, 27 Mar 2019 16:21:15 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2rgd49qscb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 27 Mar 2019 16:21:15 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <zohar@linux.ibm.com>;
        Wed, 27 Mar 2019 20:21:13 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 27 Mar 2019 20:21:10 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x2RKL9R853084220
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Mar 2019 20:21:09 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36BED52050;
        Wed, 27 Mar 2019 20:21:09 +0000 (GMT)
Received: from dhcp-9-31-103-153.watson.ibm.com (unknown [9.31.103.153])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 55EA65204E;
        Wed, 27 Mar 2019 20:21:08 +0000 (GMT)
Subject: Re: [PATCH v8 10/10] integrity: support EC-RDSA signatures for
 asymmetric_verify
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 27 Mar 2019 16:21:07 -0400
In-Reply-To: <20190327201441.ikw76qzpgzm6t35b@altlinux.org>
References: <20190326125842.24110-1-vt@altlinux.org>
         <20190326125842.24110-11-vt@altlinux.org>
         <1553710220.4608.9.camel@linux.ibm.com>
         <20190327201441.ikw76qzpgzm6t35b@altlinux.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19032720-0008-0000-0000-000002D24DBF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19032720-0009-0000-0000-0000223E803D
Message-Id: <1553718067.4608.43.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-03-27_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1903270140
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> > diff --git a/security/integrity/digsig_asymmetric.c
b/security/integrity/digsig_asymmetric.c
> > > index d775e03fbbcc..99080871eb9f 100644
> > > --- a/security/integrity/digsig_asymmetric.c
> > > +++ b/security/integrity/digsig_asymmetric.c
> > > @@ -104,9 +104,16 @@ int asymmetric_verify(struct key *keyring, const char *sig,
> > >  
> > >  	memset(&pks, 0, sizeof(pks));
> > >  
> > > -	pks.pkey_algo = "rsa";
> > >  	pks.hash_algo = hash_algo_name[hdr->hash_algo];
> > > -	pks.encoding = "pkcs1";
> > > +	if (hdr->hash_algo == HASH_ALGO_STREEBOG_256 ||
> > > +	    hdr->hash_algo == HASH_ALGO_STREEBOG_512) {
> > > +		/* EC-RDSA and Streebog should go together. */
> > > +		pks.pkey_algo = "ecrdsa";
> > > +		pks.encoding = "raw";
> > 
> > IMA signatures are stored as xattrs, making them persistent.  Support
> > for streebog was upstreamed in linux-5.0.  This change would break
> > existing systems using streebog.  As long as this is not yet a concern
> 
> In what sense it would break systems?

For example, if executable files are currently labeled with
rsa/streebog signatures, then enforcing file data integrity I assume
would break if the kernel uses ecrdsa/streebog.

Mimi

> 
> Unless kernel crashes or signature is recognized as valid, I think, it should
> not be called a break.
> 
> > Reviewed-by:  Mimi Zohar <zohar@linux.ibm.com>
> 
> Thanks!
> 
> > 
> > > +	} else {
> > > +		pks.pkey_algo = "rsa";
> > > +		pks.encoding = "pkcs1";
> > > +	}
> > >  	pks.digest = (u8 *)data;
> > >  	pks.digest_size = datalen;
> > >  	pks.s = hdr->sig;
> 

