Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9ECEC0650E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 17:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B44C8218A0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 17:10:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="qSIHAi2c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfGCRKb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 13:10:31 -0400
Received: from mail-eopbgr130084.outbound.protection.outlook.com ([40.107.13.84]:47753
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726430AbfGCRKb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 13:10:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wpM14TJHytTU7ev4exyN9gC1pt+3+sCqijV3yyGhTnI=;
 b=qSIHAi2c5nPmRgPfyUwjyb/XauUqDgno5P7gsk7iWXjRAfRhBdtuCBcJhcN9BKeljY3RMT74epTKJDZY5qeNKKmtf/geEWMNeWZqps/8ho0Xb55pP5pt12A6AJ7zh5RwiWnPBPcnHF9e5oJoaSz33R/sJpUEctyBVVEpR871aQg=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2798.eurprd04.prod.outlook.com (10.172.255.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Wed, 3 Jul 2019 17:10:26 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba%6]) with mapi id 15.20.2032.019; Wed, 3 Jul 2019
 17:10:26 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Fuqian Huang <huangfq.daxian@gmail.com>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Gonglei <arei.gonglei@huawei.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v2 06/35] crypto: Use kmemdup rather than duplicating its
 implementation
Thread-Topic: [PATCH v2 06/35] crypto: Use kmemdup rather than duplicating its
 implementation
Thread-Index: AQHVMbwvhMxjtgd8Ck6FxllExWXG3A==
Date:   Wed, 3 Jul 2019 17:10:26 +0000
Message-ID: <VI1PR0402MB3485A113C5FB19DC556B678B98FB0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190703162708.32137-1-huangfq.daxian@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 872d7a5f-e0eb-4b41-98ca-08d6ffd957f5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2798;
x-ms-traffictypediagnostic: VI1PR0402MB2798:
x-microsoft-antispam-prvs: <VI1PR0402MB2798E20A16034BEE9101227798FB0@VI1PR0402MB2798.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(199004)(189003)(4744005)(53546011)(476003)(25786009)(4326008)(486006)(6436002)(6916009)(446003)(6506007)(74316002)(33656002)(26005)(14454004)(102836004)(7736002)(305945005)(186003)(229853002)(44832011)(99286004)(66446008)(64756008)(66556008)(66476007)(8936002)(8676002)(53936002)(81166006)(81156014)(2906002)(66946007)(73956011)(76116006)(91956017)(6246003)(5660300002)(256004)(76176011)(3846002)(6116002)(52536014)(54906003)(7696005)(9686003)(55016002)(86362001)(66066001)(68736007)(316002)(478600001)(71190400001)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2798;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ad5e7Wmf+qRRWmAKhqjaqEmJ6yHHPGkD4WgjtggahiZhIrJyuF2/JYw/g8tNcLyPZTUenhOUu5KsAAz0WLlclp2601QtIThKLYgWSVHuTspmjzWpqjLV/I0ICy2j52J5QBKbVjZPZGc/nCg2zikflh8WHOLZj1vfXldpp9o3CWVPL2bGJfJunvziDCOmIZl236/3D6R/RcW7YG/b5uAsRC9+SuMNXzpG3aT6ILlLLB7PVdu9kK37KI3XQIDMYrNrmwudAeG9wgFGAzFBk3PK21Hl8Y/xPMO3WygCe4VCvLtAwFZcriAwhcwK0MuWGlN1r8Nywf1VgwUmbxOJ1haTb/eX3nzMlGUPshZLbYK+mKItxMfiX5CPfrk09grSwaplNqxtA3O359gHv13wlvbojWsPZAm8FyDQnB1G+OpodCM=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 872d7a5f-e0eb-4b41-98ca-08d6ffd957f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 17:10:26.6883
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2798
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/3/2019 7:27 PM, Fuqian Huang wrote:=0A=
> kmemdup is introduced to duplicate a region of memory in a neat way.=0A=
> Rather than kmalloc/kzalloc + memcpy, which the programmer needs to=0A=
> write the size twice (sometimes lead to mistakes), kmemdup improves=0A=
> readability, leads to smaller code and also reduce the chances of mistake=
s.=0A=
> Suggestion to use kmemdup rather than using kmalloc/kzalloc + memcpy.=0A=
> =0A=
> Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
