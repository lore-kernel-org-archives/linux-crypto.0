Return-Path: <SRS0=i4aU=AQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23DC6C433E0
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Jul 2020 19:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 000F82074F
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Jul 2020 19:11:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="BC/CK6D+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgGETLN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 Jul 2020 15:11:13 -0400
Received: from mail-eopbgr60082.outbound.protection.outlook.com ([40.107.6.82]:51751
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727781AbgGETLM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Jul 2020 15:11:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VvgcSEjUf/xzVqXNRiPzSpIispyX51MJSCAx492lZCTrbW3vJkWTcDaXnb2S1ISH02H/WlDCuaQDKxoetvmV+UQRQRArwNTez9mIDpuTQPvWpPlvVd4bspkDF1EsGeY+tTX8/uS73A43wyS5P/xi9dtmmV4ueMF4+omVWLvH+s6MjPVOxgLpubc2LCaaPUX6nzfskKrdItn1V/dluZ2igVb6TOX/F41SHn0o34F+yHuoVTepJ3hDMIeyNbvF67uWmsAhVnTT4wFG0pqlnnw+e3WE+O0WRgkVo5ioSGahUkR+dTX5wI3RRKV/wyPxnRjH2Tz7PjoRIf9C3KUNnwL3KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v7nmwCoiPjaBAFbGlB1pHt+6ps2D7DzcIkYXTetOaBo=;
 b=lWY4dSe2lwNqMHekKT3BAx9zfPrWe4888aMuQ23JvBKvgGVFkTpr7T6s5nbezLoxM/QC7GLjIVj2pXvUb/aacGRi8HZmi7TB2wAQHJWr0rkWJsCi8H8b1HLOd+ez9W9YJ/pJM6Wl6+VwsYUXMKXDW/3XHPWe6b9JLsyHCHLcVOlykaF+YJsFT5HXNnVVbksFvMYjZ1As6AiPPhh5njaX4kuF8+mOmpVldcdGV25Jn0PbxoLWCDzEPc7YavXACNRwut3MAmzYYfhaRBgGEi26mG9lYlSCEbc8XZ5JYWtcEcsFcuqhqnoRAlkbOvgwGiMNKXvPLtoj5hnhy5HHI8JVwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v7nmwCoiPjaBAFbGlB1pHt+6ps2D7DzcIkYXTetOaBo=;
 b=BC/CK6D+pdcpEnBE7nFlaRfWyvH1420BBCM+sBJNG+EVXPoXUnKoPpqDlpWuDwyW19MWGcXyhYX4/dDF+O05Bq5LyfsQFZprwhugG7BEjYgTfpgCC0AccttqggNvLeT2zaYIOr4cHsVgLVJAqknx8Hcw5WKfTfNa5+t7gyjiTR8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB5583.eurprd04.prod.outlook.com (2603:10a6:803:d4::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23; Sun, 5 Jul
 2020 19:11:09 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81%6]) with mapi id 15.20.3153.029; Sun, 5 Jul 2020
 19:11:09 +0000
Subject: Re: [PATCH] crypto: caam - Remove broken arc4 support
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Ard Biesheuvel <ardb@kernel.org>
References: <20200702043648.GA21823@gondor.apana.org.au>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <31734e86-951a-6063-942a-1d62abeb5490@nxp.com>
Date:   Sun, 5 Jul 2020 22:11:06 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200702043648.GA21823@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4P190CA0020.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::30) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM4P190CA0020.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20 via Frontend Transport; Sun, 5 Jul 2020 19:11:08 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 45733bfe-87de-4ebe-acef-08d821172cb6
X-MS-TrafficTypeDiagnostic: VI1PR04MB5583:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5583ECAD1B8614A69FC6555C98680@VI1PR04MB5583.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 045584D28C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yb0jZ+nRQDg3TwSuL4PaeyT8w1bJpyYkkewT0ZVWgHBxLQ5Vh8Uy03mV11bvGzvvyvVwQzvVCmUGYTWxAknweJpene5PyLtvI46SBeePVqk9y4PYj6B3YgQJ/nDFvAwqrDFu96Ib0EPFbGXdbR0ln32DcM8MLMjpI1o6z+lDO726QkbHDqAxphGNR6Elj7hcdzL/e0Foe1Qf5cpdnv5lWGInIZ87s3+izNO0ih6YMVfxselblBCHJVKMOCgVLNDNkJnVK/dL07CsAizgHFKmMNLpwKtDUyJ1DuuIiWfVaIHnavNbme2aCagikL/1syukQyHpTxwPwZFIOYOITqY277mFi+Em3lyBkiZmPzO27LXx4r06yopNSPdTEtZt4cViQCRGGwK3z9voLyfaJW+aIfKtJRXurqg74EAg27esxyS68SMttJP35q5pqWBh2fT14BJ+w5XnWzRnaof66MLPRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(39850400004)(396003)(136003)(4744005)(54906003)(31696002)(16576012)(316002)(110136005)(5660300002)(2616005)(66556008)(36756003)(86362001)(66476007)(66946007)(956004)(186003)(16526019)(478600001)(966005)(26005)(52116002)(53546011)(6486002)(8936002)(31686004)(4326008)(8676002)(83380400001)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZQ7nQtXq5dwqHTeX317Pg9pxT8lFLzfUfAP7PEfn9j69j7UjF6+g3/hdD4kiVZQdROD7qgc3dEbGl7wd2Ezhb5e6gjR0KsgTi5QM4/4Asiho1lg1GXIuxVmngPGHs6xzudXEJnfHApA2odShMV705NLysbx551Ly8gId6Bt045SYZVofLadeatNmlBAL6J07dBpHCN7BZQfW+7x7Cx5V07MHccfbAn2muu11paWAsF6YWzr+dnTmSEzW6MiiW2nF7bC0SvK8kgcXKxgOMIMVBVDNytiTXhxnUksI7V5tT+DyKJxFw3IMXQ3Bd1+9D0Mvh2KRRcdIUlpVRxD4l7KDaPeephr8RF8DtJB0Odc+FmquO1XS0/e1+vhytk5rJz5nskbbHmWB9duxSOQjoEvtz0CJ6ubmhZQjcGUrqB6C9k0jWuXzd6nblgN3vGc0DMiW97csmJOQ+29L1mh2zzazvJ+/wyackrSHlCvCy+jY2aqWvIpxru+bRndgxKKQXU70
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45733bfe-87de-4ebe-acef-08d821172cb6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2020 19:11:09.3757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rUL9/erx8QTWY69hd594JOUp1/qWFg7QdIdICEEg9SNRjNIoZOn2gPzOuaXQmRmt9aHZcXwYh0NWr7rPB0rDUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5583
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/2/2020 7:36 AM, Herbert Xu wrote:
> The arc4 algorithm requires storing state in the request context
> in order to allow more than one encrypt/decrypt operation.  As this
> driver does not seem to do that, it means that using it for more
> than one operation is broken.
> 
The fact that smth. is broken doesn't necessarily means it has to be removed.

Looking at the HW capabilities, I am sure the implementation could be
modified to save/restore the internal state to/from the request context.

Anyhow I would like to know if only the correctness is being debated,
or this patch should be dealt with in the larger context of
removing crypto API based ecb(arc4) altogether:
[RFC PATCH 0/7] crypto: get rid of ecb(arc4)
https://lore.kernel.org/linux-crypto/20200702101947.682-1-ardb@kernel.org/

Thanks,
Horia
