Return-Path: <SRS0=6s16=C5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E6FC43463
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Sep 2020 17:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A0B920874
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Sep 2020 17:56:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="IzBnF6EF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgITR4t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 20 Sep 2020 13:56:49 -0400
Received: from mail-eopbgr00072.outbound.protection.outlook.com ([40.107.0.72]:3140
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726043AbgITR4t (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 20 Sep 2020 13:56:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SNuggmoe52sxawa9xnP8hw++Q4VEvBqrDUEDvTulG6Uu5yeQfJtEEuja7tCJxY7BU/4sjsGhetfZEv9JV66kv2WZU1Lsw2XTpRu82XNZKxrKGLSUg2+PMtzFGgVA43V7F8uiBUjVrK7zfO32QRcaGwR1gdCU34MRGVWYZEv0cNW6K8L1G8h0jurcXJrrmkUrQa8s2+8wwVoLsc+jNN8RjoN6i7FxAftMPckSAO7C5o2lEnDC70IFR1aGjZGBhCMTI+VoObkd7zO0STTh0oOY9b54XCSCo5b+1Cl1prSMSAFwigGGXNgleDWjt2WIp+UdFv+75O/xB6vYsWa6Yg/OGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MXNNL173UpM71WCtic4V0d+4KGcju4wKPCDyW16LGO0=;
 b=W+6IlIb29+oAIEnYJzGdI/N6f7Rmq5a4RGYVhPMyiK1d9Niy1jDYg6+7+ZW84+NElYDaOZ+uBhbaSgMHFYQWrpGGI9TXjRieqL1DU3wG59TChExfv23jP7PmDVfFtJ26RR2TCPkWKrTL9lHUbozH61EyM4BWmJj9z3DkAKeJWEiRObpaLZsSViAmDua3uRiaauwZihhfFTrtefAnh+lmiHAlDgfZ7WMj9YRc5MV4ogmyIpMFcUZLNvj9Zn8J9geDTvLD1tZLWCxK5iHK0BuNHgx1n8QdUwyBi/0X/vZaU8lofEbrZeMS2uhFzVWhKZ3HUJaOSUrP/Ehn8EnxJs9rhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MXNNL173UpM71WCtic4V0d+4KGcju4wKPCDyW16LGO0=;
 b=IzBnF6EFZ95T7sWB0q/ymY0jBHprsU9Ej/2KfBj60OFJ0c1zdLPM9BOrLKf6RiqriSSzfoT4nxoniMtpXZrZYB+sux5mpr9NgLeiHkAUsyFFvUh+UaKockvYkI+hmHDfWs4u/keZSp762NSuz3vHwE3kwnX01P19uDjk9p+nXAA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VE1PR04MB7486.eurprd04.prod.outlook.com (2603:10a6:800:1b2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Sun, 20 Sep
 2020 17:56:44 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d%5]) with mapi id 15.20.3391.015; Sun, 20 Sep 2020
 17:56:44 +0000
Subject: Re: [PATCH -next v2] crypto: caam: Convert to DEFINE_SHOW_ATTRIBUTE
To:     Qinglang Miao <miaoqinglang@huawei.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200918013111.82650-1-miaoqinglang@huawei.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <5a6143e2-6055-a4de-b0fe-0fa76ed4a643@nxp.com>
Date:   Sun, 20 Sep 2020 20:56:40 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20200918013111.82650-1-miaoqinglang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR06CA0077.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::18) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM0PR06CA0077.eurprd06.prod.outlook.com (2603:10a6:208:fa::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Sun, 20 Sep 2020 17:56:43 +0000
X-Originating-IP: [78.97.206.147]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bbb98a3f-58df-4caf-9372-08d85d8e8916
X-MS-TrafficTypeDiagnostic: VE1PR04MB7486:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB74862BDAE223B35CA37668AC983D0@VE1PR04MB7486.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:530;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dOGGtPg1FY6KNhMsBR6zSZpWVjCHo100Fm2LEv/yzwTbYpPLGj+iPAd21hisLpOHbUX38DRMC32Xp5j2/WbNeF/5t3QUHnHSun4kRR0Ru8PqYIHre5WLeHuM1i69aNWSII1vYad5exR3NqjHqt6+IO5+DGbCnbEbXHbwgTerSYY/z9tKwxENyOAaaTWJkOzqNPuBtEGfA1Fx9SujnBY18JRjXbCsNe88QWvV7/OMa3ZTs/X+iYj2wjTXgTbaQuCauFYCkx6Je+81E5mMqEQ7Agh9NUkChO355jv2+35XyCXs9rCPvKFya8tVqTQHoonOoQMqhN6Vb037+u98WEWKSuOhsXLsI8fEnDd6+D/Ho7O9IIxhO3KfXn3SlaBSTzJr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(396003)(376002)(366004)(66476007)(558084003)(5660300002)(86362001)(4326008)(66556008)(6486002)(66946007)(2906002)(31686004)(36756003)(16526019)(8676002)(16576012)(52116002)(110136005)(316002)(478600001)(26005)(54906003)(8936002)(956004)(2616005)(31696002)(53546011)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: u7CGcm/icqLu00+Ua2xXQqz3b2gZtChtWyiri2YYXv3MID5ySFmo/Th6KVWPKt4jUyufJlq9oVr4GIXpGurWtv70q4PiQUqexZU3gk4drJc1J0lxPATJMx7bCWl1xPZRIeyalEyg+2iaOJPUx1NxpP7igoypgAWunsxv/l1rSArVwpMnKLSn/GUJ2hAbs/0ITqhmbB6iMs3b6X1rOGBAazVyFGg7iaoZzHpY+ECaINhtO5WthBHyJSu4SA8y5pj6ADhiQKGyHxlJMQp3fVzVZJk7c159pbv5xcI7lCqFwzupjiFdg6KpC0BhsQzMIgiZzoUcrHvuvMuNU9qi8NxXIn6l/jEnG7soenCVmstsm4lNejKxbO5fm/rj2Bquy0QMlXQArKXqlJKIFqxoGo38U0jsSN+uMMQlhu9dD0WXU0amD3j4l7/TT4n1MeEtdny0/Qeew2eYzfg/Aw3xp1YlhCg3TLmv8/9x0VW5X1QPHiBdPplYQLNu8VFsvY2n9e660sWE+UapgQqIwAXFw67Jsge92AbDiB1x4QHiQBEcMpL9McSfllXoMQSeTdGeb1dBcDp3pUprj2NAbtQ+ZwzP7WPRXKfsXnRrAEHnKkgu52n2Q+uqNBa+RYpJhoY9XEwZtc26gDsWBWichui7pNvGNQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbb98a3f-58df-4caf-9372-08d85d8e8916
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2020 17:56:44.1891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0t81E3nIovoOA4ENAhKYvQefOelra0j2GDeECzngnejN/tQuahm14UE7hPfLWd0xcDTQgUXaQP95MM1FF7tWww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7486
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/18/2020 4:30 AM, Qinglang Miao wrote:
> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
> 
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia
