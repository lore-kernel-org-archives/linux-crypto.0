Return-Path: <SRS0=WfFd=5F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C08C4332B
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Mar 2020 16:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6126C20739
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Mar 2020 16:13:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="oIru/qRU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgCTQNZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Mar 2020 12:13:25 -0400
Received: from mail-am6eur05on2057.outbound.protection.outlook.com ([40.107.22.57]:19488
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727267AbgCTQNZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Mar 2020 12:13:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cSIFerIukDz5JUe7JXObZxR+O/H99hsFr2nyo1PgO/tbPSUWWOIbqiYNQqXMxLtHb4/ba076E3ViMfuFiq3vUulvoyVJmcN50NS7yB1sHVpsVxSLG1KeWw5I01+n3KrTZSX8uEkGlyjHkgAdQBh0wM44pXt35gRdT1VBweCHNI+oqLDnuug8Gl//HozJJn5nA5rEcxozgSypKMUd5WCHNTO5fYCWu7IM4+JZKl4hM40tdGTmwhvyKxu91riOxitmX4B3rFhiAD+oacBhyd7UUK07GztdbAWFIOV/gWd6B4HS7OjjWCSfDTrdPPeary39XWrRmlFlXjPD5X88LbSkoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jw3SevGjeQAQH9/eUq/xmJqIoPoermGM/N+T/+Lj94k=;
 b=lXiEXTLj+V8aTayDuUO5jxAzpPvR4anwVhr2WVZgcqWyKaYoeiUbasWw7EN3pbKb6sOwP7bmuCsaYDomH86Zw2Qjprxx6r6LxvlXyHWMiTfcq6GIGg8dJGCHTVD4tA0xrxf5CDt6oWV8/4b1UfvqyhAaxkKcxJWArC4pH9KodR9NmRjy5WiiI7T/iWpp/nZQ9D7spizfKVwFMIh3EH89LzPVqJ9uZkZIPQEWnufg2+Ug4kIaUuENklSBPc2bAFIYffzhNg3hRmWAwIHmjl0a5MybHf1XV4xy1ePiszyzUswUPlIth4bHR8udguIRgtbjnEYtYwn9+YhiHwCeRyWFpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jw3SevGjeQAQH9/eUq/xmJqIoPoermGM/N+T/+Lj94k=;
 b=oIru/qRUxJGwcjjzejJLDKstJt2CVMpNWIYv5kv+Xf1p81g2694vWuNIe/SFBsG98RAqw12YJHQCW9oq9/LiCoIGOwgNnMxbWfgs1zD39vn6xQ6AhdFIND9tySrIdsmXqzmKYeHkyiqSy6HwIZjStlY6FkNhHj5mKlugdDmQnrI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2862.eurprd04.prod.outlook.com (10.175.23.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Fri, 20 Mar 2020 16:13:21 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f%7]) with mapi id 15.20.2814.021; Fri, 20 Mar 2020
 16:13:21 +0000
Subject: Re: [PATCH v9 0/9] enable CAAM's HWRNG as default
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-crypto@vger.kernel.org, Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Andrei Botila <andrei.botila@nxp.com>
References: <20200319161233.8134-1-andrew.smirnov@gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <fab6192d-d35b-b26e-5bdc-b52b7d0347b7@nxp.com>
Date:   Fri, 20 Mar 2020 18:13:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200319161233.8134-1-andrew.smirnov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM3PR05CA0089.eurprd05.prod.outlook.com
 (2603:10a6:207:1::15) To VI1PR0402MB3485.eurprd04.prod.outlook.com
 (2603:10a6:803:7::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM3PR05CA0089.eurprd05.prod.outlook.com (2603:10a6:207:1::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Fri, 20 Mar 2020 16:13:20 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 174c8ecd-7f28-41a7-4d35-08d7cce99be3
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2862:|VI1PR0402MB2862:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2862AE8BABF90D8FC83CE81998F50@VI1PR0402MB2862.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03484C0ABF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(199004)(8936002)(81166006)(8676002)(66556008)(66946007)(66476007)(31696002)(966005)(31686004)(186003)(36756003)(5660300002)(16526019)(26005)(2906002)(81156014)(86362001)(4326008)(53546011)(66574012)(52116002)(2616005)(956004)(6486002)(316002)(54906003)(16576012)(110136005)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2862;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ARujDT7PBjXYLFxQbLa3sncQIh4NbU1OyNJmSiM5pt+Wn+n4y6XAkwsRe8yKhj9vZg/UGSIUOGDGc7Et2zEjvAfhOGMi7LwEPwdB/Y5Ww9xvvv5/GG5phpaq09fpm+gZ3740oGUwo67Rh+SsbnRCc0J8RGutsFZuLQlDUNlSI8AUms7N648u8s5nho8PzmGGWoV5+pI6xKUkmQjK5ClnRiFs5Wc/oCUbidHZsVVG4rpV2OmksLnKFupfP0W7ssHLgcaYbwKRqVPl1X0GdhiEW1vGLZ8x/u8ifmSKly+41/9MO4y+iYIJFFGC93AB7Icfxl+hGGM7OHsc5BIqNoPJq3TKy3e4fWQgaiQb4PXj6fNOhA+lLDATNI92cnmR2ImkP3p9GMswQZcpnfSBzMBMmMbQCqJl3AwN/k/eohLjtKF6lHRm7hMj2mCWNQPgKi/hzI5b3kRstSjfsx9/urdQSQ1i/tCM1/WAVwED2M64KsyldqI/75O3w8AO+TthSDaKeDpkNa3QFuRNWig+45Xt+g==
X-MS-Exchange-AntiSpam-MessageData: Ol1bAsluEc/VyNGeD+2/jqtK9gu6V5Z3XU1gSsk/14/DdICRgPHg9MHsDkRLSGxgepbWGyUYR5L+AnrtvQoJlpum6NgAfDhd64VfQs4MEhEjn616+GpVghrBFR5PMx6EebZn0QjQlCss8SZonqJx2Q==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 174c8ecd-7f28-41a7-4d35-08d7cce99be3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 16:13:21.5143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sPvxZcuIH4WrH2T5pVkm1ysdEU4mk/PtS5rbiDaBId1cM1MQpc0QYJ+DVMh+LryP6jfykARDixJUEOoWlR6p+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2862
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/19/2020 6:12 PM, Andrey Smirnov wrote:
> Everyone:
> 
> This series is a continuation of original [discussion]. I don't know
> if what's in the series is enough to use CAAMs HWRNG system wide, but
> I am hoping that with enough iterations and feedback it will be.
> 
Andrey, thanks for the effort!

Herbert, Greg,

I hope it's ok to go with the fsl-mc bus dependency
	"bus: fsl-mc: add api to retrieve mc version"
	https://patchwork.kernel.org/patch/11447637/
included in this series through cryptodev-2.6 tree.

It applies cleanly on latest linux-next (next-20200320),
and it has been Acked-by Laurențiu (one of the fsl-mc bus maintainers).

Thank you,
Horia

[...]
> 
> Andrei Botila (1):
>   bus: fsl-mc: add api to retrieve mc version
> 
> Andrey Smirnov (8):
>   crypto: caam - allocate RNG instantiation descriptor with GFP_DMA
>   crypto: caam - use struct hwrng's .init for initialization
>   crypto: caam - drop global context pointer and init_done
>   crypto: caam - simplify RNG implementation
>   crypto: caam - check if RNG job failed
>   crypto: caam - invalidate entropy register during RNG initialization
>   crypto: caam - enable prediction resistance in HRWNG
>   crypto: caam - limit single JD RNG output to maximum of 16 bytes
> 
>  drivers/bus/fsl-mc/fsl-mc-bus.c |  33 +--
>  drivers/crypto/caam/Kconfig     |   1 +
>  drivers/crypto/caam/caamrng.c   | 405 ++++++++++++--------------------
>  drivers/crypto/caam/ctrl.c      |  88 +++++--
>  drivers/crypto/caam/desc.h      |   2 +
>  drivers/crypto/caam/intern.h    |   7 +-
>  drivers/crypto/caam/jr.c        |  13 +-
>  drivers/crypto/caam/regs.h      |   7 +-
>  include/linux/fsl/mc.h          |  16 ++
>  9 files changed, 276 insertions(+), 296 deletions(-)
> 
