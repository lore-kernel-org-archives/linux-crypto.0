Return-Path: <SRS0=zQvQ=7I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5AADC433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 26 May 2020 05:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95941207ED
	for <linux-crypto@archiver.kernel.org>; Tue, 26 May 2020 05:16:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=silexinside.onmicrosoft.com header.i=@silexinside.onmicrosoft.com header.b="JrdHwNYF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbgEZFQV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 May 2020 01:16:21 -0400
Received: from mail-eopbgr40064.outbound.protection.outlook.com ([40.107.4.64]:8545
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725872AbgEZFQV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 May 2020 01:16:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eZ0qyUdCN5ZiyoXx+d+JpObb9rwozYprswASqVyrgn6YytNxzSJ0Y7LMg3BRYIRcXo/8pUajJ4THj8GPw1JEHNeKC8kVnGrNHHfdIvfqUIcr1eTkHtnOBNhV6wm8fzstn2cCar/kUKDPj6ik2nfwTfegSA+OuTuTMySILKbq/jx7w63UbPEHq53laWgygF0NOXhIQVuxT7VZUlvf+A5ODBKHjSYcqfhkimLjBG+ieThS6C2u+tDIzCRjHaECF8zx53mKW5UCKlNyu6THXeovFTvfh0gFzOUCmaEmoPFdo95lq7wMcjagV0kszL4s/re9sLJBjpm1uN0P659oK3/9Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zl4vs3G+zqTN50rrNJbykIj1Zah2QJSRvXnuj5KDVEA=;
 b=CFR18q+zjBDEWIYLMCXggOxtS+vp7CigS3vx6zfPdSzAF7XznM2jyRXejkWjE44bBd7xRV91cD3OrpTGA0eRLotUzXEF5MMrA/uKudBCUVE4AV+32TMBuZspi2xgJDQk+W32W/e5aeWUrMzAkjUqs/4PtKFNl0iRMzk9m1JQDaBkPGlddivEan8bC9LMlVcIOkT4JjW3suktpqGFEyRW0W2gL3lTvT1qI3Kwl/oWwjyWTxU17OF1HvDhWUkSwDmrc+r18CF4nMRBgMobDv5QXU/LYs38+XBDcID8OXeojT69OomoM41pfcQZuuZ1x44/ZPHt9gF/dSchUaa9qirqjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silexinsight.com; dmarc=pass action=none
 header.from=silexinsight.com; dkim=pass header.d=silexinsight.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silexinside.onmicrosoft.com; s=selector2-silexinside-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zl4vs3G+zqTN50rrNJbykIj1Zah2QJSRvXnuj5KDVEA=;
 b=JrdHwNYF7Ud8HlaqYYiojTOCNxj2vpN0J68viBxMkcSeBDEWVYfigcX6oTRzpn9J4IK7TDpRw/G2YBljSQkq/m/S5bXQpjfjcKi6pqeDni/O/AavNGsaJ8nmoVfiUJcSPGtAVuR8+GQ/jloOi2b63US56bIpwIf5u6PYhWtfDQM=
Authentication-Results: arndb.de; dkim=none (message not signed)
 header.d=none;arndb.de; dmarc=none action=none header.from=silexinsight.com;
Received: from AM7PR09MB3621.eurprd09.prod.outlook.com (2603:10a6:20b:10d::15)
 by AM7PR09MB3591.eurprd09.prod.outlook.com (2603:10a6:20b:10a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Tue, 26 May
 2020 05:16:16 +0000
Received: from AM7PR09MB3621.eurprd09.prod.outlook.com
 ([fe80::e902:acdf:8750:e9e2]) by AM7PR09MB3621.eurprd09.prod.outlook.com
 ([fe80::e902:acdf:8750:e9e2%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 05:16:15 +0000
Date:   Tue, 26 May 2020 07:16:14 +0200
From:   Olivier Sobrie <olivier.sobrie@silexinsight.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, DTML <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Waleed Ziad <waleed94ziad@gmail.com>,
        sebastien.rabou@silexinsight.com
Subject: Re: [PATCH 3/3] hwrng: ba431-rng: add support for BA431 hwrng
Message-ID: <20200526051614.GA3026333@ultraoso.localdomain>
References: <20200525195606.2941649-1-olivier.sobrie@silexinsight.com>
 <20200525195606.2941649-4-olivier.sobrie@silexinsight.com>
 <CAK8P3a3=HoQZuBoqyFgyde1X7BRfcH-GFQpu=8acOi_JhVU99g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a3=HoQZuBoqyFgyde1X7BRfcH-GFQpu=8acOi_JhVU99g@mail.gmail.com>
X-ClientProxiedBy: AM4PR05CA0013.eurprd05.prod.outlook.com (2603:10a6:205::26)
 To AM7PR09MB3621.eurprd09.prod.outlook.com (2603:10a6:20b:10d::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a02:a03f:a7df:f300:dd33:e48a:b6bd:b57f) by AM4PR05CA0013.eurprd05.prod.outlook.com (2603:10a6:205::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Tue, 26 May 2020 05:16:15 +0000
X-Originating-IP: [2a02:a03f:a7df:f300:dd33:e48a:b6bd:b57f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d781c4e3-88c1-43d0-19f8-08d80133ea34
X-MS-TrafficTypeDiagnostic: AM7PR09MB3591:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR09MB35918C3ABA259972D3A6AEB9F4B00@AM7PR09MB3591.eurprd09.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oeBNMQuVC3nsTyWTQjEBE5LTsE+pApkws1sSzzbgk8C4hZ9ezoYAbrf06ZuAQEplPTOxpfNe/KjNiE57/FLcdMtpE6ngBYrbIImz9qe8lcNsTR5N/9NnSDNH/1Z0EwCO5Du71fPFZgTX9gkUz5Wip7E28dzBt1xgYacAciiC9tXwpgy6TRMfgxuarNkBK66SrzKt+S6dCBJpU73aq+kTLK3pE/hOkdOP00fwiVCpPoULepp5FxBlO3SyE7sfYSAv4pe8ub5CkxaN6x/nB59SxwOaNY8THk2H7eKQiQ+kQ21vv6k6mDMYsU5M1g8Ktf7AaU+stnSQCY7DFxiK0DslpSo+W9IZPigeZSsmf1+NNoPV9UBALMCLO3jtDNgvvGe/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR09MB3621.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(366004)(376002)(396003)(39830400003)(136003)(66946007)(52116002)(9686003)(6496006)(6486002)(2906002)(1076003)(107886003)(4326008)(53546011)(316002)(6916009)(186003)(33656002)(16526019)(86362001)(8676002)(8936002)(44832011)(54906003)(66476007)(508600001)(5660300002)(66556008)(17423001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VuYl5HfOp+Ta+bw+qKOKN+1Zb1Ui9RRcL6OWgg9EQKp9SUWJpmqvcAg5VVvnelJCd0bYvnCzPyoAQgaKDR88k0ekqDKzan0LvBTq6fx77BNSBI79lX2/pBay0wE+YxyzyA57Ry9Yz2zHU/ekMub/bzYOHRMINkIiQre/cbn1xlpm5YZE6KMpxqW/nwyK0lS6vqFJfHV+lP1nq3nN0gW2MtZygh9Q4GHzTAk/aESxKHaz/oSBYzbrAJqA1ku73xW2z79LuuQr7vUY15Imt/bCbZlA2KIs8dWeVQEC61tGwb9DVlN+UF5QHrjqGQ+MUDWuXt2iHzEkQIEGD2FzqZ5v6cf5aDhUQD2ExeyJb7JE9Yelq/v4X5l+4itI+oo65Cab9359KjnTcM4CIqoChbMfaZz4zWoAtdaPWZLIR8yAxZIBhSeebYVh9o4gY25X+LhZiis69/s7Id955BLivJslyCjfMwgdtdZ/2rHthmwoK2pxLsKk+4qv/q7OE8gA/SI4ifHu2bllHTsDj7d/xwt0dVaoY32THxovqPrcD7JeXFKHzer4HdBGJuLXfsI0Jl9c
X-OriginatorOrg: silexinsight.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d781c4e3-88c1-43d0-19f8-08d80133ea34
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 05:16:15.8601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a02f6f9b-0f64-4420-b881-fca545d421d8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 09uWuZx8koP9zP6WXXRZOmNCKhbzugluHEnQZS3I297ixQVBog6fdc6aUIy8mZdHuoD+Ai2Bi5uoFRQArb6VwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR09MB3591
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 25, 2020 at 10:28:46PM +0200, Arnd Bergmann wrote:
> On Mon, May 25, 2020 at 10:07 PM Olivier Sobrie
> <olivier.sobrie@silexinsight.com> wrote:
> >
> > Silex insight BA431 is an IP designed to generate random numbers that
> > can be integrated in various FPGA.
> > This driver adds support for it through the hwrng interface.
> >
> > This driver is used in Silex Insight Viper OEM boards.
> >
> > Signed-off-by: Olivier Sobrie <olivier.sobrie@silexinsight.com>
> > Signed-off-by: Waleed Ziad <waleed94ziad@gmail.com>
> 
> The driver looks good to me.
> 
> Acked-by: Arnd Bergmann  <arnd@arndb.de>
> 
> >  drivers/char/hw_random/Kconfig     |  10 ++
> >  drivers/char/hw_random/Makefile    |   1 +
> >  drivers/char/hw_random/ba431-rng.c | 240 +++++++++++++++++++++++++++++
> 
> I wonder if we should move drivers/char/hw_random to its own top-level drivers
> subsystem outside of drivers/char. It seems to be growing steadily and is larger
> than a lot of other subsystems with currently 34 drivers in there.
> 
> Not your problem though.
> 
> > +       /* Wait until the state changed */
> > +       for (i = 0; i < BA431_RESET_READ_STATUS_RETRIES; ++i) {
> > +               state = ba431_trng_get_state(ba431);
> > +               if (state >= BA431_STATE_STARTUP)
> > +                       break;
> > +
> > +               udelay(BA431_RESET_READ_STATUS_INTERVAL);
> > +       }
> 
> Looking for something to improve, I noticed that this loop can take over
> a millisecond to time out, and it always runs in non-atomic context.
> It may be better to use usleep_range() than udelay().

Ok I'll change that and send a v2 later this week.

Thank you,

Olivier
