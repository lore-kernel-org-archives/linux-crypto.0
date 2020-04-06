Return-Path: <SRS0=kLV/=5W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F1ECC2BA19
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Apr 2020 10:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08585206C3
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Apr 2020 10:40:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zj//MldQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgDFKkQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Apr 2020 06:40:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42168 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgDFKkP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Apr 2020 06:40:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036Ad4fT119959;
        Mon, 6 Apr 2020 10:40:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=kr75yLIamnwtawkz2MxXauBsevAhOSzEy1Avd4AWZ+8=;
 b=zj//MldQIMtf/M5vCmrGkcuRQ6KPZAwYwrjmLxLbYoxHTkWEHZ5H5VdtgqdCL+b/y9ac
 FRjkoYTp1eml0+tk4tQNwBwGQx8pU4ECUMeZPulBmP9jrozBO218+SEdlwREUivBjRuN
 AFk8QUhKqcKNBd+vriE0H9e/PHMDMrYwahO5fZvsuv4luxBY6iKbhd/NIAvAGP9nzEbF
 Wr0EiOaJ/yE7HiCUwhLHUFq6mphotyduuZXn6sfo3HaKFxe9eCYxB7OUzT8hEMb1mXVc
 SMcpfdd6U/mM7Fb8CjAPFoxFKEJl5DS7yaYP5mH4uVzsMDdNA8PGknQDp2h7xnZRiFQO Tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 306jvmwydr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 10:40:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036AWOgL167276;
        Mon, 6 Apr 2020 10:38:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3073xvx0j3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 10:38:13 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 036AcCSx024387;
        Mon, 6 Apr 2020 10:38:12 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 03:38:11 -0700
Date:   Mon, 6 Apr 2020 13:38:05 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     schalla@marvell.com
Cc:     SrujanaChalla <schalla@marvell.com>, linux-crypto@vger.kernel.org
Subject: [bug report] crypto: marvell - add the Virtual Function driver for
 CPT
Message-ID: <20200406103805.GA34106@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9582 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 mlxlogscore=785
 adultscore=0 spamscore=0 phishscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060092
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9582 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=3
 mlxlogscore=840 mlxscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 malwarescore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060092
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello SrujanaChalla,

This is a semi-automatic email about new static checker warnings.

The patch 10b4f09491bf: "crypto: marvell - add the Virtual Function 
driver for CPT" from Mar 13, 2020, leads to the following Smatch 
complaint:

    drivers/crypto/marvell/octeontx/otx_cptvf_algs.c:132 otx_cpt_aead_callback()
    warn: variable dereferenced before check 'cpt_info' (see line 121)

drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
   120	
   121		cpt_req = cpt_info->req;
                          ^^^^^^^^^^^^^
Dereference

   122		if (!status) {
   123			/*
   124			 * When selected cipher is NULL we need to manually
   125			 * verify whether calculated hmac value matches
   126			 * received hmac value
   127			 */
   128			if (cpt_req->req_type == OTX_CPT_AEAD_ENC_DEC_NULL_REQ &&
   129			    !cpt_req->is_enc)
   130				status = validate_hmac_cipher_null(cpt_req);
   131		}
   132		if (cpt_info) {
                   ^^^^^^^^^
Check is too late.

   133			pdev = cpt_info->pdev;
   134			do_request_cleanup(pdev, cpt_info);

regards,
dan carpenter
