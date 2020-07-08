Return-Path: <SRS0=WqbL=AT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105F7C433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 19:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E76A1206F6
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 19:53:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ri/wpHrN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgGHTx1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jul 2020 15:53:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51392 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgGHTx0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jul 2020 15:53:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 068Jkc4b014971;
        Wed, 8 Jul 2020 19:53:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=l5kP04TQx9CT6XBndJoPCQt97j3az16WSIoo49ut7H0=;
 b=Ri/wpHrNAp/87a8ITffVtp7EjnPYPzVXnf++JO8YDZ4h3h6A24ObFmeMUy2urj8JP860
 WmPB9TfZdQNosk77pShY+mRzraYfQnC2mzkkX/cREpHlmWIkKqf/Tr7xjV8MRyWoj+Z2
 wLpjbBtMuWD3cCt9wGtAHF2heY6wrDRZseIUIHcPlX7vJe5PzBgYgN+7YEZ1S7SKoeOJ
 gp4IkGEbBdRa/3g7f7TB79rpRqzIHVNKQ61BW10/nglfUQup6PUM3HyD+eBt46D9wUwc
 GoX22Ro7BQsFkpWlRO34sK2EdnbFK57XPPIq+iDQXmZaq70ldIidQxYTlN3zix8c4Se3 pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 325k368j0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 08 Jul 2020 19:53:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 068JnHUe167225;
        Wed, 8 Jul 2020 19:51:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 325k3efsre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jul 2020 19:51:14 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 068JpClo018936;
        Wed, 8 Jul 2020 19:51:12 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Jul 2020 12:51:12 -0700
Date:   Wed, 8 Jul 2020 15:51:40 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Nico Pache <npache@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        steffen.klassert@secunet.com, daniel.m.jordan@oracle.com
Subject: Re: [PATCH v2] Remove __init from padata_do_multithreaded and
 padata_mt_helper.
Message-ID: <20200708195140.hioiltf7pwppz6j7@ca-dmjordan1.us.oracle.com>
References: <20200702155548.14690-1-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702155548.14690-1-npache@redhat.com>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9676 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007080119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9676 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0 mlxscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 clxscore=1011 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007080119
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(I was away for a while)

On Thu, Jul 02, 2020 at 11:55:48AM -0400, Nico Pache wrote:
> Allow padata_do_multithreaded function to be called after bootstrap.

The functions are __init because they're currently only needed during boot, and
using __init allows the text to be freed once it's over, saving some memory.

So this change, in isolation, doesn't make sense.  If there were an enhancement
you were thinking of making, this patch could then be bundled with it so the
change is made only when it's used.

However, there's still work that needs to be merged before
padata_do_multithreaded can be called after boot.  See the parts about priority
adjustments (MAX_NICE/renicing) and concurrency limits in this branch

  https://oss.oracle.com/git/gitweb.cgi?p=linux-dmjordan.git;a=shortlog;h=refs/heads/padata-mt-wip-v0.5

and the ktask discussions from linux-mm/lkml where concerns about these issues
were raised.  I plan to post these parts fairly soon and can include you if you
want.
