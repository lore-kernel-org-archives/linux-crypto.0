Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C63CBC433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Oct 2021 21:20:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D0FC60FE3
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Oct 2021 21:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbhJHVWS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Oct 2021 17:22:18 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:22652 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231714AbhJHVWR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Oct 2021 17:22:17 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 198K1cak023220;
        Fri, 8 Oct 2021 21:19:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=BEF/MWEDXnVsmN7wQe9jEhLITlG9NzBXrDLaHA4vMJ0=;
 b=shbKc7YMF2H1Tn20lT9g2UaBdfcXUvoRJF5fmDMWt3+7V5XPGT0SDz0/jm6v7V/c6N2L
 vAq4lCbpxhodM0+2xAQkbnwR8VTQ8n/eUTfNthAQTI2WsNqB91BJ0ReKXHWPQpbWZ52z
 UKeZ/iNiE/BGPgxbTe4R98U9RAoVuii9mzz6zGGhVOwVFV08Vw2rBx2NLJKYugYiYIfX
 PTqs/6zVGWDmcRWi4pYbgJMFa4KDRTPLKh/Khf2KmRFggmXg1z5SfMaKEeG+SzBzsEa/
 RI0/f5sWYhi9SQO9yTOyPx8EQQEcdxH4uManMySPMjshuLMj8D2OrPq0XsH+Cx/g6TLL 3Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bj02jt3uf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Oct 2021 21:19:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 198LEpZM021089;
        Fri, 8 Oct 2021 21:19:30 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by userp3030.oracle.com with ESMTP id 3bf0sccjxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Oct 2021 21:19:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FwRzhQFFkVW3+MMYDYlslzJc55cxeGua6Yd7r//3NBHJzDxgHQOAFrQq9YgfWtnH5Jut2qSc9U+ISk4fabYElst5ZuiNGVDTdZIHKfp0LQiiUeFtnO+bfq589Akb7Egp8zT9vxKqlapLJu9aXFiGoquWooDC0fUVmaT3KZHdBqnBz/ttGloM3Jb5/9F53iQCPTAlyDXNF/LXq293Nkx+0yoQwJ436iqO5AnwULZqbasF91fC7fwNtOF6iVxNqnoo2SHpmfb8J/oZGAuNZ1jjYLiKrZTfDjJFQbqIFqbN7zO1nD60EYVeazSk3KfpgOSBTdlKsTYgdubn4tXy7ixUog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BEF/MWEDXnVsmN7wQe9jEhLITlG9NzBXrDLaHA4vMJ0=;
 b=aeWZC+l1LqEfzNNt+Fn/ByraRKif66hn2+zfFmTDcek/1UN9vJ41weJLirbpykLXrUVwmVipBGaSBKEv4HShe7BXyy4WfAEg4Z0ce0421KhSnPoUFkHVCRXs0rHU+3bgTIScxnGyEQie3v+aLX/cGW/AFyvvuBpPVxWpxcaNRJz8KPPJOeP26B9Yfwup0y+C984iw0vZi1CCchvoERJEcbYvEnfBccIvgYL99TyeTD4FvkQ1wDcqV6PIfr9EDqTvwUXB9kX4LQOBr9wfsuMyUugF1HpAOhX67xt676wbej5fihlYPG/+vhnSwCGIVDft/WjD6Ym6FyCctl0qrDyMTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BEF/MWEDXnVsmN7wQe9jEhLITlG9NzBXrDLaHA4vMJ0=;
 b=spltDiOuTBiROsgN+Q0OeS9AV4QzjoZI+QiMglf3VQwIkWFahh6/ZiVBYF0Tefp39gwkMnvYXFe+mwHX4CDFet/C7NLqELWqjSu8RfeRaFHi4Zr4as6XjU7CFrZnp1hl4cfvogmj+w0c2vJgD9ItXHppCvG3QwdPxiZ7zALYrCY=
Received: from BYAPR10MB2934.namprd10.prod.outlook.com (2603:10b6:a03:85::22)
 by BY5PR10MB4227.namprd10.prod.outlook.com (2603:10b6:a03:208::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Fri, 8 Oct
 2021 21:19:26 +0000
Received: from BYAPR10MB2934.namprd10.prod.outlook.com
 ([fe80::a835:7e9d:bf65:47d7]) by BYAPR10MB2934.namprd10.prod.outlook.com
 ([fe80::a835:7e9d:bf65:47d7%5]) with mapi id 15.20.4566.022; Fri, 8 Oct 2021
 21:19:26 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
CC:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCHv4 00/12] nvme: In-band authentication support
Thread-Topic: [PATCHv4 00/12] nvme: In-band authentication support
Thread-Index: AQHXtDDZUZp7yys7CkyPJWrzxHmg3qvJq/YA
Date:   Fri, 8 Oct 2021 21:19:26 +0000
Message-ID: <B62ECFDC-82DB-4C00-BF2E-016AA0D731A7@oracle.com>
References: <20210928060356.27338-1-hare@suse.de>
In-Reply-To: <20210928060356.27338-1-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b28201d6-4f0f-45ce-2d12-08d98aa14ef4
x-ms-traffictypediagnostic: BY5PR10MB4227:
x-microsoft-antispam-prvs: <BY5PR10MB4227E417A56B9242B9DA07C6E6B29@BY5PR10MB4227.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IS1JecKiPbcZy9sHH870wIhL+mpImvkqLsjOLM7nj9P7HfvAz1Vz9+BiRii5oVmifISXdpqdKR0zg84xIwSbWW3FX/3vPtQg4gZtHr895Tg+NwFoLZ/BNWpWWfRiTgO0dcncAvGC6ECg7HH6m1X8bO5dqFZqSK+GfVZdu37X+jbqQ+KWRRzD7MvDeqP6m6aIFyA6v2VOMTLOUXjNfAFz9XRVku8d1GDBrBCXqSpK6DpFMXke15HXI9Szni0PWblG8xFmiHhoNU21T2cTuorekz4t3kAyDLPYpLqaTBk2wdF6HDnUZ9thNr7cKchZa270r96wG0c5LyQ4Fk9DQ1lOJv8OBnZSsyiVRsLWRjuvQTvTNpvps0dt3B0tXL13CHoic+Lt45RenygAAkB1ZNp9Rxaeq8Wxr4oxZwI/fJPuiTT+Q5zraYS7nxdaVw2cet557QQDpBnbygJtpI1wWY0jsnuGPBqe0GjXHDukVJpjvB1fbUu7tUl/niUO9/SLly9WfzprX/yhuzmKVtKMclnhjJ94CPFKTwo2Z0LwtsPEdWqvgx9bBo/ZRrNbYRSSSAOnW3uwfCGc5AkdDmmfbgmTFESG8WuuAjYwVWzo0v4C/1OaZGaX0o7AQa4lkGi3oJUSNe0oxeEJukShug67FQ/wH/0veJNPY/QDm5Zns5qd5SgJ/1ExvAnglyJYBucY6Kxsia08MLwOXFKRv2DaWLFxkxmETApQDUKDblk1iHvbCD9Gtieilt0QmvpAtgh9w7UakETMsU2OhDF8Y0XAzd/8/E84Foq+LH+osCzp9xgTSWgq1tG1QRoXeSZN7JKR3xjK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2934.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(86362001)(4326008)(8676002)(76116006)(91956017)(83380400001)(54906003)(36756003)(8936002)(6506007)(53546011)(33656002)(38100700002)(6486002)(5660300002)(38070700005)(2906002)(66946007)(122000001)(44832011)(26005)(6916009)(2616005)(186003)(66446008)(508600001)(316002)(64756008)(66556008)(966005)(71200400001)(66476007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?r/WrsyoO0v1GFqT5gBHdcAZ0NoCzhSSKUcnX94LOCwArin2KrOkMDG1uYtVb?=
 =?us-ascii?Q?eQ8Amc6CGDmiuoEKvH4jSb51PSRpF2sFGHP9aDQn6P0kf3+vD+03uZAlZ037?=
 =?us-ascii?Q?ZUOaPJwle0eaMtAuMsCZDr17Mhv5CGxoOqAwtUcWIkKvB5lsE/i57K79laMk?=
 =?us-ascii?Q?CnyQSDpVSJM9caOJeH+QH46CroFBJ0Yz2WcJisrmahSUFb30WpQUknUz2MvX?=
 =?us-ascii?Q?jAt32mEX2ETPowG1GW62/putThQ2GiG9JFF2PCgjsQ5DA6ar/YTUmJFR+fVo?=
 =?us-ascii?Q?6Ngd7f1VXNsy2XjU9S5m48zegRH4QF6l9kgxxSRysUbLNu4JhD8alydqtU24?=
 =?us-ascii?Q?3NoSSu71vg1b5RLSozUtan6h3Smu1gNNQtW/qaqj8+vdwoZ7Ahjv/vkiGHds?=
 =?us-ascii?Q?0iWu/lmJKaSxmVMngUknlLNHF1e/7HAVieHhGNr1n28Ve9KZrNxs3QA2euo9?=
 =?us-ascii?Q?G+2bqgYe5rXxjzy6PZBsrVThzTajvIzKvFVRCEnwyVfCFtZqrNffF09RnkMf?=
 =?us-ascii?Q?wjwKj3iexvmII73HNptpgGA9blkzE0r9rHWbEuPXgR+Ab+mqbtbJDx75mdVA?=
 =?us-ascii?Q?/yDF0u+BGYr32RbpvX4e7AYVY7juzkNzSHL9XDl9R7FmLg3NiMQDGR36JGdH?=
 =?us-ascii?Q?Iz9yf4FPiLQycHqQcC+tTR6FubizpBA4EN4dBtuDRqNGrrLw/u6QXTrf9pL4?=
 =?us-ascii?Q?DzgSRJQST9PC+XvQq1iV3ZmtPu29orDdeqdfLhLSsAt9AgAnGTw67eHXF+M7?=
 =?us-ascii?Q?gt4jPJo0dT7WziUlHvL/3LRkri2zYbvkYNl+OBOMPawPBkWPDwxq1SIwtYsj?=
 =?us-ascii?Q?aWvGSMAMtnNQ8kVigaUz0lUFXtGqPOxzESLrLryWoTVzC4mu+nHzuLFtDcF7?=
 =?us-ascii?Q?WczRpxwelKJRT5C/MVWzu8pUP5IotDqB5+0/0S5tyoW1xOzhmrZumz5W3a5x?=
 =?us-ascii?Q?IzwKjcqLjiN8Y3EeFsyAkURy9xq5OEdyyPyeynckoHMkXc2+vmzq6zS4DNgT?=
 =?us-ascii?Q?b/J+JRzvgydZef6NlkMRMQeE/8cE+hCZ4o3zsBmBhI+ibr0iD9B263VevY61?=
 =?us-ascii?Q?Zeb102NG+6gto5wS+k5z9a7y5Fi8F9wgR1VBOyQ0x5jgD63RmHzri70bjNcZ?=
 =?us-ascii?Q?9hTSAdvGI5A86gCxwkZWXDHC7oGLIIP+8WpUFQ7yXefKvY9QPx7Ofbv/h+tJ?=
 =?us-ascii?Q?G9AI7LueagKG8MkU9ZIHpbhFvjw29nCz6HbxVSlFdSGbgYsWabKcfVqfuUXt?=
 =?us-ascii?Q?KGNnLAWNVDvBSaXEFpnI3GfmRFpylGk5AaH/eUuP8vqy+iq1TYnvKb9nYZ6M?=
 =?us-ascii?Q?gNPlSf7LHcSd25HaP+AYsdVCAzx77XoIzGe8Sy6bwxDa4w=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4A3926989B65FA499A1411CA0EE98F74@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2934.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b28201d6-4f0f-45ce-2d12-08d98aa14ef4
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2021 21:19:26.7619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ugbt0OngVwVhYIXs9t3+pj5mUM0s0G4GJEiXbqbOwAXFu0Oc0rnhJHAIN2pOsF/mhtAH+oajp5x0/3rIUQJeGFV4C8enbATxqhlAOogbFDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4227
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10131 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110080116
X-Proofpoint-ORIG-GUID: sFoxXElpJrFoTL9m0Dd9rMd1DScxnxhf
X-Proofpoint-GUID: sFoxXElpJrFoTL9m0Dd9rMd1DScxnxhf
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> On Sep 28, 2021, at 1:03 AM, Hannes Reinecke <hare@suse.de> wrote:
>=20
> Hi all,
>=20
> recent updates to the NVMe spec have added definitions for in-band
> authentication, and seeing that it provides some real benefit
> especially for NVMe-TCP here's an attempt to implement it.
>=20
> Tricky bit here is that the specification orients itself on TLS 1.3,
> but supports only the FFDHE groups. Which of course the kernel doesn't
> support. I've been able to come up with a patch for this, but as this
> is my first attempt to fix anything in the crypto area I would invite
> people more familiar with these matters to have a look.
>=20
> Also note that this is just for in-band authentication. Secure
> concatenation (ie starting TLS with the negotiated parameters) is not
> implemented; one would need to update the kernel TLS implementation
> for this, which at this time is beyond scope.
>=20
> As usual, comments and reviews are welcome.
>=20
> Changes to v3:
> - Renamed parameter to 'dhchap_ctrl_key'
> - Fixed bi-directional authentication
> - Included reviews from Sagi
> - Fixed base64 algorithm for transport encoding
>=20
> Changes to v2:
> - Dropped non-standard algorithms
> - Reworked base64 based on fs/crypto/fname.c
> - Fixup crash with no keys
>=20
> Changes to the original submission:
> - Included reviews from Vladislav
> - Included reviews from Sagi
> - Implemented re-authentication support
> - Fixed up key handling
>=20
> Hannes Reinecke (12):
>  crypto: add crypto_has_shash()
>  crypto: add crypto_has_kpp()
>  crypto/ffdhe: Finite Field DH Ephemeral Parameters
>  lib/base64: RFC4648-compliant base64 encoding
>  nvme: add definitions for NVMe In-Band authentication
>  nvme-fabrics: decode 'authentication required' connect error
>  nvme: Implement In-Band authentication
>  nvme-auth: Diffie-Hellman key exchange support
>  nvmet: Parse fabrics commands on all queues
>  nvmet: Implement basic In-Band Authentication
>  nvmet-auth: Diffie-Hellman key exchange support
>  nvmet-auth: expire authentication sessions
>=20
> crypto/Kconfig                         |    8 +
> crypto/Makefile                        |    1 +
> crypto/ffdhe_helper.c                  |  880 ++++++++++++++
> crypto/kpp.c                           |    6 +
> crypto/shash.c                         |    6 +
> drivers/nvme/host/Kconfig              |   12 +
> drivers/nvme/host/Makefile             |    1 +
> drivers/nvme/host/auth.c               | 1501 ++++++++++++++++++++++++
> drivers/nvme/host/auth.h               |   33 +
> drivers/nvme/host/core.c               |  126 +-
> drivers/nvme/host/fabrics.c            |   85 +-
> drivers/nvme/host/fabrics.h            |    7 +
> drivers/nvme/host/nvme.h               |   33 +
> drivers/nvme/host/trace.c              |   32 +
> drivers/nvme/target/Kconfig            |   12 +
> drivers/nvme/target/Makefile           |    1 +
> drivers/nvme/target/admin-cmd.c        |    4 +
> drivers/nvme/target/auth.c             |  486 ++++++++
> drivers/nvme/target/configfs.c         |  133 ++-
> drivers/nvme/target/core.c             |   10 +
> drivers/nvme/target/fabrics-cmd-auth.c |  507 ++++++++
> drivers/nvme/target/fabrics-cmd.c      |   30 +-
> drivers/nvme/target/nvmet.h            |   74 ++
> include/crypto/ffdhe.h                 |   24 +
> include/crypto/hash.h                  |    2 +
> include/crypto/kpp.h                   |    2 +
> include/linux/base64.h                 |   16 +
> include/linux/nvme.h                   |  186 ++-
> lib/Makefile                           |    2 +-
> lib/base64.c                           |  100 ++
> 30 files changed, 4309 insertions(+), 11 deletions(-)
> create mode 100644 crypto/ffdhe_helper.c
> create mode 100644 drivers/nvme/host/auth.c
> create mode 100644 drivers/nvme/host/auth.h
> create mode 100644 drivers/nvme/target/auth.c
> create mode 100644 drivers/nvme/target/fabrics-cmd-auth.c
> create mode 100644 include/crypto/ffdhe.h
> create mode 100644 include/linux/base64.h
> create mode 100644 lib/base64.c
>=20
> --=20
> 2.29.2
>=20
>=20
> _______________________________________________
> Linux-nvme mailing list
> Linux-nvme@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-nvme

I reviewed patches 1-7 using b4 to apply on my local tree, because I am not=
 able to locate them in my mailbox and lack of versioning on each patch mak=
es it hard to figure out which one belong to which revision.

Please add for v4 patches 1 - 7

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

