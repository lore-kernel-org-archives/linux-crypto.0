Return-Path: <SRS0=I3Dt=5C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 838C9C1975A
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 17:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5667720714
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 17:09:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="hkR9EnP3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgCQRJJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Mar 2020 13:09:09 -0400
Received: from mail-eopbgr80081.outbound.protection.outlook.com ([40.107.8.81]:35908
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726082AbgCQRJJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Mar 2020 13:09:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bcJDcsmMG0ZaEO8RWqdO6nsyFOla4N5LaLA4wF97P2IDOP0JMpWzn8hNjpzxagGvPrtw0/gWr2rGUS3CANVy25fqYyIGruPL6SmeAswyWHeI5m2+h55ewbO4k279COXts8nTDVnpMPCMwHL0A+VE/+aEf9AkUE/m4U22pQEwc0R2/sO95HNN8MMd1d7/TXAvNmtOlYDsDuXX5seEV29dzsds0qv2vNaihGJu9YE9sc3Bcl8ZrQdwatQ/Qembfg5IBL6uHACEssSScv/mGCvtKibTOnbjw2zskb3j1j+mx+q/RkYyBNkkFohZ4D17txxaGoAgLRQPlf9/5ByzPEzI2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=awz/rUGFQMyKcoeVFkhlqae4AOKR48qP9rRKCtUa+F8=;
 b=PTpuf9+5pWXWKHkM8sT5sFI05OLCWBGNImdcS8h9v8dJCSqqVdX5PNSC0er/j8trLaFfalpaoglEoW0hZ3rYtMoovXvwJGcMR1m3WdJWg8jJ8Bc+BYgq6enNPWNU7mw7qaasdtzVSRcgZO20HrKFqh5u8IJ2U7RU5KWJ9A/5W3Hdo0m4z48H7pNHayvt4Xm660enC3rN8wpA/CNqLAf5dxxoXkFUExu/QKIuHy1RViGmjKllI3lCaDvJbCdO4wbJ9WfKg4w5PNRDzZuNv2x8gzXPfSF6yXqQJg1LP9j7iWrkTx23cfdSD3/apYbzhBjwCI7VPeNVAWeeocspUud+oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=awz/rUGFQMyKcoeVFkhlqae4AOKR48qP9rRKCtUa+F8=;
 b=hkR9EnP3ryW2A/MkmjwBSZIveMgyx1tn+lB1qlmiSlVRCVW+oVfDnhhHA4KRrvxB5wVZl6Mz6m94rRjM9tLVl67VuuGav52kHvy6O7lk220m6yz0ZwuZjBhCRIHn9L/5zwQW9Uu83PGSUUSrkEmpZc+9n3zBRI7dGYWFUYZLcOs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2798.eurprd04.prod.outlook.com (10.172.255.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14; Tue, 17 Mar 2020 17:09:06 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f%7]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 17:09:06 +0000
Subject: Re: [PATCH v8 5/8] crypto: caam - check if RNG job failed
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <20200316150047.30828-1-andrew.smirnov@gmail.com>
 <20200316150047.30828-6-andrew.smirnov@gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <7d5ad3ca-4ed8-1068-fb9e-4f66da1e3d88@nxp.com>
Date:   Tue, 17 Mar 2020 19:09:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200316150047.30828-6-andrew.smirnov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR01CA0019.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:69::32) To VI1PR0402MB3485.eurprd04.prod.outlook.com
 (2603:10a6:803:7::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR01CA0019.eurprd01.prod.exchangelabs.com (2603:10a6:208:69::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15 via Frontend Transport; Tue, 17 Mar 2020 17:09:05 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 893182c6-2c98-4fef-643e-08d7ca95e65f
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2798:|VI1PR0402MB2798:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB279885E979246E9A73EE158098F60@VI1PR0402MB2798.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(199004)(31696002)(4326008)(26005)(186003)(2906002)(86362001)(16576012)(81166006)(8676002)(54906003)(316002)(8936002)(110136005)(81156014)(16526019)(2616005)(31686004)(4744005)(36756003)(478600001)(53546011)(66946007)(66556008)(66476007)(5660300002)(52116002)(6486002)(956004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2798;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QNjXbIuh+h0L/ol79+ftCoSfSNw7tBYD7/zdgChBqe+qfXyYqFQY6qs8iQ/47BqCsX0yWOgExBhDUQVVFXbzRcRKe1zHaMlzBlM3QTg0lbBpZXjitVON2CnNarxhYJZZYUsJvFrJVeoyjOXjatJ7Q72EdXB9AmBYMyGtjOUJ5NZbyDx8cR4lERmPoi9Ch0iuXfVC6e68gPWwptkSNXeDUGakuIyD4oSyDIuvh7YBstD7ZqqXiE7lISa8sVHXxH123DHV07PNBxGcLVv+XV00FnI+PzgRBsrVIvDoC874B5AE3GTdX0pVsrX+QHaJpGkz4HFL/3Nv2AQmWfuhKOa67M9DTAvJewXXokdSgKpswY6N3WbZqQSckadnDZYEEctB+OBQJIsoaDGxn2FIDB/fcVsegRja7Ovl0UhyPWKsG0dbBSt4M52YGAuKtwfYrca9
X-MS-Exchange-AntiSpam-MessageData: gSDmML0ffua1AD6/5cuflGDjeZpq52nNSwcXhaf33Al4icpoVMBVt9RhUYDCPMRhHCVXIXJiuzEz8YW0IXs0TB34f6fRJvwT5yY05Mg4HTkW9k1MZncWY4n+sOM2XVKMWzBw8aUWM5i8RuztWyaFBg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 893182c6-2c98-4fef-643e-08d7ca95e65f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2020 17:09:06.2482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w7hIfeV5jWD5nHMXnn2sQb6izHgkdQ42nF11OaymJTxNWvb3des8KqXA1m2io9z5foyHPWMb99Qe+yu0FYxeMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2798
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/16/2020 5:01 PM, Andrey Smirnov wrote:
> We shouldn't stay silent if RNG job fails. Add appropriate code to
> check for that case and propagate error code up appropriately.
> 
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> Cc: Chris Healy <cphealy@gmail.com>
> Cc: Lucas Stach <l.stach@pengutronix.de>
> Cc: Horia Geantă <horia.geanta@nxp.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-imx@nxp.com
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia
