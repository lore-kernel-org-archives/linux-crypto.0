Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11022128.outbound.protection.outlook.com [40.93.195.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D0C1DF666
	for <linux-crypto@vger.kernel.org>; Wed,  7 Aug 2024 13:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.128
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723036031; cv=fail; b=cAHspasCKylxSwe/6f6r50yz3V2qkUJk8alhdOKLqp9gpH0RfTsjHjXonZzY4q98s9UmvymnlS4MzMV6JqJmphGRjDudZbpTYVps959QNkQVI2nM4RK0/Q5/DEt45cR48D1q4V187Daozs9dv5oacxl4GNK0Koenu9V0cRyecfs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723036031; c=relaxed/simple;
	bh=rhd4arcm2Hywrju0dYi+zI1x3Czr0z8UvoOxSPmVj9k=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=JBtnWHR1Lrg+qk3qGz3IbSvvWSyk48oaHwgiCuOw8tJiEQRUslnUNGsV4mzgvoPB46pCp+JOctYFEJy7Kcvn5EaKQ8uEf0LzhbpBKFr9ubxkLUlhqN8kfRfH1SOnLJhPM0OG67OGtCrIYrRBjNhPQrUrkptoHJ6pghzmFenBW0M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=YW+C+0AM; arc=fail smtp.client-ip=40.93.195.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="YW+C+0AM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fTabkFIDSc0Rbuyaru2VG7/vwcHZmIOQAdv/P64Sj8+hRYvEB3Fswa9BeIBrab6vT6/Duj9V63OLAStpZ7yErfGjEE8PmUDS8jdUzb3q+zUUFSQL7hzemu18xgSQ/xf4qWl2GhETAwAGHIR2s1yc1dAvTWWV8TxPDgxRDaYdWN2hXMq7JXNvdDo5aFv8J2SYvWUnxB+rlWAsPQah8mACAeHfYjkCloNcNJ/DMmZRQNENEw6yywZjPqJxZBVSEDoS2bEhzZHfxVxdEGdQ2ss8AwgtsPAGwo4xUNj7GVqyyN5fQ7A5M5Ro8d93BbPgGjcIZ0gVWRyLpko2im/QP9KxiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HlvOeU1W9+IUiVMMihzGHuY5yGMz1w43ibaCLipEa24=;
 b=whWSuGBrYQUdBCBwKzl9OVUSeNCbGUefEGm0yzuGCnw1KGtI8900Gstf/bF/6TyrG4rF8Ku4tJzL85PtzwF3/EGPoFvmTsELAffQsRLuGTM412jTh2rV9ZypQhlfgg/Mef/5VE3avWpUVU1ro6irIrny1223muAh8j9lioDy/kBmnUpVPB5wrJbt49tg/sZrPKPMfmxvTBkWuhwAp+hoXEW4EShf4C8tKbmLsrWpNhFtvtjwfKg5Li0WRK1k/5Z3/wWNs+Q2ejZdQq21aR3i8NFQEgrSBhQyzCQUSnFogeSP48P3+GnV3+1yoo1Pnj54yybv5ppar9tRBbQbmkty9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HlvOeU1W9+IUiVMMihzGHuY5yGMz1w43ibaCLipEa24=;
 b=YW+C+0AMYD8iKD2A532QcaRUQG558uGu16BSd6ilf61EhM4BT0YuVa3z2T2rzjwyYcCF4xKrR5xaTi5E/j3bBb9Hc4DEQAMQS7qE9Yx8WP8B6T10wqy7MQyaJSktsX3bwx282UZKvooYAs7Qxx/6NirIQEPRJ3xyNmIiCoWVexw=
Received: from CY5PR21MB3614.namprd21.prod.outlook.com (2603:10b6:930:d::18)
 by SJ0PR21MB2069.namprd21.prod.outlook.com (2603:10b6:a03:398::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.3; Wed, 7 Aug
 2024 13:07:07 +0000
Received: from CY5PR21MB3614.namprd21.prod.outlook.com
 ([fe80::d11b:ce77:339d:3a2c]) by CY5PR21MB3614.namprd21.prod.outlook.com
 ([fe80::d11b:ce77:339d:3a2c%3]) with mapi id 15.20.7875.007; Wed, 7 Aug 2024
 13:07:07 +0000
From: Jeff Barnes <jeffbarnes@microsoft.com>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: Intermittent EHEALTH Failure in FIPS Mode - jitterentropy
 jent_entropy_init() in Kernel 6.6.14
Thread-Topic: Intermittent EHEALTH Failure in FIPS Mode - jitterentropy
 jent_entropy_init() in Kernel 6.6.14
Thread-Index: AQHa6MqKrb+INXlaDUCeVdmHgGvtNg==
Date: Wed, 7 Aug 2024 13:07:07 +0000
Message-ID:
 <CY5PR21MB3614CD163252779D226BA4E7C7B82@CY5PR21MB3614.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY5PR21MB3614:EE_|SJ0PR21MB2069:EE_
x-ms-office365-filtering-correlation-id: 3b0963a7-0995-44ad-60dd-08dcb6e1d70b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?cz7BsfeENXUnO9wM3+vCLM1KjuHklvvmiXdncYz+C5L0d7oYSWhVxqV6La?=
 =?iso-8859-1?Q?T/tT6PPmW0GpxA/hBUrI+qLgp+mOygTbUAJLlwFH0PSP2r5vDjtKJDNZty?=
 =?iso-8859-1?Q?DNbH9sEgli0QSwn0MdFsa1J+/7w8QhT3qEkynDogegZpGHHuzHrHFN0eWC?=
 =?iso-8859-1?Q?gqam3U7xa7EXADm9UqK1FK2XPeGdRMEr8W8ZnNYsX6NDPIs0wmxH4w2YBP?=
 =?iso-8859-1?Q?jERjxy6asSc33qySIb7mxRJbJrVa4AtoxVjhBJYh4t60Maokt+VfrJOS/A?=
 =?iso-8859-1?Q?8aNSYYn5RA6lc7Og1wmxewX6KxGME2F9UT3ZcTa3TXyUl+1jhxgnLcTUd3?=
 =?iso-8859-1?Q?3HGdRKKWpALmyfKi+y64nCNqMKEnNpjWwj07cES0tfdnZ+Y7sU8PClBxk/?=
 =?iso-8859-1?Q?NYfps3/3rZNEsGV/1PTVyIRCGA52X/FGPV7pbQM/5mGs+I69tIGzKsXlcj?=
 =?iso-8859-1?Q?p4MZTqOodTp+08BzIm2ZVBkehRjPb5tra5x1DZpZTSwBV31JcHNEFw7HbP?=
 =?iso-8859-1?Q?UeJv4IqovtxmQFysr7lE/zz0OQRB7U57EN/5Q04PXuDrL3xhTw7LJigtee?=
 =?iso-8859-1?Q?weiJvYs58UWlQP6a54EOJeSA5B3Vp7dZmjhuwEIvlqTo10y+1+SOrAVF1g?=
 =?iso-8859-1?Q?menOH5CYRULL/ntA0k3z3A+qDtbI7Kx/VcKQJffCtAH2LBtLClVpowjUW4?=
 =?iso-8859-1?Q?OoGUUEjLRpcGJy2ImfjfiXttJaZIokW8/ZxevyYguzMr0YiW+GX6eZ2UN9?=
 =?iso-8859-1?Q?NpIMJWepl0WAAKjDpn9yynw15+asrhYNZNp0f3EeZAVwtNBxFh2BAtWrfa?=
 =?iso-8859-1?Q?Q5ckevNe/hV1ThtTxO5unnLESaeHQc/OPxO2jaVWpRJETmhEM1gOPMSM5P?=
 =?iso-8859-1?Q?pDknnIqrH8uHpDP1Vc7yXppqGQzu44YN8o5QtYIntSh03zJVFq6svwXz9o?=
 =?iso-8859-1?Q?1eOcCNIYaAPUjV5vLLFZKNdFbDVNjMtBX0RiUvsI2bY6Fs0b6mzGPYL0WC?=
 =?iso-8859-1?Q?s3PoxYi6fhuDcs/pUOrCC2M/7nOHTSQFWr6cZbehyb1JiSvTBFdfBkAu3z?=
 =?iso-8859-1?Q?2grT3iiVfdbt4CxsX8G4ef+1zW1FdsOprXs+1nxcthzvYPZlg+TDut5G4g?=
 =?iso-8859-1?Q?E1URjMUZoSYYrDdoFLCYQP9cK5h1x1lErEHXl4BWpEDnf/3nbyuMyvF1di?=
 =?iso-8859-1?Q?TVALRhvky50jgD2wY5i2Wt/MyP5r6INzQJJUf2WKRiG+RVGDgCUPJiRNwY?=
 =?iso-8859-1?Q?3KvE54p2D4msVnFmg8KotVkWBXrXM82lim3GxqNlIT1RR/DsRVOwDyba+L?=
 =?iso-8859-1?Q?viHpRF9yadhJpnVyftsSNhlT7RAckFteGJZZBYEXbW+opI8vU7ACnzfpCS?=
 =?iso-8859-1?Q?7BiFBc3gtoa4yad8D5KKsw/OLj5V0Okp7YOHlh3FRKTtSLM3zy4fejOBIb?=
 =?iso-8859-1?Q?WYkRBInvC2DqD0qZpk0/qMoJ71ZyreL7iHNeRg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR21MB3614.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?jlBmyDggY3Fb7gsc22z/y73syUHVV7HVtzKtYEo7oQAhUeiLss61UfU8oy?=
 =?iso-8859-1?Q?Nco9KWpeahJN+iyI0wlfozdGrPxEfAJjL3hB5G7LLaE3EWNFDG1ebJM2Ky?=
 =?iso-8859-1?Q?08U1N9L8/NhiDdIvg4rdQWOISwoeiRE3XhDxb9v3Cl0U0bpXsPxXoPerJA?=
 =?iso-8859-1?Q?9jN8C080NpTd9/bFjpYS1fNWaYBjnYD/AW3Cs+WEzHp57xhcnFFoiliFeD?=
 =?iso-8859-1?Q?x/uSC9ZPHDsA47n+IrwATzmbftgmbQznJWMxJKu7stcQ1vatr8CJ0mMgRP?=
 =?iso-8859-1?Q?TSYdKrYtfgw7sVy+C5tZ7UfpO+mKe1hEEyduFPWrtr4XjlwfwlN1oFvgKu?=
 =?iso-8859-1?Q?G9RanTtOJ+P1mbPyE7EtYMAW/Y0zWWCF7dDnLOIvifg/9IdSj28ZHnOqPz?=
 =?iso-8859-1?Q?h1M6WwdTWeyPEVIzXVYYzuSRTIx3f1qABb/nihvmnhKth1+oagNAn0eqnx?=
 =?iso-8859-1?Q?7SLUqCzYXivi8tYqBn8yJBPUDNj713xRCTHOOGQ52D/3sLeN5RNk29DsYV?=
 =?iso-8859-1?Q?JqgDY2R3bLZkV859PGPELhgSyuLFENSbL7KSo1WtiC7lrJDQ45ZcZGsVUR?=
 =?iso-8859-1?Q?PmamEq2FMERPC67CQ9R4eU3AV2qIh2SUpIfMt1iLc9lRFybJIxyLxtk3p9?=
 =?iso-8859-1?Q?c/VfmDDTkKRPImVcBob+oINOPgE271USB6EwLmYSiB+PKk1h8v1xBz06u3?=
 =?iso-8859-1?Q?Ad115O34NPoMTTy4w65TiFamE4z/k9vzJohyKdrrISR+5fmilalJ4UgjBg?=
 =?iso-8859-1?Q?qhobAnTA6gqSutjw/Lg9KT7iN5JkHFxEditc0xdLx4M6vMiu4eDUm3MKlA?=
 =?iso-8859-1?Q?ypyg7ihDQaqmxxfD1TYwfBfdUnIHR9sf+J7JYTQoXB3BE9lRGUWzs462+m?=
 =?iso-8859-1?Q?gjfPthK40g0ByaDNtn1SeekniJWKdn++h351dhSr5wRV6zuQUKjLCextgj?=
 =?iso-8859-1?Q?zegQV7exgYZv0d6TXL9BdfNv77OcZi3eTvFH9CFimO+riVp3ZMpQE3xLuw?=
 =?iso-8859-1?Q?7RKcFuxnzAjMH6GWHn062TelYTjBodTffYnrMdljzXybMvQdjcTErdvuKV?=
 =?iso-8859-1?Q?9KxE9aAUgJv/TO0AEu2vPfVQpbFdyYHQxDtHS70OrJKFUNs5AK7jNuPa3v?=
 =?iso-8859-1?Q?RSZosasvervmOjVLYKP9XUQZKKOZpUyl6dBpBnQ/QbC5A9HJlPqiD7a4qy?=
 =?iso-8859-1?Q?Skp2qZoPwyXFlDWzhsZs03M7Iwk1X3XC5GqVDhQd/wxC4ZSysy2aatKAt6?=
 =?iso-8859-1?Q?v5b+bW7QV6QcBWSavgOTL+qOqU1PlpIIl5oFY7G4pzUW85zkYAVwMunB82?=
 =?iso-8859-1?Q?49L+hLofPeJYUJR7eYdN8NxMSoAv+1lYSQkB7T+3RxeyeISl83Swx02iH1?=
 =?iso-8859-1?Q?0nipQN1Od6amNlaK81TQVwMrM4bvIsWcX3RdUNXAJBotRtFJ0zIdYWlpTu?=
 =?iso-8859-1?Q?MGLwod6YT99jEDZrjqSjUiiRced1tGlAUl8GYfXyqM0RA6TmJE8d935xGF?=
 =?iso-8859-1?Q?RWU+sZVomabFY/rDg6+Mjvdgjg/1j7DzgZXxNxldFUI52cX+lpyGgfG6Sn?=
 =?iso-8859-1?Q?Oc0Y4O6gjxJp+Cjh8WjWvwhvjXb1WDyeVX9vhQxHnsTqdBFYbA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY5PR21MB3614.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b0963a7-0995-44ad-60dd-08dcb6e1d70b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2024 13:07:07.0911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BVrUYcdLmKumO/A4VygsIVf3aOA5GEUcUkBaMCxA5Yqs+X1kMb11GDAxf1+GxCmToUgVmG/9zU8QaLN43E8A9T0ANFofcRS90qVoqiwF6P0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB2069

Resending in plain text=0A=
=0A=
Hello,=0A=
=0A=
We are currently migrating to kernel 6.6.14 and encountering intermittent E=
HEALTH errors that cause a kernel panic in initrd (FIPS mode). The error oc=
curs in the following section of the code:=0A=
=0A=
crypto/jitterentropy.c=0A=
722                 /* Validate health test result */=0A=
723                 if (jent_health_failure(&ec))=0A=
724                         return JENT_EHEALTH;=0A=
=0A=
This is called from jent_mod_init():=0A=
=0A=
337         ret =3D jent_entropy_init(desc);=0A=
338         shash_desc_zero(desc);=0A=
339         crypto_free_shash(tfm);=0A=
340         if (ret) {=0A=
341                 /* Handle permanent health test error */=0A=
342                 if (fips_enabled)=0A=
343                         panic("jitterentropy: Initialization failed wit=
h host not compliant with requirements: %d\n", ret);=0A=
=0A=
We are experiencing up to a 90% failure rate.=0A=
=0A=
In my troubleshooting efforts, I followed the call to jent_condition_data()=
 and attempted to increase the SHA3_HASH_LOOP to give the CPU more work, ho=
ping to collect more entropy:=0A=
=0A=
356=0A=
-#define SHA3_HASH_LOOP (1<<3)=0A=
+#define SHA3_HASH_LOOP (1<<4)=0A=
=0A=
This adjustment reduced the failure rate to 40-50%, but the issue persists.=
 It is intermittent. It is also intermittent without the change. Sometimes =
I get a 90% failure rate on 10 reboots, sometimes 0%.=0A=
=0A=
Given the difficulty in reproducing the kernel panic consistently, is there=
 a more effective workaround or solution for this problem?=0A=
=0A=
Your assistance is greatly appreciated.=0A=
=0A=
Best regards,=0A=
Jeff Barnes=0A=
