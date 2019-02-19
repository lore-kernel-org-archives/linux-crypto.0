Return-Path: <SRS0=4Nwj=Q2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D713C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 06:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B9A221848
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 06:57:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="d3DzvBOW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbfBSG5N (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Feb 2019 01:57:13 -0500
Received: from mail-eopbgr140082.outbound.protection.outlook.com ([40.107.14.82]:2530
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725763AbfBSG5N (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Feb 2019 01:57:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2oWWkllyQPINkIJ2O88/jfWWS1pU26uWYCIoOdMvdxA=;
 b=d3DzvBOW/EPlJkglk6/UK8btQwUR4OyAa6vb5Z1z8nX8jxG1zbxGbUUniISNI9sVuek5rL8cL8RJ8XCQqjcU9MZW1IJrbLkFAIizwY61rjwuOS4yy9/fkHXzuZ0b2K2OsrU98yr3RreCBw7NiVdMToquiBkveu3rqdqhrZxXbzs=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3933.eurprd04.prod.outlook.com (52.134.17.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1622.18; Tue, 19 Feb 2019 06:57:10 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931%6]) with mapi id 15.20.1622.018; Tue, 19 Feb 2019
 06:57:10 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Philipp Puschmann <philipp.puschmann@emlix.com>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "o.rempel@pengutronix.de" <o.rempel@pengutronix.de>
Subject: Re: [PATCH] crypto: caam: set hwrng quality level
Thread-Topic: [PATCH] crypto: caam: set hwrng quality level
Thread-Index: AQHUw6tKHa9ziAJsHU+mY5wmn71RVg==
Date:   Tue, 19 Feb 2019 06:57:10 +0000
Message-ID: <VI1PR0402MB34850724B851235EE1FCE2D0987C0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190213144907.5696-1-philipp.puschmann@emlix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [86.34.165.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad17d9b4-6622-4ae2-f9b1-08d696377819
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3933;
x-ms-traffictypediagnostic: VI1PR0402MB3933:
x-ms-exchange-purlcount: 1
x-microsoft-exchange-diagnostics: =?us-ascii?Q?1;VI1PR0402MB3933;23:XO+JFz4WDRFXbnv4JT2SFUbyrDAOyPZsPgOFGCM?=
 =?us-ascii?Q?kwwgJV3ghn8hnmeivE7vHs2qn8AxAoe81ChDkGI48GuSeC1zfx61gs82IpM6?=
 =?us-ascii?Q?iL5EhwNjlv1La2xK/CDseyAwM2V+sH1vJMdaVD5N/70GDIdURzjZA9qtuv5/?=
 =?us-ascii?Q?EIgy+Ct/mvlCQIKqEAlSSehTHwxiOiJ/gwXzb+h3qsyfDyVXfzu0ceCps9Lo?=
 =?us-ascii?Q?3B8VFZA4NYDL00gWhjXkpQKHsqpAtBKHIXh89e49zGm7VrVhgmsg8eZqph3q?=
 =?us-ascii?Q?6R5ZFPZvGgOX/rgGa4IRtTRWTHBtJ1LJszkuDyn8EIzb9D3POXv21uGZnwlQ?=
 =?us-ascii?Q?gs6hB1YP3+4sYC1o1gg04jAaBJ1+SKFVTDhBc1yrkf90TDu84g0Y3y0pOcQu?=
 =?us-ascii?Q?zWnDg7gnl8O49XoRXRLl8viLGMamqWDpFIWVHx7/Y6JENujLlzFex5xPV1ea?=
 =?us-ascii?Q?55+7gMUMdCHxaJgbmzmp1CJBuK30QDlJP2DDmt6SJeozWxDDRSBUvpGfnK9X?=
 =?us-ascii?Q?AgZxFECmcrsfgOCsbOn1E04A0a/iEB6F3udvpsBL5SynubuFSxPK+WLrRTEV?=
 =?us-ascii?Q?ltAkZG9QIf2emIdJuC2Ds7UCXLpfkQG4iF0w5AaM7x4d8h9uMVH03sMiIQZX?=
 =?us-ascii?Q?qkvmlBm5tTVTzuSRJiB5HWU2Nzwk0XhUxN7/B3wT/ANMnA0r/Q+XSXUeJs7X?=
 =?us-ascii?Q?yJY2KMNrAxhnVjlrjWomGRwIwDpK8/u74fFLtZAAgVNocn6LsqRMy/t3rP67?=
 =?us-ascii?Q?cuIfGBOmbRx8yKal0pwDdEuLANTs+zCwqY6Fd/BRvt5uCne/bVfs76XfzBdR?=
 =?us-ascii?Q?de4wN2CyhPGdJVGskPhN4ViGCo4G0X9Ealz9M0Xpw8xO5qCN5JwK/6mhM8un?=
 =?us-ascii?Q?OAP59SMZ87nq9/WTeL1FMDvV7+J/yBONAEiCud2blysInWvYDTqtZNNRglbV?=
 =?us-ascii?Q?lwX1DE8j3T0q3ktwwNweA6himUYsK+svORlrDXuJYxVL4cqx7mufHfHH9dws?=
 =?us-ascii?Q?3M0ggTLGbYce9hKADlWYe/u1EdtYFS6adqnQHqLxVbBuWWOjb6fzbjWB+mGC?=
 =?us-ascii?Q?zFngY7Bodadk1nlPUZfyT7vWj3+26FXKx//VrUdtnplcm7y7jtKl32tqO+ZW?=
 =?us-ascii?Q?hM1FCk0doUCPRTBp9CtrFoFLMCipdkJ/TSAr2/ZESa8GXdtzEvFY+EpixGAr?=
 =?us-ascii?Q?08Ozup8jshMjpS+WjGJ7uES0oZWq8MeyMTmXbQSfdNVu+o2Y6XdPU03JoP1e?=
 =?us-ascii?Q?P0XDyYWsVqWop7X2OEmpzyD2MdftuE62vFZhMMFDc?=
x-microsoft-antispam-prvs: <VI1PR0402MB393397B0056213589194A651987C0@VI1PR0402MB3933.eurprd04.prod.outlook.com>
x-forefront-prvs: 09538D3531
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(39860400002)(366004)(189003)(199004)(6436002)(2906002)(76176011)(478600001)(33656002)(6506007)(53546011)(305945005)(25786009)(476003)(3846002)(446003)(229853002)(26005)(7696005)(5660300002)(68736007)(74316002)(186003)(99286004)(6916009)(6306002)(9686003)(102836004)(71200400001)(53936002)(71190400001)(14454004)(6246003)(966005)(4326008)(55016002)(81166006)(4744005)(44832011)(256004)(66066001)(81156014)(316002)(97736004)(105586002)(86362001)(106356001)(54906003)(8936002)(486006)(8676002)(6116002)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3933;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2ZLdg3OK4Vg5tjjCfRg5HwE6XPJ5AvY02oPAhYg8Smgj3IuEUiX4iURU0glvvK+TR8TLirqDk+N799WV7baAVyqDnd5xG0ps2rDXPgTDqUx5a2mh0pCdYifT9mkxkSKf1ubvM1oSptJCekTbrCQDSfWbKtUrPObM1XTh3KgR2279yeXtRVBX+2rmwtGhpKi+sazMVmn/emrShdDJro275/JC2gnDyyyPYdl+ESeZEaQwoV5fQy7z5avVVa73K4HmbI1qT6d2SS7sMiX6r8mI0rApsLi5cvvW82u6MgxefBEc8VE7Jo+WnJMXvOYaCpgPW22dSS6a6t2wva+7CAh5nvmK+qMRFqUSmmGApw47+zdiL8f+OoqgN2PPRcJ+98l1rIhWf/3tKUcCAYCkkQz96zZNZzEUcFae0TqpX+l445A=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad17d9b4-6622-4ae2-f9b1-08d696377819
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2019 06:57:10.0668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3933
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/13/2019 4:49 PM, Philipp Puschmann wrote:=0A=
> When quality is set to 0 this driver is not used as randomness source by=
=0A=
> HWRNG framework at all. So set the quality and finally make this driver=
=0A=
> work. The value of the quality was discussed before=0A=
> ( see see https://patchwork.kernel.org/patch/9850669/ ) and it is still a=
 rough=0A=
> value.=0A=
> =0A=
In the same thread you mention, the conclusion is that caamrng should be=0A=
properly configured (TRNG instead of DRBG) before claiming to be a reliable=
=0A=
hwrng entropy source.=0A=
=0A=
Horia=0A=
