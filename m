Return-Path: <SRS0=xc0K=7W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDAE1C433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jun 2020 01:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD9B420774
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jun 2020 01:28:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WkK1kROf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgFIB2m (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Jun 2020 21:28:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58160 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbgFIB2l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Jun 2020 21:28:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0591QZuj129594;
        Tue, 9 Jun 2020 01:28:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=6CG+NZiljIKnCImKVj+Ku6NjV6OAFTrVxrGb4aTwcWQ=;
 b=WkK1kROffoKTpIURAGgaeYYfQ9OnvmrqKRWFe1EtEvyQN4oxoyhx7TFtD3cBTnyBJCYk
 jxFppewhB8Rw2QWcj4PgBGBqvnBp2Iuf3G38b5SQ3vaaSg+6GS0wHCEl/jUYpuVOozBF
 4kahkIwTmtAvdp6AH9qW0baWbLzlfb+BFKjeuZ/LI24bkpE+c+A2zRUBNpgQYAWMKBIq
 vdqTkyRGiOCTAUud8vzTml+PzSkHm9flnVaUz0IYya7+E4eA7gkHONeHeukm25/xwQSs
 gnxGwI/5LyaL7MYvvHKoBQvOw6liqSU4g1SLaQgnAPB3QI2PkGLc450peaIcDl8NFgpc KA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31g2jr1w2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 09 Jun 2020 01:28:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0591SLMr189024;
        Tue, 9 Jun 2020 01:28:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31gmwqnxyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jun 2020 01:28:31 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0591SUKi000491;
        Tue, 9 Jun 2020 01:28:31 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jun 2020 18:28:30 -0700
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [v2 PATCH] crc-t10dif: Fix potential crypto notify dead-lock
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sgf5rpta.fsf@ca-mkp.ca.oracle.com>
References: <20200604063324.GA28813@gondor.apana.org.au>
        <20200605065918.GA813@gondor.apana.org.au>
Date:   Mon, 08 Jun 2020 21:28:27 -0400
In-Reply-To: <20200605065918.GA813@gondor.apana.org.au> (Herbert Xu's message
        of "Fri, 5 Jun 2020 16:59:18 +1000")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006090008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 cotscore=-2147483648 priorityscore=1501 spamscore=0 suspectscore=1
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 phishscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006090008
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Herbert,

> The crypto notify call occurs with a read mutex held so you must not
> do any substantial work directly.  In particular, you cannot call
> crypto_alloc_* as they may trigger further notifications which may
> dead-lock in the presence of another writer.
>
> This patch fixes this by postponing the work into a work queue and
> taking the same lock in the module init function.

No particular objections to this approach from me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
