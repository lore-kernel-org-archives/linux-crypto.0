Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012033.outbound.protection.outlook.com [40.93.195.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF262E7F2C;
	Wed,  8 Apr 2026 06:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775628094; cv=fail; b=QcaTZrCfVZO4E3Dd56XQZ95cc/xckbN89Hspa40tcomnmRIEHH6UT1336dXsXayXLnFrtFntnAHawOK6RxLcTXBttfojUtZgcYy9Fc3XrWURt02eP24lFzWzCkDpo929ZRJUvs6QQKpb1Ouhh4jh411EeVgttAVFSXRvQUaMBe4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775628094; c=relaxed/simple;
	bh=kT/KsJMBVlzxONPl3L3blCu5CG6ADte3Fge7xys6Oh8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=eEa8yDEHznHKeHI8HiQnvkEzc3bvH3eYUVP2upQ4Ym1rU1ooI7hNzUQYoZ53AhwlTv6tqzgRVuTBzRNEJufjjazHFd/OE/K7WC9lgRczcynvAz8fvzRYZqc3yH4qukhqdggNyBmj581bsJnH9QwNYDssIgNls2WhLeSNqTNyAQo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gwZSf5JC; arc=fail smtp.client-ip=40.93.195.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gwZSf5JC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H6JPs4WNdVJUwVEssfuTwQBKPjQoPdKpVGWhpTvFOp9Pl1f0AF/NiLrqtJZsxcHmIhFW7xmkQSwjjXSXGtyyz12DcuDIwemHuqpXkcA1wKsz+FjrrMgRUCO52RF9O7/gbun7OHDZCvLkPEbuxQ3P6p0E/rcAtv+mbqqmOsLLXxZAHboSfGnRaWy/mbjhPu3jgIo8PlPC9ZOe62IPgypEVcB1Jp48nHzZtJ0etiOXQXwjoVR7iSpdUqVE/Q0DuZ8fJFiZaDRZcI4VcwORYREzWZWMiBFYrqrSFkko0G47X90feW+E9eAi1cM8Z3ExDRaqSkeXkdJnp5ybr+2gVnPJ6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b9o3z867g7d9v8zrvibIYLaDvpxwG3TkK4PZwHVp3NQ=;
 b=vV9XY/Rw69E/r6DarprzLWwDJHV7IjI2Y9kjGC6O3TWpGmjfcO2gA7XFuTthIKz9UrWJQWb8KxSNlWGAbIJKeG6sZOtW7KibVgEa0BJ/6+kBM1Wu84XZEpLS9DvXYi6z8Ip57k8+bRVDKHHDWsfe9WblQvo4rA1c/6OnquY1bU8dsn643cQn5uENekKQSHwoX886pShAlWxzeXKF3hNfE5giLPmO8zw0TS2KG8lAonBjOQoGF75oEi8DUT3P62U7YMa/ThshHUIX0REPpCOQYgGUJe5Eh4odajeheET17/goMvobx1FKCjxKTH1AMh4V377IeK8XYHuNi1m0WdYpPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b9o3z867g7d9v8zrvibIYLaDvpxwG3TkK4PZwHVp3NQ=;
 b=gwZSf5JCejr5D2+3anNvn5Dw0eYMVpa2n3H4uLh9BXTu29lGXlqxPupgX4t1oxHeQmYkJ3RY1aEM46+7AnANaSuWL+ylHatCvGicqL3PHcUl6L6XHWfeDDIgf517myjF5FRdi0zFBjEsVQNdjZuwnIovl2vEDCSVNck9nllmqbE=
Received: from SN1PR12CA0079.namprd12.prod.outlook.com (2603:10b6:802:21::14)
 by PH7PR12MB6694.namprd12.prod.outlook.com (2603:10b6:510:1b1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.21; Wed, 8 Apr
 2026 06:01:27 +0000
Received: from SA2PEPF00003F68.namprd04.prod.outlook.com
 (2603:10b6:802:21:cafe::c8) by SN1PR12CA0079.outlook.office365.com
 (2603:10b6:802:21::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.32 via Frontend Transport; Wed,
 8 Apr 2026 06:01:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SA2PEPF00003F68.mail.protection.outlook.com (10.167.248.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Wed, 8 Apr 2026 06:01:26 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 8 Apr
 2026 01:01:26 -0500
Received: from [10.143.200.36] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 8 Apr 2026 01:01:20 -0500
Message-ID: <f6170c40-5a36-440b-bcf0-b1c79bcfe639@amd.com>
Date: Wed, 8 Apr 2026 11:31:18 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] crypto/ccp: Skip SNP_INIT if preparation fails
To: Tycho Andersen <tycho@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	"Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Ard
 Biesheuvel" <ardb@kernel.org>, Alexey Kardashevskiy <aik@amd.com>, "Peter
 Zijlstra (Intel)" <peterz@infradead.org>, Kim Phillips
	<kim.phillips@amd.com>, Sean Christopherson <seanjc@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
References: <20260407174713.439474-1-tycho@kernel.org>
 <20260407174713.439474-3-tycho@kernel.org>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20260407174713.439474-3-tycho@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F68:EE_|PH7PR12MB6694:EE_
X-MS-Office365-Filtering-Correlation-Id: bdd9d127-5bad-4a90-09d6-08de95344570
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|36860700016|376014|82310400026|921020|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qJkMvLUuoLdOvGSFB3gGwtmMe7zwJ5AvpSI/75jnRYf8gE87Tu5ABOSyNl81mQVigPtsrMHGcdJhiD0YiYgCYad0hoa5oWIZqBIUc+vXCbSTLV8b5m4iNbZk8o339xuC/pZ9+d8k0XxGKJV4P4iC8n//YtMhjQ2uL4ux0L7yMyrSGElUmhkprTDu9Qjyv46igk8OJ2JJGT7DyYXc00eR20fOEVdvyRBDW+KRfLk7dwC4pZxtqk147zYJFTb2VNPrBlyL6QCese1M02Lu/GOdGkJyQ8q1M7vfZqoL5WpzsKTs3ib6bua3zHzA9YUMVZ6kUzqGTmuxUJMCUF0GZRsc77N/u4xhUx+8LgcILsNh+3EGzKvIzGig3k6XdwcYwp0ZgO6HLw6XzfQtSunknMSpGrOG7dPnveZZXgw4JL7sPOVSkdOnBssDjgbS3yDWPnktNfpJzikn6dBNTdtGZsWmGcGrJJS54v7zlvRHmO+9ajwZ5aC4YGfmG0nPpm7srfkml4to8QsSD0h0vYU3teXIBYi/GZZUud6IUMoEYIjvYr2x3OuuHhXY6tFBX6TH6KWT152rI+XcHcwNQbpReqII996YJJNM/nJW3ZNKQqRQwIYFFLEb/iYkuItb3PaYijNmuE7IZNjrkiGxFujCtHoi7vR3FVzh5t2qPAdEQhGTD/StVVI/WKQykg5lEg+BA0wWsHvy7N1hz4Cw9JvcVzN00hQZXmBlGBD6DmjtLTb+LchIdx6RNHLO8jwvsy8svz9SALs9OolB3xvAjiRXT2N6RJFi4U6BFXMXzYvbJ5DRp5s1eX7bb5XvL2KCidKzObIz
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(36860700016)(376014)(82310400026)(921020)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LKmV0Q/J3mWy7dJyCzUhvJne0gql7oZ6+1zrrjTiN+I5JE1BKhmGCY87B8ouww7lhWrW1HrazCoxqQxhzhOMt/Ofilwv3mSzg53cGhEf1N5qHd/8MVd9ZAKAxZ7kxswORNxtK9+gbhoOp3XwEOynbeRbw/AiMYA0hU+VxQ6P8yF8YcYcpb0MhyoDZQvta3h+BN+Ibsdp7HVzyTCIS9nIN9i/7BLPfcg71fhS8FBsB74V0KyNoj+AY5OpumyUdTzVdCgBImRZavLPsnnUf3OeBg5PNeAXPhC8PDrKhjhRC20UjfeiwXnQLcUvhJR7kMRvdZk7QAU42Y7ulLe+zV4ReN3TaDqDD2WCpQGp/SMs5OKVUK69ZMWLdjKFjibynWEqgEk5NabiLXzAsGljugLI2aBfX74/3TGShrytfGMdNCNi1bMo8IZIMt0SnfFSrbja
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 06:01:26.8316
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bdd9d127-5bad-4a90-09d6-08de95344570
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F68.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6694



On 4/7/2026 11:17 PM, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> During SNP_INIT, the firmware checks to see that the SNP enable bit is set
> on all CPUs. If snp_prepare() failed because not all CPUs were online,
> SNP_INIT will fail, so skip it.
> 
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 939fa8aa155c..854263cbb256 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1374,7 +1374,9 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  		return -EOPNOTSUPP;
>  	}
>  
> -	snp_prepare();
> +	rc = snp_prepare();
> +	if (rc < 0)
> +		return rc;
>  
>  	/*
>  	 * Starting in SNP firmware v1.52, the SNP_INIT_EX command takes a list

