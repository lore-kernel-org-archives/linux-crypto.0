Return-Path: <SRS0=VBnc=TV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03564C04AAF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 14:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C61E021773
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 14:34:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="KygpDxVR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbfEUOeC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 May 2019 10:34:02 -0400
Received: from mail-eopbgr130043.outbound.protection.outlook.com ([40.107.13.43]:54704
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726900AbfEUOeC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 May 2019 10:34:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rx6ctRwkpSDWCtJNwj1ack1zxk9x1hJ3gOb34h3BZ9U=;
 b=KygpDxVRXZaBUysCD78wTuWdK3hxz0Mqsuq00SPKOYoi4szuhjYixhhGefSHoYBNeazgqXPzRohySWqCCp3nxX96Y1DNZNjWzUk9LpvnuY4EvmjCotL/ksfirsC+206tVWfB05a5/7f/a7/LYC/E0teVdVuuwdxwAdVB5oia7Q8=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3552.eurprd04.prod.outlook.com (52.134.4.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Tue, 21 May 2019 14:33:57 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a450:3c13:d7af:7451]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a450:3c13:d7af:7451%3]) with mapi id 15.20.1900.020; Tue, 21 May 2019
 14:33:57 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH 3/3] crypto: caam: print messages in caam_dump_sg at debug
 level
Thread-Topic: [PATCH 3/3] crypto: caam: print messages in caam_dump_sg at
 debug level
Thread-Index: AQHVDJL/16KinpQLJEO6LVpaRbA2Ow==
Date:   Tue, 21 May 2019 14:33:57 +0000
Message-ID: <VI1PR0402MB34854A3EE9C7D5AB4FFAA97698070@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190517092905.1264-1-s.hauer@pengutronix.de>
 <20190517092905.1264-4-s.hauer@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [94.69.234.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c6df66f-d8ae-46f8-3abf-08d6ddf95bf1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3552;
x-ms-traffictypediagnostic: VI1PR0402MB3552:
x-microsoft-antispam-prvs: <VI1PR0402MB3552392A235A0316C26752A998070@VI1PR0402MB3552.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0044C17179
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(136003)(366004)(376002)(39860400002)(43544003)(199004)(189003)(478600001)(4744005)(71190400001)(71200400001)(66446008)(64756008)(66556008)(66476007)(73956011)(66946007)(76116006)(229853002)(86362001)(81156014)(81166006)(110136005)(446003)(44832011)(14454004)(186003)(8676002)(8936002)(26005)(6436002)(52536014)(33656002)(74316002)(476003)(486006)(25786009)(2906002)(5660300002)(6116002)(3846002)(256004)(2501003)(7736002)(53546011)(6506007)(9686003)(53936002)(68736007)(305945005)(316002)(66066001)(102836004)(55016002)(99286004)(4326008)(76176011)(6246003)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3552;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uimCJxOUbJfzVjUOyfkObDey6xUu2+UuH1TzM4cvUwE5Q7Iz20HrgT3f9oFBw3oDRPE4wXbH9fVkwxnlSNLxfO0nPrOLfVUEMjDs/s84AVQERnS12KAKVX3+3xzAwGIzWCVvk0jbhj83x3SyCr7cD4E7bf7/5VKJtwM/TAC2m1sEWor3jdRCk+ueNjLRIR1LY0MGliMuYdayLeVhesFcZ8BWpBsYKBsuRAn92T7rzwZll412AQrrDRzI4J3MgNP9NR9zzf2XBS2UL4oUKAL9ASw17cX4I68/AIl//xl0RCExHPax4RhB8170OfQCGWZ15I37YuwHnDPMQQNfPVhy1bE5I1dbWzJIxqIKMLMDFVHp9w/q/gaLCXXL3x7We+yIc0bAP6WjRwSIaT7NyERwxr5uHNZ5brvIPG9KAEvQK4M=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c6df66f-d8ae-46f8-3abf-08d6ddf95bf1
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2019 14:33:57.8195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3552
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/17/2019 12:29 PM, Sascha Hauer wrote:=0A=
> @@ -35,7 +35,7 @@ void caam_dump_sg(const char *level, const char *prefix=
_str, int prefix_type,=0A=
>  =0A=
>  		buf =3D it_page + it->offset;=0A=
>  		len =3D min_t(size_t, tlen, it->length);=0A=
> -		print_hex_dump(level, prefix_str, prefix_type, rowsize,=0A=
> +		print_hex_dump_debug(prefix_str, prefix_type, rowsize,=0A=
>  			       groupsize, buf, len, ascii);=0A=
Same comment as for 2/3, please take care of the alignment.=0A=
=0A=
Thanks,=0A=
Horia=0A=
