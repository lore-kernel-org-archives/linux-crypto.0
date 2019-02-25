Return-Path: <SRS0=IhKu=RA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC801C43381
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Feb 2019 21:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2DB72083D
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Feb 2019 21:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730238AbfBYVVD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Feb 2019 16:21:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56232 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730544AbfBYVVD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Feb 2019 16:21:03 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1PL4mFX147373
        for <linux-crypto@vger.kernel.org>; Mon, 25 Feb 2019 16:21:02 -0500
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2qvq4aaxhd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Mon, 25 Feb 2019 16:21:01 -0500
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <bauerman@linux.ibm.com>;
        Mon, 25 Feb 2019 21:21:00 -0000
Received: from b01cxnp22034.gho.pok.ibm.com (9.57.198.24)
        by e14.ny.us.ibm.com (146.89.104.201) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 25 Feb 2019 21:20:57 -0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x1PLKu5D24838388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Feb 2019 21:20:56 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51C05AC05E;
        Mon, 25 Feb 2019 21:20:56 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A51CAC059;
        Mon, 25 Feb 2019 21:20:54 +0000 (GMT)
Received: from morokweng.localdomain (unknown [9.85.212.38])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTPS;
        Mon, 25 Feb 2019 21:20:53 +0000 (GMT)
References: <20190224060828.2527-1-vt@altlinux.org> <20190224060828.2527-11-vt@altlinux.org>
User-agent: mu4e 1.0; emacs 26.1
From:   Thiago Jung Bauermann <bauerman@linux.ibm.com>
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: Re: [PATCH v5 10/10] integrity: support EC-RDSA signatures for asymmetric_verify
In-reply-to: <20190224060828.2527-11-vt@altlinux.org>
Date:   Mon, 25 Feb 2019 18:20:49 -0300
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
x-cbid: 19022521-0052-0000-0000-00000390BB6C
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010663; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000281; SDB=6.01166320; UDB=6.00609219; IPR=6.00946924;
 MB=3.00025738; MTD=3.00000008; XFM=3.00000015; UTC=2019-02-25 21:20:59
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19022521-0053-0000-0000-00005FF81824
Message-Id: <874l8rr2dq.fsf@morokweng.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-02-25_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1902250151
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Hello Vitaly,

Vitaly Chikunov <vt@altlinux.org> writes:

> Allow to use EC-RDSA signatures for IMA by determining signature type by
> the hash algorithm name. This works good for EC-RDSA since Streebog and
> EC-RDSA should always be used together.
>
> Cc: Mimi Zohar <zohar@linux.ibm.com>
> Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
> Cc: linux-integrity@vger.kernel.org
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> ---
>  security/integrity/digsig_asymmetric.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
> index d775e03fbbcc..c4a3313e0210 100644
> --- a/security/integrity/digsig_asymmetric.c
> +++ b/security/integrity/digsig_asymmetric.c
> @@ -104,9 +104,14 @@ int asymmetric_verify(struct key *keyring, const char *sig,
>
>  	memset(&pks, 0, sizeof(pks));
>
> -	pks.pkey_algo = "rsa";
>  	pks.hash_algo = hash_algo_name[hdr->hash_algo];
> -	pks.encoding = "pkcs1";
> +	if (!strncmp(pks.hash_algo, "streebog", 8)) {

Is it possible to test hdr->hash_algo instead of pkcs.hash_algo? IMHO if
an integer value is available it's preferable to check it rather than
doing a string comparison.

Also, it would be good to have a comment here mentioning that Streebog
and EC-RDSA should always be used together

> +		pks.pkey_algo = "ecrdsa";
> +		pks.encoding = "raw";
> +	} else {
> +		pks.pkey_algo = "rsa";
> +		pks.encoding = "pkcs1";
> +	}
>  	pks.digest = (u8 *)data;
>  	pks.digest_size = datalen;
>  	pks.s = hdr->sig;

--
Thiago Jung Bauermann
IBM Linux Technology Center

