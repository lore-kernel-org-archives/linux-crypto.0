Return-Path: <SRS0=hp4v=WW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60156C3A59E
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Aug 2019 08:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A1612173E
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Aug 2019 08:38:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="UUjvnxmG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730703AbfHZIiN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Aug 2019 04:38:13 -0400
Received: from mail-eopbgr130054.outbound.protection.outlook.com ([40.107.13.54]:11747
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730287AbfHZIiN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Aug 2019 04:38:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aq1b7VQ3LWp+Y77ebxX+m7tEYBnJ12L/DagtbokBhDPs7y1jePMD9pCYKcowMxCNue9wOR3GpkJEMEwMcENrXzZ0LeigQkjluuP3unqXoJUvEBt4W4dmHhIVyWtyc0Hhb1V2jEFQEqsu9RDbUWbnDxP79leIGTej+suEHUovKMS9wVajS+4me2iF7SAPlFdDCwbGvlCGYa4QIQj79Sa+v3cZJJ963OzOM+ys93OiSB6gnW0FVduYeBO2BnGSYCHtz26y7exLMh41qJQfkMykZCFwcDEXt79ITHkRKOw6kn4Cnxn2EuiU2Q/N7ZzooHCVCiXltAOZ2i3N19IlQ+ji2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ImPLFp98OG9GxvY39qGzl7rzxOXXa2eV0wPVct6cG5I=;
 b=lLq1Hq6btIYGmW2O+W8fyOnzCo9N/yQ/EhjBVV4Iv1Hp7W5vl3Bda07jEVrajbr15h35r2M7Yge5sDaakZ2tYnLEKjKUJlaz2DS+Y6jm9zdUnSm3skuiL9LCJQeNR5npgIskvzYgYiZep02wNJu7qAw+Xxr7qI4v5ENUGcufIv/ej/Cfyz8BtmqjZdNb4WKhypsoS3yf6Etmf0Z5s0Mtc3XMIhdms7NaQknAR+rtHmIRKjcfzCpfSQj+RDAlrLxj6+UhvHHK5LIK5kTptrlI4srx5eLRpSd3vpCa6FH3Aevj+cuhldMCupaqvPJ/uUGFCZjV+MD5jZW0dhPVO7/+jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ImPLFp98OG9GxvY39qGzl7rzxOXXa2eV0wPVct6cG5I=;
 b=UUjvnxmGQcfxAZTcERYT/gzhpqD3sgHa81M/FzbnxvnsXHeLYDB2E3wG7FDq6WKBUdttn6qON+mIhJyaRfWpWhkrZKDJHY3nrI5OghMbFH5XSdogpjiyX+z78Miv0CfEf3XHJX7ViiryPmwfr6kD/AJnLJW8S1mW9eh1dHDRXps=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB4734.eurprd04.prod.outlook.com (20.177.48.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Mon, 26 Aug 2019 08:38:09 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::8d42:8283:ede8:9abf]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::8d42:8283:ede8:9abf%7]) with mapi id 15.20.2199.015; Mon, 26 Aug 2019
 08:38:08 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 00/16] crypto: caam - Add i.MX8MQ support
Thread-Topic: [PATCH v8 00/16] crypto: caam - Add i.MX8MQ support
Thread-Index: AQHVV5VB3CgVSzdtsUuKFBe5Nr//dA==
Date:   Mon, 26 Aug 2019 08:38:07 +0000
Message-ID: <VI1PR04MB44458F25E97B5052CC2498258CA10@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <20190820202402.24951-1-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07ad3381-17ba-4fa1-0d12-08d72a00b90a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB4734;
x-ms-traffictypediagnostic: VI1PR04MB4734:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4734897EDE6CD8CDC76D54798CA10@VI1PR04MB4734.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(189003)(199004)(71200400001)(44832011)(76116006)(66476007)(66556008)(64756008)(66446008)(26005)(8936002)(66066001)(54906003)(81166006)(110136005)(81156014)(8676002)(53546011)(316002)(186003)(478600001)(102836004)(91956017)(66946007)(229853002)(7736002)(74316002)(305945005)(14454004)(3846002)(6116002)(25786009)(52536014)(6436002)(446003)(4326008)(5660300002)(6246003)(4744005)(6506007)(76176011)(9686003)(476003)(53936002)(2906002)(256004)(7696005)(2501003)(33656002)(99286004)(486006)(86362001)(55016002)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4734;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VXqiUqdhiGsIOL5zG4+xarKitFNbiyM1lF5MyyexrWrIWidfG3TSZPRjluRc1VAlhqYvt+ZEyyKr4mXrOYEy5VUjdB/UHECDwpAmOJU0BGH+EWs6wScfzBqxHsDNub6m0PVUgQxvxCKyzbTgUc5XZD808uEKhMajI9kpEUrhik4OymrPog05KytSkze03PLiNgfkD5ddVwWRz85iTXL1NMnmKzfLwylyOM3PkXd6zRtXiavWo2oymDICF1lu2X2F7ONjA6Rw4reKEaVl7Pat5P8okLUu8ld67y2gMuO5YzoWS5c11n5vbvzJyGBrZCC8kvCfaihY9Kun/I/aMK0I3Zbc5+U2XllP/8FiKLVzeHduhADQN51BdyxdujUPBjEGsuCKsyFuseJ7qALb9f6eKxQvvT5QnohwX84loH8jhdo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07ad3381-17ba-4fa1-0d12-08d72a00b90a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2019 08:38:07.8071
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BuFvcvbjt98vqZtEw94/1qVXdppyZp2kjihqEuuEdfjVrviJOkEjXlZ3IkX39ZCOuKKtQngKfcgJ0moYnYgiQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4734
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/20/2019 11:24 PM, Andrey Smirnov wrote:=0A=
> Everyone:=0A=
> =0A=
> Picking up where Chris left off (I chatted with him privately=0A=
> beforehead), this series adds support for i.MX8MQ to CAAM driver. Just=0A=
> like [v1], this series is i.MX8MQ only.=0A=
> =0A=
> Feedback is welcome!=0A=
> Thanks,=0A=
> Andrey Smirnov=0A=
> =0A=
=0A=
For the series:=0A=
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
=0A=
Thanks,=0A=
Iulia=0A=
