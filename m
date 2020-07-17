Return-Path: <SRS0=/E9c=A4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C724AC433E8
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jul 2020 05:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6375C20684
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jul 2020 05:01:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="EdQoDfh4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgGQFBm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Jul 2020 01:01:42 -0400
Received: from mail-eopbgr70105.outbound.protection.outlook.com ([40.107.7.105]:49795
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725811AbgGQFBk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Jul 2020 01:01:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NveI/2UtiMVVChMzFCJR8R/BrFvRDYKCuz5RzHp5GXP4iW0q8EOers+TdOQFBdn0j/x/wGN0Qibk9MO6MwQ7RnETrlhKsDUVClT+cGzmKlEYWJIHtrW1JD+JMEZqexR2z0vtbJPcBZGSv1nJgiE7SiwRHDpNS+HtQV7a2pV7zNFc1/Y5rd+oune4oGvzxR39VTWW1yiKcz5WMWBNYvgIUaWAZfmWkmyILflGLh2zrR+UUeO3ZBOwpHnXAebFWdB6LRb6BlBhLo9XaTLISLLhW9kSbPUFhzDeFVpYlhNzwV9v+ewMoQ5RpDHNVmdjS7H4LIh4QbJBWWEVXHD6BMf33g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+GU1cA4ySkNeInCS4t9PBR/ZK3bF9Ao8zGMqVIPPGU=;
 b=YY1IvKxl3wEfybLjLtvqpNrMesTkBpqSU5KuWRSpz2MqiNyZrG8pUZOQiRT4rXW+L3vXO8NHqxioBcQPzELBgyPnVvtMxDzljz+SycBKc+bT5Jj59Eto0/nYTVfkNqofy26TgPvFJGA72ykcrHi7ysASO4tJnC0gjxfimKZmf9H2honukZbHSDbxS1jD8S65DvdHRs4p0EuCqNzH0G0NqvQ4tsZqKYUUpi7nW3oOd9M7N2d5K2oBLPbqGWWRpJ2QiSRhrg0QSHlIh1DrPZWAH1pI09+4BXPEa+rrbnOmQDy1Jk2DmWErxZFPzVxEDjFea57btUAk8eruV/QquRu0ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+GU1cA4ySkNeInCS4t9PBR/ZK3bF9Ao8zGMqVIPPGU=;
 b=EdQoDfh4lUE5f/BrOw4v44GH5ncRA3cNppOJFElJNGvqTTYxZT0WYzuk8HDKoBxx1FLKE3K/2QOV7oNnJGIjMiioR7PQnl/XERfyHdgyZtJpUOjCPph6sv1zEcn1jvBkKx6bTppV4ykO3zEyzdu0R8D8hjh4kLQnCMiewE/VI9o=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11) by AM4PR05MB3396.eurprd05.prod.outlook.com
 (2603:10a6:205:5::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.23; Fri, 17 Jul
 2020 05:01:35 +0000
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39]) by AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39%11]) with mapi id 15.20.3174.027; Fri, 17 Jul
 2020 05:01:35 +0000
Date:   Fri, 17 Jul 2020 07:01:34 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/1] inside-secure irq balance
Message-ID: <20200717050134.dk5naairvhmyyxyu@SvensMacBookAir.sven.lan>
References: <20200708150844.2626m3pgdo5oidzm@SvensMacBookAir.sven.lan>
 <20200716072133.GA28028@gondor.apana.org.au>
 <CY4PR0401MB3652C2232E0B0A7951B84596C37F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20200716092136.j4xt2s4ogr7murod@SvensMacbookPro.hq.voleatech.com>
 <20200716120420.GA31780@gondor.apana.org.au>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716120420.GA31780@gondor.apana.org.au>
X-ClientProxiedBy: AM0PR03CA0086.eurprd03.prod.outlook.com
 (2603:10a6:208:69::27) To AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.sven.lan (109.193.235.168) by AM0PR03CA0086.eurprd03.prod.outlook.com (2603:10a6:208:69::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Fri, 17 Jul 2020 05:01:35 +0000
X-Originating-IP: [109.193.235.168]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d26d186e-77f3-46ab-fc17-08d82a0e7b03
X-MS-TrafficTypeDiagnostic: AM4PR05MB3396:
X-Microsoft-Antispam-PRVS: <AM4PR05MB3396C327F062CDDAF30191D3EF7C0@AM4PR05MB3396.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K4uw2bBFvpzRQjHWCHXl013hiYrzKeZ3M8M5twfDfVkShHuYkGody2fG7JyKQP/Fd2wQmVqTfoJtVh/L1naWKDuPCT796ePIrxGy37iUYAeOviytZmh1WQWMIvzu7WSeh449edfuZrigAbau98Xu1gt6HbXnduQsWbT9JdahLblEk1JR9TnlstmQjB7+qEQCvN14FNWhXpJSUOhQ89/bPE++ZZEOXiSlhajwzbOZh7EmuGMxCTrlSCjYabIqEDP5W9pvf8G9MEZEB84uukcq8vbD2ShvQnLDAC768heJuZTlZbXhyS9bVkVLJXvgpZ/n98fMypUW52/DpQoyQf92ykNG+TVRY37kXBIm20M/CXaj3WBPGqcGikTmuMCkHWE6UVURgZiSBJpspmgvC1+cOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0501MB2785.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(346002)(366004)(396003)(39830400003)(83080400001)(316002)(7696005)(86362001)(52116002)(44832011)(26005)(9686003)(54906003)(55016002)(45080400002)(966005)(508600001)(956004)(6506007)(4326008)(16526019)(66946007)(6916009)(1076003)(2906002)(66476007)(186003)(8676002)(8936002)(66556008)(5660300002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: LO7pnNich7OTq/8/Px/y/fwsJ4LD2LOQVrTZfLnTzfN+gvW64VtQpXlDjDr84SrBSvwhwh1kYgvEY1UbBCsHkKTtw/xXvg1PE9Wu/b2UKJwsPA2QIC0379UyLun+Yxufvfcx01/AslAGxDYh6G0xWoGNl7M/ebgx8avfmXFf7KwaX9/dX2CsV4uw9+palTzB2ScnmyPxKwW0PgNFEK0Cw4kohPUTxTUPBSssMACj4ifJu43pYQKVCtrQCMyxZZWMioigUcjPgwL3cekVLyZd+KS/tKjZDW2SviylB77+RHfMa72w+mpfALbxGHyIypLLSCAlhVF7S9q9BLQvqwzS6NjK3haG6zXAzmpiWQfmJOvgvthpgeMK0tkdu4oZFlpMFAcl/+eaw0V39maIbdIRqOmHYU5XfRjvfjxXddb+qFEcsvQAyOTYMHuV7WOBkScVfBoGsxUajQTfzf0doIoOpAJK9oqS+r0cl3TVDnYV82NyKLwJEKgj7uYD3dYr1axH
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: d26d186e-77f3-46ab-fc17-08d82a0e7b03
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0501MB2785.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2020 05:01:35.6751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lkY6WfY6X+qYRaF6WY/3UTMvrGBZcuHir0jTVeb+dZQBxeWR0o1PK8AfMx6BcGybssiQ20gMx8/sXuWz5y+lILqIcs/cehkduL1JX02T8ZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3396
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 16, 2020 at 10:04:20PM +1000, Herbert Xu wrote:
> On Thu, Jul 16, 2020 at 11:21:36AM +0200, Sven Auhagen wrote:
> >
> > You are correct, let me have a look at how to get the cpu bit correctly.
> > Well everything runs on the first CPU now, what do you do if that does down or up?
> > I think there is no mechanism in general at the moment for the current or my implementation.
> 
> Unless the driver changed it the default affinity should be all
> CPUs, no? In which case if the first CPU goes down it'll just move
> to the second CPU.

Alright, that makes sense, thank you.

As I said in my second email yesterday, it is just a hint and not binding.
I run some tests and here is what happens when I disable CPU3 on my 4 Core MCBin:

[641628.819934] crypto-safexcel f2800000.crypto: EIP197:241(0,1,4,4)-HIA:230(2,6,6),PE:133/332,alg:7ffdf000
[641628.823954] crypto-safexcel f2800000.crypto: TRC init: 15360d,80a (48r,256h)
[641628.825326] crypto-safexcel f2800000.crypto: firmware: direct-loading firmware inside-secure/eip197b/ifpp.bin
[641628.825693] crypto-safexcel f2800000.crypto: firmware: direct-loading firmware inside-secure/eip197b/ipue.bin
[641629.033302] alg: No test for authenc(hmac(sha224),cbc(aes)) (safexcel-authenc-hmac-sha224-cbc-aes)
[641629.044442] alg: No test for authenc(hmac(sha384),cbc(aes)) (safexcel-authenc-hmac-sha384-cbc-aes)
[641629.057356] alg: No test for authenc(hmac(sha224),rfc3686(ctr(aes))) (safexcel-authenc-hmac-sha224-ctr-aes)
[641698.795895] IRQ 38: no longer affine to CPU3
[641698.795917] IRQ 54: no longer affine to CPU3
[641698.795928] IRQ 59: no longer affine to CPU3
[641698.795942] IRQ69: set affinity failed(-22).
[641698.795950] IRQ70: set affinity failed(-22).
[641698.795959] IRQ73: set affinity failed(-22).
[641698.795969] IRQ 77: no longer affine to CPU3
[641698.796131] CPU3: shutdown
[641698.796156] psci: CPU3 killed (polled 0 ms)

74:       1363          0          0   ICU-NSR  88 Level     f2800000.crypto
75:          0       1772          0   ICU-NSR  89 Level     f2800000.crypto
76:          0          0       1427   ICU-NSR  90 Level     f2800000.crypto
77:          0          0          0   ICU-NSR  91 Level     f2800000.crypto

IRQ 77 was bound to CPU3 via the hint is no longer affine now
and actually bound to CPU0.

When I disable CPU1 and CPU3 and load the module I get:

74:       4089          0   ICU-NSR  88 Level     f2800000.crypto
75:       1772          0   ICU-NSR  89 Level     f2800000.crypto
76:       1427       2854   ICU-NSR  90 Level     f2800000.crypto
77:       2824          0   ICU-NSR  91 Level     f2800000.crypto

where you can see that the affinity hint is ignored for CPU1
which is selected because of number of cpus online is 2 now.

Does that answer your question?

Best
Sven
> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: https://eur03.safelinks.protection.outlook.com/?url=http:%2F%2Fgondor.apana.org.au%2F~herbert%2F&amp;data=02%7C01%7Csven.auhagen%40voleatech.de%7C0790b23c7a61493c8bfe08d82980621d%7Cb82a99f679814a7295344d35298f847b%7C0%7C1%7C637304978692090806&amp;sdata=QZUqtMuwN8vOxUK1tjFiENuwPD6gIxHpTvntLdbqTqg%3D&amp;reserved=0
> PGP Key: https://eur03.safelinks.protection.outlook.com/?url=http:%2F%2Fgondor.apana.org.au%2F~herbert%2Fpubkey.txt&amp;data=02%7C01%7Csven.auhagen%40voleatech.de%7C0790b23c7a61493c8bfe08d82980621d%7Cb82a99f679814a7295344d35298f847b%7C0%7C1%7C637304978692090806&amp;sdata=Z3GYc1YWWeenCLYZUKXxzwWDQnrmvEuBHStIcPFcOp0%3D&amp;reserved=0
