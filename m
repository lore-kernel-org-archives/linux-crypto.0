Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010037.outbound.protection.outlook.com [52.101.201.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937511B3925;
	Mon, 12 Oct 2026 06:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784865; cv=fail; b=BY/E+zuqPAq/ANB6PxHI7toyxu3drC95o4DUu0S6EE9TZWXqNTKkYb3UUf/JyURqLbBz2V57leNOt71ipow5h+ghrLFreW9BEmEiW8IjsTX7tlj6o7IKs4wRlgF5yAaJecfEprBV1pYDpItdaNjt99S/vNcJorF3m5Q4l20MO4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784865; c=relaxed/simple;
	bh=rf7S4klWLVfWwWBj3aqJMRirrB0msIgkbMFJqObAXf0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jb7kMg8dHU7f6Sk1ccJE6m1oebY6iQRWon4BBWr2XkmCzWnNVBkxk5WL+AQFMXlegR+W+Pu6uZB/WvjyObAbCr6o1XtV2PXytIdGjKHvZkGdZflpCvXbIYthBsMADF07sejbShY3Dp8Xdgk3I5SqcdFFTZoNtvDdUSIBFOfjL2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=REvgliFe; arc=fail smtp.client-ip=52.101.201.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="REvgliFe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YdndVQv7Pp/pjB5WZW1ATFwHqVZf7bIhmQY5jsohIhPKQK7sZtLw8qPP40XcUUs6lk1v3PEIQ2bmmmsNavAlf/5BlhXEdQ9l2ZUm+jA900TSAkAHW+aCzoaeQta+OOKqdCKNuhykMSzTkqk+k7jklOZVBKVYgYQjbaAtCA7pFausMrbujP9/PcNo4QMY/DKaz7FW+TxGGAgJmqJyjcEKdmdkX3G/1HZTWG08SKnhDVM4ziQGTYo8GKAyj3awAVe4zffhDquOkOWT60KfyvTTAjq4jKxA5xVdQb5/XQq66fAmXAVylf4BYN2POrL2IR+z4zNslAiX8JKow2ji1He7rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Smck2Bpq2BqceuhanfQ8/7aHT50jGp8guUJfZ5IM5M=;
 b=LDvY6hp+Ap5qA+w75mmWJGWvnibPSCwJtgFM3FbeIIPWnicycJ+H8vDuPvxLVnbqsqtkePLJ/7TED/Bdyzo0XDOY+Ao5siob7w6+YVWjqLBVHNHNHC89o/71QRDPKadlgLHP235IntuKPI2Mu71pWt9UdGUAeLkk4vtPNQtZFw9xp4/0scjf27iuBOU3Uo0oawz0iU3gz/ql4IPFY3HgL9wa2MForacGndCb1q/y12LSgOdrRAoPTtWNrsYp8emOlEko5wviW2r1TCpKhWArIOaIytL/1ZkPhbNznHufevgNX1EDPA58HEr2O+cQiVoXGyyV/U+hTribXz/I3VkPJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=suse.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Smck2Bpq2BqceuhanfQ8/7aHT50jGp8guUJfZ5IM5M=;
 b=REvgliFe6xqeGmJaHQpBPQkuDcwnC+71UR0LQltJw4zmcdi+ul5Edno40nCS2b8kCnBCy2MdkkhnLagyiHXQoz4nJNO+GH9rrb5HIxUjIgeXsOoxFvc3Qdv8Y4HYw1atKJLnaq8aU2EfwdemOoFyUWu4kNwujEiK3uPZ1l0PgJo=
Received: from BN0PR04CA0020.namprd04.prod.outlook.com (2603:10b6:408:ee::25)
 by DM4PR12MB5915.namprd12.prod.outlook.com (2603:10b6:8:68::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Mon, 12 Oct
 2026 06:00:50 +0000
Received: from BL2PEPF000352CE.namprd02.prod.outlook.com
 (2603:10b6:408:ee:cafe::4d) by BN0PR04CA0020.outlook.office365.com
 (2603:10b6:408:ee::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.15 via Frontend Transport; Mon,
 12 Oct 2026 06:00:50 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL2PEPF000352CE.mail.protection.outlook.com (10.167.249.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Mon, 12 Oct 2026 06:00:50 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Mon, 12 Oct
 2026 01:00:44 -0500
Received: from [10.136.45.168] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Mon, 12 Oct 2026 01:00:21 -0500
Message-ID: <c40415f4-7bc8-4479-a07c-22b9f67a7613@amd.com>
Date: Mon, 12 Oct 2026 11:30:15 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/13] treewide: convert rdmsrq() from a macro to an
 inline function
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-hyperv@vger.kernel.org>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <linux-edac@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <linux-pm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-acpi@vger.kernel.org>,
	<linux-ide@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	<linux-crypto@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
	<linux-hwmon@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
	<platform-driver-x86@vger.kernel.org>, <linux-fbdev@vger.kernel.org>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim
	<namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, "Alexander
 Shishkin" <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>, "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, "Dexuan
 Cui" <decui@microsoft.com>, Long Li <longli@microsoft.com>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	"Ajay Kaher" <ajay.kaher@broadcom.com>, Alexey Makhalov
	<alexey.makhalov@broadcom.com>, Broadcom internal kernel review list
	<bcm-kernel-feedback-list@broadcom.com>, Josh Poimboeuf
	<jpoimboe@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, "Pu
 Wen" <puwen@hygon.cn>, Tony Luck <tony.luck@intel.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, James Morse
	<james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, Tony W Wang-oc
	<TonyWWang-oc@zhaoxin.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, "Andy
 Lutomirski" <luto@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, "Rafael
 J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>, "Kiryl
 Shutsemau" <kas@kernel.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, Len Brown <lenb@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
	"David Airlie" <airlied@redhat.com>, Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, Viresh Kumar
	<viresh.kumar@linaro.org>, "Huang Rui" <ray.huang@amd.com>, Mario Limonciello
	<mario.limonciello@amd.com>, "Perry Yuan" <perry.yuan@amd.com>, Srinivas
 Pandruvada <srinivas.pandruvada@linux.intel.com>, Yazen Ghannam
	<yazen.ghannam@amd.com>, Linus Walleij <linusw@kernel.org>, Bartosz
 Golaszewski <brgl@kernel.org>, Guenter Roeck <linux@roeck-us.net>, Artem
 Bityutskiy <artem.bityutskiy@linux.intel.com>, Artem Bityutskiy
	<dedekind1@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
	Ashok Raj <ashok.raj.linux@gmail.com>, Hans de Goede <hansg@kernel.org>,
	=?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, "Rajneesh
 Bhardwaj" <irenic.rajneesh@gmail.com>, Xi Pardee <xi.pardee@linux.intel.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>, Helge Deller <deller@gmx.de>,
	<xen-devel@lists.xenproject.org>, <linux-geode@lists.infradead.org>, "Michael
 Kelley" <mhklinux@outlook.com>, Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
References: <20261008071839.2247074-1-jgross@suse.com>
 <20261008071839.2247074-13-jgross@suse.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20261008071839.2247074-13-jgross@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL2PEPF000352CE:EE_|DM4PR12MB5915:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cfeebe3-ee41-47b1-9a45-08df28262b02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|32650700020|82310400026|23010399003|1800799024|376014|36860700016|7416014|18002099003|10067099003|22082099003|921020|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	iF/4vsFZ0oCxke5nY+IzxcsajSzz5fPHlKfX0Y7e1Yx6IxBZC2sr3ME/4gk3EsXUGoPLFu//3fq/5B93Fmnz6J+cejonYpLtAT5O3MoE9q/2qtUyA6JQVe9/KyUI0Zq2D53G0gSEYWNHVkklvOhGU3AX60Gl1/Dp2o8a7kr9auN2+ROJk55lgWuFVdOkGsnI/RjqR5yBE4YcIzdhUzo75yL+R1wluPkHvKzcBNUfJfs6UStcg3RvocQJvos3t8Ie55dbTBkmiXWO4GzaPMQMnWvyrNt99CU+kzYB2REQ6ZgmORiF6Vk/sQETKzhd/wI0RnhOuijITF21qZ+26lP8Z1rMGjpDfGCIA9/mHEWxy19fLdKyoLhnKunjb3sOk/NjA6nyZye1VKAQiR8L+P5Ix+8q4LpC4K9NO5pUbHiCkPwvUKcnq+gpAnjBtETeBz9J8IgxTvjLZVYS/5A/5aHcDzbNe/52x+IvEtxiu4QwbGgfgQNEwe5+0Ldvt/OFZn81u5mxvzdiUgvrqnm5Z0EPSmw6fhhzpuABtp4EULwt7/UHejEZxA8hCVUgDY1Q+MtNR7qd7b7NKZfskF+X+GyK6f1MXX9RGTjpff8PVrN7Vh2ybgNyjgBkyttYSxy15Sbssdy9hqKgVgE1S47frdT5p4BSbk28gX3HPHxEKRKgrLPQYvWGajX7RRYx+4XJkjMv2YlOgsIGCq/STIrTUogxtK+o1EhIKanpaAYU/pnTG0R/okTYWsplHnynkYPwx2IJ
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(32650700020)(82310400026)(23010399003)(1800799024)(376014)(36860700016)(7416014)(18002099003)(10067099003)(22082099003)(921020)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7oS2RettfJciXjAoPrqIpsgslkhkkpGAiW01FyzZHJNa6VOeV1Fs9l0RKNylshp8F43mwG7dYZK4yEnC3v2OZJfklqhnVYV8xmuueMD12u9jjbrj9fZR1VkqsUWmm6umnN6nxJeXy+PoYlQEQJEoloPH4EFw7pN+5lvyUMKMLbcWDF1wFCxmgit2RPf6HuaBXte6l7/4hBbWSHicYtdXGpY5AbGKJBmFA25RMv92aM3cXFiCCKCvG1U1CnGToXMhntV12UFo+3Pw59MKrc8GTvPBosZ0etwE2n1Wp4DIHjySvFMuIGuPBtltL9UDWxOmFJngwwXyApuTDlKSDb3h4ptwXkO8ss96jh/qHKPb0lo2Kg4bHCwK5V1iWIh7xJJ4YSFLPtrgDz0pQVTJQQpgka82T+jZZUitzlQX5OGrgr2p+XXZY9v881FQ+I0KBjNe
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2026 06:00:50.4752
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cfeebe3-ee41-47b1-9a45-08df28262b02
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL2PEPF000352CE.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5915

Hello Juergen,

On 10/8/2026 12:48 PM, Juergen Gross wrote:
> Today rdmsrq() is a macro using its second parameter as the target for
> storing the read MSR value.
> 
> Convert rdmsrq() to an inline function returning the MSR value.
> 
> The users have been converted using the following semantic patch:
> 
>   // Options: --include-headers
> 
>   virtual patch
>   virtual report
> 
>   @@
>   expression msr, val;
>   @@
>   (
>   - rdmsrq(msr,val)
>   + val = rdmsrq(msr)
>   )
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Acked-by: Damien Le Moal <dlemoal@kernel.org>      # ATA
> Reviewed-by: Michael Kelley <mhklinux@outlook.com> # Hyper-V
> Acked-by: Rafael J. Wysocki (Intel) <rafael@kernel.org> # ACPI, cpufreq, powercap, thermal
> Acked-by: Sean Christopherson <seanjc@google.com>
> Acked-by: Reinette Chatre <reinette.chatre@intel.com> # resctrl
> Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com> # cpufreq
> Acked-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>		# pdx86

Feel free to include:

Reviewed-by: K Prateek Nayak <kprateek.nayak@amd.com> # amd-pstate
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>

-- 
Thanks and Regards,
Prateek

