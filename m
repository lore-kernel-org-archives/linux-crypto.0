Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3E74C43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 14:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2EB7205C9
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 14:53:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ktPm5tc6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbfFXOxn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 10:53:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38702 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbfFXOxn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 10:53:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OEmvQ4041482;
        Mon, 24 Jun 2019 14:53:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=waQPePaU/7Xj6dq9mxwPa/7YRLZYgY2bjH/CbYXyHIU=;
 b=ktPm5tc6CSRuF1rAb7B26OtxPNBhY55a4sqhg74vNRdlAD6zMqjUAX0konlS2bVASIa7
 OBGgI/GDOeFF+fq+4bW2dZwYb6OnbYxDh7uD1ewZRcjRwwQbvIQdWdZrUjWA2kkqe1rP
 FXaEu/c35wOqU2uu291p2xhe7rfpmJueBeZLLMPTWq33ttbl6875n/Jxw708h8alyJRQ
 42TEAub0CAqdGFJF/tTsSyzxQRj+O7CNPztazp8OWH8XMiWGk3PkXx1G21xGhkcWNTPB
 fo65o/h3VlIjWO/TkQkTq33k1oDVW4Erx342kRkpFjSA7FapqPHCx3lRRq4x/3C46vwf 8g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2t9brsxxdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 14:53:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OEno4s021846;
        Mon, 24 Jun 2019 14:51:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2t99f3akmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 14:51:15 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5OEpEob026505;
        Mon, 24 Jun 2019 14:51:14 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Jun 2019 07:51:13 -0700
Date:   Mon, 24 Jun 2019 17:51:06 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Tadeusz Struk <tadeusz.struk@intel.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - Endian bug in interrupt handler
Message-ID: <20190624145105.GX28859@kadam>
References: <20190624134839.GB1754@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624134839.GB1754@mwanda>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=804
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906240120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=856 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906240121
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Never mind.  Please ignore this patch.

This is Intel hardware so it's little endian.  There are a bunch of
other test_bit() casts which would be problematic so this wouldn't
really fix anything anyway.

regards,
dan carpenter

