Return-Path: <SRS0=vjnc=7P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8170C433DF
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 10:50:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83F58207D8
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 10:50:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="XfsCdh1F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgFBKuv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jun 2020 06:50:51 -0400
Received: from mail-vi1eur05on2081.outbound.protection.outlook.com ([40.107.21.81]:16914
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725958AbgFBKuv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jun 2020 06:50:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JprdrqtwQ3Xh5YY8JOBQ6ASAoleDmqVuFsqJvLPNPeStSIgG2J7LppGDrFkC6Nel6DMIGyJiDmEyRKs4qNwv502Yo1jxE/WdTOijYwe2Yx3LDGJkbfcEZrj/kLY+yh1058H/n5svtr7t79XDbmDcca8rxsBQb88HfaAXPpBrpLITFxZPEhSEHC5Gp7PDWYfjR6rEiqkFbxFNDQPjkpAT/uo8rvmY46ocKNq/MzN4ivwv+UhSW9m1jkemvIv7f5Kgfc/tCWypCqFw9fLL+8BbDYH7c1CAjdua/tFZ8Sd/Qg3+OHNtAEctf1K6u51gVHZpRDiJ7EqOx9gLYaPiLx58Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=97WGhAZHccmXtmMaWeNGKbL27gJ3J44Rp0sqMqDVOaI=;
 b=iIufXwQpXwlDc9ioxNsY0Dem6MAvpzMvX73nRG3Xk0pbgMDqjLab6J/p3OX3acmXyA/Ge8sZr8gL82Fbo+Daf1XE+p/mG42c49zOjNKczyCwK2/1SeSsHJLPqAjgQ+uDp4l6PVldDxGluafTAqy2vMhVgXbVTjOKklvqaVmARqCZLngowevSbd3ndABtsvIJCfefzGjoefPUvKpII0nB2SYcNvC32ToO0FUErFTQnTAB0tXJw/kDtRQiehcEQUhb3Mkj0mV56RbCbW5xF28l9Do93CT/DVg+YkEACb3V1DI/ajm5j90qalZV+sj2LB1rU1+PKhy/ehXf5rdj67ULbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=97WGhAZHccmXtmMaWeNGKbL27gJ3J44Rp0sqMqDVOaI=;
 b=XfsCdh1FG0IJGqd1B3zyNGn/zzwKh1RZYP04ETLr4zZTs4xPvdukX8FpmYtdsXUiV/fIDivwee2tE7PV7POSr3as4GpT7EN2AVQaIugpq9sRhk9YEDX/+nShXj/V5fgGHjEvw9u4vV82WgZBVMagDV5mr+J7v9ZeyMzOvP3/RGs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR04MB4038.eurprd04.prod.outlook.com (2603:10a6:209:44::24)
 by AM6PR04MB6277.eurprd04.prod.outlook.com (2603:10a6:20b:bd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Tue, 2 Jun
 2020 10:50:47 +0000
Received: from AM6PR04MB4038.eurprd04.prod.outlook.com
 ([fe80::a915:1f41:6468:75ea]) by AM6PR04MB4038.eurprd04.prod.outlook.com
 ([fe80::a915:1f41:6468:75ea%7]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 10:50:47 +0000
Subject: Re: [PATCH] crypto: caam - add clock info for VFxxx SoCs
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     Chris Healy <cphealy@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Fabio Estevam <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200601230726.32328-1-andrew.smirnov@gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <87d4ff0f-e797-41af-7761-a58c77a14c1b@nxp.com>
Date:   Tue, 2 Jun 2020 13:50:45 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200601230726.32328-1-andrew.smirnov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0P190CA0029.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::39) To AM6PR04MB4038.eurprd04.prod.outlook.com
 (2603:10a6:209:44::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0P190CA0029.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Tue, 2 Jun 2020 10:50:47 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 59d22403-2f32-49f3-4f31-08d806e2ced7
X-MS-TrafficTypeDiagnostic: AM6PR04MB6277:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB627789F00C800491D6941963988B0@AM6PR04MB6277.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:277;
X-Forefront-PRVS: 0422860ED4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QDcHl9t+sb//PEnGWaBATSEkrSBeIjKyy4uLbZtLtyQYSppCnTtFb0Nw/G7c8XEg+H5AJHapitDcIM+Y7QmU5C/3Di4oW78MTdf2YhrW00G22tTXSzyMcz/xlqPPC+cy8InRx3gx1BRQO+NKveLFClOmBtjnKPpeixgOoQUJrKVfh/bU20VKCPfWTkPXRrSUOobsUX4qnBsU6qFS96LLzyDgIC/boqAVJkfJNEetUypC6NzX5xQ5EwNUuG75z/JitqBAxsTDDqI3/qyxcVoMHwQ8rSxO54ymmly1x+83WRCLzZHLlxUknQSIsBzGHNU+/xFaq46UCq9bKXRhJTSukzYxitXwbv54tFtX9J2IWODwjeuifqxtOhVDMYHlZymy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB4038.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(6029001)(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(2616005)(2906002)(53546011)(110136005)(956004)(31686004)(16526019)(26005)(4326008)(186003)(8676002)(316002)(16576012)(66946007)(66476007)(66556008)(31696002)(86362001)(4744005)(8936002)(52116002)(54906003)(478600001)(6486002)(5660300002)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fm2WZB5DCrNTpwBaaf9Ftb/GIaXg1udiJOzMyHdxaNY02Q2Di3SZFGAdtj18uFx2oPaEk6/F1ZhabMyE/LdGjaJgBqfcb5Ww8U21xgQ5BdJvsOmFYctR1CsRhWs06RSnwi1OoOnByIQpjnReWFNqOVJ/9pA7UKHZo2L5/v8fVLUaFdw79EiWtcQbCDOSM362wgqZD6WouG++Wbxi69JlF7iDkr7wqG4CsGi/Ndg7E0tc1og6Npf58FOjyHj7Nf6Op/J0UNm1s4L4iMCwBJWmpstbzw5w/zkJGVVkrLeBK4R8kYkWtrt9ca/LNzbwGF8BjE2n5UmJXpwfJDgKSPO3NP2mWkTem81p199l3Iljssxe0ThyY1ZUSWFLxx7qoFDN4nITt2PXOgFrsuhq2VoM+6fHbTc/R7xVBmjs7iYrz+jIQg820hBtzaq9rubE+H8BWU1h9qNXQ3fhcFk/WnYcejDVSBtUAlvmnV7PsHpYfhs=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59d22403-2f32-49f3-4f31-08d806e2ced7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2020 10:50:47.7246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xgpcghg2VuqSjr5cbivHj0AJW71h4j0/W28iHLz3rWzRDgl1UpqcBSavdi2t1ibe2nJouqqrH1DIA2qmHSow5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6277
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/2/2020 2:07 AM, Andrey Smirnov wrote:
> Add a small bit of plumbing necessary to use CAAM on VFxxx SoCs.
> 
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> Cc: Chris Healy <cphealy@gmail.com>
> Cc: Horia Geantă <horia.geanta@nxp.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Fabio Estevam <festevam@gmail.com>
> Cc: linux-imx@nxp.com
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia
