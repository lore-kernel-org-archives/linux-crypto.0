Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E9DC2D0A3
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 17:58:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B59C222D9
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 17:58:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="DZj47V5U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1782200AbgJZR6L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 13:58:11 -0400
Received: from mail-eopbgr70045.outbound.protection.outlook.com ([40.107.7.45]:7302
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1782050AbgJZR6J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 13:58:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c41JdQudqkj3ro37hQ2HxIvMQAQa6uPHkQFVMFHBfJfHpJvbfs+nhE/osjAmT5PGTBsUfUA/6Ik3mzKC5smaM+UjgWPxI3bxVvKNVDr3jhotD/+4hTQ5rvDaN1yXjVy1wXfgwkA4G6pHD0ZCfDx0mn3skxy61yi+YMyMItMfK+/b8J7C7isHxwUVLSyfe/yNr1AfNa4V8o+fD1yp/bOEN+9KvEGW6WtccJ2FIktgePcYSzTGG2g1Hrc1DNRJMAjVhWCSCM+uOxoUYk/2r2mgOnVKH290GWg2VYTnj7uxdVU3A5dxoZPfxBigNJy3vY3uuHxX4adDk/zmpn43uk20Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+gSgOk92mZCrUk0Hc82XMr+r7KFYCfRM6XQXWOyGo4=;
 b=lnbWNiuUCCjCLwpT+pl4up7X+EcOpN+q8IkDITBidXn6hXqIsuKUs1huUOiwgNu4YTg7jPwGFAJpy0PKVdY+Oi3RLRSUeGA+0t5/D1Oyy0DlnAkgturvG0KY0ljl7mEu+KMqI0qP8AtHroaa2pglhKrwQk8XkYLa/pJWi9VQbd4MQel5UhGt4bAm79BftVBVkrKQ+4HrOPiYtOm39VT7Vwwg4CVl5Pxtq2JtFw5v7Y63TCkudibBLiulP14+wLgi6U1+QHBp9LyVvqXbsPbHWaarhIJajvw6TNnlwUYFm3D0Fle9BylnqWKeN5HQr9ukJAVbuizjeajM2DB7HrV/Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+gSgOk92mZCrUk0Hc82XMr+r7KFYCfRM6XQXWOyGo4=;
 b=DZj47V5UG2FlEm4JIFQ3ShNda5clEKTUBa1DfZthJ5mTR07AlMp6TFCu3bd1bNXTsQtNbNrR8+ASyFLexP7pFYCosoc1BbCtTfr1PdYih8JJa2Wm0ghRogvKphnZcIsvbVEmO30f4pqBh2bL+vzzlZhvQZIBAJmkT8LzpdQl9f0=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB4895.eurprd04.prod.outlook.com (2603:10a6:803:56::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Mon, 26 Oct
 2020 17:58:03 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d%5]) with mapi id 15.20.3477.028; Mon, 26 Oct 2020
 17:58:03 +0000
Subject: Re: [PATCH] crypto: caam - enable crypto-engine retry mechanism
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Andrei Botila <andrei.botila@nxp.com>,
        Dragos Rosioru <dragos.rosioru@nxp.com>
References: <1603310810-25307-1-git-send-email-iuliana.prodan@nxp.com>
 <d54a2528-11a4-8a54-6454-a0d0fe06f39d@nxp.com>
 <ebdad102-fe91-7324-8096-dc1dc2313786@nxp.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <bae6b3d7-582a-c9fc-c118-992d780ef5ed@nxp.com>
Date:   Mon, 26 Oct 2020 19:57:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
In-Reply-To: <ebdad102-fe91-7324-8096-dc1dc2313786@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: AM3PR05CA0089.eurprd05.prod.outlook.com
 (2603:10a6:207:1::15) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM3PR05CA0089.eurprd05.prod.outlook.com (2603:10a6:207:1::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28 via Frontend Transport; Mon, 26 Oct 2020 17:58:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ab7c9bd6-1747-4fed-eb9e-08d879d8af23
X-MS-TrafficTypeDiagnostic: VI1PR04MB4895:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB489553A30C5E9510A4F8762998190@VI1PR04MB4895.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /IraOQOfW28QxCwNYvZSujxIBpzEZ5xHZjOShInY4HJ8jKWQozCAJ6f/F7v2wy7TXPgizJdLWVOpUoGZ+CDZsiNkhNEqODmBxP/0c9wF6ckqFRQLQeD7VVXsmU3Wr/oKHSaKzMNvrJw8Lu+nWX1w5Clcl5SvjGJA/bvlDH4pFAUH/JvYEyxE8zFSBSozaXYKnFr0oEpa4OlEvhSJy2j2OuJjIsJ0GARcS5IWyQZ2iqw7mbKVNTodS/H9q9m8gC9vi0SK/EHTDyCKyGN4+HvvMENJ13UJnhyzO6rmGXfwkj2r3td7YXG5/C8Fcagn/ztwhHMN2IBBucAR1I8BMxkwUTz8Mq4jRp1TpdRBOgNjC/+Ge993DI9Rw3bqaK0QCm3a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(2616005)(956004)(52116002)(8936002)(5660300002)(6636002)(66556008)(53546011)(2906002)(66476007)(66946007)(186003)(86362001)(26005)(8676002)(16526019)(54906003)(316002)(4326008)(36756003)(16576012)(110136005)(31696002)(6486002)(478600001)(31686004)(4744005)(6666004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Vy/y686znDzsfYCjJz0geKbc7Zoti7fyWQCnGxY9SwFWuo7hFdr65cEYGj6ZbPVubqMH0Lo0KIUnn8nbvw34QgRUbJLe1dSl/CYvN2q7fbsBWWpVR+9onLMHcpUrQ7x6yT3nGQ4QMl91UA5wII7rLz+lxbG/Moiq/EohPShh/Xigd41dIh2rVu8FqQXAzwzj/funKGp3CUzIqF4iN8bf9fu7fYknWe8yzbp8Z+V1lPV8GSeKp9Zo2Fn6G7K6GC+XUQ4Dfn7Z+EBfnrP3sOY4Lxp+0macPiZXU4WAh0xaVfw/kNQnLxQ2ROdMHG8JnKKmkMpCXgaGZRUvHRvXqV4CnUkw4Hb+llD9mitaIKbwWuwc+dcJyfrgITB6sNXJVZ54EyWKcVhmigJxpzXT7O1pGGG6azKrI+n8VVqn8ZR0Paz038LBRjdyFG1T2rAxMjgzIFLW2vG5q/+boCc675MAkZ9IUD0uv1DRmBvzXEqV21W3vwLq4BwfEcDjjn4zkiVRnqdvOo93eQOFiRGY09kCalDhb2w+Zq+Co3HWLWkNUI1CO3AQgllm+m7HHN+yR2CCFIrIRdvTSyifSFRjwdj1UlMCjv3zwWXytJvA1nZXszzHOTIehs7Yibie6T37W3sIslEgMlcEKE93JKB+vfjydw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab7c9bd6-1747-4fed-eb9e-08d879d8af23
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2020 17:58:03.3487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S932dMxYZpKuXWN55kQ7wAEjvVwmMR3xWryfqJLi2+U4OZbbFQprpVq7iWHdCqsqrI5UJFsUVP/TUPF2sK1H6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4895
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/26/2020 7:11 PM, Iuliana Prodan wrote:
> On 10/26/2020 5:36 PM, Horia Geantă wrote:
>> On 10/21/2020 11:07 PM, Iuliana Prodan wrote:
[...]
>>> +#define CRYPTO_ENGINE_MAX_QLEN (2 * (JOBR_DEPTH - THRESHOLD))
>>> +
>> What's the logic behind multiplying by 2?
> 
> I added the 2 as the number of Job Rings.
> My logic was that crypto-engine is one per CAAM (x no of JRs), while 
> JOB_DEPTH is per JR.
Currently there is one crypto-engine per JR.
crypto_engine_alloc_init() is called when caam/jr driver is probing.

> I know there are targets with other than 2 JRs. Therefore, is there a 
> way to get this number automatically?
> 
Most SoCs have CAAM configured with 4 JRs.
Of course what's visible to the kernel might be different.

Given there's one crypto-engine / JR, determining the number of JRs
shouldn't be required.

Horia
