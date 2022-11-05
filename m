Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A4A9C4332F
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Nov 2022 16:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiKEQVO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Nov 2022 12:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiKEQVJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Nov 2022 12:21:09 -0400
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A781A3BD
        for <linux-crypto@vger.kernel.org>; Sat,  5 Nov 2022 09:21:05 -0700 (PDT)
Received: from pps.filterd (m0134424.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A5Fc6ZS006839;
        Sat, 5 Nov 2022 16:20:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=cvoT/Tmx9ewSho2E5yWsk4+0puZQSpuMfnKnlcQRs2o=;
 b=nU83jn4lECvq7439QFAgvxb98Hxf1g5BxStW/X5yjX652AV/qyd/w+Caq+kp/NLF2wfE
 v/S/ylZ9IQH47yCIkvO4mA7p+w9VwSuYzXbLdVF1mmI80AmADBKjz7P2urrYr68LR03l
 TpYiFmmHaUMI19mJYT2zboT9eHnYiw8zAsKUXR/OUQpl4KcizS2he2g4/200rndMe/95
 kI2uB2No15sdoM5tRXa4RlTXD6sHrXWb2R1KgGl5OmD0T4yxlRLiD8lL01mC3+tR7ZUy
 lHX70ItXPUoXrNQjRdYqbefuL4IKJPTBxCiKA5/dL9bbWo3czbgOrsUo9MlO+3li84Qo gg== 
Received: from p1lg14879.it.hpe.com (p1lg14879.it.hpe.com [16.230.97.200])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3kngm2ju1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 05 Nov 2022 16:20:25 +0000
Received: from p1wg14925.americas.hpqcorp.net (unknown [10.119.18.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14879.it.hpe.com (Postfix) with ESMTPS id 962B7295B6;
        Sat,  5 Nov 2022 16:20:23 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Sat, 5 Nov 2022 04:20:18 -1200
Received: from p1wg14925.americas.hpqcorp.net (10.119.18.114) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Sat, 5 Nov 2022 04:20:18 -1200
Received: from p1wg14920.americas.hpqcorp.net (16.230.19.123) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Sat, 5 Nov 2022 04:20:18 -1200
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Sat, 5 Nov 2022 04:20:17 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwh6QgYDQ21o0sED1bTrfejko4k7cEczNmDW6ip4t+moWD76Cr09n8DGD98JIMisk9GAd/zg/sc2LpTG3O7QziRc4Ap9STP2k6/aGgpBi3YJxRO+9zvB6QhTuVi8hQjurISyGQ+ShpT0rb4jy8MKHFrjRlBwSVSH6LiXH9aRu1mXvjb71ANSaOZQbX9C4RgXNmnQuSO4yzBECYV+ER7IaAMcELPrJSX5IGA2ZFQut+kGdxxwKy3K/IsfXxuDD+6kwfU4nPaIpSjDbCn/OYSXSN1SHUvyPxO2ufV9BuRMUeWwDFKOUz8FbwIluCMXB+hYQ+vgUO6DX9aJ00uqdK5lgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cvoT/Tmx9ewSho2E5yWsk4+0puZQSpuMfnKnlcQRs2o=;
 b=b3bAXfBVfaRHXPHZl13S1Ggv+Lbnfq831V9YJ1pdtm+T20PwX8lmT8Kd4BxKzsP8IAzBtWKgt/ljqjV/CnAixsVYGNLH7ywFjH4N7H79ebbDtvJ6SG3feo9Zwq8/FC2lGrk0ZD/jm73+1kMm24SK76CBA55rgIXZEBJ27bB8kRTkIPo/ZSD133NMiSOl/YA/vKpQevxyE6HYIYVXu7qEUZuo8kuZDcIqlmvlT6W8wVJsWvQ1D5p7418DHFF8P+phYbHSnrARrzXULFOVFA2qnXC0jTpcIdWLEG5IdXsiyQ+8ytRj3PsBl2QudbxYKdjGcyFTPtK77LnLcTAxI7XOLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by PH7PR84MB1485.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:150::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Sat, 5 Nov
 2022 16:20:16 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c023:cb9a:111f:a1b2]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c023:cb9a:111f:a1b2%5]) with mapi id 15.20.5791.022; Sat, 5 Nov 2022
 16:20:16 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Taehee Yoo <ap420073@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "jussi.kivilinna@iki.fi" <jussi.kivilinna@iki.fi>
Subject: RE: [PATCH v2 3/3] crypto: aria: implement aria-avx512
Thread-Topic: [PATCH v2 3/3] crypto: aria: implement aria-avx512
Thread-Index: AQHY8O+fXPj6RpDrIEWfmNHho+KTdK4wfI9A
Date:   Sat, 5 Nov 2022 16:20:16 +0000
Message-ID: <MW5PR84MB1842E11FD1CF7B44703A42B0AB3A9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20221105082021.17997-1-ap420073@gmail.com>
 <20221105082021.17997-4-ap420073@gmail.com>
In-Reply-To: <20221105082021.17997-4-ap420073@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1842:EE_|PH7PR84MB1485:EE_
x-ms-office365-filtering-correlation-id: e682ae7e-1cfb-46fe-9f2d-08dabf499fee
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iLTGb8/GrGtOTsWNHKpX5FXnMxWWpKl5Lw41IjUmRGuoURWYD57DMSsYF+qoGCiu5iPASR09oMfJEw5jZtC7G7f2YzlnnJd29TGH+dkbLbQMHKLMX0th/HMBWT1CAYNU7sK08xj00GMR45DbeVqatNEjt9LuDXkjjb635TiiMEoO5dqvSd1E2aI5gxeLQ/rHsW1h9gVtkUfRVAcfqwdomsAkaJA3/STpzaDOnSGPl6N5p4+UDWPcM7ievaE/C8kTcS7uxlh4IvthHCYzWUKnjQL7NAkgpxu/nR8jjaOnn24pbbX2mh9rhWUZ01mTcF7FeT+cs3DGKWvttZR2aL3siLyGut6NZJLvJ2OdX84RrhAVRCG+oTi3A+gK5TXMu/zYpaQGXLJfaFvhzn6qLGjzRLtvd2ByMEfeTh/eFTqsG8DLjryrmo1OL4z5QX1VBGdBsHsJci2ZtigFfTflKNkcc5AJj90H6mCYqp+y/uIEvcNnpc6U2dE26Z8J9yDTq+hF9QL5l4QPk+ey1lc69JC8f5dROPSm46B7F8AxDwgOWr2v+8P8x3+Xkq5OPPZHUqiJitXO59X500nanOz4l+nE2H4+4qgoFwdgfrgCyliofjnfIXixzfq382OQ+apDWo5qd0LZpqQhWngZ5PgNVBCgN+3r1Uc7dNG/OQ+svKn0afz4gKr2ljl3sNH7iUZn0cchwc5WSnwoN/09f1ezJEgUWvNiFqczu+lI7stBBXeT4iBjLBYGxz7JvqolEzcmJvA5sb+eR3y/NrX/O57dv2mOUYQ9VDxu4/5lwYQVZSPW/xo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(396003)(376002)(346002)(451199015)(52536014)(5660300002)(82960400001)(41300700001)(8936002)(7696005)(6506007)(7416002)(316002)(55016003)(71200400001)(76116006)(66556008)(8676002)(66476007)(66946007)(66446008)(64756008)(122000001)(38100700002)(2906002)(110136005)(33656002)(38070700005)(86362001)(921005)(26005)(83380400001)(186003)(478600001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MJYc618y4jD+pacyog2UYygRrFvNvwpxEJTlIPMOfmq8DrKD2e7o560uN/04?=
 =?us-ascii?Q?ECjT6pze63cxszWy49u+GOnfeHaDStULq4dJfKyUOQPKnqMe9gvCLvA0sTJm?=
 =?us-ascii?Q?8kOiCRxmU6FHXUB+Nk3226kzvOuLeACNpBWVykz9tIgLjGUvyLusjNb15f3p?=
 =?us-ascii?Q?3yL9AZ90CJ5DfJMJvG10Dfyfd/Li62+LVATvURWIdsf1tHSUD6vg4YCq6iLF?=
 =?us-ascii?Q?KUWqPiJJgo5dRQEcOFgZzgL92SwlnPdZDHutl2TCsw4etiqL250sDtdq8KjL?=
 =?us-ascii?Q?qRiDILUB+ae29AgV+LsPPeIIO9txNyCSzgJd7z+wYcw/HkulU4im2sM9Q0Kh?=
 =?us-ascii?Q?wcZWzWwEdrEZW6jfbAxkEkdxDYmyMjfb6SdNHUyUoGfrffOQYnL0wihIV8Vo?=
 =?us-ascii?Q?Z9By1dlB5oc1kd8EjP95CHvPTZHv+2cWmio5DW1ACvNZ8+K+gqVJRMdczGgX?=
 =?us-ascii?Q?OLTVyjh07q+l5mttuzQUw7P39j33TcUx+NKdU6YNXKy7QLdId1iSXrfelmrU?=
 =?us-ascii?Q?6O4tJACbwINxRSxL3v4N3YOv9IywNkcBqZQbbiTbmySX6rK1ktRMgToqibu/?=
 =?us-ascii?Q?W9GZwyUL81gE2gmCFiIZpK5ykTKTfapqx+xIzapQrGaOX+AEybmpm9B8m+At?=
 =?us-ascii?Q?3RhKhdSz2LDvru6htp1zeo6YPDAwOqhWEN/xjKBCQlpKpLRQXMyCMti5dir+?=
 =?us-ascii?Q?lZWFo88PKpngI75N8ovy7gf4w6pyVHr59eFK2R1DNdS296qlZNcSqIhMepZl?=
 =?us-ascii?Q?ndIqPywmOHoU1XK69V7SIn3b/Lw49vKBYvNQERG61GvQvNhSdvmJiT/FtBcE?=
 =?us-ascii?Q?/c+j71IneJ+hJf+IiYr0gNCyWXwqK2QAEk1CJvPEfKMTwnFMtCNFSQIU8NPY?=
 =?us-ascii?Q?qud5xkwTvDu+Bbfqyb8zPKoDJojeNePd9BZKIABxroVM23Q8JAAudGsPVJPx?=
 =?us-ascii?Q?RsWhUxOzcOg1hN0i8WBFSud82zT45RE3Sj4deWodw1xn2pSO1tSTnMCEnLjx?=
 =?us-ascii?Q?ATtAZAA7irdSIdSlV1CizXncEXEU9Mv87+mGQuRl11bHYhpVPRVxgAnTp93+?=
 =?us-ascii?Q?VvW1v1JZ2dJ6Ae8RIVCPU9k0L5rwUhzz10jg1pFjWe/m0dSLEww5bL+I/3Hb?=
 =?us-ascii?Q?TMYUBClSXzJKzPNPqg91fOuBqnNWZCk3S9Mb9+NADJgqsgzcfIqIFsEm4ake?=
 =?us-ascii?Q?pIBUNv3dMkWwA+r2DYtYR7zfF9nwYq44etCE9d7m96Dq9YNalVvBMRtpWaWg?=
 =?us-ascii?Q?W8pI4PR86QYv/wovE6AWlGogbv4guh2Aurg0mmcY3zxp4syywp/rpAWROpdr?=
 =?us-ascii?Q?62yYY6iH0uuJZNVDAzquNVhSsfdxXIAQNBRMLTJSAC2XYv/w76luOg7dVgSE?=
 =?us-ascii?Q?GWQw7cdEKVyw4ft6j8CIszES9Eu6Mt//zFu/bPba3h0pPpCFkjl87N+kIB0m?=
 =?us-ascii?Q?5AW5tFEhEl/8EHQeJmCD+K30BqFqmP9EStIVS/vTsw9OuWSfydnnMAqips36?=
 =?us-ascii?Q?BaqHa+/w+hiP4SzgVGVZtAD+Y1H9L3w4rVyAVRMkescuwqYX7Cf7wdeJgNqt?=
 =?us-ascii?Q?LnO9kpuubRBRV9KVqaM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e682ae7e-1cfb-46fe-9f2d-08dabf499fee
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2022 16:20:16.2455
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ShhGyDjlPpljEpIUe0rceFygxpTmn1ZRWAQbUPJlKRRoNYzhWcUG+kHkLK9gPhSp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR84MB1485
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: GOdAIbrYZK0GsrLP57fkulQpNxRXVGik
X-Proofpoint-ORIG-GUID: GOdAIbrYZK0GsrLP57fkulQpNxRXVGik
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-05_09,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 mlxscore=0 adultscore=0 suspectscore=0 clxscore=1011 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211050123
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> +++ b/arch/x86/crypto/aria-gfni-avx512-asm_64.S
...
> +/* struct aria_ctx: */
> +#define enc_key 0
> +#define dec_key 272
> +#define rounds 544

I've noticed other modules with assembly code also has=20
hardcoded assumptions about the offsets in the context
structure. Sometimes they don't use macros, so they're
less apparent. Example from aesni:

SYM_FUNC_START(aesni_dec)
        FRAME_BEGIN
#ifndef __x86_64__
        pushl KEYP
        pushl KLEN
        movl (FRAME_OFFSET+12)(%esp), KEYP      # ctx
        movl (FRAME_OFFSET+16)(%esp), OUTP      # dst
        movl (FRAME_OFFSET+20)(%esp), INP       # src
#endif
        mov 480(KEYP), KLEN             # key length
        add $240, KEYP
        movups (INP), STATE             # input
        call _aesni_dec1


To ensure the C code and assembly code stay in agreement,
it might be prudent to add a compile-time check in one of
the C functions for each hardcoded offset value, like this
for aesni:

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-int=
el_glue.c
index 5db4814583ea..e4bcba765c77 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -288,6 +288,10 @@ static int aes_set_key_common(struct crypto_tfm *tfm, =
void *raw_ctx,
        struct crypto_aes_ctx *ctx =3D aes_ctx(raw_ctx);
        int err;

+       BUILD_BUG_ON(offsetof(struct crypto_aes_ctx, key_enc) !=3D 0);
+       BUILD_BUG_ON(offsetof(struct crypto_aes_ctx, key_dec) !=3D 240);
+       BUILD_BUG_ON(offsetof(struct crypto_aes_ctx, key_length) !=3D 480);
+
        if (key_len !=3D AES_KEYSIZE_128 && key_len !=3D AES_KEYSIZE_192 &&
            key_len !=3D AES_KEYSIZE_256)
                return -EINVAL;

The sha functions and sm3 have such a check for the first field
(but only that one) in their context structures:
    static int sha1_update(struct shash_desc *desc, const u8 *data,
    ...
        /*
         * Make sure struct sha1_state begins directly with the SHA1
         * 160-bit internal state, as this is what the asm functions expect=
.
         */
        BUILD_BUG_ON(offsetof(struct sha1_state, state) !=3D 0);


