Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E444C38142
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Jan 2023 05:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjASFaZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Jan 2023 00:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjASFaZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Jan 2023 00:30:25 -0500
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2120.outbound.protection.outlook.com [40.107.117.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87BDC1AE
        for <linux-crypto@vger.kernel.org>; Wed, 18 Jan 2023 21:30:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8MavNw71UjNLWQBStIaVdDd6UTu/qYI2AShUuN7auVUywaUDvzaLAa5Pndcfu9adqHS4tpk4Zn/rXtWE3kmE7qKeabtQbadu75StKSMAQFgbFQRkcuGMu3gQnXvL8sMr2dw3SZA7spdAyaHJhw2Dxjz+abnLh+YvnmiS5v6KUkHbDTsk2eeKWNNGdoWgDdZBjOOiwaOc8m9Wj4LcGvPnbZYFCGIB45VibZwQX1ubMcctMQO25nu989GOnaWkm1BWNJdsDP2WjijFuZABryOUnLJaaXNInD4N/v3pL70DObpCT/rQXd7QnolOkd0W+v+4PUi0gMGRiVTRMiALdwxkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YTlANqY317wm69C6VIRxHd7WnTu73POBjX7KxE7T7U0=;
 b=LScGt2tVo9HyrIeqEUBphsreA+vW+kWFN4q6mM+lWKMlYOaf+BC9IB8Iu6Eq+pgimkpc9o9XOtQxhqP2TpIy5E38APISjIWWs7yIP3bqYfeEEGRl7rAvvaT1UU85p7ffpWOzjFLwDXnIvuhkaj4UVeLTvhPqRyiKcsYspsuywFVsS4DqBy+VuC7dV20oOTA8610wTiV45IMIt1wBtrLnwbVMAIH3n6tve43PBhVkkCRDcEI8ID/ltoTqPkf8yw9IMT1VNmEhkPXkCUBjmZ47pNtdbGtKXdcOzmnYZLvel2QwOblcN9L7/wVpPCyQYDQuPQD9G0psmKuFnmynzrwnOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aspeedtech.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YTlANqY317wm69C6VIRxHd7WnTu73POBjX7KxE7T7U0=;
 b=TQ390SIbvWyr6WzEd/fIhpvVT5RJ1n3isLpocXnq5X4UUglMJRY2l8v2AI8YMW/wBsUkdM0oQnbep+CZWSM3eQje0OPPoe+wfAT399nZtq0UDOA9q8aUbnd2CrMbrZrsJXrmc8Ugsp/pRATD0o+6JK1ROlxEaIB0VWU/wFhL2BvR61KbKLft6Fb6+O0eZGpEjqyEXIhtlpQShWQ/lJ70u/j2BB3TxgrBEIxrAmFXZqaalxytlY3qEqgsGbEXMVoGuBWGjQM8t5Vf4+gfH+4kWsxx/izh2kZtTcXjKSlfGKeD7iZWjHLApNXxTfDLjIB4nsgPg3re6xhwjy7URjzSow==
Received: from SG2PR06MB3207.apcprd06.prod.outlook.com (2603:1096:4:6b::9) by
 PSAPR06MB4151.apcprd06.prod.outlook.com (2603:1096:301:2b::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.24; Thu, 19 Jan 2023 05:30:14 +0000
Received: from SG2PR06MB3207.apcprd06.prod.outlook.com
 ([fe80::bfa0:771c:8258:c299]) by SG2PR06MB3207.apcprd06.prod.outlook.com
 ([fe80::bfa0:771c:8258:c299%3]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 05:30:14 +0000
From:   Neal Liu <neal_liu@aspeedtech.com>
To:     Yang Yingliang <yangyingliang@huawei.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Subject: RE: [PATCH -next] crypto: aspeed: change aspeed_acry_akcipher_algs to
 static
Thread-Topic: [PATCH -next] crypto: aspeed: change aspeed_acry_akcipher_algs
 to static
Thread-Index: AQHZK6WwSMVtzomYYE+HVkKQig9+xq6lNqxQ
Date:   Thu, 19 Jan 2023 05:30:14 +0000
Message-ID: <SG2PR06MB3207C0C0D82F4F27BC4C3F6F80C49@SG2PR06MB3207.apcprd06.prod.outlook.com>
References: <20230119014859.1900136-1-yangyingliang@huawei.com>
In-Reply-To: <20230119014859.1900136-1-yangyingliang@huawei.com>
Accept-Language: en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aspeedtech.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SG2PR06MB3207:EE_|PSAPR06MB4151:EE_
x-ms-office365-filtering-correlation-id: 0bb0f2a6-578d-48a4-0bb1-08daf9de3df6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YxND1fMjxgWCcfzk4wyk6lbwzO5k49V9Ecp3z7LsQEUEPwVJB5UyeHIrsT6HnUUqJu4bivpFU9GYd/W7hf5XawXLnAvN+JfoXvtQffBGSTmguhor1krqBwIJrRn9OMR5rFPGfBeE3bbhyLWIW9OHNg2TV/S390i0sPf7Ij/VA+BY25Sxg03s0LOZDehkmbOLPkSBh674M/eOFU5VYq9xkRT6EHmFxvxrAnU58KHtFQEDeu6XKgTN7Gy/3zJqjSRCm1A+LSLno26WCjA2NOH81zwiu5cU7m7r+ZFv9DsQmXJR641Xj8R6+ViaSts18hAqGg+aOqsL0BKvLCV6cA9tdX3tpxDFfWBFt51BN5UVXTcfHecL0bBPS6zpt2HSIsS/+5oyizrwhkEvXFWLDErDdZ0D7zeaIXiAGI3mtGKhez4VPuemSnCMGUDeHqFRCP5v6QlcAURbsysq3brTPUsmGLKUe4E7ThH3TNAYH6smRoAPe+11j25SOoWDpT9w4Y8PXF/94v+LztuDkB670PjwDgv8VroDiPaHbM6SGzQL+v3i85+Yjq8+OzMDxxs03ZeWlQPiw3T/z/jCtx2+OdL2wRamlExuPhYIojsFDIA+itfqqu832M+J37eMa1EaQx/f6mW+MN0WrQwiSHwj2ldJ1JpmY+X40dZFqs78MxT7GtApCWj+DbmD8zmLFbsqk5j9o8V6YAtThp8wxUBzaDmSmA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3207.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39840400004)(366004)(136003)(346002)(396003)(451199015)(33656002)(6506007)(110136005)(186003)(478600001)(26005)(9686003)(8936002)(7696005)(38070700005)(86362001)(8676002)(4744005)(83380400001)(64756008)(5660300002)(66556008)(52536014)(76116006)(66476007)(66446008)(71200400001)(66946007)(4326008)(41300700001)(316002)(2906002)(122000001)(38100700002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VHwNtwVBZRaXJEW97jvf1mbPOAqBn/gn8LuOAn+fcQnKKa8RaATUoaAPIebJ?=
 =?us-ascii?Q?VMsfIxriouGyKzrxwJOQfeWg39ohOhYEMlxjkDeR1BAvnriBmBfPm+g9GlT9?=
 =?us-ascii?Q?C65ARVBxhgJqzXt57ezEGYTtzdR26v+jo+m1abbbImDBcLPZsE7C0XdpVhoY?=
 =?us-ascii?Q?PbPXPhMXDMUv0IyTehUub3aNg6lglhqykTLAA8NkQwUUoY03PWeXdgbsWad2?=
 =?us-ascii?Q?gL8T4w+ehdUMIKHxDHXbtdX4hTmvxG9jGiZXdbC+LWbIv2r/vhwTgEoNSbOO?=
 =?us-ascii?Q?VGiH4fywHg4Ib4M1V9v6s1ExA+PYV871iKk5axSXvovV5/jc3gltdxxHYMaf?=
 =?us-ascii?Q?yPkGJXa2G5i0RbjU1ZI8USgjtXBDr+xzJJlrAt3U4iBkGnUORkurzmfKgl0O?=
 =?us-ascii?Q?nfercce5G4caqPRxnN0Sl2SXFxs+QlQnm/teLLmAn3AknBROLjf73pvnlime?=
 =?us-ascii?Q?WSufw8nY45j910kK9eKQLmEByrvp6c8QsU211vIfR969bt2XgAudtoI2qlHW?=
 =?us-ascii?Q?qTaiReVKTWJrlDatJU2HkRD9/2Vx0vZiXpxkZbK4MpdFhfuP6FhOLLivRA8T?=
 =?us-ascii?Q?ZIci4Dfje0o0Wq7475LFmHUJJjvmm7qO7j92nIMVGUdWMIWYZRcFM5INz87D?=
 =?us-ascii?Q?HbB164bBOBlUTAtTZbLkaEKvFkzFvhloKb8l++pmfYalqDi5ecy8WXE5BI1R?=
 =?us-ascii?Q?nuAzf/GUpVzJaxrekcn8BX5XTfP5Qgwfizwo4IQg9tDYo77QOJDlha4mt2HL?=
 =?us-ascii?Q?H3XbZZbYDFx/8ItG16xOHId1AU2676iXdtIjf3qSPXMACBER1Fqd6oWAHKsp?=
 =?us-ascii?Q?BCgpemjYxrUkL/9d1WyfPi5i5rfvgr3IvhJvO+ODJJsKitGsmUqCDA6gh9yl?=
 =?us-ascii?Q?RtkS1pOxQhZyCXbenS64yWue11nPgucZ8X1ABokNQkyqeQa8SUr1ihV7oOfl?=
 =?us-ascii?Q?zpjGQr66i3gN5/6C+Z0kTXTy6M82jHMExkau8v/UTEVqG5gZxKjVb2aqwIqV?=
 =?us-ascii?Q?yStDRKD2tW1CIaXkOwCHXH/oTUEeovtx7JSKfA47spYahqM0vhn3QZBijk70?=
 =?us-ascii?Q?5ZfNWK0YCZF+nMwHpIyqibJgakwZ8zMFmKqy6fTNjvkzH3UBCQNa6uHCJY+N?=
 =?us-ascii?Q?+sHzfX0tpVbtj6d4yTn/Q1uiKgSUWJvHACoYyaRfbWVriQQrNXSCv0X5XnLS?=
 =?us-ascii?Q?sj6emuXsNsHWJswRt7QeH0FxPuKyDfB3Bqr3dEFWYGeiz8bD8ZfEzWnZOWv7?=
 =?us-ascii?Q?vAD996xj4M/LxrxSKDeEn1Sqw8vU4OEqScz34WyeO/b4giV6pvX3g7RtlS76?=
 =?us-ascii?Q?/hHW0q3/bKuxnQrvSWx2VUS8qadEetdBsxyjjf+9r6RMAD59H25cEgkErYq1?=
 =?us-ascii?Q?b9IDIU4Ua0tjHNm2UZzc74cNHKo2dW5vF4Gq/X4kKvz12YdgqweN+PCdTnl/?=
 =?us-ascii?Q?JbZifu7E94AhDMTGS4DHfpO66dOMxFhA58QdhBsCQpFXYMwHbwQAxKpIdIFb?=
 =?us-ascii?Q?TB3nXt0QDpI6VgEnxZlkjye1HOQ8NZVIdP8+EW51cHev1CuVlCZMYTmiTbEK?=
 =?us-ascii?Q?imOA5dBHdPHAWgBOmez4JJwhAC651/R9Tw7cNmGH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3207.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bb0f2a6-578d-48a4-0bb1-08daf9de3df6
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 05:30:14.3624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pSe/Ps+1l86t1RQbQ6S/PtE/MlB88Gc9AUtlUxXEoqa/6Ga4SQTebwjCxCV/d93HKCZsGDeBM0CpWT9VLIyFxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAPR06MB4151
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> aspeed_acry_akcipher_algs is only used in aspeed-acry.c now, change it to
> static.
>=20
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Reviewed-by: Neal Liu <neal_liu@aspeedtech.com>

> ---
>  drivers/crypto/aspeed/aspeed-acry.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/crypto/aspeed/aspeed-acry.c
> b/drivers/crypto/aspeed/aspeed-acry.c
> index 6d3790583f8b..164c524015f0 100644
> --- a/drivers/crypto/aspeed/aspeed-acry.c
> +++ b/drivers/crypto/aspeed/aspeed-acry.c
> @@ -603,7 +603,7 @@ static void aspeed_acry_rsa_exit_tfm(struct
> crypto_akcipher *tfm)
>  	crypto_free_akcipher(ctx->fallback_tfm);
>  }
>=20
> -struct aspeed_acry_alg aspeed_acry_akcipher_algs[] =3D {
> +static struct aspeed_acry_alg aspeed_acry_akcipher_algs[] =3D {
>  	{
>  		.akcipher =3D {
>  			.encrypt =3D aspeed_acry_rsa_enc,
> --
> 2.25.1
