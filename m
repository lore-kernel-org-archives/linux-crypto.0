Return-Path: <SRS0=I3Dt=5C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8390CC1975A
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 18:00:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2ABCD20674
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 18:00:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ofQMSxU/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgCQSAE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Mar 2020 14:00:04 -0400
Received: from mail-eopbgr130087.outbound.protection.outlook.com ([40.107.13.87]:22244
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726189AbgCQSAE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Mar 2020 14:00:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lm82Sdyz08yKSH7aweA/tfk0URzncasemay/w2XB+oBLTT8578m/KHFHO7hzF1R2C8LDzvpwmbqTnnSfjpbeMfdd14JLfhGBlnhk4SdYAYkkHkLLWoErpPmsqEwsWfqgsfYE1XuI19a398GR4ux2CK+NyMKq2tIsJAZUWKbGv4iWOdROWjnZ0W176TP49MbHw36oDishQkiRFBCQ3eHLcLwNIq9GEz+CqLUzVg0eu7bgmVNbmiDimfVm7gIi7d+sO4dqxuK05aZZCkKiryCRZk7ktjV5/UvAxqXXEpn6Tf79x0MuxNQCdL3RXVAHkmSz88aAm7BuEbUQSrLWEOK5fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aTMe45VDREcnKLzoEYUYLXtPyyecLT47F4c8s2ZoP5E=;
 b=aRB2QdaqJjWRcqYhNPdNrjWqR492KDzeWAPQyDYSNTRfbSlZJ/dopFix7p/duwETpayJDI3sjraVM7e2od5gSnZAKSOAG5QOqPpNP7ntEJB5cGxaAPfTAB83TqKXap1B7yIZseV3RFohRqx4kzBgz0wwYfi/7TlkICu6xkk8CvpOti+8fGj4VfHMYE2A33wf2Yau4dVFYXCLaEoRBvDJjmDKV0mwjZGg3Mpdk2XFrBzbHwNEV1iS0WFJwJdAe8jzf7hRiZX8cPj9DMDO+TRGYdHMF1FwJoXxBuzb6Jd+EF98zcHA+7VqhEublvXqlsEkBI4k+0WDhOIiEoKRC5QCSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aTMe45VDREcnKLzoEYUYLXtPyyecLT47F4c8s2ZoP5E=;
 b=ofQMSxU/SzQFFt99RY0jiyyKBwwUdbOf3K5ciD9eTAkld931s7fAjavqnEzbwFOiYdjrNHbMEYhytKctKWLLJFYheEiRLCw37oa17XEaqk3I+BDcViYmOSS3s/3yjEMLbm85iMz/Uc4xEfSOdw6IzD5YcSqiZYCXYyx1zrR8luU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3389.eurprd04.prod.outlook.com (52.134.5.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Tue, 17 Mar 2020 17:59:57 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f%7]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 17:59:56 +0000
Subject: Re: [PATCH v8 7/8] crypto: caam - enable prediction resistance in
 HRWNG
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     Andrei Botila <andrei.botila@nxp.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <20200316150047.30828-1-andrew.smirnov@gmail.com>
 <20200316150047.30828-8-andrew.smirnov@gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <3b4178a7-f410-b5fd-d154-9682f1acb29e@nxp.com>
Date:   Tue, 17 Mar 2020 19:59:53 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200316150047.30828-8-andrew.smirnov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR07CA0083.eurprd07.prod.outlook.com
 (2603:10a6:207:6::17) To VI1PR0402MB3485.eurprd04.prod.outlook.com
 (2603:10a6:803:7::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM3PR07CA0083.eurprd07.prod.outlook.com (2603:10a6:207:6::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.10 via Frontend Transport; Tue, 17 Mar 2020 17:59:55 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 88184432-9f5c-4058-da4a-08d7ca9d00a6
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3389:|VI1PR0402MB3389:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB338973C496F20120B520546498F60@VI1PR0402MB3389.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(199004)(36756003)(4326008)(2616005)(478600001)(2906002)(956004)(86362001)(31686004)(31696002)(66946007)(66556008)(66476007)(8936002)(81166006)(81156014)(4744005)(8676002)(53546011)(186003)(16526019)(6486002)(110136005)(26005)(5660300002)(16576012)(316002)(52116002)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3389;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HQ0PDDfUAwJrYs4gmSKEzMd7YQu6FuUD4HMloIRn/tw99DIVUfV0i239jG86GcM6z9mBOhyUzMVzY/DlI1J8+DyPNpDseekamKR7G5PQrA8ZZUsdRZBrg5F8GXDJLPM2C/ze3qbUY88dmjUgJiueaJd0KjSk+m1ZyyYDYJLk3yCgZ5ddEWUpV0khPFdHnwAsR1Zz5vUVHYDwMMQHPmbrBQeOsXCFDz3h02RM5HE6qDXaiEj0vnrfXLQU596QqRrzKkzyKlQ1uSFNlYzLAHqjieZzeCno+9QGasaehJk7k9Fn23ABT2pj54ResepVWJxf7ZUpyGEEct5q0wtmKAGMbh2m66B0lp3Fo5EueBUU9D6mdR8RHqTNLrC7dhKovuMDdE44LAbqr1sanLkbZ6OBlhicYMYTFR1VP+/0UgTh4vcWqYdvpmZYdlDEp0Jd8KbD
X-MS-Exchange-AntiSpam-MessageData: BrTohAq/oot5bApf0ujQotStiGflCmu3hHMEEz1HNUpz4v6fPja/4gT8SqSMBLfOh6jTyl/IWf9cbn0wnPp0JgenztXeh2bdoHAH2gcTxcGnbhUXH1s6Vo66YuzND511oG4F5Id3yAAhYzp16KuthQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88184432-9f5c-4058-da4a-08d7ca9d00a6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2020 17:59:56.8514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zqUE9myPVriBybdVZO0V+y5MZF+Vke5u7bmSv3nOrjUSvszJ/DxPGEiBwAVr0zU+O6BWNCG0yxb67fn0SwKsSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3389
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/16/2020 5:01 PM, Andrey Smirnov wrote:
> @@ -564,6 +579,26 @@ static void caam_remove_debugfs(void *root)
>  }
>  #endif
>  
> +#ifdef CONFIG_FSL_MC_BUS
> +static bool check_version(struct fsl_mc_version *mc_version, u32 major,
> +			  u32 minor, u32 revision)
> +{
> +	if (mc_version->major > major)
> +		return true;
> +
> +	if (mc_version->major == major) {
> +		if (mc_version->minor > minor)
> +			return true;
> +
> +		if (mc_version->minor == minor && mc_version->revision > 0)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +#endif
> +
> +
Nitpick - checkpatch complains here:
CHECK: Please don't use multiple blank lines

Horia
