Return-Path: <SRS0=pM9r=EC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F209AC4363A
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Oct 2020 21:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C3A220747
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Oct 2020 21:11:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P5LHWXvR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505411AbgJ0VL1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Oct 2020 17:11:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38100 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505367AbgJ0VL0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Oct 2020 17:11:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RL8gCJ168382;
        Tue, 27 Oct 2020 21:11:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=lRZmq3kWpRJ7AxDzYsfJ3jGJvDrAet61pmfQoBn+ils=;
 b=P5LHWXvRAIsaSx9WhFZC0Es1OCmbw8MWwYSR41GoCDhjrfgZ3Hb7P4oUcCWY2kD0zbwK
 8uaukGj2yRaNbXW5lbtNBKzjCG6aN95xrPdPrHKs4KQGaha3rnLlVRhvl/3opDMVVb+J
 Ne9FfXw+W4acQegSIqQCgmabEoxCOX83q0jF1gQFzBscCOL2Jq9/jsM5YSWhu7POeUaT
 CRK7phLEDRZnyR726Z+AzXr30eqWLD+up7Jp3z+zS+05/Mc9S1j60EMHsNxsJz3AKGDs
 LHxD7DA9/smrlC6GcP+/UTfAe2hAMx/yW0Co5bf/uyP6HTmXqsBCRXWChHWq50+DS3nX dw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34dgm4203u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 21:11:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RL5LL9186830;
        Tue, 27 Oct 2020 21:11:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34cx6wf1x7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 21:11:21 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09RLBJEv016279;
        Tue, 27 Oct 2020 21:11:19 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 14:11:19 -0700
Date:   Tue, 27 Oct 2020 17:20:34 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Nico Pache <npache@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        steffen.klassert@secunet.com, daniel.m.jordan@oracle.com
Subject: Re: [PATCH v2] Remove __init from padata_do_multithreaded and
 padata_mt_helper.
Message-ID: <20201027212034.qiwk34ihwsdwlqv3@ca-dmjordan1.us.oracle.com>
References: <20200702155548.14690-1-npache@redhat.com>
 <20200708195140.hioiltf7pwppz6j7@ca-dmjordan1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708195140.hioiltf7pwppz6j7@ca-dmjordan1.us.oracle.com>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1011 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270124
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/27/20 12:46 AM, Nico Pache wrote:
> On Wed, Jul 08, 2020 at 03:51:40PM -0400, Daniel Jordan wrote:
> > (I was away for a while)
> > 
> > On Thu, Jul 02, 2020 at 11:55:48AM -0400, Nico Pache wrote:
> > > Allow padata_do_multithreaded function to be called after bootstrap.
> > 
> > The functions are __init because they're currently only needed during boot, and
> > using __init allows the text to be freed once it's over, saving some memory.
> > 
> > So this change, in isolation, doesn't make sense.  If there were an enhancement
> > you were thinking of making, this patch could then be bundled with it so the
> > change is made only when it's used.
> > 
> > However, there's still work that needs to be merged before
> > padata_do_multithreaded can be called after boot.  See the parts about priority
> > adjustments (MAX_NICE/renicing) and concurrency limits in this branch
> > 
> >   https://oss.oracle.com/git/gitweb.cgi?p=linux-dmjordan.git;a=shortlog;h=refs/heads/padata-mt-wip-v0.5
> > 
> > and the ktask discussions from linux-mm/lkml where concerns about these issues
> > were raised.  I plan to post these parts fairly soon and can include you if you
> > want.
>
> I really like the speed benefits I've been able to achieve by using your
> padata multithreaded interface in the branch you linked me to. Do you
> still have plans on moving forward with this upstream?

Yes, I'm still planning to push these patches upstream, but it's going to take
some time with all the prerequisites.  I'm working on remote charging in the
CPU controller now, which is the biggest unfinished task.  A little background
on that here:

https://lore.kernel.org/linux-mm/20200219220859.GF54486@cmpxchg.org/
