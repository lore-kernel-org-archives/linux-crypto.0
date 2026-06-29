Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013071.outbound.protection.outlook.com [40.93.196.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4364A3655F1;
	Mon, 29 Jun 2026 03:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782702327; cv=fail; b=VqU09ceBmsA3SxbcYlVkWntRy4Cw82FPjr1zUU4zypZhpK+fA7Vby67wesubSSTH8865of60+1au6Gxr3bJQqnBjNbsyueyXYP57m29zxrmT0ImAQA4pDFlHSTI2Awhma8llqC11fy1PIeFvJsIFSp9M1YhxmK90hLmT1pIt7cQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782702327; c=relaxed/simple;
	bh=RLQRHMX8nwVuBP0OlDW5CncUPO1ApmJsF5cJL8IYjgA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=iy9clzoJ1CKhjyDYeis/v1oY1xjBhAXYfMkpDGYFlKOAASV/rkel9gFee/X+BcBgd1hSLYBcMZVeIQCE0DmWYpl8HSJs2Za5ROag6IbI3xtMKyUBCnUGgowPj+i1tvL82YoQEB7fdpClqKLB8w9tREU+E7NyzhvtWp1xD5PhbTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2l0TMJkG; arc=fail smtp.client-ip=40.93.196.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2l0TMJkG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GtvKRZ7Q/91EOsImjUY7lOtebFu0thT0wUNTn4SQmelZRoCqhTAtaQUVZwzz6tjBO1oWlA2rzy3nJyLAfnu/7YhE0pwtM7W1WZshTMgPzgf8e8AAYJw7Eg4j4mZPktFNbeBDLP6ZPT4rx+l7MrTUI6Ezt5QOYgWIw/nqkPNFvMqcBZfwx6dQZLWM3Femha/nS8xLQOVL6EM0RJgjCnMEW21lWj1NLrybLzvje1FMuMZ70kdFQDu23mw3d9h9OTRkpQpRxvn4vcS0YW+Psuc2uNf3URNrl3Nr05RHHAX6ojjtu2T0cv41LW0qmnfyci+QRodD8PNaa7Z5peeD5RyFLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cw0TzyDpeTW4qjkfkzMCrDPps7CccER2n0WsFGexch0=;
 b=Tq7CArOhOxiOS5Zz5qdBczHHkdNq6Jd+jCzVcJlbXEDb4XoFsxyIYYEVpTwW3zi/8aM3D9p/NIhvjGiGE+BZ+70CsPlBLmr8iHgiqwjg7eG9RUljrlO3u/+dOvvWfPJT1aoklLYTDbtsI+HmrsyJ4DWTHxQClRfVr7VKPBMGZFaPCMVN6Z7Nc33CiXFyWvP0yfDUanzSwuUejsLV+B4z9Pog6N9JU8mZlAccNKphS5b54Rggk7FTIEMjqT5yhUdjU4ZtAm95AtZIOXbY8KbrtlteXac1zrEJPM/TLt3vFykzroqXmDLTGW6Gb041pbe8E2S5a2aP82gy1Yj+oPq/Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cw0TzyDpeTW4qjkfkzMCrDPps7CccER2n0WsFGexch0=;
 b=2l0TMJkGe3ktQA884c0E/iVgKZ1BwNXdrRTROQmhIXce54/SRMwR2DOlP6iq06rBG7/JufBTdtO/6CDE8y33+o33KNIdHKzagitKGym8DkH6W51mBaD9TPYUUMy62sz62NkYVT4aNZbKUMskEicvhYlBBNtsaTzWio5xC82dV2g=
Received: from DS7P220CA0042.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:223::35) by
 PH7PR12MB8178.namprd12.prod.outlook.com (2603:10b6:510:2b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.18; Mon, 29 Jun
 2026 03:05:19 +0000
Received: from DS1PEPF0001708F.namprd03.prod.outlook.com
 (2603:10b6:8:223:cafe::8c) by DS7P220CA0042.outlook.office365.com
 (2603:10b6:8:223::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.19 via Frontend Transport; Mon,
 29 Jun 2026 03:05:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS1PEPF0001708F.mail.protection.outlook.com (10.167.17.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Mon, 29 Jun 2026 03:05:19 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Sun, 28 Jun
 2026 22:05:15 -0500
Received: from [10.136.39.208] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Sun, 28 Jun 2026 22:05:06 -0500
Message-ID: <75a397c3-5251-45c8-8aba-a185685b382d@amd.com>
Date: Mon, 29 Jun 2026 08:35:04 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/6] x86/sev: Disable CPU hotplug while SNP is active
To: Borislav Petkov <bp@alien8.de>, "Kalra, Ashish" <ashish.kalra@amd.com>
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
References: <cover.1782336473.git.ashish.kalra@amd.com>
 <ba146ca15b7f76eee386c8c073fb3f1cc36e5781.1782336473.git.ashish.kalra@amd.com>
 <20260625150253.GAaj1DHZC8ULg6PzbI@fat_crate.local>
 <7c64d96f-f932-4db9-8119-b9e40d5b7fd9@amd.com>
 <20260626164032.GDaj6rgHq4xPd-qjvG@fat_crate.local>
 <9d019b55-739d-429c-bb34-ce792e8340b6@amd.com>
 <20260627044117.GEaj9UbSvTExfmFilu@fat_crate.local>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20260627044117.GEaj9UbSvTExfmFilu@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0001708F:EE_|PH7PR12MB8178:EE_
X-MS-Office365-Filtering-Correlation-Id: 9deaa726-700d-4662-a00b-08ded58b4071
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700016|82310400026|23010399003|22082099003|18002099003|4143699003|11063799006|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	j1+XASNJnPce0sWUOEnTkigSVsi45PhDvA6IOTovtXXxn1mAvKQeKJ+a1yda+msrMQCa+c8Jq1g4e78zW/KVV1FabF7nrPCgKD/UKSLbw7E+lhXRJ/9s+RZoWJPA+bnKJc9LkBZ3fwoQBlwx3wuCLr05Gpz+QY+erT7K2FW7/aAjQlnP2xP5R2F/xsL9nFO1pAfuSOeibt64JCujcs+fiuIpi8J7EiYktvQfTiACy6nyfXbotYFM3g2BLD30SiBFsd/bG/F9H5+72Nv1jWgkonuRBn8/FtloXQHc7MkDp3NaBYmADkjyMW8gte3KhYNLbRBt4TeLKRx3eb+R+CuDxHhDuiC3fu5qO+wsUP0/PlVbmy86zFl+kblQAHmrOs8/W5LERXdgVHx3DlTdOnjwSZrIcvvQZi2SGspfCfoC+YSCvLRiSJKv0X8L1aTfKkTTg9LWjIEquVjphCKmcih1ABd/rnq6OSnFX7aYfhnb0ET6jMZTjESZyHuFvcaXR712gDanZgyFNbcJtaj8KMZoEDEnAnL53LqQAEk047PCHDAKm6q/ZF/B035Gj3exwUS0Yb4tKmodYrSUTCKCYbI2VDrpBP5V59ZQmcnWTlih/qQDF/kfdGNsW4suirj/Q+LPFRKVRwDBaKVABvaJnK2OwNDI+QFJ/DVjiJLW1dlHGygqQ2z02u1ckD3+xe443u8nsVE7aQq0jvxPLp/nTSz6Kg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700016)(82310400026)(23010399003)(22082099003)(18002099003)(4143699003)(11063799006)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7yHX1TsJPkPw4sy2I/R8lUXw732W30A4a8WKwhv/uOIR3uTMNiMxlzu9L8/jTyPllQWbOueq04sEznfRLpsFL/v3OzxesisZg6dp7aEWg56e0RaifW2VmMKoJb7sW/qVgpsHXNVEwDRokdjfqM0wh33IdcNPw8liuvF434maJA4T5ArE5d9rURnmXI2BGiPCSAPhVeoRvLPl/Kn1pS/ERFIpvgKH4L5VaI08qfYoDmrPKLjBGtYBE5/3D9FPvbAtLYOjHGF3xeipWMj5lrwYaZlWm5jDwLgUUE8aD5obGoRCdqH4oqCGQzmww42ANFBjVJkFL9YqBQxlTzI0FWWI4YKZef0lpPVqUFto51guzaOIJTt1HJndSZpvlj1owK5n6P97NGPS9AJjjZMBwAsD0oSBCZUV0pTiPgxqXBEfB7EKtyazn6xRoHVDALHIIqkA
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 03:05:19.0794
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9deaa726-700d-4662-a00b-08ded58b4071
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001708F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8178

Hello Boris,

On 6/27/2026 10:11 AM, Borislav Petkov wrote:
> You could also block hotplug for the time being by grabbing cpus_read_lock().
> And only when you know you are all clear to disable hotplug, then you can do
> that in the end and drop the hotplug lock.

This is bad idea because it'll stall the tasks trying to do a hotplug
until the last SNP VM exits. Instead of simply getting an -EBUSY, the
users will start seeing a hung task splats in dmesg.

Also, since the last VM has to re-enable hotplug, you'll need a
up_read_non_owner() variant for cpus_read_unlock() to unlock the rwsem
from a different thread compared to the one that locks.

I think cpu_hotplug_disable() is the correct way to go forward but if
you are not a fan of the global "snp_cpu_hotplug_disabled" flag, maybe
it can be turned into an indicator like "snp_initialized" in
"struct sev_device". Thoughts?

-- 
Thanks and Regards,
Prateek

