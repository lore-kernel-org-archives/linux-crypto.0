Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CEA6C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 22:41:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B7E7218D4
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 22:41:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="vgcvaLhe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfCVWlQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 18:41:16 -0400
Received: from mail-eopbgr50045.outbound.protection.outlook.com ([40.107.5.45]:57967
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727846AbfCVWlQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 18:41:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8OQZsg6uumDh1klxVAzgZAlkKiyowwt+HdXzFmNfj+0=;
 b=vgcvaLheppNw/rCKcj6591yk2LTcIVQOKihpYu0ZpvAqcZR4lDJ2KCUqLoilH9RpTSomSMcv5utC45CbXM2QY9CuK8LzoWvEgdcrvfkVW99Q2JMGUym+a2DbN5yqY80Ph9sw7TcI2e7n4qGUMtf8uZRfObVgPLSOpJmR5Z8U1p0=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3758.eurprd04.prod.outlook.com (52.134.15.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.17; Fri, 22 Mar 2019 22:41:11 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::9c05:647c:6f6c:c531]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::9c05:647c:6f6c:c531%2]) with mapi id 15.20.1730.017; Fri, 22 Mar 2019
 22:41:11 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Vitaly Chikunov <vt@altlinux.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        "qat-linux@intel.com" <qat-linux@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Subject: Re: [PATCH v7 03/11] crypto: rsa - unimplement sign/verify for raw
 RSA backends
Thread-Topic: [PATCH v7 03/11] crypto: rsa - unimplement sign/verify for raw
 RSA backends
Thread-Index: AQHU0FiE7YbNLAo+GEG1lDDG7g4f9Q==
Date:   Fri, 22 Mar 2019 22:41:11 +0000
Message-ID: <VI1PR0402MB34850609BF2BB886C029F0B398430@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190301175918.29694-1-vt@altlinux.org>
 <20190301175918.29694-4-vt@altlinux.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [78.96.98.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20997fda-a98d-49c0-4cca-08d6af177bdc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3758;
x-ms-traffictypediagnostic: VI1PR0402MB3758:
x-microsoft-antispam-prvs: <VI1PR0402MB37585D857500274CB862A40D98430@VI1PR0402MB3758.eurprd04.prod.outlook.com>
x-forefront-prvs: 09840A4839
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(346002)(366004)(136003)(396003)(199004)(189003)(446003)(5660300002)(2201001)(6246003)(8676002)(2501003)(2906002)(9686003)(68736007)(6116002)(53546011)(102836004)(6506007)(8936002)(229853002)(81166006)(3846002)(105586002)(81156014)(186003)(76176011)(7736002)(71190400001)(55016002)(44832011)(106356001)(97736004)(26005)(52536014)(476003)(86362001)(4744005)(305945005)(71200400001)(486006)(6436002)(14454004)(7416002)(74316002)(110136005)(54906003)(14444005)(316002)(4326008)(53936002)(478600001)(15650500001)(33656002)(99286004)(7696005)(256004)(25786009)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3758;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SKCZLyK+nWdylY8fpWwNxeRdTQgFnjnvWlOjNfIcbO1yChzRjwJm7xQCiwOIYAGDgNTHvJd0cYI8y7xeYLXf1V6cN16modh+Te3v8ASbXo8Qug7/eQrFonUJOE0M73MlqbrodCQJn3GnGN4T6TJbVQM23lBabtdsb2SJX/sx1CAdM7iWjMd/sE5PiFiHHs+7KWzs0atbDcWZzEJoC4qTHoal4DQZTmjN2r/q810OA3qRS/QiZf145NClo2CniTAhta7VRkKioUpSZD0I0DZHHj5p0LNWl/5qxRrpwyMO/WhHM1aueRHbk7+TPA6gEqzDOp/HgGRShRfJOK1Qp7BYz2vs4V4Q11c7ZapkwsYIJznyIY0xwL84beGhlrdWgNAaMnG2bIDYyzdLfWnYXHM6PyUoMiAIZacRctG5FLiQ1yw=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20997fda-a98d-49c0-4cca-08d6af177bdc
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2019 22:41:11.5857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3758
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/1/2019 7:59 PM, Vitaly Chikunov wrote:=0A=
> In preparation for new akcipher verify call remove sign/verify callbacks=
=0A=
> from RSA backends and make PKCS1 driver call encrypt/decrypt instead.=0A=
> =0A=
> This also complies with the well-known idea that raw RSA should never be=
=0A=
> used for sign/verify. It only should be used with proper padding scheme=
=0A=
> such as PKCS1 driver provides.=0A=
> =0A=
> Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>=0A=
> Cc: qat-linux@intel.com=0A=
> Cc: Tom Lendacky <thomas.lendacky@amd.com>=0A=
> Cc: Gary Hook <gary.hook@amd.com>=0A=
> Cc: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>=0A=
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
