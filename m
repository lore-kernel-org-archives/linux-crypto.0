Return-Path: <SRS0=vKog=AZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2EB5C433E2
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 14:27:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAFBE22519
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 14:27:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="irFkq8f9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbgGNO1q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jul 2020 10:27:46 -0400
Received: from mail-am6eur05on2055.outbound.protection.outlook.com ([40.107.22.55]:53280
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726187AbgGNO1p (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jul 2020 10:27:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XyXXAHKnKp8mPz8LtJPAHLqlwPDHxLywuIGDTEZ0W7We3Lqh9d8mbv2vCYoWbWVy+3wUpINFUOwJyZyjtOjuroddQXpwkXQfCP3wHgU+D01dvYpyvbDGpa553GpCLo4xXMakA0pI9fa2naMFuUQE41xDoXVdFSPFAIZTlPaO3FWgRLZHpd1ODFq4F3Fy9O+cnavXLmD31l6HF/gExNusFLDYCDs2QAEhNvF5NmvRmmNJF5KIJwNYhnkB+AC3FuOxuVO9JesKODrU9JqQpF+GGZyw1eEynnxNsGZC4EcafGELgQcQVpVuVCrv4WVdqCu02K1ZfughTdybghDcTgZStA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aXPsGLyv0p8r01R6bHSA+EPNXQCzOyAKDkuBTxMhb7g=;
 b=gqEZzvG35tsJiGWp9m7VpWfzA9k/We6pYYbm7ld3oeRUq/2DrjSNvEBcR1ELaT/N7LssG63uG3p5lkaFs2fzbAuuKzGkkh3/dzCZ04LVx33v5Elyv1bBvzcO1t9kGmDZ6Gk6p/zMtNrmhmEcwxGkEaLEbp6gpa2y8lrZR5jpdr5KwLuCL2rZyzXQSdnXsR5pg9w2vrHgWxYNswveO+1SuBTWE7UwmmFZTxrkF3oOm8oPN6c8RQ7ncpiBZ7PDqR68yZ7hg/nKFJr5jfaDnPhBIbcLYQ7ejVc2YT2QwhHXmFD1ODQII/qcWusM+hP7HmBHVBo6vaxpGcw9GoNlu5I5FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aXPsGLyv0p8r01R6bHSA+EPNXQCzOyAKDkuBTxMhb7g=;
 b=irFkq8f9MToq0rYssSmTrXbeBUsL34W77EnYsMh3cZoKRRiGjVkUWAeqHyeZDRWJiIonTcu3tlk/iMbfA7B9zq8xccwErXoSzyzTReQetGYbrw4fTBUE09gm2MQK5pud3oOhw8auY1pHB6Q5VpIOy2MtjY1PR/yjinOgjJba33Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR04MB4038.eurprd04.prod.outlook.com (2603:10a6:209:44::24)
 by AM6PR04MB4966.eurprd04.prod.outlook.com (2603:10a6:20b:2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Tue, 14 Jul
 2020 14:27:42 +0000
Received: from AM6PR04MB4038.eurprd04.prod.outlook.com
 ([fe80::3880:77f6:c5ed:6ee2]) by AM6PR04MB4038.eurprd04.prod.outlook.com
 ([fe80::3880:77f6:c5ed:6ee2%7]) with mapi id 15.20.3174.026; Tue, 14 Jul 2020
 14:27:42 +0000
Subject: Re: [PATCH v3 5/5] hwrng: imx-rngc: enable driver for i.MX6
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        DTML <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Kaiser <martin@kaiser.cx>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200714123920.23711-1-horia.geanta@nxp.com>
 <20200714123920.23711-6-horia.geanta@nxp.com>
 <CAK8P3a3eQ2a3QV=0XAumHAOssddAZ_sBs=Y0D736Sp7_P8Jvuw@mail.gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <dae0aa53-dd6f-0ca1-4170-908d66342eb4@nxp.com>
Date:   Tue, 14 Jul 2020 17:27:39 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CAK8P3a3eQ2a3QV=0XAumHAOssddAZ_sBs=Y0D736Sp7_P8Jvuw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR08CA0028.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::41) To AM6PR04MB4038.eurprd04.prod.outlook.com
 (2603:10a6:209:44::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR08CA0028.eurprd08.prod.outlook.com (2603:10a6:208:d2::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Tue, 14 Jul 2020 14:27:41 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 004c405c-807e-4e0c-aea3-08d8280211ac
X-MS-TrafficTypeDiagnostic: AM6PR04MB4966:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB49665EC030DEEE847936719D98610@AM6PR04MB4966.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3t54enaVhxe2AcXCKIUTVeHsMkfAoQBO/1J9Xf3a5MXKzqxM+1Kz0RCAG5JczvEQRQ0j9S9nLiAz2VPIys+O9S2KfW5GitA9O7+61hYeYqvrj3RPGLNZQnyNcUp278/tkPYAOrmL5/NCDagB0hY8kofwYHPsZvx7xDpHukAv9odSdOcoc1bHAGPCk/eumCdCu7pHwcz/UDGxkQREdYHtac4ABznditNoJV/DbVH/aJVWa3ZU+8HJ8EKzXwX7BBZBOdeWNvvArgBQ8Lr+iJnyWfwxNnJybcXliOMjKrXTXhdoiv9KA6axjeHz0hj0QvFXmYCsJL00Rw/9/sGd2hvgONyOdGB+AvKgCuheDbV9kGlL0Ujm6IzNUwDx3BYSzmu4cHWTS1Tm0iDtAvT0L2BwBov2IOOY+u8yXR30wLbZ6nhj6ilWxO6fadw+EwZl8nNNovcDXTexFpbKxAw/3YS77g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB4038.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(66946007)(36756003)(66476007)(83380400001)(66556008)(7416002)(6916009)(498600001)(966005)(6486002)(31686004)(54906003)(16576012)(53546011)(52116002)(5660300002)(31696002)(8676002)(956004)(8936002)(2616005)(186003)(26005)(86362001)(2906002)(4326008)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: WZolsLEc9yBL4tJRlGzKcvlerB08MWApAy182WSDIpUzin/YNRDTbKkh2cISms+cXpGgNvzderUK9mJsEIjgKYizQntSYtV//shfZMUZAJNffplh6/4bL+ioDtg/qwezU03M9dMwQxIclvhQPie2QXsob/QcFvCjrG+OzAgCs6xHAlekFXsrbNKGMwC1sDH2r4dOwmkp4LKDibkHjqBsdSoatAC00FNVnWBRsE8Z8cRDCD0dkz3Sc46WE8hXSL+vZjDZT9u8P+LAzUJ8WmLkSBsigpxXn0e/kxdEMS0Gn2N24SiKxAPpq2El47bbiMwEKpbeIMuGGpJ8pcVhp4cP7OtEJI+owZAVLEMBS7dqYQ7XdG7N7DZTu2OZI5r9CiDdGrb6i/A5IemWcsmNxEyRFtE4wXJlEjmPs+o6DLkurtm9tazqZ/rfnePj2Qzu8Kn1NpbKR+oMYWriljk6qrgDVEcvHRgjP554tL1mgLXMKgWvLUWx5NbsnbPjinHVzZke
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 004c405c-807e-4e0c-aea3-08d8280211ac
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB4038.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2020 14:27:42.6469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fw1spowGOOZJIMmS3TfZt8peAAuHb7bbEZi2O2+IqaZl091CJjH3u1Ytoma9mhMGYr3kGs1qyEoHHr43osmftg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4966
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/14/2020 3:48 PM, Arnd Bergmann wrote:
> On Tue, Jul 14, 2020 at 2:39 PM Horia Geantă <horia.geanta@nxp.com> wrote:
>> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
>> index 8478eb757f3c..98f95a09ce55 100644
>> --- a/drivers/char/hw_random/Kconfig
>> +++ b/drivers/char/hw_random/Kconfig
>> @@ -255,7 +255,7 @@ config HW_RANDOM_MXC_RNGA
>>  config HW_RANDOM_IMX_RNGC
>>         tristate "Freescale i.MX RNGC Random Number Generator"
>>         depends on HAS_IOMEM && HAVE_CLK
>> -       depends on SOC_IMX25 || COMPILE_TEST
>> +       depends on SOC_IMX25 || SOC_IMX6SL || SOC_IMX6SLL || SOC_IMX6UL || COMPILE_TEST
>>         default HW_RANDOM
> 
> Are these the only chips that have it? If other i.MX variations have
> the same block,
> or might have it in the future, maybe just generialize the dependency
> to SOC_IMX6
> or ARCH_IMX?
> 
Fabio also suggested this during v1, see discussion here:
https://lore.kernel.org/linux-crypto/292aafd1-7249-5b76-ccc3-77b153594ef9@nxp.com

The SoC list is relatively stable, to the best of my knowledge.

>> diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
>> index 9c47e431ce90..84576d2fbf8c 100644
>> --- a/drivers/char/hw_random/imx-rngc.c
>> +++ b/drivers/char/hw_random/imx-rngc.c
>> @@ -350,6 +350,9 @@ static SIMPLE_DEV_PM_OPS(imx_rngc_pm_ops, imx_rngc_suspend, imx_rngc_resume);
>>
>>  static const struct of_device_id imx_rngc_dt_ids[] = {
>>         { .compatible = "fsl,imx25-rngb", .data = NULL, },
>> +       { .compatible = "fsl,imx6sl-rngb", .data = NULL, },
>> +       { .compatible = "fsl,imx6sll-rngb", .data = NULL, },
>> +       { .compatible = "fsl,imx6ull-rngb", .data = NULL, },
>>         { /* sentinel */ }
> 
> In the .dts file you describe the devices as compatible with fsl,imx25-rngb,
> so this change is not really needed, unless you want to add non-NULL
> .data fields in a follow-up. It is usually a good idea to have the more
> specialized compatible strings in the DT, but the driver change won't
> do anything here.
> 
Indeed, this isn't needed.
Will remove it in v4.

Thanks,
Horia
