Return-Path: <SRS0=QLPS=3J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252CBC2D0DB
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 16:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2AF42073D
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 16:39:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="o+gZWM5c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgATQjL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jan 2020 11:39:11 -0500
Received: from mail-eopbgr140074.outbound.protection.outlook.com ([40.107.14.74]:8568
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726897AbgATQjL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jan 2020 11:39:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJF4dQpnv52ZW3WnzinY73eSKOQ0e6PAN+Uf33dokJ7zoWQ4n5lQiLKZQB3lttagAcToHD5WjR/clC64JyiiRsCsJFEUCSIQLVSAvJhTUHNxDW8vZtqE/EH5i08yV+d69hEUlSnv7xJyaKNE2pPLe++kco7hExhqY79X+5z1ZK2fLIym/9nZHNlDQsnJriDPPDcPO0pq37N3nCmNDVgD1lPL/y0lyihbkF+UmEG8hW19Ou9mYWWZKpdLCnbBwCbMdPhQZUqzDnARwdZUTeQKVhdF4n6o4BPm2x7UEkm+eVyhORil+/4COjDRNjsCQy8e3iLDBL38929+M6UprrHl2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yraLZ+mAckyeAxXv/M8mZC6WbiXgaTZCQKEsykbHTlU=;
 b=NLDKUMRzYkoNiHzB5YQYsyj1o+5A7E2yPr6llsnGbl1OatstYc8yE18WppkNCZTTM2Wa4k56aClJDXt0z7DwOiM8gYHC3CidmiH6433I2XgddJn4VkxSlFHR8L92JMdo5fmyyhlq+nV3ZNhQvjzmJlV2kbH1LjJfddqRXbfiQGpN5TDRsur87GrToQhf6a+Rhna51vMCAnyioqcUBNmw/OZ5SJ36rDB4Ohxjv8M2MlMNFGRNUZo1VxP9e7F2s+lpbyDpbByJYvJC+1NSQv28C8kVvALL/z3MwojmMvlwtfwBQzVomqnKhuHaBQjuv1nd11jezKuDozo5Zr10mZAQhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yraLZ+mAckyeAxXv/M8mZC6WbiXgaTZCQKEsykbHTlU=;
 b=o+gZWM5c2IKr8LmuVUl4+5gpkoidSSpblek2wJ/du8IbPaBUGNVI+qhReZ+LyWfIYjgLw6g6ThCxfx/kkBCQGhJ8814ZUAQklXzUdj7ydZrXlDeNeYto5DV2hvhREr8Adj7O7GOOzDvbvSw8iyCS7aRdQJ4xL43FI7jemiHqmjw=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3744.eurprd04.prod.outlook.com (52.134.11.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Mon, 20 Jan 2020 16:38:46 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2644.024; Mon, 20 Jan 2020
 16:38:46 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v6 6/7] crypto: caam - enable prediction resistance in
 HRWNG
Thread-Topic: [PATCH v6 6/7] crypto: caam - enable prediction resistance in
 HRWNG
Thread-Index: AQHVxjouh/c8xz5csUKnQ9CkhtEExg==
Date:   Mon, 20 Jan 2020 16:38:46 +0000
Message-ID: <VI1PR0402MB3485F1AF6DC4B74FF373B16998320@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200108154047.12526-1-andrew.smirnov@gmail.com>
 <20200108154047.12526-7-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 524a99e6-2144-4815-9f8c-08d79dc7386e
x-ms-traffictypediagnostic: VI1PR0402MB3744:|VI1PR0402MB3744:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB374490590F40C5CA2D504D4798320@VI1PR0402MB3744.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0288CD37D9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(39860400002)(136003)(366004)(189003)(199004)(2906002)(71200400001)(54906003)(9686003)(55016002)(478600001)(110136005)(7696005)(53546011)(186003)(6506007)(26005)(316002)(66556008)(44832011)(66446008)(66946007)(64756008)(66476007)(8936002)(81166006)(91956017)(81156014)(8676002)(86362001)(76116006)(4326008)(52536014)(33656002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3744;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VYoxBKDk1tiz6PlPYflLUQtzpD+kdg0mgnGhBi5AkTIiIwbF8r1vf91dnaJoItvbGmObXJAiww88ebHSpm+T4YokFKfjOcgVWjOKa4IGlksXlYQGcPWrTNidfzdJOPLdOS9eQCQXCPvgRHNdCiyS3E9IV/Kwi5Uy4OAOnNcVC21Xf+2zrJkEsT0joh8jBXElle/XFwi64oY9rRc3OWtViRTbfTH+Jm4CgAnWOLh49RJhGLJ8d3b5EAvSCPQ9I43nF+DylAAXiEaXodEihjJ+LZkB+0XnZa+p9xQTDcFBB84OT6Uk+XXwZOPdIY3LmlLCFATV/ZbX12cTJr2Jfdkra0BTUGUqlkUOjMiQWz5DpTzAGpJZ+CdDBf/mUf/8dPEHegqZlyyiTjfP6UpHvFm0x6JnjEGgRjwnAs+iDAT+uU8aus2DPvCnojUmRsvEkhcZ
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 524a99e6-2144-4815-9f8c-08d79dc7386e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2020 16:38:46.6067
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SSxL6SarabtX332n4e66BY9j/hIcUR8nYCOrVb4IO6HyGc2Hb2oG9lmTNBUjroB//34HkRwSyfr+vv/QI8COTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3744
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/8/2020 5:42 PM, Andrey Smirnov wrote:=0A=
> @@ -275,12 +276,25 @@ static int instantiate_rng(struct device *ctrldev, =
int state_handle_mask,=0A=
>  		return -ENOMEM;=0A=
>  =0A=
>  	for (sh_idx =3D 0; sh_idx < RNG4_MAX_HANDLES; sh_idx++) {=0A=
> +		const u32 rdsta_if =3D RDSTA_IF0 << sh_idx;=0A=
> +		const u32 rdsta_pr =3D RDSTA_PR0 << sh_idx;=0A=
> +		const u32 rdsta_mask =3D rdsta_if | rdsta_pr;=0A=
>  		/*=0A=
>  		 * If the corresponding bit is set, this state handle=0A=
>  		 * was initialized by somebody else, so it's left alone.=0A=
>  		 */=0A=
> -		if ((1 << sh_idx) & state_handle_mask)=0A=
> -			continue;=0A=
> +		if (rdsta_if & state_handle_mask) {=0A=
> +			if (rdsta_pr & state_handle_mask)=0A=
> +				continue;=0A=
> +=0A=
> +			dev_info(ctrldev,=0A=
> +				 "RNG4 SH%d was previously instantiated without prediction resistanc=
e. Tearing it down\n",=0A=
> +				 sh_idx);=0A=
> +=0A=
> +			ret =3D deinstantiate_rng(ctrldev, rdsta_if);=0A=
> +			if (ret)=0A=
> +				break;=0A=
In case state handle 0 is deinstantiated, its reinstantiation with PR suppo=
rt=0A=
will have the side effect of re-generating JDKEK, TDKEK, TDSK.=0A=
This needs to be avoided, since other SW components (like OP-TEE f/w)=0A=
could have black keys in use. Overwriting the KEK registers would no longer=
=0A=
allow CAAM to decrypt them.=0A=
=0A=
Horia=0A=
