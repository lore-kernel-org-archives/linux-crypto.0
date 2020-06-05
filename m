Return-Path: <SRS0=mFw2=7S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01AA5C433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 09:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8DD2207DF
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 09:13:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HOrykkGu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgFEJNy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jun 2020 05:13:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57526 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbgFEJNy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jun 2020 05:13:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05596psK031612;
        Fri, 5 Jun 2020 09:13:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Srr3x0KE0YyUtKTiuAnbJA2aIeBpytmapuzrhcjP1Tc=;
 b=HOrykkGumjXllrp8el7dOOFrRe1ejP+/fpjzDYWcrq9HHHSseFPxRNFKVgG8yCg/voU8
 ZspEPPA65PqQqrAShvyKQwlKePwAMDaeyXEbzV81i4ktTJYLRQjNMAz3nYQ7BTj4goB0
 nUgHMLtQod24WnkXjvAj1bCH97hN5+Tff+8hqigRrnic6p3XjeReo2xbfVm9IPmtwShV
 j4a1Z1yjKLvY5TTy3AkigVB0Ea7UXn3kvH+tWSlHaFv4C12Ewne11iVO2FkOf8fU6SoO
 OyyhNFSEzooUu0ulaWEVbyqY6Rb9qE28wqRvG/B0KlFqFuNayjhYMCBoyeeKebt9sTZO 8w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31f91dsyed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 05 Jun 2020 09:13:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05597bFn095862;
        Fri, 5 Jun 2020 09:13:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31f9255umg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jun 2020 09:13:35 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0559DVbT011015;
        Fri, 5 Jun 2020 09:13:32 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Jun 2020 02:13:31 -0700
Date:   Fri, 5 Jun 2020 12:13:24 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Shukun Tan <tanshukun1@huawei.com>
Cc:     b6da310b-e633-9f74-f7af-7791d803aaf5@huawei.com,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] crypto: hisilicon - allow smaller reads in debugfs
Message-ID: <20200605091324.GR30374@kadam>
References: <20200602135409.GA59808@mwanda>
 <3e9b204f-ef53-31c5-afcd-e0791224c2b0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e9b204f-ef53-31c5-afcd-e0791224c2b0@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9642 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006050072
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9642 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 clxscore=1011 cotscore=-2147483648 malwarescore=0 adultscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 spamscore=0 mlxscore=0
 impostorscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006050072
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 05, 2020 at 09:19:53AM +0800, Shukun Tan wrote:
> Hi Dan,
> 
> On 2020/6/2 21:54, Dan Carpenter wrote:
> > Originally this code rejected any read less than 256 bytes.  There
> > is no need for this artificial limit.  We should just use the normal
> > helper functions to read a string from the kernel.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > v2: Use simple_read_from_buffer().  The v1 was slightly half arsed
> > because I left the original check for:
> > 
> > 	if (*pos)
> > 		return 0;
> > 
> > So it could result in partial reads.  The new code means that if you
> > want to read the buffer one byte at a time, that's fine or if you want
> > to read it in one 256 byte chunk that's also fine.  Plus it deletes 21
> > lines of code and is a lot cleaner.
> > 
> 
> In fact, In our original design, we do not hope the user do the partial reads.
> Thank you for your work, but I still insist on adding this limit.

This not how POSIX filesystems work...  :(  Last time you said that this
literally breaks cat.

This doesn't break anything if the user chooses not to read a single
byte at a time.  That's obviously a crazy way to read a file.  It just
allows them to if they want.  Or if they want to read 256 bytes at a
time then that also works.  My patch makes *everything* work.

regards,
dan carpenter
