Return-Path: <SRS0=PdDN=R6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 145D6C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Mar 2019 19:36:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D11C920700
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Mar 2019 19:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfC0TgQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Mar 2019 15:36:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36450 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728203AbfC0TgP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Mar 2019 15:36:15 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2RJZDJf138002
        for <linux-crypto@vger.kernel.org>; Wed, 27 Mar 2019 15:36:14 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2rgc3egjt7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 27 Mar 2019 15:36:13 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <zohar@linux.ibm.com>;
        Wed, 27 Mar 2019 19:36:10 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 27 Mar 2019 19:36:06 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x2RJa5ND34537692
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Mar 2019 19:36:05 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79DECA4062;
        Wed, 27 Mar 2019 19:36:05 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D8ADA405C;
        Wed, 27 Mar 2019 19:36:04 +0000 (GMT)
Received: from dhcp-9-31-103-153.watson.ibm.com (unknown [9.31.103.153])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 27 Mar 2019 19:36:04 +0000 (GMT)
Subject: Re: [PATCH] X.509: Add messages for obsolete OIDs
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>
Date:   Wed, 27 Mar 2019 15:36:04 -0400
In-Reply-To: <20190322062738.19852-1-jlee@suse.com>
References: <20190322062738.19852-1-jlee@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19032719-0008-0000-0000-000002D24959
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19032719-0009-0000-0000-0000223E7BBC
Message-Id: <1553715364.4608.36.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-03-27_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1903270138
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 2019-03-22 at 14:27 +0800, Lee, Chun-Yi wrote:
> We found that the db in Acer machine has self signed certificates
> (CN=DisablePW or CN=ABO) that they used obsolete OID 1.3.14.3.2.29
> sha1WithRSASignature and 2.5.29.1 subjectKeyIdentifier. Kernel
> emits -65 error code when loading those certificates to platform
> keyring:
> 
> [    1.484388] integrity: Loading X.509 certificate: UEFI:MokListRT
> [    1.485557] integrity: Problem loading X.509 certificate -65
> [    1.486100] Error adding keys to platform keyring UEFI:MokListRT
> 
> Because the -65 error code is not enough for appeasing user when
> loading a outdated certificate. This patch add messages against
> 1.3.14.3.2.29 and 2.5.29.1 OIDs.
> 
> Link: https://bugzilla.opensuse.org/show_bug.cgi?id=1129471
> Cc: David Howells <dhowells@redhat.com> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>

Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>

> ---
>  crypto/asymmetric_keys/x509_cert_parser.c | 7 +++++++
>  include/linux/oid_registry.h              | 2 ++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
> index 991f4d735a4e..bbd22d5c5b5d 100644
> --- a/crypto/asymmetric_keys/x509_cert_parser.c
> +++ b/crypto/asymmetric_keys/x509_cert_parser.c
> @@ -192,6 +192,8 @@ int x509_note_pkey_algo(void *context, size_t hdrlen,
>  	pr_debug("PubKey Algo: %u\n", ctx->last_oid);
> 
>  	switch (ctx->last_oid) {
> +	case OID_sha1WithRSASignature:
> +		pr_info("1.3.14.3.2.29 sha1WithRSASignature is obsolete.\n");
>  	case OID_md2WithRSAEncryption:
>  	case OID_md3WithRSAEncryption:
>  	default:
> @@ -464,6 +466,11 @@ int x509_process_extension(void *context, size_t hdrlen,
>  		return 0;
>  	}
> 
> +	if (ctx->last_oid == OID_subjectKeyIdentifier_obsolete) {
> +		pr_info("2.5.29.1 subjectKeyIdentifier OID is obsolete.\n");
> +		return -ENOPKG;
> +	}
> +
>  	return 0;
>  }
> 
> diff --git a/include/linux/oid_registry.h b/include/linux/oid_registry.h
> index d2fa9ca42e9a..0641d5aa2251 100644
> --- a/include/linux/oid_registry.h
> +++ b/include/linux/oid_registry.h
> @@ -62,6 +62,7 @@ enum OID {
> 
>  	OID_certAuthInfoAccess,		/* 1.3.6.1.5.5.7.1.1 */
>  	OID_sha1,			/* 1.3.14.3.2.26 */
> +	OID_sha1WithRSASignature,	/* 1.3.14.3.2.29 */
>  	OID_sha256,			/* 2.16.840.1.101.3.4.2.1 */
>  	OID_sha384,			/* 2.16.840.1.101.3.4.2.2 */
>  	OID_sha512,			/* 2.16.840.1.101.3.4.2.3 */
> @@ -83,6 +84,7 @@ enum OID {
>  	OID_generationalQualifier,	/* 2.5.4.44 */
> 
>  	/* Certificate extension IDs */
> +	OID_subjectKeyIdentifier_obsolete,	/* 2.5.29.1 */
>  	OID_subjectKeyIdentifier,	/* 2.5.29.14 */
>  	OID_keyUsage,			/* 2.5.29.15 */
>  	OID_subjectAltName,		/* 2.5.29.17 */

