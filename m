Return-Path: <SRS0=I3Dt=5C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E6B4C5ACD6
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 17:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 315B120724
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 17:41:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="UGMWsbsl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgCQRlo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Mar 2020 13:41:44 -0400
Received: from mail-db8eur05on2052.outbound.protection.outlook.com ([40.107.20.52]:52448
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726148AbgCQRlo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Mar 2020 13:41:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JWl3tBOiLdQTwUKhIxeCiA5J8aJtO5OjzzXNGz+94sF+wmRr5pzrM8Hd5Kex6gO24eusbKxPzZGBn/NRI/Yfv34IoteFp4llyewGsV7x9iCyGUolsA4/a3cGQaTXTC2WdjLAXDt/aBpTr2xR4rFSJbZzYzIBWzD96h952aR4idBbbjTQ+1vG3r9pCiaopdRNYRqce0rfXbYs3MYTbpo1E6ymTZJ063yn6HWq55nR10+0V5dNB0CuyjaVCApeADkHvLpVMY+bXhAPMd3mqqPxdaxX5m3MF8yxHzeLPEf7YCEkZ+rEkpG6E/fVqOTaOe1t9JnOSZjyjE475JamJUNSYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6+UZWjHfVYAqp0AecHs/vFchgTQPeUxbbTve1V36fFg=;
 b=esEZj+1nxqu8nvu+VzmLt0YOKE0TQv8pQtsT+1LcaFZM8ujwkAHVIyldXVAthfE23A+EkyIoJqB3Q6tYiMaORRMRJ/vFAPkTOj5N0gh3TVq8b93H2i9BvWzH6lgQxq5UP2+Fq2gdnwIYGPwKwLc+67XRHHt3v6u3YltDmWaAYnQHoD5TfFIp+inhw6kj/1WZ6T13KsIaaV1xXmq/TgOgZ9Ff/gnT6i28vvEYRErT1azSGbPJVfiVkEdHlHpkvHDCXJTnNLv0Lt7Cgcoi89lniTw+rN93pUIdzSHgoY6H0tWhwqyJQ/jm1sAp0ddbbXs9wrGK73JiaZzcKrzmQQi4rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6+UZWjHfVYAqp0AecHs/vFchgTQPeUxbbTve1V36fFg=;
 b=UGMWsbslQQAnlIWF9y365bTKcnb9+CLcAQDQRlJ9guOstHvSCjxGMYacsFQ8Hrffs742KD3ei/0PtkSPskXPcRLMtOEy++cibVico4jxl9LWKGMYKry5dE79HahoEz7En059ZjFpXquSUAgyFD6QiJaIDVFyeHrNZOj8j4LoNNQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3853.eurprd04.prod.outlook.com (52.134.11.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Tue, 17 Mar 2020 17:41:40 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f%7]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 17:41:40 +0000
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
Message-ID: <25f35233-dd45-227c-f535-67bd698ce28c@nxp.com>
Date:   Tue, 17 Mar 2020 19:41:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200316150047.30828-8-andrew.smirnov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR0102CA0032.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:14::45) To VI1PR0402MB3485.eurprd04.prod.outlook.com
 (2603:10a6:803:7::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR0102CA0032.eurprd01.prod.exchangelabs.com (2603:10a6:208:14::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.21 via Frontend Transport; Tue, 17 Mar 2020 17:41:39 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 264c38fb-d14c-4661-2f2c-08d7ca9a7328
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3853:|VI1PR0402MB3853:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3853627D646669467C8E394498F60@VI1PR0402MB3853.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(54906003)(52116002)(53546011)(110136005)(31696002)(16576012)(8936002)(6486002)(316002)(86362001)(478600001)(31686004)(81166006)(81156014)(8676002)(4326008)(956004)(186003)(5660300002)(66946007)(16526019)(2616005)(26005)(66476007)(2906002)(36756003)(66556008)(966005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3853;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cBuzrmWY3ag8/RVwGT7CEDDI8FScK/vRg3W34FWvptGSx4ymzED9d3FCTeczYLtZAcCOeN/fVyT6vwcXxXc+8vfrYjRdu1csdA+mPvlSHMHbcEvwhjInOtl2lwgqEpy/uDdW1XSz63OFvqSTqmvRQMNUl9d7qyBik23e6Eqi6wgwqecGR8Fs4y/ctJ2YvvUbqobTMzdmZUs8rZlZSVhGtjxmsgB9a5aUOuKEVF1HCJ4R+jvOK/SeX5GyS1cL5NGuZyt7dBz/wDfwFJxWgm7KBI5S3HHoXZ285jAENVy6KTxkRUWX0J1AfzZHEgyU558K/ek0eteUfjdl9MHqp67n9k0zt7TU98HAS4Oct2OEmlX15kki99FjcZ6X5U6TzLL8LpT/IcAzyBfeX3CjUYmLoWJuKZBExg9ALK9uIkcyMRPN+Z9WVdoCDbc1svWCcHzCwtS2l4rP1ZDiwr6+yuJJAHDE6qsnTi4n1ULMGiSAyY5CAjunUFcFfbd5GQfibEcQRwAgI38Nl8VY+6UqLn8QNw==
X-MS-Exchange-AntiSpam-MessageData: Q6ggHp7mi2qHSeJzdiwVUZ8786Xom6vxVIVSDd3xktbBf7m3KmTX9Nk1ds9qcDoQD6NoQZqA7XJt1xBRNAsz3igP4RY3KwcDlkhDN2JgLonE564YFh9rX23kgtoRosPWttcoqF+zdaUE3R8gHonC1Q==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 264c38fb-d14c-4661-2f2c-08d7ca9a7328
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2020 17:41:40.3721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vPbYUIW/4HaTu4uu3SvGL2Vq88Ci/cx+AjybGlYWrYcaKKlJDqD8Qg4GOwduAkMn0Ue/ne81PETUSPof0jKZBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3853
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/16/2020 5:01 PM, Andrey Smirnov wrote:
> Instantiate CAAM RNG with prediction resistance enabled to improve its
> quality (with PR on DRNG is forced to reseed from TRNG every time
> random data is generated).
> 
> Management Complex firmware with version lower than 10.20.0
> doesn't provide prediction resistance support. Consider this
> and only instantiate rng when mc f/w version is lower.
> 
As mentioned previously, this does not compile.

Please include the dependency
"bus: fsl-mc: add api to retrieve mc version"
https://patchwork.kernel.org/patch/11352493/
in the patch set.

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
There's a typo in the code we provided, sorry for this.
Should be:
		if (mc_version->minor == minor && mc_version->revision > revision)

Thanks,
Horia
