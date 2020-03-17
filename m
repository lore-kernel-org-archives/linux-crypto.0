Return-Path: <SRS0=I3Dt=5C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D18FC1975A
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 21:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2103520724
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 21:56:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="eXOUu/XM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgCQV46 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Mar 2020 17:56:58 -0400
Received: from mail-eopbgr70057.outbound.protection.outlook.com ([40.107.7.57]:62180
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726494AbgCQV46 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Mar 2020 17:56:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kiw92Yvyo/urpu4yoyliG7Ck5N/PjxmU0UlOMVodI4AcSU4stgpJpeynyiq3sv/6WUU9bskrBCiytyt78JbT9QqU4KHu11uxgZP/ZTd8hm/39WeYr/p+9HtZoi1JBm4K3wHouakKyekpLyWLdJ5i4fY9mLEs2jq/4lcMXmotGuv1y0IyMiCyzlEhVUd/Pnn4Z9BwljfHxnz59PQ0SRn5ji08MSK7oGaOudR0B/CTXG+XjZPkd0oDhC3bot10UNYozOZqSH3r4YrugfxYLGi9b+GrpuLYG95O5bbzLec4WRXPq6Lecfx1OoTNsPobGh9s6vZhKV7OYa6CLI0Te5cX8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2O0ZZpn957wiJq8BQ0Tb0ByDPyfYJRXWoqRiWxVVWMw=;
 b=PvsHjrzLfHrN2+bYVb4dOmcq0ogxcP4pzk6KPecozji5113rTSAztEpldJ9IIpTyerZ0w5iFl3piyQVGAuqxacX5kzcKvdF0jqXJIYNGeIOSFoifdbfsRfbtyIrKskXMEwzAxFhNTntqgeI1b+SngXrQdkO1BIznwPcs6DQlcdKBrJjsgsZtPpK3b2N6lH8c1exibY8QAi7VDWBwm2Q690y9rIawC3Tj1zASWbR5vVZ1sGE4V4L87m+zeyk9OEmdXatXb5zfbhYyqqLv0bIk/Nt43y5v64hoX0e/8auiewlEU3WgYW3LM/f/77UGau225Cbf57CJo5PLIr3Dfe8YfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2O0ZZpn957wiJq8BQ0Tb0ByDPyfYJRXWoqRiWxVVWMw=;
 b=eXOUu/XMxwhU39VDhGVDzdkDZodxpswbVLG2MxDmBfkBKi2tjFfzKMm9vUhYeBlsEGykl1glgUE78cloG87Ti7mAsxLZK/3TGfzC5yR3CXfBu5ujf1CEOZcFk59Y3L4fyDrlEz5hLHwgaIb572znQdeVL7PrnpQcGBI93RLr1tQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3919.eurprd04.prod.outlook.com (52.134.17.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.22; Tue, 17 Mar 2020 21:56:52 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f%7]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 21:56:52 +0000
Subject: Re: [PATCH v8 8/8] crypto: caam - limit single JD RNG output to
 maximum of 16 bytes
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <20200316150047.30828-1-andrew.smirnov@gmail.com>
 <20200316150047.30828-9-andrew.smirnov@gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <a7644ba3-188f-f881-ad38-adace986011b@nxp.com>
Date:   Tue, 17 Mar 2020 23:56:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200316150047.30828-9-andrew.smirnov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM3PR04CA0131.eurprd04.prod.outlook.com (2603:10a6:207::15)
 To VI1PR0402MB3485.eurprd04.prod.outlook.com (2603:10a6:803:7::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM3PR04CA0131.eurprd04.prod.outlook.com (2603:10a6:207::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18 via Frontend Transport; Tue, 17 Mar 2020 21:56:51 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6846c386-630c-47c2-e115-08d7cabe199a
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3919:|VI1PR0402MB3919:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB391997BA049E820A9FB4CF4598F60@VI1PR0402MB3919.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(199004)(186003)(26005)(8936002)(81166006)(16526019)(81156014)(45080400002)(2906002)(8676002)(66476007)(6486002)(53546011)(66556008)(66946007)(4744005)(31686004)(5660300002)(31696002)(966005)(478600001)(52116002)(86362001)(2616005)(110136005)(36756003)(4326008)(54906003)(316002)(956004)(16576012);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3919;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EmbaIleDgp0DFh4HwZCmUgkFGade844dXlbOqpBYx17lWpMIt/GCzVHawh60Rmv6puaQBCQps3vdKhBqQ4Rb2zfSgw6wm4fE11wDS2uC7JJGtz1Mq/9T4lrkr21M4YumRb9nWLZubyFeTJpNGa14c2v/pozxMjin+3XoYCT4gs+nYuM4IdI7jpZA28TwS8l/sAV+zNziKxaVzZGC8H32e87+E1b0dLXs507ywDzSdCYfR4I8cdwzQ+b7QhXRzj/1HlL/vPGkn21TZZAiNVEWc3mCoA7VHthzBGb5oGSDvPlPIz/v0M09SqxxFW6b3rxo2XN7L7uvWBwZ60FXg7YYaYJ+elOaVwn/5q1qR3XnwuZrR7DejivziVNwutFi33PDrsFB4IimebLMdxVWxB83Ay+jmJseLPzCMfIRT9f6+agUw1RWZjv7hJZRrFM12MIwnfKSlXevUWqHdNrFllcbpz08XEDKTQvpZbbfzWpZcSqI+zI0Y/ho+0waw/XpN2ykEGnOaD24ZvoF324pthVJ4g==
X-MS-Exchange-AntiSpam-MessageData: 2TTtlajOpAkImf+lpqoGwQC/2fQdrTc4Ft/uwWLHrfVhso5UC1k3jnvLFBtEx+TXUOBo94q+qHmeqG4rQvGhY+Zte6G5W3u57WmIqzv33rDkqp0BXvGnT8jXhoil3BSOSlHwX8JroLJc4X+Jn/tBIg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6846c386-630c-47c2-e115-08d7cabe199a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2020 21:56:52.0610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7McI0x8nMpY+bMnN/bk1EzJmSRH6gFP6WOKIsWV1flerkO52Au66UpCKTRH3gX5RWQxHewBkUcg5e8UbE1nngw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3919
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/16/2020 5:01 PM, Andrey Smirnov wrote:
> In order to follow recommendation in SP800-90C (section "9.4 The
> Oversampling-NRBG Construction") limit the output of "generate" JD
> submitted to CAAM. See
> https://lore.kernel.org/linux-crypto/VI1PR0402MB3485EF10976A4A69F90E5B0F98580@VI1PR0402MB3485.eurprd04.prod.outlook.com/
> for more details.
> 
> This change should make CAAM's hwrng driver good enough to have 1024
> quality rating.
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
