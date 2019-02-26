Return-Path: <SRS0=wbmp=RB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87F03C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Feb 2019 12:08:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65F7E21852
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Feb 2019 12:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfBZMIE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Feb 2019 07:08:04 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59724 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726719AbfBZMIE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Feb 2019 07:08:04 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1QC11QX026285
        for <linux-crypto@vger.kernel.org>; Tue, 26 Feb 2019 07:08:03 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2qw2a8aqgx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 26 Feb 2019 07:08:02 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <zohar@linux.ibm.com>;
        Tue, 26 Feb 2019 12:08:00 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 26 Feb 2019 12:07:56 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x1QC7tQC56754208
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 26 Feb 2019 12:07:55 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A805DAE055;
        Tue, 26 Feb 2019 12:07:55 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 846BAAE053;
        Tue, 26 Feb 2019 12:07:54 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.108.64])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 Feb 2019 12:07:54 +0000 (GMT)
Subject: Re: [PATCH v5 10/10] integrity: support EC-RDSA signatures for
 asymmetric_verify
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Vitaly Chikunov <vt@altlinux.org>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Date:   Tue, 26 Feb 2019 07:07:43 -0500
In-Reply-To: <20190226042546.czh6me47f7xldgk2@altlinux.org>
References: <20190224060828.2527-1-vt@altlinux.org>
         <20190224060828.2527-11-vt@altlinux.org>
         <874l8rr2dq.fsf@morokweng.localdomain>
         <20190226042546.czh6me47f7xldgk2@altlinux.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19022612-0016-0000-0000-0000025B106D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19022612-0017-0000-0000-000032B5727C
Message-Id: <1551182863.27819.62.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-02-26_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1902260090
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> > > diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
> > > index d775e03fbbcc..c4a3313e0210 100644
> > > --- a/security/integrity/digsig_asymmetric.c
> > > +++ b/security/integrity/digsig_asymmetric.c
> > > @@ -104,9 +104,14 @@ int asymmetric_verify(struct key *keyring, const char *sig,
> > >
> > >  	memset(&pks, 0, sizeof(pks));
> > >
> > > -	pks.pkey_algo = "rsa";
> > >  	pks.hash_algo = hash_algo_name[hdr->hash_algo];
> > > -	pks.encoding = "pkcs1";
> > > +	if (!strncmp(pks.hash_algo, "streebog", 8)) {
> > 
> > Is it possible to test hdr->hash_algo instead of pkcs.hash_algo? IMHO if
> > an integer value is available it's preferable to check it rather than
> > doing a string comparison.
> 
> Yes. But we have long tradition of comparing by the name too:
> 
>   --linux$ git grep str.*cmp.*'"sha[12]'
>   drivers/crypto/mxs-dcp.c:       if (strcmp(halg->base.cra_name, "sha1") == 0)
>   drivers/crypto/talitos.c:                   (!strcmp(alg->cra_name, "sha224") ||
>   net/sctp/sysctl.c:              if (!strncmp(tmp, "sha1", 4)) {
>   scripts/sign-file.c:    if (strcmp(hash_algo, "sha1") != 0) {

sign_file.c is a userspace program used for signing kernel modules.
 This example is not applicable.

>   security/integrity/ima/ima_main.c:              if (strncmp(str, "sha1", 4) == 0)

In the ima_main.c example, it is used in an __init function to set up
crypto defaults.  The code also predates the enumerations defined in
crypto/hash_info.c.

Mimi

