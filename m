Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D45C7618F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 16:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75E872186A
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 16:37:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ihZb9H4r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbfGSQh0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 12:37:26 -0400
Received: from mail-eopbgr20051.outbound.protection.outlook.com ([40.107.2.51]:13985
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727577AbfGSQh0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 12:37:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UgzRvX7XPAlXcvPegap+mjWXDkZ2dVk9PZoVUbCWOP4hgRq+rVY7SE9WkqU+vhxvBTEBOh9hk08bJsxdwh4x4Wb53qgoZvNhHC815Q53BlbkErYTRBKkxYBxxRQwhFfcG3e92+uMjYXkdJ4Q8oh471ne8XiX3t9iusaAlFhC/NjpHa/pi5b2qZtsv8l4cAKMgHpnvvJ3NMYsQkQOmzPRof/PD7p6HIE8y3uhRFBCd05DxSgrV533R84VhGNNjO5k7ViDk5ySnWJ0G2HnuG1UyL/RHPinpa2rEJG7Iyhn5MBV1Q1/23fWkFtmrOMChCR1OsaA0Lh++NtNILjam7llaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rb/EX2auQYCefW2DfJksKBwlyxPzaKo+ElXU3sd/Ep0=;
 b=MbDxt+ROwpFsaFVJKWY4aArR18iPa0oUKJ3aENKwUKuoxhx6wM/d/rTlp0t3/yiarNmjRQjoMpNZQNbWzlg10P7UFMcqN5zDKmXngqzPxG19CmZCx31oty0xuM1+7j7j1Z+j7fmGHhHElUL9xBJ/gGDBYQouKhvoyZ9FQ/bLpBfPm07VFlJVRzXDfjpSCs5TKxaWT7KJb6fETeht4iHlhwExYHAuEWUhL9VtBWva4d72RKeUJzeW8Ypi4TuEtQ8V6DP6diCrEkiiyEHNC2TVzQRI5Psoh8xiUdau2rBU7bPGZhIRD88gN5xKrlk+0Dj/IqXyAeQZzoxyppp1oOF16w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rb/EX2auQYCefW2DfJksKBwlyxPzaKo+ElXU3sd/Ep0=;
 b=ihZb9H4rASe3JWorwHyypUZnpcIVhL2BNFOiSiOSlS71nhNpkzGrPo49BicOUqf1GITeJm8ikzygzU6L4053EyaciMM9AhmuzdJ43d4f3Ik/As9AZn4gggMS9DX7T3qS8gDJBdCNeFHaZ0dS83YKsQiArdUHH6YVRdF1H7black=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3807.eurprd04.prod.outlook.com (52.134.16.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Fri, 19 Jul 2019 16:37:22 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2073.012; Fri, 19 Jul 2019
 16:37:22 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Vakul Garg <vakul.garg@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam/qi2 - Increase napi budget to process more
 caam responses
Thread-Topic: [PATCH] crypto: caam/qi2 - Increase napi budget to process more
 caam responses
Thread-Index: AQHVPVwIjltj49haakO+KNMG6PEHuw==
Date:   Fri, 19 Jul 2019 16:37:22 +0000
Message-ID: <VI1PR0402MB34858D0914FBD5E3F8B362E798CB0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190718112440.4052-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 539397ff-ed60-4604-a4d6-08d70c676009
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3807;
x-ms-traffictypediagnostic: VI1PR0402MB3807:
x-microsoft-antispam-prvs: <VI1PR0402MB3807519A6A2EA5F959714C3F98CB0@VI1PR0402MB3807.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(199004)(189003)(110136005)(316002)(54906003)(229853002)(25786009)(66556008)(99286004)(66946007)(64756008)(66446008)(66476007)(55016002)(9686003)(76116006)(53936002)(52536014)(7696005)(76176011)(6506007)(53546011)(26005)(71200400001)(5660300002)(7736002)(4326008)(486006)(81166006)(81156014)(446003)(3846002)(6246003)(6116002)(4744005)(44832011)(186003)(102836004)(476003)(256004)(68736007)(14454004)(86362001)(66066001)(71190400001)(2906002)(478600001)(8676002)(6436002)(74316002)(305945005)(2501003)(33656002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3807;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cc97W42byoiDIV9KV+TcQoIo8gY8182QobQqJmXcXbmBVScRqVQYp7+K1wy0DQ52JF0LXC0J7sxfNqd26erLaVJLWuP4PWLUDaWpX2Mj7DCJKVYHmKoNyRW+8xlsFgmRw3uZ9qdnl2uBfW0ISrtZztC5UCDbmCrFRlo3DOI9hj+JuEXkc56/pes4ubKWFZTJ/UYCJu4YADxReseAklAeZ4jslu6R3OLRyGY31Oln1lMC9Ocw8vxUWmHf86iYsdq0CaB7uLSGCf9mEHh0uTTF9cjhcF10cII9yk9q8+kU16eT1OqydYitHigE9TE/LFngt758PiTtQrz9gGRZI+JHODESY8UF83UKba0W9W32heH9O01LMf5cZVcZv0pFPM8pkenhjYg5qSDkfPgzLeI6+C9CxtuWZXp0SEU7D6bkzmQ=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 539397ff-ed60-4604-a4d6-08d70c676009
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 16:37:22.7784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3807
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/18/2019 2:29 PM, Vakul Garg wrote:=0A=
> While running ipsec processing for traffic through multiple network=0A=
> interfaces, it is observed that caam driver gets less time to poll=0A=
> responses from caam block compared to ethernet driver. This is because=0A=
> ethernet driver has as many napi instances per cpu as the number of=0A=
> ethernet interfaces in system. Therefore, caam driver's napi executes=0A=
> lesser than the ethernet driver's napi instances. This results in=0A=
> situation that we end up submitting more requests to caam (which it is=0A=
> able to finish off quite fast), but don't dequeue the responses at same=
=0A=
> rate. This makes caam response FQs bloat with large number of frames. In=
=0A=
> some situations, it makes kernel crash due to out-of-memory. To prevent=
=0A=
> it We increase the napi budget of dpseci driver to a big value so that=0A=
> caam driver is able to drain its response queues at enough rate.=0A=
> =0A=
> Signed-off-by: Vakul Garg <vakul.garg@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
