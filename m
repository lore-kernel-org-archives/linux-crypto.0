Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 459E0EE49A8
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Aug 2023 09:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbjHVJri (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Aug 2023 05:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234450AbjHVJre (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2023 05:47:34 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2056.outbound.protection.outlook.com [40.107.105.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4A21B2
        for <linux-crypto@vger.kernel.org>; Tue, 22 Aug 2023 02:47:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBRhyF9g2CJaontS/ZX27aVOnByBCrkb3FhwX6cSMU1g8M3nIw+HB0VgOlwOEqZ0AVWWYjkdEIomlPo/wvnrbuBhNopiUpiH7+F47HLH8FiCCkbzAwjWeP53+y2Hn+cihpe39qe3KKNj8mDvGNsvHb2ZYf94Hrrjf26acCmqTxE3CNhwPy2X47fZuVL77TAmBrsanLT9KUkE0aCgIRYPO2UDqhF2tww0vQ1Qf4J3RayYfRBRqugkbh/SslNqrHeNNmRZ1UZS9IeaVp8K8HSx3IV/ZtSEKSIFDauJGePqjm3FueUEjYjEreERjbrbtwXwlj6VpO69/E4c/8mrIkuVcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=auVUm5fn7590akNHXC29VV9Sa5v+EMaxlAseOOwwaPY=;
 b=O++2/v+rHCyzgeFJM24DUK0i0SENZrz11zC1NRfFiVOAlHEtHtMADmye572yMtTRs43pDBzpFrb1rN1FC5zNsfcKQCPTOcuwsGtESa+clWGxzgm0u+uHN2pudByvL2sBqPctH/N1+ntE4nBVBiG0v6Tou+FRHIjgP9CK6G5n2JJpTwH+z5zuvTMn4S5oGVaEMrXsXRjgvYxKFCuG2cy6yYkvVQGc+qHbQ4W24xCBe9jLD7oUgrH0fefigEexq/uD8oO6OnVluSBp9F305cT/vfwQCX5vbBB0Bej753l35ExoXCWDWC+YXoHsSx2LHpy6HJUSvzya4A+0dYHVmUZYhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=auVUm5fn7590akNHXC29VV9Sa5v+EMaxlAseOOwwaPY=;
 b=X1M8CbowA8xtD6dsLm5HkyzYqLpDGPbDtjCOKYX5iUJ0opRrMT8Ue5s5cglp6f2awLpefE5UU20oUlXYWm/16ptaA0ujJJ3nPP+/OWe1SjMctZ27YhnYtISCnajowC0HI7MXG+wMWYr+cZhTmW2ThoqwVqg1mlPmhmLEEXmUyTA=
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com (2603:10a6:208:11a::11)
 by PAXPR04MB9352.eurprd04.prod.outlook.com (2603:10a6:102:2b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.20; Tue, 22 Aug
 2023 09:47:30 +0000
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::1392:7c78:1b43:769f]) by AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::1392:7c78:1b43:769f%4]) with mapi id 15.20.6699.022; Tue, 22 Aug 2023
 09:47:30 +0000
From:   Gaurav Jain <gaurav.jain@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
CC:     Nikhil Singla <nikhil.singla@nxp.com>
Subject: RE: [EXT] [v2 PATCH 0/36] Move crypto_engine callback into algorithm
 object
Thread-Topic: [EXT] [v2 PATCH 0/36] Move crypto_engine callback into algorithm
 object
Thread-Index: AQHZzbLf3vZnAFf44UuLV7UYWMChsq/2H8rw
Date:   Tue, 22 Aug 2023 09:47:30 +0000
Message-ID: <AM0PR04MB6004AFF755F0FC5375E9A7CDE71FA@AM0PR04MB6004.eurprd04.prod.outlook.com>
References: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
 <ZNh94a7YYnvx0l8C@gondor.apana.org.au>
In-Reply-To: <ZNh94a7YYnvx0l8C@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6004:EE_|PAXPR04MB9352:EE_
x-ms-office365-filtering-correlation-id: 0a409652-b321-4f43-bc4e-08dba2f4cd46
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lPRoGZUAGfW+zbPSGQ3jLf1pwAAi+8RLgi+IgheRnUt/Ywip1qSN5FQaPvwSrRvq15UUI0I4BZyOjs+TkvSAX4U1KNdvFuG6il07jL1zgzQkk02JZPZP1ADriqwU2brAJFpL+hbqQUTymcVMk8JxuCRDui6Yy+VclY9cHnAZOf9SX0hbmK19OMaf3o/fJwLZ0n8kLL0QxX26UkTmHFH2LPEtq/wWEtSwL+Q8M86ohGi0MvWmk7LywBKypraoepD/Wh1c5QOIrFE/iuogJrkP3J+WTE1y3GJMPuD8str4WwaAudh4js8VaTvu9Fzm5yqJtSt4h+HT9/wdq1rF7TjaiSy7HDuPPtPdG1B5zFPGUd5j6dxOdAnEFhaQITE6s1KrMzdiDuPoPkesXOX7SsG7grnoWoLcJOV26KwQtyB/CgDlgCcb9WZXObom+ZeT/fArey8bsw5RtzkUmNMWH7LtMfKTONvpPhPtBUq1tUQUt/LPJt9ZeIhyYc3gBRjvUOB3ClAe1eIkMUv8NkJdoeZjjo4fi9sXV+80mB1m6mhnHIIEefqonKYM4PEaoj6KToS+Zl71l0vG69IbaFfPGvAQxF3R8pshyzFA7hR6RftPu2Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6004.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199024)(1800799009)(186009)(122000001)(316002)(53546011)(26005)(6506007)(9686003)(45080400002)(71200400001)(2906002)(7696005)(44832011)(4326008)(83380400001)(5660300002)(8676002)(8936002)(52536014)(76116006)(966005)(110136005)(64756008)(66476007)(66446008)(66946007)(478600001)(66556008)(41300700001)(38070700005)(38100700002)(55016003)(33656002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5An6qGF/zw5qhnbPzMGRLHF/Y8haoIIRhrKxN1fQZtVt8Ltqrz8lT+C7s3hd?=
 =?us-ascii?Q?D8OUVpIZa0IxVbCKya2sM1BViZMpDu83GK6zsXQ1BmS55k2oJZ/GO7j5fa1+?=
 =?us-ascii?Q?BlLkCJtOV3ENAiMlsNYX4sxsNAM6n8LnuGkaVVLj0oGY2nxXKhDCrJhjyADC?=
 =?us-ascii?Q?7K9l7eFxsawgkPGHYh+DKJnwFipjMi0OAzOkI8RWQ/ZF8KBrIiUMtCtEXPUL?=
 =?us-ascii?Q?my0QB+VTRvwls7O0851bwHiAajkHZUZJAjLzcCX5uTmuscwfxS9ahwKgv0Sd?=
 =?us-ascii?Q?Lvav8VozZnXH7cKB/UuiM5aIomluyqFLGGbAN9tpJUetU6VL6Hd+MP9xAC50?=
 =?us-ascii?Q?hzRcX0bmXAzDpwCrOLGBXwx67xRAOZAwh1fBOv+GzwAhWWg/UoFEMIEi0uoo?=
 =?us-ascii?Q?i6963fpL00KebOlpvBf5+5G3FCgzV0AezZmxhR7qP+BgUunnR9aqXjl8hHi+?=
 =?us-ascii?Q?tyJJcwI92MsB6BLRtx1Cf/w4vMHSdJGNuVZh+WsdRMotUZ88px6StEbgtnuQ?=
 =?us-ascii?Q?tNQ655/oY4mhzKEfnYYzByPTF4UM1sPzFxSo1tPA6ebf93qjaM7hLw2RqX2R?=
 =?us-ascii?Q?Ae9dTuHQ5zrpfQ61MS340vsiaT1NhIh0Ok+EkpZd6+ZR26mEA0vT+4cLXr+X?=
 =?us-ascii?Q?+XxAPMhdpd8MsHIZqnLnSH69mgjTRJwNJZrBJiESCKaS4XCg3C56GYkHiMbu?=
 =?us-ascii?Q?miYw4f3hI0oRqGYeknR4y4uNageoT8Dc/4mgcgPJdmo9dgN9MybwJ1GRh7tA?=
 =?us-ascii?Q?SwGw5PgtJlgtBAu4TnCdGUPgEGvoGBStzyRSKH2ivZ89AIaVIN/LdXYXM3gZ?=
 =?us-ascii?Q?FEKqEkZmsm2DDeHl+P4IGS+YOLqqvK1YbU5RN4tbmtW7BrZ65qsVwRTN2mzP?=
 =?us-ascii?Q?G86D50ZFWLR/HEmaBV7ynbkRI9rfOWxdJIPDBu9UcG2NmLvk31/QcIuIvOMK?=
 =?us-ascii?Q?AEPWaZMk3pWYeqSLilnbKaR91nBCPuvKyyJK8D+rAeE9GMxm+/ZLE+6vEm5l?=
 =?us-ascii?Q?/JGl5/spsAtnuUQUlD4+MDWxXh2gn5mlmNsi9Ms18JfGyDjjm/cTa3iBGSZk?=
 =?us-ascii?Q?/PH0sJtcNXMnCOp2yzCgtL5rFfFnFWebUDJhn1vOMzBcMtoBI9HayxWqWc6v?=
 =?us-ascii?Q?Xi7XzmTyYGZOFUDU2YeYSUpenrTdBHBV7bLV8/ZhXujs/FmittXE0uxNudma?=
 =?us-ascii?Q?fV+p9SYm6cVQpjBzyXjTx9syQweGwSN5ZDJKo8Q4tLC0mg1Q1dgVt8v3SknH?=
 =?us-ascii?Q?RhrvpMeb3l0c5ko/n8bSza/QV1lrCVZTvyw+IVW5n0q5jytBUA/r8cRc+iLo?=
 =?us-ascii?Q?FIOh9gYLDJtyNUJ6PiOyZI2i6QtYDiqskyS4plBhDqMVe1EJh32enRAgyXsy?=
 =?us-ascii?Q?u4VKuurs8lc/L+G62ncqIQQRISShpdd90383g1cLyT86hGccznqjnGAkaiFI?=
 =?us-ascii?Q?hnP1SEtE06fTIJ2zIRp003ia6BYSsC2dr+FgDC51F8K9bzA3yInF68DjhsuV?=
 =?us-ascii?Q?lN0KYlL0tdvLv9A3Q2IZVf23zO5Mg2unO0QthjwgTIz60bScNpbSGuVdFrG3?=
 =?us-ascii?Q?RPZFtpga+swcNiQt8Swe+vKaiXJcorZUWeU4EYL/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6004.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a409652-b321-4f43-bc4e-08dba2f4cd46
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2023 09:47:30.2344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mg7c3uWkk6/Hzt1bFp31L+4XwBJNAcuHtNzQwSZruVoytwcGvBu1I/zfWEutN0kJ+FOJ7WgElkv5RK6NpUGvkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9352
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Reviewed-by: Gaurav Jain <gaurav.jain@nxp.com>

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Sunday, August 13, 2023 12:23 PM
> To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
> Cc: Gaurav Jain <gaurav.jain@nxp.com>
> Subject: [EXT] [v2 PATCH 0/36] Move crypto_engine callback into algorithm
> object
>
> Caution: This is an external email. Please take care when clicking links =
or
> opening attachments. When in doubt, report the message using the 'Report =
this
> email' button
>
>
> v2 fixes build failures in allwinner drivers when debugfs is enabled.
>
> As it stands, every crypto_engine user sets up callbacks in struct
> crypto_engine_ctx which is stored at the head of the tfm context.
>
> This is error-prone because there is no guarantee for that callback to be=
 there at
> all.  In fact this is exactly what happened when the tfm context was move=
d for
> DMA alignment.
>
> The first part of this series eliminates the unnecessary prepare and unpr=
epare
> callbacks so that only one function remains.
>
> Then that last callback is moved into the algorithm object.  This is chec=
ked by
> using special register/unregister functions that are specific to crypto_e=
ngine.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> http://gondor.ap/
> ana.org.au%2F~herbert%2F&data=3D05%7C01%7Cgaurav.jain%40nxp.com%7C14
> 1e3a0f31eb40bd5a9608db9bc9fefa%7C686ea1d3bc2b4c6fa92cd99c5c301635%
> 7C0%7C0%7C638275064121607795%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiM
> C4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7
> C%7C%7C&sdata=3DiacbgdbHaAIafT5imURgLPXUFTf0YEzmkbPv8zdPSk4%3D&rese
> rved=3D0
> PGP Key:
> http://gondor.ap/
> ana.org.au%2F~herbert%2Fpubkey.txt&data=3D05%7C01%7Cgaurav.jain%40nxp.c
> om%7C141e3a0f31eb40bd5a9608db9bc9fefa%7C686ea1d3bc2b4c6fa92cd99c5
> c301635%7C0%7C0%7C638275064121607795%7CUnknown%7CTWFpbGZsb3d8
> eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%
> 7C3000%7C%7C%7C&sdata=3D7vaeBPSY6XELp6R7Bj3JZ%2B%2B0xemNpUENHPzg
> BvSwlw0%3D&reserved=3D0
