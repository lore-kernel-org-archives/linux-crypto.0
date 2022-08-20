Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A1E6C28D13
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Aug 2022 00:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244833AbiHTAQ3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Aug 2022 20:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbiHTAQ1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Aug 2022 20:16:27 -0400
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F371AF4B3
        for <linux-crypto@vger.kernel.org>; Fri, 19 Aug 2022 17:16:26 -0700 (PDT)
Received: from pps.filterd (m0134423.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27K02nFT003045;
        Sat, 20 Aug 2022 00:16:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=9S2jVoMzESDzhXY5DmhT2rvPKdFdHrrepiJOT2db4SY=;
 b=E48fNKEDQ/M2iWl1d+gqzFiaJb/oExgPn8Z8VLQ+RpT6KR9JFZ7cmzgjncGxBfEkpp4e
 +3QiYp+oMnxd/xqqhFSzSD6L/Ptba15uGDI8g7WXqKB+AhsFD8j18MPKyvXuL3diUZwH
 gjOk2jJ1ctRfazQKcePWnZBTXdKSuxlo7mXCI9wVcD8IyypiOf60hZIsnTpB28H7/rYJ
 77yWRBPS+Oyr1JdokL36hQ5yioYj9/18p/Wei59s3+QPnbqQGEub+nQ8WhAF30JICvQQ
 cS2KNNy7U0uhTfaZTvGWLYE0oUquFTsw+IvaRu7r0tKZOA+ra+QBYfd7liSp9/XzXDOe pw== 
Received: from p1lg14878.it.hpe.com (p1lg14878.it.hpe.com [16.230.97.204])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3j2jq6gug6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 20 Aug 2022 00:16:09 +0000
Received: from p1wg14923.americas.hpqcorp.net (unknown [10.119.18.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14878.it.hpe.com (Postfix) with ESMTPS id 088BAD2E8;
        Sat, 20 Aug 2022 00:16:07 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 19 Aug 2022 12:15:43 -1200
Received: from p1wg14923.americas.hpqcorp.net (10.119.18.111) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 19 Aug 2022 12:15:43 -1200
Received: from p1wg14921.americas.hpqcorp.net (16.230.19.124) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Fri, 19 Aug 2022 12:15:43 -1200
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 19 Aug 2022 12:15:43 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tu5q+PPorJKKJraU1Tvq9ETjTMFpSEfdCTFpvHxEwLZkV4hU3VhjWeRJEeu+vlQOe+XigLRkJX2wN1XnMm1cHkV2yeDvMOyRVHclvLrSHVEwgY1s5vG8PK/O1K2gYi//9zRPKszUBpt1VgMsyHCTTjiPdNU4kDbQi70Oi1b+KjZGbXfo6Up9lO+RhbKofpx6UAoSLRIxoLz9KaimfO+rRf252fW7mNGOQjuoMXJpJIVV+nx/SdUtjiQnBPDe0GPlXNIUPWyGKDWEyeEJvKJeg6lUP3gX9x3eZtTPGY8XaohIc3j1+Lc4S5OjgUN+f5f/XIqu7EEPSA1YKSHh8QJksw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9S2jVoMzESDzhXY5DmhT2rvPKdFdHrrepiJOT2db4SY=;
 b=ZQ+9COFx3lcQffIX7q8vBWmiFlqAvBxG/11uFFKGyUHQDt2FntuLfWpC08LDQFWpu6jqff/XyL+CGmpRzbiF4BmO8f98l8Qnoq7Sm3ltcdq67n3Q+Z/pUll7ByE4TuFme5vhTVXfR8qe3Mw01xgQi8wxFeZmICT0Qkpa2zZUJ4Uue0yu7E9Wwz9vJ7J4H/zeUD+UikDQKscDDcY7eL+qpJLniAuwtMzo5uPoUnbgI0/Y7kjvRihRZnO3bkzoGU8cApDUnhbqxDRdap3ITSXGAjgSExiE2kfkQ+Vl7r7IXA13XpT+igfVQr45i8GAPC0FsEqifeJ0Uwk7jmoDTqBJKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by DM4PR84MB1544.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:4b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Sat, 20 Aug
 2022 00:15:41 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1cc2:4b7b:f4c5:fbb4]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1cc2:4b7b:f4c5:fbb4%5]) with mapi id 15.20.5525.011; Sat, 20 Aug 2022
 00:15:41 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Kani, Toshi" <toshi.kani@hpe.com>,
        "Wright, Randy (HPE Servers Linux)" <rwright@hpe.com>
Subject: RE: [PATCH] crypto: testmgr - don't generate WARN for missing modules
Thread-Topic: [PATCH] crypto: testmgr - don't generate WARN for missing
 modules
Thread-Index: AQHYr2qKvFfENN2UYkqyv18Pmvb4G622GGiAgADL2ACAAAvpsA==
Date:   Sat, 20 Aug 2022 00:15:41 +0000
Message-ID: <MW5PR84MB1842130E7FA4D064D50DC1EDAB6F9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20220813231443.2706-1-elliott@hpe.com>
 <Yv9uhQY7UAPN7QDE@gondor.apana.org.au> <YwAZhFLCrlHXegr9@sol.localdomain>
In-Reply-To: <YwAZhFLCrlHXegr9@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab248840-64be-4771-e57d-08da82411dfe
x-ms-traffictypediagnostic: DM4PR84MB1544:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x2FyP72FlTzP++atXfST//du95iKrHpLqE3XvlUQaRJrsJI7INFDsEA6Yzv7fJS+vhrzjD1Qijd9P6TFwOjdUV3gRNOwmqiYcEI7KvDYDcgLaro/e4S3x6f+1/xIBeA4Sj92zb0UYrQY2AWN4hFqnCfCp3TMbWsPW3nxCKHX/7rawfIUz7Um8NKbVZDVEodj/w+dtGPZCCVc8EDQ974coObmHPBNoy70rtWCBR1utpk66SuyoH0t+G9NLWXAkze6E1vWnBZ+XmokxpX1DielqJHDLyKpgwIgUyxbmHNEm5q4AHzM+ciasybpgGW9W6J9C8AlulgctqA6KhWoo4KdY7y0fujApCqb+Yc1Po9JCcm06+9zAcOD4iBM7tmeaUo9+QOkmmjQEo2TdlrkdvKoqM1Uic8TLEfk9ORP2e9bg/rAovqJrlrGELOqqHMe1OlrgzxD6/EwFOBftLF8SFFd3yabY+kRBabhXHzJse0+hjugWGPJgseSol3guHErXn6xzQPHR5Rg+p7pvjVpR/xg8+aw/Qy5wcvBgy5zx/0nzgAh8fRt80V3Ma3JLJjP1Ny6xrQmH9xsorJJoOrGu4ylVnLmqUI/IDoZB1DDYndmP8CeISzhUmaSb51vhuSrrZILejqc6d/pYWi01PV/zYoS1sDIrWy6ocyXHYJyJxxSUQbXujjHtsQVAqvfbfWiaV5LBLH+gZ7iYyexXCYxIAs6QWtU2/kfRUbRORwLMV3VrmWCazAw+jw0bcB7/MG4k2wVI0pm+HnZx6PGQ2UMO/pPeg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39860400002)(376002)(136003)(366004)(76116006)(66446008)(64756008)(66556008)(66946007)(5660300002)(66476007)(316002)(52536014)(4326008)(110136005)(55016003)(54906003)(8936002)(2906002)(38100700002)(8676002)(122000001)(33656002)(38070700005)(82960400001)(26005)(86362001)(71200400001)(53546011)(6506007)(9686003)(7696005)(478600001)(83380400001)(186003)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HNgLlOPgVyKB+0dP2JZPBpav1TuHeWgHWRwUQLSQ0jbDjXEmPxIIfNsfs5vU?=
 =?us-ascii?Q?ju1zsPLn8u+WsSerxGVOxqAngc0zKx3X6oeWZu77gn9d+Zdb7G3oL8yn6D1J?=
 =?us-ascii?Q?nqotxJi0kTcZlNgeGwa0slFBfiFMYsXwbTB5SZqP2i0oshBifrrEqdulQ9+Y?=
 =?us-ascii?Q?2a2Ds0du0ivxDJn+jw23h/tOLKAvuMloSBYfVoG55y9C8pQoVG/i4kyVerKa?=
 =?us-ascii?Q?ySfQ3LxD4VKHNcmiwrtuFUmiyBBg5WXPARESx/7g8uMolv+ig8qvKnVo4CNU?=
 =?us-ascii?Q?u9+DfQvtVCO6UbMUk6kJFaufG8t+K5rI+NzOkoqKx2vdjWMEMJ234LURLUid?=
 =?us-ascii?Q?ljErsFVOwPx8xhrF3SfnCgr2O12m/RAtzjY1Br50k8KdRkKeiaXFL3Bzs1EZ?=
 =?us-ascii?Q?BROH1c2bzOky1RTWpB7rQZ5CWozXvsoJDb95N4YupXsWnEf7fMCavfwTnIti?=
 =?us-ascii?Q?sXEYgJTfR32b+kButYgMhIAYSP4gNNvJZLA2nT7P1K4dUERO5gpXrzSI9Dbi?=
 =?us-ascii?Q?gBV2EWFlGHTknk3Jt0YFanE49Kj/jXXDaIaxeVn3aGOSr/W8GuBCGaef8HwO?=
 =?us-ascii?Q?x9gdPoVLa5slPMl4yt5PEz7961AB5/5DSV6usOfiWSnsKX2lPTRPsKQnq4dc?=
 =?us-ascii?Q?dWd3NE0Yrokae6MGyfY2egN4ku1SmQTSvrEajpHFnOaxk7hCJZSDoqn6pImd?=
 =?us-ascii?Q?kVK9HFDPLJdTqyvhkG+WjyYQLy8EFV32zW64tfSFacKcVym3UeDs1pq0REkL?=
 =?us-ascii?Q?cfmlyX49K7EqF2CG1QPm2/VcV1z86kDKasn5a2XZ7cXQ0OajfxSEIWKCq1NP?=
 =?us-ascii?Q?NVJMyLpb+KoJ3SiRgocrDYFnwV6vqHqGTBrtevsfYjHUV02uMt9T9aE7ohPx?=
 =?us-ascii?Q?MTK89YiSAzVt8NbUZtJBc24nwxwuq73aJssUJJK8P6b0ojtDxp+7GUNt4Qzb?=
 =?us-ascii?Q?qIwa5UFXD1zkHmh9my45h2rM0UbjBM/oyoJjlZB4+lbOjNrfr7NVa4B1REdZ?=
 =?us-ascii?Q?yb2GRjR0oavLW+aLBC5rWkdpYGtrvpjlaTfmHymdppvH49daSosDCboppxjL?=
 =?us-ascii?Q?osnjpDhGGEHAYuYAAbKLt/Svek5hSDKg4VT5FYDa3KYfCvDmVkGD+FVLxm98?=
 =?us-ascii?Q?spEYhs3IqtrjHKqjFolwiosnY8jnVB/8kL/z1VMWtmjkCPwBRflxZX8im8cM?=
 =?us-ascii?Q?ID+Y7yQOHgmyDT/bT2OOP4T/8+WHwN5Aj8lzwq2VCVhdpFgbedC8c/wBTwOH?=
 =?us-ascii?Q?sOseiWAj4P6ctKoXN/6BPHVF3c0bxKOJWt+zjD9qrQHkLHXIbs4fmSLpV5B/?=
 =?us-ascii?Q?SPgoyj6qXlsXMIJ5fAalwxLRBtuMAaHNZ/DeGOITuNu3WA0eaNWhERleptTS?=
 =?us-ascii?Q?FZitKW64dy41lTLcIuvvwFXwD04caGJKsdcUvmNiIyr4ZA0tR3K860tbuO1P?=
 =?us-ascii?Q?wkpE13nxQKo6tzfIEU/AsVkmxWc8Cz5v8GvwyP6+3rm/FL7FkHW+p/rHMY0V?=
 =?us-ascii?Q?LJsMuzFOXhWxErO8u1Ng1eWQacxEYZ5480QYmKjL5f2FqPlp0q/kPQXK6I34?=
 =?us-ascii?Q?x72TDnweReHrHO8zm80=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: ab248840-64be-4771-e57d-08da82411dfe
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2022 00:15:41.3763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ure1+DnjmpMNa7ZgSLkeiRmkY3mnnJxvCr0PMT3oJGs0DTZbIR+3/JoR41prHnzf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR84MB1544
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: 1YQFHIgpsGEP50Wd6mS7bxAaJbxuxG2U
X-Proofpoint-ORIG-GUID: 1YQFHIgpsGEP50Wd6mS7bxAaJbxuxG2U
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-19_13,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 impostorscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208190091
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> -----Original Message-----
> From: Eric Biggers <ebiggers@kernel.org>
> Sent: Friday, August 19, 2022 6:15 PM
> To: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Elliott, Robert (Servers) <elliott@hpe.com>;
> tim.c.chen@linux.intel.com; davem@davemloft.net; linux-
> crypto@vger.kernel.org; Kani, Toshi <toshi.kani@hpe.com>; Wright, Randy
> (HPE Servers Linux) <rwright@hpe.com>
> Subject: Re: [PATCH] crypto: testmgr - don't generate WARN for missing
> modules
>=20
> On Fri, Aug 19, 2022 at 07:05:41PM +0800, Herbert Xu wrote:
> > Robert Elliott <elliott@hpe.com> wrote:
> > > This userspace command:
> > >    modprobe tcrypt
> > > or
> > >    modprobe tcrypt mode=3D0
> > >
> > > runs all the tcrypt test cases numbered <200 (i.e., all the
> > > test cases calling tcrypt_test() and returning return values).
> > >
> > > Tests are sparsely numbered from 0 to 1000. For example:
> > >    modprobe tcrypt mode=3D12
> > > tests sha512, and
> > >    modprobe tcrypt mode=3D152
> > > tests rfc4543(gcm(aes))) - AES-GCM as GMAC
> > >
> > > The test manager generates WARNING crashdumps every time it
> attempts
> > > a test using an algorithm that is not available (not built-in to
> the
> > > kernel or available as a module):
> > >
> > >    alg: skcipher: failed to allocate transform for ecb(arc4): -2
> > >    ------------[ cut here ]-----------
> > >    alg: self-tests for ecb(arc4) (ecb(arc4)) failed (rc=3D-2)
> > >    WARNING: CPU: 9 PID: 4618 at crypto/testmgr.c:5777
> > > alg_test+0x30b/0x510
> > >    [50 more lines....]
> > >
> > >    ---[ end trace 0000000000000000 ]---
> > >
> > > If the kernel is compiled with CRYPTO_USER_API_ENABLE_OBSOLETE
> > > disabled (the default), then these algorithms are not compiled into
> > > the kernel or made into modules and trigger WARNINGs:
> > >    arc4 tea xtea khazad anubis xeta seed
> > >
> > > Additionally, any other algorithms that are not enabled in .config
> > > will generate WARNINGs. In RHEL 9.0, for example, the default
> > > selection of algorithms leads to 16 WARNING dumps.
> > >
> > > One attempt to fix this was by modifying tcrypt_test() to check
> > > crypto_has_alg() and immediately return 0 if crypto_has_alg()
> fails,
> > > rather than proceed and return a non-zero error value that causes
> > > the caller (alg_test() in crypto/testmgr.c) to invoke WARN().
> > > That knocks out too many algorithms, though; some combinations
> > > like ctr(des3_ede) would work.
> > >
> > > Instead, change the condition on the WARN to ignore a return
> > > value is ENOENT, which is the value returned when the algorithm
> > > or combination of algorithms doesn't exist. Add a pr_warn to
> > > communicate that information in case the WARN is skipped.
> > >
> > > This approach allows algorithm tests to work that are combinations,
> > > not provided by one driver, like ctr(blowfish).
> > >
> > > Result - no more WARNINGs:
> > > modprobe tcrypt
> > > [  115.541765] tcrypt: testing md5
> > > [  115.556415] tcrypt: testing sha1
> > > [  115.570463] tcrypt: testing ecb(des)
> > > [  115.585303] cryptomgr: alg: skcipher: failed to allocate
> transform for ecb(des): -2
> > > [  115.593037] cryptomgr: alg: self-tests for ecb(des) using
> ecb(des) failed (rc=3D-2)
> > > [  115.593038] tcrypt: testing cbc(des)
> > > [  115.610641] cryptomgr: alg: skcipher: failed to allocate
> transform for cbc(des): -2
> > > [  115.618359] cryptomgr: alg: self-tests for cbc(des) using
> cbc(des) failed (rc=3D-2)
> > > ...
> > >
> > > Signed-off-by: Robert Elliott <elliott@hpe.com>
> > > ---
> > > crypto/testmgr.c | 7 +++++--
> > > 1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > Patch applied.  Thanks.
>=20
> I thought the conclusion from the discussion was that this should
> instead be solved by a tcrypt change?  Either dropping the enumerative
> testing support from tcrypt, or making tcrypt just try to allocate the
> algorithms (relying on the registration-time self-tests) rather than
> call alg_test() directly.
>=20
> - Eric

Per Stephan, it sounds like this was a hacky way to get some/most of
the modules loaded.

It'd be good if there was a way to run all registered tests on all
available modules, not just the ones that someone remembered to put
in tcrypt.c.

I do worry this WARN() isn't really helpful even for real self-test
failures - it's dumping the call trace to alg_test(), not the
trace to whatever crypto function alg_test called that is failing.=20
With Linus always expressing concern with too many BUG and WARN
calls, it might be better as just pr_warn() or pr_err().


