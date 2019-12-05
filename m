Return-Path: <SRS0=t288=Z3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C9AC3F68F
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:53:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAEBC24651
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:53:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="rUj2mBYh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbfLEJxq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Dec 2019 04:53:46 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:11804 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfLEJxq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Dec 2019 04:53:46 -0500
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Tudor.Ambarus@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="Tudor.Ambarus@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tudor.Ambarus@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: n82bip38J3bRkkGy1/3d2rYdMVCTPZ/lTKFB0d7tf2QhXmVelxc59mrdAHS6Fp0oIC5BoXXCPk
 yHzEuZJx91sSF9lCxzz+S//zm+UbtOQPk7pk28rC4MASqFp2ywbBUS4o9pXYK/Z7iuEuD9ilyX
 4TCJ4irVPa4siqNJMSbAArp3AFotXxTH9vQy97jkkzWdyuWng5NBh9v5sPUCnosKSwmYAGMK51
 S84unDrfZg45f1jqSRcdSdluhxllnwlRaWesi+MOZ8Vayf9v5mO8prhV0pviWDHUtkEC10fosB
 EcE=
X-IronPort-AV: E=Sophos;i="5.69,281,1571727600"; 
   d="scan'208";a="58828869"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Dec 2019 02:53:44 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Dec 2019 02:53:44 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Thu, 5 Dec 2019 02:53:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/+aApJVZ36HbIxFBGAAVKrp0naj+Qir29zBaa+kZJdLFQ82F7brOOkQ+LFU4AHaKVnb512WRiSnFO/UqlLnz6kK9TitdDyjT3W3t4R9kZCrkDWC9/N9guoinOCjFbaiVnqCbcwnM2Od36qWROpVFQKn2W3Eq4e63Hj9J2X5V8eWFBkmTclNUbqdHTl0lnALlPGMVIMAaKhGVmjMrbjeqGEjYFzyOTLkA4BDP8Joe1YmYUVwEJM1fQEXtj3iak3UI1j3wG4hG0XDirkmG/YAPKZxXEcYr63MoP4TdMzC9dhsDr9FWqGpcio8VoWj36CVd2ef7Hghk8sdA1dAVe0CuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2M42lxTGtsVVc0PDLWsKAy6Mb6epP2IqIvRzdb2Y36I=;
 b=b/RwaPjYX69e7LHB4I0z48On8PflunQ4yFSdctwb01hLw1xbiks4PQ97qZosqPcIz+Fxue5v3lYvJBT9uBGrDDrI1ZTtwiaIFiQhwVcRyGPzv9RFnXGh50J/E199vUBOTLxfOJU5sRZYF0tu5aEirBJWB1px/MskvqxsVoXLYJSfQWtWwdNE7TnaWxguChIKHylkNe/wQws3RVsD4h1PdmZekk/zqJpLGeWYjSGV8Jw9HdqGB9pQ9oBICtPgHQuVCXd5Q31ux69gu7VdDOiN11hgfJTjUaA6YBVDId44zXLqZGn2Ap63mg8Vvxw9fkKGsiD4uLIOHcO2m73fPvmLyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2M42lxTGtsVVc0PDLWsKAy6Mb6epP2IqIvRzdb2Y36I=;
 b=rUj2mBYhFQXjiHWXcajSvmhITyNFA6PJCrJuPnxUSc2UCcAN2CEuHooYVYuIjO+paOiraLuWukzrYY+SyUPlNe44X07tqkCAaR1TWxHrRCszO4N0EEECAVPZvaPL8CnkJhkdbU92CurL7Jltav/1OsI7YNAE+tZOljudzN+QfgY=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB3677.namprd11.prod.outlook.com (20.178.253.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Thu, 5 Dec 2019 09:53:43 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9%5]) with mapi id 15.20.2495.026; Thu, 5 Dec 2019
 09:53:43 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <Tudor.Ambarus@microchip.com>
Subject: [PATCH 00/16] crypto: atmel - Fixes and cleanup patches
Thread-Topic: [PATCH 00/16] crypto: atmel - Fixes and cleanup patches
Thread-Index: AQHVq1HgGYJ7Y9qfpE+77cxwmTv1mA==
Date:   Thu, 5 Dec 2019 09:53:43 +0000
Message-ID: <20191205095326.5094-1-tudor.ambarus@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: FR2P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::28) To MN2PR11MB4448.namprd11.prod.outlook.com
 (2603:10b6:208:193::29)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.14.5
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc77d333-5944-47e2-35d1-08d779690365
x-ms-traffictypediagnostic: MN2PR11MB3677:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB367714EB312B5F2B96906884F05C0@MN2PR11MB3677.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:962;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(39860400002)(376002)(346002)(396003)(189003)(199004)(2616005)(66556008)(305945005)(66476007)(66446008)(102836004)(64756008)(5660300002)(52116002)(99286004)(36756003)(66946007)(2906002)(54906003)(26005)(6916009)(6506007)(1076003)(8676002)(6486002)(4326008)(50226002)(1730700003)(8936002)(14454004)(81156014)(186003)(86362001)(81166006)(5640700003)(478600001)(6512007)(71200400001)(25786009)(316002)(71190400001)(14444005)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3677;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xMc+4GYAgaXBveRx3uibEEw6Eks7VIC+f4pYQ0jFgQ3Lvo5ybwMqsOoYpBJWC2HWYjEzLbjl4p8Al2qkhPjDZUVMymGG3epN9zqEzY/IEsCUef2lnwzDmSim1vPivrbb4BK7PXCwVVFPLG1OySbUqMHM4xydB80dk5k/fIGsqF1uRXo+1SjamjQTB7owggBdZniBu/fgQEjUnxQy6wiPyCGfmQvyxLndKJw8Osc2I3qih+fmB7HhUxalFzMYFk7eJ3gQ3ryqwnHs2QAYasPx3Yj/DNQbWIPapgOtApCqZIHD45QPUZ+hVaHmfhVHeyt+oEgjUXjF/8/ROXyovHwe/bN+7Qb+twltkrgzCSU/VebFBbOffFDZXWXxhZEq2W1YGMlCog8Y2WFrigGnQ7tQ3r+uDOVyU8IoenytFMY4Lz+d2b9Ru8nXngj7wU83zR+L
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bc77d333-5944-47e2-35d1-08d779690365
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 09:53:43.3435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v5gRre/9xDJGlj2UCGTH0n3Lu7RxhPBT8T8sDRiUwnKmdYIqO5hccF7bq6jzv9LXOfG4V6suUDErqKXZGqWU+1sCDme9Gb0m9X1pUWwKOis=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3677
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

Fix AES CTR and other cleanup patches.

Tudor Ambarus (16):
  crypto: atmel-tdes: Constify value to write to hw
  crypto: atmel-{sha,tdes} - Change algorithm priorities
  crypto: atmel-tdes - Remove unused header includes
  crypto: atmel-{sha,tdes} - Propagate error from _hw_version_init()
  crypto: atmel-{aes,sha,tdes} - Drop superfluous error message in
    probe()
  crypto: atmel-{aes,sha,tdes} - Rename labels in probe()
  crypto: atmel-tdes - Remove useless write in Control Register
  crypto: atmel-tdes - Map driver data flags to Mode Register
  crypto: atmel-tdes - Drop unnecessary passing of tfm
  crypto: atmel-{aes,tdes} - Do not save IV for ECB mode
  crypto: atmel-aes - Fix counter overflow in CTR mode
  crypto: atmel-aes - Fix saving of IV for CTR mode
  crypto: atmel-{sha,tdes} - Remove unused 'err' member of driver data
  crypto: atmel-sha - Void return type for atmel_sha_update_dma_stop()
  crypto: atmel-aes - Use gcm helper to check authsize
  crypto: atmel-{aes,sha,tdes} - Group common alg type init in dedicated
    methods

 drivers/crypto/atmel-aes.c  | 227 ++++++++++++++-----------------------
 drivers/crypto/atmel-sha.c  | 102 +++++++----------
 drivers/crypto/atmel-tdes.c | 270 ++++++++++++++++++++--------------------=
----
 3 files changed, 247 insertions(+), 352 deletions(-)

--=20
2.14.5

