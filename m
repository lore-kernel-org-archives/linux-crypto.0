Return-Path: <SRS0=S8oY=Z7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3350C04E30
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Dec 2019 20:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B58AD20637
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Dec 2019 20:39:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="si5mTl2q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfLIUjx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Dec 2019 15:39:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33546 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfLIUjx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Dec 2019 15:39:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB9Kdar4083867;
        Mon, 9 Dec 2019 20:39:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=pgrzkgIvorMYsWDVNvkZGEiwd4r9QTH0sc9WP6gd/fA=;
 b=si5mTl2qpZ2XIuHA+nlWUePoRIhka1QKKCCWNVtyx6rhpIw55EVZH81no/g7mZJn+yKO
 d/VaSMECkMGHzgLZnTPozIoYWj/R7kia8MqyOkB1Sx2ek4PymbM3C6f2gpwjcSVr6pWH
 5k+CNxQY6kAMN9eZ6HZkz0dkt7UnT+p64XIokHHMXZvu347ER8d0B+JK4KmXU4j279/X
 wEVTOvNueze5qiRGYgOktwxUq1cY8IAnuFWqVT3eruAtC1Fd3iIxeVjzv/HaOVSsiW2B
 g82odMAk+8qeSfmqk+WURms/llfiXuMkgN7Ioc7++U9c66IM6Ijv9E2txpdDQjSaf3O7 Og== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wrw4mxw4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Dec 2019 20:39:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB9KdU5J015463;
        Mon, 9 Dec 2019 20:39:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2wsw6frn7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Dec 2019 20:39:42 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB9KdeNX015737;
        Mon, 9 Dec 2019 20:39:40 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Dec 2019 12:39:40 -0800
Date:   Mon, 9 Dec 2019 15:39:46 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: RFD: multithreading in padata
Message-ID: <20191209200348.av6b4g6euqmoxvvo@ca-dmjordan1.us.oracle.com>
References: <20191203155841.56egvxekxgf5xctw@ca-dmjordan1.us.oracle.com>
 <20191209123929.GQ8621@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209123929.GQ8621@gauss3.secunet.de>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=764
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912090162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=846 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912090162
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 09, 2019 at 01:39:29PM +0100, Steffen Klassert wrote:
> On Tue, Dec 03, 2019 at 10:58:41AM -0500, Daniel Jordan wrote:
> > Thoughts?  Questions?
> 
> I'm ok with this.

Glad to hear it, will continue in this direction.

> Please consider to add yourself as
> a Co-Maintainer, I guess you know the code in between
> much better than I do :)

Sure, I'll consider that :)  Thanks for looking, Steffen.
