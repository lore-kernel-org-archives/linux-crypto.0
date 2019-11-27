Return-Path: <SRS0=XAm+=ZT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F8DDC432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 23:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 131C8216F4
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 23:37:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kRlpjTXM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbfK0XhN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Nov 2019 18:37:13 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35026 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbfK0XhN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Nov 2019 18:37:13 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xARNTbYO060364;
        Wed, 27 Nov 2019 23:37:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=LoPc+eRX55aPbwiB2lf6oWAsVQspVY5etB8wrc7FkUs=;
 b=kRlpjTXMZIhgDxzJsrPrAGz+pTtvLzuYIu1hETkvvzt4I7OFI1jvpW6R0EbCo2hzX86J
 rEmBVMyNIRBOrv2Dfz88kQ2q19tKSxECC7k8+FxU8frHGyxbWUT4ZAL9UgC2aj0DqXPe
 /kOCjwHmgkb1IF50FtBFnVFcymY+H8QU/3QV9+GQoUcQ7zsKhSoXGn+UtbxTIpaE4bij
 x6RbR5/PjzUZVFfNMZ24AuduNiKOqisH/VJtWgO8efjXERohPEdEKSwRrEuZFplPTzFG
 X7bPUudRTclRDzMmt6CfgrMewSbIs9hcjcY3OoMwEVue/KceHdBvV99Dawl0waoTOiMQ Tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wev6ugd7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 23:37:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xARNXrV4090696;
        Wed, 27 Nov 2019 23:37:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2whrks7egy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 23:37:05 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xARNb3x4027355;
        Wed, 27 Nov 2019 23:37:04 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 27 Nov 2019 15:37:03 -0800
Date:   Wed, 27 Nov 2019 18:37:10 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH] padata: Remove unused padata_remove_cpu
Message-ID: <20191127233710.6gybmvu4dhhw2jgg@ca-dmjordan1.us.oracle.com>
References: <20191119223250.jaefneeatsa52nhh@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119223250.jaefneeatsa52nhh@gondor.apana.org.au>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9454 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911270188
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9454 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911270188
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 20, 2019 at 06:32:50AM +0800, Herbert Xu wrote:
> The function padata_remove_cpu was supposed to have been removed
> along with padata_add_cpu but somehow it remained behind.  Let's
> kill it now as it doesn't even have a prototype anymore.
> 
> Fixes: 815613da6a67 ("kernel/padata.c: removed unused code")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
