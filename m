Return-Path: <SRS0=nMY8=UM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C162C31E45
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 15:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 455FC2082C
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 15:22:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="UKcrGmGt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732921AbfFMPWX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Jun 2019 11:22:23 -0400
Received: from mail-eopbgr20057.outbound.protection.outlook.com ([40.107.2.57]:14659
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731980AbfFMMji (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jun 2019 08:39:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zagcy70nrZEkZHMPRCoAChUpGg5p9HOwkY1TU5/4jVc=;
 b=UKcrGmGtuD1FHEt+b/1GIWkkxAba0IxuQx72a8Wyr4Gd+ZumWU7+0O2ptQiVZWIJd+HWtpHqvVBtP1+HRWTuoHWYgOWCdNlrRaz3JS3hYqChedb86qqHWs8IFpj68WBaLnvstAiCEoUu02wiKsgYWVYayApFnM73v5Zwg8BSjq0=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2943.eurprd04.prod.outlook.com (10.175.24.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Thu, 13 Jun 2019 12:39:34 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1987.012; Thu, 13 Jun 2019
 12:39:34 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v2 1/4] crypto: talitos - move struct talitos_edesc into
 talitos.h
Thread-Topic: [PATCH v2 1/4] crypto: talitos - move struct talitos_edesc into
 talitos.h
Thread-Index: AQHVIGOHWjiLuJ/iA0u2rV751i1YWQ==
Date:   Thu, 13 Jun 2019 12:39:34 +0000
Message-ID: <VI1PR0402MB348514C4AA9E41C26FF4430998EF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <cover.1560263641.git.christophe.leroy@c-s.fr>
 <d9b5fade242f0806a587392d31c272709949479f.1560263641.git.christophe.leroy@c-s.fr>
 <VI1PR0402MB3485C0F4CB13F8674B8B5A5598EF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <7fb54918-4524-1e6b-dd29-46be8843577b@c-s.fr>
 <VI1PR0402MB34858ABA5DE0324FA6E2CFCD98EF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <ce6beda2-75c8-f360-9e01-5a883128d153@c-s.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [78.96.98.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8939f288-383a-4459-90af-08d6effc30aa
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2943;
x-ms-traffictypediagnostic: VI1PR0402MB2943:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0402MB29438948A34965569BA0BD0C98EF0@VI1PR0402MB2943.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(39860400002)(396003)(199004)(189003)(66446008)(91956017)(76116006)(99286004)(5660300002)(6436002)(71190400001)(76176011)(7696005)(53546011)(6506007)(71200400001)(110136005)(54906003)(52536014)(66476007)(66574012)(64756008)(66946007)(73956011)(316002)(66556008)(33656002)(66066001)(14454004)(229853002)(26005)(966005)(8676002)(81166006)(86362001)(8936002)(81156014)(478600001)(7736002)(6306002)(9686003)(305945005)(2906002)(25786009)(53936002)(55016002)(74316002)(102836004)(446003)(186003)(6116002)(3846002)(256004)(14444005)(486006)(476003)(44832011)(6246003)(68736007)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2943;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: v3JAdCHoJzCNJRiflViIKxRFRHffWO49Qkh8GR5iEGpZPjJxrvWrFHxcGF60b0b1UGkBEiOhHwt1uZoAsgZW99fG4tByCtAM8EAFNMY4BqfCW89PqgXW8iXsIzXezGlCmkJI6gScp9GXg4MfSpHmABEQVB0doSbMD0cjJGngv1lGEL5ZA2DIYTCn7bKp4f5dVYEmDy7S0Hg9T6dxcVkVMUmO50PzVhYIRsbNTkiTfOkycqKJ+sdVZ1/TpCmU5GCbf5mSGAwmY0LFkZnl7AlsKNGvaSxLjny3fRYuXuR/I9sPM/sGCjzFfW9nNH4+hUJxVnQNCEx17N30JwQMipFty48LQMsPWa7Z/9vSm1CrwB3iqK7xnZgAk61DukDCVdyVsPZJ95hFuqr7W16KFrPzLLOTTSHhgXQdBfGjVc7MgFc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8939f288-383a-4459-90af-08d6effc30aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 12:39:34.5426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2943
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/13/2019 3:32 PM, Christophe Leroy wrote:=0A=
> =0A=
> =0A=
> Le 13/06/2019 =E0 14:24, Horia Geanta a =E9crit=A0:=0A=
>> On 6/13/2019 3:16 PM, Christophe Leroy wrote:=0A=
>>>=0A=
>>>=0A=
>>> Le 13/06/2019 =E0 14:13, Horia Geanta a =E9crit=A0:=0A=
>>>> On 6/11/2019 5:39 PM, Christophe Leroy wrote:=0A=
>>>>> Next patch will require struct talitos_edesc to be defined=0A=
>>>>> earlier in talitos.c=0A=
>>>>>=0A=
>>>>> This patch moves it into talitos.h so that it can be used=0A=
>>>>> from any place in talitos.c=0A=
>>>>>=0A=
>>>>> Fixes: 37b5e8897eb5 ("crypto: talitos - chain in buffered data for ah=
ash on SEC1")=0A=
>>>>> Cc: stable@vger.kernel.org=0A=
>>>>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>=0A=
>>>> Again, this patch does not qualify as a fix.=0A=
>>>>=0A=
>>>=0A=
>>> But as I said, the following one is a fix and require that one, you tol=
d=0A=
>>> me to add stable in Cc: to make it explicit it was to go into stable.=
=0A=
>> Yes, but you should remove the Fixes tag.=0A=
>> And probably replace "Next patch" with the commit headline.=0A=
>>=0A=
>>> If someone tries to merge following one into stable with taking that on=
e=0A=
>>> first, build will fail.=0A=
>> This shouldn't happen, order from main tree should be preserved.=0A=
>>=0A=
> =0A=
> When they pick up fixes, AFAIK they don't take all the preceeding commits=
.=0A=
> =0A=
This is not about Fixes tag, but Cc tag:=0A=
https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html#opt=
ion-1=0A=
=0A=
Horia=0A=
