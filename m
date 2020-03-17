Return-Path: <SRS0=I3Dt=5C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA9BC10F29
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 15:22:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1ED0920753
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 15:22:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="i+pMiLx9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgCQPWm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Mar 2020 11:22:42 -0400
Received: from mail-eopbgr80071.outbound.protection.outlook.com ([40.107.8.71]:28037
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726680AbgCQPWm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Mar 2020 11:22:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Edpz9KS+zRQI4ZXY6TwIxeedLZ2hTjIDrI6Po/Pw+/7wr/ERiQQDwY0q/lXUjb9CtTKDNvFy9ah8dZbXW1D9eVRfrLXVJGiZ4xhKUMsBZyZoJ6/tp/bqlehHH3nBXYcxsexNBkJ2uDZ9fnmhwopw2oXaP2Z9wFSkFIJpSKFr3M7EW75asJRiwGgSnkmmpuLQhmQiweyATRYw0Q4EpBu19wyZfBXdLU06lO8ri8DvSUDqR4POZTe3QqmWMH+/kigjN3EeoYZ8Ffd1fe5FqitbB5qnfPjTQD3iywY14O4PuJFW5puGZ4CZAxuYvqJXN1cSVFkm45Tg8DtQrj9+bj5lRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CtvoUSFKYiSSLyg+97nlOXBduv+T7HOVM/TzbzbpeU0=;
 b=K5jgTAkfn66GyYZodd9YGr1By1ItqoFP3sPio4DemVb4GPOiU+7FA6R4fivIaEsWKiLL45n8IGT9QVLO1JUC1ZkklKERn+x2fESc/uY2ml1Q/fbnjC42K2mLMIiA4qwpfdiGPh9K7jh3MhUYeXKZSpcmmUHX5WDRXy8bexfQhOXuHpTmz8iEZq0GyRtib1H4HPIQ6g6k4JFo0/6UTt2a6rMVqhakPnCzu9ijZUoHCOX++3k7mOjnEFNM2vF9awGfIVOmUXxs6ss5uNcW9YcO8MybExDofW/ZQiiLUjlhwcs7hjKVeLJJeFcv1wbAQWvF2Gp5WDwQ2D69POi5nl0sNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CtvoUSFKYiSSLyg+97nlOXBduv+T7HOVM/TzbzbpeU0=;
 b=i+pMiLx9/6qLRgbh3v/xDGewvUBM873Owmsj6Pgxtb6Ek8AU1S5NGRG9E8CqTHgqlvt0R3BSElutG/1ZcEv8ugWfN4rPHqO44DI3LwdLQZMno3aX/yADZq6L503iAB1f/I3wxJEyC+bRbOe9soyqBrmKIXofTPUD8XP5Sez8cek=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3855.eurprd04.prod.outlook.com (52.134.17.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Tue, 17 Mar 2020 15:22:37 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f%7]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 15:22:37 +0000
Subject: Re: [PATCH v8 1/8] crypto: caam - allocate RNG instantiation
 descriptor with GFP_DMA
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200316150047.30828-1-andrew.smirnov@gmail.com>
 <20200316150047.30828-2-andrew.smirnov@gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <97b01e42-41f1-e0e8-59ba-9df957392ede@nxp.com>
Date:   Tue, 17 Mar 2020 17:22:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200316150047.30828-2-andrew.smirnov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR06CA0071.eurprd06.prod.outlook.com
 (2603:10a6:208:aa::48) To VI1PR0402MB3485.eurprd04.prod.outlook.com
 (2603:10a6:803:7::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR06CA0071.eurprd06.prod.outlook.com (2603:10a6:208:aa::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.21 via Frontend Transport; Tue, 17 Mar 2020 15:22:36 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a6eb5b7c-4df2-4fdd-c05b-08d7ca87062e
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3855:|VI1PR0402MB3855:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3855263B451312439A51596698F60@VI1PR0402MB3855.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(199004)(110136005)(6486002)(956004)(2616005)(316002)(16576012)(54906003)(66946007)(26005)(478600001)(4326008)(16526019)(186003)(31686004)(2906002)(31696002)(66476007)(66556008)(5660300002)(53546011)(8676002)(81166006)(86362001)(36756003)(52116002)(81156014)(8936002)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3855;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aeIwTretd2k7eFZzCg7OYv8zvSBYvVT+doc+sLDtgBLf6Z5CqZzBAF2MyMaPkOseKYV9VjdqqJEBfhSwxKrHvyOf729/Xl2WmGBNRgtHIJNMnNBQMEX+rCWARaCWcY4o9uG768AF8l+rmLDFHXhZ8ov6aj7UxNl9tKkhkXPgFULnyZ1HyGD/qe6FiU8WtNoOS6RfFMz5wlyIcEG2bhCXu9xFN8Tp0IW5+88m1CK70dCPV68gPnPKiH7ljhwcroAYNJ/p+KFfI5N5Zsqg46uf3OuJX3gNOfH6e8Ex9JFJTf/GS+OQuSu+GoZ9wmmGZT4YzwIbLRZ4irlBLKKOHymN1G9is2hZ7UlL7TxP+E8Two40spy8Kf2La5hjhtkezsL1G1+VIAUV3JrAah9eB6JzjUjMWqM3OvbzK8GYsZ/JdD5H7fYUjovXE11b8jr7Ny9R
X-MS-Exchange-AntiSpam-MessageData: 4OCxu7VQwi2UiqLuCDQ0xCKFMGrFPD+9rEJ62bwXFqZeqfbfmk/j1UiqszQMOEmGZfhrWpg4/sfA/YZUcQPXy/sOZO5mfslU09JlNNt3oX88af25UPIqPL40wjfKvDImzDeZExgfFjWIVyvYFCxjrw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6eb5b7c-4df2-4fdd-c05b-08d7ca87062e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2020 15:22:37.1006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GPzjTZPCWZIUistiM+XWbpkZnT1iXPWqvb5MSIT33mMVfuaXerE9FC2omMKg8Jo0Rkn/6YbAzg5SJFCK0qv0og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3855
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/16/2020 5:01 PM, Andrey Smirnov wrote:
> Be consistent with the rest of the codebase and use GFP_DMA when
> allocating memory for a CAAM JR descriptor.
> 
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> Cc: Chris Healy <cphealy@gmail.com>
> Cc: Lucas Stach <l.stach@pengutronix.de>
> Cc: Horia Geantă <horia.geanta@nxp.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
> Cc: linux-imx@nxp.com
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia
