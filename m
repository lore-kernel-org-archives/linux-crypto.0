Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC324ECAAD4
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Aug 2022 15:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344604AbiHZPTV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Aug 2022 11:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344582AbiHZPS6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2022 11:18:58 -0400
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DABDEB6D
        for <linux-crypto@vger.kernel.org>; Fri, 26 Aug 2022 08:13:00 -0700 (PDT)
Received: from pps.filterd (m0150242.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27QEnImd013269;
        Fri, 26 Aug 2022 15:12:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=OfU6fEDEWTZjzY45xTIqcCN3YnoQim4rMspvj+j+s/o=;
 b=Rr7Pzi/rVX+6sunAusEsHI9nTLsltS8qxhYm86fMbpiqwQL1B2G0641Q/Jv93Uv90GKA
 c3KaBSdXxyFuyQeupzR2Rxsxjq8+GdS+Vshwfq8Fb7iAu9PhzqbueshgRBW10ga4Q5e7
 z1zRDDGApKK+b6RU92BUYBJx9pBER3zE29iQ4NuuxNxoaOw5a06YnxKxR0AddWqJOJ3i
 LUvsg7m6BLn5uTaPyEa49Vp7lOZGGN5xBvgsWIlbnwY+ihdlhrH89LP3ya7RYoFAbRQw
 ekBuicgNk3Vzb0C/sO2ZTqVGms6kYnEi6r43oq5ajfXhHCI/3UzjK1tvf6xKVO8a5YWB 4A== 
Received: from p1lg14880.it.hpe.com (p1lg14880.it.hpe.com [16.230.97.201])
        by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 3j6yma0mya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 15:12:27 +0000
Received: from p1wg14925.americas.hpqcorp.net (unknown [10.119.18.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14880.it.hpe.com (Postfix) with ESMTPS id B7C9C806B63;
        Fri, 26 Aug 2022 15:12:16 +0000 (UTC)
Received: from p1wg14925.americas.hpqcorp.net (10.119.18.114) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 26 Aug 2022 03:12:12 -1200
Received: from p1wg14919.americas.hpqcorp.net (16.230.19.122) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Fri, 26 Aug 2022 03:12:12 -1200
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 26 Aug 2022 03:12:09 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=khcUSxb7dHXPtH5hqYqlY+j8cBdLZ+6Z0BDP+AtARynxZwqj4/Bq4uM/dW1TycKQefhS6WbxTw/Yda98jiQP4t/1dbZzePD/ADOp3HHgQae8IDFXdjYnW66fI7wdRGj01DAp1Y9ElojJeDclLRwLugpTe/kDisax6W9biriAopmclvwRVZyLg8p3c33Fs01gEPAMc5ZPGW5g6GpEPLr6VkaRIlmC8De2P4RlacWpN3qJJdSsxguTx4VP+Sb+nmIxO/DRTyDiSpdEOhxjgWu1zZcOyeqBmwujJ8DoKaDbM9Ibmcfga+Z9Qtv00hFfZb0PvkqpEAs5f17GlJawQ8IiGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OfU6fEDEWTZjzY45xTIqcCN3YnoQim4rMspvj+j+s/o=;
 b=DjZZnv6ppkSNWYLr+FYj2iu8jYEa/0Y1VJOs8x2kAt56wP75jogYoS4wPw/2wAyfkfo6R6yhvtmGp3oQDiiRLeghXrCZny5Sz/4WJTw97Nm0ms05D0SAVkFfQOgCUHlYKGNT12edB8hJnugp71b/fCjoo0nBj0W2WhgX1p3C6GkhRob0WSo4tlOj9Xj1ZoasCKuI1ImwsaXUzH9oCAleu+tZ5ImwcjxJt3ILDBlvsxMJrf/zPXWFN9vd3DJ7YGldUyT0dClUWC22tTbbyLBj3mgUogL0ndU3MEwjIQe+9kixWT+KY2w60G/UcyyS9QGwwpSQzt37dGXJVyOvlZlkPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by PH7PR84MB1701.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:150::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 15:12:06 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1cc2:4b7b:f4c5:fbb4]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1cc2:4b7b:f4c5:fbb4%5]) with mapi id 15.20.5525.011; Fri, 26 Aug 2022
 15:12:06 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Taehee Yoo <ap420073@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [PATCH v2 2/3] crypto: aria-avx: add AES-NI/AVX/x86_64 assembler
 implementation of aria cipher
Thread-Topic: [PATCH v2 2/3] crypto: aria-avx: add AES-NI/AVX/x86_64 assembler
 implementation of aria cipher
Thread-Index: AQHYuQ01HRji5wtnCkWSODGF8l3nsa3BRpeQ
Date:   Fri, 26 Aug 2022 15:12:06 +0000
Message-ID: <MW5PR84MB1842DCF66CD8692D99545D98AB759@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20220826053131.24792-1-ap420073@gmail.com>
 <20220826053131.24792-3-ap420073@gmail.com>
In-Reply-To: <20220826053131.24792-3-ap420073@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd93fbe1-be4f-4880-4475-08da877556f1
x-ms-traffictypediagnostic: PH7PR84MB1701:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e9ORGko0mZp+EBz0LIfPrzutOLCrwN2LtJxmj9xoq58VK7vXmZuVECJgcDuldsCcPxpz2tcCxDuNAFtllPhRjkKnomepIO157M2y3iW1C1qw8lLlUdOKiWT7FZpJoweMPBsnd3h81E+6WNcrEX7ZkE+iWbY/UnGn/0BzdZfaYOVy51ZW0XE2KjFQRFlu1b/YMxTr1Lz3VnmXppc9x0z8gc4FMWcP7UoLorpUIOG5MBvFtV+7k35raibwjFs8emBWPGzskIL6My5kkXLc9YhxOHelGz2K0/TcDoA+yunQGia6O/3zLyStR/aoVZvuKRhSTQQP5MDazf9KQoCMgutuRGwIuflfaToPDzs9Q60I2sS2BynJUXZMUL50wrb4PAFRrsE5d3O7cQNGo4xFGufcTt2KcHWZH7sgRzvTHcBZVXYxD9taQiOFUjq65fkYktPXLuRa97x8k6AOlkYauYHJmgBBlANsuzW1dX+Vc0zWC+KUnQGy5dkc7ogacV/aB/u4VS/zSED7P7wiR4SpHurr6Nmo0RP+lEqxPhWqpSEzNs0ckb3Ulv5sIexKSdH9fp4RpLfW89hxxXTwva2CPL4IoPuaTz5gLQXAwBjbh3DhLPIPICYCo1H2p0fuXar7loZkSy0CFY5uNDES7LGaRC+e+0RXk4wd/xcGALAp2WAA9tAiILeS4W2XTemQGsZvKOHItnWxwVGgaqmNtZIJcibD4YChNtX4G9Pgr4ClEgRBsEGg0M1ZcSP64whH4BJWnLqRyJp/VpP6rn+6m10xSCg3OjLux1kwJS9PsMkqjh0hBAM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(366004)(39860400002)(396003)(38070700005)(5660300002)(52536014)(38100700002)(41300700001)(478600001)(8936002)(83380400001)(7416002)(122000001)(186003)(33656002)(86362001)(9686003)(26005)(6506007)(8676002)(55016003)(7696005)(2906002)(53546011)(921005)(76116006)(64756008)(316002)(66556008)(66946007)(110136005)(71200400001)(66476007)(82960400001)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FqdOZYyURXAGtPAsCf/BrcnL9GwQ5tJavoJavR1DEcYpgV7+FtVQnYP8fa7b?=
 =?us-ascii?Q?3qY8U2uWe0uLdjhXloes0zB4PMq+12Ijw7jmA8TQ0AJEsnrTae+y2T9DNOzc?=
 =?us-ascii?Q?bnVNv+y72xFuWAxx8TEmlGsUPkLuz0N5U1RdXhisKWBLmEeP+E3bv7HQdHYR?=
 =?us-ascii?Q?5Sie0tMaRGhTJJRNsHEDeBSkgEA/WGYdGWYCLdabEZBR7wDNtPifGwBmA2iG?=
 =?us-ascii?Q?sLk0QqjxpSt1Of9nxyjt5W/HiIOHa7ac7NMJ99dVo0tRie53h/Sglh5npkVy?=
 =?us-ascii?Q?NZ2laLeYkM1vTBHEerQOBYil6wYhabm5m0xPiKZyXUL8rxWeA9Jq3Kf/f3tY?=
 =?us-ascii?Q?1O0Kc6LeZjyX2Qaz7j7ibzrjYMmod6hbel6//6g5GZbE+jzKIsVFziQtSGSj?=
 =?us-ascii?Q?27bHLn7VFDgvXwDkyUIcM+6GOvmzCbaf8jM/jFqfvrvOFlbyTzVf5goiOVfR?=
 =?us-ascii?Q?G6SnFZ7Vze18Gy1bIsALNO4T+tp3+wLEHA/00UN9aooXjstQ0hGmF1wYPEGb?=
 =?us-ascii?Q?2GzM/eOAD/eZp78B1wUsZ256rk7Fg+82IUTz2wDPrZbXiuMyGuvQmZ6v9/KV?=
 =?us-ascii?Q?YZJL5mnlAruKDwhm0RTc/B0DEae9OGVlwjIRsFWglpgbApSeHJlw0noNCmSk?=
 =?us-ascii?Q?cWwqpXE9g9ivzDRQiFS8xMZ5BvxYXZNAjXVeflKt4gZCB6Yur04zhxRX/CxO?=
 =?us-ascii?Q?whZwWaFCwxvBuQBfyMTMHhswCKEnf4QvQprbLK72Qf3fPl2FCc04U7ocSsIG?=
 =?us-ascii?Q?VhFJ1lj4A2uC9+KErx0zr7Bw2HbFaJOBMqPAWeAdE1dArQVwnJHEUh4ZikZf?=
 =?us-ascii?Q?vqYAVpm5zcPwvlfdFCyjOxzS1y2copdgmSIVBONNt79xTPf3VlAYaTjtMSac?=
 =?us-ascii?Q?t3aWjFRKNHYQVu61zIWxeDCtgc0u+3AhHfFueDbiU//nIEv2E+cqOxU3fjcn?=
 =?us-ascii?Q?HX2gPrjhfnoI5YGGuqsF0rtjjcd6ojo3zhvQWe45sWGszCkW+NGYmhXVPQbD?=
 =?us-ascii?Q?kenhVLfJ1AwdZ8W5xaZ5jacBnmbMlEIJYA5aE0n8zabKF0uoyVTv/fvFLnqS?=
 =?us-ascii?Q?kzaK7RD6Bs14VHYeRPP16q/nsITMaXSVvRb9BwEz2GBGP5jwkstkWw7Ac3XD?=
 =?us-ascii?Q?i7IF7AfC6m5v4Bu2kBF90kY7OU3SrryjxeTjIqOIGNGwByu7zUU9hvVBs64C?=
 =?us-ascii?Q?iEEg8MqV1L1Tb+VMEJsB2DGYkTqbBv7ZfIS9hsbR0kWzWNc8dESvyMYePXLF?=
 =?us-ascii?Q?MgBe9tSu13LIKrzkiFHOLiDaDeXTZJSdOgGJ8orTW0927gpsKqoxAeulJ8bP?=
 =?us-ascii?Q?hrSYLgEWB3XEWs9SdpCCUY0KCmMVKFht1TU7O2l1ZvQ9c50pLX+bX3ILGjKj?=
 =?us-ascii?Q?2+oUh6LHKS1fOhzkfA6ezlNRjagpR3MOve6XleGL9jht0BEjea94QCr+OSFA?=
 =?us-ascii?Q?3VN9c9laQS414xYaXc7WcP3rZqm/VylcHh1pFvcBzgXQPb44YvCN9+DRDpTv?=
 =?us-ascii?Q?UFEBdQ7AhF+YISpEnhAppHsgjT4jGN8UsgVHj75UqcqRdKzxyWQkGbYxcnCK?=
 =?us-ascii?Q?Y3oYW+W6vgSYg5X9dqM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: dd93fbe1-be4f-4880-4475-08da877556f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2022 15:12:06.5295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DUIzTCZhU09Wd/IqvOC1N1zKxOhivnpNmImE3VdXjhRqKhk+FaVnzE1i18d3lqWx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR84MB1701
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: _AVjg-m2ENyWvpBae-G33PcWlo0EKtPv
X-Proofpoint-ORIG-GUID: _AVjg-m2ENyWvpBae-G33PcWlo0EKtPv
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_08,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 suspectscore=0 clxscore=1015 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208260063
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> -----Original Message-----
> From: Taehee Yoo <ap420073@gmail.com>
> Sent: Friday, August 26, 2022 12:32 AM
> Subject: [PATCH v2 2/3] crypto: aria-avx: add AES-NI/AVX/x86_64 assembler
> implementation of aria cipher
>=20
> v2:
>  - Do not call non-FPU functions(aria_{encrypt | decrypt}() in the
>    FPU context.
>  - Do not acquire FPU context for too long.

...
> +static int ecb_do_encrypt(struct skcipher_request *req, const u32 *rkey)
> +{
...
> +	while ((nbytes =3D walk.nbytes) > 0) {
> +		const u8 *src =3D walk.src.virt.addr;
> +		u8 *dst =3D walk.dst.virt.addr;
> +
> +		kernel_fpu_begin();
> +		while (nbytes >=3D ARIA_AVX_BLOCK_SIZE) {
> +			aria_aesni_avx_crypt_16way(rkey, dst, src, ctx->rounds);
> +			dst +=3D ARIA_AVX_BLOCK_SIZE;
> +			src +=3D ARIA_AVX_BLOCK_SIZE;
> +			nbytes -=3D ARIA_AVX_BLOCK_SIZE;
> +		}
> +		kernel_fpu_end();

Per Herbert's reply on the sha512-avx RCU stall issue, another nesting
level might be necessary limiting the amount of data processed between
each kernel_fpu_begin() to kernel_fpu_end() pair to 4 KiB.

If you modify this driver to use the ECB_WALK_START, ECB_BLOCK, and
ECB_WALK_END macros from ecb_cbc_helpers.h and incorporate that fix,
then your fix would be easy to replicate into the other users (camellia,
cast5, cast6, serpent, and twofish).

