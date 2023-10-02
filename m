Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0651DE784A4
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Oct 2023 08:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235803AbjJBII5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Oct 2023 04:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235773AbjJBII5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Oct 2023 04:08:57 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F29BD
        for <linux-crypto@vger.kernel.org>; Mon,  2 Oct 2023 01:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1696234134; x=1727770134;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=seK+jXBG+H42GbZ+ta4qN4sFhnQ3zZGo+apgi6/1+yQ=;
  b=RgDqtwKROaA86KL9vBnFtJNFDYhGeAEuzAypwFKSbl/uQKvZzGrSMIRV
   7uZkYEAaOgf7k+FUlOBopLVpfOUa9V2kkNyXapCXc1cRZDvDZKHuzZK/9
   ZHb/7NxudbE2Bu1tbXLhf5n20h+5dMSBvF2cjQyUDT5e6m8ftkR6J0POi
   ugIZDJ9jspEsx451NeqKaNguM2K6lcbfuq/njG8rc4GHZHunoHsJYly52
   kCWi2VtJWi26bqdDCV3ynTy+LgvzwAX1E2jn7FqA0gPNNx6brcefW68LP
   qAxoxfPbdIRZI46XbwjNYrg4cv1BgWM8NwS/RY25GnuKkUF1CFjDa3D6Y
   g==;
X-CSE-ConnectionGUID: F+bpKlgITZibjSSTuShkNA==
X-CSE-MsgGUID: rkvo9P6RRjS12jueBsPQGg==
X-IronPort-AV: E=Sophos;i="6.03,193,1694707200"; 
   d="scan'208";a="357542375"
Received: from mail-dm6nam12lp2174.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.174])
  by ob1.hgst.iphmx.com with ESMTP; 02 Oct 2023 16:08:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kvT7OK2Kh4Omkw1PqN65g1wseGxC0M8F9hvlaq3aGlj1iYQL/yoSVjngTjMRLlq4Q6FhoRknCPVKfKlDRZS8wCr20cdlvqPjetPPBAWCIKe+iw+JpHqIBBJgMVJ8gM3I1/JaDBl7H6dyp4chu3O7bBVpkLOcINfkx5CDdIB20FJ1STnNCHWHzRj3PEY2VMKjJgHc+hIcoZ6kaUua40EJRVYdMlDNgqRdDM29QK4NkM5h+BIIdjNsGs4DcFjdOpaoY70yV8RsEjpyjJvPfPc09LMBgrNeF9+d7JS9/l41aRVEgnSm6XqAJWcwqvfL2m16TJavhcQNULsy44VmGJHCCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=96Dn/KqWaovDNU4C2jeBDJw7TS+CTXIXyPIJgGt/ECM=;
 b=D28ydfXjZW6jCIrmC4fpqUwdn24QIcaKr92BfiE0fChHKCC1uRt7hcj4TcdaJNLm6iNpvkppa1NF6+8QYRqQ6e2F+Km4kdjgOIiUCxFvBhEXUn5N2nQjsdYpPos7jvDo0nMGQaDOp2HdshH+CmeYK4DbOcbnABIqbwgi9zackDnz4HljgloA5JNYuj6eDN5MSH6DGPWgsmIvcXa6eyeko9S6qt/wT5JcLy+U84BAKNc0hTQGFPP7tGm9JujkZZXmUdLxoQFL+0GyankiqH+cFp5CY8AY9MVHiI5v2RRBY5crEuRI74TVBXtud9brGjpu9ChFg3Bfx4HJ3GTLVI2f/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=96Dn/KqWaovDNU4C2jeBDJw7TS+CTXIXyPIJgGt/ECM=;
 b=tEWcq3AkblZuRTvF2R8SdbRHqmjqazDG+zP+DwXNG7xCC3bULJBGoVYi7wJbxAffycDB0L+Fw5zRD+4Jd1tD89FggbSu37ZDvAfZtEmkGlP+ZAZbYXVLvzkdZY61Hxhee6CSmUmkqY97kHCRMH6hrl4ANoR0svhEsdE0nUkHHbk=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CYYPR04MB8790.namprd04.prod.outlook.com (2603:10b6:930:c0::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.25; Mon, 2 Oct 2023 08:08:23 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::2256:4ad2:cd2b:dc9e]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::2256:4ad2:cd2b:dc9e%3]) with mapi id 15.20.6838.016; Mon, 2 Oct 2023
 08:08:23 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [bug report] dm-crypt setup failure with next-20230929 kernel
Thread-Topic: [bug report] dm-crypt setup failure with next-20230929 kernel
Thread-Index: AQHZ9QedZs2zex8je02tGiGJaFS5rw==
Date:   Mon, 2 Oct 2023 08:08:23 +0000
Message-ID: <4u6ffcrzr5xg6tzoczkfnuqy7v2e3w6243oxdsu3g4uughh6go@6owks5linnxi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|CYYPR04MB8790:EE_
x-ms-office365-filtering-correlation-id: 35ce2a7f-e616-480d-410f-08dbc31ebfcc
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: guKNu6ecK3+tqOinjz2eJbRKXeLas9l2u39SrILwYwthORBWpHAqZaN0OCvldVRGtovnhi/ySDMfBzHSsNwMPbXZiMXnAncAc3vk4hT3Djid8IPawXjQEybG3gUxSgmh10ctcghtfwwznhUNns2Wrjw9KfoyKzRvVKdcJuDFkFWAA5uZG9nEWIrhRtN7kA8v32orwEYs06BT5c0TAtHtF5uz9x15QplKKLQgVE96WUYVvx/jfeX3KE4xjqFy+RrupqSTK4ljD+Rc4Wo41OfuGIM6fQrJkRi9ylVjlJ8av0pGmeT5Ub5PrJfMCVDfeUMDk0h9biB3jvw5/XbYP10qc12RtJf5JBITYy4lsmEAEdW1gWcDuXkULQYGZhKAIfP1sFi1q8pLAw5mB9XbejGLnmrBZ1C6gfXgNw9UJpFEwgO7HEgOJLuhV9xlMW+yN17jWJuo4qHApCUB9A5v+Jmm8nOJhO6JSFTUEgt9RBeUhRxdutZzoJowrujS8ytBywus4ss8mQaw84FbMPOJ6ao/60Y+XIoz9VqyC5WyUarkfNLnpdAv1r7/88hS9GhLsBYPs+D0BIEmAPnmURX/ePX/m6wVV5ft/pyBGSsfnFMyNyWUQ0knxc5fQ2d5BNVjv1Rt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(376002)(366004)(396003)(136003)(346002)(39860400002)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(83380400001)(26005)(66556008)(86362001)(38070700005)(38100700002)(76116006)(122000001)(66476007)(66446008)(91956017)(82960400001)(64756008)(6916009)(316002)(54906003)(41300700001)(66946007)(5660300002)(33716001)(8936002)(44832011)(4326008)(8676002)(2906002)(9686003)(6506007)(478600001)(6486002)(6512007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nh+f3HWSxUVYPEkXe9RKRp0M/AneFZ+pmHC6nCctPuo3MlelrE0odudzqoHp?=
 =?us-ascii?Q?TCxIFfu1hOLNxbCNnSBi9bpHN2J16Mji7UTAz9RDP/zQ0PelFAQMkK0drckW?=
 =?us-ascii?Q?BVTQx61yrhC62cEzVHfvQCvI4G29RW1J3j1xVBMwLHdj3kRKULk5gOfZF2DO?=
 =?us-ascii?Q?Te9LR09t05FFlRZ41v8OnglWF6cvvfo/LalCHq+CgVjxicjwGCQfk4g8aBFm?=
 =?us-ascii?Q?nQKs/2/BXHTtG1Fve89BcbQTVj4SzsgHQZkLLX5P21cIq1EvXvTDDVA91SkA?=
 =?us-ascii?Q?h4JDPs0hHvEpV6O1e0wRis+YLIoiysPhof88kFFKpJqNl0jVmTWiayKH6jui?=
 =?us-ascii?Q?hNHRLHizOWHtlV9OVAijtr3W9S1HuF9bStaPaJcpCs3omJ7iVaG1Ktuxtx0x?=
 =?us-ascii?Q?phxPSXBYypXZkSPM/baH3thWqRycnt8/87FAt52axCYxe4gjQNdPPjsxrilA?=
 =?us-ascii?Q?Pu5fBK9ea7Gp9MyCkGH40uq9ytti3D4FYqYQ08v1bbgwklPpGVufagTqWpnw?=
 =?us-ascii?Q?qoUKlmu0VYvwo0/UxAH/3X2+1nWvzPZ757gXBX4MFQ2njhIJr/mpJCHAGX2p?=
 =?us-ascii?Q?Tit7bltZcdPwRfcpYanW2gkx62fCfGxwaRWzYOSFMQ/feUOfuGAEBGYGAocq?=
 =?us-ascii?Q?W3T9ypNJ8nlEpxRBh5Y+wYQcAwVg+oKC1igsaXJ00GNlFRQKvmQw4FwntgY8?=
 =?us-ascii?Q?6RHarP9znuWIksJfBipPc9vCfFXI0aXHumAdjjsIUqsshBUI6foYXtOcT4Hq?=
 =?us-ascii?Q?4RWoNbj8zQL5xKQcvJXkJMcyAFkRKCVFg8Cp12HsYQyz/ntTrMwwHOi8aWf1?=
 =?us-ascii?Q?pglOTUchDQcG+0RR5L9ABePvzC58aAYBtP1TqhsG5QGNNHOSbhEY6d7AjprK?=
 =?us-ascii?Q?FIrb4QKRpbj5GAStgiPYnfoL2lb6Zv0UJMmWFIl8b9LXZZ59sJ/8tFEa5sMv?=
 =?us-ascii?Q?YTapDdsFWJFwMVL93H4gfCFaUl52XctGzRQk2qQFJBXuVM139GNVmt6IZ2Pk?=
 =?us-ascii?Q?GFVC7C9HZXojTKHyKfpY/urYIOmp3WNQSaj7UUwmU2429nWf0flSWlCZEBtX?=
 =?us-ascii?Q?44TIu8vrXuErSHs5RZv6YAafPraRn5QS/ELW+5sXXR89NDWf+9HJ5qvOhUiV?=
 =?us-ascii?Q?ElwA7KCVRXyO2WlCYuZ7WufKEtnUCds0GU3Wm2OPZzoGJZIWWu2cipzUsa1p?=
 =?us-ascii?Q?owNrMGhgDJPGefyL3vVpp5G9omMkKXYmUJOjuH6/auUmnRNPvQaW7xDA6wBy?=
 =?us-ascii?Q?F0TNHuH2DsAUg9fgDFu2/jcdA+WVnEdNSbkUZBzRhOWIy6DEV2g4f+b7+tjx?=
 =?us-ascii?Q?ezkUoTp43riV808XDjeXmoqK2BPzoxRdfWZqhGlWkFfsHGeABa3FKuAyE+RB?=
 =?us-ascii?Q?N8V+IKgN2YObXXaTGyx+Zl0FcGJah4MKb/OW9PZAJbEmehlEM10Zu/rN+H/3?=
 =?us-ascii?Q?41jntC+WMf6strHHBsBISUm3L5SfHtXtZomVnL0QwYpgB+hp5qyq8LaRmBdj?=
 =?us-ascii?Q?bBmhWS6lumgX9yyCW7yDAeSCrD6cOxLmtwYvqYs5iVNLASCHgByyRiUM71sJ?=
 =?us-ascii?Q?xWDgu+8q1/EVpORmABbcAYH6K+FUGjSlSb2CRwa1O0JPLAd1hgcVQJ5e7FaA?=
 =?us-ascii?Q?0620++glY1vQSe74S6wAr2Q=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5F892623868AAF48A4445EB676955CFD@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +FJAoHKtiSb834WESd4PlbNDn+YIkYESf5D6GnB9APP4qeCd0opAK51ZRMzB0s0g/d7zeINIjGd8nD/zprcNUs445SlhDE1fV1IYle6xn+qTqo1P8LeiZfar+YlEK5YEbhxZ9wnjyVyM7u8iGhY1pcU+FtTUTxYBwSB0QUobIympZcAmM5dMArSaTc5zAVg7VDZnQHWu3qjPIAsLJKy6zCKgmGFb5tsQZKxH4/DrCX0PHffrAagcX5SA+CJw1ef3UtjaRdItBNyXqbEqKFdy5BRrQ7yYIh4AGJO1fBZosgiux3va/L7nvDb2B1juRQ+hCnEwgkKi6z5BQIk/eU1mqWMf7KNm7lfv9+Hsfko9datszy8tyAi5RMCp4KYe3iHYxjyUfkJZagvoCR7dbbdGich2IIpuzN4aNVyDhZX6Id5HAySH/NwTgiaY0tFlslYB/KXiI0cbn+tzuFpWgYdZ4QzEUmQE7ZgbvpK2iDCFzpsDTc1V1YysmehsGVxV3N/k6/O4XAkH/k5PtgOvQEp2Y49ev3Pz/FoVGBVCQ9vT3zVoJ//3ZVHlrKtn9EbWKQh1neTMprnCKgRylWcmH+otewyMIFfqPN9xRavdQUVhaPzNZ8P2EuoDzDdzEUjVjMu8YWKxvMfqWUjj8S8f+xzzqEtjAvLt3PJZsLKLmsC5WQgt3eAgRKBj0PGAqxq7bWySZseWA6pezFju14IpKSc3Lz6QG6272kFNTC3I2XeOSgV/dfUBWKgOhnIusF+8ieCxHlysSvVjQESzzG+a3DTrrYqpVGYrHLKw8sKrcENDMnySHBP8zeUg0nCVKh1pDxq3X/X0vufkvHPn378e4j/uHYVmJaIilKgQkIsjCq8/Euw=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35ce2a7f-e616-480d-410f-08dbc31ebfcc
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2023 08:08:23.7298
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FdVEWIpYOJq6Nz+x6yecFZcYGdd99ZxpGVMKfY91L6K10oBNf/m5VYgEUx8cMu1FsXRs9JpDyQQpJ6dEvYl1Ssm6vSdRTWfC1oBbDk6gNTA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB8790
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello there,

I ran the command below on top of linux-next kernel with the tag next-20230=
929,
and observed dm-crypt setup failed.

  $ sudo cryptsetup open --type=3Dplain --key-file=3D/dev/zero /dev/nullb0 =
test
  device-mapper: reload ioctl on test (253:0) failed: No such file or direc=
tory

Kernel reported an error related to crypto.

  device-mapper: table: 253:0: crypt: Error allocating crypto tfm (-ENOENT)
  device-mapper: ioctl: error adding target to table

The failure was observed with null_blk and SATA HDD. It looks independent o=
f
block device type.

I bisected and found that the commit 31865c4c4db2 ("crypto: skcipher - Add
lskcipher") is the trigger. I reverted the commit from next-20230929 togeth=
er
with other four dependent commits below, and observed the failure disappear=
s.

  705b52fef3c7 ("crypto: cbc - Convert from skcipher to lskcipher")
  32a8dc4afcfb ("crypto: ecb - Convert from skcipher to lskcipher")
  3dfe8786b11a ("crypto: testmgr - Add support for lskcipher algorithms")
  8aee5d4ebd11 ("crypto: lskcipher - Add compatibility wrapper around ECB")

Is this a known issue?=
