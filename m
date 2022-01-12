Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E1CC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jan 2022 11:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352954AbiALLnu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jan 2022 06:43:50 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56584 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239294AbiALLnq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jan 2022 06:43:46 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CBDkWV007362;
        Wed, 12 Jan 2022 03:43:34 -0800
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3dhwwy82rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 03:43:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mcrvlDlMXhVtatBbbboM/JnoREMyfYPjOGxxA3/cYWCAkNNwUAYpTdiZ/VTKJLAhp3aT1UaXUCjFxUO9bBJVoxkWKAjMN5IuEJ9IDTkKoow+MZXqqSU7V+JJG6RVtsewlFSiZCiZHTHI0JZrnfETmVk4BiJyMEubBUtf8SIlVFOtZrYTLaMyxXEc9agCmqrUzHowoyn5yvL1cvYg2/d4NyETaN90M+mrIrVXVPwMBnR00mq0YNgJ5MJCejExC1dOMQ/ETatErXllT9rLR6fMyF6jVSpRXAYC3F69R/cqJq4alLqcYLLrt6Pjg0UouWOdAP8aoTl6lL48rpTqRWXhDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EqsxmIachiLP6ZkgjHcocSH19Gb5SAw1EoHwzJbJ1+M=;
 b=UY3uYJC52IeAQcG4ckRTMorv6DQ3IZ27T2M8FH9/kl3vJoeGWYOF5D8rdAj3OC6JMCLz3Z15UHDkMX8nNtvrZFiTITykeVpfgDPKU0jySqzS0MbtPZAe/RMJSWE4Bh6YPHPua2aEYG7myIqc8BfIk27g2s3pXhsA2zP97FfN9tfqc4w8z/cwKjUEFcaMJcRQzgiEOV3/pD6VOx1Iq1COL3IjCYUePO7JOk4G349gY6XOIaRHzgR2OiC8Ir+cCjfCztdjSOqVIBvQz+FUEbRQ1SUS/MSQYKcjnnZGyNuZdES/ZQFCclWvXJykI1XUucwn6AtQNbT4WG4KpxuAHQoXcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EqsxmIachiLP6ZkgjHcocSH19Gb5SAw1EoHwzJbJ1+M=;
 b=SAdv+nsowQDT5FbFYwszSJ3ZMG7nYdjzbSv7q86ewxQLtqEKlDRWKHgqRm7IJzolK0Kt13VMQGbEi3pYUHfL4uiq43KagPau5v1nziJ15Of+fj/evwLVISqMBSc5F/yt5qMtmILoIEL9v7g4AaXIglxcB3gLjFGQigHPKWfvoV0=
Received: from PH0PR18MB4621.namprd18.prod.outlook.com (2603:10b6:510:c1::12)
 by PH0PR18MB4085.namprd18.prod.outlook.com (2603:10b6:510:3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Wed, 12 Jan
 2022 11:43:31 +0000
Received: from PH0PR18MB4621.namprd18.prod.outlook.com
 ([fe80::e401:a9b1:41c:ec5b]) by PH0PR18MB4621.namprd18.prod.outlook.com
 ([fe80::e401:a9b1:41c:ec5b%5]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 11:43:31 +0000
From:   Dhanalakshmi Saravanan <rdhana@marvell.com>
To:     Ben Hutchings <ben@decadent.org.uk>,
        David Woodhouse <dwmw2@infradead.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Shijith Thotton <sthotton@marvell.com>,
        Karnam Raveendra <kraveendra@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Raj Murtinty <rmurtinty@marvell.com>
Subject: pull request: add Marvell CPT ucode binaries
Thread-Topic: pull request: add Marvell CPT ucode binaries
Thread-Index: AQHYB6iiH2Mgda5c4EmOnj6I3TkNQg==
Date:   Wed, 12 Jan 2022 11:43:31 +0000
Message-ID: <PH0PR18MB4621CAC90B0C17D14D787F5DC8529@PH0PR18MB4621.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: ddbb5a0a-2610-72fc-d0ec-6612a5ee6011
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 420bd435-df26-41b5-cc9e-08d9d5c0c204
x-ms-traffictypediagnostic: PH0PR18MB4085:EE_
x-microsoft-antispam-prvs: <PH0PR18MB4085DE9B91922F951A4BEAB3C8529@PH0PR18MB4085.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: elYN9+S1B/JDVw/tcWCu71YNwxp/Uwq6X1B1quKUiMkUCO+bMLBcpgJ2JSzac5sy4c6I/iN9AUjOhPChalh7y1kpLtIZ54IxzipQCUqaZOmo7xk7LdKm79z6O8Sd0tg+OritQgo5EtOaXJSyW+07WO+RxyNxPUiX66CO3K7owYn4fBXtUM8qQ5HWYK0mmXyp/5J2PUKv0jms0JuI1+h50Oz/ZLo5+hOySYmZH/v+MHKVYt/wA4Kxbyojd1Wvk1tzc52lTb3Gg8ngxRBn2CjU3oF346kxvMNPhq8oPtS4uJYbmjFxM434rjSGZgCkz8YDbwue5s+SUR0o7hUGPqIj5k6BNLHH3iJtxnntQo4bZZODeCcUf5c52yj9wbpb422Vs7w/IwQsR2xrWsZRNOUFez8Nl+x0gsGAQAOBLS+nhE2bBxGekgVBwp1I3S2QugM6myth9VHDuwR6SZtEOBoujcpW81p5lXSJmHRqoHStaa1R9cI9UUvtFn/MNhr5yvRwRaQ2LK9/sFwl4omTWB324Y6rzZWcC7nMrbiuKyLd1hwIftvOWt5XbpuplGbIGGf3H6NSaH/KurGEufbTvCoY12ftamjcRWq8XAqU3jQHZZ5eaOseTIa9HMhtQNzoDrhwzjUqaDRoie4P+I5ns3gAxUBWOxEUKAH30RLkqS3p5OEZjxlHYxoky6q4HSlmvzd9vPT7Gv0FN4eXYc/M1ISMWA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4621.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016003)(186003)(107886003)(4326008)(26005)(316002)(83380400001)(86362001)(6506007)(5660300002)(33656002)(38070700005)(55236004)(64756008)(8676002)(91956017)(54906003)(110136005)(7696005)(8936002)(66556008)(66446008)(508600001)(52536014)(66476007)(9686003)(66946007)(122000001)(71200400001)(2906002)(76116006)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?hQ2mqGfryY+gSx67zogKPLpbtMuuSYThvAzOZTn5u+miqh3gxymvSoLVP+?=
 =?iso-8859-1?Q?aIX7VVAVVBm0SZwVkkV7PmBpI5u8l+DML/BQv9QXeMNArouY+wwU7dxonr?=
 =?iso-8859-1?Q?yxob5N4SefcgdgcX3NSlh7wmjS2Lo8v1YbBdHfll8erBmWAcuspF7o6vKT?=
 =?iso-8859-1?Q?g7mhNTkHK4ZW/xZGgMfrm8WTgaqFG3g24jtFH5ZPvSrxwb3/Z7eExxTbC+?=
 =?iso-8859-1?Q?TSZ9DTZKv29IdRkoEL4/AQfpJIoSFgdA8bPM4mZZ5AlX8GuWn9iL31fcMK?=
 =?iso-8859-1?Q?ZNRVT+BW9QhjhhNrtpOpz9ZDNsQodcenfrDBNbyH0JLBOvFgixt5M/qr2o?=
 =?iso-8859-1?Q?xWbaFs8p5MhWM3jyJBdtt6jQGJOgjhjiYleBHpPFYaVrcdkgnedDVcjbGa?=
 =?iso-8859-1?Q?oSaTSQO3KCBU7brBQtWU9QViqppEg6vtdOJY6HLGlN3slVdEdkz5iYM6Mj?=
 =?iso-8859-1?Q?7eDgMXxrDXPeWNz+VYalJ7vAA3K1XXXQ3+Qf4vUbpn1aFxlVxG1oGgzipB?=
 =?iso-8859-1?Q?xxu0km1N6aAGMoyoL0up+guiMDVZFns00GTRl7o6XFq7x0fYX1KmxAWnah?=
 =?iso-8859-1?Q?ZuIggxVWwowxh+arCZs4MsEIk8UnWO1Uh62zkOS/gIVRj6WMpqjwDJGa1x?=
 =?iso-8859-1?Q?vSj5Z/jfjOc6Ky7fBef6/ruJWmUXlkoCE6Kf+8UKAfMuhEYe+f+o/v6HHW?=
 =?iso-8859-1?Q?+2K4r6Uv26dHCL5QLxvvd5cr0Z41pOw6/hCy1b2oEFzxqyLLv6u2qRgVbf?=
 =?iso-8859-1?Q?vkY/iDNz+UvCM5xsKTVeBTD6ak/q1tX9V1tlt26VjX1/jw4qIfMSuNXwDW?=
 =?iso-8859-1?Q?fdSF/tyDPtYSA9vM3/Jc+v3NuK+ECdeTlRNNziym1eKI2LMyNZxcYRMt//?=
 =?iso-8859-1?Q?4vBOq5vU/Xvt9FadqB7SCfkEp2y8rySE3w9LpNcJ/emO6cL94jeb1TFxAQ?=
 =?iso-8859-1?Q?XeZKbRB4xgStIFg01u2Ycg3L75oOl7HHtdGmlK/sc8Ec+G2ARH97ZHPfXf?=
 =?iso-8859-1?Q?eDcmapvZGezKahMuJbJTe6037wvw253DxRMqGbsIxBL5akcWJB+qzWgLmL?=
 =?iso-8859-1?Q?U7wO4D+eedRHpJY7EFyWO+KZmrfDfXpKLMSE5ne6i36p1FjulYJP3Ty/Mk?=
 =?iso-8859-1?Q?Aeks/ueLzml5gqPMH2n0Z8A3NfJWL6E34+4c5oJJjmFB5kkoeGBLOPz/MD?=
 =?iso-8859-1?Q?HK+99zrrcgS5p4LKs3/hce8gi34iQnlRWfFA1BviYB3yRNIMfUe3ejDa2Y?=
 =?iso-8859-1?Q?OmqYPh4KTRn12BGhM8zHZmdOTojYp7ddS9PJZ4VP5JglF0qURazrCS42tk?=
 =?iso-8859-1?Q?V1zPgLxFfowxv3zudKVV0ZIxMbwYDTe6GKx58II363NtoBs8B3Te/md6oh?=
 =?iso-8859-1?Q?FmyV/c1r2kqx6KlxxsLbe1kSvLO0VC22tMasFQqoiK8zPWKFL8L6xO5kRi?=
 =?iso-8859-1?Q?EB3ZZlOiZUbcWfvnmg0UUjX8rlZ86we7JQ9yraEsRlHwJwERuGe9fdmcAg?=
 =?iso-8859-1?Q?Kljqml/kWqykoaqxETjVjd2k/PsXxG3IUcL2HcHn1lW0/CIt9DosMOpgZf?=
 =?iso-8859-1?Q?yJl/lkAlX3B7dSvQVIrTXaBHJF1pUrhaC5vuPpD4jg0Teas/TN69iyGGSM?=
 =?iso-8859-1?Q?7+OmE0qn3lCAPQIBmm2N/tYbgdQh91zACb6uRSceNrnvaXxG/LPsv10Q?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4621.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 420bd435-df26-41b5-cc9e-08d9d5c0c204
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2022 11:43:31.3136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: twD3bVP5orH2B9zJMHkqqwYQdA3LyEwYnoqxEltbaNY9FET8sGiAkgMQnzEdda+X2r2m2GXuQXQ2IdLAnF1z3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4085
X-Proofpoint-GUID: iSH49kvSjqsTBF-pE0kfapjVJPYRS6Ni
X-Proofpoint-ORIG-GUID: iSH49kvSjqsTBF-pE0kfapjVJPYRS6Ni
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
  linux-firmware: update firmware for MT7915 (2022-01-11 06:53:15 -0500)=0A=
=0A=
are available in the Git repository at:=0A=
=0A=
  git@github.com:Dhana-Saravanan/linux-firmware.git cpt-ucode-mrvl=0A=
=0A=
for you to fetch changes up to fbbf73f539233b93f57782d07d91815be91d01e8:=0A=
=0A=
  linux-firmware: add marvell CPT firmware images (2022-01-12 16:53:31 +053=
0)=0A=
=0A=
----------------------------------------------------------------=0A=
DhanaSaravanan (1):=0A=
      linux-firmware: add marvell CPT firmware images=0A=
=0A=
 WHENCE            |  20 ++++++++++++++++++++=0A=
 mrvl/cpt01/ae.out | Bin 0 -> 9376 bytes=0A=
 mrvl/cpt01/ie.out | Bin 0 -> 51312 bytes=0A=
 mrvl/cpt01/se.out | Bin 0 -> 55600 bytes=0A=
 mrvl/cpt02/ae.out | Bin 0 -> 16192 bytes=0A=
 mrvl/cpt02/ie.out | Bin 0 -> 52896 bytes=0A=
 mrvl/cpt02/se.out | Bin 0 -> 58080 bytes=0A=
 mrvl/cpt03/ae.out | Bin 0 -> 10560 bytes=0A=
 mrvl/cpt03/ie.out | Bin 0 -> 52560 bytes=0A=
 mrvl/cpt03/se.out | Bin 0 -> 56784 bytes=0A=
 mrvl/cpt04/ae.out | Bin 0 -> 10592 bytes=0A=
 mrvl/cpt04/ie.out | Bin 0 -> 29872 bytes=0A=
 mrvl/cpt04/se.out | Bin 0 -> 34768 bytes=0A=
 13 files changed, 20 insertions(+)=0A=
 create mode 100644 mrvl/cpt01/ae.out=0A=
 create mode 100644 mrvl/cpt01/ie.out=0A=
 create mode 100644 mrvl/cpt01/se.out=0A=
 create mode 100644 mrvl/cpt02/ae.out=0A=
 create mode 100644 mrvl/cpt02/ie.out=0A=
 create mode 100644 mrvl/cpt02/se.out=0A=
 create mode 100644 mrvl/cpt03/ae.out=0A=
 create mode 100644 mrvl/cpt03/ie.out=0A=
 create mode 100644 mrvl/cpt03/se.out=0A=
 create mode 100644 mrvl/cpt04/ae.out=0A=
 create mode 100644 mrvl/cpt04/ie.out=0A=
 create mode 100644 mrvl/cpt04/se.out=0A=
