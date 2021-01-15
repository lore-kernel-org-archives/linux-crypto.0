Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA802C433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Jan 2021 18:08:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B327323A58
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Jan 2021 18:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbhAOSH6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Jan 2021 13:07:58 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47956 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbhAOSH5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Jan 2021 13:07:57 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10FI5S4o158458;
        Fri, 15 Jan 2021 18:06:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=IwvUFpVsIzA5OIqdGUQ2dTbYP+xZokygMo4pqSnWeXo=;
 b=yKPrL2TL5OFIGrI2VmdRAYFFyuBZ1oB5S3Gy13unlAFNXN0+y58D48UIblljISFLxXQk
 DOuaad67mugTPo7oGZbev6F8PtNbyXvayv7r7l4TTebv2wlnu3zbiszw3PvVbI9TBTM+
 VQucP2XJbJOSUpk2nM50LRKeVefaY7rP7p9vFT/Gar6eaiJMc6ON+uo858nBWgKszUbj
 VQJJb0Jz2b79JJkKdIWAUMr48JOg8XXuLHbcD809BLpiReajRFJi5h7+JSROcAY1DrQy
 rRK3dK+kFBhqK4mq4FbzTuQPDcgYNJmCA6wW5WViCsKDRGobu9UIEOrfnB9nlSxKdksn Jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 360kvke2sp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 18:06:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10FI5q29018467;
        Fri, 15 Jan 2021 18:06:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 360kebebxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 18:06:37 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10FI6avd007797;
        Fri, 15 Jan 2021 18:06:36 GMT
Received: from dhcp-10-39-203-150.vpn.oracle.com (/10.39.203.150)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 Jan 2021 10:06:36 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] crypto: lib/chacha20poly1305 - define empty module exit
 function
From:   John Donnelly <john.p.donnelly@oracle.com>
In-Reply-To: <20210115171743.1559595-1-Jason@zx2c4.com>
Date:   Fri, 15 Jan 2021 12:06:34 -0600
Cc:     linux-crypto@vger.kernel.org, ardb@kernel.org,
        herbert@gondor.apana.org.au
Content-Transfer-Encoding: 7bit
Message-Id: <6F8CD748-33AA-48C7-90A4-D42F9C037F77@oracle.com>
References: <20210115171743.1559595-1-Jason@zx2c4.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9865 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101150109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9865 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1011 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150109
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> On Jan 15, 2021, at 11:17 AM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> 
> With no mod_exit function, users are unable to load the module after
> use. I'm not aware of any reason why module unloading should be
> prohibited for this one, so this commit simply adds an empty exit
> function.
> 
> Reported-by: John Donnelly <john.p.donnelly@oracle.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---


Hi ,

 Verified 

 Please add 


  Test-by: John Donnelly <john.p.donnelly@oracle.com>



> lib/crypto/chacha20poly1305.c | 5 +++++
> 1 file changed, 5 insertions(+)
> 
> diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
> index 5850f3b87359..c2fcdb98cc02 100644
> --- a/lib/crypto/chacha20poly1305.c
> +++ b/lib/crypto/chacha20poly1305.c
> @@ -362,7 +362,12 @@ static int __init mod_init(void)
> 	return 0;
> }
> 
> +static void __exit mod_exit(void)
> +{
> +}
> +
> module_init(mod_init);
> +module_exit(mod_exit);
> MODULE_LICENSE("GPL v2");
> MODULE_DESCRIPTION("ChaCha20Poly1305 AEAD construction");
> MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
> -- 
> 2.30.0
> 

