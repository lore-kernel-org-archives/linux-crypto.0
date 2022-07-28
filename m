Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B3CC19F29
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Jul 2022 10:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236023AbiG1KhF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Jul 2022 06:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236016AbiG1KhE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Jul 2022 06:37:04 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BAB154AF2
        for <linux-crypto@vger.kernel.org>; Thu, 28 Jul 2022 03:37:03 -0700 (PDT)
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=DItVBGog7cn+jPuH1/kEwJ05+Wcko8mArbDrwdSFpViyFtj8Y7on3HS4hTZ10dx0HevZVMaeK4M6mQAns2YpmorQ4wfXZFMvu6L0VEF5BUrlgs3Ln1IjTghAdF4HfnD2Jt0td90NsMnwXdhrB81L9uyCPTTgGRh2VnODyazghnZRiXp1EUx7qe5j/3IZsm2LebH3unPZS5FOxKHha7EP0yLanOcPqKWAF9Vh+9a/M11Dn/puEp43p0+odSufWZAHivUSqtTheNx478WtJDWovJbtn0HgMHtjjfG9eK7ZmBhfA0rL4iPu2lqFeF4bLRKIp7Q0mLFa0i3CDwPnYrtJ1w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/s4kWse1BMHTQqhr5HEVUptJYHB4WvzGtRTffyhUPdE=;
 b=QS6HA5HH5aeMYg4Yklq5zm7CLCwaKycyWLG0kGHDrooDU0AqA3nBjCsRzVjKvRroQ87rJX0FtQf1xNo9TQexZK/ZQQIuewIGkA4WCJ99UqBZkVnRD85SIRYnTv4pszwlFzgzpe1d1zXStO29s2JMs11qYGAGEWti8OHbwv5N1xU9FNWkLU9fEEzLzYtlynnD7TA2kH0+FAoWi6+gDzJjqLQMBGgOOAg2LopB2sRrzRW7OUOdDsD+TNOgYRAI/rWi68b+0pdaSV/licsJjI45zil5NkCpdk1+7dJGmOoz+pIJXy6Ik9ALN2HxSXdviLczkHWS1ou1f+6ymXSRlnD9/g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/s4kWse1BMHTQqhr5HEVUptJYHB4WvzGtRTffyhUPdE=;
 b=Yc82DWwdBrHXkqXQNYcnwwBi9QYEosrG6XqHVCVuHu5ky2v1ne/V2QA4aQq+gmLGgA52Dl1DhL5vzS7QcGPCwxFbc1UX5iGpo5Ne3mFiwlvJtkA8o9ufeQ5wkMFdT8QKqok66dEg1Ggf2cQwqYGWXXJ5MwB1pQFv8Y3jvc5MbHs=
Received: from DB6PR0601CA0040.eurprd06.prod.outlook.com (2603:10a6:4:17::26)
 by AS8PR08MB7025.eurprd08.prod.outlook.com (2603:10a6:20b:34c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Thu, 28 Jul
 2022 10:37:00 +0000
Received: from DBAEUR03FT014.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:17:cafe::5a) by DB6PR0601CA0040.outlook.office365.com
 (2603:10a6:4:17::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.10 via Frontend
 Transport; Thu, 28 Jul 2022 10:37:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT014.mail.protection.outlook.com (100.127.143.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5482.12 via Frontend Transport; Thu, 28 Jul 2022 10:37:00 +0000
Received: ("Tessian outbound 2af316122c7a:v123"); Thu, 28 Jul 2022 10:37:00 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 369a0555cfc39863
X-CR-MTA-TID: 64aa7808
Received: from 03cc4cf737a1.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 6D1236CD-1E3B-48D2-ACF9-8722DAFBC016.1;
        Thu, 28 Jul 2022 10:36:53 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 03cc4cf737a1.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 28 Jul 2022 10:36:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQaVsP2zWneXrkGC0WenV/jzwSH/Qhl54O00EA3RRie3t/rx4f8+ZzjUB6MCyM4ZB9kdPJbdMQLsyYtwq9FcJmbPI23+EoWALWQ6wL5r9C2O0JVHRdDRkV9yctEnEJBjmQP6hBSCZmPoh+AuL5BkcVYkQxwBk0edTEhnVMZEhq0l7xDX4A/xhVId7nI06HpZe5mZRNdJNSU6F3RYDYnGLzXbVZLMxHS44tY2rAZVdX+p/kNZV/nD6M4mSU5gY5HX0VLW6Yz5UlNRr5AoSHDzcUVom+p0GayWuQSdUCTs8tERCSNyLyQ8C4W6OAE/ob/iW9FioqmQAPy4tL9XoQkA9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/s4kWse1BMHTQqhr5HEVUptJYHB4WvzGtRTffyhUPdE=;
 b=YNf20XdEvM3Z3U8ilQCjEjv1Ni2btby02L+a78Z12WBcCsottUUP9BlZhL81fDWSmbh/2KWJm1LgT+zUUHyoqi6JwmEJJ1Pm9hyvRPjuvWUybuB0T4p1NWUsFE+HS3sZyb5P1bSFRLwlXJr+Z6X/7d/zOt4ztgVHcKd5mm66XFdxKQtpVxPy7CLzGfwaDyT+8bII/eDIX51mFK/xNxroDMBrNCc6U5ZTR8DHpHipfUONWfmZ8AZHjLoY2Kg15arSrTArEgaAWa4ed3lKezJTIQ0oyJghul839Hy7Ul1spV38QN9xajLBFB75jKhioxf1DTnt1hjJMIAN4ZWw/2KyYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/s4kWse1BMHTQqhr5HEVUptJYHB4WvzGtRTffyhUPdE=;
 b=Yc82DWwdBrHXkqXQNYcnwwBi9QYEosrG6XqHVCVuHu5ky2v1ne/V2QA4aQq+gmLGgA52Dl1DhL5vzS7QcGPCwxFbc1UX5iGpo5Ne3mFiwlvJtkA8o9ufeQ5wkMFdT8QKqok66dEg1Ggf2cQwqYGWXXJ5MwB1pQFv8Y3jvc5MbHs=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com (2603:10a6:10:2cc::19)
 by VI1PR0801MB1904.eurprd08.prod.outlook.com (2603:10a6:800:81::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Thu, 28 Jul
 2022 10:36:51 +0000
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::7920:5d4b:d11d:d5e4]) by DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::7920:5d4b:d11d:d5e4%3]) with mapi id 15.20.5458.025; Thu, 28 Jul 2022
 10:36:51 +0000
Date:   Thu, 28 Jul 2022 11:36:37 +0100
From:   Szabolcs Nagy <szabolcs.nagy@arm.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Florian Weimer <fweimer@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>, libc-alpha@sourceware.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v6] arc4random: simplify design for better safety
Message-ID: <YuJmtY6agbe2pBSW@arm.com>
References: <20220726190830.1189339-1-Jason@zx2c4.com>
 <20220726195822.1223048-1-Jason@zx2c4.com>
 <YuJlCijOtAXOco6h@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YuJlCijOtAXOco6h@arm.com>
X-ClientProxiedBy: LO4P123CA0282.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::17) To DB9PR08MB7179.eurprd08.prod.outlook.com
 (2603:10a6:10:2cc::19)
MIME-Version: 1.0
X-MS-Office365-Filtering-Correlation-Id: a02569c4-f0aa-488b-0b16-08da70851a64
X-MS-TrafficTypeDiagnostic: VI1PR0801MB1904:EE_|DBAEUR03FT014:EE_|AS8PR08MB7025:EE_
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: LAaqm7cojCPmTqhNv6FgPD2hgrWGCxdv3uh8ThvqnUx/+CK7SBgiPt2v5Glv0ZdWBqccuH5B5m/71LZKr19MFtClt5oJK4wqzuZ71wjSyxn7AnQn4Fv+0JwskkDMHpiRQCw+pN8dGq88YuT4pnyw1F4+PXc6NzLYoWLfMV6s509GWxHQ56IQushL0YeDR53mjI4rqWomk1Jyw6TAW1hqcdDGWHjrJ1oYslV4jN6Zq2+TAyIXNXMejayu5gb+VwspJt70l31EQatR3xg0Zvyyx42nS/89YMhldHqxY1/MWLZCHuhppI7cEBjkDVJJfuovH/TiPcoJzpydt6WQlx6Ba9ssiN2pKVAMlIxmuAMMTvgdZiNKRxuM/vD7/X7AWFUmWMAb2dfssaLz3pOg5H9YxmeAFnrE+9pLffEK3qGeKkMACyIxLBCl3DhwHQ+mqmNleu7UlpmPeA69ivXO6rwOYesbsbN2xdZ5J50pGOVUT3QwqZnIDafk5wwNAhy0i4v4cCvTauNKH0NWe0wYWChdsgmhsZbiXsZbjVHvHo1WEsAUWMnMqPoo/6dDjkcmT5bXIDEaHNsUIB9KuOJZMfeSmJhjxEHwG/kgPFzqjPDji3lpHr5GSB5yLLTzZzQd2vmeFUXePQ8XFHX3nrigtL0USbKcTVlitVWj3iqrDpcuncdXkpXYiH78l9mwlqKm9cmgAY5MBuQZr2QgPubZu01Brq4ciu1NFrqQmj6oHmAcvFE+Vl5qyo2UkzbknM4VBKs6MF3h/ekjAMccuuoGsJpUrCY28HnXOwVt3PuZ2/jhRRg=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR08MB7179.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(366004)(396003)(346002)(6486002)(86362001)(316002)(36756003)(26005)(6666004)(6506007)(41300700001)(38100700002)(478600001)(110136005)(6512007)(2616005)(66556008)(186003)(8936002)(5660300002)(66946007)(66476007)(2906002)(8676002)(4744005)(44832011)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB1904
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DBAEUR03FT014.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 29603e65-383f-406f-9505-08da7085150b
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NrGexAhzBVA9zCvmRNVw6fu78MxG0G0o4CebIX6lXmneCZR2/GWPS4NCShrKSB23dPEY0FqvlLIimfeHenge69nLoPV+l6nkuzZ5eBzXx3ePAG59kuC2GpDX8lCNIIe02r18VqtFznLM23gGfY2MbtUisBBXoK0RUedAgcA8BsuKVPRQPMeyqX32vh1GVfH/gTl2umkmBJbGoneDnOcZh51ommUgdL7LjpodR37QP6Wx008I0vMlo5Taa9BLKvhsTx9/33trgXrbh/EPFaCCJMW1i8bZcJs9UPVq9bz6PUfg+IrM7Er0HkWg5qVpOEWJKtgzjfWm9W0oiJMOfhP5z0HYEMN7OUz+xrbmvfVKX3awrNQEB3988KI8gCQC+61YmHGW/kNWQlUCF/wGKmib4PlmS2Z3IOg5R0dbHB1kPyKfgydQ7PtHecfhtt6Ew53oSYUL7PQuOhrOiGrvG9ycnnJjjIeUCvcU2WWm5/wFzFTS+0KZApyZ4mUUXtHCcX9/cNDauYVBrOG8k97Rz1051JHrJV2CXvRk6xxTR1C0MwfWjvqDbt3QdEV7jicLcrgjMUpwiIQ2FZ52GM3T9QvwydmjGZ1FJdhGH0BQa4qbziMzS1Gmallpo03nH71sLo7tgqhHkmLlqNTrknp63hJ8wTO5GQDukWpb2UOHrY8FGbgLfltmJ+EFDgXcycbgpTwDLoEeJpLqDzodztwxaELj5ts72HcwvtIYffDwfbU0iBWnriPkNfGwzBkncsexnzMqOg2qMnK14YEXAeG7XSs9eauxbskhQuCs5K4kUWfb5nC6hzI0LeDZ/lI4pm2iGd3DEerje1j0KcVXYJG05qakUQ==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(136003)(396003)(376002)(46966006)(36840700001)(40470700004)(36756003)(6512007)(82310400005)(26005)(6666004)(478600001)(6506007)(41300700001)(40480700001)(86362001)(110136005)(316002)(356005)(6486002)(4744005)(36860700001)(81166007)(40460700003)(186003)(47076005)(5660300002)(82740400003)(44832011)(336012)(8936002)(2616005)(70206006)(70586007)(8676002)(2906002)(32563001);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 10:37:00.1915
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a02569c4-f0aa-488b-0b16-08da70851a64
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DBAEUR03FT014.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7025
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The 07/28/2022 11:29, Szabolcs Nagy via Libc-alpha wrote:
> The 07/26/2022 21:58, Jason A. Donenfeld via Libc-alpha wrote:
...
> 
> fyi, after this patch i see
> 
> FAIL: stdlib/tst-arc4random-thread
> 
> with
> 
> $ cat stdlib/tst-arc4random-thread.out
> info: arc4random: minimum of 1750000 blob results expected
> info: arc4random: 1750777 blob results observed
> info: arc4random_buf: minimum of 1750000 blob results expected
> info: arc4random_buf: 1750000 blob results observed
> info: arc4random_uniform: minimum of 1750000 blob results expected
> Timed out: killed the child process
> Termination time: 2022-07-27T14:41:33.766791947
> Last write to standard output: 2022-07-27T14:41:22.522497854
> 
> on an arm and aarch64 builder.
> 
> running it manually it takes >30s to complete.

note that before the patch it was <5s on the same machine.
