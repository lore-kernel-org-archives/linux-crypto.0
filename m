Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA53C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jan 2022 11:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353002AbiALL7l (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jan 2022 06:59:41 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33576 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240123AbiALL7j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jan 2022 06:59:39 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CBDkXP007362;
        Wed, 12 Jan 2022 03:59:28 -0800
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2043.outbound.protection.outlook.com [104.47.74.43])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3dhwwy84ap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 03:59:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KKrXaqL4zHnRlC/RB8WdhjX8u2t5o6e5zG+rzGyAkYdCOqMBbdRYK3RqoejClnBHUr12nOOJ2znB1bpzu2Z4zm6fM+ym+UJ4NdzxQMaleQplkmi9270Sao5YK6dLfCWEvCV49jWz6zpl+0pfK+T/Fhr9xr9ChOzka18lQPZFXgok0Gl256JssH22vJ8JOQ4PdZN5wI5db2AviWBEAmRyqxaXJlS5mN2vXq2MAFWQO/5H/1KBYVCkAOhVNMQc/CcIHB22VVt5ATn+M8A93IvCTas59etQtST2QZ0+uJ9Y2pDBrO1pfstJevirwMQrlHfbPaXq6f9zGqprHJocP9bPTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=05gTI+7K1iqv2FRz3myVgkfzjfcIsV49dU44FVhw0tg=;
 b=l1HHWcUSnyXpXyeM3lEKlD6qqos+B+99wdQHzy6UZGl6NYKjRO8KOAyLgwdRb97kYkJ1v72hqmgzvPuK1vTMllGjQmgoUiU5ZGCCfSd/qmtpjuStBYSxkGA6tp4L+34kQrZyJhGQctAK48pzu2wzAitNG1sEnDHWQaK7cF13P4W7A3V/W+rkySjVx3IGjkOOK8nbVlw445MDljPD45zOzLyqZG5nc4zIRtrv4wbf50TV0CPaKROEzNaUxXvWUwHQLqeC7fQM922WIIheQw2Yq5S5QF107dIx/uLPiPpNyvn4pIcjIfXwsasn6WXossMfK2gg9myWh4OLnlKFtrNIGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=05gTI+7K1iqv2FRz3myVgkfzjfcIsV49dU44FVhw0tg=;
 b=aWZ+DgnXxurf/FSsunD+54tI3ZzcNiMJAH+5uEfpwU3083q/77AZRf2J/1LthUlEMYbBJ0HcL3PExrBQnu7EKxpVh04cvxz7LCaU5Iq0YyY7EdtcWz975mOVs4NYaX3ksUSleJ3iJEiWzYgSCsf+XfliCRDjAkWWI2ezC9oawgc=
Received: from PH0PR18MB4621.namprd18.prod.outlook.com (2603:10b6:510:c1::12)
 by PH0PR18MB4685.namprd18.prod.outlook.com (2603:10b6:510:c8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Wed, 12 Jan
 2022 11:59:26 +0000
Received: from PH0PR18MB4621.namprd18.prod.outlook.com
 ([fe80::e401:a9b1:41c:ec5b]) by PH0PR18MB4621.namprd18.prod.outlook.com
 ([fe80::e401:a9b1:41c:ec5b%5]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 11:59:26 +0000
From:   Dhanalakshmi Saravanan <rdhana@marvell.com>
To:     Ben Hutchings <ben@decadent.org.uk>,
        David Woodhouse <dwmw2@infradead.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Shijith Thotton <sthotton@marvell.com>,
        Karnam Raveendra <kraveendra@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Raj Murtinty <rmurtinty@marvell.com>,
        "linux-firmware@kernel.org" <linux-firmware@kernel.org>
Subject: pull request: add Marvell CPT ucode binaries
Thread-Topic: pull request: add Marvell CPT ucode binaries
Thread-Index: AQHYB6iiH2Mgda5c4EmOnj6I3TkNQqxfRocA
Date:   Wed, 12 Jan 2022 11:59:25 +0000
Message-ID: <PH0PR18MB4621BFAAEB1686B3400D885AC8529@PH0PR18MB4621.namprd18.prod.outlook.com>
References: <PH0PR18MB4621CAC90B0C17D14D787F5DC8529@PH0PR18MB4621.namprd18.prod.outlook.com>
In-Reply-To: <PH0PR18MB4621CAC90B0C17D14D787F5DC8529@PH0PR18MB4621.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 65ad6ac7-41bd-635d-5b26-32251e12e453
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa1cc6e7-0df0-4b5f-b375-08d9d5c2faf3
x-ms-traffictypediagnostic: PH0PR18MB4685:EE_
x-microsoft-antispam-prvs: <PH0PR18MB4685E9DE2A16503F6D797653C8529@PH0PR18MB4685.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sNbbG6GpMr22f6jUGXFKBCZA+/lc5PnGwBBFESiw/ytpletpJ9v5uiKVzbbrmS30p+tER8MEc19jQmjrD6BxFcgaZw44vY24tWzdsL8UuYyRVpINH8lyaAmje3kzC+A0nKODa+mbc3Y3GwWWMWKSMvQXl3DMyAvCGrDieaB9hEziulRt9v/UU+Lt41cYEjh2tUKRjFlppfVDQQ5jkJZvFZlf9Zh109M2HR+bTZh+EEodVXSRlOCuiU4cHoIo5ggnJ2oanWDIm7+wUVuas8dhds/rcDG/04SW5B5FaHOWmb6Vwo4WHnvKxRRlbgXdD91D3xkQAcTxaA5pm/O7R2JClUo4XHe7G4QwM/jvHEaj5+XaKrqQKgX/mjaywRPx1zQexrJvRd/suDYJk6fsOdRmzX9axuPfHrZ1Ojurvyca1gqh/ERlCaU8rof7H21ZEepVVb8bzW6wSg/eZsyr27hhn8mMixob2OJblOMvMr1YrG96+3n3bSJPWkhha57QvMoxiVaKF6yfdG5bl2XsXZCr5uyTegZDCNoeIXUPx4UEoe8y/RU8p4/3bDNWzDG6BODDOIf3D6IFgSppa5PgX/0zqJ92eeJtOFWYJ9GP7tj7/iG4G/i9zaj4tjn24TLx59wcTJtAN/S1H1EaaBnz3qzjw7bygQLc4roSyQ9jl/v0IMDhDO9m5Te0vrNhWopGZBd/ZOlNZxtsODnS/7gdfTypSA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4621.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(38070700005)(91956017)(86362001)(66946007)(76116006)(26005)(71200400001)(8676002)(83380400001)(8936002)(186003)(7696005)(64756008)(55236004)(66446008)(66556008)(6506007)(110136005)(55016003)(33656002)(122000001)(38100700002)(5660300002)(316002)(508600001)(2940100002)(2906002)(4326008)(54906003)(9686003)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?fMTV/89P3gvSn8gzCtOuWCjWmU73lvkzYEDvejfHKwcOwyK9sdv/hQBvkP?=
 =?iso-8859-1?Q?HOA8trxanYwV5ewO5SZ8g1eHcBnvBNd1LLVQIMo44Le7A67avI6cYNtRau?=
 =?iso-8859-1?Q?ImRni3g1pSiLjd7aJkMaXrhyOktleLYW0UbOEvByr1I+vyKAUxulNSo94Q?=
 =?iso-8859-1?Q?sOkoN5lKERrtcLSl9o1SahdeOXoxTG2L9Oo0wzUPm/wHr5/Szsmmy3sBy7?=
 =?iso-8859-1?Q?nITDjI66fndqh/R1sfWYsrSkHMacQOI3yuoo9+nnc76YIdE0VpwIZsIYsR?=
 =?iso-8859-1?Q?Le/S0dAmaJeBYTsx1ciTUef8EwVqKCBJx2qWNGOozLCa7316EXysR3GWWM?=
 =?iso-8859-1?Q?PIoXx4A7NvjRXvnbmWWL32qcEgkKMi0Ogh8q1RLmFngvQpw/J+jm3L+Xez?=
 =?iso-8859-1?Q?YugeFp6BCwob9izb4q7Ocqus2CiBRSz9U9AgY1b5fMp15GIi/BPjlQo8H9?=
 =?iso-8859-1?Q?keF9+GUYnVMNlaaUIApANk3vs30dTfzNADN1PyJ1bCCrva6J51ZIyT47sS?=
 =?iso-8859-1?Q?wGSBlPuv/GAaeBYeK2rJ/x1nmfBnDCQ1gOSle9T2+gco3xJqfTw2sg2ykm?=
 =?iso-8859-1?Q?lC3L363Mg+58DiLswaFMnsJsBfF3GVRo01g4OK5PV0i/wbZ5WVBcVy/bnY?=
 =?iso-8859-1?Q?QktCDFnBOzWpko4OVRkWJDnweG2bmImsajE9aWjNrISW47CArZFBJbL2ma?=
 =?iso-8859-1?Q?WrSGHdYS7TaaTVN4afXen2Y5WHNsAbN1A3psFYQf30jsez0UFL5cGBzZ7o?=
 =?iso-8859-1?Q?UEZPCipl2VnK2RlR+9LeQ391bjaZR/BRy2JjUwM65MusUmCBAMzo7nXrjj?=
 =?iso-8859-1?Q?iR2HEAaKcTqboxgGKGJoit/KS+lMG+fXu19XcXe75sKg+1ljGnaFOgn4s/?=
 =?iso-8859-1?Q?F9RfcFr5oPixBBLoBdCR6XXFvVWy4G08vmqrY1zjMjYzpbVWzp6+zwMAJb?=
 =?iso-8859-1?Q?aBdh6btCunpc8VxpHtiDnFpdlXNFHCnXBoDCg4kRouv94n/6aJrZk+X4zh?=
 =?iso-8859-1?Q?4boJZ3R9f/2s4zbBhNlZdv616NOSBQvcRzbHdCNvgIoq1kKz4q/uqzI7t7?=
 =?iso-8859-1?Q?qzH8INSHzv22logpIYCjocbc0gYAxRpSswsWzHr8f4MKL7NyJG/O00y9Mj?=
 =?iso-8859-1?Q?yn/iTto+jmmQXAwqhBMm8vBDE/ygpXAkMmGJHY+kUbWm/GyhnzmFYUFPyu?=
 =?iso-8859-1?Q?tv7uasz3LfUCtFww/sNFMhYpwf6uA2CAxPiCxtCmbAg2XcJzTdZEplSMkv?=
 =?iso-8859-1?Q?CvKz38qKmRIG/FA6c91uXjXmw0TjJM440pACVouFSeLm0ccjVvBkiiFvXs?=
 =?iso-8859-1?Q?AhImD9T54CV2e7njnUIlrVDb4e4IMAhDOeEN2jkBEv91/W1xDeOBYIjmLe?=
 =?iso-8859-1?Q?yaxpKowPwrtKFNLWqjPo53xBKF2I034GtElRhpeU6EM57znQ66jfZw6UwD?=
 =?iso-8859-1?Q?xQusm/TP2FTHDpA9GdjOpYzxeygpESoSYP2ZBd6l9K2Xhh3EhmfXvkqLhR?=
 =?iso-8859-1?Q?MgjJvzmaGuvMP9voi4Hg7AEdUb2710MpCZHZxiCyXWbRlB2rvqNfnOr9iH?=
 =?iso-8859-1?Q?2wXLN6l7cCqmY4EF1XuQYTSPV/k9shReJz/9ryd5OIJBMGnRHoJcp5ggEc?=
 =?iso-8859-1?Q?JFrDgZ8AN6jUol71omuTEzAeRgdpQZG1NLtaBGd73VN1o6n4UyvGtw0w?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4621.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa1cc6e7-0df0-4b5f-b375-08d9d5c2faf3
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2022 11:59:25.8876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9ZsKZJ2ixse7+1Q7mIE9eMjyscn9/0T3nTUD6w9CAEAOtQra7EOmfO2piTLfT151KjjGAdgB77mmLoNQVC0cHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4685
X-Proofpoint-GUID: W0o28X5IOzEAFo7_5dmwGlxrU6HVI6DI
X-Proofpoint-ORIG-GUID: W0o28X5IOzEAFo7_5dmwGlxrU6HVI6DI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_04,2022-01-11_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,=0A=
=0A=
This contains new CPT ucode binaries.=0A=
=0A=
Please pull or let me know if there are any issues.=0A=
=0A=
Thanks,=0A=
Dhana=0A=
=0A=
The following changes since commit 13dca280f76009ba2c5f25408543a1aaaa062c25=
:=0A=
=0A=
=A0 linux-firmware: update firmware for MT7915 (2022-01-11 06:53:15 -0500)=
=0A=
=0A=
are available in the Git repository at:=0A=
=0A=
=A0 git@github.com:Dhana-Saravanan/linux-firmware.git cpt-ucode-mrvl=0A=
=0A=
for you to fetch changes up to fbbf73f539233b93f57782d07d91815be91d01e8:=0A=
=0A=
=A0 linux-firmware: add marvell CPT firmware images (2022-01-12 16:53:31 +0=
530)=0A=
=0A=
----------------------------------------------------------------=0A=
DhanaSaravanan (1):=0A=
=A0=A0=A0=A0=A0 linux-firmware: add marvell CPT firmware images=0A=
=0A=
=A0WHENCE=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 20 ++++++++++++++++++++=0A=
=A0mrvl/cpt01/ae.out | Bin 0 -> 9376 bytes=0A=
=A0mrvl/cpt01/ie.out | Bin 0 -> 51312 bytes=0A=
=A0mrvl/cpt01/se.out | Bin 0 -> 55600 bytes=0A=
=A0mrvl/cpt02/ae.out | Bin 0 -> 16192 bytes=0A=
=A0mrvl/cpt02/ie.out | Bin 0 -> 52896 bytes=0A=
=A0mrvl/cpt02/se.out | Bin 0 -> 58080 bytes=0A=
=A0mrvl/cpt03/ae.out | Bin 0 -> 10560 bytes=0A=
=A0mrvl/cpt03/ie.out | Bin 0 -> 52560 bytes=0A=
=A0mrvl/cpt03/se.out | Bin 0 -> 56784 bytes=0A=
=A0mrvl/cpt04/ae.out | Bin 0 -> 10592 bytes=0A=
=A0mrvl/cpt04/ie.out | Bin 0 -> 29872 bytes=0A=
=A0mrvl/cpt04/se.out | Bin 0 -> 34768 bytes=0A=
=A013 files changed, 20 insertions(+)=0A=
=A0create mode 100644 mrvl/cpt01/ae.out=0A=
=A0create mode 100644 mrvl/cpt01/ie.out=0A=
=A0create mode 100644 mrvl/cpt01/se.out=0A=
=A0create mode 100644 mrvl/cpt02/ae.out=0A=
=A0create mode 100644 mrvl/cpt02/ie.out=0A=
=A0create mode 100644 mrvl/cpt02/se.out=0A=
=A0create mode 100644 mrvl/cpt03/ae.out=0A=
=A0create mode 100644 mrvl/cpt03/ie.out=0A=
=A0create mode 100644 mrvl/cpt03/se.out=0A=
=A0create mode 100644 mrvl/cpt04/ae.out=0A=
=A0create mode 100644 mrvl/cpt04/ie.out=0A=
=A0create mode 100644 mrvl/cpt04/se.out=
