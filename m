Return-Path: <SRS0=VsUo=YP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E8BCA9EA0
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 15:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6254E2084B
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 15:42:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="nPtq3O0f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387716AbfJVPm5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Oct 2019 11:42:57 -0400
Received: from mail-eopbgr820051.outbound.protection.outlook.com ([40.107.82.51]:18901
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387703AbfJVPm5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Oct 2019 11:42:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h5f9S6ijLiX4/y+8EQhX7XO4x71pZYQwJJHAgNmY4XN+zn43XtcdNOP2ZsepZO1TxAhswPU59EP/hfERASon70sCjaPYWyI3FEewJQsG1R3jgf1/Zrta7Ys+klBqH3w9LJtC0TIzRqwGpvHalRX4MlE6HBL9/3R0VKPkP8ELpWaLizTeS+NG+HmFW/9GmfXlXCIhPueWDPXXJp6wLlCzLZ83DuzXH8BqdyMu2AKtVveQ0EPBrtufKjpg9Aj5axmFZS5R2ic5pvnjPKrFmhZNjotVtHqN0hMPve5iWO3SCH1Xt/GCvAlx0O5yTpLd2fuVkdRJcSukYLYkjVNwV0xEcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T3hRPqgZJsiVSxhf7S3ZR6poJklTpJRSftcCRBhhDzM=;
 b=Doy/JRa2wyYmGLolaI4adfXkwru7tUi3ZFtiuNJD0yDzjX/YYsT9QvHRkMe7AUdxrNW8nBdxLocHCtq2luD/+pWEI1mcpTO45ndQ/lipPWOC/QtbdxUwLzpi7eFdrwGYcmeyjsYymyA6wEV6iyTeEGr2dBPCwC2xAtW9ijfSoW28FL/sXsPBzzamw+fxiSbjx0PMqc22yAcS9lwvCWcrF/SSMLjckNXdwEkOS0Px8HeDwZOUAywAKz4V+aTfJjVBMYGCjlLnwbDc0KdNUa9JS6ZpwzRG0eLwvIJZXZ/BOrli99+klrORFFBta657o8mWJ4vYt2uUVm0uwVcgBvoIhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T3hRPqgZJsiVSxhf7S3ZR6poJklTpJRSftcCRBhhDzM=;
 b=nPtq3O0fFUDyxS9a8nlctV+GkJDfxWjX7tqQhbbAGw3XFCo7d5wYwp6FqyHspFigwG9r2FF8IhkiCaCT2igTMPoSKYTw21j9Qtm70zgAnmk4XTvTZhbUChdCuhnLkpO5R1QwXyBdI3mCtkMnaTSDaBIccjdEV9TZYQBlGeBzQCA=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.86) by
 MN2PR20MB2989.namprd20.prod.outlook.com (52.132.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Tue, 22 Oct 2019 15:42:54 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4%7]) with mapi id 15.20.2367.022; Tue, 22 Oct 2019
 15:42:54 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] crypto: inside-secure - select CONFIG_CRYPTO_SM3
Thread-Topic: [PATCH] crypto: inside-secure - select CONFIG_CRYPTO_SM3
Thread-Index: AQHViOUe+e/Hs63J30KPA9kL8v+yAadmy4dQ
Date:   Tue, 22 Oct 2019 15:42:53 +0000
Message-ID: <MN2PR20MB29732A5C1B14AE24DD7531A3CA680@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20191022142914.1803322-1-arnd@arndb.de>
In-Reply-To: <20191022142914.1803322-1-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab468249-178b-4556-7d33-08d757068101
x-ms-traffictypediagnostic: MN2PR20MB2989:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB29892F802DB2CB171DDED6B7CA680@MN2PR20MB2989.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(376002)(136003)(366004)(346002)(13464003)(189003)(199004)(66946007)(33656002)(66476007)(74316002)(66446008)(64756008)(76116006)(66556008)(25786009)(3846002)(14454004)(6246003)(7736002)(54906003)(6116002)(305945005)(8936002)(316002)(81166006)(81156014)(478600001)(15974865002)(8676002)(6436002)(486006)(102836004)(446003)(5660300002)(52536014)(476003)(71200400001)(71190400001)(55016002)(9686003)(229853002)(6506007)(53546011)(76176011)(4326008)(110136005)(7696005)(2906002)(26005)(99286004)(186003)(256004)(66066001)(11346002)(86362001)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2989;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ecsrCzq/r/TqyfH4RgkKjZkPCbuJdbRtNZJvBvZKl9PeAUmbkrE8nRgQ/3aUZKMD4l4h2AvCKWZlJXLzyImkTp49jpmK9JyKWOiKZj3R3OQFB6kRhA/T/kCAGuh3e6kUj7yRcGkW+btFN9JL7gkVQoPo0+kNQNKsv4c5perxrsf9wGh4328B++4cbCJFSuraAI3cIhQEcDGBTlYPwFoAMR5zb8lVrbxGtOFxcodm0vm9pSOciOi51Z6Qiz+dt7xD7WMjb+qCBLtsxzOU0i3sA7GsvUpb/vW3XM24ruOakpR58a69G8Gv8YrzL6DgPoQhZ4T4gNxIqQngyVgx1c4r9qixrQtUxkDov+XZh3NXXufEt03a/f8i1rPCrVTsO6O8EvN5o4Pz9UODev2zouNTJTMvNP5KJW2RraqmBMcDkMhuPR+RcILv+C3zx0rsslqX
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab468249-178b-4556-7d33-08d757068101
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 15:42:53.9804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z0hNjldPdRp6bVKvloJE7h4/zAgmdlRVgovtQAhRx8iN9pQ3hyTnhgZYjMm4g96Jn9/1IFLE99RuFEjZNn4cJWSFNiyJJf1pfgksfszSC8g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2989
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Arnd Bergmann <arnd@arndb.de>
> Sent: Tuesday, October 22, 2019 4:29 PM
> To: Herbert Xu <herbert@gondor.apana.org.au>; David S. Miller <davem@dave=
mloft.net>
> Cc: Arnd Bergmann <arnd@arndb.de>; Antoine Tenart <antoine.tenart@bootlin=
.com>; Pascal Van
> Leeuwen <pvanleeuwen@verimatrix.com>; Ard Biesheuvel <ard.biesheuvel@lina=
ro.org>; Pascal van
> Leeuwen <pascalvanl@gmail.com>; linux-crypto@vger.kernel.org; linux-kerne=
l@vger.kernel.org
> Subject: [PATCH] crypto: inside-secure - select CONFIG_CRYPTO_SM3
>=20
> Without this symbol, the safexcel driver causes a link error:
>=20
> drivers/crypto/inside-secure/safexcel_hash.o: In function `safexcel_ahash=
_final':
> safexcel_hash.c:(.text+0x3c4): undefined reference to `sm3_zero_message_h=
ash'
>=20
> Fixes: 0f2bc13181ce ("crypto: inside-secure - Added support for basic SM3=
 ahash")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/crypto/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 357e230769c8..1ca8d9a15f2a 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -753,6 +753,7 @@ config CRYPTO_DEV_SAFEXCEL
>  	select CRYPTO_SHA512
>  	select CRYPTO_CHACHA20POLY1305
>  	select CRYPTO_SHA3
> +	select CRYPTO_SM3
>
Was this problem observed with the latest state of the Cryptodev GIT?
Because I already attempted to fix this issue with commit 99a59da3723b9725
Can you please double check if you still get the compile error with that
commit included?
(I can't tell from this mail which version of the sources you are using)

>  	help
>  	  This driver interfaces with the SafeXcel EIP-97 and EIP-197 cryptogra=
phic
>  	  engines designed by Inside Secure. It currently accelerates DES, 3DES=
 and
> --
> 2.20.0



Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

