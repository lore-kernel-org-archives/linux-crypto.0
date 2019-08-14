Return-Path: <SRS0=c3b/=WK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82AC7C433FF
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Aug 2019 10:26:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 446CD2083B
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Aug 2019 10:26:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="HalZjtSs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbfHNK0l (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Aug 2019 06:26:41 -0400
Received: from mail-eopbgr40086.outbound.protection.outlook.com ([40.107.4.86]:53878
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725800AbfHNK0l (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Aug 2019 06:26:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SE4OgvDFXM2m44sBc6BeKdZJElEKa5HlnGnobK2Np7Xm4ReIsxLxdanzE4L9PLzYYcplLD7XMTkch3qnoAJryjNHCUBECqeaI8qjw0avxCmHVryjm6Srr1RnCe2zAVp0E/2ZcMkHIKAnpL2jTE5CA8vzRSlywJzWbXjPhTmCaEbNyEFDzV2GkvM/0HFHce1pnTvPPwxfE64txnvaZ2Lec6aOvsoLLLrU1K5NYkzX4v9psUf5+6QNmDZ/D/f2gBn7oxyzpYtPeeMdU532SmJm5a4n6/54ma6WONqDNJwuA3D/EyEkar/Pp+B/JceXP+C7qCve/i4STZC4o27SxDHW1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q30rKSuoP7BCLDOdpJHwqrrhiXkrF7gSAbcGXlokCAk=;
 b=mT50tWN8p7BybOq+o3EEjnZealrorgO/qtJ4ZE/LDCvbZwR2xQkg9jPTuuP74lB8zN0IPwkiLMNnw82e9xomyKgxUOX1vue+H2Wrynz+muD7mXb8aqU4BGRsGmB1qfKkuxbhWtOsJVWIu6n4O7VmO9AyEe2CbFRs5AmBc//hGs0A8RmsXw3AIQpYvDpOGeariYMwzmAjf6JLA+IN9MuAOWG2adQkjKFeE3Fuuzwm3GD8yFOKMLHTlwPZrNjP4t70Y55inrmGDoD4HTRyu5eLvJq947OW4YqL/Pe3he/l65KpkaPjFTPi/xtukVVPVL3K1jys+lRQ3jGWccg17e6Bag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q30rKSuoP7BCLDOdpJHwqrrhiXkrF7gSAbcGXlokCAk=;
 b=HalZjtSsFKk+6CqjltETR1ltc2oIm5NPjjooJWIC9RJjZKeba2vgM3FHWRld6E53toKLmGQAIOGokIJ/38fgBAwBB0Z2g0wx4ruM8swdmZcpmI+5z7MoLhpXDHUQl3yRhS5RBFRUKaB5WxFgO8wS15JedZVpZck4sW6nJwCYCKc=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3901.eurprd04.prod.outlook.com (52.134.17.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Wed, 14 Aug 2019 10:26:38 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a070:859:ccf8:3617]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a070:859:ccf8:3617%7]) with mapi id 15.20.2157.022; Wed, 14 Aug 2019
 10:26:38 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 00/15] crypto: caam - Add i.MX8MQ support
Thread-Topic: [PATCH v7 00/15] crypto: caam - Add i.MX8MQ support
Thread-Index: AQHVUUmn1hIaCFgDckirZJX9STyHyw==
Date:   Wed, 14 Aug 2019 10:26:38 +0000
Message-ID: <VI1PR0402MB3485F27982EC85ACE381F4A098AD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190812200739.30389-1-andrew.smirnov@gmail.com>
 <VI1PR0402MB34857B6486BDFE28B75A642398D20@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAHQ1cqE1UOaWUghuFC69+LVGZcp3TiV4uNPCS=86KMroEWrZcg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7569d221-cf46-4743-8ea1-08d720a1e40b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0402MB3901;
x-ms-traffictypediagnostic: VI1PR0402MB3901:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3901FA9E7949EC366DD5354D98AD0@VI1PR0402MB3901.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(199004)(189003)(229853002)(53936002)(9686003)(71200400001)(71190400001)(99286004)(81156014)(478600001)(66446008)(66946007)(6306002)(91956017)(76116006)(66556008)(64756008)(2906002)(5660300002)(6916009)(54906003)(66476007)(8936002)(55016002)(6436002)(6246003)(86362001)(316002)(52536014)(14454004)(186003)(305945005)(4326008)(966005)(74316002)(256004)(8676002)(81166006)(33656002)(7736002)(26005)(102836004)(14444005)(25786009)(7696005)(3846002)(6116002)(66066001)(76176011)(6506007)(53546011)(476003)(486006)(44832011)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3901;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8XqnvLQN7db/o+PmHloax15PmDb/8cZPxwCLRTuTF6fUA6ZcxghXZm/5VizpTbpEJgmPadkpgMpxdH5O7ofcjjr4eQh/HwQZ2S6Pyfzg+iHXp8R+IisrMVPGyflgflnHb77fqMnOOHlfC+ND0ravMDcihITrn0i3q/tfLusWdZYen0B8gpy99C2/ow6iqODZlAc50PRDRw6FRuUq/xBgmtAgJJGg+b2uCbRVpSqNz2fbrfCRWsLz4fp10357kh+/We8pQURVtwE2+sVYjI3ccN197mGGJuX/KPWsz9Y4XHEUetyQHKT17EFPcRV1ByLNcyemzdfNfvTl3uuP4jb1cKvDBz6c7HMex/MEYfjILcJHBZaCipzNFa/Kc1heH5DLf9dKFfP2Mq5RVVoCLyBcd8H4Xa8tlCGQdS05cgn2HUs=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7569d221-cf46-4743-8ea1-08d720a1e40b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 10:26:38.2261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v5DVCrKuBbyvBGI3L5WppN9G0Sc2rc8oftryErIh3lYclrUMDC6EKUDO/lntXI7zWdiohW8vMUEqxua/OcB6YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3901
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/13/2019 9:51 PM, Andrey Smirnov wrote:=0A=
> On Tue, Aug 13, 2019 at 6:59 AM Horia Geanta <horia.geanta@nxp.com> wrote=
:=0A=
>>=0A=
>> On 8/12/2019 11:08 PM, Andrey Smirnov wrote:=0A=
>>> Everyone:=0A=
>>>=0A=
>>> Picking up where Chris left off (I chatted with him privately=0A=
>>> beforehead), this series adds support for i.MX8MQ to CAAM driver. Just=
=0A=
>>> like [v1], this series is i.MX8MQ only.=0A=
>>>=0A=
>>> Feedback is welcome!=0A=
>>> Thanks,=0A=
>>> Andrey Smirnov=0A=
>>>=0A=
>>> Changes since [v6]:=0A=
>>>=0A=
>>>   - Fixed build problems in "crypto: caam - make CAAM_PTR_SZ dynamic"=
=0A=
>>>=0A=
>>>   - Collected Reviewied-by from Horia=0A=
>>>=0A=
>>>   - "crypto: caam - force DMA address to 32-bit on 64-bit i.MX SoCs"=0A=
>>>     is changed to check 'caam_ptr_sz' instead of using 'caam_imx'=0A=
>>>=0A=
>>>   - Incorporated feedback for "crypto: caam - request JR IRQ as the=0A=
>>>     last step" and "crypto: caam - simplfy clock initialization"=0A=
>>>=0A=
>> FYI - the series does not apply cleanly on current cryptodev-2.6 tree.=
=0A=
>>=0A=
> =0A=
> OK, sorry about that, will fix.=0A=
> =0A=
Please also include the crypto DT node in v8 series - see patch below.=0A=
=0A=
I would like to go with it through the cryptodev-2.6 tree,=0A=
to save one kernel release cycle.=0A=
This way kernel v5.4 would support CAAM on i.MX8MQ.=0A=
=0A=
That's how we previously did for i.MX7ULP and Herbert and Shawn agreed.=0A=
Details (including who to Cc) here:=0A=
https://patchwork.kernel.org/patch/10978811/=0A=
=0A=
-- >8 --=0A=
=0A=
Subject: [PATCH] arm64: dts: imx8mq: add crypto node=0A=
=0A=
Add node for CAAM - Cryptographic Acceleration and Assurance Module.=0A=
=0A=
Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
---=0A=
 arch/arm64/boot/dts/freescale/imx8mq.dtsi | 30 +++++++++++++++++++++++=0A=
 1 file changed, 30 insertions(+)=0A=
=0A=
diff --git a/arch/arm64/boot/dts/freescale/imx8mq.dtsi b/arch/arm64/boot/dt=
s/freescale/imx8mq.dtsi=0A=
index d09b808eff87..197965dac505 100644=0A=
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi=0A=
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi=0A=
@@ -728,6 +728,36 @@=0A=
 				status =3D "disabled";=0A=
 			};=0A=
 =0A=
+			crypto: crypto@30900000 {=0A=
+				compatible =3D "fsl,sec-v4.0";=0A=
+				#address-cells =3D <0x1>;=0A=
+				#size-cells =3D <0x1>;=0A=
+				reg =3D <0x30900000 0x40000>;=0A=
+				ranges =3D <0 0x30900000 0x40000>;=0A=
+				interrupts =3D <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;=0A=
+				clocks =3D <&clk IMX8MQ_CLK_AHB>,=0A=
+					 <&clk IMX8MQ_CLK_IPG_ROOT>;=0A=
+				clock-names =3D "aclk", "ipg";=0A=
+=0A=
+				sec_jr0: jr0@1000 {=0A=
+					 compatible =3D "fsl,sec-v4.0-job-ring";=0A=
+					 reg =3D <0x1000 0x1000>;=0A=
+					 interrupts =3D <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>;=0A=
+				};=0A=
+=0A=
+				sec_jr1: jr1@2000 {=0A=
+					 compatible =3D "fsl,sec-v4.0-job-ring";=0A=
+					 reg =3D <0x2000 0x1000>;=0A=
+					 interrupts =3D <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>;=0A=
+				};=0A=
+=0A=
+				sec_jr2: jr2@3000 {=0A=
+					 compatible =3D "fsl,sec-v4.0-job-ring";=0A=
+					 reg =3D <0x3000 0x1000>;=0A=
+					 interrupts =3D <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;=0A=
+				};=0A=
+			};=0A=
+=0A=
 			i2c1: i2c@30a20000 {=0A=
 				compatible =3D "fsl,imx8mq-i2c", "fsl,imx21-i2c";=0A=
 				reg =3D <0x30a20000 0x10000>;=0A=
-- =0A=
2.17.1=0A=
