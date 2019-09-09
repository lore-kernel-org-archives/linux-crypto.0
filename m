Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A46AC4740A
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 13:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2330121920
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 13:25:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Oyqw/Vn7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730283AbfIINZR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 09:25:17 -0400
Received: from mail-eopbgr30047.outbound.protection.outlook.com ([40.107.3.47]:64526
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729836AbfIINZR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 09:25:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S31BMXnNFmj2IxGTB5zTaZmIIpPJLQAYTlPcl+I7EYu4eTkgonelwn8PCbwwpURzdwy902p+aXLK82trDCD+BWJWULz99FV0DqzX1cGOXT8BT8j7CRXnXkecyj0hn2UeBZQnQ66OG9DkUy+Q1kYcYSw2ChgVHINXKN/d5V8SMV31bkcNN/HjvXx9b4vJecupPIskhvq048Bp02yAabSxi8RlGwiUP51RPgBMRChS2W7KfjfweS8u89nZ9O3KcFX328VlHp5sRTCd4vIGM5YEuDdCEXuZHgW3hxqRQzgy48EU389yg4GcQLBy9/XENythu6GLXKzl/VRwQ3WfQFQ6TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ocC+cxBfunHUICkHAsfOmPjNb85oooJak3enQc/5AM=;
 b=lZ2QqNrZoFpC7D6hbgSB1mvM0ELpO2bsVhzwSMDIIlS6eWIbY5O/rwGt0mxVi2EdzPmXpthT3xVUZvyH7cgu6rpt9lBCndL3sLr5kHpasmduz8WJoCvuNoNBZBmPckmRX5sBNDRVMsvaw/aOJ6nkWTKBhggQNCcHf+2msCf/CGYUyeYdIYViCTEFFLL6A7jbm3EGYjivkaoiaqbA6iTVnNPtIYDlWC3FS3qlWYIYo6gzSJ/Wgth+9vaASgS7nBA4GeS4kR2ezELiJXtjrxd3MlEY7ofQkP3rrJOB07KSi8Ivq4Lc8blXkH8SvC62MiaJWncSe44VSRJBqFTkUkH5Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ocC+cxBfunHUICkHAsfOmPjNb85oooJak3enQc/5AM=;
 b=Oyqw/Vn7JHu7voGUw4oKl8gH0J2fxfa0dAoN+pC5mHuavm0tP/E/vSmQHKZMXK8rvqgp/oIGEsu09xZpxjFz1xF+g1tc7vwoR3pzi1OXi8PrER3YYnQjW/ni6nhDarO+21iSygCz8EQMWvp/BLuR+ciOkAQEfmlvJJAInAL2itA=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2797.eurprd04.prod.outlook.com (10.172.255.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Mon, 9 Sep 2019 13:25:12 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::c1a3:2946:8fa8:bfc5]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::c1a3:2946:8fa8:bfc5%3]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 13:25:12 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/12] crypto: caam - use devres to remove debugfs
Thread-Topic: [PATCH 06/12] crypto: caam - use devres to remove debugfs
Thread-Index: AQHVYslyCmXAbYtWGE6iYQDuvB+rCQ==
Date:   Mon, 9 Sep 2019 13:25:11 +0000
Message-ID: <VI1PR0402MB3485EBAF75E5578FF638234198B70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
 <20190904023515.7107-7-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f2b382b-a394-4b09-23ac-08d7352924a2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2797;
x-ms-traffictypediagnostic: VI1PR0402MB2797:|VI1PR0402MB2797:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB279751EF0BF95C488EAE131098B70@VI1PR0402MB2797.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:224;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(136003)(376002)(39860400002)(199004)(189003)(476003)(86362001)(4744005)(99286004)(2501003)(478600001)(316002)(7696005)(33656002)(14454004)(110136005)(54906003)(229853002)(6436002)(8676002)(81156014)(81166006)(66066001)(446003)(2906002)(8936002)(6116002)(55016002)(76176011)(44832011)(91956017)(6246003)(76116006)(25786009)(486006)(9686003)(52536014)(186003)(74316002)(3846002)(305945005)(53546011)(6506007)(102836004)(26005)(5660300002)(71200400001)(71190400001)(64756008)(66446008)(66556008)(66476007)(7736002)(66946007)(256004)(4326008)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2797;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5gsyewuPiqtoNftPQkuv2OmJw7dAuBLGrECTARq9B2TuuyFg+JIOn7TsC5cpafQCGFqVF9W6WFVhRyPgQZ8i6ilO/wgyNRuOJ5ph0ufUiE3jUG6QImdFcil+EQi+P6dge5D2ak9L/ECq7PgK+pyEwt2SxmuU5Jm/8VDpFqfn3p5WJkM4UkQNlzR0l/ApneRY3sOYoMJUr74VSWgVEvT+13QQS7rSnlVTfi47VvMLTyEWLXTtKtfUkudzqZ/D7t0j1gJsDwWwJa8r/xy8FjOcb95bnixTw9utodYa4gyn6Dp5A8KV/LCaO9j7ZIsQodHGF6BUMDMtBcp+arIopELL5sVZUcNiU1FD/IXA1lMPsxjLXDt/TAzt1Z4zrRwFfLQzLfXj9OIbsa3431IhvDXSsJsyzrmRO8Ql2TRq2b1jMhM=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f2b382b-a394-4b09-23ac-08d7352924a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 13:25:11.9802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7MAcowE/GTNa3js95Rf6dnYKFFP3NNPm3jdpL+LLHVngt//nLlwKRhC7G0RiAHvlg19VCpQyeAS+mNCWUUEPtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2797
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/4/2019 5:35 AM, Andrey Smirnov wrote:=0A=
> Use devres to remove debugfs and drop corresponding=0A=
> debugfs_remove_recursive() call.=0A=
> =0A=
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
> Cc: Chris Healy <cphealy@gmail.com>=0A=
> Cc: Lucas Stach <l.stach@pengutronix.de>=0A=
> Cc: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Cc: Herbert Xu <herbert@gondor.apana.org.au>=0A=
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> Cc: linux-crypto@vger.kernel.org=0A=
> Cc: linux-kernel@vger.kernel.org=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
