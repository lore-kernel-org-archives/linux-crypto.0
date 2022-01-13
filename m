Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB076C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jan 2022 17:53:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiAMRxW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Jan 2022 12:53:22 -0500
Received: from mail-eopbgr60077.outbound.protection.outlook.com ([40.107.6.77]:25316
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237280AbiAMRxW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jan 2022 12:53:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g5jn9D/ELpNRrkKfMU21gNsw68Ra7gTEOFxMGeXP328pcXAnA3/E5U+qIYN+ZybzSEFxduJH2SFNSw3I/wLDFfdQKjWjuGgdb2aGL74aaTaUP3mTQ/DfQzN3y/XiGkkZr6FZTQE0DoTQ+U5A93ci2V5mFKyoP99X3RoX/WHF/2fU5Tdp6FA2aYuTsMhiVAyuoqvJnw+CjykIc2MFLBzp/Y/C39T0+jE4mNqVbYMct/wMX/o/csKAinstwqnQDSxpLf/Xwb/5F3561mCng5pGkRtdJxnS9a2hgCCTpnf7ftDSzpHXm6Y+3tyLx2o+dQqu3lLlRXR4OK5+EKXjxk516A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fhmCRYx7o1bdJK4qaCi9HtZctJh30s4kj/rE/HvWWx0=;
 b=QtF9YL9B3SVfoneF6/G+n+/oiUs2xGT8jY8tfcnc4jOnhJviFbU9fCqsp48JStl5L1cKpHoH9HK4SPsSFE/ikubDWbQfmrkytlIScPtoOBrLa6GIXy2Jvza5uaVj2u4Gsybd2LzynQRBM1kjlLW6wFEGcJ1Ui+kVbbebE+ZO3g72J6GVdrkYqa/iTfUXgrpjF3xaB4VxhMAP6wf1XzL2JZHdFP1VDBUAv8oLOPaL1kzsLGYCO9+BceIzy8hHiSSUK6e952evz0Rf1HckgyYPfkCkLG0w61BABZLsxedPQ4oue2WyV29YRT2KRocxFT9HNC+APwOWLx8u2NXjFavuZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhmCRYx7o1bdJK4qaCi9HtZctJh30s4kj/rE/HvWWx0=;
 b=j5Zlu8DzYW0VXTyrQVuWj0/5Kaj6z7H8CuM1BYyBr+O8I4eNpRfBsl+9YX+J8jf4ZroAH0CBAy9C+pyFFTUc/DsbDin0xXIkR6GGUkVCtINMT6w+Q0OGzyzh83jLv7xLGrcNOHOJvbuP2me+ATWC++cdYN+/79KwvVGIz5ZtRcM=
Received: from AM9PR04MB8211.eurprd04.prod.outlook.com (2603:10a6:20b:3ea::17)
 by AM0PR04MB6195.eurprd04.prod.outlook.com (2603:10a6:208:13c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 13 Jan
 2022 17:53:19 +0000
Received: from AM9PR04MB8211.eurprd04.prod.outlook.com
 ([fe80::59d:b332:4268:acac]) by AM9PR04MB8211.eurprd04.prod.outlook.com
 ([fe80::59d:b332:4268:acac%8]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 17:53:19 +0000
From:   Varun Sethi <V.Sethi@nxp.com>
To:     "festevam@gmail.com" <festevam@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "andrew.smirnov@gmail.com" <andrew.smirnov@gmail.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>
Subject: 
Thread-Index: AdgIpnHk70dKumr/RhCbN2dpPmPG4A==
Date:   Thu, 13 Jan 2022 17:53:19 +0000
Message-ID: <AM9PR04MB82114956521F134B09FF5D9CE8539@AM9PR04MB8211.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7a00d03-6afb-4e86-a71e-08d9d6bd9573
x-ms-traffictypediagnostic: AM0PR04MB6195:EE_
x-microsoft-antispam-prvs: <AM0PR04MB6195513CD77BE3F31A89A346E8539@AM0PR04MB6195.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tkJJBfJFEFnr0OuHwxKiXtney1IIt4rNHmzZ+7Z3LwnEJDShccZ98ZHUBSxRSE7LMU+KDpG647fP+75t56LvxkR1Th+mz0azG7qBRpFPDQjCcrzxO1Hyszhzx5yZNliEOQMUes8hBs24ikoEQcbYJO3+Bfa//VHjRY1mp6mLeIe2KwG4IZbBhH2t7pBbx8BzpVnp8esxlhtSwg5n2zVHtg0ZZ6JIT7LcO9r2wbkYXgTGVIeKArOP5vzaJBdje+agk6n93TMQjL0Ys0oX1uKjhELheN1rITnsKCVxBinCnzqD6vyp0ZLxAlVCmt7xiE9CofXovnYs0hJRDWbharYBZ2r0VK/v05qqhSxKaoMZ6xlBb9Df1NrYAtcGNqkjjYynpAwbHtlGQz+y8k6KmcDQ6In6C/m37p+ezZCDY1CPHy7sDd3KVFnjL/W/RN45tIIs5CMyekFAZLl0A/5FP4KqpAgtagi62ftotR8hZYJj1ntG27Di4cmFqnIoZb3XMqkA9eZlItJY9gXkRm7vgy3LQK0QYLQAoARiAp8xBcaipEBNy79hWvREf8/MvyO1X7yJnoV9bWltXdXoNQnr2zgAiXOpVM8KazCtsgfR3rxejk53FM4GQMX1epBNQNsNsj0L6djLNcM3bA/1G35Zb6B2TZN/3QMMjThWTZJ0cckhfiknPK/MdFoREFO8D/e0cEfNNXj6nhVgepe6chc/1a0ExA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8211.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(64756008)(66946007)(71200400001)(6916009)(5406001)(66446008)(76116006)(66476007)(66556008)(122000001)(55236004)(2906002)(6506007)(83380400001)(33656002)(508600001)(55016003)(54906003)(38070700005)(26005)(86362001)(186003)(52536014)(5660300002)(316002)(4326008)(8936002)(7696005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eddx7Gw4aytCsx/saimuU9JoMdBP8E7wJGSM7GMn38Srj6uGyfA3Pzr+JpXS?=
 =?us-ascii?Q?X0OK4O8W1grF1iN3zBU0Py+xEp5DWg2Lhy38qcKYMk23pgJXJmnRHRn5TJtH?=
 =?us-ascii?Q?kf13fE5hIuqGcGeQYK8RgZZ2hx1UXim4TbvdGkwNqbmJHsQp4psoxd93rs9o?=
 =?us-ascii?Q?XjqRMu1Dsqp0Nnk4caoIxFGcoK23NNekJz7QG4kv5mGzqfYfTgV6uvuIf3WY?=
 =?us-ascii?Q?jObNkyFF6voJmuio39jFScKcsCHto71hJO9dEvBBvHVoH8c9PQJwmAIrgTgr?=
 =?us-ascii?Q?7q/1ezBT4UBR96FYOwF/Ls8MGkTYmJ+q+yoHTQlRw7cguQOe35IzyJ87kLtO?=
 =?us-ascii?Q?sqhFzbuuSrIt0zZnrSgioZR5aF8aZvygatO78G3y/lNnpVeCiZpq+z/sOGNK?=
 =?us-ascii?Q?B8prVvv8orGsRFO5UgbAwgchWOORk86tvwRGqx3kA5a2gdSDZeYYIUzuPUsh?=
 =?us-ascii?Q?SHQ6tNOeEqlaCENfl0y7shA0RmyCAd3ach9ebHOvUmnx/xtRGjAxAAWEPwrB?=
 =?us-ascii?Q?PV9SE5T7T0DzHKOPAKi0OrYqYqa2OLOZhvddbD5qofDt/8DJ9N8ZOHK/mXON?=
 =?us-ascii?Q?MD3sQksudNIqkawymSFHi4DlystY+gQj6rbqMqjDAIcnlQ6BkDVgUEC6/4TM?=
 =?us-ascii?Q?cU/TthHmIMhmUCen762B4OmOEUEr8dOln6SgHIAbUvMu1olE9jX+a+2cnYRH?=
 =?us-ascii?Q?X7ZzGmlkBzYEJg5qhXfYk+okJJQg8cNv/XWZnVvka4sX0/CIFxW8kQKeus8+?=
 =?us-ascii?Q?bQxmJ/y0nhorzVjs3rJuGFUbkp7dbD7CDBOJ2cCbmIJqsvAYumCUoubKDodR?=
 =?us-ascii?Q?ANIHdcd5gjISbp+NuwxOukk0ZqQZUnuxQQv0AEM60e85lAHTAYki2FN+g9NE?=
 =?us-ascii?Q?peSaExw29W3dlR4GBu1DZ9RfEXKxcINrJOy1NDT7PIIxFQp0cf+rJ+6Jk9li?=
 =?us-ascii?Q?vAHKV9T45Mb06mhNkfmvJqjfK5n54FlRU4datpLTAdXKq9agJE9pUtD2kfml?=
 =?us-ascii?Q?HOSK8dA5qriHIDSWJ5UH+AyQck6eIiK1GcLJNJJ14DYcqN/uf6eiZvzP2MMm?=
 =?us-ascii?Q?JkIvF2NPZ1ah5bbbE+RQBoDcXcygd5Z4i44vZpPVHonkuzaiHw823bKbdfVG?=
 =?us-ascii?Q?rgNZfOr0sKDL2OeEyqpIwQZmQkFBJ7ssq6VmX5oqaDxhP6z4DKt+eAOxNKzD?=
 =?us-ascii?Q?y1a13TIKgt/acILiEKE+MoLboOe/uvWBTcg2cjtC2/x2bNzOYAlnQLSs0yJ4?=
 =?us-ascii?Q?GImkGPY1S1K6l85UaGyB758XPbpyrF/45jDYCB6sH3NXiVMCYiRjPRuDjBX3?=
 =?us-ascii?Q?CAmme1wVWM9aDo7tyR8BL9Rn47a0R9YSiqYUqnOB8Zur2demcwI+ebIDLavr?=
 =?us-ascii?Q?GuR93xavrwB32JfdVvGtX/us4eJqM7p+3fkGlpZ3BnCFnqy33SfjhT/MFDKs?=
 =?us-ascii?Q?UsdSoOftf9inPNV+iy9AR/YITiMPRRKF+/t6z/VO9M4O1PPCuNMGuz+t4w1q?=
 =?us-ascii?Q?hZHmTofzKUikt4kCNtdq1t8gYatKlenf5RWs0cEqs28YKhLzeHFisfFbfuRo?=
 =?us-ascii?Q?3F/VVZ395zlvynDFUlk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8211.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7a00d03-6afb-4e86-a71e-08d9d6bd9573
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 17:53:19.3715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z6voYR2V+0/GVMpyE78AmLP6orfA4ikIhvNL8yzmfRel1gwD7oftNkeERdKatMaR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6195
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Fabio, Andrey,
So far we have observed this issue on i.MX6 only. Disabling prediction resi=
stance isn't the solution for the problem. We are working on identifying th=
e proper fix for this issue and would post the patch for the same.

Regards
Varun
>>On Tue, Jan 11, 2022 at 4:41 AM Fabio Estevam <festevam@gmail.com> wrote:
>>
>> From: Fabio Estevam <festevam@denx.de>
>>
>> Since commit 358ba762d9f1 ("crypto: caam - enable prediction resistance
>> in HRWNG") the following CAAM errors can be seen on i.MX6:
>>
>> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
>> hwrng: no data available
>> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
>> hwrng: no data available
>> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
>> hwrng: no data available
>> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
>> hwrng: no data available
>>
>> OP_ALG_PR_ON is enabled unconditionally, which may cause the problem
>> on i.MX devices.

>Is this true for every i.MX device? I haven't worked with the
>i.MX6Q/i.MX8 hardware I was enabling this feature for in a while, so
>I'm not 100% up to date on all of the problems we've seen with those,
>but last time enabling prediction resistance didn't seem to cause any
>issues besides a noticeable slowdown of random data generation.

>Can this be a Kconfig option or maybe a runtime flag so that it'd
>still be possible for some i.MX users to keep PR enabled?

>>
>> Fix the problem by only enabling OP_ALG_PR_ON on platforms that have
> >Management Complex support.
>>
> >Fixes: 358ba762d9f1 ("crypto: caam - enable prediction resistance in HRW=
NG")
> >Signed-off-by: Fabio Estevam <festevam@denx.de>
> >---
>  >drivers/crypto/caam/caamrng.c | 15 +++++++++++----
> > 1 file changed, 11 insertions(+), 4 deletions(-)
>>
> >diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng=
.c
> >index 77d048dfe5d0..3514fe5de2a5 100644
> >--- a/drivers/crypto/caam/caamrng.c
> >+++ b/drivers/crypto/caam/caamrng.c
> >@@ -63,12 +63,19 @@ static void caam_rng_done(struct device *jrdev, u32 =
*desc, u32 err,
> >        complete(jctx->done);
> > }
>>
> >-static u32 *caam_init_desc(u32 *desc, dma_addr_t dst_dma)
>> +static u32 *caam_init_desc(struct device *jrdev, u32 *desc, dma_addr_t =
dst_dma)
> > {
>> +       struct caam_drv_private *priv =3D dev_get_drvdata(jrdev->parent)=
;
> >+
> >        init_job_desc(desc, 0); /* + 1 cmd_sz */
> >        /* Generate random bytes: + 1 cmd_sz */
> >-       append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG |
>> -                        OP_ALG_PR_ON);
>> +
>> +       if (priv->mc_en)
>> +               append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS=
1_ALG |
>> +                                 OP_ALG_PR_ON);
>> +       else
>> +               append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS=
1_ALG);
>> +
> >        /* Store bytes: + 1 cmd_sz + caam_ptr_sz  */
> >        append_fifo_store(desc, dst_dma,
> >                          CAAM_RNG_MAX_FIFO_STORE_SIZE, FIFOST_TYPE_RNGS=
TORE);
> >@@ -101,7 +108,7 @@ static int caam_rng_read_one(struct device *jrdev,
>>
> >        init_completion(done);
> >        err =3D caam_jr_enqueue(jrdev,
>> -                             caam_init_desc(desc, dst_dma),
>> +                             caam_init_desc(jrdev, desc, dst_dma),
> >                              caam_rng_done, &jctx);
>>        if (err =3D=3D -EINPROGRESS) {
> >                wait_for_completion(done);
>> --
> 2.25.1
>




