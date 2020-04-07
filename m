Return-Path: <SRS0=R0fc=5X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4F4FC2BA2B
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Apr 2020 07:39:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B2C2206F5
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Apr 2020 07:39:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="N+1FgKa0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgDGHjn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Apr 2020 03:39:43 -0400
Received: from mail-eopbgr150053.outbound.protection.outlook.com ([40.107.15.53]:53382
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726591AbgDGHjn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Apr 2020 03:39:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LfRr7TMf39WO2IUr9wQ03nZL1bm6CeFQyUWDoTZQuaDybTvDaGESIwXdVr72YajZHPNUcTy9KM1GES7IC/38bE2pWL3eddNC3D6t25tk1pC17hCTSJo2eZDnKO8C6ozZ17RROFuAdH3Rdtrn9Nv07OxpqK9GgoXGMLpG8Y/rDhbRofL541x3UBrOycyXwV8C+WQ5FjxYSKdnpZPDraeIz7iAV4G57PUat3umtxa2uTh2/huHNjbZC8341ZU2T3fLRx5atr2dm8gJ166IVbxZHF8VwbZyV9f9xkQQLC5Q00bcF5VHwUcMVFP0BWGCe+kkCcOlOX0pzJI/rVFVYXZnAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cEyNNEoh+9JoZIjNisIQIVqVDqK3/qxxSVzG9O29Jxg=;
 b=M7PcMuz0GASW6A+q7RSkyA4EUTqK8wWJQiiHdSlRcUAr4tTASlZ1poIoSFyMlHqCOUslBF+/5NEgYJ/LouI+dXh11ah2Ka1wK8GaGVB3LW34L3nxIibMoG9QlLPSVJiZ0i3ZsyFew6e9mWTERYGshOPlhXUngihONB/aTQiTLOvZaeJ9eRezUnHQo31X5yT7nRPLIve5SBS+Ht09XHFEfBK+F8PSr2TEGB/tjF7v/L9kH3s/LtGWRSqOUrCF+/dHDrx55LdQCncvpluW9PtfEktZK7b0K+Hp8b7hZ9/VGDESsDupJWGXco1mWyXxiZueX2SoQ1DrcXDcXm+fj1/0Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cEyNNEoh+9JoZIjNisIQIVqVDqK3/qxxSVzG9O29Jxg=;
 b=N+1FgKa0sfOQea+lhtlEHwIpRhmLL0mJUR6SkiOuDoyz6jJoRaIZUh6iRTs+G3aqKFG/ubcpF8lJiV9YtFjoeGF0gDM/El+uqorahNKJKegK6b80e+3Gf0VQv5CGrH7p0mR6pNOGFHOQ/qjaVYTGp4nlz0AyUo0NCVB5Cs4aA64=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (2603:10a6:803:7::25)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Tue, 7 Apr
 2020 07:39:39 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f%7]) with mapi id 15.20.2878.021; Tue, 7 Apr 2020
 07:39:39 +0000
Subject: Re: [PATCH v2 0/4] crypto: caam - fix use-after-free KASAN issue
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <1586213248-4230-1-git-send-email-iuliana.prodan@nxp.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <a0715aa8-e19e-1a1d-a924-e8a2d3f076fa@nxp.com>
Date:   Tue, 7 Apr 2020 10:39:33 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
In-Reply-To: <1586213248-4230-1-git-send-email-iuliana.prodan@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR10CA0057.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::37) To VI1PR0402MB3485.eurprd04.prod.outlook.com
 (2603:10a6:803:7::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR10CA0057.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Tue, 7 Apr 2020 07:39:35 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d08c685a-6772-4a98-b5fe-08d7dac6d24f
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:|VI1PR0402MB2861:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2861D721D4A0C070E8870A4D98C30@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-Forefront-PRVS: 036614DD9C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(26005)(186003)(66946007)(2616005)(16526019)(86362001)(956004)(36756003)(8936002)(5660300002)(966005)(54906003)(52116002)(478600001)(66556008)(16576012)(316002)(8676002)(81166006)(66476007)(110136005)(81156014)(53546011)(4326008)(31686004)(2906002)(6486002)(31696002)(6636002)(4744005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YBkK89yuPTSmSRaenyYKCySBsuaf5ui4rbUlLG5fHx4uP9pjtnCcsqjkTgR+LTRQ3gdtMMXfWv4XsvmGKrOsUXFS7tUgEQp1JMxKK73nuRRekNm3w5BPydAvm6xLp0NchAxGVfpY1/si9RCxBa8KcDDf/ysUs3sgYqw5iTp8Ymkk6g6nVaWb2ScgKnhSc8JdsrVz9YV7hmbmq5uW54oDimikwi5tBekFoc/AqNONkf7+dZI/UeuvOx6oqVTtWmBcKUbCp+rzUBj126NReRD760zX5pYbmUDEQdydfH1QMUoeAuD1G4f7vdVkCF06Yo1PP0gq2Ek0FnR5ZOkaXimbACi+8K4lu0PkG8a5TPaeFTGrcX6MyS4JhwuOrPpiSw3DibLQPKh9BiUCOYeZ3IAm5uzTURcmM5QD1i9KLFvRWIlVTR+WYoE80rSoulfT063aH/DNv+HQAsYo6BIGG12YCcgapNSq0FfutJbfInkW4FEYrWpW5euVCmv2Ar466wVCCZnNgbNn5IE2qylHoq1P3g==
X-MS-Exchange-AntiSpam-MessageData: 6xs208hv1jdQXXx1LgC6jvlM3SK+V7lC6YbqnBs0L6MUwdf4FdOdcuOG0QvY7ODfk9KUkCx2Qf92U28qypJZqxPBuwto4+bmoxMAus6W//Gcs4Yjofy9b1QhnHQ/yZ2WvI1bI5y/wQ3R2epExUnOCw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d08c685a-6772-4a98-b5fe-08d7dac6d24f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2020 07:39:36.4962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 01tCiGIKXfEvaR6SkqP5o4i1qAFQjPDrfbc19RbCdlNltNqx2OtR8NxlTJu7guwtfunqnkuPiIXCcFqJpVsiXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/7/2020 1:47 AM, Iuliana Prodan wrote:
> This series fixes a use-after-free KASAN issue that was introduce
> by CAAM backlogging support[1].
> This is fixed for SKCIPHER, HASH, RSA and AEAD algorithms.
> 
> [1] https://patchwork.kernel.org/cover/11378941/
> 
For the series:
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

though the Cc: stable should be removed, since the commits being fixed
will only show up in v5.7-rc1.

Herbert, could you do this when merging or you prefer instead v3?

Thanks,
Horia
