Return-Path: <SRS0=nMY8=UM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29322C31E45
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 15:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 028EF2082C
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 15:24:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="TkolVTuI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732778AbfFMPYA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Jun 2019 11:24:00 -0400
Received: from mail-eopbgr10082.outbound.protection.outlook.com ([40.107.1.82]:37754
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731734AbfFMMQ0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jun 2019 08:16:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8pubeHdJ3qZsawX6ybkUmUsvMuU/H47eerguowtxKg=;
 b=TkolVTuInkmBqLnwLWIACcDzpwStnz1x+w1AXZVpHcI8+CKdmqAxlF9jGto8eWucKFbE+y9rQ69TJFSFhbcFH3qGarzvJl0aExZZbgUHZLgBdylkl0ImawCG8zHGzAzfv2S8YD619oxPyGx34dhC6GLL5iYQTVn5HeSirng/xqk=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3743.eurprd04.prod.outlook.com (52.134.15.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.17; Thu, 13 Jun 2019 12:16:21 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1987.012; Thu, 13 Jun 2019
 12:16:21 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v2 3/4] crypto: talitos - eliminate unneeded 'done'
 functions at build time
Thread-Topic: [PATCH v2 3/4] crypto: talitos - eliminate unneeded 'done'
 functions at build time
Thread-Index: AQHVIGOIQP2x5QtZB0WoMkrOdNiB0A==
Date:   Thu, 13 Jun 2019 12:16:21 +0000
Message-ID: <VI1PR0402MB3485CE6D5D9F3AF8E010378398EF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <cover.1560263641.git.christophe.leroy@c-s.fr>
 <09bbce930ef6bf209c5bb5241fccc6b4dc583ba5.1560263641.git.christophe.leroy@c-s.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [78.96.98.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c5662b4e-0a7c-4c39-4a40-08d6eff8f28e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3743;
x-ms-traffictypediagnostic: VI1PR0402MB3743:
x-microsoft-antispam-prvs: <VI1PR0402MB3743668D73C2F079D17E70A898EF0@VI1PR0402MB3743.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(366004)(376002)(396003)(346002)(199004)(189003)(5660300002)(52536014)(305945005)(14454004)(71190400001)(71200400001)(8936002)(81156014)(81166006)(8676002)(256004)(446003)(110136005)(54906003)(316002)(7736002)(33656002)(478600001)(44832011)(486006)(476003)(186003)(91956017)(66556008)(66446008)(64756008)(66476007)(73956011)(66946007)(76116006)(86362001)(55016002)(9686003)(102836004)(6506007)(53936002)(4326008)(6116002)(3846002)(76176011)(7696005)(6436002)(74316002)(68736007)(25786009)(4744005)(229853002)(66066001)(99286004)(2906002)(26005)(53546011)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3743;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: l+eW8ulnS1yLmax/kwQtejfjtvYnZUqOcGU4gw7RMv379N8VMFkvS6LMCIZ+JXMnxiTPKrF0USt5LUCN6E8750iyWm+/si7EbpnBa6riHG14PqTr30P4tvcrohLEYalEhVM4YCLuMvhZM2CSuL51TzhVYNLBdU1Qn60+qJ6uxCpqtAu6qTj7OKsG0PJabJMBhbS3jcXaxpw1793t32uVZZ9IGwKVsZVCbKVtToJDoch/pt2UWgL6gGvjvfX4pWRsd9my1hhC9K77nlIabzKe0L7i+YVswQiEaYGKDGBds4M8PzBdRcU1Gr85+cKLCoduQMGnhwbAMxy2Gt6ng2bOxiV2l+MfVbYHIeA6SgaW4VKnSny7cQTtE5WDqAruJHKG70hC3XnOmIeP87v6kJGkpsLcVaxnVUXYs9OrHFj507Y=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5662b4e-0a7c-4c39-4a40-08d6eff8f28e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 12:16:21.8413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3743
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/11/2019 5:39 PM, Christophe Leroy wrote:=0A=
> When building for SEC1 only, talitos2_done functions are unneeded=0A=
> and should go away.=0A=
> =0A=
> For this, use has_ftr_sec1() which will always return true when only=0A=
> SEC1 support is being built, allowing GCC to drop TALITOS2 functions.=0A=
> =0A=
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
