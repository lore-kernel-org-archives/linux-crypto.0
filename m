Return-Path: <SRS0=c5Ty=T4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,UNPARSEABLE_RELAY,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA778C04AB6
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 23:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A960621019
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 23:37:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ax71s3QJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfE1Xh0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 May 2019 19:37:26 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:54904 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfE1Xh0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 May 2019 19:37:26 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4SNSoGF128001;
        Tue, 28 May 2019 23:37:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=H1b3CmpfTkZgxRfO0YlFFrBaQVtQ3uJKq53BkVtB23s=;
 b=ax71s3QJrcnGCWO4hozKCTSzGgWZowVWZ8V2DBjtoAFxl/i8EaA6pSU86r0JUC6T7gGz
 NDGFcFNw9sqRG/WYn5KGzBXtFQInfK2uAMG6aC9yF7JxvFvvGAknblfM2Vs7EPlRG3Oh
 Ho79Bo+GwKrPiPswmbjF1UNOf8xB2DhR2HMpVmrs0bmpl0QoCz2gxeOhl1fU/IWOzuaH
 Bi5wg2MD5dksntcTLgs2idTeGP1rNq/TYdZ7kAfczWg8zZ2mjKcJBwEflsJQDVkR2t7m
 ihAzQ7cFelZMefB/m8Hwafp9VQXj35fHUqMb8w63zf64P+IKoQOTrTSoQk0omzJsB0Y6 MA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2spu7dem5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 May 2019 23:37:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4SNZKLk077525;
        Tue, 28 May 2019 23:37:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ss1fn54bh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 May 2019 23:37:08 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4SNb7WF022616;
        Tue, 28 May 2019 23:37:07 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 May 2019 16:37:06 -0700
Date:   Tue, 28 May 2019 19:37:07 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     steffen.klassert@secunet.com
Cc:     peterz@infradead.org, akpm@linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Question about padata's callback cpu
Message-ID: <20190528233707.gc4xomnlcuiszqht@ca-dmjordan1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180323-268-5a959c
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9271 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905280148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9271 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1031
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905280148
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Steffen,

I'm working on some padata patches and stumbled across this thread about the
purpose of the callback CPU in padata_do_parallel.

    https://lore.kernel.org/lkml/20100402112326.GA19502@secunet.com/

The relevant part is,

  andrew> - Why would I want to specify which CPU the parallel completion
  andrew>   callback is to be executed on?
  
    steffen> Well, for IPsec for example it is quite interesting to separate the
    steffen> different flows to different cpus. pcrypt does this by choosing different
    steffen> callback cpus for the requests belonging to different transforms.
    steffen> Others might want to see the object on the same cpu as it was before
    steffen> the parallel codepath.

Not too familiar with IPsec, but I'm guessing it's interesting to separate the
flows for performance reasons.  Is the goal to keep multiple flows from
interfering with each other (ensuring they run on different CPUs), or maybe to
get better locality (ensuring each always runs on the same CPU)?  It'd be
helpful if you could expand on this.

By the way, the padata patches extend the code to parallelize more places
around the kernel, as Peter suggested.

    https://lore.kernel.org/lkml/20181106203411.pdce6tgs7dncwflh@ca-dmjordan1.us.oracle.com/

Thanks,
Daniel
