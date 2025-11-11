Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013040.outbound.protection.outlook.com [40.107.201.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25890359717;
	Tue, 11 Nov 2025 11:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762861249; cv=fail; b=l5phl/7pw7Cupu0fmU5tHHvPr/4jZteUPmeHEhiu4HaXHOlx06F8EqGRlKYLDhlLw/JdhhHSCNoDrLym1iVfA7/MHDuL2LByQPdQeQIVvEiVlAq2Dzxgd/G7esY23nPw+SkwJIpeHq0pE1BFSwzszeRXXWKfFyi9BPBlUDpRjyY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762861249; c=relaxed/simple;
	bh=zqLwgTvXeaIcCuM9B7X+JivNJ6HQx75m/37tks+7h8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=M6J3UJxZBacQc4fLXtCSgoox+rTbnH3M+TnZs2LyfoEw9uyJrojVgWbTTFvemy5z80LjB72QaRLWbfupSOdukx//N9Hwuz9z+rj2ingcdBldN33Ffhii9OTQ/HdBZRkKkGYl6kdfkUTOw4cbuwo3QUX3fQylWdNeS07Q39Qgd5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=ZMPEDtNS; arc=fail smtp.client-ip=40.107.201.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="ZMPEDtNS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WbFu0xIFHiG02Aecv9Rq9CnyaD4WWJQ8VZQulsxhinNLDLwUOa4aUQh8JUm0vduEfJ5iw2zzgRm9o8fPFmLlYBGVxQfHA8Ske5LmcElo+6488oBu0A2NXMgdTg0ihDWu33FcpaWG7GTnlZSlfZoDoEc19WBy6GayOmDWhs0dR9njpqSS6JlNO1Mn03yfiuOBPXsp4dW9AK8m4CL3IpUZt6gqDGOdHRaDgVg2hNqf7tK2G3UJDUwWiTemFHisRqaTDJw0oYTlWmBUcjAZjEL7D1abW+j30Z7Yf5DkQxhgvcitfW1Otryd6W6bR6Oqadmxg0YSe45Wipuq9Q+n6OG5pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Spq65BHieh4ngcqvdk7ongRsyNTBMBj+9KnpUI8Urzw=;
 b=AuWANphrsXucMiwR9MZ0XmikZgbuiV0NvOS4M0ombRtGj/b/UhWH6WIcIL7tS9KMv9Ql+WVPp1cvmS2RIXZOVmeHPeU+rVbcq5b7zqWDr6IM1+Cg30EUUv+mRNQBxWMrP2zaTT0K/H6c/MXxLaTgM24ZswztiSsI1Ao5yWBFw8kqcUldnvFLmxIuSLi45uxd7YqECzOlehg9TIifA7EQp6B+L0kbVkvqAPLJliIUGnN+hDbEfrwbWhSHeD8ga9hyScWoBMZpnnKevAm7nwBzzzSBqgk0M5LMPL8RfDb/pi25DDUwhA+NU7h0qAPo1Ub4vxcnR2W+tQEHNqVxDqrBHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Spq65BHieh4ngcqvdk7ongRsyNTBMBj+9KnpUI8Urzw=;
 b=ZMPEDtNS0RAtyGf95c5POWpg3F730gVqNpoazcwCtu+xkZZBcZQleJDpb+C/Ng1wbWzoGjgao2CQ/RltE3RZuguxMKznKzLBRCZeejp9Vo7QaPrK76Wzkc9WqZSJGKekfMAMxj0maCBCaxgHaF0fVAIVVLNnY26bknePM3nY+yo=
Received: from BY3PR03CA0013.namprd03.prod.outlook.com (2603:10b6:a03:39a::18)
 by IA0PR10MB7304.namprd10.prod.outlook.com (2603:10b6:208:40e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 11:40:44 +0000
Received: from SJ1PEPF00001CE6.namprd03.prod.outlook.com
 (2603:10b6:a03:39a:cafe::36) by BY3PR03CA0013.outlook.office365.com
 (2603:10b6:a03:39a::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.16 via Frontend Transport; Tue,
 11 Nov 2025 11:40:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 SJ1PEPF00001CE6.mail.protection.outlook.com (10.167.242.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Tue, 11 Nov 2025 11:40:41 +0000
Received: from DFLE215.ent.ti.com (10.64.6.73) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 11 Nov
 2025 05:40:40 -0600
Received: from DFLE205.ent.ti.com (10.64.6.63) by DFLE215.ent.ti.com
 (10.64.6.73) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 11 Nov
 2025 05:40:40 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE205.ent.ti.com
 (10.64.6.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 11 Nov 2025 05:40:40 -0600
Received: from [10.24.69.191] (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 5ABBebUc880679;
	Tue, 11 Nov 2025 05:40:38 -0600
Message-ID: <4bf8cac1-ea21-480f-bc1e-bc1790a66a6e@ti.com>
Date: Tue, 11 Nov 2025 17:10:37 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] crypto: ti - Add support for AES-XTS in DTHEv2
 driver
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>
CC: Manorit Chawdhry <m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>, Kavitha Malarvizhi
	<k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20251111112137.976121-1-t-pratham@ti.com>
 <20251111112137.976121-2-t-pratham@ti.com>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <20251111112137.976121-2-t-pratham@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE6:EE_|IA0PR10MB7304:EE_
X-MS-Office365-Filtering-Correlation-Id: f6c69294-bdd1-4511-3e61-08de211724d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MndrRlNjWW1ZaSs2TnZseTNsM1hBQWtrVkxUc3pVZHc3WE5CWEZJTDgwMVF4?=
 =?utf-8?B?SGp4MFAxWnZmV3lRSkwzMVhxaFlZUFhrTm5jYjQybHdoRW9Pc3BKVURKU3ZW?=
 =?utf-8?B?ODBHdHVseHFUd1hBd3NHVzdESXY1Z2VnSGxQOUZqL2dtZFU0V0ZXMVhhNmdj?=
 =?utf-8?B?Q1NhN2dpT2ptODBrVnVNTlJSK1lwcHdmN2VLRTFpd2wyWnRUeGxBc0RKMnNW?=
 =?utf-8?B?cUtRL00zcURYekdCbmhaRU5vTEw0QllONjVIc1UzWkMvNWJHZ3M0OTBHeWNv?=
 =?utf-8?B?UzMwTVlnbzJObmx4REMzek9LNFoxTkhaUWZSVjNGNjJEdkgzUFBCdStvN2M1?=
 =?utf-8?B?UlF1M0hCUmRKM01ST3cyTTcrQ3dNbzhRYngrUHdQS25HZ0JQOU5tMCtZTnRs?=
 =?utf-8?B?enJxQ2ttMzBDcFpTUXJSMDdJWVpKbnU3UWN5YXJtOXRuMGhJRHRya1JubmNx?=
 =?utf-8?B?TnRtMEVoVUdSNHFtWUlMMUZIdi9Hem94alMxZHFKZ3hRUkF6bXpkWEwyZDZx?=
 =?utf-8?B?KzJSa3R3TVZrcXFwTTdsajB4SXlOc2hqcjNiZmRtVHVrYVAzR3RLRjZBbGY0?=
 =?utf-8?B?LzM4T3ZNNktDaXBabDlrQVl4dTZNYS9qR1JTdy9Gc0ErTVIzYnBjVXUwVmkr?=
 =?utf-8?B?SXJWTFNUTVNvanlzS3FLSjk0UnlhYU5MbTJoZDljbGhxYnEyc3FNcmF1akNH?=
 =?utf-8?B?UkZES1hPVTJiVUI3bDltVXZocGxDcStyd2E5VE80SGdrWlFPY1VkUTBib3Nk?=
 =?utf-8?B?L3kvQkg5N2dGVHdjc2VIejdOUHhOU1Nad1Q2enkyMFNuUHErSDExVGh3MkRu?=
 =?utf-8?B?YmsxOUVaZmJ6d1MxM0l3cUx0V0F6T3V5ZmNRZE5xVnZyaytROEhDVmVjaHFB?=
 =?utf-8?B?VSs1RlQyUmlSOFJHcytPM3JpRW9CWmVzaDhYRUg5cXZRVDA2MTI2OVlVQXA1?=
 =?utf-8?B?U0tNdVlZMXF4eEhHWCtMVENyZHFQTzFhZnhrR3YyaTVxd05FTFdBeG15YVlM?=
 =?utf-8?B?ZTBmUjR0ZEF6bmZ4YXZ0QUVIU0dwR0FTVHU4QldtcjFFekFhM0Z2L0pBZWVh?=
 =?utf-8?B?WEE5bGVSWmltbVg5b3B0eG5GczJBTWdTdS9USHY3Q1o3Q0dMUTIrL21OSngv?=
 =?utf-8?B?RHZQWC9OQ2dha1liMVQ0WHFEUTZYb25YMWFCbFR2RnI0Z0t1Y0RtZDNhYXFq?=
 =?utf-8?B?MndaYWpVdVE1QTNRV2RYZ3N3RlhlZmVQMVU1aXZONUVCdmxMR0pNUmZZMFBk?=
 =?utf-8?B?aHdYbDgrekNvZyt2UER1RFF3ZXdPV0QzcWFkRnA2TmFOeFdYbDFDTmhLUzNr?=
 =?utf-8?B?elNORnh6dHlYbTJ3VmRDd3Y3NVhiOHpTNG43Sy9FWHFjaG9uZ0VEOGVsSnZk?=
 =?utf-8?B?WUlVOUlYZGVtMUxNbWtaNHBEci9ETUxTVDlmbU1tU1NDazZpME45UEE3b25F?=
 =?utf-8?B?N2EyUVZWeUxkc1dTWEVVclVNSDZGakZkY2dNbjZFeVRLY0NjeVJCRFFsTk9M?=
 =?utf-8?B?ckRJWjE5akIva1pSTGFBdlZ3OGZLa0lRWWhhajM4aTYxaGNEdFlMOXlYa01O?=
 =?utf-8?B?bmFyMXVmMitwZFpmNkxTeFo2a2hHUHVNdm5RalhGcGhPVzJaV1J5YmkxZk5O?=
 =?utf-8?B?S2kyRDBCaUhvblljWDNka1lickNXaWhIdHJDelVwV3RWZDY5aEhEcjluVjh6?=
 =?utf-8?B?cEhqdDl4b1NwVHFlWU9aTTBXaE1aK1Y0R1lvUk1lRkJYdzBvMDlaaXU0a0Zi?=
 =?utf-8?B?STJpTlBPV0FJTGx5Y0gzeWNoRHFqcVZTeVgwUGdiMnQvL1U2dC9jdHROdksx?=
 =?utf-8?B?eVREbGQxZjZJYTByNkNDckNXcVpFMlRLUTdvS2c0WFc0eHF1VDlQQnJ5NFZq?=
 =?utf-8?B?RVd0dkw4Y1Q4S25jVi9qL09MVHNVaWc0TGJUSWN0bjViRGhIMDNaZ2hLdjhM?=
 =?utf-8?B?WWNoNmlTTkcrcjRyQnQxWFBlTWRrT1ZObjl2cThMVkYxQW1VRlZvR3o2aXl0?=
 =?utf-8?B?ZnlWWXljWWMrT1dEWmpOemdqb252LzUwZ2k2amFLVjlzTi9pQkd0ZHYzMVIx?=
 =?utf-8?B?R3llZkV5ZUF3SFkxVmMycVdmd1JQWkRISUFtNS9xK0NZQlpDOUpyNHdkaGI1?=
 =?utf-8?Q?xIxQ=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 11:40:41.8511
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6c69294-bdd1-4511-3e61-08de211724d6
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7304

On 11/11/25 16:38, T Pratham wrote:
> Add support for XTS mode of operation for AES algorithm in the AES
> Engine of the DTHEv2 hardware cryptographic engine.
> 
> Signed-off-by: T Pratham <t-pratham@ti.com>

Hi Herbert,

I noticed after pulling your tree that this patch was already merged.
You can safely ignore this patch in this series as no changes were made
to this.

-- 
Regards
T Pratham <t-pratham@ti.com>
