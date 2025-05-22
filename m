Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B05F28C5C6;
	Thu, 22 May 2025 18:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747936808; cv=fail; b=aN+6dDxygI5Vq6h1f6QdR6Vkg2EqUiy1+COzyX6s30RYrx/ctLrkJtwk6NHhZusZzrX1pvS6He4chbG4iK8M8Zv5eZmB/aRH+emwjObcjAZJj1+gxlUucHm3uyhgBbmeEtTKvk4l535rl6GlZpyf0YgDOyEzKmeCyhMBNf3zUMM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747936808; c=relaxed/simple;
	bh=e3OKP8DkThJhjtY1bs8yDtW4ckKAqLOD5Tj4TJjWmb0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HMUapcf/SxeRdtNiHA8Q+qiHLLcG7sy46gJsuHS34Wuq7ydlP8Gqp7aLua44hLXhN8APM8e5r+ntukPalWNNFHGrUhwoebPfi2U8mI4YNiYUHDJCJx/jF3YGsjQRrqqAmvI074E2z1Hr+wJ3Fq3yuZP9C5I4olgQ0DIXa62LEFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gC6tsyWg; arc=fail smtp.client-ip=40.107.237.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gC6tsyWg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fOdbJCeX8V+9UiPQ9GFHjyu8sGNhpBW7t3XxwUwhnrwNIgyHndMpCakK5btBs1h5qiajfTtCjS18/c/zOXvPM3pIji4z64wr8fvJPEfEVH92GEI/RyrR2uGDgbGUjJxGbsZcgeF9cBDHixLTiHofr30TnUWJGAAZ+YlH6zel98wWHpyYKOgholHWmEcyJ6SJ42yS21Pj6iv/8d9e5V953VjJAoi+7n6e6ITjncBU7KCOAwhl9SwWoRAnueozmVmxR9dmej9w+V5Kvfu222g203g946zu5AmG7GTr7i6udYxXhW0E0h37IZy2CinsSMPQQDeuURdMjxbhIPckIK3ciw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e3OKP8DkThJhjtY1bs8yDtW4ckKAqLOD5Tj4TJjWmb0=;
 b=tHEDmZ6+B7lnFuGsN6iHXywikTekEJ7+yMsvBQEEv8uW/yFbimI8GNNZeQizpvfohQFp0EjTVvqc1UBuJbmF3VPbNNeX7mhL2xB2StyXa5+W8VwygUpFeSiD/eZ7n/bLdH7KGI1iF21VAk0ononqNFFqe9EehSK8q7Q/M30TDtYnG3Wv84Y1xtV8ZE/QNVnpJP68lnrkdjGL/letWn6Jz/JC0KOGIV6HVOMbAsy74NMY1QyPLkCjFedBOdhTT8J6r5rRFAyBX+yFsexH8w3UoVmcjnLG7l3vEHz3jRgTX8ik68PzWNo8+0JMKuNJTsbJ7C6LCDjoxMUz16MPRR6prQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e3OKP8DkThJhjtY1bs8yDtW4ckKAqLOD5Tj4TJjWmb0=;
 b=gC6tsyWgF0ODFedN1FQr14FowR0eBZST9bgfsyCO0oL90uPVRAGwA5GLuFveUOmpoQbfdPpR5e6VFP+p+WLXJJ9aX6b2KgG7RtA9Q0VLuKOoDoEEju7/4IhalYT6W92T4LVeFAeqm8OVFRTU615FDkoGQ/PV/DrFP9rT4dJvAzAaH+uQMICVFfZZJYzBLVJVbGvEQf/m/v+0OvtNVLM3O3bATbDw1M3x/BQcIRsdCYT/VG5gx07goDYD+kwSALI99R/p8EbENNC4/soRQ3CvY+dYCd0/d0LLSQOYbKwU6zf/tpbn+/SDs+YQ+UR29O899BkZ5P47Y8HhsNLKS3Zs0Q==
Received: from DS7PR12MB5719.namprd12.prod.outlook.com (2603:10b6:8:72::16) by
 LV2PR12MB5797.namprd12.prod.outlook.com (2603:10b6:408:17b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Thu, 22 May
 2025 18:00:03 +0000
Received: from DS7PR12MB5719.namprd12.prod.outlook.com
 ([fe80::2e4a:1df3:8c8a:f53d]) by DS7PR12MB5719.namprd12.prod.outlook.com
 ([fe80::2e4a:1df3:8c8a:f53d%4]) with mapi id 15.20.8746.030; Thu, 22 May 2025
 18:00:02 +0000
From: Ron Li <xiangrongl@nvidia.com>
To: =?utf-8?B?SWxwbyBKw6RydmluZW4=?= <ilpo.jarvinen@linux.intel.com>, Herbert
 Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC: Hans de Goede <hdegoede@redhat.com>, Vadim Pasternak <vadimp@nvidia.com>,
	Khalil Blaiech <kblaiech@nvidia.com>, David Thompson
	<davthompson@nvidia.com>, "platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1] platform/mellanox: Add mlxbf_pka driver for BlueField
 Soc
Thread-Topic: [PATCH v1] platform/mellanox: Add mlxbf_pka driver for BlueField
 Soc
Thread-Index: AQHbxdBOF6Y3K2UCAU+TuMyhglt9BLPU+6gAgAn+WmA=
Date: Thu, 22 May 2025 18:00:02 +0000
Message-ID:
 <DS7PR12MB57191E5CCC239A43370B8729A999A@DS7PR12MB5719.namprd12.prod.outlook.com>
References: <20250515193234.2436452-1-xiangrongl@nvidia.com>
 <c85784ee-5f06-6d7a-377e-07db7af8bd35@linux.intel.com>
In-Reply-To: <c85784ee-5f06-6d7a-377e-07db7af8bd35@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR12MB5719:EE_|LV2PR12MB5797:EE_
x-ms-office365-filtering-correlation-id: 9be27f2a-f1a3-450a-6080-08dd995a79f4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?czMxWXd3T1ExRStwYU42OENrM3dyTUNIaFExdFhZZjhhWk9pOHRPeWY0d3gx?=
 =?utf-8?B?VVptUXlyWlpmMVA3a1YzUzJuMEtXY3ZoNTcyWGtpTmVUMlJtY2xBSmNlWUlP?=
 =?utf-8?B?c1ZISUgyMUFBcEZiSGp6a2NVQlAveDR2Q2EyTWNuckN2dHNmWGtzdFNzbzVn?=
 =?utf-8?B?L3R1cm9oekNuR1UySnlCTmlMNkZvY1N1V0NXR1ZxKzBsczFQNkZFRHIzL2lW?=
 =?utf-8?B?TDk0K3FQdk9XK0oyaklISzhqcll0VmhGanlGZ3VEWjBrcWVzSXUrZWhiUlZm?=
 =?utf-8?B?UWtDbGdXZmNlZDkzb1dMVEtaaXgwemh6VnBWRTVaT2M1dStyZVFwN0NBTHEx?=
 =?utf-8?B?QjVITXBMdTRDMzEyVGZrenJWeGNyd2d2TldlSmZmOHhrcjNOUmtRQWx3bDBT?=
 =?utf-8?B?b2pJTjExdWlaK1FOQmJEeDhIdldJN0tkbjdEZk5XTDhSWnBGWGhaaU9BL1ZB?=
 =?utf-8?B?QVBrMUx3OU04TVVPY1RoMlRQVUZhdVpHWFQrck5neGIyc25lb2JqNkw3R0g3?=
 =?utf-8?B?cVprdHJ1RnB4ZG5rTVp6cUdqUnJEOFpZVDZvTjltYzFlTkdEaE5Nb3djK0J5?=
 =?utf-8?B?dEFMMlRudkxmYS9ndytDRFk0VU9XRkVQNEh0L2gzSXZjSHpXanlHZ0svU3V0?=
 =?utf-8?B?SE5Mb294eXNKTGF4eDUwYXdCMHcwazBxS0JENmdoSG1nNSs0amRXS2Q4eTZ5?=
 =?utf-8?B?R0lydCswYU5Da1lHK3JhNXhaakhMS2l5endPWndudURNOE53blVzYXZkUEY3?=
 =?utf-8?B?emMwaWFvT2hBUFM0bXFUeXlKY2NkZzgrRXhxUTYxSEdLK0cyTFdkWVFBTFE1?=
 =?utf-8?B?VkVXalFzTWpENGw1SG0rd24raE9icE5OaWkzVGpQdjNJcnQ2Q1RnRlZWSUEx?=
 =?utf-8?B?YUNFZGE2cVRRU2VackFOUTZtWWp5VUxBMEhLVmxDRXBEaU5LZmV5c1pIelFm?=
 =?utf-8?B?c1I5MHU5WjkybVk2NDFXeUkwYVZEQ3BKT2NRUXlZT3B2bGlJcFpNam5qMUI0?=
 =?utf-8?B?bjRpQk10QUd5c0pjejdWdmlUQUlhd3psMll2eDlBZ0Rxay8wV1ptTDlMN0dm?=
 =?utf-8?B?OStPNXUxZlpiWk1wUk1GWCs3aEw1dWt0MStUd0h3RTRlbmlBd3BMUlA1Rm1K?=
 =?utf-8?B?cDBqRlJuay9nZmJYMjN0S2tIcUl4ZkZyeDlSbGlRenZsYzVxRC9JZDQxREN0?=
 =?utf-8?B?RDZmVlM2NkRLTGUwMnpDaCs2UE9NTWNUelJpcDVhdDZvYjF4YXM2MzhOQnlF?=
 =?utf-8?B?ZTBCbm9YdUFYT29aT1FPNlBnN2NBSng4WGZvVXdBcnVxa1lpMW1iV0ZGWFpq?=
 =?utf-8?B?VTc1ZlBSR2NKZFZBdHRORHgvNHFHREZ2WVllY2hWZjJBRmJMSHpNa1hHYzRi?=
 =?utf-8?B?T0UxNWVSdUM0NFdaMnRCcm42aFZ4cW9pS0loQ3JGTitBUk5Qanh6YnFROG5u?=
 =?utf-8?B?Z1NnWkx3YTBCa0pQeEtEdndtZDdHN08wU2ttVnFIbVppV05yNmRKaWxtbEtK?=
 =?utf-8?B?cGdCdjBrSmlwaXZPTWhGYUlHSGcwbnM4bXI0YnlXS1JkTUNMVStSSnZZZFlk?=
 =?utf-8?B?N3puWXNhVlpUNTRuQUoyYWRjQVd5T3Y1M01kT2lVc01WWFFVYlRwRlF0V1hp?=
 =?utf-8?B?MEo0QnlrSWdHRFBraXhLSUNzS3QwZkZITWRKT0RRRlQyWHZxbGlXSnluT045?=
 =?utf-8?B?Mll5UTZuSVRUeCs1dlR0NlJHcEpWV3RtSWJmUWJWTWxML2tXRnJMTzNMRE90?=
 =?utf-8?B?enFCVGh5Q3VXaUVIbXV4Ui9vYTY3UGVmU2J1STg4Z1EvTGhOSTRrY0hiVGhl?=
 =?utf-8?B?UW9FZ1MrRktwUXFlLzBhRldxKzh6a245ajgyWXc2bGVuUmJaVjdWeFJEWHgx?=
 =?utf-8?B?RDJnbXJlM1YxV3JSR2NmUXVlcmVZcSt1Q1JycGhtUnZMTXdHS2FhMFIwMS9y?=
 =?utf-8?B?SFNRYityTGluWURDTlc4SVE1M3lIRlFVNUdlZUJoYkdnRDFzbFl6ZU9oZmFs?=
 =?utf-8?B?bVRYRXdZRkN3PT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB5719.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Ky8ySmlHTmlScHpIQWZvcGpCQTBBTFJOeXY5Ly9xc0RaNG1VUkYrT3F5OEJS?=
 =?utf-8?B?TXJ4WWk0RmpDM0VqRWdRNUdGTHlYOUZIbWRtSjZvSXpqcDdIQzd1NU5yL0Zw?=
 =?utf-8?B?YXhNN1ZrWU81TjFNdUM5SnYvbXEyZDd5a0tsMXdaRWo2cE5ST1IvWHhJMFJP?=
 =?utf-8?B?VWdzTTlPbEQ5VFBYWkNVb29XWFJ2UHhaVWxJeVVzNHNXY3IxWHRGN3dQVWlp?=
 =?utf-8?B?aEFXVUZsSmQxSUd5WCtuSVBzNGdSRUViaGFidFc1ZEhENEVrMzNzbGtNQVFG?=
 =?utf-8?B?UzBZSXRJYkltV1VpRkNzRCsrY2E0QVppc3pHc0Npb3lMeGhJSTB0S2UzOHlO?=
 =?utf-8?B?RStadEs4dmpSbk5SWFRvdnFkdVR2OGRzWEJYOUsxdFVCNWZOa0lKei9id2pq?=
 =?utf-8?B?NXVwWU01aVY2VlJKQVBxVUpSYkx1QWJKa21XNFdmcmhMcEVnNjFYNE5na1pQ?=
 =?utf-8?B?KzhBQ3RPbE8xUGtqZ1NUaDV2V1BUSC92Q0M1MWhKeGtuK214ZDlsaXdqdFVX?=
 =?utf-8?B?MUVhelBOb0puVHdMbzR4ZUJBdUxpeEh4NVdZMVBlY0VUZkdKWkxwMHNCVmZQ?=
 =?utf-8?B?bWlZNGZvVHpHd0R2c25BazhJUXZEYTFzZHBsQ0lDeEkwK3dzNlBETUJ5cEtV?=
 =?utf-8?B?WUdZZXoxMm4xZ2hTYjV1ZnFRK0NSY0ZIbm5odzB1UGtGTHpzdjJOSGxZV0p3?=
 =?utf-8?B?K1N6K1VTNHZETjA4UlBKOVdUaCs0TjZncWZURW85YW1XZmE4NHUveFVsdUc5?=
 =?utf-8?B?WDBZdVErcGNsb0tSY3ExWGJqRUcxcTZXTGJLeGtXQTN1ZldwRGZxbm9aZzFi?=
 =?utf-8?B?MkhnVFI3bHBaaWErY3gwYm0vaVlOaGZPWGkxQ3FGS1E0eXBLMDNWaEZGV2M3?=
 =?utf-8?B?M1B3Q1VpZjFYOVB4TlNKODBIaVI3SnZVeUwwY2dMMWJtbWJIUW55MExXWUY5?=
 =?utf-8?B?UjdrWFBDK2tSVVcvZy9zZXRsNHZlWXo1N1dSdUlpTXpVa0xsWkdjN1h2Rldw?=
 =?utf-8?B?ZDlJSlc0QWtRd0swNGVEY25UdUc1TTYyaDNYYWJ3T2lsc1RDWEkwU0lvT1A5?=
 =?utf-8?B?Zm9SRXJUWlRGa09WNDNQOTk2RlFJZE85V2s0bnExYXdTWE9ML3FxTFltSElJ?=
 =?utf-8?B?VG9TS0h1OUlOSEFaRHFaZHp1d1crbTRVcHBpWkl2OFgrSmJCcHl3T2hldDE0?=
 =?utf-8?B?cGZmYU5BSm95TVRqeFZPbm42U0VlZjU0MVVVQjZpNCtsL0tmZGl5OUJyNS9q?=
 =?utf-8?B?RFBFNVRlR3RyQy9nd2tZbktSSm5FVG9nTXlGbHFvOXJsS3M0QVBQTmd0WXJx?=
 =?utf-8?B?aTFvd04ra0RGMHBYdmdMUG9EZXhoZTVyUTYwYThZdUF2a3Q3cDk0Vk94RGhZ?=
 =?utf-8?B?UmNHeFBNbU5QL2pmRFY3NDBPSG82bTJiMlB2QkdNOXRqZlA1SkxZSXcvMDlh?=
 =?utf-8?B?YjR6S3k5Zjd0Y2QwcldDQlJiaDExdmZzWm1qbDJXYkZ0a1p1RW9iOVZLOXJn?=
 =?utf-8?B?d0lUVnNlK1dUaFlMSzBlbjA4ZmxYSkQ5NTdhMThlaUZUYjJ4L0JZMHJBVjFs?=
 =?utf-8?B?M3ZFVjRQTWxvVTRYd2E0emxHb09oVWVITUlUM3oyRlplTGJNTVlLN3diSDhv?=
 =?utf-8?B?Nit2QW11cFhBUUg1WlNJWE1DeGhPek5pYkVDUFZmbkM1RHRhbHJOZWpabXhS?=
 =?utf-8?B?TUxlcXVVQjBKODJLUE83TzkyQ0JLY3BBaWFKb1ZFVkVEeXFnalYvdXB1M0kx?=
 =?utf-8?B?SUlXTXVCMVBjR0x2ZFNvZUVidkV3Z3F0cDVGZXE5TXNVSTJ0N2U0MlF1R1Rm?=
 =?utf-8?B?NXlaekFHWTh3NUhnaWpYRWNWZjVzWU9sbmViZlluTmhRNlF3NnI1RFU1bXBx?=
 =?utf-8?B?a0FkU1hxTkEvR2pHSkRFQ3lnaTV5TCtXdGZlZHgrQXJCRGxvQWU4U1RUdHhr?=
 =?utf-8?B?TFZHekdZMitVU0l3dU1DMHFQRGEvR1VtMnI1am9zSFVqOVZ1a1lUbTNCY0Yz?=
 =?utf-8?B?WHFqRHlzeEdUaUtFNE5VQVoxVEFUeUdRY1JQRWtCZHdDazVEVVpscWhQV1ZC?=
 =?utf-8?B?K2Y1SGlXZUplQ2xWNUV1eXNwWWxGV1ZSaFlVQmVTbXVXNWNzcUp5bW9FNUxQ?=
 =?utf-8?Q?XyLIET9NipmvtU09uYYXMD4dO?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB5719.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9be27f2a-f1a3-450a-6080-08dd995a79f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2025 18:00:02.8258
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ckjnfkzvhyLnjr2Ap9NuTxzpdcRk6sGNxdfg50ESAQOMViCLq6G3V2OFw65FdwLqtAZcpizXqpumG93NCLJ3dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5797

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSWxwbyBKw6RydmluZW4g
PGlscG8uamFydmluZW5AbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBGcmlkYXksIE1heSAxNiwg
MjAyNSA1OjIwIEFNDQo+IFRvOiBSb24gTGkgPHhpYW5ncm9uZ2xAbnZpZGlhLmNvbT47IEhlcmJl
cnQgWHUNCj4gPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT47IERhdmlkIFMuIE1pbGxlciA8
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47DQo+IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmcNCj4g
Q2M6IEhhbnMgZGUgR29lZGUgPGhkZWdvZWRlQHJlZGhhdC5jb20+OyBWYWRpbSBQYXN0ZXJuYWsN
Cj4gPHZhZGltcEBudmlkaWEuY29tPjsgS2hhbGlsIEJsYWllY2ggPGtibGFpZWNoQG52aWRpYS5j
b20+OyBEYXZpZA0KPiBUaG9tcHNvbiA8ZGF2dGhvbXBzb25AbnZpZGlhLmNvbT47IHBsYXRmb3Jt
LWRyaXZlci0NCj4geDg2QHZnZXIua2VybmVsLm9yZzsgTEtNTCA8bGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZz4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MV0gcGxhdGZvcm0vbWVsbGFub3g6
IEFkZCBtbHhiZl9wa2EgZHJpdmVyIGZvciBCbHVlRmllbGQNCj4gU29jDQo+IA0KPiBFeHRlcm5h
bCBlbWFpbDogVXNlIGNhdXRpb24gb3BlbmluZyBsaW5rcyBvciBhdHRhY2htZW50cw0KPiANCj4g
DQo+IE9uIFRodSwgMTUgTWF5IDIwMjUsIFJvbiBMaSB3cm90ZToNCj4gDQo+ID4gQWRkIHRoZSBt
bHhiZl9wa2EgZHJpdmVyIHRvIHN1cHBvcnQgdGhlIEJsdWVGaWVsZCBTb0MgUHVibGljIEtleQ0K
PiA+IEFjY2VsZXJhdGlvbiAoUEtBKSBoYXJkd2FyZS4gVGhlIFBLQSBwcm92aWRlcyBhIHNpbXBs
ZSwgY29tcGxldGUNCj4gPiBmcmFtZXdvcmsgZm9yIGNyeXB0byBwdWJsaWMga2V5IGhhcmR3YXJl
IG9mZmxvYWQuIEl0IHN1cHBvcnRzIGRpcmVjdA0KPiA+IGFjY2VzcyB0byB0aGUgcHVibGljIGtl
eSBoYXJkd2FyZSByZXNvdXJjZXMgZnJvbSB0aGUgdXNlciBzcGFjZSwgYW5kDQo+ID4gbWFrZXMg
YXZhaWxhYmxlIHNldmVyYWwgYXJpdGhtZXRpYyBvcGVyYXRpb25zOiBzb21lIGJhc2ljIG9wZXJh
dGlvbnMNCj4gPiAoZS5nLiwgYWRkaXRpb24gYW5kIG11bHRpcGxpY2F0aW9uKSwgc29tZSBjb21w
bGV4IG9wZXJhdGlvbnMgKGUuZy4sDQo+ID4gbW9kdWxhciBleHBvbmVudGlhdGlvbiBhbmQgbW9k
dWxhciBpbnZlcnNpb24pLCBhbmQgaGlnaC1sZXZlbA0KPiA+IG9wZXJhdGlvbnMgc3VjaCBhcyBS
U0EsIERpZmZpZS1IYWxsbWFuLCBFbGxpcHRpYyBDdXJ2ZSBDcnlwdG9ncmFwaHksDQo+ID4gYW5k
IHRoZSBGZWRlcmFsIERpZ2l0YWwgU2lnbmF0dXJlIEFsZ29yaXRobSAoRFNBIGFzIGRvY3VtZW50
ZWQgaW4NCj4gPiBGSVBTLTE4NikgcHVibGljLXByaXZhdGUga2V5IHN5c3RlbXMuDQo+ID4NCj4g
PiBUaGUgUEtBIGRyaXZlciBpbml0aWFsaXplcyB0aGUgUEtBIGhhcmR3YXJlIGludGVyZmFjZSBh
bmQgaW1wbGVtZW50cw0KPiA+IGZpbGUgb3BlcmF0aW9ucyBzbyB0aGF0IHVzZXIgc3BhY2UgbGli
cmFyaWVzIGNhbiBieXBhc3MgdGhlIGtlcm5lbCBhbmQNCj4gPiBoYXZlIGRpcmVjdCBhY2Nlc3Mg
dG8gYSBzcGVjaWZpYyBzZXQgb2YgZGV2aWNlIHJlZ2lzdGVycy4gVGhlIEFybSBjb3Jlcw0KPiA+
IGludGVyZmFjZSB0byB0aGUgUEtBIGhhcmR3YXJlIHRocm91Z2ggcmluZ3MgYW5kIGEgNjRLQiBt
ZW1vcnkga25vd24gYXMNCj4gPiBXaW5kb3cgUkFNLiBUaGVyZSBhcmUgbXVsdGlwbGUgUEtBIGRl
dmljZXMgb24gdGhlIEJsdWVGaWVsZCBTb0MuIEluDQo+ID4gZ2VuZXJhbCwgZWFjaCBQS0EgZGV2
aWNlIGhhcyA0IHJpbmdzLCAxIHdpbmRvdyBSQU0gYW5kIDEgVHJ1ZSBSYW5kb20NCj4gPiBOdW1i
ZXIgR2VuZXJhdG9yIChUUk5HKS4gVGh1cywgdGhlIGRyaXZlciBoYXMgYmVlbiBkZXNpZ25lZCB0
byBwcm9iZQ0KPiA+IGVhY2ggUEtBIGFuZCBlYWNoIGluZGl2aWR1YWwgcmluZyBpbnNpZGUgYSBn
aXZlbiBQS0EuIEl0IGFsc28gcmVnaXN0ZXJzDQo+ID4gdGhlIFRSTkcgdG8gZmVlZCB0aGUga2Vy
bmVsIGVudHJvcHkgKGkuZS4sIC9kZXYvaHdybmcpLiBUbyBpbXBsZW1lbnQNCj4gPiBzdWNoIGRl
c2lnbiwgdGhlIGRyaXZlciBjcmVhdGVzIGluZGl2aWR1YWwgZGV2aWNlIGZpbGVzIGZvciBlYWNo
IHJpbmcNCj4gPiBhbmQgVFJORyBtb2R1bGUuIFRoZSByaW5nIGRldmljZSBmaWxlcyBhcmUgaWRl
bnRpZmllZCB1c2luZyB0aGVpciBpZHMsDQo+ID4gaS5lLiwgL2Rldi9tbHhiZl9wa2EvPHJpbmdf
aWQ+Lg0KPiA+DQo+ID4gVGhlIG1haW4gZHJpdmVyIGxvZ2ljIHN1Y2ggYXMgcHJvYmUoKSBhbmQg
cmVtb3ZlKCkgYXJlIGltcGxlbWVudGVkIGluDQo+ID4gbWx4YmZfcGthX2Rydi5jLiBUaGUgUEtB
IHJpbmcgZGV2aWNlIG9wZXJhdGlvbnMgYXJlIGFsc28gaW1wbGVtZW50ZWQgaW4NCj4gPiB0aGlz
IHNvdXJjZSBmaWxlLCBzdWNoIGFzIG9wZW4oKSwgcmVsZWFzZSgpIGFuZCBtbWFwKCkuDQo+ID4N
Cj4gPiBUaGUgbWx4YmZfcGthX2Rldi5jIHNvdXJjZSBmaWxlIGltcGxlbWVudHMgZnVuY3Rpb25z
IHRvIG9wZXJhdGUgdGhlDQo+ID4gdW5kZXJseWluZyBQS0EgaGFyZHdhcmUsIHN1Y2ggYXMgVFJO
RyBvcGVyYXRpb24sIFBLQSBoYXJkd2FyZSBJL08NCj4gPiBhY2Nlc3MsIFBLQSBtZW1vcnkgcmVz
b3VyY2Ugb3BlcmF0aW9uLCBldGMuDQo+ID4NCj4gPiBUaGUgUEtBIGRyaXZlciBpcyBhIGxpZ2h3
ZWlnaHQgZHJpdmVyIHRoYXQgaW1wbGVtZW50cyBmaWxlIG9wZXJhdGlvbnMNCj4gPiBhbmQgbWFw
IG1lbW9yeSByZWdpb25zIG9mIHRoZSBQS0EgaGFyZHdhcmUgdG8gdXNlciBzcGFjZSBkcml2ZXJz
IGFuZA0KPiA+IGxpYnJhcmllcy4gVGhlcmUgaXMgbm8gaW4ta2VybmVsIGNyeXB0byBzdXBwb3J0
LiBUaGVyZWZvcmUsIHRoZSBQS0ENCj4gPiBkcml2ZXIgaXMgaW5jbHVkZWQgdW5kZXIgZHJpdmVy
cy9wbGF0Zm9ybS9tZWxsYW5veC4NCj4gPg0KPiA+IFRlc3RpbmcNCj4gPg0KPiA+IC0gU3VjY2Vz
c2Z1bCBidWlsZCBvZiBrZXJuZWwgZm9yIEFSTTY0Lg0KPiA+DQo+ID4gLSBUZXN0ZWQgQVJNNjQg
YnVpbGQgb24gc2V2ZXJhbCBNZWxsYW5veCBCbHVlRmllbGQgMiBhbmQgMyBTb0MgYm9hcmRzDQo+
ID4gdGhhdCBpbmNsdWRlIHRoZSBQS0EgaGFyZHdhcmUuIFRoZSB0ZXN0aW5nIGluY2x1ZGVzIHRo
ZSB2YWxpZGF0aW9uIG9mDQo+ID4gdGhlIFBLQSBoYXJkd2FyZSBleGVjdXRpb24sIHJhbmRvbSBu
dW1iZXIgZ2VuZXJhdGlvbiBhbmQgcHVibGljIGtleQ0KPiA+IGFjY2VsZXJhdGlvbiBwZXJmb3Jt
YW5jZS4NCj4gDQo+IEhpLA0KPiANCj4gV2UndmUgdGhlIGluLWtlcm5lbCBjcnlwdG8gZnJhbWV3
b3JrIGJ1dCBJIGRvbid0IHNlZSBhbnkgYXR0ZW1wdCB0byBidWlsZA0KPiBpbnRvIHRoYXQgZnJh
bWV3b3JrIEFGQUlDVC4gV2h5IGlzIHRoYXQ/IFlvdSBicnVzaCBpdCBvZmYgYXMgIlRoZSBQS0EN
Cj4gZHJpdmVyIGlzIGEgbGlnaHR3ZWlnaHQgZHJpdmVyIC4uLiIgYnV0IGxldHMgc2VlIGlmIHRo
ZSBjcnlwdG8gcGVvcGxlDQo+IGFncmVlIHdpdGggdGhhdCBhcHByb2FjaCAoSSBhZGRlZCB0aGVt
KS4NCj4gDQo+IChQbGVhc2UgYWxzbyBDYyBjcnlwdG8gcGVvcGxlIGluIGFueSBmdXJ0aGVyIHN1
Ym1pc3Npb24uKQ0KPiANCg0KSGkgSWxwbywNCldoaWxlIEkgYW0gd29ya2luZyBvbiB1cGRhdGlu
ZyB0aGUgUEtBIGRyaXZlciBhY2NvcmRpbmcgdG8gdGhlIHJldmlldyBjb21tZW50cywNCkknZCBs
aWtlIHRvIGZpcnN0IGFuc3dlciB0aGlzIHF1ZXN0aW9uIG9mIHdoeSB0aGUgUEtBIGRyaXZlciBp
cyBub3QgYnVpbHQgaW50bw0KdGhlIGNyeXB0byBtb2R1bGU6DQoNClRoaXMgUEtBIG1vZHVsZSBp
cyBhIHBsYXRmb3JtLXNwZWNpZmljIGltcGxlbWVudGF0aW9uIHRoYXQgYWxsb3dzIHVzZXIgc3Bh
Y2UNCmRyaXZlcnMgdG8gcmVhZC93cml0ZSB0aGUgQmx1ZUZpZWxkIFBLQSBoYXJkd2FyZSByZWdp
c3RlcnMuIEl0IGRvZXNu4oCZdCBvZmZlciBhbnkNCmNyeXB0byBzZXJ2aWNlIHRvIHRoZSBrZXJu
ZWwgb3IgaW1wbGVtZW50IGFueSBjcnlwdG8gQVBJLiBUaGUgUEtBIG1vZHVsZSBhbHNvDQpuZWVk
cyB0byBoYW5kbGUgaGFyZHdhcmUtc3BlY2lmaWMgb3BlcmF0aW9ucyB0aGF0IGFyZSBub3QgY292
ZXJlZCBieSB0aGUNCnN0YW5kYXJkIGNyeXB0byBpbnRlcmZhY2VzLiBJbiBhZGRpdGlvbiwgdGhl
IFBLQSBtb2R1bGUgaXMgdGlnaHRseSBpbnRlZ3JhdGVkDQp3aXRoIGl0cyBzcGVjaWZpYyBoYXJk
d2FyZSBhbmQgdXNlIGNhc2VzLCB0byBhY2hpZXZlIGJldHRlcg0KcGVyZm9ybWFuY2UuDQo=
