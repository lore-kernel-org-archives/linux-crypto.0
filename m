Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957B5450F2;
	Sun, 17 Aug 2025 11:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755431755; cv=fail; b=C+kAQcHwmH0XrSZw1ryN34GWoDYwAFonOuXmYZoCNnxwgPBx03F4Lt3hO1rVULi1+eopXDrtsemkna1ACMDvCQ3Nmb9ZCgiN0XBU5gc9l63B01BbIwR7ycx0B2AeeMDK0V8AMdZb1BjSCPGwG2ja7X33lHrJmgt21plqnQWX9R8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755431755; c=relaxed/simple;
	bh=laC8gDAvhJh6teBIJvySiVSuBF9LxhVyztaOBiE7xFE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AbGWRnu1q7qnHDvzYmJUXyMKPk4SiyvX1CZo3nuN/7QaPDNsiBcbsGJpBJmsEXxsvQjSO2zcJKTxPn+SnCXTPU74ODXBLlirpFjriC7o1I7YPF3Efscqf5RrxclvPKOm7VlpPI7QvKMqxsXHZ5i0G3PZgvPtFqrTnzzJYKWSZJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EUIppIO2; arc=fail smtp.client-ip=40.107.93.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EUIppIO2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jxa+4bD8Xtdoxu85heNtH6j2uokToITLgOG7tnNjbQ4o0tMTp/H188iSdljEi7i6JMdgBNIc3jn9IyqQfSN4QwBr0+ZZz37lV4yC7npWoUbYK+RmdkGl8rNQmSPKFTPzW66urOPyo9hIgDCbhvHbezVWigl7F+IT018ZFUpeNH5th07shRWlnCBOvgEWZAhORd/UgmtbYRFvIT0mXNbg3JOtulPw029FUfW0F/KfoaVVa1LzCfS6Fe0amKEblnz6xhouqcaJy8tKA9RIT1HswV0M5CbCveajMljYkpYBpvhC/uAlodJV9x6K+TWOVBOIxJ7lEMw5mgaoAEk2pzi69w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SOihHzO10oOVTXqW67yDYaNnDPNDcYdBfOmnbSdy0CU=;
 b=XM3gmk/kgTPh9PY11jbdGukATvSTOiiC+gh0YCZL0R1ubWxvfZbzl02FY7QiT3rl6mPecZQfJLMbP29rYyJc6pgX+r2zUGEiMj0l+cxWA4bjmwglaynKPoryGYNfnBzZPaBNYnDIoNIlY0EVI3ZoPrtkloAHgqafu0SJ8U8Omd59pNy7RCmuSbP+LqR6btRatj5BIw/H7O+F6gy13wAuZ0Ss764wcvX2Ppm1aM8wXC4oh0uZ53vXTtwUaSIBnwS3HhDS7P57k3lvCz5pzT76Ia0vFyUdXxZwHZJ7koHtRn3hCRO31p84PoHPEsej6Bm5Fk6K8gzyYOwrUxJ1/WdN6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SOihHzO10oOVTXqW67yDYaNnDPNDcYdBfOmnbSdy0CU=;
 b=EUIppIO24pCPKX+32kMajWAnOXQye+QUdCfQjJHb+k5n2sz1zyZV/YiKuCX3W0mOtR7txnCDcKKMKjt35BbZ3bd+NZCFFbum0uUba7eRCdo0+xbLbqs9YstSoHNqphVAcgjybunrghcM7/oOU4TvMmK04CIZz3dvo2g9c1/LKjs=
Received: from DS0PR12MB9345.namprd12.prod.outlook.com (2603:10b6:8:1a9::10)
 by LV3PR12MB9144.namprd12.prod.outlook.com (2603:10b6:408:19d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.23; Sun, 17 Aug
 2025 11:55:50 +0000
Received: from DS0PR12MB9345.namprd12.prod.outlook.com
 ([fe80::65ab:d63c:7341:edbb]) by DS0PR12MB9345.namprd12.prod.outlook.com
 ([fe80::65ab:d63c:7341:edbb%6]) with mapi id 15.20.9031.021; Sun, 17 Aug 2025
 11:55:50 +0000
From: "Jain, Harsh (AECG-SSW)" <h.jain@amd.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "Botcha, Mounika"
	<Mounika.Botcha@amd.com>, "Savitala, Sarat Chand"
	<sarat.chand.savitala@amd.com>, "Dhanawade, Mohan" <mohan.dhanawade@amd.com>,
	"Simek, Michal" <michal.simek@amd.com>, "smueller@chronox.de"
	<smueller@chronox.de>, "robh@kernel.org" <robh@kernel.org>,
	"krzk+dt@kernel.org" <krzk+dt@kernel.org>, "conor+dt@kernel.org"
	<conor+dt@kernel.org>
Subject: RE: [PATCH V5 3/3] crypto: drbg: Export CTR DRBG DF functions
Thread-Topic: [PATCH V5 3/3] crypto: drbg: Export CTR DRBG DF functions
Thread-Index: AQHcD2VKdeFuVaU+KEa3xnvIIgln3LRmuKUAgAADyUA=
Date: Sun, 17 Aug 2025 11:55:49 +0000
Message-ID:
 <DS0PR12MB9345A8A31600FFA23F8E526B9736A@DS0PR12MB9345.namprd12.prod.outlook.com>
References: <20250817105349.1113807-1-h.jain@amd.com>
 <20250817105349.1113807-4-h.jain@amd.com>
 <aKG_qHTkmvQynXQ8@gondor.apana.org.au>
In-Reply-To: <aKG_qHTkmvQynXQ8@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Enabled=True;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SetDate=2025-08-17T11:54:26.0000000Z;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Name=Open
 Source;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ContentBits=3;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Method=Privileged
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR12MB9345:EE_|LV3PR12MB9144:EE_
x-ms-office365-filtering-correlation-id: ce614579-b7e6-40f2-c401-08dddd850276
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?MyNhwi/TFn+ENp187u6JIZDxA6k9yvuvn8wVzAe/bpMy6A/z3aThg3GJegJ1?=
 =?us-ascii?Q?MSblUgUffYfhJd+h8x0GNglYixPtTpbaPs+HcW1t3bGEzWrwbxBMvD8mZulF?=
 =?us-ascii?Q?OjvSRpjhZsrLLX05jlySglq3nlmpWKa073rIxl2Hrqw0MDRIIBsdyF0Y81HU?=
 =?us-ascii?Q?Byd2sN9Z6IQNyfsjcfK4X7dyrSakVOICXl20592G0QVWeuL0O/Npnjz8SvJm?=
 =?us-ascii?Q?IfKcjVZhZICxa4HuCFNADQQ1ms8fmRS5gMad5F+0WUxOvtOjmhZy89dAmd8z?=
 =?us-ascii?Q?+tT+I7RbXRsPJ0Lv+WIQGB8kqJG3u3n3uv0JzOy3140fy5k6zz9Zo94bXysh?=
 =?us-ascii?Q?n+aGqdJB1402WLPybfDXPtoiDhbFPpFrOQ8MwfGgEFSw0iRg9+XduQWVWl4L?=
 =?us-ascii?Q?3XbyoQWx4pHZmlIB3Yt+AyZjTAI1fs4eYLEwzRefScXPhsNN4NHr4464UPJC?=
 =?us-ascii?Q?sb1Z1tMdsk2vwkmh/x66ZjwwXZje9cPSCMNy7BUjH2RHpXF1l3XVLAnIIfBJ?=
 =?us-ascii?Q?i63mBKyx1Ianhit/AT3yXbKArDgMFPaGtPscBKJRFNoC4uDLqcl2kSB29EVE?=
 =?us-ascii?Q?caykLNT8CkL/tE57JLnWW4l4FDDiq+qqlnPk+yOtaDZeeiuOaaCSrSRL0dE2?=
 =?us-ascii?Q?6w3/gZcdkataGJ5IUkP391z2M9QUC31efsou1iOu9OLU3ZubvhFepFyoEAf3?=
 =?us-ascii?Q?q3yX8a3RinZ+7COQG0O8RksC9mm7GBerGUV+TsOlfLQ26AHF2DaeVjAnchgO?=
 =?us-ascii?Q?KNe+sHzqQwt2/kkVgx+/DmN0f+YUgaSiOXI6R/P2W8lCGDLY2qKXDE4AgeCq?=
 =?us-ascii?Q?xbGDNJakNqkhMkjTC+uiMa6Nv9JEOf9Z0mBOyzPMCVGgBQhWH67Lm1HugtEw?=
 =?us-ascii?Q?5dhrYLUGL7t0dQEd3W0uz2iTu6kmcL0q8VyE9gZdO3fauFakt7pU9LOiXJF7?=
 =?us-ascii?Q?qFjujlCR2sg7FVcZP6zixDFrzXdCeJlN0N83bWpY36XIUv9BSUi6KMwZIm7Y?=
 =?us-ascii?Q?NEp7X/X5tjB7uEpKfw9sMpwTfu7OIAAAGf1rw46uyEmU4+UTa5Qi6yfFDYDZ?=
 =?us-ascii?Q?SUNzNjrOl5sNW8ySvXYfkDXceadnhEi4bVnNwJVrwzaqJlMTTiZZsmlakYhX?=
 =?us-ascii?Q?iKmwSAYKRM7fxS1mkZJWsTxiiQF3BoW8AGsxRov/xalv9kfgrjhUwzJjhntx?=
 =?us-ascii?Q?GTBo2sPWY94olaYg3yZcGy5/zzRKdDD1auZ/7gNv8TIRQEMEABsnJE59lSYC?=
 =?us-ascii?Q?Uv8fcwUO6wakrxRQCJweLv+i9CMdUsPwb/u5TdWluaXqqPvtrNQwJxYBk5LN?=
 =?us-ascii?Q?D4MORWLfjf8AwgYjuOsuQpwrSYojLM+T4wTxU0Fo5hBFBVeTaFw5A8K77qnr?=
 =?us-ascii?Q?eFSMpOtkKzFIgH2Nmnh4UjTw6DAxZiIjtj/Co9bSVNJ2Nw4mBDDDKvASAzpt?=
 =?us-ascii?Q?wMuqw98hoK8=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB9345.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?HldSU+pAZW/dg3xywKxOxfy8myWAPxDiBr40UwPXeZ/az1QplJbpgSGuhPge?=
 =?us-ascii?Q?2/tR/y7p6JFdgDYC2KkIcdSAO88lBFlHhgellylqhEtGTPKG1aqRwCMtiUzq?=
 =?us-ascii?Q?QtirLZxbcK3BTECI9mdX1Q/13Dumdb7FXCv7m8ZdDRLDJUWb91UDRfvl2SiV?=
 =?us-ascii?Q?16G+lfLKLTV/nCYnFnFT87aPXYtf2yO9YKuoZjeGKOX+Dbi+nPXqH8vp8kRP?=
 =?us-ascii?Q?VvAGkHDicjbmfKMydVdy1ni82Btme+ThWkP39y2UzwANG37wZZ/mYSGWAhgR?=
 =?us-ascii?Q?pYOyeBAt1+tDhVDZhJlnFpKjuTscE1GikI/hs19z7KQopQnbqEfMkg2nv/Y9?=
 =?us-ascii?Q?Y5LHI2oE98XeTrgp3I1yV63MLCjMy/vKG5qqGE16xOs7QrD9C/5zPWsf7ra3?=
 =?us-ascii?Q?JdkoeA5kdPzgwOjLm0aRW2OXceMFPeQ2Rdptr7OOMNuOR7EA104puvkyexX+?=
 =?us-ascii?Q?Gfa+Qzki/fGqQ5LoMwtHsDyIsf7DMb+FEbUlJ0t7bee5eGoMD2Us6+Miq79m?=
 =?us-ascii?Q?fmR8lhYDEX9Divcd2khis019lkqpYaxH0+JJAg2jdrtgpr9wk1DjjIImNkQD?=
 =?us-ascii?Q?NZWP38nJhN/CWdPOc+WmaewrBGF/kzjuZqOCN03F7Z+7kyTDzlNI1TMPV7Av?=
 =?us-ascii?Q?xqrES7tdpW2EHVjEZrr/590pNHXaUYBoixaJ7NrGLFXEHQ8kG4Oe9SxsLVgB?=
 =?us-ascii?Q?R9HB8zTOFh8ATtnPeBlFdliSJF+S9Ihe4i0HSO/PQTb8bEU/8b2ylnw0RxlF?=
 =?us-ascii?Q?7EkcJdqxbuCwQUwFi8UAQHnf6ZsCvqXVNG5X956/lrVeNcPSmNowKyBchWFc?=
 =?us-ascii?Q?GZdEpl+2hGA7e9cxOofGcDMvI8IXFa83eCv/Wwku+fWV4D/D3e3DBHFxcMnC?=
 =?us-ascii?Q?GnyCDpmEOzp539nYr2OxMU9NhS0yfXMrGfpz+y6UPEGYtSihj/bqR8VkCnLo?=
 =?us-ascii?Q?JVWua4ddHek6QmrSdjICqo6b2704RkHr/ExN350NwqNE+ZWkYKgmtbs2E9+S?=
 =?us-ascii?Q?yCfaUHLHwSjHZuHCApDnlkQomUpUQHXRZUyUMNbHouvt5npQLeC94Pg+PVYI?=
 =?us-ascii?Q?aqy+psxlV15dl/szHiiQOaHwmu4ftQnWY5l/+vS1qS8ZQ1XsvLTampybRMdf?=
 =?us-ascii?Q?QSPs1/ZJydYH3KVzErrlMahGkfr+K1bYTDuRv/epBa0syGYqRwTehs4QNMYi?=
 =?us-ascii?Q?YMvlt+ULlfKjlPdQZsMg8evaJdcdPP+5ZpCHEhiJwtA01wYFkicnrbB96b7d?=
 =?us-ascii?Q?Ybr6ZBADa1fwuXdu4HDKZnT2f7GNmXK6VWrDvMP42i5Lq1YZ4ByJKgejov5d?=
 =?us-ascii?Q?EWQJxkujeXEIlG/NJqVWhdjWfdsPiuwoXdFqIoNS4zJKTQb85BSsfwQpSVez?=
 =?us-ascii?Q?EuvcPnVayYJfY20UFwnkn+Dnm5BYeHpmfswqwrLEugiSXCdnFJ7mVW6NwtXi?=
 =?us-ascii?Q?cwE/IivLQk45X81aq/nmtbJYmlzf7DXxu9XawmsaYBBJblJcTc8WKFyf3LN0?=
 =?us-ascii?Q?sHAW94kzvIaZTtEr0YffVwOtYZejC7PVyyWMg/L8JQzV3yjxGbgmO06ozDHa?=
 =?us-ascii?Q?9nGFdUTOKuS4FvExgOw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB9345.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce614579-b7e6-40f2-c401-08dddd850276
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2025 11:55:49.7812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mZa9UrxHUYlplKWwYDtLwqmvZ2XELYm4Em+r6BkemU7oWBwL0QDY9L7fqpPNBoqg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9144

[Public]

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Sunday, August 17, 2025 5:10 PM
> To: Jain, Harsh (AECG-SSW) <h.jain@amd.com>
> Cc: davem@davemloft.net; linux-crypto@vger.kernel.org;
> devicetree@vger.kernel.org; Botcha, Mounika <Mounika.Botcha@amd.com>;
> Savitala, Sarat Chand <sarat.chand.savitala@amd.com>; Dhanawade, Mohan
> <mohan.dhanawade@amd.com>; Simek, Michal <michal.simek@amd.com>;
> smueller@chronox.de; robh@kernel.org; krzk+dt@kernel.org; conor+dt@kernel=
.org
> Subject: Re: [PATCH V5 3/3] crypto: drbg: Export CTR DRBG DF functions
>
>
>
> On Sun, Aug 17, 2025 at 04:23:49PM +0530, Harsh Jain wrote:
> >
> > diff --git a/crypto/df_sp80090a.c b/crypto/df_sp80090a.c
> > new file mode 100644
> > index 000000000000..bde5139ba163
> > --- /dev/null
> > +++ b/crypto/df_sp80090a.c
> > @@ -0,0 +1,243 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +/*
> > + * NIST SP800-90A DRBG derivation function
> > + *
> > + * Copyright (C) 2014, Stephan Mueller <smueller@chronox.de>
> > + */
> > +
> > +#include <crypto/df_sp80090a.h>
> > +#include <crypto/drbg.h>
>
> The header files are still missing.

Right, Will fix.

>
> > diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
> > index af5ad51d3eef..4234f15d74be 100644
> > --- a/include/crypto/drbg.h
> > +++ b/include/crypto/drbg.h
> > @@ -144,6 +144,24 @@ struct drbg_state {
> >       struct drbg_string test_data;
> >  };
> >
> > +/*
> > + * Convert an integer into a byte representation of this integer.
> > + * The byte representation is big-endian
> > + *
> > + * @val value to be converted
> > + * @buf buffer holding the converted integer -- caller must ensure tha=
t
> > + *      buffer size is at least 32 bit
> > + */
> > +static inline void drbg_cpu_to_be32(__u32 val, unsigned char *buf)
> > +{
> > +        struct s {
> > +                __be32 conv;
> > +        };
> > +        struct s *conversion =3D (struct s *) buf;
> > +
> > +        conversion->conv =3D cpu_to_be32(val);
> > +}
> > +
>
> Part of the problem is that this header file includes an insane
> amount of stuff that it doesn't even need.  How about moving this
> function into a new header file crypto/internal/drbg.h that includes
> just the bare minimum?

Sure, Will check that.

>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
