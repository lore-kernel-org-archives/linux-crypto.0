Return-Path: <SRS0=/E9c=A4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30841C433E2
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jul 2020 06:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4DE62071A
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jul 2020 06:35:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="gVk20ptY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgGQGfJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Jul 2020 02:35:09 -0400
Received: from mail-am6eur05on2119.outbound.protection.outlook.com ([40.107.22.119]:45824
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726141AbgGQGfI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Jul 2020 02:35:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C1u+5Nm2tKgcDs1bWRP3cFioKBjR3D48OgriLXM8xBs5nNRYV/8XdqtGZ3+YgyuTZR+uRPZJi+2WdYKyq0cSrFbxJt9IMXPdcKgQgqczfPbNZzL7ZZ4+0PRnrjxZ9e/ieqnQEYQ6QDYMalXjV2zFW9hawidHaWGNxxARlA4MXSP8b3Iumv6xNmB1Fiso7NgYUfaVfJ/hJghze3juSY/jvaJRYFQclhCNzi6kBi7499rxJ26wL73wpMR/yy3+I6c33AaxbfT/fdyJwPTHQve6TkORGGooIMBLpTtzapoSIST/MsWNWcQe5gDOz3PBhEoW9l3w5WWtNvrtLU/jgwwxPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/1FxIkmPd7WXxgbOU8u1skX6n9OkSsx0Z7PINYR0pEs=;
 b=aPGC92IJBWGRxsyFkS4ZKL8o/Y7dQPRgRlannweute4Iosj4P6D79ebMBSmQ/LvMw5bh9dUHpSaLFb2HsYig/Ohz8tQUGKp86ZLAMPjHdGHezZdLAtvJPhH/d/FLR+cfKcRKYpf29kCi4N2I/8TM2Cl0Rf0WqlphxSybTTGz/8YRkQVd9nTiMPbe+GqvsuI815FF0atJWgKqhMhREBlAHw3IBGM1v0kPkNNEADmoGO1XTYY9f0kl9fMq9jAhz6yc5f96HrmflvH2KehX9W1kzhSjllCruFAXqjmdRC+FcBZDowvZMXAj3QnaRjGm7wNeeuUgZR0Q89dvtdxwgcrO9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/1FxIkmPd7WXxgbOU8u1skX6n9OkSsx0Z7PINYR0pEs=;
 b=gVk20ptYJL6CCBnU34eQCibCDIvffDilX3/UQhZbvW7xbib79GMFmTAGYF5wudcpKlERbpPQraM3EcmT4sj+Gy7v+37RKUE5VcUh5yFBNI5T95vRE72zRje2VvABNN2A2I1WYrrdvnjwje03MKrP6SgpAkRffX7bQ/yohxtt060=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11) by AM0PR05MB4722.eurprd05.prod.outlook.com
 (2603:10a6:208:b8::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.24; Fri, 17 Jul
 2020 06:35:05 +0000
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39]) by AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39%11]) with mapi id 15.20.3174.027; Fri, 17 Jul
 2020 06:35:05 +0000
Date:   Fri, 17 Jul 2020 08:35:04 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/1] inside-secure irq balance
Message-ID: <20200717063504.sdmjt75oh2jp7z62@SvensMacBookAir.hq.voleatech.com>
References: <20200708150844.2626m3pgdo5oidzm@SvensMacBookAir.sven.lan>
 <20200716072133.GA28028@gondor.apana.org.au>
 <CY4PR0401MB3652C2232E0B0A7951B84596C37F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20200716092136.j4xt2s4ogr7murod@SvensMacbookPro.hq.voleatech.com>
 <20200716120420.GA31780@gondor.apana.org.au>
 <20200717050134.dk5naairvhmyyxyu@SvensMacBookAir.sven.lan>
 <20200717052050.GA2045@gondor.apana.org.au>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717052050.GA2045@gondor.apana.org.au>
X-ClientProxiedBy: AM0PR03CA0093.eurprd03.prod.outlook.com
 (2603:10a6:208:69::34) To AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.hq.voleatech.com (37.24.174.42) by AM0PR03CA0093.eurprd03.prod.outlook.com (2603:10a6:208:69::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Fri, 17 Jul 2020 06:35:04 +0000
X-Originating-IP: [37.24.174.42]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 179cab0a-a31e-41f6-dac9-08d82a1b8a9d
X-MS-TrafficTypeDiagnostic: AM0PR05MB4722:
X-Microsoft-Antispam-PRVS: <AM0PR05MB47228D551148B1CDDA7002ACEF7C0@AM0PR05MB4722.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FX65HXdGDXWOgjREdH8TLrEdr/anRKckCw9CpNa+v3XfdryqQ+TUVuk29iRQL/4zF7+5bcNdysGr/UShIwqXk+VtFvdX1bE/z7hAseX+qEo1oi3myGRyW2rj4tzopbf1utcMgGjDIFwoVN+8N13HsG04hYAtJGrRByl73DzKGieBpuJJ+g6reJftme9qPrer6/Nnv6ak/YlelSBYKPWTeUMnB6pDOkclLQ/QVkJ9K4HQs8z8/mtVuCB4392gFMELs6IqHZhyHg49qoTxyIFlPkF38fWIYrzTbMZKnWBIkj1kaBCQlIivSPbeXyPmiPk1K6drPWlaUStyRShwYoNIEP3HV0l3fTEBupnjiSqAcGyyzCM8qBFVlX1zEcsJpfVNJvkSt9wiWzY2yid0aLAkwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0501MB2785.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39830400003)(396003)(376002)(346002)(136003)(7696005)(8676002)(54906003)(52116002)(508600001)(1076003)(16526019)(186003)(966005)(9686003)(44832011)(2906002)(8936002)(4326008)(55016002)(66946007)(6506007)(956004)(6916009)(83080400001)(316002)(26005)(66476007)(5660300002)(45080400002)(66556008)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: gP0dABOWdQoG6jEPiDYQKcNkavKrrZ3Ucfeuu6/vfi2lt9HVFXPwgVQhnFbNQBSwElg7ROAHlZ/Awc3gl8ZB5EANYpg+ESYmpWYTQPdFu8pRsEH4iKvLFXZ52D9lgdmpiMM64JndKrsVusBAfXbjFYT8/83DhVrZrefZPPDwe3NVG8Q12gkIU4x2I4WEnrNZKCtnX40IJvq4SL3XFqjmJNRdr9mumRrP0xmFEye+tByuZaPb8/pzANJXw26jgOhk5MR5hyorkIz1BT8z/l8iry+C3qcN4YKDOueG8jVSNrXxXa5DY3zKq5weKjuLDuRevvOm+g7eY/oZE0oyrJi0BkXoIMUwwj0pS4xjTXKQv4GrnIourV/q0p4ei/bLhJ8K92JNVS6HER10ev1n3naxKmDxYa3fXjYOp077AYkRwwO1p3VDNEaBcX7+m0QgFIZatM9WWZXGoielIzzKd3hg4xoiBuYm5FkeN9ELX9/f6hY=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 179cab0a-a31e-41f6-dac9-08d82a1b8a9d
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0501MB2785.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2020 06:35:05.3008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Kqo5Y7eJPuA4Cpjuzi+GetNjZJq9EmTrR/jely9shQSF1y0ocGPkhaRW1JyMNidM4xoCQ3fd9ADzTiglhJmqJEy/DF0Ku6PtYHaeikGsPc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4722
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 17, 2020 at 03:20:50PM +1000, Herbert Xu wrote:
> On Fri, Jul 17, 2020 at 07:01:34AM +0200, Sven Auhagen wrote:
> >
> > Alright, that makes sense, thank you.
> > 
> > As I said in my second email yesterday, it is just a hint and not binding.
> > I run some tests and here is what happens when I disable CPU3 on my 4 Core MCBin:
> 
> I don't think we should be adding policy logic like this into
> individual drivers.  If the kernel should be doing this at all
> it should be done in the IRQ layer.  The alternative is to do
> it in user-space through irqbalance.

I disagree as this is common practice among other kernel drivers
like ethernet.
Also this is also beeing done in other crypto drivers not to say
that the speed improvements are pretty significant.

irqbalance can of course also do the job but there is no downside
of adding the irq hint in the driver.

Best
Sven

> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: https://eur03.safelinks.protection.outlook.com/?url=http:%2F%2Fgondor.apana.org.au%2F~herbert%2F&amp;data=02%7C01%7Csven.auhagen%40voleatech.de%7C85a3fd0bef964ac07a1d08d82a112f12%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C637305600595365880&amp;sdata=E%2FnccG%2FNnIivbW0A2mE%2B9k89tWEWA%2B%2FcljshtLi29TI%3D&amp;reserved=0
> PGP Key: https://eur03.safelinks.protection.outlook.com/?url=http:%2F%2Fgondor.apana.org.au%2F~herbert%2Fpubkey.txt&amp;data=02%7C01%7Csven.auhagen%40voleatech.de%7C85a3fd0bef964ac07a1d08d82a112f12%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C637305600595365880&amp;sdata=e3f%2FXrlr0k9c1Cdv5kBo6zp5gtkPtkBNMNTJhB2Dg8c%3D&amp;reserved=0
