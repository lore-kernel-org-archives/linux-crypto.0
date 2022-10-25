Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72102C38A2D
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Oct 2022 21:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiJYVQv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Oct 2022 17:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbiJYVQu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Oct 2022 17:16:50 -0400
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DC5108DFE
        for <linux-crypto@vger.kernel.org>; Tue, 25 Oct 2022 14:16:49 -0700 (PDT)
Received: from pps.filterd (m0148664.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PL8naO012636;
        Tue, 25 Oct 2022 21:16:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=w/I9KryuScusvUzvtK5NH/JYbi5+QeFwiw+MphH6xos=;
 b=DA66ovhG3XYDIfXYwgnUhUGOmMOknc10Q6Rp6swFR2z/G9tnF88ULSh4yMo088UcZ+DZ
 ZFMqlmgVn0iW+qwxiEf1NAKC2hWso5+iZpzQ1N/AbNwS2nRXZ+yqYOR+eD5O2hA6AGr+
 Hov8+5T0aCKzqDL1/3wBujldsGBtxH1MD4jE1Ntlek4m2RbTgOjbpJW0DAUFcmAaZoKI
 2paRyzgmrQG9I+Cg9j3uD4ER1G/efQK9/Lx/YWPS69kDkVmmZlzdRe27/F17Kx5g0R4m
 THjzZ0gQLKKH6jpBQ5gnKY9nt0TDBKvC2ZPD9fyEU3TNKNAMdzfqEotz4S/QGWQCRgem 2Q== 
Received: from p1lg14880.it.hpe.com (p1lg14880.it.hpe.com [16.230.97.201])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3keqeu01d4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 21:16:39 +0000
Received: from p1wg14923.americas.hpqcorp.net (unknown [10.119.18.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14880.it.hpe.com (Postfix) with ESMTPS id 63EAC8040C1;
        Tue, 25 Oct 2022 21:16:37 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Tue, 25 Oct 2022 09:15:53 -1200
Received: from p1wg14923.americas.hpqcorp.net (10.119.18.111) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Tue, 25 Oct 2022 09:15:52 -1200
Received: from p1wg14920.americas.hpqcorp.net (16.230.19.123) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Tue, 25 Oct 2022 09:15:52 -1200
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Tue, 25 Oct 2022 09:15:52 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBYPmlMik+MRUMmlBr0ByV2AHiTcsSXz+4+2IiVyzLG5Mi+IRDPvGMQPFn4tycsslxOqCNs0GNDRhpjAy9N0jmiLX2KTzDypRyoY0Zp4b3CBVXZl4wfp+wKmEPKxjnTc8oSn3Ia1AptxjBjlF23lA0ndsmxj5/uNTLO3dqNcVcblLuPMrLg5Cw5Ah1wOab3ggS8aquef0558IIG2kE0IrnY9P45qfUHCRNDUIJBCgWZWr1QcsBauLkkXr6T8Ela9hRvw0LFHLqlpYEkFvq40XwLnd/46hTfpXFZjlF3KsrwZ1UJx8I7/UyKswaSX14kXTqtaXOXJiE1B5XLKpavHeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w/I9KryuScusvUzvtK5NH/JYbi5+QeFwiw+MphH6xos=;
 b=CG2XNVjA8Y6qq+U2Gw+DOvxvTeJLeKblMcl4X8OYGiWsXjgoMYfCw7eeGjvqFSfnbAqu5dap+hNA4P7/XcLNlUnaRLXn8+OsYGX+Tn1R7x2FGl6kwGrjGcukVMIBarbtG16P/3M9YnMYPrHldVPWYEuKUbtOlvoSAJXXviRqY+c1DtUfwJ2w5cn6MOJbK1dqyeCI4snKpa7lbWOcyVmJNkrd4Ndp33SkoXy71JZIX9xzcB++pBasg6Vpa0OPKb5ucgvYjOyIJXrZZlZQ8Tp3DvQKguRNe+FG5TfFD+q1FHVaLffBQMV90QD6n3uSesH9lymvc0OKyiqUm65Nmx3DNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by PH7PR84MB1768.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:156::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 21:15:50 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c023:cb9a:111f:a1b2]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c023:cb9a:111f:a1b2%6]) with mapi id 15.20.5746.021; Tue, 25 Oct 2022
 21:15:50 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     kernel test robot <oliver.sang@intel.com>,
        "me@tobin.cc" <me@tobin.cc>
CC:     "lkp@lists.01.org" <lkp@lists.01.org>,
        "lkp@intel.com" <lkp@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [crypto]  aa031b8f70:
 leaking-addresses.proc..rodata.cst32.PSHUFFLE_BYTE_FLIP_MASK.
Thread-Topic: [crypto]  aa031b8f70:
 leaking-addresses.proc..rodata.cst32.PSHUFFLE_BYTE_FLIP_MASK.
Thread-Index: AQHYt5PvLy2B12HVbEe8YaLlmRqPyK4f4Zug
Date:   Tue, 25 Oct 2022 21:15:50 +0000
Message-ID: <MW5PR84MB1842289055550CE30913D2CEAB319@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <YwXfnidzkebRDty0@xsang-OptiPlex-9020>
In-Reply-To: <YwXfnidzkebRDty0@xsang-OptiPlex-9020>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1842:EE_|PH7PR84MB1768:EE_
x-ms-office365-filtering-correlation-id: cd1f9b94-cecd-45b7-ae1e-08dab6ce17a6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6gBBtg8haQ+bRyTOoHYY/KJGc+bfEU4Tev6yTJqCJdl2JRF26ZpfPYPCT2AGirAEMm0Jp+LQsI3DQ4Tp/JzErrOOUA/txIYU9NIRxpXeVrDHmdkKYE4STfhWtp+Bw1aQjnzTiw0pY+W9eXJhGZXtFHHNNiz8jPqtvfmOXaVttkTANw8uU3PODqfxxuexjBVcgsVU3WOgD49Kh7r+pJm9DZXIFBkkMVTAmgZ81S2yPeTC2usJ0w2Ivx0uH3Jn47i4m+lHSfR1rWp6gGEQ4SFemlST4aQFVr531NVgwBwKdQxY7a34aTl5lHYmqg4VmOSMloXdsMcvh9P+XpmOp3BaIlfN0b/D3PyK9bLgybpTAaxkgJn7K1wDdCPOlvhs0S+XO9BNPA3T9iM/cKLHgboaa5l1eMJEkEpKxC8eccAGOWZrCSY6ANkurar+PeKrhpcnVjQdg22RDOlswiqV1We63PXfsT4BR9wQ1Kt2yJxkoJP9lpkIMGxQk+lQAOb66s9KyrrEOgqZ2NJG5qwBxFkzNiXbJ5U6gtZnN2cTCeth7S4BylMBdG+CdNW6DpdCNvUcjTlcKCCYqBECdm9p47JsU1eOGEuCq6UV9+9y2oDcYvkbe4RN6ZTxgcAOH9GoX0+r3+llXs31ZSESmuQA+XCuuJS3GWVThfaPH41zFWk8Hc2Hj8k4kHTfzqjz/osoTF/q9Cd/PtIPPXWuDS0dHIf/pk/Nv7JzTPypvUAwreNNUQLf3KiuWmGnxHp/Uu1jAFKC6WnOecE/TL6GVhb5/2KuW092SMDuGn3xXwFX6WcEICdvlEw3V4s5zg9osP2yH1SUtVP/vqKmseV/m28h/Wiftw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(136003)(346002)(376002)(39860400002)(451199015)(110136005)(54906003)(38070700005)(7696005)(6506007)(186003)(2906002)(41300700001)(53546011)(38100700002)(4326008)(76116006)(8676002)(66446008)(64756008)(66946007)(55016003)(26005)(83380400001)(82960400001)(86362001)(316002)(122000001)(9686003)(66556008)(66476007)(71200400001)(966005)(33656002)(478600001)(8936002)(52536014)(5660300002)(101420200003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Sbh/NJgNh0v9H9oxqoFFw3RtsbQNuxsHbPyrH/leYV1uMXpRFrIQfCbIMw8x?=
 =?us-ascii?Q?UEYvhdk5bBgueHVb9qxbQboshzbjU9Y0JCU0rRMYh98HovTPv+CFy8nmhG9v?=
 =?us-ascii?Q?vEu9pz4tOq3IvaPfngngpnx9Cr8UPLXC6hMeO9nVn/a6N/DGxlzoq6fqjxUr?=
 =?us-ascii?Q?wKwYlAxUwNFIwkKmoLXC55ZeLeWO1VlGoIAqZZq2Rj2GIdGVANA7rTESV/Eb?=
 =?us-ascii?Q?N/oK+kyQI5tgCqTfc80hfckcG5RkX+IyJurnmfUnGz/S0PEhryz8fFyXZ7Gh?=
 =?us-ascii?Q?a+lo+mIeJY/SXo35sDi7zsoN+GPnHQhNzFolNbIO6y9tXyF38Cvve1XXV2Dk?=
 =?us-ascii?Q?sg+or8TJroGOEYxsIo+tpNpavWaA4tl1emEiHgz4wH5d8WBJkvArcBFKVjSO?=
 =?us-ascii?Q?PAOp/i8hVFaeq4LlUylEKhjuLs4ilPshGps7lY5Q2XJXod2yjXwo2AGfA10m?=
 =?us-ascii?Q?XYegnRvZmQqTxbJptCYpAexY9UJ3RHSeikMZ6gIFTXqk82yLPJMe3Liwb/ih?=
 =?us-ascii?Q?pjvegBZlYvDxBbUcaphDhju/vfPAK2mOz2MNrT4WPQg+ev2Vwppl9MKTYZeB?=
 =?us-ascii?Q?FR5dGzxBWTr00pjcVznzMmef3RUaxJ18hUP5FlhCSTztuil3EEB+3+9oFt5o?=
 =?us-ascii?Q?7y8Vu6VeabWWK6zDlNosNtuzZnFYOBT5eW7eQOY89m5LboxeSj3LAIzgLeyH?=
 =?us-ascii?Q?M2k+xYqDUxruHYu1tN62d5UHMi/bewomxARqqBeaUcYX18AcC8soIHDDiAk3?=
 =?us-ascii?Q?I5EVhMwNSLhIdRX+S3NNIwPq/jcRJMhiyMpAFVDcscKTwGJKQnLhll6N2J61?=
 =?us-ascii?Q?dRvEc9r9J8e8hw8WN9e7MPA88lNyUwjzOx5HqwjaHQh84lJUG8H0gCJzRC8x?=
 =?us-ascii?Q?ikVcO7nR28LFR2KcNPD7vP7ZtqLEUoYSk32C/yU4hqaTNKLbb0zE+laYcVV7?=
 =?us-ascii?Q?ijf2dZDGgVuR8WLe8c7X7+X0s5CJlaKe4k8YzFXzfAkrXGEfrna2EBkhefz0?=
 =?us-ascii?Q?yxJu8K+7ryu4lTrR4buq3Fvm9HkJ6TsdS0MDMUbKjVUqtM8ztX5CARRFKm3j?=
 =?us-ascii?Q?zge7+HaUtyNzeHNiDjjtwceBPiMyfdfVzMmUlKUitQ7bj2moa5xZNM9WveFY?=
 =?us-ascii?Q?s1u5buwSGAdxvNErPbJUCQAr/gOf9YE12phMAq0c8X3CKsjlULs1dGBc6eFv?=
 =?us-ascii?Q?bOj8ebiv9KHpukDGExVgrSGzFBPwi80TvUxqWNP1wlDj+oXnlc6IOKTO2cwR?=
 =?us-ascii?Q?kdUtH5n6Bo5Lnw6tZBlb0ztxIcFJ18QWdptQIfK0qRvUg8oxqgwMY4GzheRC?=
 =?us-ascii?Q?mAD/syi1g1+K6pwu5drXgCWEswctsHKgQ5rFJfrkfmDM2U7+v4BT3RlS4N5d?=
 =?us-ascii?Q?nls6xHdp1Jt6VxamTyUSe3bwTXM0bJcbezTAwDYkTrbLA/aHTDxk6dNm9RLx?=
 =?us-ascii?Q?xmvJM6rzm5u/GMjW1mfiHKYxA4jLFDah7dQ5q7NzAankBfbLTGgwbPBTUJ8n?=
 =?us-ascii?Q?hcoeYBIUepi0Mi7bSyIkdOPeXeVxozSdY7qGyoGOLcAKgLwylaOWyhKDFjRo?=
 =?us-ascii?Q?oBi5HtfChNqWHpGfwyI=3D?=
Content-Type: text/plain; charset="us-ascii"
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: cd1f9b94-cecd-45b7-ae1e-08dab6ce17a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 21:15:50.2195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sb8uNaxpqz7u1EAkV4EU5+CMTWQzNG0LbfvpPNZtXoulVp/N3M22zNsDfWACgLTd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR84MB1768
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: g1Bo6XLLn-TkD8WaetPDZoTK4K6Ywjdd
X-Proofpoint-GUID: g1Bo6XLLn-TkD8WaetPDZoTK4K6Ywjdd
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_13,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1011
 mlxscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210250118
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> -----Original Message-----
> From: kernel test robot <oliver.sang@intel.com>
> Sent: Wednesday, August 24, 2022 3:22 AM
> To: Elliott, Robert (Servers) <elliott@hpe.com>
>=20
> FYI, we noticed the following commit (built with gcc-11):
>=20
> commit: aa031b8f702e7941b4c86022348a366c335d389a ("crypto: x86/sha512 - l=
oad based on CPU features")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
>=20
> in testcase: leaking-addresses caused below changes=20
> 2022-08-21 00:20:54 ./leaking_addresses.pl --output-raw result/scan.out
> 2022-08-21 00:21:21 ./leaking_addresses.pl --input-raw result/scan.out --=
squash-by-filename
...
> [49 .init_array] 0xffffffffa03f0000
> [50 .gnu.linkonce.this_module] 0xffffffffa041a540
> [2 .rodata.cst16.bswap_mask] 0xffffffffa040d100
> [2 .noinstr.text] 0xffffffffa0c3ae00
> [4 .altinstr_aux] 0xffffffffa0c39d55
> [20 __param] 0xffffffffa0415a88
> [20 .altinstructions] 0xffffffffa06fb180
...
> [1 .rodata.cst640.K512] 0xffffffffa08001c0    <-------- (1)
> [1 .rodata.cst16.XMM_QWORD_BSWAP] 0xffffffffa08001a0   <-------- (2)
> [1 .rodata.cst32.PSHUFFLE_BYTE_FLIP_MASK] 0xffffffffa0801160  <--------- =
(3)
> [1 .rodata.cst32.MASK_YMM_LO] 0xffffffffa0801180     <-------- (4)
...

The patch simply causes the x86 sha512 module to be loaded instead of
sitting unused. Future patches will do the same for the rest of the
x86 crypto modules.

scripts/leaking_addresses.pl is scanning all the files in /proc and /sys
looking for files with contents that look like kernel addresses (16 hex
characters starting with ffff).

kernel/module/sysfs.c creates a sysfs directory for each loaded
module that includes a sections subdirectory containing numerous files=20
with filenames starting with . including:
-r--------. 1 root root 19 Oct 25 14:07 .rodata.str1.1
-r--------. 1 root root 19 Oct 25 14:07 .rodata.str1.8
-r--------. 1 root root 19 Oct 25 14:07 .rodata
-r--------. 1 root root 19 Oct 25 14:07 .rodata.cst16.XMM_QWORD_BSWAP
-r--------. 1 root root 19 Oct 25 14:07 .rodata.cst32.MASK_YMM_LO
-r--------. 1 root root 19 Oct 25 14:07 .rodata.cst32.PSHUFFLE_BYTE_FLIP_MA=
SK
-r--------. 1 root root 19 Oct 25 14:07 .rodata.cst640.K512

The contents of the files are not accessible to non-root users.

Those contain linker addresses:
/sys/module/sha512_ssse3/sections/.rodata:0xffffffffc084b000
/sys/module/sha512_ssse3/sections/.rodata.cst16.XMM_QWORD_BSWAP:0xffffffffc=
084b170
/sys/module/sha512_ssse3/sections/.rodata.cst32.MASK_YMM_LO:0xffffffffc084b=
f00
/sys/module/sha512_ssse3/sections/.rodata.cst32.PSHUFFLE_BYTE_FLIP_MASK:0xf=
fffffffc084bee0
/sys/module/sha512_ssse3/sections/.rodata.cst640.K512:0xffffffffc084b1c0
/sys/module/sha512_ssse3/sections/.rodata.str1.1:0xffffffffc084bf20
/sys/module/sha512_ssse3/sections/.rodata.str1.8:0xffffffffc084bf28

That is not unique to the crypto modules - all modules are there:
/sys/module/intel_uncore_frequency/sections/.rodata: 0xffffffffc08d0020
/sys/module/intel_uncore_frequency/sections/.rodata.str1.8: 0xffffffffc08d0=
118

/sys/module/coretemp/sections/.init.rodata: 0xffffffffc0c5d000
/sys/module/coretemp/sections/.rodata: 0xffffffffc0a2c280
/sys/module/coretemp/sections/.rodata.str1.1: 0xffffffffc0a2c000
/sys/module/coretemp/sections/.rodata.str1.8: 0xffffffffc0a2c130
...

Perhaps lkp needs to run that script as a normal user, not root?=20
As root, it outputs 67234 lines; as a normal user, it outputs
just 3 lines (all values related to keyboards, not addresses).

