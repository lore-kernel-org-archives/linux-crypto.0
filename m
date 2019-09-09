Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0943EC4740A
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 12:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81F972067B
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 12:08:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="DUzCmDr9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404360AbfIIMIA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 08:08:00 -0400
Received: from mail-eopbgr80057.outbound.protection.outlook.com ([40.107.8.57]:7168
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390907AbfIIMIA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 08:08:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8cBFhhUp6/hlxqrA7i9sgT/NmzdADFsoXVskNRBc5QJaZzr1SVOc+OPbOLx4gRwYHMx3B8ViRM+raIq0+FWFQIk8s7CuQNoRPfUfpvhyC0VWNWxuOe6SnFNyTNEgOEkmTO6cRjXfB4NDbVfAxm9hoVXBKlgd+AnwwvQUnipxNNk9p2EyUQHBRLPDrIhpcRSn21VnK0S6lmjAdI8fDxonuRBLk0Rcr94bK1Jd7bTD8of58Lh89aN18sn7E5MtN+zsNlJHrXreEA234+WtBGWBrDHxfglUwUqZT3asyXfAxfFcyhevgv+sXPonVml/Ebl4OK+rqaDBonkxKA9PRnKig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/y0ZKGvPbXOSE682aGkrIttSNboiADW5JoivkeTeyU8=;
 b=mpUfe4hAtZfcXh44Po8vXJdsXtuMF6Zi7ihcyPJPteDV0g/BqFx6lBa0fzSj39/6ZhMabAsXOh+nHbKs/ieeg+y+mSqJyf/dE4LobWNV4SgtYZLUIdSaz3XG5T3Kc+uKD4Sk6rG61VPeYDDlrvetWYpV2mzO+3YswoEgOq19zznPixMfs45HRowHVKc5EbPZQjFBQJZtLfSu6BlyjdlDepsIBzJ2wD2NP5pVn1sSuRsLcwr6W409huOOl20pQPwsgtYzok8rnbCvdt7/GrLNP/qsq/pRc7ipqKEVsfijLVP94fHWcGxJKAYEqz0PEvH/PaG2EJFXunP9hoLoo+wVPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/y0ZKGvPbXOSE682aGkrIttSNboiADW5JoivkeTeyU8=;
 b=DUzCmDr9U6hy/SfFzSHQYEeR8H8mXzfWLQm7aejODtK2OJjMEdvu7Wcvq9z2SciSvcfdYMHJFiL5kdbMqatf0ojy+qerpH0H9mZ6icmlk/+j92jHxHYe7UuerlyX3MWMldYsks1Aydyik0aNhAW4JQSa7PjO2Ma1E856Gx+V3zQ=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3344.eurprd04.prod.outlook.com (52.134.8.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Mon, 9 Sep 2019 12:07:17 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::c1a3:2946:8fa8:bfc5]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::c1a3:2946:8fa8:bfc5%3]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 12:07:17 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Andrey Smirnov <andrew.smirnov@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/12] CAAM bugfixes, small improvements
Thread-Topic: [PATCH 00/12] CAAM bugfixes, small improvements
Thread-Index: AQHVYsltKfzOWzulykSXuTfZEkbAhg==
Date:   Mon, 9 Sep 2019 12:07:17 +0000
Message-ID: <VI1PR0402MB3485DC32B1789CB76C16F23798B70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
 <20190909075308.GC21364@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c4245aaf-aa52-49ae-a53f-08d7351e4234
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3344;
x-ms-traffictypediagnostic: VI1PR0402MB3344:|VI1PR0402MB3344:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB33446FF84093657DB004DB0A98B70@VI1PR0402MB3344.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(199004)(189003)(256004)(54906003)(86362001)(8936002)(33656002)(186003)(81166006)(14454004)(81156014)(8676002)(76176011)(316002)(229853002)(305945005)(74316002)(7696005)(110136005)(478600001)(9686003)(55016002)(5660300002)(7736002)(25786009)(52536014)(66476007)(446003)(44832011)(53936002)(2906002)(6246003)(476003)(26005)(91956017)(76116006)(66066001)(6116002)(3846002)(4326008)(71190400001)(486006)(6436002)(71200400001)(6506007)(53546011)(99286004)(66446008)(66556008)(64756008)(102836004)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3344;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0cHAiooOiItgKpTWZeYwArs6/Ya2BUA0pDNOPQXOc8FdUbyVe1YvJE+U+3bInOf6MtAqc399TDLf8qS77a/mGL71iwC4E583tPjXoN9lyJhF5g3fYU45AN9b4dq4jV2Q3myvFD9Pvj3zCUW2Zv/hc6g1/NWyjC3UEJLuxzZ0us2UbZptGjZO/CGGLoZgg16LYhweh+L5DdLzfKJIVJSisTwJI5yCrkbczL4/V8Zk5XjO0gLLfhfO4iZKmBBYC6Ohs/baAM8zpAe3ACq9cj7PcKCoPBfnZ0mMpbMoTMYesI73P7YC1aqgLll+OQ2WqGjHFolpaLo4b+tDT0aW35ex3C+uurQ9GtMJSoj6Hb7lda+kYfojNqNiYoGS7262QRQJwXquQvBbNReVi4At04LdHEQhvJ+cX7tLIBLbOUSigfk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4245aaf-aa52-49ae-a53f-08d7351e4234
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 12:07:17.0662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /CR1IxVXaSkOFcD9RwD0PGgNqYDriu33JbvAnL9gabx2su/tzy3JTxlM8JQ35eED4zKzj+OiHxMEOlAHSaEHbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3344
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/9/2019 10:53 AM, Herbert Xu wrote:=0A=
> On Tue, Sep 03, 2019 at 07:35:03PM -0700, Andrey Smirnov wrote:=0A=
>> Everyone:=0A=
>>=0A=
>> This series bugfixes and small improvement I made while doing more=0A=
>> testing of CAAM code:=0A=
>>=0A=
>>  - "crypto: caam - make sure clocks are enabled first"=0A=
>>=0A=
>>    fixes a recent regression (and, conincidentally a leak cause by one=
=0A=
>>    of my i.MX8MQ patches)=0A=
>>=0A=
>>  - "crypto: caam - use devres to unmap JR's registers"=0A=
>>    "crypto: caam - check irq_of_parse_and_map for errors"=0A=
>>=0A=
>>    are small improvements=0A=
>>=0A=
>>  - "crypto: caam - dispose of IRQ mapping only after IRQ is freed"=0A=
>>=0A=
>>    fixes a bug introduced by my i.MX8MQ series=0A=
>>=0A=
>>  - "crypto: caam - use devres to unmap memory"=0A=
>>    "crypto: caam - use devres to remove debugfs"=0A=
>>    "crypto: caam - use devres to de-initialize the RNG"=0A=
>>    "crypto: caam - use devres to de-initialize QI"=0A=
>>    "crypto: caam - user devres to populate platform devices"=0A=
>>    "crypto: caam - populate platform devices last"=0A=
>>=0A=
>>    are devres conversions/small improvments=0A=
>>=0A=
>>  - "crypto: caam - convert caamrng to platform device"=0A=
>>    "crypto: caam - change JR device ownership scheme"=0A=
>>=0A=
>>    are more of an RFC than proper fixes. I don't have a very high=0A=
>>    confidence in those fixes, but I think they are a good conversation=
=0A=
>>    stater about the best approach to fix those issues=0A=
>>=0A=
>> Thanks,=0A=
>> Andrey Smirnov=0A=
>>=0A=
>> Andrey Smirnov (12):=0A=
>>   crypto: caam - make sure clocks are enabled first=0A=
>>   crypto: caam - use devres to unmap JR's registers=0A=
>>   crypto: caam - check irq_of_parse_and_map for errors=0A=
>>   crypto: caam - dispose of IRQ mapping only after IRQ is freed=0A=
>>   crypto: caam - use devres to unmap memory=0A=
>>   crypto: caam - use devres to remove debugfs=0A=
>>   crypto: caam - use devres to de-initialize the RNG=0A=
>>   crypto: caam - use devres to de-initialize QI=0A=
>>   crypto: caam - user devres to populate platform devices=0A=
>>   crypto: caam - populate platform devices last=0A=
>>   crypto: caam - convert caamrng to platform device=0A=
>>   crypto: caam - change JR device ownership scheme=0A=
>>=0A=
>>  drivers/crypto/caam/caamrng.c | 102 +++++-------=0A=
>>  drivers/crypto/caam/ctrl.c    | 294 ++++++++++++++++++----------------=
=0A=
>>  drivers/crypto/caam/intern.h  |   4 -=0A=
>>  drivers/crypto/caam/jr.c      |  90 ++++++++---=0A=
>>  drivers/crypto/caam/qi.c      |   8 +-=0A=
>>  drivers/crypto/caam/qi.h      |   1 -=0A=
>>  6 files changed, 267 insertions(+), 232 deletions(-)=0A=
> =0A=
> All applied.  Thanks.=0A=
> =0A=
Why all?=0A=
I've ack-ed only 1 and 4.=0A=
=0A=
Besides this, patches 11 and/or 12 break the functionality,=0A=
i.e. driver gets stuck during crypto self-tests.=0A=
=0A=
Horia=0A=
