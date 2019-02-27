Return-Path: <SRS0=wS1t=RC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9F7C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Feb 2019 23:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F9C72133D
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Feb 2019 23:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730310AbfB0X3A (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Feb 2019 18:29:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729986AbfB0X3A (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Feb 2019 18:29:00 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1RNJZXK088204
        for <linux-crypto@vger.kernel.org>; Wed, 27 Feb 2019 18:28:55 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2qx1qhe4ah-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 27 Feb 2019 18:28:55 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <zohar@linux.ibm.com>;
        Wed, 27 Feb 2019 23:28:53 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 27 Feb 2019 23:28:50 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x1RNSnQ058195990
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 Feb 2019 23:28:49 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5008D4278B;
        Wed, 27 Feb 2019 23:28:49 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EE3842790;
        Wed, 27 Feb 2019 23:28:48 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.106.105])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 27 Feb 2019 23:28:48 +0000 (GMT)
Subject: Re: [PATCH v5 04/10] crypto: akcipher - new verify API for public
 key algorithms
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Vitaly Chikunov <vt@altlinux.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 27 Feb 2019 18:28:37 -0500
In-Reply-To: <20190224060828.2527-5-vt@altlinux.org>
References: <20190224060828.2527-1-vt@altlinux.org>
         <20190224060828.2527-5-vt@altlinux.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19022723-0020-0000-0000-0000031C18FD
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19022723-0021-0000-0000-0000216D87D5
Message-Id: <1551310117.10911.108.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-02-27_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1902270151
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Vitaly,

On Sun, 2019-02-24 at 09:08 +0300, Vitaly Chikunov wrote:
> Previous akcipher .verify() just `decrypts' (using RSA encrypt which is
> using public key) signature to uncover message hash, which was then
> compared in upper level public_key_verify_signature() with the expected
> hash value, which itself was never passed into verify().
> 
> This approach was incompatible with EC-DSA family of algorithms,
> because, to verify a signature EC-DSA algorithm also needs a hash value
> as input; then it's used (together with a signature divided into halves
> `r||s') to produce a witness value, which is then compared with `r' to
> determine if the signature is correct. Thus, for EC-DSA, nor
> requirements of .verify() itself, nor its output expectations in
> public_key_verify_signature() wasn't sufficient.
> 
> Make improved .verify() call which gets hash value as input and produce
> complete signature check without any output besides status.
> 
> Now for the top level verification only crypto_akcipher_verify() needs
> to be called.

All but this patch apply.  Which branch is this patch based against?

Mimi

