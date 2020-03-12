Return-Path: <SRS0=Vvbd=45=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5757CC1975A
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Mar 2020 11:05:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2918A2071B
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Mar 2020 11:05:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Suc6Ds8l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgCLLFk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Mar 2020 07:05:40 -0400
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:18151
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726000AbgCLLFj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Mar 2020 07:05:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NzcWPXNZ/PebIjDnaNktjWlxvff0qICiTdwMGb7MDJoHO4i8UCoKD/A9sKyLqMUoJytVgjv8BWcbsBmrquqvOyx00c8nKK8wmFFipSysb/CXBjE0ZDL9jG9NkC01365155v7k7ul4DmfN6Akn02FKMVqPd4tE97Y+O1llLN7APht0wApe5vpRC8SlGlJ+Nv0nX9MXIc/uaoKzP1UvFtHigdcQZ95NybMWlW09XPsI6jyLaL+uMSfwAAc1cMUylGcknQfU+RSV7CzGXlGa4qUKInRXDy7suXkyJyM90iL1YUrn93WI7YvYb0UonRUC+hGCoV2tTjOHwP8ZEi93SF9mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1lIdZcRK2geLIj1MjuYBqo/JJteAoss/oeooJL6p/E=;
 b=SeOGEQAp0Wt7TussL47yET49L6s4h+6h8pxd18PWiNdKb7k2xenj3A4O5h5ksXxDnyo+/Js9PQJ+QNcEz7twEVhKyzth89fdGCIiYO1UZQ1lAFRVgeouwiwYB+iZka75ZwiZ2j4a2bjIRiZSC42TWQXdMjkUCgI3ZMxrRycZ+btz/sYCbthCyhkHWwKvGsxJJ3wDKnrDysdETKC0dmScA8fIQKiCvN1BvKA3z+9TECA0PoQLjpRYLH/oceJZF0D2OXsSG1IyRKnxWkgQrKt1zrReXNxh1lJ4m4wxbxNgvuBEz4uqS4A6riNXwBAHHIcMeGHMcke4MxARPB3+1MKcRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1lIdZcRK2geLIj1MjuYBqo/JJteAoss/oeooJL6p/E=;
 b=Suc6Ds8lpA4ST6GMU+oCxzWwM+U0ia18KwEPmBaENofCQfBwBTAHpyHRafKkxtpTlUYHwg588MIyGHwtYWTR7Vu3P1M/pplAY3pu80E08b+1AKlhzaUCqMEYnbDzqAlDHIYhPysWSUABVerTvcKdkQiW1imHT43TCO0jZNk5KN0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2750.eurprd04.prod.outlook.com (10.175.23.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11; Thu, 12 Mar 2020 11:05:36 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f%7]) with mapi id 15.20.2793.013; Thu, 12 Mar 2020
 11:05:36 +0000
Subject: Re: [PATCH v4 1/2] crypto: engine - support for parallel requests
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Baolin Wang <baolin.wang@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Ripard <mripard@kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <1583707893-23699-1-git-send-email-iuliana.prodan@nxp.com>
 <1583707893-23699-2-git-send-email-iuliana.prodan@nxp.com>
 <20200312032553.GB19920@gondor.apana.org.au>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <61c28d90-af55-25a1-3729-90a622f2a7b2@nxp.com>
Date:   Thu, 12 Mar 2020 13:05:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200312032553.GB19920@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR0202CA0012.eurprd02.prod.outlook.com
 (2603:10a6:208:1::25) To VI1PR0402MB3485.eurprd04.prod.outlook.com
 (2603:10a6:803:7::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR0202CA0012.eurprd02.prod.outlook.com (2603:10a6:208:1::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Thu, 12 Mar 2020 11:05:34 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5db3650d-209d-4b08-bc58-08d7c6754a67
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2750:|VI1PR0402MB2750:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB27508D898E6BD916068D3EE198FD0@VI1PR0402MB2750.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(136003)(39860400002)(376002)(199004)(8676002)(81156014)(36756003)(81166006)(956004)(8936002)(31686004)(2616005)(4326008)(16526019)(6486002)(186003)(66556008)(66946007)(66476007)(52116002)(110136005)(86362001)(16576012)(5660300002)(26005)(54906003)(316002)(31696002)(6636002)(2906002)(478600001)(53546011)(7416002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2750;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cQM+Fn3okrNzbzjqRAouUyS1y4K7yAk8HvBTqTEIcYWoeno+fq6btNbrhB3yGPtQhiS086WXMXFJl+rd/jHUgAs9BypuIA34lFl1REC2+CEQW1NYqJn81JL6f+wRR0RrFvJMjCyHq3EXdsFst4y6dCNfnJWg582sp2qRkkZIDd3lecScGPSqy+eLSVj4ojYx27SiSK+4rGLFKXDvKZjlbC5DxzSvcxUBDwDoXRPMoAO57IpgZ83CUFjg771BEe/6l4+//+KaybDtuY7izZiDfX2CopSIsowAgofZy5Ey8aW+MExTduxFroA+3HRJRjHvUAW8Pt1/oJqdycajHcZnIgmrxGpptw/tWOhZ90qQg6xO2MLECRZbsfgecO/SLFFAbtvLSKwIHm+6Jr07NYmHYRg4WfDNh+JHQwPRDRe9feqlb2Eqf1COwWHqNvwJyBXw
X-MS-Exchange-AntiSpam-MessageData: SQAKCVhGKndEdYvouGnl7H9t1/BH1qCab4omtUC1eyuN/tMga1r1ci61CKf83OtrBbunxH5ZeRfW3sQN2uvrLFH9/k4rkKFajmYHYF2m9VrKYsGGbD+Bg0HwZU78EA2aGEGoKe/MbLwCdkrg39DBFQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5db3650d-209d-4b08-bc58-08d7c6754a67
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 11:05:36.0228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cPNxyI32/8nK7jmVHVTRMh8TysIbPC7sJ8jBzKIlG+bNoy7YYaiQ8vIJJhH+pyzjulq/OHy7w6geXMjLZaypdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2750
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/12/2020 5:26 AM, Herbert Xu wrote:
> On Mon, Mar 09, 2020 at 12:51:32AM +0200, Iuliana Prodan wrote:
>>
>>  	ret = enginectx->op.do_one_request(engine, async_req);
>> -	if (ret) {
>> -		dev_err(engine->dev, "Failed to do one request from queue: %d\n", ret);
>> -		goto req_err;
>> +	can_enq_more = ret;
>> +	if (can_enq_more < 0) {
>> +		dev_err(engine->dev, "Failed to do one request from queue: %d\n",
>> +			ret);
>> +		goto req_err_1;
>> +	}
> 
> So this now includes the case of the hardware queue being full
> and the request needs to be queued until space opens up again.
I see no difference when compared with existing implementation:
in both cases failing the transfer from SW queue to HW queue means
losing the request irrespective of the error code returned by .do_one_request.

This doesn't mean it shouldn't be fixed.

> In this case, we should not do dev_err.  So you need to be able
> to distinguish between the hardware queue being full vs. a real
> fatal error on the request (e.g., out-of-memory or some hardware
> failure).
> 
Yes, in case of -ENOSPC (HW queue full) the request should be put back
in the SW queue.

Thanks,
Horia

