Return-Path: <SRS0=i4aU=AQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41475C433DF
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Jul 2020 18:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AF4420739
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Jul 2020 18:35:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="f4VrK8XS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgGESfF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 Jul 2020 14:35:05 -0400
Received: from mail-eopbgr00089.outbound.protection.outlook.com ([40.107.0.89]:22909
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727855AbgGESfF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Jul 2020 14:35:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C7ugQxwYFj3o2OsPgECgIUjmMcSSmw5ZpfWIGqGeKBcq/tWMu5Yq3qFxuhIXrEiwikhs6NVnxNJue+KcT8F5OGOZy0A28gRDhIzK5+YjxhnFPVptHnZDdQ8S9c0aML4R/XGlci0X9MylghkPGRrFUTU2eOxOtLk+JCH1+hK1RgzShfD9IZuj6M2f7Nvmakc327mTxfpixZHRTwNBwD8yasbjeGyO8gxd70jsLP1tBtv/QYkzT5DHW5N4TRttRA7+t6UwpGoyYDKGAM4rEe3lbLvlHg1qrOSdakb/5i6Vs84ROYMVbeT3977Ekxvjj91s2U5hLa4ICFcP8dpeDsfxYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gIYstVLI3h/ehXFbE3+5YwvDfwu6p6F4bJKgbyY8OBE=;
 b=dy5puefPBM01znmjTe70FLMmCbWJMM02yQ6dsySiPKJrXjG7bihdxPhBbClBKlv94hZIZGwdmBsZvxhIIs1MSRWT+eZ4Cc637bGC8atSTX0XL8CoGwtL7kpXlAywHp4GJcPZpoYtz4zxaf7uuP+c6b/y6JSBet0D6cOEE+7fCIPZSJILM6DaQ+E9OhMdvNITgar1JO7dNhUA+XACo9MP44QWgmk5V7SyCBY1cX1B79wIAv1+R87lCwlQ0acKfmeYWNyukk7/qhZE/OcfzOQ5UzKvbKGCinugeUEEnmJMU+f8EhXM6+VAS3JbQlq5pNhJhymGMYce0wPN6Je+GvPrHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gIYstVLI3h/ehXFbE3+5YwvDfwu6p6F4bJKgbyY8OBE=;
 b=f4VrK8XSswPzuxmW8ugX2vZZtwKP8jE1seb5fGkJGKTI1Hm0CDpHRqbejVf0L9PZk96QfUpDL0TCmVrc3HAhbN4npEphexJBJ/4wlNKC4YWP38uKKuT89AzYBwpx5BXy8MaspfSKZKd3oS+Ql5Oiux7KlzMBWnBUrhE6LG+wMu0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB2973.eurprd04.prod.outlook.com (2603:10a6:802:10::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Sun, 5 Jul
 2020 18:35:01 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81%6]) with mapi id 15.20.3153.029; Sun, 5 Jul 2020
 18:35:01 +0000
Subject: Re: [PATCH v3 12/13] crypto: sahara - permit asynchronous skcipher as
 fallback
To:     Ard Biesheuvel <ardb@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Eric Biggers <ebiggers@google.com>,
        Tero Kristo <t-kristo@ti.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
References: <20200630121907.24274-1-ardb@kernel.org>
 <20200630121907.24274-13-ardb@kernel.org>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <4a579052-5af7-1d3b-f1fc-cce72c1ae60d@nxp.com>
Date:   Sun, 5 Jul 2020 21:34:57 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200630121907.24274-13-ardb@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR0902CA0015.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::25) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM4PR0902CA0015.eurprd09.prod.outlook.com (2603:10a6:200:9b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21 via Frontend Transport; Sun, 5 Jul 2020 18:34:58 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0ba5c1af-4cdb-4ec6-d94b-08d82112208b
X-MS-TrafficTypeDiagnostic: VI1PR04MB2973:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB2973CF500310F20D6AC9332398680@VI1PR04MB2973.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 045584D28C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ihq9w1DAyOgHgj7aOEykFwCIWx+eHWsb2OrWPQnJi2zdBg1cS3KhnG1vuPitTu8wfi6VcJsC2m27yEHkN8W1qIg4bjnM0KYG4dZPiifbSnKwbo6chG+OsIUTVK0htCqFl2Ua50SaCyjIcvDqTrLnx1jSDO3/9UfmEgal+QXE0+mWpfyO3JZFdnMO5XPFKrVKeHTWJ6VY1TiL7rSVWeRyqTnlOmIrTh8V3zpakP/YY6oHw1DCULWtYowcylh2lwEl1R8/3xbgYmcmhdvDxhhz0JhXOAwQolQglOUGvAxCZz4uiMlmjs3zwBvomaVD3NwIxS+qWznh2wlVNIfVJFSeFDPorhgjMYx/B1V9P60nnPSWwo03zxWuYf3+kilib9Ub
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(39850400004)(136003)(346002)(110136005)(54906003)(36756003)(6486002)(52116002)(53546011)(8676002)(478600001)(7416002)(83380400001)(316002)(16576012)(2616005)(86362001)(5660300002)(31696002)(31686004)(66946007)(26005)(186003)(956004)(66556008)(66476007)(16526019)(2906002)(8936002)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: IOG5ZthF3ERf1Ye4+GrPoaucigtSKQB8d2SMDEm2lCTMromtJFUKMoAAIui1x7FxEPL0tanY4yOjrOKe/ouzgWgpKVsZH9vvsICDie0NLuiVTqemLadET2irNMagmYyd6GVnioPG4N3ub/u7GFpJQCqSiAMwFCeRt+solgYvJuETmC4Oub0XnGXUi7sxGV/vzGh1a+eQR54bKkNPaUE0XqkUNQ0YI2xjbJyyY/Huasg5xDKvY/R7ZL+YozlCyzBNoWpkD5soJuwRLniZ28pkG3t3d4U0wOjhKuRdV1LNVN8/BAHnhvo4IZPqM/3m2xbKzR4u1SLiUo7EJ76ONXojgUuAJ8IqEjIv8nfOy4zpUGRqdJN4CHEm5CupAEYBKdYt2c+DweYMZSXk2EhUQ0hz3vYaJbPhz1VGyn4a9byOw9g6R4cmxcP3li0p0H0JUK5ah5FmguVX2JR3RYQ/dOKPMJ2gIakAYnE4Rle5xl3XABud3/Sg2FI25qJsx+DlGJ8l
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ba5c1af-4cdb-4ec6-d94b-08d82112208b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2020 18:35:01.4507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lZ3jNbHhWoRNYJhb1jaE2msbUHg6mkrirliz5V+ndQpEVR7UMCkiVkZcVqkvLO9lenFBUd9QuHgYMnkNZhFyEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB2973
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/30/2020 3:20 PM, Ard Biesheuvel wrote:
> Even though the sahara driver implements asynchronous versions of
> ecb(aes) and cbc(aes), the fallbacks it allocates are required to be
> synchronous. Given that SIMD based software implementations are usually
> asynchronous as well, even though they rarely complete asynchronously
> (this typically only happens in cases where the request was made from
> softirq context, while SIMD was already in use in the task context that
> it interrupted), these implementations are disregarded, and either the
> generic C version or another table based version implemented in assembler
> is selected instead.
> 
> Since falling back to synchronous AES is not only a performance issue, but
> potentially a security issue as well (due to the fact that table based AES
> is not time invariant), let's fix this, by allocating an ordinary skcipher
> as the fallback, and invoke it with the completion routine that was given
> to the outer request.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia
