Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A759C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 15:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242393AbiKRPoe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 10:44:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242417AbiKRPoc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 10:44:32 -0500
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EED57CBA4
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 07:44:30 -0800 (PST)
Received: from pps.filterd (m0150244.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AIEljvL002820;
        Fri, 18 Nov 2022 15:44:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=FLkoy5vUrA+zNWdTewhq/JT69UVnHlcx8Nl4oZmOKOI=;
 b=OeNV+cge3qXImNdaKbslhZ5FAP2WKM3agcGJubrB2hb5+lvVtG9JWXhEmyUZo6llNKlT
 yJMihpEom4d6hOa31iBqqQXEx2F8knrR2SKacMvhy1AkvZNeNFsncT62v0bBx8WSqfIQ
 OGglDL2qXl6mV12msCDGH2YyZpD166nGMa9Pmn9dUMAfxQur+CQbAoubVYj7zUGSV+kE
 1bmde0ybihrG8tDhBjbO5c+jZeg1/Jv2HDBoo2r/XXJ27ZowwVSVb0gayFLxOsWyjVBS
 YO5lggGSA3xL9qr5cfkyMwqrYH9AMQv7DDv/KBFHoaPK3U5D3DCJqAvm6nm0a9g8HmOB GQ== 
Received: from p1lg14878.it.hpe.com (p1lg14878.it.hpe.com [16.230.97.204])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3kxc4bgfkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Nov 2022 15:44:12 +0000
Received: from p1wg14925.americas.hpqcorp.net (unknown [10.119.18.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14878.it.hpe.com (Postfix) with ESMTPS id 1B7AB2EEEE;
        Fri, 18 Nov 2022 15:44:11 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 18 Nov 2022 03:43:58 -1200
Received: from p1wg14923.americas.hpqcorp.net (10.119.18.111) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 18 Nov 2022 03:43:57 -1200
Received: from p1wg14921.americas.hpqcorp.net (16.230.19.124) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Fri, 18 Nov 2022 03:43:57 -1200
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 18 Nov 2022 03:43:57 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PxNI6EKkm9rvh+/RBrScknJZWvZHKAMUODrLdbPKniBkQ3xEtWEt5Q0hNMoeLrBjdIaFumruKt8Jnk9vBTS4aQiqS5OFzOd2cl6l2dQzceIaizhAEJ6gtH1ZEAsNCHDqDMLJ+LsNrhNtJ/BUpbydB9lPdJ0faxjNEH+OseCxlnAxUNPQkA3xCCJ8GEezRX6G+5eu1urlMGjHjNmiJCdopGKoAyxdXNoG9i44vz28uokVb9yxip54oRUQOug9XlwzllTtr6sTuB9h3j0HYJUno6GzSFewAHc13xsPwXEwXS9A2a9d25bnS+NhjbHT6aLdYmTdjyqDqfXf5wLNixLFNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FLkoy5vUrA+zNWdTewhq/JT69UVnHlcx8Nl4oZmOKOI=;
 b=Td6nOPNDBTHz+aKgnp7lQXCmyDAiGB9ycVFSezgXq9vtyvUWRWjoG+RALqG9wEvEqsDHiY89exdr+onobC4S5GJo4O8ei6wvgpef7Nx8J3Oz3P4OsnMdsuaVlhFv6sjYwLHj5ac1dXMrbmVlHRgCVGLkhk13FxQW0MfGLbCALI8uQFbyoeaAvAl9k+d0zFNsefv5ci+i/iSSzrIF/YazUJHE1GRZQMhriui7ZlL1EEh2i+RFFOBg1sKGadSWoEqQg1t70soVBYqmbhzjAyWJ9u4XPqRsNjGUxVeBlCnYm+4AXgJ+AXIdutXwqkVRj1fPPRO+cDhxbaIkMkAbLiqRVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by PH0PR84MB1693.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:171::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20; Fri, 18 Nov
 2022 15:43:56 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::5511:bd85:6961:816]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::5511:bd85:6961:816%9]) with mapi id 15.20.5813.020; Fri, 18 Nov 2022
 15:43:55 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: RE: [PATCH 0/11] crypto: CFI fixes
Thread-Topic: [PATCH 0/11] crypto: CFI fixes
Thread-Index: AQHY+yzRYe3fakVHM0eSxOcY4VJpEq5Ey7FA
Date:   Fri, 18 Nov 2022 15:43:55 +0000
Message-ID: <MW5PR84MB18424C160896BF9081E8CFCAAB099@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20221118090220.398819-1-ebiggers@kernel.org>
In-Reply-To: <20221118090220.398819-1-ebiggers@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1842:EE_|PH0PR84MB1693:EE_
x-ms-office365-filtering-correlation-id: dde284d9-e36d-45ca-fb60-08dac97bb3a8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lnz+1dImhWAThiLcA1T8LOfke5NDvu3cbj9j6VSCgISRYvBtx02jqnU/xGpmvRe0ukKyZcgP+IFHj1Rmr4F+zDYpH/G+hSFqGxrT+ARKc8bvx8bLgviOUoBgWOPgPgHC6HbCf65x+4TxnwhoYIKaCEBjxRrZEKQJutFXE75Z5TUhaAoe32DlAQDA6DgDbUXNUrQlEARNyw3wFdv9StAAV2qDSGJDVctfmjRw5QBDQWaeZXXC0T7H3TwlpVYWLcnDbVtK3/qdwAprsgaFRVqOIj4K95FemclFADXxWxWjV1o+EDVh31v3wVVC6xAMbryRFc5qUDZpaXTPRZp6dwLvtFE1tw8dqDCjCzvxwrKvvo5F+ZVtAVwKMoxb686fSs1mgYH4jWo9n4z7KYjt54NJC4jGzzeaN0nO1Fgy7p1xS+Xbpr+SqylwGi11XrzOJHHXJghYQPAKiK09Bapx1/P2/1aWvlxfDMu81mfXBFCVgXbY89DP4eje5PU+k70X1upLQcKqhpBJeJRwbMoLP0wI2bZXxC9svUnm6ShUXXtAH7cifPpvF+WiU3wg89zxrKSV4CyKXNmaxjphhvHSDrD7qK8wRJYF5ly2Te+UN6L2VoYbkjP3vnHiOWgd7WCrPAvC2wdVSN59PniImX8QpswEv8ogSlokf9vmexJ+Glco/BqcsI3aMpOHe/3K8utjpQiYYE+U9k1e+tp6ONqpacvTZg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199015)(33656002)(82960400001)(66946007)(2906002)(4326008)(8936002)(38070700005)(86362001)(122000001)(83380400001)(316002)(8676002)(54906003)(186003)(478600001)(5660300002)(110136005)(52536014)(66446008)(66556008)(26005)(66476007)(41300700001)(64756008)(6506007)(71200400001)(55016003)(53546011)(76116006)(38100700002)(9686003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Vx7e72cHtrxSIrksRcDJNr/c7qL+5OY1cJ3SxG7CKUnPrtKl1bNNzkFtuXQR?=
 =?us-ascii?Q?k2ffdfhS26td3d4hajnF4PQ6cVPqVjzjzNbHbZiHm+UllJW1uzq4JXTSBRr8?=
 =?us-ascii?Q?V+ucgluRUKh18NFNk6tphXZLPOvPR4r/ZYhkaiJkoidUtGBacpI/VYBpxNrQ?=
 =?us-ascii?Q?p3SA/luH6MHeqGBZAqPrcYVNUwXwTrm+fxbwg5hfM0HCF8T7Aj7VpGQHp4xa?=
 =?us-ascii?Q?zD3PSACvd4GlIp9JlYaI2r9iQoWGSItiniI8lOiwa1ops4Mp3Q49lpjTIJ8p?=
 =?us-ascii?Q?wvn4Tuqk6lA4bmxOifygaDFPhIo29+amEY4usluZeIutcrZvBr/g9uNZwogs?=
 =?us-ascii?Q?3nMJYahrHEbPsbh/hpkYtOVI7yDWGKzYcj3CujY7F+rrEtVPlxpO64Fkb6Go?=
 =?us-ascii?Q?LmDr2IzCU7W+TUUlBdITpSd1cPoCFT85Kb2C+M3XnKYajfTQEBD1h9A+EnP7?=
 =?us-ascii?Q?c4ywuY4bS8BnH+I/BMMyShrM8nBz9+inRfKTRlACgaUva+62K/jKDcdVY8E0?=
 =?us-ascii?Q?4xxIOghukAH5SR7JkYjuMIs62SprnvNdE4mYb+BJBALtisLB/ZsvwBTueJmp?=
 =?us-ascii?Q?mSpgbKvMNmQmayvHtLTrng3JkZuM1muIaWHoR6ecH02sGFO3roqHIPROWRy7?=
 =?us-ascii?Q?h6fGg/lWKT8LFyXskpthJ2q7Z0xRsHqiFdW/G6EyyfmiJlLZhl6tJ9SQESYz?=
 =?us-ascii?Q?HGgFswyGw0OVoLTfrakUL+bAJ9On1xIesLgp5KeGuQ6YmfJSeJ+/G+lsjnWl?=
 =?us-ascii?Q?vJ4TWfKlA4njrGwsYSNM6NHcFjtR5yiNNkkSuZbpAmmLfcnVsCQ/Og6bEYCy?=
 =?us-ascii?Q?wlN4ze0MYs5enZanEjizadmjYQZISCoU+b+2t3HDSEC0BuiHvV2N6wqXnrkd?=
 =?us-ascii?Q?tmElNUnrWuf5DTn0LRVfidROkOqVlKGWdnTyZXmUPmftiGF7GBto4CKkeo3s?=
 =?us-ascii?Q?wxx3Q//LdAe6u1RJZ9Dx2YQSdV+qRTuIQY8RCwyuPi6k77H1YxKLApMRqJl/?=
 =?us-ascii?Q?jOWwINEgMv/PaU/vDOsRoAz+jQPGqia9xrNn1YcSBinjqZZOyNhrFIN41eas?=
 =?us-ascii?Q?UI3aqBGBgNdbIt2od6xtvv8Ip7cN4Eb1t2TSFZJZSv8JNPqe/Ve5sLXZzdoY?=
 =?us-ascii?Q?B2HwzjXugYURBm6rEw5kjG86N3AQP2pO8fDFbdODMjoT4OK/CeoPbWX57Zox?=
 =?us-ascii?Q?77T0D+AEzT9DS155l4gS7n81hOmcFAsvL5RXYK7TWXbMj7dTSUct767G5zpU?=
 =?us-ascii?Q?rbq511hxetXXkl9DaBqaEttkypbzqpxcqs32XDA0jzvgbnS+Yz2EvQuKFtJw?=
 =?us-ascii?Q?LXZJSEll9ZDdAZ25ZSqq59RMdNC81uGLZuJi8+w8d+czlmH4/yhXLEo9re2W?=
 =?us-ascii?Q?IYZC3BA1xxZ9U1p9P4dNegm4Ch/5aQ35YT5ecbP/XE3ExFi/Yc+/Lx2kpapt?=
 =?us-ascii?Q?6poUPhMDdkFes/1XFSrFOI4ae3RPCjHhEDLxKDLTm06ApyuPK/KooHWZ1YDS?=
 =?us-ascii?Q?mq8n6TrrWgWlH8scmN1uaguxeKe10Dh/4+wkE6/X/No8mRgSCRfXdI4sgrKn?=
 =?us-ascii?Q?ssVP5+vQ/jjgYXhhpaE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: dde284d9-e36d-45ca-fb60-08dac97bb3a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2022 15:43:55.8546
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FXUtOtjjUPFhHWUmjcSqKBd2gMmAlSawG68mczUf1zXZb2fkpAXJm0wIrT6Sivzb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR84MB1693
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: qtFMSw048R60vRvTW9td9NXct2rbbLre
X-Proofpoint-ORIG-GUID: qtFMSw048R60vRvTW9td9NXct2rbbLre
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-18_04,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0
 mlxlogscore=988 lowpriorityscore=0 phishscore=0 clxscore=1011
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211180091
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> -----Original Message-----
> From: Eric Biggers <ebiggers@kernel.org>
> Sent: Friday, November 18, 2022 3:02 AM
> To: linux-crypto@vger.kernel.org
> Cc: x86@kernel.org; linux-arm-kernel@lists.infradead.org; Sami Tolvanen
> <samitolvanen@google.com>
> Subject: [PATCH 0/11] crypto: CFI fixes
>=20
> This series fixes some crashes when CONFIG_CFI_CLANG (Control Flow
> Integrity) is enabled, with the new CFI implementation that was merged
> in 6.1 and is supported on x86.  Some of them were unconditional
> crashes, while others depended on whether the compiler optimized out the
> indirect calls or not.  This series also simplifies some code that was
> intended to work around limitations of the old CFI implementation and is
> unnecessary for the new CFI implementation.

Some of the x86 modules EXPORT their asm functions. Does that leave them
at risk of being called indirectly?

arch/x86/crypto/camellia-aesni-avx-asm_64.S:SYM_FUNC_START(camellia_ecb_dec=
_16way)
arch/x86/crypto/camellia-aesni-avx-asm_64.S:SYM_FUNC_START(camellia_ecb_enc=
_16way)
arch/x86/crypto/camellia-aesni-avx-asm_64.S:SYM_FUNC_START(camellia_cbc_dec=
_16way)
arch/x86/crypto/camellia_aesni_avx_glue.c:asmlinkage void camellia_ecb_enc_=
16way(const void *ctx, u8 *dst, const u8 *src);
arch/x86/crypto/camellia_aesni_avx_glue.c:EXPORT_SYMBOL_GPL(camellia_ecb_en=
c_16way);
arch/x86/crypto/camellia_aesni_avx_glue.c:asmlinkage void camellia_ecb_dec_=
16way(const void *ctx, u8 *dst, const u8 *src);
arch/x86/crypto/camellia_aesni_avx_glue.c:EXPORT_SYMBOL_GPL(camellia_ecb_de=
c_16way);
arch/x86/crypto/camellia_aesni_avx_glue.c:asmlinkage void camellia_cbc_dec_=
16way(const void *ctx, u8 *dst, const u8 *src);
arch/x86/crypto/camellia_aesni_avx_glue.c:EXPORT_SYMBOL_GPL(camellia_cbc_de=
c_16way);

arch/x86/crypto/twofish-x86_64-asm_64-3way.S:SYM_FUNC_START(__twofish_enc_b=
lk_3way)
arch/x86/crypto/twofish.h:asmlinkage void __twofish_enc_blk_3way(const void=
 *ctx, u8 *dst, const u8 *src,
arch/x86/crypto/twofish_glue_3way.c:EXPORT_SYMBOL_GPL(__twofish_enc_blk_3wa=
y);


A few of the x86 asm functions used by C code are not referenced with
asmlinkage like all the others. They're not EXPORTed, though, so whether
they're indirectly used can be determined.

u32 crc32_pclmul_le_16(unsigned char const *buffer, size_t len, u32 crc32);

void clmul_ghash_mul(char *dst, const u128 *shash);

void clmul_ghash_update(char *dst, const char *src, unsigned int srclen,
                        const u128 *shash);


