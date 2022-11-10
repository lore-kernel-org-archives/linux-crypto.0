Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C0FC433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Nov 2022 03:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbiKJD5X (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Nov 2022 22:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKJD5V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Nov 2022 22:57:21 -0500
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864EE31355
        for <linux-crypto@vger.kernel.org>; Wed,  9 Nov 2022 19:57:20 -0800 (PST)
Received: from pps.filterd (m0150244.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AA2DCZq026573;
        Thu, 10 Nov 2022 03:56:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=AlrhIr6nHv8dd0YwqzE5dqUBrL0YfUZX5Hp8zoZVxyA=;
 b=WhHEiEJg5+mF4aoFkgvYpLMnAN4j9VJ4bvHdZ1UkplUIoCkDNe6F2SUhUjB8ILpY1uWD
 /+RmaLcmurRYC4uU9gp5giGQx+Ik1OYQHXNqjJsEzxxBQ0y8yj0YExj6mBx9BjbRTymn
 gjWhSUop1h0ITlW4Ty5RT2+adn3MUS1WNMkk0nGjP39oHqJdQ+GaLzO6eyiBpzGFLSD2
 hBa07a1nrmKWJkwyYYSgUEvSg7GEmJ1Jy+tqmCqNOkSM/HltsO+Ydhou5B2+Vx1pa+Bc
 IajtMa84pJNuUFXjo/taQPYIOmADxekpaYezXee/zSFSEHyqDyB9JT/cFXSC7dP1Wuzm YA== 
Received: from p1lg14878.it.hpe.com (p1lg14878.it.hpe.com [16.230.97.204])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3krrae0kp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 03:56:15 +0000
Received: from p1wg14924.americas.hpqcorp.net (unknown [10.119.18.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14878.it.hpe.com (Postfix) with ESMTPS id A0503D24E;
        Thu, 10 Nov 2022 03:56:12 +0000 (UTC)
Received: from p1wg14926.americas.hpqcorp.net (10.119.18.115) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Wed, 9 Nov 2022 15:55:41 -1200
Received: from P1WG14918.americas.hpqcorp.net (16.230.19.121) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Wed, 9 Nov 2022 15:55:41 -1200
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Thu, 10 Nov 2022 03:55:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3dtRqyisZQ2cx4F2gKG59imzCAefeM4GhQyPCA+TOXBlgHNdLR1r/dcRStVHkmovE1K/A0ZfhFjx0d970kxhn+8g05QR+ayrebB656bhi2wpyQsXkNxyLbapOkGht35Kx1Sd5yZIwDt1gHFc67JJocuWgllI/wYAe7erUQfc5h+V/Hk6yw5APlBSm19dLvuCeEN+I3QFh2P3xyIJmG8TP/iV+7tdO0wU6C5oaLNPdBzzgD1YKMeZbwOqOs5hc8LYN4xTKzr9DnljROVe5VUuDIzTzPfnzqcpHIitbvQo8Nk6eQPczEOvuRf59sOcxO3zsWSKlmP8ipcJxc8U9s0Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AlrhIr6nHv8dd0YwqzE5dqUBrL0YfUZX5Hp8zoZVxyA=;
 b=Gf+MDYD23zlGd98v2UiDlhMVe9y+e/aMQiWlEt8YLO+82FOlqEyWYJdWjjKHqlLX4rSVKXIlEtWwpX57hK5DTi2b1AZR4SOC8yLOhc/Tem3HCb3yh6hOU2AVt3TID0LvNfTVCOhCV5LXezRCO/k+dhn3uIkQE6O0HO5zRu6gNxH0u8YuPLztnHM8CJBEG0urugPEN25JQEOMnNVQC3hnuREMCzoBZixhAsNrKtwpa5qzUMplyy8CHvKpMrnDiJro+ycUaf29KXE4qa/dMuIif3q+8+0tjW26NcVm5nCaPbkRP2Z6Ch4sERpPY5ojNUZZzIJ2Q+T5R/uiLflkMu2D3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by MW5PR84MB1570.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 03:55:40 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::e739:d90:9fca:8e22]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::e739:d90:9fca:8e22%7]) with mapi id 15.20.5791.026; Thu, 10 Nov 2022
 03:55:40 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Taehee Yoo <ap420073@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "richard@nod.at" <richard@nod.at>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "jussi.kivilinna@iki.fi" <jussi.kivilinna@iki.fi>
Subject: RE: [PATCH v3 2/4] crypto: aria: do not use magic number offsets of
 aria_ctx
Thread-Topic: [PATCH v3 2/4] crypto: aria: do not use magic number offsets of
 aria_ctx
Thread-Index: AQHY8e1gHlUTGybXLkCClZ3eR7ihfK43cq3g
Date:   Thu, 10 Nov 2022 03:55:40 +0000
Message-ID: <MW5PR84MB18422C6DB5DDFAE158BAF459AB019@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20221106143627.30920-1-ap420073@gmail.com>
 <20221106143627.30920-3-ap420073@gmail.com>
In-Reply-To: <20221106143627.30920-3-ap420073@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1842:EE_|MW5PR84MB1570:EE_
x-ms-office365-filtering-correlation-id: c144279a-5331-410c-4593-08dac2cf6eeb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hwOcSBYSCALc+EK6YMTrJ2N6EYUEAh4rg82n6D6UwRSkK2JnvZ/tcc2LUKeQ2wqjFuucHvtd8JkpAJ+PAKNewqNLhjUnWdIoVzhOS+uXRcxHnUjphqh6UDJdNF39nEYzTK81kQire/s1QwLd9p2MAYHCGais2Z/Gy1RqN6Ry1OSD+Ku7nsoqAj7ygmv6gNS1eWccTX8TkFO1U6vOus4p/yF1gF10PVSjNhnxcBaVD+7j3f7rYbCIPCpYrZQ7BuH/dIhXe3dD+7JDl4jbr5FQgqPoxJp20JAXEB2pS9WkKbcwvfTn/a5w7HDlBpPuMHkC2WiX+ZMh/n7IQAdVEik0TNwo8KFrWgFNxjjPSho7mLZk1/cNPIEnEUhxsXcGePRSrwIeLs5uQdK7gA190QiXOP1yIo2ZwMmMQEIr3nINPxYTH3IOtiJwsuoLDrZwbAHk00Iagd4l1RgLUqf2vCrlROGg/OKGABObE2Iovhn2nxCKJaKFSRcIugjOwdeT0HI2F7SuOtJQKn5eE3XjoJYmLSI29G7ovCDvu13PSrKMSEVqt+eVwM/d+N8TuuUzUG5WR+Dh4oGiBbJIb2CeIOpRmQk/Km4iY47SvjI50teXTaTphfTCtmGBj+Qohbuq87av00u7ZGK0Ws3DpbCmeVrdSSt5DhKiUUKeeHllmTqmvHo4MsD9XWvcj3hC3C+zGY943IojO/6eLN1psNr+ZhW2zqKj3ous56TlhUdbOu1XjoBLosL2Obo+VZAgYT9FbjQgZaBrsvXpupPZNC6o1h0rXl4o/zZu8SoQHMltPttYP0Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(346002)(376002)(396003)(366004)(451199015)(82960400001)(9686003)(64756008)(122000001)(38100700002)(86362001)(2906002)(5660300002)(7416002)(8936002)(52536014)(41300700001)(83380400001)(8676002)(55016003)(186003)(33656002)(478600001)(66946007)(66446008)(76116006)(316002)(7696005)(110136005)(71200400001)(26005)(6506007)(38070700005)(53546011)(921005)(66556008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?k1NN74SBz1+1a7HA3fIEbjFryY/QuxnCoWXV2+FAFADSsiY56X+wD8qppLRu?=
 =?us-ascii?Q?zJYjC27GRpstNU3QXV80fEAXc7doVm44I4mevkSqQLvhtR1DHHuTmaBxB/8X?=
 =?us-ascii?Q?QjNFnxh/jFydxfEd1/1Q+8tk3kyX8moaBFAzieY7KAzP+26USnFB0LNThv9o?=
 =?us-ascii?Q?ULLVExGMZv5jvM/n1dkDYc2BzQMwxuW5zfNAqq6Y6+ZUZHJlM9Oxqnj58Wtr?=
 =?us-ascii?Q?Es6LPNWiXLcSxtRvOByGYnS+KBF/mU67xUrH8ad7cU5RjQ/12gpBnx+p2ndM?=
 =?us-ascii?Q?uM1mvNap1vqe6cU2N2tgnc7Eu1/6J0slseoBZObiXmuThna63iqd8smjNOBS?=
 =?us-ascii?Q?TQjh7oxyvGFzvWL0ITW3FNbm35RX7//YegLNutL0rtIoAoG9wP9rvi/MRjkJ?=
 =?us-ascii?Q?GG0Wi1+8CJFw03bURk+sQV0iqg0r3rs+xR0TCfDzIrZ4fFJdZZjZG8R38l6c?=
 =?us-ascii?Q?SZF5dYC+PoFh5lQzR61RUU01NuG3Am4mrFXXjMUAkAn4eX/aK8rWoXfj4oix?=
 =?us-ascii?Q?fICX+aTa60hRh8fS4YpilaGBAko0Ql6DiOOUMjA5ozAAxrCm+hBJFHpHrf1/?=
 =?us-ascii?Q?HNi4xGZw9m1rkzl5TMAkc+Fe2dfHvOISCI3CdncD2vv+lM2bEqj/kAm14B/n?=
 =?us-ascii?Q?63qEX4HAe/C2wbNhHz+hIxJ6MmBhaFuyS4YEwEaFh6kpGG8Kvmq8sy6uAuGH?=
 =?us-ascii?Q?Y/jOzC7vXWAGL97hEyxlPKiH/pTEbWLiX75AWn7+nKjz6kiCxzCPsRAKx6mx?=
 =?us-ascii?Q?ytrtnDSGCbCSPIU3I/IRDqcaUMvN0WteQ/wWz+BUeONTLDhkdKgTk2pmr624?=
 =?us-ascii?Q?Xh5iBrvpZoxHLwG9oJtu620BffM14QnCVoryaWio96EIXDDgMf5nLE96oppX?=
 =?us-ascii?Q?O6jm2PkShSMINNL6cS5/URlR35TuD33Q8K9JAhau/hGlH/FCUMhhoVyo+oOM?=
 =?us-ascii?Q?JRfZE0TBk0X850AvAYIZMh5dmsiyn9rKP/qG/wlPpRW6viVpEYXlIIw0dap8?=
 =?us-ascii?Q?+Nngbwjcv6QdBTXCaZFtOk70NI5RUoYmOATQosEWVcC74dk6d7lqqlYrqLg1?=
 =?us-ascii?Q?tHlPTJkanRyPyp5FJwX6NulnYtOh7h1ZbFFf7oygvg+xNp6f6lVQG1uTI9BQ?=
 =?us-ascii?Q?SQLePsIaFVRu4SqcbYgWIvyukNqI6+m8D4oif7rYlJGM9xDliUROJXJ3VW5l?=
 =?us-ascii?Q?s9HNWDo3wM5QOsV1CVetB6wlk10lLNKuPMoQ7OCB+WfjtAqC5EaWZB3Aqpcw?=
 =?us-ascii?Q?LuX2fGIToHvSpsNe7ZTqyG10RmfZ2eHZlp9KFSMLy5oL6AOVjPwnKORBMSXS?=
 =?us-ascii?Q?PK3RtTiRBZeF73U57RDiPC0UZ1lOCY0p9HwBrq1gvc2VSgIyVzrtA/WqAZR5?=
 =?us-ascii?Q?BLPCjhGJcH7dDM22iS6IUgjE+BnquHbfCFIL1wmJ++TleCGscUQZlze5vjux?=
 =?us-ascii?Q?sMUw6+Wx+ICaSMh7w+7NeU8HCU/j9sUGzYfPnjRl2KsSVLJdu831cmm/i0wQ?=
 =?us-ascii?Q?WfmXB8dBe866fTk/wIUEPx0zeIlEtbDOb3P9fIOTSfukziohmKsvyZi/Tfkm?=
 =?us-ascii?Q?2q2tgTHkTRRZUF2XHYE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: c144279a-5331-410c-4593-08dac2cf6eeb
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 03:55:40.0809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8Sr4Wh3FLATAr0npxiea6FQVQXY7B+saoxVeOsFSKMDPlyDNjuuuXi7dadL0m5ON
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR84MB1570
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: cL9aAuWvGpxa0jza8dxh_ms1GosHt4f1
X-Proofpoint-GUID: cL9aAuWvGpxa0jza8dxh_ms1GosHt4f1
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 bulkscore=0 phishscore=0 clxscore=1011 priorityscore=1501 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211100028
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> -----Original Message-----
> From: Taehee Yoo <ap420073@gmail.com>
> Sent: Sunday, November 6, 2022 8:36 AM
> To: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> davem@davemloft.net; tglx@linutronix.de; mingo@redhat.com; bp@alien8.de;
> dave.hansen@linux.intel.com; hpa@zytor.com;
> kirill.shutemov@linux.intel.com; richard@nod.at; viro@zeniv.linux.org.uk;
> sathyanarayanan.kuppuswamy@linux.intel.com; jpoimboe@kernel.org; Elliott,
> Robert (Servers) <elliott@hpe.com>; x86@kernel.org; jussi.kivilinna@iki.f=
i
> Cc: ap420073@gmail.com
> Subject: [PATCH v3 2/4] crypto: aria: do not use magic number offsets of
> aria_ctx
>=20
> aria-avx assembly code accesses members of aria_ctx with magic number
> offset. If the shape of struct aria_ctx is changed carelessly,
> aria-avx will not work.
> So, we need to ensure accessing members of aria_ctx with correct
> offset values, not with magic numbers.
>=20
> It adds ARIA_CTX_enc_key, ARIA_CTX_dec_key, and ARIA_CTX_rounds in the
> asm-offsets.c So, correct offset definitions will be generated.
> aria-avx assembly code can access members of aria_ctx safely with
> these definitions.
>=20
> diff --git a/arch/x86/crypto/aria-aesni-avx-asm_64.S
...
>=20
>  #include <linux/linkage.h>
>  #include <asm/frame.h>
> -
> -/* struct aria_ctx: */
> -#define enc_key 0
> -#define dec_key 272
> -#define rounds 544

That structure also has a key_length field after the rounds field.
aria_set_key() sets it, but no function ever seems to use it.
Perhaps that field should be removed?

> +#include <asm/asm-offsets.h>

That makes the offsets flexible, which is good.

The assembly code also implicitly assumes the size of each of those fields
(e.g., enc_key is 272 bytes, dec_key is 272 bytes, and rounds is 4 bytes).
A BUILD_BUG_ON confirming those assumptions might be worthwhile.

> diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.=
c
> index cb50589a7102..32192a91c65b 100644
> --- a/arch/x86/kernel/asm-offsets.c
> +++ b/arch/x86/kernel/asm-offsets.c
> @@ -7,6 +7,7 @@
>  #define COMPILE_OFFSETS
>=20
>  #include <linux/crypto.h>
> +#include <crypto/aria.h>

Is it safe to include .h files for a large number of crypto modules
in one C file? It seems like they could easily include naming conflicts.=20

However, this set does seem to compile cleanly:

+// no .h for aegis, but ctx is simple
+#include <crypto/aes.h>
+#include <crypto/aria.h>
+#include <crypto/blake2s.h>
+#include <crypto/blowfish.h>
+// no .h for camellia in crypto; it is in arch/x86/crypto
+#include <crypto/cast5.h>
+#include <crypto/cast6.h>
+#include <crypto/chacha.h>
+// no .h for crc32c, crc32, crct10dif, but no ctx structure to worry about
+#include <crypto/curve25519.h>
+#include <crypto/des.h>
+#include <crypto/ghash.h>
+#include <crypto/nhpoly1305.h>
+#include <crypto/poly1305.h>
+#include <crypto/polyval.h>
+#include <crypto/serpent.h>
+#include <crypto/sha1.h>
+#include <crypto/sha2.h>
+#include <crypto/sm3.h>
+#include <crypto/twofish.h>



