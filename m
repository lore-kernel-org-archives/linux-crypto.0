Return-Path: <SRS0=wawN=VN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 948BCC7618F
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jul 2019 17:46:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A21D2145D
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jul 2019 17:46:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="jA6z9j5o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbfGPRqd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Jul 2019 13:46:33 -0400
Received: from mail-eopbgr140058.outbound.protection.outlook.com ([40.107.14.58]:46983
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728190AbfGPRqc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jul 2019 13:46:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SPlsSkx6U2C1Y/kK8Z5BZWCjQfgAf+FLSNVi0sKcsYpYYWrhlLKkVYsr9Zz13PyHT5g1dusisqwAsZ2A3L1Pz4lMRPQt35H1bIM9IDaWpJPe1LYwBp9FoGbhnxcXzNv65k+E7iVAEyhlBivKzdeH73sG/nLAeB+nIdlj+5eDhVKZrXln28LSv7ILy79IPAIqCL1niJO/66DgR/oGciCS1/IoiRLnXmyUXYj3aKz9mEwMyL8Hcdz9c92FKUcnfulKXnK5gDaoBW5DWHuAyvD0Kfz5dzi4htZ0dWdeNUMdsXQY4l/S1ffB4MnzQZNF4rF3/MfCg9uFgfDvk4btRYIpVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFQI579NFeXtS/dWJyorJrKW7HarNwbhUUV/7kUOhlM=;
 b=Gh0NZYCSwsvHoaoIoxqAPd5alnjsU5WfA78R/1jo2mvymzCvk7t6b8D5G4s0b0NhoInsxpwntvdNqQSjau8uCLkCwncNyey574OMBnpYBnJPq6YuOpMlRk7ATfQvojJh1JrwKMysjIWpclC6lSJT4c/sMeSWNaCU7cgYDvRZwDzf9AGVxPwryqtud4rOHAtY+XorSc25XIbak+csa9qEN1RkcZOcT8yrecRlda3HqJyodb6+nF2NqU9G7mrTAxJ3Ehw1794U9626IbS5oWKdAfORlLQeSBjUUk3PP1UMOol+7mboBt1Zi8rxGc5yffosVcAu8/Rt0irfQqG7OIQPmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFQI579NFeXtS/dWJyorJrKW7HarNwbhUUV/7kUOhlM=;
 b=jA6z9j5oedyOHk2VzEzu20UOY/o1xPv81DDGS1BuG0ynFKEni6QbyW+xzQ3bI6X0Ri6qeK4vfB40VaQhn/acD+scKSdY5nVEBE5B0azJ1iCAq/kNsF4CW2vTLmwAaS3N71sji5XC5QvYtzUZrkAphTuV/mQODxC/wb6BpxIxUW4=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3616.eurprd04.prod.outlook.com (52.134.7.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Tue, 16 Jul 2019 17:46:30 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2073.012; Tue, 16 Jul 2019
 17:46:30 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: xts fuzz testing and lack of ciphertext stealing support
Thread-Topic: xts fuzz testing and lack of ciphertext stealing support
Thread-Index: AQHVO/5l0aVU4O6KC0WgPIqEsMQCDg==
Date:   Tue, 16 Jul 2019 17:46:29 +0000
Message-ID: <VI1PR0402MB34858E4EF0ACA7CDB446FF5798CE0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [78.96.98.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b522f9d4-1511-4c8f-7089-08d70a1588b5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3616;
x-ms-traffictypediagnostic: VI1PR0402MB3616:
x-microsoft-antispam-prvs: <VI1PR0402MB361628B8830239F4B929973998CE0@VI1PR0402MB3616.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0100732B76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(199004)(189003)(3846002)(2906002)(74316002)(305945005)(8936002)(478600001)(186003)(7736002)(14454004)(25786009)(33656002)(4326008)(256004)(52536014)(81166006)(5660300002)(53936002)(76116006)(26005)(71190400001)(71200400001)(8676002)(99286004)(68736007)(66946007)(91956017)(64756008)(66476007)(66446008)(66556008)(102836004)(6506007)(66066001)(55016002)(9686003)(7696005)(44832011)(86362001)(486006)(476003)(6116002)(6436002)(316002)(110136005)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3616;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UT5ZNOft6VIKUTRZJDN1wcQ5OisaxRGPY5iDa/ram1ayt+6Djp/v8L/B8eTMD3PW9OJz+nLG15yhW35S4v+168Rx4P7z6C5dRP7t+rUf3v3vzaqirjIKsMgmDBLyU8VSK3eP6g38/aqCzusW2IAFrV2TpT9vDpmDNdENCSXUVaM7FEPVXZH9CqE+AfYC4BnDqo2errelVgd4CSFr/3HlOGxTrvXErO+ckrB1+inQkWnHkTjFJcFFqj21wv6fFGLb9ucsYY+9+n7I7pVa4ZIa21WnXgKVobLlLGRK4njq463G594UNuPZbo9XfL7GcIz6xa6LSl6GJL9c+JpMr2peSueq3QT4YRO5nU2PlCx6SZQk1Ts9z1/P4qOg2lcVZOoqQtDuwpDSeDG4FMcMGUJLHWLgOUc24VqnpbiTd3evCJY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b522f9d4-1511-4c8f-7089-08d70a1588b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2019 17:46:29.9498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3616
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,=0A=
=0A=
With fuzz testing enabled, I am seeing xts(aes) failures on caam drivers.=
=0A=
=0A=
Below are several failures, extracted from different runs:=0A=
=0A=
[    3.921654] alg: skcipher: xts-aes-caam encryption unexpectedly succeede=
d on test vector "random: len=3D40 klen=3D64"; expected_error=3D-22, cfg=3D=
"random: inplace use_finup nosimd src_divs=3D[57.93%@+11, 37.18%@+164, <rei=
mport>0.68%@+4, 0.50%@+305, 3.71%@alignmask+3975]" =0A=
=0A=
[    3.726698] alg: skcipher: xts-aes-caam encryption unexpectedly succeede=
d on test vector "random: len=3D369 klen=3D64"; expected_error=3D-22, cfg=
=3D"random: inplace may_sleep use_digest src_divs=3D[100.0%@alignmask+584]"=
 =0A=
=0A=
[    3.741082] alg: skcipher: xts-aes-caam encryption unexpectedly succeede=
d on test vector "random: len=3D2801 klen=3D64"; expected_error=3D-22, cfg=
=3D"random: inplace may_sleep use_digest src_divs=3D[100.0%@+6] iv_offset=
=3D18"=0A=
=0A=
It looks like the problem is not in CAAM driver.=0A=
More exactly, fuzz testing is generating random test vectors and running=0A=
them through both SW generic (crypto/xts.c) and CAAM implementation:=0A=
-SW generic implementation of xts(aes) does not support ciphertext stealing=
=0A=
and throws -EINVAL when input is not a multiple of AES block size (16B)=0A=
-caam has support for ciphertext stealing, and allows for any input size=0A=
which results in "unexpectedly succeeded" error messages.=0A=
=0A=
Any suggestion how this should be fixed?=0A=
=0A=
Thanks,=0A=
Horia=0A=
