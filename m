Return-Path: <SRS0=bqmp=Q3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6E6DC43381
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 10:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72F3820C01
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 10:46:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WGXHv4kc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbfBTKqe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Feb 2019 05:46:34 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:42366 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfBTKqe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Feb 2019 05:46:34 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1KAckki168291;
        Wed, 20 Feb 2019 10:46:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=OnW/mkv4OKpJJYzcDGKhU23ZGm+FJYU0X7DmRwVem+8=;
 b=WGXHv4kcdiNuW0MPDvGVHY4tOs6qfvQREsjG+p/Krjt+VyVA+g1Aeljy7vody1EwL7ZT
 3Fx4Wb30N55wkjXlY05MLH9dIyBG9NmSeCmwnbru0LxY79DD8aegzf52tS/pqrMRHNTo
 xIaArUYDRk2kLVbqNjb1xEMfSho6LinAWXXgk1mpI2TXo162Rj2Hoe3OLkXH6Nx2q0Si
 tedFT/M761hxxlxMJmuFmrHeaSh4Q2BjCxIwBslZdKJCmeKdVy5hS4Ks4GE0vqKQd0wZ
 fsA0I2LPRHZfL4Qr0Zwybfy/AYuKRKsvRj/p1elHoTrNh1r2vmPqtsZJZKHJMXyltR3w lg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2qpb5rgn9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Feb 2019 10:46:16 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1KAk9dj021824
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Feb 2019 10:46:10 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1KAk8IU008437;
        Wed, 20 Feb 2019 10:46:08 GMT
Received: from kadam (/197.157.0.53)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Feb 2019 02:46:07 -0800
Date:   Wed, 20 Feb 2019 13:45:56 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] hwrng: make symbol 'optee_rng_id_table' static
Message-ID: <20190220104556.GO17104@kadam>
References: <20190220093458.159208-1-weiyongjun1@huawei.com>
 <CAFA6WYODEymSPh6gQjUL3wRmoPy=zoMv-Z1Q1TbKtWFH=UUgMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFA6WYODEymSPh6gQjUL3wRmoPy=zoMv-Z1Q1TbKtWFH=UUgMw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9172 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=969 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902200078
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 20, 2019 at 04:04:17PM +0530, Sumit Garg wrote:
> On Wed, 20 Feb 2019 at 14:51, Wei Yongjun <weiyongjun1@huawei.com> wrote:
> >
> > Fixes the following sparse warning:
                        ^^^^^^

> >
> > drivers/char/hw_random/optee-rng.c:265:35: warning:
> >  symbol 'optee_rng_id_table' was not declared. Should it be static?
> >
> 
> I haven't observed this warning during my normal Linux build using
> gcc. Is there any specific configuration you are using?
> 

It's from the Sparse tool.

regards,
dan carpenter

