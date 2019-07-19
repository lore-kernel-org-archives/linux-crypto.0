Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15636C76195
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 14:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C916E21851
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 14:05:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="Ufp9CfU/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbfGSOFF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 10:05:05 -0400
Received: from mail-eopbgr800040.outbound.protection.outlook.com ([40.107.80.40]:40616
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728351AbfGSOFE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 10:05:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKGRDJ8uJ2MSexuXe9XCKChvqszTU8QuamuFpLuotFw0DCanevokIpW+rga+I0ROkeEBiXO8rTzcZWiPatlddl4MngJvct7jBBH410PgU4iV5JU3kRpPuIusN66geXtas+H+2fBp7oUn8sl6+yVmZTapF57JwYjjucO+OUOaJYfzz3EWJcaIUrYPRShL0cBCPZecfYls0BYBk1jjp7Njxf9qDLGKmYHLD+fjcFeDbU63di55sMbcW4GV3fTKNqxp11dSR8IitKTAf9rwnlvmqZjUM7k3AxAq969tIU0VC5KJcBj+VF1pmFtFLSht2aUfq0MOUVQ/F70FYM3ISTblHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Srm0DVWXurea31F359ru7U46wBOAObLwr8U2c8AJ1Tw=;
 b=REKdM39KuRWKXTEf7MDS+48bl7VVI10tI0C0KcUXta58oW9OcaLM4nEZVw2gEyzhyjTNAPfRRdiOvco4yEog5tjMrBXd/HbMJXON2MFGXMkDNUnxq4y3Q+6UVB7K7mJ4Pb4XCV+50ze6M6seBGv7DDztaa5jVVZ0KT28+3Y6yo+w6V/p0TBMHfyNcfSnupola1JsjnwwC9Np57otBZDpc0rgye160klC2fvIfddBDse+M+nJwcSggSUERWO9PtUB0ckfgGDlqUCPrSSBFPhbeHRnS8AZK+KpF9JcVi4hVILHeedHeuMmVqUI5Pb2C8ToIDIIv2d41yh+hE+zhwzVIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Srm0DVWXurea31F359ru7U46wBOAObLwr8U2c8AJ1Tw=;
 b=Ufp9CfU/1KiXgl7TtB8wOdjSsa1ggz+mBcn126OFgkDBbHyLu9VeUhr1qBdgLWOxCEyW+C/0RlvHV0oYGsTdrshm4VjZ4vF22U7PeKGvB1qbbUi2Dk27z0miik3Zhfjw0piobkoYhqLd24DD0TihY66/WzK3N8UjXKGvafAtjgk=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2717.namprd20.prod.outlook.com (20.178.253.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.12; Fri, 19 Jul 2019 14:05:02 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.013; Fri, 19 Jul 2019
 14:05:01 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: ghash
Thread-Topic: ghash
Thread-Index: AdU+OcccbSpphUQDQMqR1uphPmes/w==
Date:   Fri, 19 Jul 2019 14:05:01 +0000
Message-ID: <MN2PR20MB29737F1F60B3CBACBC4BD287CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6be963e4-473a-4e33-fb28-08d70c5217a5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2717;
x-ms-traffictypediagnostic: MN2PR20MB2717:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB27171E2A32126054B10218DECACB0@MN2PR20MB2717.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(396003)(376002)(366004)(39850400004)(136003)(346002)(199004)(189003)(25786009)(478600001)(305945005)(68736007)(966005)(7736002)(33656002)(4326008)(14454004)(74316002)(6506007)(26005)(102836004)(186003)(2501003)(256004)(14444005)(486006)(476003)(15974865002)(2906002)(7696005)(9686003)(6306002)(5640700003)(55016002)(66066001)(221733001)(6436002)(3846002)(6116002)(2351001)(52536014)(76116006)(7116003)(3480700005)(54906003)(6916009)(8936002)(99286004)(66556008)(66476007)(66946007)(66446008)(8676002)(64756008)(86362001)(71190400001)(217283003)(5660300002)(316002)(71200400001)(81166006)(81156014)(53936002)(133073001)(204593002)(220243001)(18886075002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2717;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EMkO7zF00mSri23A0+NczyB13DwItv7noVx2QryYw3vbLcgrIYqNmGWVXUJNLxZuW1iinbEfSlKz5NmLGYHN9XCKdPa1EONGTbDXeIX+FJ+4jAtiSzkslhGRHT2uYRVlcUFFGXJ8yZG1jeBeG7/BnXa/52GL6tHFpFZCTn9RitqVd2H0M/aoGDVg7+1kH4CGsns9/qL4ZSdUa4r0d5qtFGKU6n88VTz+MEYo1rXhA1JeQi9sptLCbsEzFhgM6lpy7Yygc0BQvbgiMWEUJ944LeafRgrvyRSRtwQb2sCRZStieH9SI3bNB0xboUFH12rbVKUYUOwwp62amcxEUKoF9x/Is3Z10sEhKWevezssiuPQCgvFh7tNgz2YJyMjRoXZwjeMPV4Zehw7xGnB5P81JYHO461XjG4vb7dZFeA/YQw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6be963e4-473a-4e33-fb28-08d70c5217a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 14:05:01.8070
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2717
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

While implementing GHASH support for the inside-secure driver and wondering=
 why I couldn't get=20
the test vectors to pass I have come to the conclusion that ghash-generic.c=
 actually does *not*
implement GHASH at all. It merely implements the underlying chained GF mult=
iplication, which,
I understand, is convenient as a building block for e.g. aes-gcm but is is =
NOT the full GHASH.
Most importantly, it does NOT actually close the hash, so you can trivially=
 add more data to the
authenticated block (i.e. the resulting output cannot be used directly with=
out external closing)

GHASH is defined as GHASH(H,A,C) whereby you do this chained GF multiply on=
 a block of AAD
data padded to 16 byte alignment with zeroes, followed by a block of cipher=
text padded to 16
byte alignment with zeroes, followed by a block that contains both AAD and =
cipher length.

See also https://en.wikipedia.org/wiki/Galois/Counter_Mode

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

