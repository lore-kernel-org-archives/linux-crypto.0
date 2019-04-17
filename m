Return-Path: <SRS0=UJZd=ST=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33819C282DC
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 09:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 029752173C
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 09:47:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="WYVz6o3G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731108AbfDQJrm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Apr 2019 05:47:42 -0400
Received: from mail-eopbgr150058.outbound.protection.outlook.com ([40.107.15.58]:37463
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731868AbfDQJrl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Apr 2019 05:47:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cVmY8AlXc9+RgxMCmMTpaykOHS09p3ErFXb02TImzHQ=;
 b=WYVz6o3GJ51dNwVhRXoTWFjiLRdvIHc/WwzLJn32j449MT+7CGJza1yVLJirxSsSyNME0wZSEqh6NHPlgFwsR+UGCPZXb98fUAgE+e0iMAGWoZM+oWdR+NFcPUukFPDwzrZuxhFgBiuS2QuseJniAqwEs+eYn/xTNryWKlfqQwM=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB3023.eurprd04.prod.outlook.com (10.170.228.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.12; Wed, 17 Apr 2019 09:47:38 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::e136:3450:c3e3:3517]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::e136:3450:c3e3:3517%5]) with mapi id 15.20.1813.011; Wed, 17 Apr 2019
 09:47:38 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: caam/jr - update gcm detection logic
Thread-Topic: [PATCH] crypto: caam/jr - update gcm detection logic
Thread-Index: AQHU9HFGSk3p1r6fIU6l0LPJ9licjQ==
Date:   Wed, 17 Apr 2019 09:47:37 +0000
Message-ID: <VI1PR04MB44451A2A26D7B7A79EE6BE658C250@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <20190416162712.31106-1-horia.geanta@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 42042a59-790c-44e2-da9c-08d6c319b9eb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600140)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB3023;
x-ms-traffictypediagnostic: VI1PR04MB3023:
x-microsoft-antispam-prvs: <VI1PR04MB30232FD1B9D395780C5B74578C250@VI1PR04MB3023.eurprd04.prod.outlook.com>
x-forefront-prvs: 0010D93EFE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(136003)(346002)(376002)(396003)(189003)(199004)(44832011)(74316002)(14444005)(7696005)(14454004)(97736004)(478600001)(71200400001)(71190400001)(8676002)(81156014)(81166006)(305945005)(7736002)(8936002)(99286004)(256004)(4744005)(54906003)(86362001)(66066001)(110136005)(2906002)(106356001)(52536014)(6506007)(105586002)(229853002)(6436002)(102836004)(446003)(186003)(25786009)(5660300002)(53546011)(33656002)(68736007)(316002)(76176011)(486006)(476003)(4326008)(6246003)(3846002)(26005)(9686003)(6116002)(53936002)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB3023;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DgYNs5t/U+hmHBYyxrGizB9NL2qW0GKbpoStbBxosf73cccwdxCWC0iLf58zwqh4NIABe2jl9Bf5b1HQqSspwaFXoODdeNXVMwAqpYfEpxT41Kba3gYsXnrnYI8mVOAg5VoNyuHD7vbvWFOtchpEFczAI+H61+ccJme6Z1akWjM/vsI4KBLbbRzYntYpACKqiwW0dKwUuastRDOGYvpf02xvJCGYGgmCKp24wq4Is715lW9Ryxs+Y2mHrxvIY1t8jtqCUiefaej04uoU5SWoub8JgTeE/WpMZB+68U5wms/kcA2gdWF2TaxjjDW62E7a9JheFYNpkkAghKkVxBdmPgcarfQSmasOCh5EVjIxNi/mNhA5G+qhuJg6gOdXndjTV8hSTedIZ3BSYP5s6Z+AGKZZ+MDIRM4CcShcxva+gz4=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42042a59-790c-44e2-da9c-08d6c319b9eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2019 09:47:37.8923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3023
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/16/2019 7:27 PM, Horia Geant=E3 wrote:=0A=
> GCM detection logic has to change for two reasons:=0A=
> -some CAAM instantiations with Era < 10, even though they have AES LP,=0A=
> they now support GCM mode=0A=
> -Era 10 upwards, there is a dedicated bit in AESA_VERSION[AESA_MISC]=0A=
> field for GCM support=0A=
> =0A=
> For Era 9 and earlier, all AES accelerator versions support GCM,=0A=
> except for AES LP (CHAVID_LS[AESVID]=3D3) with revision CRNR[AESRN] < 8.=
=0A=
> =0A=
> For Era 10 and later, bit 9 of the AESA_VERSION register should be used=
=0A=
> to detect GCM support in AES accelerator.=0A=
> =0A=
> Note: caam/qi and caam/qi2 are drivers for QI (Queue Interface), which=0A=
> is used in DPAA-based SoCs; for now, we rely on CAAM having an AES HP=0A=
> and this AES accelerator having support for GCM.=0A=
> =0A=
> Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
=0A=
Thanks,=0A=
Iulia=0A=
