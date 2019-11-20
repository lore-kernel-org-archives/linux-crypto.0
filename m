Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B42DC432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 18:56:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72EA120715
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 18:56:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bxP1klUO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfKTS4Y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 13:56:24 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51274 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfKTS4Y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 13:56:24 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKIs6oU002510;
        Wed, 20 Nov 2019 18:56:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=yr+89KhIlhBh3uIKtOV1mQDek7rSN7MYOBSixP/sdYY=;
 b=bxP1klUOy8++X8hthkXi6wOv9krI5OKS1xs6CdRBho3HqR6FOmgMAzFaYR4Emaqkz9U4
 FNw5KJ2DcFiNaFTJxmZ2THu35LPFZgJ5ne3hsQngmH+cF6UimHPN2qjO3UWzjIsR/r1z
 73F13F4Kic0g3vI691f+CuLtmTZvOEmUaTNUIIZ6x2FGILReslwm6g7LIG7K7cny19tM
 7JGEXsP2mzZvJM8BHY0DAgk7tGyI1FUFXWk7E9DUGYU4hM2jvoTiDpKys/1JMS5VVrL7
 8HZtaJJq7bE+V/u+7QHfuaABx5zGwfN+/tVcFXI6KhljhDik3beIgqOD4VgAynyMSXl8 pQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wa9rqqf43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 18:56:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKIriSM004152;
        Wed, 20 Nov 2019 18:56:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2wd46wwqr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 18:56:12 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAKIuApU012723;
        Wed, 20 Nov 2019 18:56:10 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 10:56:10 -0800
Date:   Wed, 20 Nov 2019 13:56:12 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH] padata: Remove unused padata_remove_cpu
Message-ID: <20191120185612.ez2polukfpibkhnd@ca-dmjordan1.us.oracle.com>
References: <20191119223250.jaefneeatsa52nhh@gondor.apana.org.au>
 <20191119225101.t4ktiggrdyptd3ii@ca-dmjordan1.us.oracle.com>
 <20191120011015.qzhn3yd6w5qhze3l@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120011015.qzhn3yd6w5qhze3l@gondor.apana.org.au>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=803
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=869 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200156
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 20, 2019 at 09:10:15AM +0800, Herbert Xu wrote:
> On Tue, Nov 19, 2019 at 05:51:01PM -0500, Daniel Jordan wrote:
> > On Wed, Nov 20, 2019 at 06:32:50AM +0800, Herbert Xu wrote:
> > > The function padata_remove_cpu was supposed to have been removed
> > > along with padata_add_cpu but somehow it remained behind.  Let's
> > > kill it now as it doesn't even have a prototype anymore.
> > 
> > Documentation/padata.txt still has a reference to this function that should be
> > removed.
> 
> It also has references to all the other functions that have long
> disappeared, such as padata_add_cpu.  Would you like to send a
> patch to remove all of them?

Ok, sure.
