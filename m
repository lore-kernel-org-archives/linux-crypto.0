Return-Path: <SRS0=f1VZ=XN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E803C4CEC9
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 20:38:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8660207FC
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 20:37:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jUwQMtUn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfIRUh6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Sep 2019 16:37:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36014 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbfIRUh6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Sep 2019 16:37:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IKTPIC031589;
        Wed, 18 Sep 2019 20:37:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=cryqLvipHgUfVuStZy6gQHFH68Li1WzodPzi1Hm38z8=;
 b=jUwQMtUne+QRIEc97eE/n7GKrRdPD32KZXpuBd55SBjOG0C0CyqIWBsYiAcQOQEnU3K+
 nLjiqXcf6kfHnzVjW4SZ9FSzDyrcRxOWsmqYE8BUHeeOQrla5nLaB1GhhZcXRDs8em8P
 KP49jtuwdn16XI2CQUZKrSQejudN6QmJgSD0/VdU9/DnIDotat5IlMKQb0rSsDo0Ew0t
 oW5R7yI3RPlgL8Jamok0j3Yk/1nmDvckzXdep7DojN1H0TIAwDWRxmBKFqXQzd2E1i8d
 qGus9cr/ZZqzBW/1pcfLljbazRhJEOjx/mjTnSeKcZ+1qbYACcyX43GJZ6krlMavgQ88 kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2v385dxdng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 20:37:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IKXexs092475;
        Wed, 18 Sep 2019 20:37:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2v37mb95v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 20:37:36 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8IKbY6E002285;
        Wed, 18 Sep 2019 20:37:34 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Sep 2019 13:37:33 -0700
Date:   Wed, 18 Sep 2019 16:37:30 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] padata: make flushing work with async users
Message-ID: <20190918203730.4x5blgg74ah5dxup@ca-dmjordan1.us.oracle.com>
References: <20190828221425.22701-1-daniel.m.jordan@oracle.com>
 <20190828221425.22701-2-daniel.m.jordan@oracle.com>
 <20190905041734.GA25330@gondor.apana.org.au>
 <20190905223756.wmmjkjvztlerjzee@ca-dmjordan1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905223756.wmmjkjvztlerjzee@ca-dmjordan1.us.oracle.com>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909180176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909180176
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 05, 2019 at 06:37:56PM -0400, Daniel Jordan wrote:
> On Thu, Sep 05, 2019 at 02:17:35PM +1000, Herbert Xu wrote:
> > I don't think waiting is an option.  In a pathological case the
> > hardware may not return at all.  We cannot and should not hold off
> > CPU hotplug for an arbitrary amount of time when the event we are
> > waiting for isn't even occuring on that CPU.
> 
> Ok, I hadn't considered hardware not returning.
> 
> > I don't think flushing is needed at all.  All we need to do is
> > maintain consistency before and after the CPU hotplug event.
> 
> I could imagine not flushing would work for replacing a pd.  The old pd could
> be freed by whatever drops the last reference and the new pd could be
> installed, all without flushing.
> 
> In the case of freeing an instance, though, padata needs to wait for all the
> jobs to complete so they don't use the instance's data after it's been freed.
> Holding the CPU hotplug lock isn't necessary for this, though, so I think we're
> ok to wait here.

[FYI, I'm currently on leave until mid-October and will return to this series
then.]
