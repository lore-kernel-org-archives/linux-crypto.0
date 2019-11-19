Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5479FC432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 22:44:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 245012245D
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 22:44:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iVRGnON8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfKSWok (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 17:44:40 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44514 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbfKSWoj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 17:44:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJMYKek039172;
        Tue, 19 Nov 2019 22:44:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=RmelXEZbfZTrI5HxtJpeK/xmE6iGKJe/MNPcP/qSWPg=;
 b=iVRGnON8CERyIYt+MTEPXrciGh3m0G4aCo2y4vfGQXrC6dMsiQPN7v6veXrqjA4fJgtZ
 FeX1rBe2E5tSNezAr2xTFP2xNWAjSfaEP18kzqEpSUZzbjkWlIO2pB75zulRbFUycHGn
 GyUWRdzByhmbPSi68y21jaGzVfAHQ4ix8/kR1LCb1oOVSnX73Px1uCXZjTSi8MWj8V8+
 AkVS/iI8r/kqLrcKlwM/BvEimLufVsmMYeb7cjCEdBh4Jnw/GQQl6lo62nOcPg+xtxmT
 N3qz+zelma2Q6kX2qJqbjuXGyxjA9eIiyj2UpHoZ1SDcbXoLU49HaF4R/mY3Atdy+Z8n KQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wa8htt52v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 22:44:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJMceJM170085;
        Tue, 19 Nov 2019 22:44:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2wc09y5jyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 22:44:31 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAJMiUPU019553;
        Tue, 19 Nov 2019 22:44:30 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Nov 2019 14:44:30 -0800
Date:   Tue, 19 Nov 2019 17:44:32 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: Remove broken queue flushing
Message-ID: <20191119224432.vr7lyoaqdzpelszo@ca-dmjordan1.us.oracle.com>
References: <20191119051731.yev6dcsp2znjaagz@gondor.apana.org.au>
 <20191119192405.imfi6q4u3g2zgstc@ca-dmjordan1.us.oracle.com>
 <20191119215345.jr7y47b37ivshwcm@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119215345.jr7y47b37ivshwcm@gondor.apana.org.au>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911190180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911190180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 20, 2019 at 05:53:45AM +0800, Herbert Xu wrote:
> On Tue, Nov 19, 2019 at 02:24:05PM -0500, Daniel Jordan wrote:
> >
> > __padata_free unconditionally frees pd, so a padata job might choke on it
> > later.  padata_do_parallel calls seem safe because they use RCU, but it seems
> > possible that a job could call padata_do_serial after the instance is gone.
> 
> Actually __padata_free no longer frees the pd after my patch.

I assume you mean the third patch you recently posted, "crypto: pcrypt - Avoid
deadlock by using per-instance padata queues".  That's true, the problem is
fixed there, and the bug being present in bisection doesn't seem like enough
justification to implement something short-lived just to prevent it.

> We should also mandate that __padata_free can only be called after
> all jobs have completed.  This is already the case with pcrypt.

Makes sense to me, though I don't see how it's enforced now in pcrypt.  I'm not
an async crypto person, but wouldn't unloading the pcrypt module when there are
still outstanding async jobs break this rule?

> In fact we should discuss merging padata into pcrypt.  It's been
> 10 years and not a single user of padata has emerged in the kernel.

Actually, I'm working on an RFC right now to add more users for padata.  It
should be posted in the coming week or two, and I hope it can be part of that
discussion.
