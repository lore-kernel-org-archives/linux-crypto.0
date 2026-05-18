Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012050.outbound.protection.outlook.com [52.101.53.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C2A15B998;
	Mon, 18 May 2026 13:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779111321; cv=fail; b=qJiY4tOpIjkuciOtcWLmQUXUBlyyt7i6OxoQ7Q0yLzfU/Tb3g5M0gI8ROD3qiCjrQUNU3WjVO/lUSM1aD87rPhUbDygnhQ7WDd5V+ljwGcY8zFY8wtJbLxqWsZm+koB1vQys5SrtW5d3i2UAiHMgI1up/47V65NyGVttF5YG940=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779111321; c=relaxed/simple;
	bh=/KUVdPiHfnU44tMRlTkz3snoS6bq7UpLxiSJkPlXaYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=KGOUIK8HUBMd7PA+1lq0s7NB5bhmtbw88HLXvGIE2MW+fESYrBR9oPQPuUJJepPtNzycd5SFz/RwNFK+Q7Qhs6kubNkW0kGx44xMblxIehySaMaHKPNIHtcWpdopdMmG+T2KgUOpE8leRL8ZrtR/U6WrCIY2laVfl+Xa9Ezn7BQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=i9Zmae9L; arc=fail smtp.client-ip=52.101.53.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="i9Zmae9L"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u87fIRImQo5ImzNK7XPuY5KS1sdkWjAe8OlupNrIacW7xxZr2WafXJyaTa8IiAKrhmDYWqBKI59yipEJnNtH4Sx4xqxYX1vXsVcWAg7im6cRgJvBS0KK9cBBBIGLz72jigOX6yPf80iYGAhEJp2fclyfWp/S/p7nvQP/RwOcn251jjfdi1X2xN0NwSY2qwsImZYcwa4vbPH7bgy3ZNDQjLmgLUc3+p0YWGfYoQ0lhserv03FAEB2dF/cARbaPf5iJfpS6X9bKwLm4HgTVW5cp328lk+X22vZHAolU3IxFLAy10fWz6y/oNja2dEXR0sc8iPOSOCGRlQ2Wane54i5ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/VLuO6JgSSeSH9aocs/cRorybr46PGcnWEpbNuOZL0=;
 b=FiMrM6sKu2nUETdCEGA9nIdUodETlzBlYu8uj/eEWeQ1tIPKmHzcPAP/97jfbbnWVctLX3eRh/0nxsva23k1+66H+YZ2VXcblQB0S+l5tt31QM3fxftkCUMffJ5c9/EWlSRUN/f1yekq2QcgsW5EtOb4ieK7xZTl6ZIbHRNe6L8spF/x+AIKqdMiPG9Gn6qD1EKbPDK1ocR7/wOXVq3fj3xzEKftnsPTEPdsZDOTFKB/rvdu6mDltkP8E52n30jDGP8eesb3jJNwFc7RnEWWwDLeHao7jNXoyhth1rJ82iTDgbD8EQbXjtnj/Iy3kSaHgvPKEx+J9Ba6F+woWAig9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/VLuO6JgSSeSH9aocs/cRorybr46PGcnWEpbNuOZL0=;
 b=i9Zmae9LWJQhDbP7FpmuKYj1EWWv56OUIhu7CoRhzfQ3hlAeMZZ81IH9UMci1Obh0krZ/ZURs8vLYcIEB7FRmb64vtaBUXWqp6yzhfrvKdfl7Kki4PM0ILRSWC0OyaBEvDjRKDcMY84QI59T/zPWTvjv2fKs9xaVmfHT6WpwxcQ=
Received: from CH2PR18CA0016.namprd18.prod.outlook.com (2603:10b6:610:4f::26)
 by DM4PR10MB5992.namprd10.prod.outlook.com (2603:10b6:8:af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.24; Mon, 18 May
 2026 13:35:11 +0000
Received: from DM2PEPF00003FC2.namprd04.prod.outlook.com
 (2603:10b6:610:4f:cafe::54) by CH2PR18CA0016.outlook.office365.com
 (2603:10b6:610:4f::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.23 via Frontend Transport; Mon, 18
 May 2026 13:35:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 DM2PEPF00003FC2.mail.protection.outlook.com (10.167.23.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.48.11 via Frontend Transport; Mon, 18 May 2026 13:35:08 +0000
Received: from DFLE208.ent.ti.com (10.64.6.66) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Mon, 18 May
 2026 08:35:08 -0500
Received: from DFLE205.ent.ti.com (10.64.6.63) by DFLE208.ent.ti.com
 (10.64.6.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Mon, 18 May
 2026 08:35:08 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE205.ent.ti.com
 (10.64.6.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37 via Frontend
 Transport; Mon, 18 May 2026 08:35:08 -0500
Received: from [10.24.69.191] (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 64IDZ4lo1971801;
	Mon, 18 May 2026 08:35:05 -0500
Message-ID: <e3612486-20ee-4c0c-b5f5-677ee9f724dd@ti.com>
Date: Mon, 18 May 2026 19:05:04 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] crypto: ti - Add support for SHA224/256/384/512 in
 DTHEv2 driver
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>, Manorit Chawdhry
	<m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>, Shiva Tripathi
	<s-tripathi1@ti.com>, Kavitha Malarvizhi <k-malarvizhi@ti.com>, "Vishal
 Mahaveer" <vishalm@ti.com>, Praneeth Bajjuri <praneeth@ti.com>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
References: <20260226131103.3560884-1-t-pratham@ti.com>
 <20260226131103.3560884-2-t-pratham@ti.com>
 <abTdJSPtLYN0VJWm@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <abTdJSPtLYN0VJWm@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM2PEPF00003FC2:EE_|DM4PR10MB5992:EE_
X-MS-Office365-Filtering-Correlation-Id: 13e6f33a-09c0-42c0-40fd-08deb4e24789
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700016|18002099003|22082099003|56012099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	+fuLaEp2BXsCH4dZjDWLvLDfSK5DARLNMD3x/QzbEnY0fzJGJt3D85L89aitE7Wv0NgCIFvb/4GY072E7Y+R/ChoTNOIopVIiyWK3/HvHokLq1jNQccUhCHJpl2S0QcLYbUcPf3fJmWtTv3dsTWQughAIeIGQDX7g1pbpnf1/0Kr005exXsmvTTt99H6CvBamil3rwPYk8Yg92vzQLNwvumlvXr8SitPciwMZUCN0RdQV4ix5AGgISk9FF7Ds1s+9nr0org9UjZWgaY7NId7dDnpNZaNIfH199edZTYF/Xx7RGEq7iXXoPwz8v9RaFmAogR/KKutWp4pOsG0jJ0Ft6QL4AmXpdbjUggZPrW8r5ylerfRbRLqOcPBDEd0cmu/u33ay4E1eW7Q/O3R88tOwlEk8gCrCABeo2HQWgwUuA8uuAl/KQAoMf3mH2wxYwzokmGwyEOXTnfqewWM0PXHszVCun2o6ay+Vyybmm8q19UWLbUkjRfdZj7O//TV5OCh4ArBeDOtuK2DmhxepShXEuwbFr6Fw6aXRulgyDJ+f7z4KkF67IfpKPtbIoCPrumBiV0Rol0InG0TaU673Q70vPW8AqioevMSOE28bWdJeEDKA+PRgMz8a6un8P0WkB1oAUPXUsQJzzvHLhmsvzq+x4699fitxIu/IM+LdHzkc/ZPuxS/UvF+PFY9P1Pv4Mwh0UURePoHsY+oyMJdDKyDPbT5KC68hY1tMnD0I9nX/Nk=
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700016)(18002099003)(22082099003)(56012099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	oZrvnB3anUP7IaoF1YmYP25eG5x6o7Vagq5S16sanrk0rVAvWt7RIGkazhpF0Zj1IunOfhWNfSB/+7AiY9dkYbhPwUVZRAvBYNW7NjK6xQtYBPd+2hio6abnWd3eoBnGnxb53lwId/ovyi7pO7nKzro+YMpiUVxLw43QdxGWCzNFt05K0OEfkgMcNIAxprcjFSn2LxOmMy0ufrjva2H/qjBh4lKqk7r2Mjnjks3rSY9C1TOXxe39N4kkbbcZ5yMLDR+NrkZs8arBzG82surOg4yUYQIdGg70kYojCzMto8WtwdUGsMsGkwUYnXpMpgvw+Pod2U5OTITYF7MDsbfpIqrKkBtTwch0rIiLVFT/ofOxPhYHFB+89JGsOdRDTCV85/PlbKqfG/enI6nOxzWBjb7TI2kv0siTS/GS6Mhd6bUiz5C433IsvusXUJIdLjPA
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 13:35:08.8006
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13e6f33a-09c0-42c0-40fd-08deb4e24789
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM2PEPF00003FC2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5992

On 3/14/26 09:29, Herbert Xu wrote:
> On Thu, Feb 26, 2026 at 06:41:01PM +0530, T Pratham wrote:
>>
>> +static int dthe_hash_export(struct ahash_request *req, void *out)
>> +{
>> +	struct dthe_hash_req_ctx *rctx = ahash_request_ctx(req);
>> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
>> +	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
>> +	union {
>> +		u8 *u8;
>> +		u64 *u64;
>> +	} p = { .u8 = out };
>> +
>> +	memcpy(out, rctx->phash, ctx->phash_size);
>> +	p.u8 += ctx->phash_size;
>> +	put_unaligned(rctx->digestcnt[0], p.u64++);
>> +	if (ctx->phash_size >= SHA512_DIGEST_SIZE)
>> +		put_unaligned(rctx->digestcnt[1], p.u64++);
>> +
>> +	return 0;
>> +}
> 
> The hash state must always be exported, even right after initialisation.
> So you need to export the initial SHA stats if phash_available is
> false.
> 
> Cheers,

Hi,
I fixed the above and will send a new patch. But I had a question.
What is the expected export/import format for HMAC algorithms? Can't
seem to find a struct similar to sha512_state/sha256_state for hmac.

-- 
Regards
T Pratham <t-pratham@ti.com>
