Return-Path: <SRS0=/E9c=A4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D138DC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jul 2020 07:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7390B20704
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jul 2020 07:53:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="GZtj9q82"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgGQHxk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Jul 2020 03:53:40 -0400
Received: from mail-am6eur05on2119.outbound.protection.outlook.com ([40.107.22.119]:54188
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726101AbgGQHxj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Jul 2020 03:53:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dxU9Lm/+pIllsmDk5V0fsoRKa3wNZvCi+knE78wgVO3KTgzfrHLneOs/7IS+yaRnh+VapDKn3bXnHxFGlUztLcI88afQKbWL8mzNx8HYoNVDVj1pl0m5NmXrJy91rqHp9r4eSzvxulvwYOcwiR60IUrQcXcFVibcB4h4PuXtH4sVIFkfex1n4Ha8MHOHbMb7nNujV+wM2tuzxx4bWZIJlV5y4dWbpFcNuQyRH6f9lP9R4uXCVDUFmR0wqzn/Ght4malijLT2MEJ6xr1cT7L45JXkOqaK7nc6p247ogNhdu5anxfKX2FJsW+FPS/IjN0ZgD7p8OcPs9EATqRW4W/ELg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iImdz4y8O5ja1RY27OEAr85xM2sSrIOuyy764PcKfdU=;
 b=a3y4OYc2KKpYnyUK/eykW04SEFy6q2lJlwsKba+ZBfd1u1ysRdYYzZOLM1MFZVAjHMdzGrywf0o6FNbUJxb6ooxq0W6JGEQ0XHhIJugnhW2UhXXRyMr8a2cmfsaVszP+onBAaWB7uAS98sEDb7KcBd74wNktn6tFST0epUxFMFYn/g6iXfiJPA4PdtqENAoT0JslHHh5HnQy32Oz3Ebdei+fRVni0Jb946jXCG91LSPlmjNuYeT1zOpvs560PERgNDCF0QMW7gBFqR2FI7KCBzP9nQyOwzrG3VETBRPqaJKL0+0XDD76X9RcJB5CeaoLXrSwvAipnkjz0xd/RAAFxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iImdz4y8O5ja1RY27OEAr85xM2sSrIOuyy764PcKfdU=;
 b=GZtj9q82tfmI0XtZMxwpOTNd4aqNfU9lNIBeyBHjmYVXqzpvmp6kFCkm/CxafPHjx3oLoY2XmP60Lire/LKp6MEZiCj8awzSh7PwTjcyjhl3bOvoOi3kFHDGlmu9s9BEmbaHK3N7JowONqpHjcYW3jeNGO1T1wKm49CQk7Fcb68=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11) by AM0PR05MB6372.eurprd05.prod.outlook.com
 (2603:10a6:208:13d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 17 Jul
 2020 07:53:35 +0000
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39]) by AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39%11]) with mapi id 15.20.3174.027; Fri, 17 Jul
 2020 07:53:35 +0000
Date:   Fri, 17 Jul 2020 09:53:34 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/1] inside-secure irq balance
Message-ID: <20200717075334.vg7nvidds25f5ltb@SvensMacBookAir.hq.voleatech.com>
References: <20200708150844.2626m3pgdo5oidzm@SvensMacBookAir.sven.lan>
 <20200716072133.GA28028@gondor.apana.org.au>
 <CY4PR0401MB3652C2232E0B0A7951B84596C37F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20200716092136.j4xt2s4ogr7murod@SvensMacbookPro.hq.voleatech.com>
 <20200716120420.GA31780@gondor.apana.org.au>
 <20200717050134.dk5naairvhmyyxyu@SvensMacBookAir.sven.lan>
 <20200717052050.GA2045@gondor.apana.org.au>
 <20200717063504.sdmjt75oh2jp7z62@SvensMacBookAir.hq.voleatech.com>
 <20200717065738.GC2504@gondor.apana.org.au>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717065738.GC2504@gondor.apana.org.au>
X-ClientProxiedBy: AM4PR0101CA0081.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::49) To AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.hq.voleatech.com (37.24.174.42) by AM4PR0101CA0081.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17 via Frontend Transport; Fri, 17 Jul 2020 07:53:35 +0000
X-Originating-IP: [37.24.174.42]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 729fadcd-04c3-4bfe-beec-08d82a268227
X-MS-TrafficTypeDiagnostic: AM0PR05MB6372:
X-Microsoft-Antispam-PRVS: <AM0PR05MB6372AC3BAA471FFA40AF4713EF7C0@AM0PR05MB6372.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VQJAcud3WgiT97r890S0YHQ714IFZ6h2szfZgNqbapt/AhrVGATYNR+R180hV/aIYlVBfzNPCtm3ZTDXUcyw3eLiqh7JTSNkCou/nDYX3268xzbulYh/F3Y+zamxCMaHDgpMqdejbeStQG+ebY6e1DrqrWWFAdvX5WvDzI/eDK2OKTLnw9tnrLtEvPxZImIgtbfVc5uVkbOgnzHXhwpoyQ02PlU5QnkKx/M+e10kft3O8a0/51O+ryZzB1RLE5QQOqSuADIoDkU8TpLTLQfYrYWH2RRKg1HUY33JYOnQ43cBfrxctEdoJp6Unh2E+O5aisuz1KEhTaRT2kgBweZDZUqvhboK4xhnzRYr84esV+wMT6s9aEwTDfm+fqmd1mTamd7ombptagn46L2qM7fLTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0501MB2785.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(346002)(376002)(39830400003)(136003)(45080400002)(9686003)(55016002)(44832011)(956004)(186003)(316002)(16526019)(26005)(83080400001)(83380400001)(66556008)(6916009)(508600001)(5660300002)(2906002)(66476007)(8676002)(6506007)(66946007)(54906003)(8936002)(52116002)(966005)(1076003)(86362001)(7696005)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 8ju1CDqd8kZVGDFQVi2SmDyIEAoo5aE4CtFULhy6iC0D+xjG6Z4huXR768e6Q/hRrD8vyyVdeCr6q/xfoDCwrZmgxxvAQH42DW2TpD20wAcCJriOyNajqZlCxSyB+0b3ZoX+lNn+pk+gK5cpNOz9u5AhpOesuvMYNlMryL1xuSfW28Zw8hARuomp/sH5UffS6IEFRdM9qj3tlmcO/fJw/3jFl4tWtiN/noyys3MSDAF/XvU2eC0xptYyb01wKZ+CZN8LKvl4bhlnJlZ7taLJk+PrYMrpwD4c621RXQCJLMrI/0C0rF09uS7Q2FY5fPartGKMWXN5qafzE9z8SvIG9qwOt4bP/jc41yg8Xy9wWcAbyMjrACkAAqbadJ9GngPutzDXsMIX5kF2BMewXf0JtZoQLuJMAQ3pOn9wyp3zP33aekQ1AzrzgRDg/AX3uU8PoGWl5t6f5XiFkNdku+hx5WUkjGpneIJ0uzArzJCZ86I=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 729fadcd-04c3-4bfe-beec-08d82a268227
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0501MB2785.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2020 07:53:35.5730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MIwTIqVDl4hZ9aZAoj9dqMQxYza1PE0tJsHkLjs0tDE9cft52y5y5DtJV7daLPcAZ4Rv24BuiBZvq5Bh20JWxLyRKqu0yfFzkCf81A/e2dw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6372
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 17, 2020 at 04:57:38PM +1000, Herbert Xu wrote:
> On Fri, Jul 17, 2020 at 08:35:04AM +0200, Sven Auhagen wrote:
> >
> > I disagree as this is common practice among other kernel drivers
> > like ethernet.
> > Also this is also beeing done in other crypto drivers not to say
> > that the speed improvements are pretty significant.
> > 
> > irqbalance can of course also do the job but there is no downside
> > of adding the irq hint in the driver.
> 
> If you're going to do this please at least use the function
> cpumask_local_spread.

I do not have access to a numa node inside the inside secure
driver and can only use -1 as the cpumask_local_spread numa node.
Is that what you are looking for?

Best
Sven

> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: https://eur03.safelinks.protection.outlook.com/?url=http:%2F%2Fgondor.apana.org.au%2F~herbert%2F&amp;data=02%7C01%7Csven.auhagen%40voleatech.de%7C11ec864588ea43cb2b5508d82a1eb424%7Cb82a99f679814a7295344d35298f847b%7C0%7C1%7C637305658666145675&amp;sdata=U0TRKq1keey2jogZyelLwvwfSpj4SavJAhumM63phs0%3D&amp;reserved=0
> PGP Key: https://eur03.safelinks.protection.outlook.com/?url=http:%2F%2Fgondor.apana.org.au%2F~herbert%2Fpubkey.txt&amp;data=02%7C01%7Csven.auhagen%40voleatech.de%7C11ec864588ea43cb2b5508d82a1eb424%7Cb82a99f679814a7295344d35298f847b%7C0%7C1%7C637305658666155670&amp;sdata=FDSkrK3t9OMTaA%2FRxMcgKgqU4wVBx%2BomSA%2BUlZtNgBU%3D&amp;reserved=0
