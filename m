Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC941C4332F
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Nov 2022 21:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbiKCVQt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Nov 2022 17:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiKCVQ2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Nov 2022 17:16:28 -0400
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6B621258
        for <linux-crypto@vger.kernel.org>; Thu,  3 Nov 2022 14:16:19 -0700 (PDT)
Received: from pps.filterd (m0134425.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A3I3GsG031142;
        Thu, 3 Nov 2022 21:16:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=PPZPxBQ472Ldpp0Yk7fiFtuUQhnpyjmF1TGOsi6xETo=;
 b=P5ZfYMOa4KcCXyNHI6mYtEiuYhzKf5MwunMosdU0cil09oPaBVPbOIIixzkydO3h0JZO
 4El8r0y/9c350n2GEySSPBMW3xS4WZsNYtgeYe+OOa9WX/tIu4tU3N18t4RxrpK5WrPn
 4xUFDQUB0yz9rdJ9mRYwK556kUoFH0NDpqFHSfDVXUtnL4BfNsk1zx4DLS0uwzl+/PNz
 TNGkrHUwZc8HAHS4PisvnCepau3W9Et3GFgm4QaHdf4XfPbFw6aXakFKWBQP/EqgMmb1
 OUshfnIPUQ+huFZw3KTfMR2+0LErd5L87anwd2BRJUVlAQ/YOPu5M3NdZZ5n2NTUanDZ Cw== 
Received: from p1lg14878.it.hpe.com (p1lg14878.it.hpe.com [16.230.97.204])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3kmj6u1k7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 21:16:13 +0000
Received: from p1wg14923.americas.hpqcorp.net (unknown [10.119.18.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14878.it.hpe.com (Postfix) with ESMTPS id 4D7CE13961;
        Thu,  3 Nov 2022 21:16:12 +0000 (UTC)
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Thu, 3 Nov 2022 09:16:12 -1200
Received: from p1wg14923.americas.hpqcorp.net (10.119.18.111) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Thu, 3 Nov 2022 09:16:11 -1200
Received: from p1wg14919.americas.hpqcorp.net (16.230.19.122) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Thu, 3 Nov 2022 09:16:11 -1200
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Thu, 3 Nov 2022 09:16:11 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GX4KuP9/0pzAcNvUep3bReYMIqHSjOwF2RA+EO34SRQlMLMvWE7dMUUuLtZDs5HBemE2q9o8OTVigSQMEZLEMWOvJIA1CepVZ+r4K4InpcIHSFnNJ3CMq8/fF2IjA10TlJGcA4Qy8oejcVecUDp+YW8FoDXpuWoPyI7ykXXGXSCm6vkUqzFbYaFIm4LnYqDPgajyfzmDCmB681Er2q0SkKV3DA/Ox8DX6p/hT97dZEvdywboqXYNuD0e/pS4h3j6Wv13eqRnaBp0o0SvGi8fSgJypDXjYPIhIo32fkU8QVt/ADmBcN97UlvnG5EZsggBYKiEQnf9Wv90r6zqaNsKIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PPZPxBQ472Ldpp0Yk7fiFtuUQhnpyjmF1TGOsi6xETo=;
 b=g0x/dM0GZ49hDAvBFjHdMqeHfPQbaroIRd2oiOISgsMP8NR0z9Jj2MyiiUA2mRPqGjF5bybmozbUbf6gwiqzKH3OSzowOYNgP7DVkUpoG67IQV3Z4AkvzL5BrfPjaK1nqwh98EROlk/2r0f5fM7DW3Ai0Oy4gpqU5aBlAvHNjmbYyLNiHr3auTu5EZDPoJaK7Pf6UQFgDFUaXSERMAktd+QqkCyfAZPFl2HfwLXQwkYLpFBKWZgoDhN2Tj1jEaF+kakFU4M4rJYj0bX853HupGEybyJmSTsk7cidGKzbP7LU7LSOapv7JkgIVCSq4pqX1YOynCuqjJVRvgYCJ5ws/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by SJ0PR84MB1800.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:a03:381::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Thu, 3 Nov
 2022 21:16:09 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c023:cb9a:111f:a1b2]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c023:cb9a:111f:a1b2%5]) with mapi id 15.20.5769.019; Thu, 3 Nov 2022
 21:16:09 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Ard Biesheuvel <ardb@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "keescook@chromium.org" <keescook@chromium.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        "Nikunj A Dadhania" <nikunj@amd.com>
Subject: RE: [PATCH v5 3/3] crypto: aesgcm - Provide minimal library
 implementation
Thread-Topic: [PATCH v5 3/3] crypto: aesgcm - Provide minimal library
 implementation
Thread-Index: AQHY77nKA3y20aUl4ES9+3z1a5mG0K4tqzEg
Date:   Thu, 3 Nov 2022 21:16:09 +0000
Message-ID: <MW5PR84MB18427E0F1886F8A0273A8553AB389@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20221103192259.2229-1-ardb@kernel.org>
 <20221103192259.2229-4-ardb@kernel.org>
In-Reply-To: <20221103192259.2229-4-ardb@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1842:EE_|SJ0PR84MB1800:EE_
x-ms-office365-filtering-correlation-id: 2bbcbe0c-f516-4c8f-9930-08dabde0a0fd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jyTsW/w/40yDwOSysaVEGCIjEIjSBGYgQZuNOIHIHVcnGGCqCI24uPbDLAu1sWNnzLmYzqVYH7pzX3NTFfUcdxGuXfPj3vgs2Sk3y6A1MVzoF5XUgENGNKo3Ru4qP3a/Si/JHets5dRmKqMnMTtnDiOR00+Y8GFspvetGcf5q5L68cxpnP/BWPFwyQ5g3JHtpu1BoFD6IEoetxIolzPBtAfkkh7DGIMftuLbwKwNHMvnugYVmckP2gXEVqUoCdYU7egfXuH06+K2ICa8md99uv52teUID4AwtlPTXOknVGSNFWqBLAiW+6Vx4TaSaUqV96bWmHh5zUxma6jGGcIXioIL+FIc8wHIqRYLmT+OECk0RMnUde2dIR2uoT1c0NPhecBFyKlu+zIr6X9luRS1+TEjEVLtC4XutzFuunsC95AIy0N+PNWkOFQFR4VjhM8/P4ePeCzc9e4Sj/56M6HvDDI9ClrmFOmTgdCveOUFEWwmDSeHIwbjpCqR6G7Z7TxAXbUivKZ4owRmHNIVpshQoY1BEO6+v1p1EWy2thseKrpHyo39i6YbG+J4jtxYMDtZWn1jQ4DTlabRPsX7tLN8eyYm30lGR7tNgSuPrhj0ktGQ86XCTQGeq89aUH0Wf8ecwFThL5B/CMtw48DM1NGEQ5TNYgkLij1J3ty1+Si4MxKBIXU/8Io/Q+DuBdev0CGh5Za/YzLYbkBM7w++UrCTShrGjsLPfpkrS9/pruIN4RVPdifnM72jl/S4CCLTOHAMuNSJu/ksGAasGF/w862S7g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(366004)(376002)(136003)(346002)(451199015)(66946007)(316002)(33656002)(86362001)(66446008)(64756008)(4326008)(186003)(66476007)(55016003)(53546011)(66556008)(6506007)(8676002)(76116006)(7696005)(2906002)(5660300002)(26005)(38100700002)(83380400001)(41300700001)(9686003)(52536014)(478600001)(8936002)(71200400001)(110136005)(54906003)(82960400001)(122000001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?z6BVPxw7GfiBISP8asCK1lmr+9B7aIOC6U3N0IsaUZ2zhNdASTX5ib1BSvfH?=
 =?us-ascii?Q?3QhzDMLWB+NmjT3kezhaxHenfTJ7c78zzLz7dJ8HyFGb/ATaTnK0ByAECbpf?=
 =?us-ascii?Q?9gNZBN48q/FuxAUNrZk9yMibasY/WKosFThciCCgyXpxN5wMElatf1PdBaO7?=
 =?us-ascii?Q?nVjNTfHsQLxGpwPRl/Mwq0U752VxPwl1YVrg3LtzIOF3g/ZOaTgDBkP7LhV/?=
 =?us-ascii?Q?eUz4duH7bDKpFKDvptJfG2e50oGNxIRNJXQDOuBpl0SSvWx/B+KSjcltbDPT?=
 =?us-ascii?Q?kbrUBLJdSSYSMDGiP+qKF/o5eimx6c4xrXvNuh6wcZuKMO8D+m1QWWJ32Qt4?=
 =?us-ascii?Q?xwepYz9aaLZ8olG046kget9K+mP5Mwyb/ywvsVDOmjrzr82sIpllI3/y6SAy?=
 =?us-ascii?Q?iAzsiOSVIpBSC2CyUV/6fhd6Anuadfu6AU7sFveNolUwiqezrBhzVNtvoX/h?=
 =?us-ascii?Q?gtghZdZyvabpIfCDm926DOTTJ7zu/YvJqTnuwv3IULy1PeBab7kGHaIjb91z?=
 =?us-ascii?Q?cIWzY3WYjdcZ5/RndnybVlVsDyV6gWpKS+/PBza1BWYHw0kAlRRTldp4Tr8n?=
 =?us-ascii?Q?ZBK9KoqN5GidYsYMCS+GD9F+B2dWQcoS8AZZd+/VMYxMqWgvE7vFthikmOhf?=
 =?us-ascii?Q?NoT5PqCu4Tgye6eDCAoAxUOoHRzEzmYWAFS9cfbmTF84pBvOSgdEhTmOAP3v?=
 =?us-ascii?Q?xiZ7C/rvheSg8w/rCeNrboJ41uk3CxEBO/mE2iIz/zNbYnMbIcibbG5dElK6?=
 =?us-ascii?Q?MtIXW31UsfZWbMB+toUEuGHLKDhthdUiIp4ttyV8cvMTQkuH8HvixoTTRW7W?=
 =?us-ascii?Q?FFbpTSJQKwq+zecpWWRkiYxgMdkacR5TJhP8KT4GEehVpVZ6f7Lc0bl6DL+/?=
 =?us-ascii?Q?SjqbcjJVyWGrzfqvzAXVIZ+O6Gzta7VhgLunmyR3YxBPBFbpD3zZ+RI8hH7q?=
 =?us-ascii?Q?qWBKzyTBEOn8QqPkDV/CGKDFRsN0kocyYZT8XnIkHFDGDOd2hIfTCwjaQwHw?=
 =?us-ascii?Q?CyEO4BpTHF/oxPqfaaztmHQZ2FgAcTeT4Ek+wK3LP44I4BDzrMdK+8d83Kxx?=
 =?us-ascii?Q?h+4hljwoV9WKS1y3ELds31emxRmzaPSgTV9JYkzx0o4H0RzRuIANtHdpxgjt?=
 =?us-ascii?Q?ZAuLle2ivCGMfCSIAqnghHsNFDm2995Re/0UMd6PsMv00QNcvWrkBIU+xZH8?=
 =?us-ascii?Q?tArvcEBefugYlbbWelwbsocusnTit+uoQJVKitt8mbk5xZPSMNVYva6NJGMu?=
 =?us-ascii?Q?o3gnKcgoYPbVjI7EtxAMj9+JJP350fWme4rckYTamVkhwceHD2yntJkuouFM?=
 =?us-ascii?Q?rtHueitC/CKa66qip5ulJXk94kfSIjyQkmOrBqS6mzmUT0ANx7/SZZv9rieh?=
 =?us-ascii?Q?9EBFZ6Myi/raFytDbafTvsLtVyCjLD+sQiAuM4mSjdnwjzmYqB8qUTmSCP9B?=
 =?us-ascii?Q?GW+zRhjMoAngdH0RxdL177pzJP+RnTfr9gyhQ7DksmiuiEEhVytqA/h/EEUa?=
 =?us-ascii?Q?UXA9uHhPavCULvvNmNKyQpI6Zakg1MPhfikbc61eG1rMeL6v+FJVh4gA1HE2?=
 =?us-ascii?Q?twQHsuLVltkFYhGKAnA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bbcbe0c-f516-4c8f-9930-08dabde0a0fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2022 21:16:09.7332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: km3phGTxtrQ5HCVYr5BrWnmBfANgLkPfbagKQEQcbMl9bRDgsa3qfHP4vsxo58ii
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR84MB1800
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: otwPW50GKhIs92V5jx7jtnDSnXRsBDL7
X-Proofpoint-GUID: otwPW50GKhIs92V5jx7jtnDSnXRsBDL7
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_04,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 bulkscore=0 priorityscore=1501
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211030146
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> -----Original Message-----
> From: Ard Biesheuvel <ardb@kernel.org>
> Sent: Thursday, November 3, 2022 2:23 PM
> Subject: [PATCH v5 3/3] crypto: aesgcm - Provide minimal library implemen=
tation
>=20

Given include/crypto/aes.h:
struct crypto_aes_ctx {
        u32 key_enc[AES_MAX_KEYLENGTH_U32];
        u32 key_dec[AES_MAX_KEYLENGTH_U32];
        u32 key_length;
};

plus:
...
+struct aesgcm_ctx {
+	be128			ghash_key;
+	struct crypto_aes_ctx	aes_ctx;
+	unsigned int		authsize;
+};
...
> +static void aesgcm_encrypt_block(const struct crypto_aes_ctx *ctx, void =
*dst,
...
> +	local_irq_save(flags);
> +	aes_encrypt(ctx, dst, src);
> +	local_irq_restore(flags);
> +}
...
> +int aesgcm_expandkey(struct aesgcm_ctx *ctx, const u8 *key,
> +		     unsigned int keysize, unsigned int authsize)
> +{
> +	u8 kin[AES_BLOCK_SIZE] =3D {};
> +	int ret;
> +
> +	ret =3D crypto_gcm_check_authsize(authsize) ?:
> +	      aes_expandkey(&ctx->aes_ctx, key, keysize);

Since GCM uses the underlying cipher's encrypt algorithm for both
encryption and decryption, is there any need for the 240-byte
aesctx->key_dec decryption key schedule that aes_expandkey
also prepares?

For modes like this, it might be worth creating a specialized
struct that only holds the encryption key schedule (key_enc),
with a derivative of aes_expandkey() that only updates it.

