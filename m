Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00EDCC7618B
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 15:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C67482070D
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 15:33:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="MfyclBA4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388070AbfG2PdB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 11:33:01 -0400
Received: from mail-eopbgr10083.outbound.protection.outlook.com ([40.107.1.83]:6420
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387925AbfG2PdB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 11:33:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R6+COZ9gmuo7gEdvMYM2c5sM7uBI/rqq34T8DuIWZxZ78M1gHwAyeb8Rn0m8b2qJqbO7BntRvWEn69NGmo3wZt30XP8PvRXchBnJv3oPJYToNcCTM6bLN6B+bVyUrQAaKGDw3dprpulqpNZGW0zcSRqgAAtfkCUgfhMGRIu0ND+MLcDmrWO4H+PQQS4TTUPSEeFN/x8xohAhcYR3sVu18ru3RkTDsLeRyDYN9NaUHLFW/aczAqB9/g88AuX1OJv75vLoyxZhmUOzGs4QT+73IfXA8huVTQJekoY3WPHa2iz0Aj8S69nZThcrZGOcT/dyBMXvcF9VfUcTYGNIQmnrsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ue8RTdPdSLbwKJ+qvvCSHaeB9OyDARc8Ok36XeQfWhQ=;
 b=ngz4qEsLmneZTdUFFzyLyqMDSQU/ZqunulwOobu6M4myeNV6eMT65ofX+z4Z3hUfaD4Ga/9yrrj+cb3yGjtzyoHW/3m0ANeWX/D0PNjsmi4rpkY2PFnIvIOuy1W5e9wgivaZA5QP6+LNWDvs2IzLpJmecJi7/QfId3wNvm14poeJm1su/oickF4ypia8+zUkQIGe1ylu1utyVf4/P+VQ7FjyK0MWpgIEPakHXw6vjWq9qfsdp3XJBNMykuRP4ld1Mlo55ALYezxDdtO9EIKRMWtwah8uY9Q9s5dFt47kDeyEZiRWFR/6UBwrrn45nP2rUxVuwdV6jcqgt2JjPO8oPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ue8RTdPdSLbwKJ+qvvCSHaeB9OyDARc8Ok36XeQfWhQ=;
 b=MfyclBA4FC+RYBMFryTzQMjyXNpGgzHL5JzNoifBPMV2GYLyYzTp05EXtOPMA2zS0//FUCyPkCLTcYL6iqi4RB8fkfkQiY50IBkmwMH/k7HHoJKdXcrkwTYaEyEahUDoKts/96JqojGuvwRoN1e4i78k/59etyQaMjQ342tx4Lg=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3920.eurprd04.prod.outlook.com (52.134.17.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Mon, 29 Jul 2019 15:32:57 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Mon, 29 Jul 2019
 15:32:57 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 07/14] crypto: caam - drop 64-bit only wr/rd_reg64()
Thread-Topic: [PATCH v6 07/14] crypto: caam - drop 64-bit only wr/rd_reg64()
Thread-Index: AQHVPLPbJqU/tciNO0+eJySSQ03gsQ==
Date:   Mon, 29 Jul 2019 15:32:57 +0000
Message-ID: <VI1PR0402MB34856CBB1DEB39A6716B6CE498DD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190717152458.22337-1-andrew.smirnov@gmail.com>
 <20190717152458.22337-8-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4deb7ea3-7c6f-4afe-eff9-08d7143a0845
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3920;
x-ms-traffictypediagnostic: VI1PR0402MB3920:
x-microsoft-antispam-prvs: <VI1PR0402MB39206F30DD825693E67EE82D98DD0@VI1PR0402MB3920.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:854;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(376002)(346002)(366004)(136003)(199004)(189003)(71200400001)(2501003)(229853002)(76176011)(102836004)(71190400001)(4326008)(74316002)(99286004)(256004)(53546011)(7696005)(446003)(86362001)(186003)(5660300002)(55016002)(26005)(2906002)(53936002)(478600001)(6436002)(6246003)(8936002)(476003)(110136005)(66066001)(66556008)(68736007)(54906003)(3846002)(6116002)(66946007)(66446008)(52536014)(486006)(7736002)(305945005)(14454004)(25786009)(9686003)(33656002)(44832011)(558084003)(8676002)(66476007)(76116006)(91956017)(316002)(64756008)(81166006)(6506007)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3920;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: isTcHUdicfFIaLeY/9U9u43fQSISZUTgOaZHSOZ6OZdRRgm85eDe8WBE8Z+KXubeKLeixItnJY+S9czxUpQvBJJRurxtk8mBbIDlKoWw2j0475xngTgzV88OWj17ow/axfz+1MYK6tKt83LrPNX+agfM9P9xBNbkxFpT4ZTHubtq0nfHuxLOycvbvq3F9jH2NeST0ibMLBA4dK6jwRfzxnzlLBdZgfPMmm6HaPqG870npwlkNJ+6eyQ9dXD/h5ApfeSJgyERrWNnv+TVqZq4qlJdWutjMe4X8iqXRw97QeqoT5vYKIeDd2F6rzgWfjuMW8xYgvvOzW20oos7LM66mzoyjHzCGUF/7RvCt5PHzCN0RHw9YjTZRRiUhM7El97WmqrmDeBqEHeNGyZn32eydfB6hUv8hfm+VEwWI7faZko=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4deb7ea3-7c6f-4afe-eff9-08d7143a0845
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 15:32:57.3775
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3920
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/17/2019 6:25 PM, Andrey Smirnov wrote:=0A=
> Since 32-bit of both wr_reg64 and rd_reg64 now use 64-bit IO helpers,=0A=
> these functions should no longer be necessary. No functional change inten=
ded.=0A=
> =0A=
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
