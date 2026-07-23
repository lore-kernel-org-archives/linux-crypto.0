Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012070.outbound.protection.outlook.com [52.101.48.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8A41F5821;
	Thu, 23 Jul 2026 06:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784787269; cv=fail; b=GSKXuc/gJ2m1XZvzLIYzQAQBmbONJkllApgJ18K5SktMLcJukHPvr/hBGPeG/M1s6ZAirR3c0o8y/8BIspcJizjBkQAw6hV3k+QPen+y/FtnONFwXmhfoT3O1xDvBa1izgahsUh7rO+d6KjANaYDwCdamf7eb4xp9rhplYJ/yoU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784787269; c=relaxed/simple;
	bh=UTYooqJed0GMqHA97Iik2djmXdil73cEjgaVCAkwxFU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=rF6r+AByA7bOWwlNLHcJqpn13EvBQLnNJLMS/2TvWcbggZfJAQR4QqpHg5fJm/w61gvBB5sJwRrpnM4x940xxDDkpD3X4iQ3PHWx5ZB+B9W1/CH4IB9IR0ln7vnwkGlssEsrwBVOdwt+h/K0im/lxS910tgyFbW5RYWrLqeaAgY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YMV1vNj3; arc=fail smtp.client-ip=52.101.48.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YMV1vNj3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lLG4p8rOiNkyEbIF0L7ZLT8RnPPnERA8g3tM8dkV7RM6pf/c1QXo9l4d4K63O4M7Xe9HVhgCWdFMYZ3OxaBTVMZ2o5swVXia1JudYb+GtVM2jN1hBpCSLtDy9DKRfP4XwfxJH4nNntSvZc8NIofbhX2tQt6QswAozS777qD7HidgCedinjdLPFdDgHtF5PAs0hmNamM2fULRgLjIqQYd8FfvpU19HkCb4GhV7shX5SIXkxf+hH3xoEO2ldCdVzKQN5rIHx0s3ALMw2R3zK00gZOKo94yVStTlax8p+0BqNwwXe35b3cmZma8eHwLx+g/4a0IBk2DgkC8Fj6TcK+oEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CiOhk84zIeBUJJaV3I4CQVf5YoF3tXdRWwoK4UiVpYo=;
 b=DGVATxJ6wKYwM5AQweUPezLIQkzvpZkUF3jVLNFD+4cvGYvyv+1hdjBqQIM0GeBnBBIX7+M2dSj2/WM0szn4d+NsOnDKmG1Tc35BW5dOUnndceMq8Ve1h7WcVBG4+Ia50Fezg3EMi3a/XQlbu8Vq4JFwgJSRitZig0477hWCApT2tmUVUUeYs1G4xetW4ZQM0Vq+CzCpbRV3kvXkEtxe7qGhZ3OWWWIrK4uau4xtklZMlGXn+MlPULAvMyZ/zTwq5lINYuYgnxk2lCXt3HWP0QHseQxbrh4TJ83ovbt3Ljiv9V03mkvi2492Hual795l9bPnX6tiOXboy0MXqgpRMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CiOhk84zIeBUJJaV3I4CQVf5YoF3tXdRWwoK4UiVpYo=;
 b=YMV1vNj3G19IAohezx07dD9Yjyur6chduW5QHUQslXxIIaYGIKiTm0c2QchbwMgytK84mFnGDEfIk8LzopHl1mMbPuQASPIL/qPR1CcdGUubq9w9kAEtl/iaX1FpvhsCIdzT9QxCY+KHsTKs0Zg0HVgyAqDui9h8HhzlJeeQ3gs=
Received: from DS1PR02CA0004.namprd02.prod.outlook.com (2603:10b6:8:452::14)
 by IA1PR12MB9531.namprd12.prod.outlook.com (2603:10b6:208:596::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 06:14:23 +0000
Received: from SA2PEPF000015CC.namprd03.prod.outlook.com
 (2603:10b6:8:452:cafe::1f) by DS1PR02CA0004.outlook.office365.com
 (2603:10b6:8:452::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Thu,
 23 Jul 2026 06:14:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SA2PEPF000015CC.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 06:14:22 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Thu, 23 Jul
 2026 01:14:22 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 22 Jul
 2026 23:14:22 -0700
Received: from [172.31.178.83] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Thu, 23 Jul 2026 01:14:18 -0500
Message-ID: <a9b0b8eb-e43e-4ae1-9ba2-25dd7955be63@amd.com>
Date: Thu, 23 Jul 2026 11:44:17 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] Remove old AES-GCM library
To: Borislav Petkov <bp@alien8.de>, Eric Biggers <ebiggers@kernel.org>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, <x86@kernel.org>,
	=?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>, Alexey Kardashevskiy
	<aik@amd.com>
References: <20260722025338.33354-1-ebiggers@kernel.org>
 <20260722160347.GBamDp48Gyb1jYXKTf@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20260722160347.GBamDp48Gyb1jYXKTf@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CC:EE_|IA1PR12MB9531:EE_
X-MS-Office365-Filtering-Correlation-Id: f628719e-75b1-4866-e165-08dee881a39f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|36860700016|82310400026|376014|56012099006|10067099003|22082099003|18002099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	g/IwHMvDWCz4OT3b63CGYo80lEQTuPKvJ/TGCUiuLwHK6m+CWObx8JRA7G90EWdwsLu2haATdZ8Y+lKMPDquZ03r57BQJ69GQogPfPxv90HWFCwx+K2q78D591VTSksnR0RSHeh3dBbidrUnJztqPXE6vrhxoMVJT27NHP5SMtWH7OiIxVTi92pa55UUUloaqgXz8tFzmlYj7ZHAMLOQhx2PGSz/aspxoilF8Ocq3L826JC6NSSFZlWZjumg+k9U0yg5QtzXOxDnEyfeuIXOKNtbbg3ZHT6IdmHh1d+RiKI7lKBa+8sPC8zRcbKJABqc+QLFGhvGARg20YAxBYpuuk3dKrMCkSySNFGaRzK5Zsnxp1FYv1118AOOVTkvXSz+j9ALFtHYC36pN+LbEX0XnUKWmonjhzroIQfsh6Q64xthDNGiMv3RQ6fx7tVW2mGUyDZQvFMMQzpmLXE5xgf8htDdBjgsW2sloRUwBEtAKMZVLvDYEvYXwzCj0YfGHPEyoa4A1FGOZG+RwZ48vei3xlbXyjBLtFJe8HHN2qf78dA6dDbdH1OB5AyNxD2OPOaGZd3gqBUu0xHHUW1oVExjoUeKZkH59UmABk0GTfvY9e13DsiKlCTE71tJocqt3VF8zB7vWwOGh7IWCLMWmo69pFOuT928toXwX1v4t5JOApff+A1rE4LyBFmOdku0jRK3z33dEQTvio0cnGQ30TLm5A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(36860700016)(82310400026)(376014)(56012099006)(10067099003)(22082099003)(18002099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ixARLLkypen5BF5C7JuT6DgGSrxUzFPH2WNh9fq7Rm/dDEwAE0lUlGzGGWRL/2lSa2Q81VIR/QkrA/4SqgedLx/FqMFJt00tS8xxW7mByGkp99yiLbfJgmZwR6/uIh2kgEudNoxeqYTXYwq8oCHOO/DLGsgYF89i3QFXfLNPwSbryQxLpPvnpqcgFsiF8a56dKPuvpeqE5Sxjr65QtwYJnfkHlBVJSLoX01M5B7l/IRorYASYo/qcBaRTeFWKJmlp0aMYyk26K8ItGhKnmuWUYfOA1P5Yt9YJPpiI5Xlegj/JhLufQXVRLuKL9wwiEbk/eAc1t0IRYzzaJYdJYu8L6dtmewWazMSY4pJupgRzusb6enGH7N1F9BN+c5OlECWflGondJrdqaRbctxvAyVr9dfxUnmr+XqDWhqJNO3nPapbsNmHM/tFOqaqeS999xK
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 06:14:22.6122
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f628719e-75b1-4866-e165-08dee881a39f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9531



On 7/22/2026 9:33 PM, Borislav Petkov wrote:
> On Tue, Jul 21, 2026 at 07:53:35PM -0700, Eric Biggers wrote:
>> The old AES-GCM library code is being replaced as part of an overhaul
>> that is adding support for all the common AES encryption modes with
>> consistent conventions
>> (https://lore.kernel.org/linux-crypto/20260715221153.246410-1-ebiggers@kernel.org/).
>>
>> The SEV code is the only user of the old API.  Update it to use the new
>> API instead.  Then remove the old API.
>>
>> This applies to libcrypto-next.  If possible I'd like to take this
>> through libcrypto-next for 7.3.  Acks are appreciated.
> 
> Fine with me as long as the additionally added AMD folks can verify everything
> still works with their SNP guest setups.

Tested with a SecureTSC-enabled SNP guest. SecureTSC guests rely on the SNP
guest messaging API which uses AES-GCM library, so this exercises the new
library code through that path. No issues found.

Tested-by: Nikunj A Dadhania <nikunj@amd.com>
