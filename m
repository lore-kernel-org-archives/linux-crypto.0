Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 936D1C76186
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 01:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A7022171F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 01:54:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bxk8nfhQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbfG3ByK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 21:54:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54578 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727589AbfG3ByK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 21:54:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6U1cuHp039393;
        Tue, 30 Jul 2019 01:53:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=f9BTSG278YCddMybE8N0n7tZAlikyRiUgbx4cTXrEZY=;
 b=Bxk8nfhQhPW6zvVXbPjFUAohvmKJHGHnWZTRS4AQnSlb+E+1mTGqLJi6sGbX+1hWyzQU
 G84JuH/MNIzx+zAMj0Y0xJ7lfJJrpYgB6Tf8KofAlj3b5kYDNibmbTUp7UIAqV1uCwL7
 YHwFFw/Nhk2rHflIt1wPrM8RxkGnfmAGIPOl0Pj/l9U9hSRcUFlLLowPLUX+R8pGA8u8
 fp0O3VZQ0RGNV6/D3dqSdMFn+0w/lhuMmEP+o5FZCXqDQnibHkGO2M1ZzHw4ejwG6vGf
 DrS8llofUk3FkH/GhO0mYN3Hz7JwuyNFtQH3g2/46Xg6iJRO3RKyITFbCr6XzEQBVhF1 Dw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2u0f8qu23y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jul 2019 01:53:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6U1h2JG132064;
        Tue, 30 Jul 2019 01:53:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2u0bqttk8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jul 2019 01:53:50 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6U1rl5b002255;
        Tue, 30 Jul 2019 01:53:47 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 29 Jul 2019 18:53:47 -0700
Date:   Mon, 29 Jul 2019 21:53:43 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Tejun Heo <tj@kernel.org>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 3/9] workqueue: require CPU hotplug read exclusion for
 apply_workqueue_attrs
Message-ID: <20190730015343.lgj4hxejorofibmo@ca-dmjordan1.us.oracle.com>
References: <20190725212505.15055-1-daniel.m.jordan@oracle.com>
 <20190725212505.15055-4-daniel.m.jordan@oracle.com>
 <20190729194721.GG569612@devbig004.ftw2.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729194721.GG569612@devbig004.ftw2.facebook.com>
User-Agent: NeoMutt/20180323-268-5a959c
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9333 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=785
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907300016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9333 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=832 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907300016
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 29, 2019 at 12:47:21PM -0700, Tejun Heo wrote:
> On Thu, Jul 25, 2019 at 05:24:59PM -0400, Daniel Jordan wrote:
> > Change the calling convention for apply_workqueue_attrs to require CPU
> > hotplug read exclusion.
> > 
> > Avoids lockdep complaints about nested calls to get_online_cpus in a
> > future patch where padata calls apply_workqueue_attrs when changing
> > other CPU-hotplug-sensitive data structures with the CPU read lock
> > already held.
> > 
> > Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> 
> Acked-by: Tejun Heo <tj@kernel.org>

Thanks, Tejun!
