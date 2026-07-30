Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012044.outbound.protection.outlook.com [40.93.195.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B5235E92B;
	Thu, 30 Jul 2026 02:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785380153; cv=fail; b=OFwd1LwiKxJHsJgViDrXb7MRnJ+JquTyf+YIxX7NylrT8BVPOnYPFp0LA5Qy/KvjttHr1+/zAJ95W5h3c1zjlVEZeu+E2njZ86aWee8XeTPX6lJ3YmQdNDaxXSYOsP2DWVHVhlGrYBkIOOHvUWPwMIP59AJtDYbpWF4U1sMiM9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785380153; c=relaxed/simple;
	bh=drCa4V2qwfnFGm7uv6EL+oP8X/53AlgtWdSL4ganllk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=UHtCnVbvm/GZeRD3C5WjCFzAzX+h6xCpSm4yIYiyP6nsYPVqw8MTeMtNxOeMyMZbP+7qk1K9LlBCk0QHWq0TfTjj6bYeljv8xJ4XextWHbWMxs0R8MJtD/0il+6OrBRNo5N5mh+ZZheTzYR+5mRHwdgYSlB5z7E6L+rQjIuCzms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=o6HHMK1/; arc=fail smtp.client-ip=40.93.195.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="o6HHMK1/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ycBY+02lsUoMYxHlHR9K7tt3lQkinnpZNmXzhhVJOaIUOVSrNSYzRuHGBsYjUXNiOaGtynkPzyRbHHw53HUpAbJrNc2s000M8v/YIL1HI+wUk+z0qqPL+M8B3SFTqktA7hBQgRYXffO+BeuUceL6pmOOPsGjMmNcXLWQco1HCpC8/70j8Gfl9rRwKTUgH3SepJmHfv+QrCDXqHAMkexdjZkHaqhCNkuisLAdixXkKKd8C78H5qdsRck6AdTpAM+f1wn9iFN+VyR54BwvX5S1myI6CFTS51JbrStBRyZKz6YsJej7WHHsDsa40rs9m2pO9MbyfaH37S8XthhY9vCSYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1GXvrfHyVwh9U5N5nbejNel/+ZDP55aPdPfLJHOD87g=;
 b=o5RcxAQNCZKd6qpbIPZ6o1Pf3SuR4qR0bGi7XkBW24QXXgiSizprLY+bah43/HpEHDIdN29xVFKFbKhJxsAQuM72mzK0ioa2sAO77n0zBQecVlhVfjFqeelZV1WxZTE0iZE9igSa8ZhFtYXklNYdFQ93TQRuMP3395L414hSwsRmWozjetFcwWnIVacKFGaDjz8sTvmQFdf1p7Yc9q73Hcn1WgVKZURPFXtljfnVvWDfbiVE4dfXJN74GNqrHpTiK1Izb6C/nRbGVu/hPxTsxrWdpPVzcv4X8wmziqFt1cMHgVVmliYBWw6wDqMMKnIuInlRo7pOiUPcJE4J/GSgFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1GXvrfHyVwh9U5N5nbejNel/+ZDP55aPdPfLJHOD87g=;
 b=o6HHMK1/MOKK5GY1dEba8/6uh3vE5igCiIVwe6jOlmUAZyoux8CSFR++f4XK3R4lv0Mw9xfm4Kz85achk8ushOAMQyrRIC62yEHWBufZh/nuRJtGLBVLByj1SYhcST+URAe8hkofiMfWQdM5vlB4LReooix+RFMrNpcRU7Yw4R0=
Received: from CH5P222CA0002.NAMP222.PROD.OUTLOOK.COM (2603:10b6:610:1ee::22)
 by SJ2PR12MB9139.namprd12.prod.outlook.com (2603:10b6:a03:564::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Thu, 30 Jul
 2026 02:55:47 +0000
Received: from CH2PEPF0000009E.namprd02.prod.outlook.com
 (2603:10b6:610:1ee:cafe::a5) by CH5P222CA0002.outlook.office365.com
 (2603:10b6:610:1ee::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.14 via Frontend Transport; Thu,
 30 Jul 2026 02:55:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CH2PEPF0000009E.mail.protection.outlook.com (10.167.244.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Thu, 30 Jul 2026 02:55:46 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 29 Jul
 2026 21:55:46 -0500
Received: from [10.136.32.30] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Wed, 29 Jul 2026 21:55:38 -0500
Message-ID: <7f837674-786a-42b7-a289-4c048fbec6b8@amd.com>
Date: Thu, 30 Jul 2026 08:25:37 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 3/6] x86/sev: Initialize RMPOPT configuration MSRs
To: Borislav Petkov <bp@alien8.de>, Ashish Kalra <Ashish.Kalra@amd.com>
CC: <tglx@kernel.org>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <seanjc@google.com>,
	<peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>,
	<pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<Tycho.Andersen@amd.com>, <Nathan.Fontenot@amd.com>,
	<ackerleytng@google.com>, <jackyli@google.com>, <pgonda@google.com>,
	<rientjes@google.com>, <jacobhxu@google.com>, <xin@zytor.com>,
	<pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
References: <cover.1784844080.git.ashish.kalra@amd.com>
 <ff346ea1770cf996e1623270a085ac08d21888c6.1784844080.git.ashish.kalra@amd.com>
 <20260730020704.GGamqxyPy5oJAmC5Oy@fat_crate.local>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20260730020704.GGamqxyPy5oJAmC5Oy@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009E:EE_|SJ2PR12MB9139:EE_
X-MS-Office365-Filtering-Correlation-Id: 98f3e8aa-7509-4128-512b-08deede60e17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|23010399003|36860700016|11063799006|4143699003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	OnBd4GFkw4gA/7LvJaz/xeH+6qFZR7djUkgOXUQFJ2U/NTBZlcHPeG5nr1JzJWz28USQYudHP8gASYG7MRBwi3hw4OGwQisrK/uP928P6NWvVGknBM6gqJJrEp3lsxi7nr8C9N6F10PEtRIYlQY+IxfrAoTiePheNtYBM+cd/+679jrBt4JpWDacbZT09oxKdRmdCvuHUumlaNaUTuKBFouRJSoOqqWgEUF+VwCRpdrlYbIzso10t9zVR2Ts4tWy9Eg5zfUTcqUqhyVL+HSSyBa39dWzU+1xbcThN8u/cLXsY4mN3FyvVU418tquW/A+QwEM/Zd+SZdVzzmjsVq4NYn3unKV98HoB58fk4DJbSdeNmYxiEH+PhTWivAOpHPf1sqFHYKtBWVNpwhA2/A0AkDN2Zce+tPTFy6G7iX5zpj7FdSskCOIS8S7dUy/oNM/KNED6nk9iMP/CCqoTOC0vS5Tx5dhey2iexuA1kXI/Pmz3C2bcIncvk1KIsI3j0JXkE9VrMeCQ+pw2fV5t5sWZNLvNvrYOvpWtzP4zDk2UCWrX9+GO6mFjRgAeRrA/HaDGvKanwOZcEO6D+TK7beWRhcxYpV4WwHCx0xIM5yPs3FMmFHLy8jZop2zS8baioXYz3fGrXSkmT4qwN0mTtZBO2WRmB19g8yph11rpf3fmCDeu554Zx+dcOTQmjXelUS1DuClboahwYBYujwr6eIWPQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(23010399003)(36860700016)(11063799006)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2YunLvug1Y831OJwg2DoL/1pAdwXOC8mJiyGWynz6DUT0TFcJfozdmhDHDlHxol2F/ZwqU/TKYvoFDIZloc01jyJ7NulgY/3NqtENCDUVL/CjOr8+u5AdXqg1Zys7VX9szsANeqdPY6TYFi/jDI9xORUk2/9765KrF+PzrAUJWYryE0Xf10KFwsuzyinlJ+/mL7zZSg9CwRVXLWYUuNSfQkkg3EfyNY4DovqCtwCt2HHw21IkKaorz8G4et33/NHqoZNnwzHfViVUcxQI+Q5URMQWLcrR5TBqt8hT6BKt0Gnpqs4c4EZSNz9P/TAI88BtHUDbbrtkCHa5uliaSmvboIVxrrhFxnerr1StUDwmjgjpHnhTBnGPpZKJNNDQ6JyHMv5xi4AX0bNL8SJPHY6z2dJJ10bWO3F+eBeICOvb87A6/DAG1XqYTxfJoHtNDO+
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 02:55:46.7264
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98f3e8aa-7509-4128-512b-08deede60e17
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9139

Hello Boris,

On 7/30/2026 7:37 AM, Borislav Petkov wrote:
> On Mon, Jul 27, 2026 at 07:04:57PM +0000, Ashish Kalra wrote:
>> @@ -705,10 +760,12 @@ bool snp_probe_rmptable_info(void)
>>  	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP))
>>  		rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
>>  
>> -	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
>> +	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
>>  		return probe_segmented_rmptable_info();
>> -	else
>> +	} else {
>> +		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
> 
> That looks a bit squirreled away in a probing function. Let's make that a bit
> more obvious:
> 
> bool snp_probe_rmptable_info(void)
> {
>         if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP)) {
>                 rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
> 
>                 if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
>                         return probe_segmented_rmptable_info();
>         } else {

I believe there can be cases where CPUID advertises
X86_FEATURE_SEGMENTED_RMP but rmf_cfg doesn't set
MSR_AMD64_SEG_RMP_ENABLED because otherwise checking rmp_cfg in
addition to the feature bit makes no sense.

In that case we should attempt a probe_contiguous_rmptable_info() even
for X86_FEATURE_SEGMENTED_RMP.

Essentially drop that "else" and do something like:

bool snp_probe_rmptable_info(void)
{
	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP)) {
		rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);

		if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
			return probe_segmented_rmptable_info();
	}

	/*
	 * Segmented RMP is either not supported on the platform or
	 * is disabled by the firmware. RMPOPT is not not supported
	 * without segmented RMP.
	 */
	setup_clear_cpu_cap(X86_FEATURE_RMPOPT);

	return probe_contiguous_rmptable_info();
}

>                 /* RMPOPT is supported only with a segmented RMP table. */
>                 setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
> 
>                 return probe_contiguous_rmptable_info();
>         }       
> }


-- 
Thanks and Regards,
Prateek

