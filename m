Return-Path: <SRS0=XUD9=VU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D506BC7618E
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 10:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 834212251A
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 10:50:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="YtDhqwns"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731211AbfGWKu2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jul 2019 06:50:28 -0400
Received: from mail-eopbgr60047.outbound.protection.outlook.com ([40.107.6.47]:17126
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728856AbfGWKu2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jul 2019 06:50:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YHToN0YKXzP5Dp1Oii6bbg5ka+j5OhP0O5RxluonrvbXg2ZrI78y0nCyNGOELTnAYkQE0LZKt2pP2n2z5IxJruv7hm98n3lfcyWQ1zTHM4DJoeDUWLn62cBMWd/Mt4YfXJ6h7jaguvMCu9abbvnPje2xn+JQuDlkmKLDHMCkmn8LFEnbTOO/Rkp5d/YZaZEBvT2ZWXbxH1phDEZHhjwZrSW6lbQohZXLE6fCZ4KcmMH9NWSd/f8w/if8jFS/8X1H9T3mqQ6BVXVhLYEDPAZG9DIUMyHkePZZoneNR3YvaV7rAj7fS+E8l0b3K241Dze8b5XsP3nlZytOf7dGmd4Zow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQ7deO9Zt9tnQaXfK/kgLBCxAXzcYjqx0sGXq3c33sU=;
 b=NR9FoRivesZDVsD76cMeCeZHjyg6gfdQi/uhdtcVIRwZLSKymABNVadcTKpMHavHByN0tpeaJ5HAtPgmQLD09FoBGCVszkX3+Njy6bKfYEZWHpllWs3g1gazxF4Hp/TGlBd1Iuv+/MhOV2G3pdFL93PqrTwH1ancVi6JUxCXSaC8Q28b3JqvUfTC0xOloxlrdsGgzwwLLrdRImebgZEc6qFEapk6q1dnT/AIrqOfTeD86J8n1bnpBpAPlG1pXp6j/lCqja5RVunIgf7zBVaf+UR4pg43qozyeeU7GcfxgAB9eXNKgygiuqliq4RjDPNSngfqXdPnMKlZB908cXfOHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQ7deO9Zt9tnQaXfK/kgLBCxAXzcYjqx0sGXq3c33sU=;
 b=YtDhqwnsdY7mzO6LAs4JspHYLSu5Z5ntvgkeu8NC8xaHO1C/ObMBkR3v1FG0OdOrp0FopUa0Ve0yCgTxRW/zCwo33rzYkVBlJFRWGCbuqDLh99tSolHdq9PNc97oYmSkyjl0oh2oVLJwvVvTAijkIeRI3JD46H5tryXa2gKnBxQ=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3758.eurprd04.prod.outlook.com (52.134.15.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Tue, 23 Jul 2019 10:50:23 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Tue, 23 Jul 2019
 10:50:23 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Vakul Garg <vakul.garg@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Topic: [PATCH v5] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Index: AQHVQTcF+gEt00n54EefuTviasufew==
Date:   Tue, 23 Jul 2019 10:50:22 +0000
Message-ID: <VI1PR0402MB348577149DA38E846EB09D0B98C70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190723091005.827-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 379c693b-59fc-49e0-8eca-08d70f5b9020
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3758;
x-ms-traffictypediagnostic: VI1PR0402MB3758:
x-microsoft-antispam-prvs: <VI1PR0402MB37580DB179330F96EF81177598C70@VI1PR0402MB3758.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(366004)(376002)(39860400002)(199004)(189003)(64756008)(66556008)(66946007)(66446008)(558084003)(91956017)(76116006)(53936002)(66066001)(2906002)(6246003)(71200400001)(52536014)(66476007)(71190400001)(25786009)(229853002)(99286004)(55016002)(6436002)(446003)(86362001)(81166006)(2501003)(9686003)(6506007)(44832011)(53546011)(3846002)(76176011)(305945005)(486006)(14454004)(478600001)(102836004)(7736002)(81156014)(26005)(8936002)(74316002)(8676002)(476003)(33656002)(186003)(316002)(5660300002)(68736007)(4326008)(54906003)(256004)(110136005)(6116002)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3758;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kD82jKjQL8FfqZukydsNA0uoMtfQMJviaY2QNa4YlF6bWK4ct9FnCErHSuTkUEMdncEKKd+FbYgYv37+gZPmplfx/2OvDIn6VcZEYtZg44GvLSt8B36uIBjjopUQ4bt9PbYmDXQuc+Z+Imqr8qgskcHnrBK0S4wk20ruOBcpLIifODeKwkmBEpGQFJMGWy4GrVtiMZxTriOM+hOs7VPY5JJ6UBlktkBCmo9J+AW7GUEGURYers78ROlkfa2Na/E3Z2hwY0H9WiJPMo5CaKjnGSMD4+jGzT3CVEKEJMnCLS8wxcMqQaSPMQCD6HIvMyb2j7PcwoHHplG/MGwpB+wHa8rDV6N4v6ZArX8feHa2MnbtcOzzuf2vt2CNVIojkEYgRmPhPC+0B4cePm8lA6sOMufw1vCWQWHIoi4CYXElf+k=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 379c693b-59fc-49e0-8eca-08d70f5b9020
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 10:50:22.9128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3758
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/23/2019 12:14 PM, Vakul Garg wrote:=0A=
> Add support of printing the dpseci frame queue statistics using debugfs.=
=0A=
> =0A=
> Signed-off-by: Vakul Garg <vakul.garg@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
