Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F50C28D13
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Aug 2022 22:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237518AbiHSWhh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Aug 2022 18:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiHSWhg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Aug 2022 18:37:36 -0400
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B4810E97E
        for <linux-crypto@vger.kernel.org>; Fri, 19 Aug 2022 15:37:34 -0700 (PDT)
Received: from pps.filterd (m0150244.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27JLoZf9008033;
        Fri, 19 Aug 2022 22:36:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=J2YE0+4asd32eqmiL4lF+jU7kWOGawKttqBetbnAG8Q=;
 b=Xk4jhw8k8cVOU2mMqOperLRnFl95NpIEs6wLgt/XANpmMhjUGMdhvoxRlOSXSi7J+ifo
 B33taFNs+d+G4B5bTZSCkj3qwc8galYAZBWVbh7Ja0iRnYN+QQbNtR8s1wAR39hiI3OI
 ZhW0xxbNiCGmayAYqLJD1dGAJF5wfDl1rSAevPByufZfFTun3g8VrH6s5VGqRUkIGtJt
 q+smDeqoXuSH5g74CJp9Nzid45iCk5DLopfUQmGt9fsJvYNOPDvGOumtAfhsQnU4GlAj
 2x17S5rgBi1adS3z2sAKI8EwiFmk/GDtDlmPhmbV5/UXsMvVQNXOAKc9EmRGBTTL03a7 wg== 
Received: from p1lg14880.it.hpe.com (p1lg14880.it.hpe.com [16.230.97.201])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3j2jsr89a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 22:36:58 +0000
Received: from p1wg14925.americas.hpqcorp.net (unknown [10.119.18.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14880.it.hpe.com (Postfix) with ESMTPS id 1F9CC8001AE;
        Fri, 19 Aug 2022 22:36:56 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 19 Aug 2022 10:36:56 -1200
Received: from p1wg14925.americas.hpqcorp.net (10.119.18.114) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 19 Aug 2022 10:36:56 -1200
Received: from P1WG14918.americas.hpqcorp.net (16.230.19.121) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Fri, 19 Aug 2022 10:36:56 -1200
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 19 Aug 2022 22:36:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DC0fwSfWH/7JdXhx/jB7unLf/ZLBmuyXivyNAAC0LwM/FdusbrrhYu0n1LeAKCZLXV4VS1pGdRwMr0pvyDMlI0cks+XeIgNkXAsUfsArv/p92FQhT+DhYkDmnXrpbfgGQ0oGpr/bILU87eRMl44WxgJITo8r+c8wlj0K8bTTMXNheIORi2J+9yZfALT5WOvCA0tGgQuQ53nnUhzUo+tHYiCRNqRBlq9lIbiXQLXcXTP5tdaznebQvRrL50qJ2N2guXf4aHO0XrTtyBgVSRFJoNIQ26QJBK7y1D7GF6f59czVWsNMCVUeJ7SVcZag3Up5TpYf1aS/dqdsnbVC072Obw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J2YE0+4asd32eqmiL4lF+jU7kWOGawKttqBetbnAG8Q=;
 b=PG9sA6PHCueGELUX9afUxMvqk+VUQ8HPggYjRGd9rEAzp3h0XjrxfNVSuRRS9vS7ORre8n+M/teeSYrqc41DHnwkLGYVl5wR4BYGRX5xfVjsHsXipZzcVGzd9sSOV79cFzjDhmmtupdEAIb/aSDzwkp87hcDQ5Qd6hWSsONQNCIrIAEReRvj6dNn8IuIE+nu3b4ZJs8AmvS6aw+3Qez+L8E/yW+tMIT1u4uKKRlGYdogrcQZHLf0S68oZp0fZF+x3JHr6Qf5j2afwU4xr2UYVbaKFOuT0cS3K/yjsXH7Z6bCEZzX7bFDcRs5P5in/3wrTmUDb3ZwJz/LZlH2hRPbDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by DM4PR84MB3029.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:ab::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 22:36:54 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1cc2:4b7b:f4c5:fbb4]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1cc2:4b7b:f4c5:fbb4%5]) with mapi id 15.20.5525.011; Fri, 19 Aug 2022
 22:36:54 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Kani, Toshi" <toshi.kani@hpe.com>,
        "Wright, Randy (HPE Servers Linux)" <rwright@hpe.com>
Subject: RE: [PATCH] crypto: x86/sha512 - load based on CPU features
Thread-Topic: [PATCH] crypto: x86/sha512 - load based on CPU features
Thread-Index: AQHYr2k4ae1ddXSOmky6WV6b3Lh2Q622GE6AgAC77WA=
Date:   Fri, 19 Aug 2022 22:36:53 +0000
Message-ID: <MW5PR84MB18425E5211BD4EAF09D0CE3EAB6C9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20220813230431.2666-1-elliott@hpe.com>
 <Yv9ubekvQiL3UGwd@gondor.apana.org.au>
In-Reply-To: <Yv9ubekvQiL3UGwd@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b08550b-60cb-420f-5acc-08da823350fe
x-ms-traffictypediagnostic: DM4PR84MB3029:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dH7uoPo9amU7mQHO88UMIp7jWEupEowmHM+5Jp0eCAPeB4mdYYVgn337G9PkG634svTsict/sZSvMK1fOYLeRIhAZyxOICZrOHt/fTlfj3imtFnj+r2rGmnCICIZTRSt0yD6OxtuWcF2XOm0phQwDq1jX/tG1ZB/XZqv+y7HsPRKwXA3gc3nU2XxQeUp8ZGe4d5BdH86cd80iKRNIkavHey3Wgoreuo/Tf1LT1Rr3UdnoEt/FHDsa4nfvWQOQ9fROf96VwOWlN4VXgAqnC2Jdf7N2sqyEfvkmKzW6/wCxbHOLQhgMqO+saWYqoE2ivJ75lGhAGcM6D70+134RHbid1Q5H+XLFOUQGFXOV+nsx5T1qJDDygAp0YBKSUZUeUpqnrr18A7pjQFrqhnLHp674zh5rs2o6lsFlkz4CiLW06gAg0auug1Tefgh70fTYVpj+vt30ahcbMvR4K8/uumq3XCgX/LxF+IuRgQOnlkXhE/i06NxhTbalde5AmmMnxSXEWVB3sWg+NdER1ZJg6+JtkH0O9yN+Z8WtNXrcDYsymfVVWhR8Ypj/aOoxAYj1QNVMmjv/8Jy415a8iIv3YjO1GG6hpWkPszclYd2Stzya2m/W89UCK/aD7qFTIdB4RjY8RAZgV4QSbGDyGGLTMNbQyAiNJtNeUn2uZxhBXrg+Yzs5N54wI6LVrrfiwzpf86vDEnnMnM8gOx4QKJ+WjTQ9fQB0/AaNaOjOG5na3tsL3NWuJjRGu9cLIMH/0qokAlaukhV1LAyAzDNBsJsQaWxYg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(366004)(396003)(376002)(136003)(53546011)(26005)(55016003)(52536014)(8936002)(5660300002)(9686003)(86362001)(7696005)(478600001)(71200400001)(6506007)(33656002)(41300700001)(186003)(38070700005)(83380400001)(82960400001)(316002)(4326008)(8676002)(6916009)(54906003)(2906002)(38100700002)(122000001)(64756008)(76116006)(66446008)(66556008)(66946007)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?l5RphB/xp73AKYz/K6aUM7VMpMCwqBmb1YRTHsD1AXerBQbxkE7Hc9qRj4Q6?=
 =?us-ascii?Q?FpTHTlovYFbvXr0D/AYb1AGT372fgZn874t0kqHPUAIG1TNgqTjpqMpZ1IrN?=
 =?us-ascii?Q?dZ2sD0CDLRThNFQVYddLns7l0wtcmiXGpbLKtDTRv5YZTUWmImHoar8jN/BW?=
 =?us-ascii?Q?oGOcEJIR4tHcuKGo3jUlx6hdRzN0jpzjnR4bI8ouFN+Er+xmLXU9lzCUvpoC?=
 =?us-ascii?Q?xVMX7PHOajs0rigTJxsnCdiQ07uUeWxDOQviGz3ezIuX+t1Nw8ALs3+E6iyW?=
 =?us-ascii?Q?t8+2vpoATKIkt+m4iTAiQpYpzc99D12Ui7d9uLsR4Gt5SAkgiqVXQ5mk2OUY?=
 =?us-ascii?Q?Gzk45PL8rLVBk4CKoG9rkhHqlwap6Gq6u2kxdkQRHsvJG7CLxI/LGj0/utLM?=
 =?us-ascii?Q?2v2//GaSe74G6PypcALG7+NWJEvEevAOLtSr5xdszMZBvTvCu5P6c0kFXBXp?=
 =?us-ascii?Q?VVGydL0M5YyW80d3oR3bu+TY71qYOSu8dp5mdhfGQ1OiBJxwWZNSyEWQKIs6?=
 =?us-ascii?Q?cZUPnlmn1GZnGDiBwmq6xARmMv97967+ngC0wTWTHV+R4uNC4jJdtfLWmF9E?=
 =?us-ascii?Q?M4F5uv15HeIM/92c352rg4OJU+HM8zwrI3p66+mcrAhjm7JUSrGEy+yFflqU?=
 =?us-ascii?Q?gGezr2IxT/CzJg7Fn9Baxq3w+yTctLGZ5snocYPAdeJPd/GvqpB1qZuwoOwK?=
 =?us-ascii?Q?jSyoNDzieM5KCKcYXgLddILC0SZF+OLNYNUhSUhrJUy7dV+WjSbaUXfTLZYE?=
 =?us-ascii?Q?AlmvD6Qh2WMTYzDTJJMcyXWqzTOU9+SFQ9yvnwbSmNShtVEm/cRs/KAEAaH1?=
 =?us-ascii?Q?ZLcktHUqLHUzHl5jnuclo40DAGCFwds+aH7ZsQcbKS6OyHd1ZKXUF6GptfyD?=
 =?us-ascii?Q?cL01LNgf7+6n6FPLIoqDNJSSEkiZ1UvztXho4Rr7eKTh5nH7AXeQ+7X1ei6n?=
 =?us-ascii?Q?Ef+a//dtBQcYjbvaQ2Ifr1/J/5h0ZRpUXTwU6odZm1bJzJGuzNta1qaCpNmB?=
 =?us-ascii?Q?aYGWcNGY2HTVmq5/jBOcKETHIfc+UuoF0JtNTrjQAWK9/B2H35oP2sFFvpN4?=
 =?us-ascii?Q?E4Zlu48mb9+bbloXrmSc1GGqvqjve+PAOzwABJonlQI1qlpgnB0zJU515Mij?=
 =?us-ascii?Q?Wi7qQL/1fAKik80LUQIgI7/mXysDtx3+5MEYtXzNU7IOzsJQLVAxgzQI6Fi2?=
 =?us-ascii?Q?d/kfx+ARsTcxPzQgrfKR/wOEW67EkovwcxHnkGTXuclx9L21nWLgKl3/TjOy?=
 =?us-ascii?Q?Eqh48AKhtBU1kuvJia+IAlfWC0IOTOBRcRRhChi1GuBnLxQJhKKMB1mxkmXS?=
 =?us-ascii?Q?dbRKS51kMYfm9if/BZCS+DebpjA3KE9DJrpexGeb8fA9QVNREyZ+Vv/Dwz0w?=
 =?us-ascii?Q?POvlEGjte0TQWbcC4HOlsGS76q/N3Rrsn5AXUbsgdb+ovepnTEpdo1UjvP8+?=
 =?us-ascii?Q?dzgTN0Y5Qprx+1KlmJje/2LrwNhQVe0JiZn4uGyr4/6DAIOC4vAwbGFfOht8?=
 =?us-ascii?Q?Fmuyu2l2Oo/GwdyRzpUOUlRXFZ10D1Ego6bEtozWJ+EoJilLQgwP9XygjRRC?=
 =?us-ascii?Q?Ghc3poc1t0ekZG5dqkM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b08550b-60cb-420f-5acc-08da823350fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 22:36:53.9667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lYpbWojVasK2JA1qxFkQZZdo/gqBfnAxWBD6yJdVNRzyMoT5NyF4hWOPtbC+yVCp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR84MB3029
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: 63MOomNw-XEiDI7mBGwlnztYY4Iq-92B
X-Proofpoint-ORIG-GUID: 63MOomNw-XEiDI7mBGwlnztYY4Iq-92B
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-19_12,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 phishscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2208190084
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Friday, August 19, 2022 6:05 AM
> Subject: Re: [PATCH] crypto: x86/sha512 - load based on CPU features
>=20
> Robert Elliott <elliott@hpe.com> wrote:
> > x86 optimized crypto modules built as modules rather than built-in
> > to the kernel end up as .ko files in the filesystem, e.g., in
> > /usr/lib/modules. If the filesystem itself is a module, these might
> > not be available when the crypto API is initialized, resulting in
> > the generic implementation being used (e.g., sha512_transform rather
> > than sha512_transform_avx2).
> >
> > In one test case, CPU utilization in the sha512 function dropped
> > from 15.34% to 7.18% after forcing loading of the optimized module.
> >
> > Add module aliases for this x86 optimized crypto module based on CPU
> > feature bits so udev gets a chance to load them later in the boot
> > process when the filesystems are all running.
> >
> > Signed-off-by: Robert Elliott <elliott@hpe.com>
> > ---
> > arch/x86/crypto/sha512_ssse3_glue.c | 10 ++++++++++
> > 1 file changed, 10 insertions(+)
>=20
> Patch applied.  Thanks.

I'll post a series that applies this technique to all the other
x86 modules, if there are no problems reported with sha512.

Do other architectures have the same issue, or is something else done
to ensure that modules are loaded?

MODULE_DEVICE_TABLE() is used by three other architecture-specific
modules:

1. One arm (32-bit) module, matching on certain Arm extensions:
  arch/arm/crypto/crc32-ce-glue.c:MODULE_DEVICE_TABLE(cpu, crc32_cpu_featur=
e);

2. One arm64 module, matching on certain Arm extensions:
  arch/arm64/crypto/ghash-ce-glue.c:MODULE_DEVICE_TABLE(cpu, ghash_cpu_feat=
ure);

3. All of the sparc modules share a global solution:
  arch/sparc/crypto/crop_devid.c:MODULE_DEVICE_TABLE(of, crypto_opcode_matc=
h);

/* This is a dummy device table linked into all of the crypto
 * opcode drivers.  It serves to trigger the module autoloading
 * mechanisms in userspace which scan the OF device tree and
 * load any modules which have device table entries that
 * match OF device nodes.
 */

Each module .c file includes that .c file:
  aes_glue.c:#include "crop_devid.c"
  camellia_glue.c:#include "crop_devid.c"
  crc32c_glue.c:#include "crop_devid.c"
  des_glue.c:#include "crop_devid.c"
  md5_glue.c:#include "crop_devid.c"
  sha1_glue.c:#include "crop_devid.c"
  sha256_glue.c:#include "crop_devid.c"
  sha512_glue.c:#include "crop_devid.c"


