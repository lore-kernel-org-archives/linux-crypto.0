Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010000.outbound.protection.outlook.com [52.101.61.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871AC39061D;
	Thu, 23 Jul 2026 04:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784782463; cv=fail; b=fD8qKG/1F8aqglBzGYIqlIrIFqRg1DuRdusCdx/T8Fz+bnTUfbQyhIiq+YQir3waKB9M3Zl9OI3v5evlBZ7JHL3WburEc7kaHxEQfNw3c5yQHVqBAz8Aus6l2cpnTo/wO53w9HjuKGC+ugLvyLAV7qV/YTenkid6Jcf4KOZwuow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784782463; c=relaxed/simple;
	bh=1FKUvkKBznms7LD+Hp37VVsjAjXAZtib/mms8C61t0g=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=svaJULD6zcMDK8sX0I90AmmecOAuoBHDWmodmXMqBDG2e+nzIFGYvE2t88z1Jli18sXKe6fupMxDZn754KgtP68xKIgMcKXEiPAYNT2Mar+ViYSS67wISW5Ehwiv5amPznL3qgpfaiISvYq/ltNrWwe371+ZltOfONoKUgN7+k8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iGwc63KU; arc=fail smtp.client-ip=52.101.61.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iGwc63KU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iz4wMsZHqtzf4YgFgs4XsmOg//4VpSgVJj3+jDBKr2wL3nVnMufOAYjyX+GY1vYC+EzJ6I9KmV6Jq6ulJVkUg33+Nvuy8OZ80WOaEeBn6cqkYmvCLzkP5Nxv9vdxFulWSWwXca4I6FPh+bK83oX4/lRX0tAqcWcuvCoCGQoioAYmYCDYhAKMqRsLxYcoT/1eQeNW74mNmp8RZ0G9QTsR44qBOdS+Vvpj5+U41fEgwq1/bhN2XAqlV8hizacoU7ud7IWIr89SMUPa+IrATzDma1kh0B+16O/B/7B5N1OmVWbbenE08KEWqxWjuUMvSL4p7VCjD+i/75yvWlFBIytvag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dEQjkmkp1pUfWcG1r0F8LJDCqu9cwomtc0IGyPePMO0=;
 b=Gy2xGd4wFqBWCXDJe08ejywQOnKO7vTF2LbWrY9BMoTz24QFa9/ZTHpUmMXNDj/ntglgIt6evbPdETSrUTIiZRuS5rgA5/CmCHX/E6PaqOIxEM70YlnmK3eQBP9xKzdLzsCjiBixch56b30qw6m/3Gs+QbPUoMPBa5oR+N0C8AN33Rlo3l0KGeEwrV90yCIKxS8yS6V/n2uhVR4GR8naY+dDMYAaAyCUkLlr16ZirtV8FDYoH2ixkLuofZZIX5uR7xu+Wq/AJNZ8GppJY8xCB7vhLVG8imhu36u99FAdfWNyXi5SBFt5e9tzDLZvJZTCzFU+mHYKq8c1X4V0FjvcbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dEQjkmkp1pUfWcG1r0F8LJDCqu9cwomtc0IGyPePMO0=;
 b=iGwc63KUbnXkTrPysxFSPhRw8fBDRNYbmltWz2gfnonHaWj/WkCGsu/4PXizlFBYy0B9r/iezL07lhoc11SCqnYND0xrAEMPjth9mHO4cv47c85KGFzzEgBdforhzo3a7wiLEkKHuXQzO0DVVS/nDRaZTTdrdEzoa9uLoTpFl5s=
Received: from CH0PR08CA0022.namprd08.prod.outlook.com (2603:10b6:610:33::27)
 by CY1PR12MB9558.namprd12.prod.outlook.com (2603:10b6:930:fe::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 04:54:09 +0000
Received: from CH2PEPF00000147.namprd02.prod.outlook.com
 (2603:10b6:610:33:cafe::7b) by CH0PR08CA0022.outlook.office365.com
 (2603:10b6:610:33::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.10 via Frontend Transport; Thu,
 23 Jul 2026 04:54:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CH2PEPF00000147.mail.protection.outlook.com (10.167.244.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.5 via Frontend Transport; Thu, 23 Jul 2026 04:54:08 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 22 Jul
 2026 23:54:08 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 22 Jul
 2026 21:54:08 -0700
Received: from [172.31.184.125] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Wed, 22 Jul 2026 23:53:57 -0500
Message-ID: <9cfe76f4-8e16-4b21-a414-126a06859489@amd.com>
Date: Thu, 23 Jul 2026 10:23:56 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/6] x86/sev: Initialize RMPOPT configuration MSRs
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
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <8518e02c46d6edf1f37a180569c708a3cfa7c413.1782841284.git.ashish.kalra@amd.com>
 <20260723011031.GGamFqB1i4zt4Zlsx6@fat_crate.local>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20260723011031.GGamFqB1i4zt4Zlsx6@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000147:EE_|CY1PR12MB9558:EE_
X-MS-Office365-Filtering-Correlation-Id: d16bc83f-f2c7-4b39-1b3d-08dee8766e63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|23010399003|7416014|376014|22082099003|18002099003|4143699003|11063799006|10067099003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	YiqF2WhhllvKzoObLd7o8xwCbZegzmhuA6GWxiPwXYs8vPf5d9PtIuVeJO3+SyVknXLyesDAuRqsbt1SI//cTbPRBhtMAqAYcFQrxOiU5OEDFLIaQ0QelAMTXr2psAzhRq0Lqzgty7Tlxk9wsZmpuWUgfgg6MyWz6Egrmf+fxeQe8//Q1GEMmvxlnWtzs67wE863CgbeUp8eQG+vYUNjxnTiqK48nJek2tEO92iGUbaPirSYlENDKQEVNU/78UaIspTxINnqeCS4TaQWgYtm4jhVdFUzkOMFR5C6Jx1H6h8wsSTkn7DlS2UHQG4oPPi7mEkn8DAf8VFFdWDkKe7wg9gCkDtzX2nRgpvQM5O13dbAfjkESw/LTLrqUJJ1b5cLOUBllGuDrKJqyBidg/e1aFDKtHHXNUNFltCDnZNlTrxk2e8NG5jRl90dxB1J2PcFLSEh3B81DgmU5m5jzhn4ulveXwhYn8mlC8rS+YrIT/wvE87tQcK+j5VPbj+/oYljww6cR5pZUx4OhjcEm2Bkd6d7sbqG3GfGZk2cfu92KcXM4tQ0NN0xQCQVRx6kxzudK4NhRWTZ43iR0M4faUA6H+eiNgdgTUCY8BfmrdLEYlIXXCgY1i35nHG9vefUklMg90Xksi2gMZOSQQfblpifWLRv+F3UkyHfW+w7/w/Gfr6WHs1OK13fQGEwSJCf275d
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(23010399003)(7416014)(376014)(22082099003)(18002099003)(4143699003)(11063799006)(10067099003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yjeWiZJEr20h4LUWwM2YNwu087FBo5W/C+rDuiRpxw+Fx0Wsne6IqUwbVFfgpTaJ25QnfqPztOHO1Ac4lj+ed7VdqJLU8ZR+x5blqWdBoanhuMew5f7T+oOsdkJsrxy6aJoN24YzV9HN5vJe2pDb9tTDhprKOjIVVrL3GPMgA31vuZamQWijPKxv0HAaMAE0kTg0xKVYbsIKi6cuQTEd16724nyTXKjAAdYIg+CGFC3bNL1nfQGEJfAszcMb7rlMYSQkoAe3jkJt3c8sP2lOFYMIgF5Ft+PZPhN9KbPcPfBZcPLdUV2yQUq2hY+6/DaMmonU22iniS8Nff59O5DDw9YVNkJ2KLhVjtUGiau91xi2dBydMK9ofmQT3u9eVP1kOeJxSMCSDrSoUzg837HFw+0akrfLUbOFri/h3KgDWkpKs1Cyi1g+5c3CSMCF4Dk2
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 04:54:08.8419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d16bc83f-f2c7-4b39-1b3d-08dee8766e63
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000147.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9558

Hello Boris,

On 7/23/2026 6:40 AM, Borislav Petkov wrote:
>> +	/*
>> +	 * The RMPOPT_BASE MSR is per-core, so only one thread per core needs
>> +	 * to set up the RMPOPT_BASE MSR.
>> +	 *
>> +	 * Note: only online primary threads are included.  If a core's
>> +	 * primary thread is offline, that core is not covered.  CPU hotplug
> 
> So what happens if not all cores are online?
> 
> This should check that and fail if that is the case instead of blindly
> continuing here.

The offline cores will remain offline since hotplug is disabled. RMPOPT
is simply a performance optimization for RMP checks and leaving the
offline cores (that will never exit idle) unoptimized should be
acceptable.

When hotplug is enabled again, the platform would have already executed
SNP_SHUTDOWN and SnpEn would go back to 0 and RMP checks are disabled
entirely by then.

> 
>> +	 * is not currently supported with SNP enabled.
>> +	 */

-- 
Thanks and Regards,
Prateek

