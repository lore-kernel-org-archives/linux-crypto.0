Return-Path: <SRS0=I3Dt=5C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C31C10F29
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 15:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B41F020753
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 15:20:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="EiYqybCP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgCQPUf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Mar 2020 11:20:35 -0400
Received: from mail-eopbgr30084.outbound.protection.outlook.com ([40.107.3.84]:54862
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726112AbgCQPUe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Mar 2020 11:20:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kWGhleVQKixQjRIlLP7Zl6xdKs700J+XwSIIj+bkTf2dwi3rrWVRZflhsUPMGRXVFeMjMhmeVoOf0munXwC568EZHrDQTqhy5bu74xsW3ZYG0Od/bE1SWd1LmqQOdK1FI9ETcTNIsNIeY6MXOMm+0dVNgYEHQu7HUn7Ff/DV4mRxi5y2KKKmmJxUGQApHFLAZWu5QWZy38Z/oGoKytXmTzP44yosszUoTfgH2eMEaRMhmK8t/03LWqZz0v5aG72azpcJk9Z+1gv7zr+nez/MXJTLZED1XIVsGH7dd1h/JaL6j9fKJjUmB92cWNjTl0bdx3fHE2oeHCps6lASTbU46A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FA+yvm5/VeCBm7iaBf9sK2VCaUk/AG6zRNlxLqGc0Tc=;
 b=UkoOguopL82cwgiIpq0B8rMtJX/XnywrOY2Ofx2UjkRrpul9dmDlCpdJJtTgqnLiBmBYJXlcvPAj5+UvCoTKL5BxwyTFDQYknroz+S9cK5aKmJuqmZoiDc9Gi9IOUDGLtGSeYbr6Hi1BCDVhgBevm4vcC87c0aGpJLxFMYuUl6aVIiD4ghtTny2gPJN1R5I4geuO2o8lieuCSGY1oOprqbOxMlUaDMKOqplN/V/IcPrUJnT8tLhtBNsf/Lna7BWSz9pdFv9kDssI7ux7AUaGfHZ4ihb0J+awSBZqtrmVDrrdcP1eZvunbWxjvQFB20OZpFMoanc8+6qcnO+3U5wMEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FA+yvm5/VeCBm7iaBf9sK2VCaUk/AG6zRNlxLqGc0Tc=;
 b=EiYqybCPl9WCAwqjb+0HpI7QLLTzJbCKHvMyYBcnoTws66rv6BD5ypKHWpS9HGnz3wAKgnIN/OinHlICgA/3mB+GDCFEr+YCorm2dOQKkU3u3ytrLNEJS+4ZuPx/k+fgh3wl9zf5icYp+JtoH2lulq33GKg8HH/aYZXyJSNR0xk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3582.eurprd04.prod.outlook.com (52.134.4.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Tue, 17 Mar 2020 15:20:29 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f%7]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 15:20:29 +0000
Subject: Re: [PATCH v7 1/9] crypto: caam - allocate RNG instantiation
 descriptor with GFP_DMA
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200127165646.19806-1-andrew.smirnov@gmail.com>
 <20200127165646.19806-2-andrew.smirnov@gmail.com>
 <VI1PR0402MB3485FF5402B8C0FFF48FBF2298030@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAHQ1cqGZP5RKTsc4+jikyPVggt-mGViRtKNvyOx9FGkYW9pgmg@mail.gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <ce541b0c-7ddb-ed4d-9529-c1d48a38b6a6@nxp.com>
Date:   Tue, 17 Mar 2020 17:20:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <CAHQ1cqGZP5RKTsc4+jikyPVggt-mGViRtKNvyOx9FGkYW9pgmg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0044.eurprd02.prod.outlook.com
 (2603:10a6:208:d2::21) To VI1PR0402MB3485.eurprd04.prod.outlook.com
 (2603:10a6:803:7::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR02CA0044.eurprd02.prod.outlook.com (2603:10a6:208:d2::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.22 via Frontend Transport; Tue, 17 Mar 2020 15:20:27 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4acfeacd-3358-4a30-766f-08d7ca86b9c9
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3582:|VI1PR0402MB3582:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3582F0186EFF5FA0AE21290098F60@VI1PR0402MB3582.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(199004)(2906002)(31696002)(31686004)(8676002)(81166006)(5660300002)(52116002)(81156014)(86362001)(8936002)(53546011)(66556008)(36756003)(66476007)(316002)(66946007)(54906003)(6486002)(956004)(966005)(2616005)(6916009)(186003)(26005)(4326008)(478600001)(16526019)(16576012);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3582;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XHJGji+0oO9jsz/EFsFluvHiYek4cMhYevOjbRDfCNs2PSir1wpaUcIfnBL3vEQG3x2mvJ6GVnAoAmWnZS04rKlv3EYL0jGSZac7F8BCSygFoKoxPiqJvIW8h+h7v+oZ7+xtYP83+14oSN66Inm4TdT2GPlnbTdbhkN1/YAq/JVCOwQ6KffDRYHa1X0Tg5J7ID6hegn6rt76+Blcife/vYSZPfUB/yk/GYeGY4VgnPdi11Rcap/1brE145qBRWZoRALfO325/BgByJQZ7cuSZ/ixWWHuXl3cAQ2fixXEo0l4fCIkvB68ReCX/DTc+2enFHSHln7BULKKMzG7ap+uReThWzTi6iTZU3dQJNT0HfATzEQ+fY/IB+G9JW781mc/5MPDLFny6e3ldsRDRLeqomrJ5cpugyLUEqlLs780xmxNhw62BORO+tvGWJz9ImANtFCMraaTLmDPubQ7/CoHCwTbbCsdyU8YZ4J8PTpvH/Db0HWowOSyl4eoUweeY80NM0dlDJlM70JWjnYDckcm1A==
X-MS-Exchange-AntiSpam-MessageData: a3D6FVQzAYitnCb6XhI2/ltgMnh1UYCz1qcJsy77sr1UyruV9z8HLDYl8fzmqCwG/UHgy7TxpYj5+pqloX7347estsC+3ZEkR2f9XDaktsqV7GfXOO2qb9DpZfDjKqW8owDoxZySC2dH1wzWZId2oQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4acfeacd-3358-4a30-766f-08d7ca86b9c9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2020 15:20:29.3007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F3cqS6p3gBhmLKBtYui6fmQbdjqfpW7DCoCefUnutQafMyM0mqReTOMx7NqNeiyAlFOXDsLj2sw/2I6J4GqD6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3582
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/16/2020 6:15 AM, Andrey Smirnov wrote:
> On Tue, Feb 4, 2020 at 6:08 AM Horia Geanta <horia.geanta@nxp.com> wrote:
>>
>> On 1/27/2020 6:57 PM, Andrey Smirnov wrote:
>>> Be consistent with the rest of the codebase and use GFP_DMA when
>>> allocating memory for a CAAM JR descriptor.
>>>
>> Please use GFP_DMA32 instead.
>> Device is not limited to less than 32 bits of addressing
>> in any of its incarnations.
>>
>> s/GFP_DMA/GFP_DMA32 should be performed throughout caam driver.
>> (But of course, I wouldn't include this change in current patch series).
>>
> 
> Hmm, I am triggering
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/mm/slub.c?h=v5.6-rc6#n1721
> by using GFP_DMA32. AFAICT, GFP_DMA32 can't be used in SLUB/SLAB
> allocated memory:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/mm/internal.h?h=v5.6-rc6#n32
> 
Indeed.

> I'll stick with GFP_DMA for now, unless you have a different preference.
> 
I'm ok with this, will deal with memory allocation separately.

Thanks,
Horia
