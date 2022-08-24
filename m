Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF907C00140
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Aug 2022 19:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbiHXTg2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Aug 2022 15:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236829AbiHXTg1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Aug 2022 15:36:27 -0400
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB8913D28
        for <linux-crypto@vger.kernel.org>; Wed, 24 Aug 2022 12:36:25 -0700 (PDT)
Received: from pps.filterd (m0148664.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27OISaCl023676;
        Wed, 24 Aug 2022 19:35:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=iD8rUzqGsDa1z/u09VzvD0dbIFQ8Xsz48TNHv1TzH2c=;
 b=BXms7XkEU8IJfBpvQfbhV5341PJy8i6FlTpvcQP6py2WtCNgFfr43FZp/MKjHlciFcdB
 LZytOZfOpL3oj8vomLFLzvdKF4gq4QETQcIpVlhuV/jMmeQviI8LXaPv4xO7ORVOYjue
 OW/h52kMQ5eYsQH+qWzaTv4LBT9CfM962hn/jdux3eHWq1LKkgtwMDrWJcY8PkWp7rqZ
 6J+tDG6h9I956KrJqq/6eblrq0y4amSYNrWy2KV2cl+LR8J6tMIw7+ha0lTO+pD8V2hY
 keYKElTZrFHI7ynd0oMAoxuI/WjtjxHNrgI3KW6R0OA+BNV7neZJ42HM8f7gbn4/HeDJ Uw== 
Received: from p1lg14879.it.hpe.com (p1lg14879.it.hpe.com [16.230.97.200])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3j5s9j8nn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Aug 2022 19:35:44 +0000
Received: from p1wg14923.americas.hpqcorp.net (unknown [10.119.18.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14879.it.hpe.com (Postfix) with ESMTPS id 0BBCED2FE;
        Wed, 24 Aug 2022 19:35:43 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Wed, 24 Aug 2022 07:35:30 -1200
Received: from p1wg14919.americas.hpqcorp.net (16.230.19.122) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Wed, 24 Aug 2022 07:35:29 -1200
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Wed, 24 Aug 2022 07:35:29 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e8GYsJ5oFbjKEElBbrO97+N7Oom9y6NO+Y+cYlW5FiFDXw2HxngoSUZz821u39xh9XLoPFjvIoidibHywoZFUT1X29nwFXyMIXpUPE4SzozBDsPSJJd96pERaK9QXry585jwh5sKInsd8njpkSJmo2vsX3iYrsrJafdl2P4A9M4YySjiZi2pr3pOz5yD9H1iHTCAF+8QBCSF6W2a5YdzUFVF/HUBdx2cc8XYwvZhhGMu/6TqG/1eeZ94fE/a83IforX1eq+oWPvmYWr9m8ZeiWt3yy9nIBWDvnmygNH2FskgQotA+IZqu52zaUsC1mlSRwyyoLH+tPBicWHyuzNhTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iD8rUzqGsDa1z/u09VzvD0dbIFQ8Xsz48TNHv1TzH2c=;
 b=cMlM0VRNLB069RzYrFhmmYWd3lg4fknutodrUUotvrRzDHf4u14rDWXlZXRmIZR+/4tXJ7lU/TA6h2HSEIFUJuAUfZpNVdEtlxhFM7rcy/uJ6xS2dmHXHoBZdoFc/5b5AX/dk3of9e7cEtRMB4R0Hv0dpmFPEF7jhfpzb/Lkk3z7rHM2aXWgfNpksYTeYB1Q0Kt3fNySm1DUVN7CF0t8SHThOUI3kVmVmsnR93Wwc/OwXqYj9KKP3Mpp2O8NL0hddPVG15MzNp6MQ/gyjAjdxjnSYd+LvlwNjbAZ+J8h6SMd+kYj17K5ySD12Iuq7wLQDot5Dd6dT8nSYb42AHk2pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by SJ0PR84MB1483.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:a03:431::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 24 Aug
 2022 19:35:27 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1cc2:4b7b:f4c5:fbb4]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1cc2:4b7b:f4c5:fbb4%5]) with mapi id 15.20.5525.011; Wed, 24 Aug 2022
 19:35:27 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Taehee Yoo <ap420073@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [PATCH 2/3] crypto: aria-avx: add AES-NI/AVX/x86_64 assembler
 implementation of aria cipher
Thread-Topic: [PATCH 2/3] crypto: aria-avx: add AES-NI/AVX/x86_64 assembler
 implementation of aria cipher
Thread-Index: AQHYt9KWd44WPaUfqk6N5/zH6iPvDK2+a4uQ
Date:   Wed, 24 Aug 2022 19:35:27 +0000
Message-ID: <MW5PR84MB1842D91195D8B5F438230C18AB739@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20220824155852.12671-1-ap420073@gmail.com>
 <20220824155852.12671-3-ap420073@gmail.com>
In-Reply-To: <20220824155852.12671-3-ap420073@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44c26665-2a84-45ee-b04b-08da8607cc51
x-ms-traffictypediagnostic: SJ0PR84MB1483:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0P5Hauy3RcX+N/TGu5M7Rgux2T45P69nOSM4Y8bkbXEweu3acuu1BKp2jr8vIAggzLejC7yzR0QgkOLbvP6ydSodC1iQ1lxcYgnnIz5rE/ZywwcnaGZISxAXjORvc2DBCK7edMXMQq9eqOTJrKRzFhIfY0gNkr++XKCwv0O0j2cncMPisB8OO6798xYRzjNFouDmii/3tnQ4mkm0nU7l0oGVFLx5fQIV9XgPEdXDm37c/ezx5TfV9aNfcFubo9o+jYtiFEuqE8Ij0xhmAbmmDWt8GLLumclufifzZfUWKN0nsY58BpWxn7wFIt4EYhu7fASzGfoPQI7aqyWqv/uH/Cj45YxS/8LhNp4yINwuViZAlQAOEDc7WS5IZx9+F2YCUjDB71aXQYVMe8bMDknCoDig8APvqkXWLrWQxt+dgo5yvAwg6AecuO0kgR8S6Cb6RJiymQa534XSFi4z5XVria3HsgUtZKc6OEpCrtNSycuqlv8ONkV6bBNPMZdlRm0LsGoYlV89N+lhYDTh3eoen2B93paTphbSPehDwuL6QisskwwnxEyOVkHu8xm8d6ql0NgWzJA0sBA5tZyDGqAEm+qPyHVJ8YLiWFzcKmtba/Lr0CFKDyvROtfCFQITrHzC6ligyn0gODSDbVx4w1TwONxpOHominNWE891ZTBvvFWfP6O0yXKHSrWqhLksOePnPzIP8fTCVvh1ZeSrkq4/y9/Qk1ZuHgA/Cv4fBkmxcUB/uFXXzTEB30sqFdugHYZGoMf0rehX2DBuUqfQebbe+bvjL3CuYovzJgwtZjq9GFw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(366004)(136003)(346002)(39860400002)(186003)(26005)(9686003)(53546011)(38070700005)(33656002)(7696005)(921005)(6506007)(82960400001)(86362001)(38100700002)(55016003)(122000001)(83380400001)(478600001)(66556008)(66476007)(8936002)(5660300002)(76116006)(8676002)(66446008)(7416002)(52536014)(66946007)(41300700001)(110136005)(316002)(71200400001)(64756008)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Rr2229amHoV+uIKFLpODESjchZkKzXaBgHNpnghlEsxITUAK629PqyWLyoUM?=
 =?us-ascii?Q?LhJADPtwxAFULrykkIsgATRae7hMCV7eyy7UUBj9zg/XaVGsNu9OeBC/yFIo?=
 =?us-ascii?Q?5097qumv74Lk+I6/FZGXEb/hnM0ZdHmVBsxDqen0GvoKzyJfp/cWjm3BqSf4?=
 =?us-ascii?Q?wIgkznIAD0W1C9Gh1eQEDCpX2HrBkalfKXw1559xnS8+kow46DIe0DLY33/0?=
 =?us-ascii?Q?pqAEg2ipvcCdK1uihm5UFNqpoJU1ez6C+3SWJgzXCx60+vQuHjlmeS7yygGS?=
 =?us-ascii?Q?FHIWgIPkFYhjoa4I8Wnr7+iFl0fUKonpcxDTvmH7JbF3ibXC75eriYz3+S6n?=
 =?us-ascii?Q?+LjMxOgNLO3mGimptaZtLRZh3JXgXNQ9yA8o5XwD7UX9ra5OQtIN5gWJOqfF?=
 =?us-ascii?Q?sfKp/vuWdeqRdfHiMdDPQ9x+OgFa/20/aawVlKSod7jvMDxGx7CTHQYEiDbm?=
 =?us-ascii?Q?0uhoGx45pcmbL+BlyW9EJWoc6fNWp8tHRTzJ6s2fotR+H5LDlLba3plpYh+f?=
 =?us-ascii?Q?7dOQB5HjI53OvcdZtOjaNADk6LrRrGQMYHpJS69q2DehEANOELUYsSFLzShA?=
 =?us-ascii?Q?XU8NEdQnLhWmVzDz+U145gaWMPBkdGQajIZeGkZI1AEkyBqfTLh64OE/jC3Z?=
 =?us-ascii?Q?amYbsccwZzHvndGCOtELxd9+/zFIwIEsYo9VRTHjWwEjoKJ4k4QsZrK99oKR?=
 =?us-ascii?Q?tJmh2PCsbCkzQ98mJ0aP/IByQb9edLZYb6sZN9+QMchDM2Y7ZfsBpfGCuQP9?=
 =?us-ascii?Q?v6pMAmgGArw5bSfut9DNcGxRzAhLbuz2+iLFVzzskreU2Rm+JgNlI0k5tGy+?=
 =?us-ascii?Q?9vLnyT5B6YwFf1R2qPZEIeB0+I4t3sUiS1fvW0gP0MFJYoc1joBMmhdyG9km?=
 =?us-ascii?Q?d3tNr40rHfhX07VkszgnzbWGVye+fndv1F/AM4D2QYid7M30/agdcozFiLGx?=
 =?us-ascii?Q?ANADSXS7YPVmgpcWbxOObcy3jCW4b1qleh9LHAHikLGfpOWPNM/4ED7sVz3E?=
 =?us-ascii?Q?YH5xTjOcH4PGbGFZsoGUyT4Cn3n/DwLIp0eXzzLaErUZ+nKU5aKLQ/vQQsBp?=
 =?us-ascii?Q?BJPHcPmEysu741jLqzNytwxCIlIvBVFYo0gpshu6nsy9zWX5rWpRG/okEpf5?=
 =?us-ascii?Q?J0ONAU//zDbKfypg5t3ICkWFb7/u9JGY2IzKfLFBxqdqpjovY759dTeh6f1W?=
 =?us-ascii?Q?7QL3RDcSli/CeXdHvTovZZ8g4AmsTyDSHXnxbBN0dZGaMQe8/VNfvglksDAN?=
 =?us-ascii?Q?UG2IgFgwmjd822ji9bA1ZdsiXmKks3+3ZslcEjHpJLlXnifGrriM0LwwRIBH?=
 =?us-ascii?Q?RylnqeW0I3nUQty275knkx0rKjqX46+xdbSh0LsYkrf+apIZI0Pl+C91mxwv?=
 =?us-ascii?Q?aNMxp+mDboMD1spbcP8XFe/ud+ngHvJt68KXcj2ySUmNUqzObS/nqdGfcjpC?=
 =?us-ascii?Q?AJcOdl+r+4Vfm1YRUU7FMJ75RE3K0bT+CcoONnayj7ixuwZ8VkOEkhG7TfJr?=
 =?us-ascii?Q?mgsWdghvT9OQ+LtTMlS30kxubstC7BS6e3r6eOAbzPpjJyWzM36mmW+VuOxz?=
 =?us-ascii?Q?nUR+zwSGrcPAX1tgH2o=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 44c26665-2a84-45ee-b04b-08da8607cc51
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2022 19:35:27.6831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MM+aYkRtnXgMrQfqF2mthKb/s55Pt1wn1TX907KDkcssauk8Q75U/WgHRKXw1DLV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR84MB1483
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: UDJBVcmql-7e124FKRuF0YPTFMkdxOG9
X-Proofpoint-ORIG-GUID: UDJBVcmql-7e124FKRuF0YPTFMkdxOG9
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-24_11,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=799
 spamscore=0 adultscore=0 mlxscore=0 clxscore=1011 lowpriorityscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208240070
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Taehee Yoo <ap420073@gmail.com>
> Sent: Wednesday, August 24, 2022 10:59 AM
> Subject: [PATCH 2/3] crypto: aria-avx: add AES-NI/AVX/x86_64 assembler
> implementation of aria cipher
>=20
...

> +#include "ecb_cbc_helpers.h"
> +
> +asmlinkage void aria_aesni_avx_crypt_16way(const u32 *rk, u8 *dst,
> +					  const u8 *src, int rounds);
> +
> +static int ecb_do_encrypt(struct skcipher_request *req, const u32 *rkey)
> +{
> +	struct aria_ctx *ctx =3D
> crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
> +	struct skcipher_walk walk;
> +	unsigned int nbytes;
> +	int err;
> +
> +	err =3D skcipher_walk_virt(&walk, req, false);
> +
> +	while ((nbytes =3D walk.nbytes) > 0) {
> +		const u8 *src =3D walk.src.virt.addr;
> +		u8 *dst =3D walk.dst.virt.addr;
> +
> +		kernel_fpu_begin();
> +		while (nbytes >=3D ARIA_AVX_BLOCK_SIZE) {
> +			aria_aesni_avx_crypt_16way(rkey, dst, src, ctx->rounds);
> +			dst +=3D ARIA_AVX_BLOCK_SIZE;
> +			src +=3D ARIA_AVX_BLOCK_SIZE;
> +			nbytes -=3D ARIA_AVX_BLOCK_SIZE;
> +		}
> +		while (nbytes >=3D ARIA_BLOCK_SIZE) {
> +			aria_encrypt(ctx, dst, src);
> +			dst +=3D ARIA_BLOCK_SIZE;
> +			src +=3D ARIA_BLOCK_SIZE;
> +			nbytes -=3D ARIA_BLOCK_SIZE;
> +		}
> +		kernel_fpu_end();

Is aria_encrypt() an FPU function that belongs between kernel_fpu_begin()
and kernel_fpu_end()?

Several drivers (camellia, serpent, twofish, cast5, cast6) use ECB_WALK_STA=
RT,
ECB_BLOCK, and ECB_WALK_END macros for these loops. Those macros do only ca=
ll
kernel_fpu_end() at the very end. That requires the functions to be structu=
red
with (ctx, dst, src) arguments, not (rkey, dst, src, rounds).


