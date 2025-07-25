Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3781C23A9BE;
	Fri, 25 Jul 2025 14:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753453687; cv=fail; b=qVux4CQ8QQOzYEFzRWtWfp8lPjpWwIQ4mmUapcooL91f4103jrCt9aWsh7jTJrkeSfbNPT7ab6Xv4Cxc1RFcS4Q8sN3wCNkOYnK0b+cilJWfwn03diMsNayBcJwHLHr9US+tyX4ibaaqiNkxqNDTNxqfRAHrPU/I94/pMmvYSmY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753453687; c=relaxed/simple;
	bh=Hpop0dYXSZKhy8mq+inCJW2DvjaTjN8OstyRJv8M2nY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lHc61msDWjIu/NPk1AoJAzWbVF9hDu+0iRzKKiA6aBE7MvTgStNhPzVY7R6yW0sBWmAw2eZu+/We8vET4snPgLmA3sKXyqdY+Y9u8KQPdApXnsaCOuyqf2m6bfgQf25Yq24r1pimePLBhNxhrL/xE1RjCCQF+XMAuBnzotFAynU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HS8Iw6Ib; arc=fail smtp.client-ip=40.107.93.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HS8Iw6Ib"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r4XuPWnOzTplR9BjVSkfpl//7SWTQQKSFOkFnqQZpgRF8mAOhSEi2wZ9W4kWkUKp/P78a4UOSg6KYuBMIEjjg4oqU+lIXcowJ/w/C/tZ1GPyMY5Rcd6ByMMqYiP9yE1i2SLvk4qSJ8jO0jtx/CeJwmiB0AHfN5As2mKvBHlg6eRkZ1POdyEC1OD7pUzEJABHOd48CbD0vyyYPG1w5vU972JM3AeTRn9wbSSj+0XqtOufJF37gq+Og/TTuoXC6bHLX5ezSLwhpR2FhlFjWFS1nuzwFWdOJickgAG8lPjQGbZu4cZQl2dTCIVwk0f6WRvmpvufQp9D/hYp9PLWghQUwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JQUcyLe5m5rutxVH3dBhmSKSwAUo/FU4ZzZeDyRlt9k=;
 b=uZiywD7SRbzhX/G06ro3p6b2JOaQ0MciceDawi4lVE04j5wATxlVg2exS9sBJ/BOgbQrK5Xa65p7hQplxhHBYPVf4+jx6gMrICJtxAnndNvx8KNmdaWTLaeoB6uaIK7QiPl2uUeZ4aXfR0tBwxXL7vDPub84x7zwIE1tSC5uav/FCAwv7cjv7rZnGnSS0B8weh36dLr2ZyxdjQ6ZMiP5ZUDUsIJtD844XXI9B4xOK1zSv21t8sFeyzbe/3XTvC4gdaWU6+nEJDXtmjBPGgimVoMDVBiT4fb160GTVZCnygaNc0bCz5s820bQ33mQhF8/hkOhgR4Q9k3kVdD8N5cZ2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JQUcyLe5m5rutxVH3dBhmSKSwAUo/FU4ZzZeDyRlt9k=;
 b=HS8Iw6IbUYmtFWXCjYcGim/0RBqoMwT2WgFf4LWPCq/VSXOGvtKNONNKgFAxsM6erLTpW4cylps+EfSTbl5RmGjVKdk4xC9Y9oddW3DAMxRAFOGw9P+FYPChLA77a7k8yFsgvhR5ceYZuqhnqRK6UGKtw8X7akNSVssCs5u7uu8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS5PPF5C5D42165.namprd12.prod.outlook.com (2603:10b6:f:fc00::64f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 14:28:03 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%6]) with mapi id 15.20.8964.023; Fri, 25 Jul 2025
 14:28:03 +0000
Message-ID: <ff83d1e4-5fbd-360a-22ea-10efd71ff2d9@amd.com>
Date: Fri, 25 Jul 2025 09:28:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 1/2] crypto: ccp - Add new API for extending HV_Fixed
 Pages
To: Ashish Kalra <Ashish.Kalra@amd.com>, john.allen@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net
Cc: seanjc@google.com, pbonzini@redhat.com, michael.roth@amd.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1753389962.git.ashish.kalra@amd.com>
 <a5dfa1b5e73286c2d7a2d38422577aff9de48226.1753389962.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <a5dfa1b5e73286c2d7a2d38422577aff9de48226.1753389962.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0142.namprd13.prod.outlook.com
 (2603:10b6:806:27::27) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS5PPF5C5D42165:EE_
X-MS-Office365-Filtering-Correlation-Id: 59de4b11-7dfc-410d-7742-08ddcb8776b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q01NRzdMWnhHbDBXSnp6bTJwRjcrMlo4NWx5dkpNSkE0VmFySlV2TGFWNnZo?=
 =?utf-8?B?MG9tQlorRmEwUGkxSzFsWXBUK0VDd1Z1NHQvcy9GS0hSTXc1Y3N6dXcrMWpk?=
 =?utf-8?B?L3ZvTXlmazFXT01pcDBQb0trRWFLbkZKc1ZHSytWVTlLL2gwN2FUdHpJZm9v?=
 =?utf-8?B?WklCNVFVR1RoSkE4SUlMUFhaM1M2UEpRTkk2Q1daZmZzeU01RHdoREROd0k1?=
 =?utf-8?B?NnMyVVlLeDJYcmdTS0h0U0VYTnlQenBxWUNGbzQzam16dWV4THdHcVpqckMz?=
 =?utf-8?B?dS9BY1dad1RRYUhqZWppSWpuUHBGUURiOC80dVdLdW1QMmZDSlNuRXF4NlNs?=
 =?utf-8?B?Y0NaeWxUcjVOMGxVeVl2cThMYkRZSHVGdTZxWnVtY1JwcWczc3ZnY2NVdU53?=
 =?utf-8?B?RnduU2FhQ2lLSWhFVyszZlhFVk1XUVpVZDdlK1dxL2Q2ZWlFTTg3dHBjU1hY?=
 =?utf-8?B?ZWNkYzFJaENuZmtDMTdaczFaUithMVFqSnNUOVRaQVdTdU5GWHM3dDlzclYz?=
 =?utf-8?B?TjBqMThrQUdTazRFbEIrZFVjWnJ2RjFiTjdqeUVyejJpOE8wNlcwY2hKbWtv?=
 =?utf-8?B?TjhiTlRreHYzZlZFdTloRVZ1VG9vNzJvbTNiOUxyVHBTclhHRDZiYldKbGlS?=
 =?utf-8?B?Vit0dmc1bW9MSHZZUUZPeWwxelJOaXM1MmtUSysxWVpZVzdiZHlzOGdmMVRS?=
 =?utf-8?B?Q05ZcUNjWE9lUG4zYWwxdkwyd2c4ZU9udHNZQ2gwZm1ybDcwaHFSUG1oem9Q?=
 =?utf-8?B?QXN6cFZPWk1YL256VzZHekRwSXBrTHg0ZzZBT2lnQm1nMFQ4MDUwekVEU1Q4?=
 =?utf-8?B?ZStlazJ6dVdwWUMrSXlJN0xpM3FLMC9ta3QzaUNaTkh5UXkwcHN3WnpnWXN5?=
 =?utf-8?B?SFI1TVQ3WVlOUzN0ZnkrOGZxZ1FlR1ZzSEFnMmF5ekV5TjVyRk4yRXpNdSt1?=
 =?utf-8?B?YjEzcVJ1TVJOakN5UUR1UHZVUVBRc29iWXFIMVU1eWtuajFBUmFOYnZOUmNx?=
 =?utf-8?B?Vjg1NklKYW5zZ1pISDdoalM5anc1Z3NOSUNKakhndDljbDRobUxMa3lzekpF?=
 =?utf-8?B?ZXlUalBWZ2p1WnlYQlViNFIreE1LK2ZRdk5ialpJckZuT1hnUFFuUjYrY294?=
 =?utf-8?B?R0Zzbk02V29qQjluU2NNU0phSkZJNFpaS2RSTVZLNGRjZGFoTDlBa0diblJO?=
 =?utf-8?B?NkNKaEdFWVkvMWhTak5PNlZaMU03TTNBMktEd2lFVVJjRVpwMDM5VCt0ZXM1?=
 =?utf-8?B?enJ1bGY5ZXVrYzlvTlZYeTJlQnBsRTdXUmc2VExHY21lRmhpQ1dUcjRIQnJ0?=
 =?utf-8?B?NklCcDZGZ1ZuWlB3UEpMTFRlYzV6UFI0T2I1SndsTmZhanpyMjhTWUJiODAr?=
 =?utf-8?B?OUJjd0FkYlJzTVVGOUZQNEF5ZXN0REVRWFBJWFNob0RIdE5ENmZRQmkrMmly?=
 =?utf-8?B?NGphak44N3FSNVY1enZOR3gvWHRseFdIeGpleFNnYS9yWFo4ZmZxdS9LQngw?=
 =?utf-8?B?bU9CUW9zZXFCL25NK01zTStEVnI0RWhsNjdwZHJ1Vk40WERET1VFLzNERVY5?=
 =?utf-8?B?RzVsWUpKQVp2MFkzMjc2c0dIZEpMNDY4aUpINXBPMndFZVFHNXJ3L2R2KzFu?=
 =?utf-8?B?Qno3cU80YkgySkFjQnZ3Vm95bS9kNEZVazdxSnlKaXM5RFF4UVpKOVpKekFK?=
 =?utf-8?B?UEpPUC94U1JRRVdzS0Y2b09EdlY2VENqUXZ0cjhNUlB0YWsvODNKQWNPc281?=
 =?utf-8?B?YjBMVmVxZ3ljbGRJdm1xeGoyZlg3em1QMEhKN255S1FBZ3JQSFZlSDM4Y0NS?=
 =?utf-8?B?Wjd2TmFlbCtpK2ZLNTBiOVN1Y2VZb0FNaEpRQ0hoMlB2a0dJekdYY0drMHlO?=
 =?utf-8?B?MTdzZnhNcWhxZGE2NnYzQkdBNGsvbHlwYnJkNE42RU0vUnkxTVV4SkdvUVlv?=
 =?utf-8?Q?aM23TFaBzGw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dTk1QWJta3U1M1E3TGxGVlFmeVpvWG5pMWgwK1lYK1Q1bW50cjVVZjFMdThL?=
 =?utf-8?B?cWRrUDRmR1NYMUNsMVJkcWZrbFIveWp4U01sMDUyOU1oYWZIM2Y3V3UyaG11?=
 =?utf-8?B?MXhxS3haZWNXeVZuUlk4SS9qQXFGTDg0TDRmcmpIZk12OFBMUGVKZlhBU3Ev?=
 =?utf-8?B?WDRCSmlUZEt2NXdTbzlHUUVWRGltOTdQTEpPNUQ4ZzVCZDUvTlpmT0F4VUhS?=
 =?utf-8?B?UGxoQTlmKy9ZRWppVzUzeHYydUFENVV1dk5STmxlMXlUbzkva0gxZWk0M1dX?=
 =?utf-8?B?NldqdGdpdHgzYkdLQ3djRjR1ejVGN0laTytFeUdXeEVrbC9XQlpjb2M3dGRt?=
 =?utf-8?B?ZW5UTGZxUitWWUhKc2wxdjhpSnMyQTZBNHkyaEwybGM0b0YzbFBkWHJqZEYy?=
 =?utf-8?B?UjJIc3R4VUJkQzEzUlJvZDFubUNXTWMvYlozeDlxbWRKVG5EWVRIRlJOR3hI?=
 =?utf-8?B?T01HTEFxS2hWYSs2bWNyVjJ4QkxoclBKZXQvWllKamZXTk1qdWF2YjBha0Mr?=
 =?utf-8?B?NWFmakxoUU5CY25wK1RFMzdJN1RrcnYybUtFM0ZVTnZ0SVphdTNXbE5zRzVT?=
 =?utf-8?B?eXhEcmZzaE5KNVhRak9TZUthcm9VcHNqTWNCeFNFRWhNV21WRGsxV3dxaEpL?=
 =?utf-8?B?cEJPdENLa3ZjRis2ZzNpNUFBQTBNa1FPZm51NkdaY044clFhRkZnbmhJNEtq?=
 =?utf-8?B?ZXY0RWNzL1k1MUF1RCs4YWhTejlxV1VzYk55eWQrMGl2WjJ3YXQ0R1lyanRO?=
 =?utf-8?B?aWpPMm1GcWcxZ3Q4L0N2cmFKOHZJQ1AyL20xQ0lRUVlSYThPd1RhQ0Y5Mytq?=
 =?utf-8?B?dWNrWk9YMmxXY2M2RmdMQTFiOFdIejAzUHc1NDZ4b2lsRktzWU8rZ3EvbTds?=
 =?utf-8?B?SjVlSTVNRVhVaEYxTjZHYWs2NXVPL2Vkc25Sa2FWem5LSHUwNWN2cTY3eTdE?=
 =?utf-8?B?ZU80dW9lNjBRVGFNZ0JKZkdzZHFQSkdkdVN5eUtIWnRoc09pL0F4d3hwbkZt?=
 =?utf-8?B?M1lQMXRRNmNzcm1saFRIdU1ya1hOcXBJWThUQ2ZhRkdqOStDampSU0xOc29J?=
 =?utf-8?B?bFpuSGpqbUdrUUZXQko2TTUzZCtSUmJLdWVIUW85UjZsT1pGOVpLU1ZlZWhZ?=
 =?utf-8?B?UmI5bkNWVlBuREdaSGVCZFFoNXo0Mkg2czkzVktlWkZvOFBqZFlXcW1PWnZ4?=
 =?utf-8?B?dUFwTk9MSFJPSzd3TUZtMjNKSGZ3MUkwN2VvRnU2akl3S1U1MSt5SUl1anV3?=
 =?utf-8?B?c0ZBLzVFdVAzcEN4WlBJYlJTV1I3SE9sWTJnbU1keHhBVjRNQ2NUVEhiczh6?=
 =?utf-8?B?NXFhdmRPR2JlSUsvbXVHSmRWZlExQ1RJVW9zNVdnbmt0bmNZOHpUQWtlV2dJ?=
 =?utf-8?B?bnJQM2tYS2duK2hHV29FUU4vNHdNMGZVenFqemkwT3Uxa1dsbm5Obkhmblpk?=
 =?utf-8?B?ZkdwWHFlbXZkMEVOM3k4MzgrRTNKT3ZNcDE3cHhOcnBUdkFSM1pVTS9PK1lK?=
 =?utf-8?B?cFgrYkRQNEhzMVc3bTBBNng2OVN6NmlWalp5WXlVbkttdlNBTE03a1pWTm9w?=
 =?utf-8?B?SlFuODdBcDBpRGpPeGNMRnZlMXVDUnUwRlp0TTk0azZVcFhLNnFjY1ZKaHZt?=
 =?utf-8?B?aWJsUHo2Q2RRNFhFQkd5Qm9iWDZ2dTRBVm42L2xlcy9GSFBwK3RZL3ExTVJx?=
 =?utf-8?B?VHZzTFhjOStXYlAyVlV1c3M5QktBcUdiV0dXUHBPN2RYUlYyaEljcWExT0tO?=
 =?utf-8?B?VHNnSUthYnJLa3I5ZmxVdnNNeVRJL0JtU3pLdFBpSVFDTnRhTGhUZzk3Ymgy?=
 =?utf-8?B?bjVXVjNwb1R0WWE1eGkxRitOZHFwN2lEdS9BR2VLV1d0VHhsZDJ0U0hOUEpX?=
 =?utf-8?B?UlFodEYwSldUSkRiK3VRd05tL3NWSU1mdkttcUJ5NGl6U2VPL2tUQ2xHejJm?=
 =?utf-8?B?Wmt2U2xKbzZLRnNZZWMxTlRBc2V5bU1mSWFZS2tBc3JBcmFyeVF3QTkxa0xI?=
 =?utf-8?B?bWljeXA0cTQyenh0Zm1wMDhqSDJKUVJYVEN4WThoY2syYXgzL3ZLNVhJcUpM?=
 =?utf-8?B?TzkzSTJqaGlVMXZPTHZSc2Z1SjRZWjZsWHVqcDRpRURBaXpvSXQzckR5MzJx?=
 =?utf-8?Q?bb/0j/SQREOjiIY8Q2oiYSelU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59de4b11-7dfc-410d-7742-08ddcb8776b2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 14:28:03.1979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xny4oomrqZrhLyzS6Ojh6U7x4fn6mObGV+X5q1nlc91qnh0vD/KzRGD+pn5s/K9IMxmPBff9ztXRAmDu2bA38w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF5C5D42165

On 7/24/25 16:14, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Implement new API to add support for extending the HV_Fixed pages list
> passed to SNP_INIT_EX.
> 
> Adds a simple list based interface to extend the HV_Fixed pages list
> for PSP sub-devices such as the SFS driver.
> 
> Suggested-by: Thomas.Lendacky@amd.com <Thomas.Lendacky@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 88 ++++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.h |  3 ++
>  2 files changed, 91 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index e058ba027792..c3ff40cd7a96 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -82,6 +82,14 @@ MODULE_FIRMWARE("amd/amd_sev_fam19h_model1xh.sbin"); /* 4th gen EPYC */
>  static bool psp_dead;
>  static int psp_timeout;
>  
> +struct snp_hv_fixed_pages_entry {
> +	u64 base;
> +	int npages;
> +	struct list_head list;
> +};
> +static LIST_HEAD(snp_hv_fixed_pages);
> +static DEFINE_SPINLOCK(snp_hv_fixed_pages_lock);
> +
>  /* Trusted Memory Region (TMR):
>   *   The TMR is a 1MB area that must be 1MB aligned.  Use the page allocator
>   *   to allocate the memory, which will return aligned memory for the specified
> @@ -1073,6 +1081,76 @@ static void snp_set_hsave_pa(void *arg)
>  	wrmsrq(MSR_VM_HSAVE_PA, 0);
>  }
>  
> +int snp_insert_hypervisor_fixed_pages_list(u64 paddr, int npages)
> +{
> +	struct snp_hv_fixed_pages_entry *entry;
> +
> +	spin_lock(&snp_hv_fixed_pages_lock);

Please use guard() so that you don't have to issue spin_unlock() anywhere.

> +
> +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry) {
> +		spin_unlock(&snp_hv_fixed_pages_lock);
> +		return -ENOMEM;
> +	}
> +	entry->base = paddr;
> +	entry->npages = npages;
> +	list_add_tail(&entry->list, &snp_hv_fixed_pages);

You're creating this API that can now be called at any time. Either
restrict it to when SNP is not initialized or add support to issue
SNP_PAGE_SET_STATE.

I would suggest that you return an error for now if SNP is initialized.

> +
> +	spin_unlock(&snp_hv_fixed_pages_lock);
> +
> +	return 0;
> +}
> +
> +void snp_delete_hypervisor_fixed_pages_list(u64 paddr)
> +{

Not sure you can have this...  Once a page is marked HV_FIXED it can't be
changed unless SNP (SNPEn bit in SYS_CFG MSR) is disabled, which doesn't
happen until reboot.

So users of this interface will have to leak pages since they can't be
released back to the general allocation pool for chance they get used for
an SNP guest.

So this API should probably be deleted.

Or you change this to a driver HV_FIXED allocation/free setup where this
performs the allocation and adds the memory to the list and the free API
leaks the page.

> +	struct snp_hv_fixed_pages_entry *entry, *nentry;
> +
> +	spin_lock(&snp_hv_fixed_pages_lock);
> +	list_for_each_entry_safe(entry, nentry, &snp_hv_fixed_pages, list) {
> +		if (entry->base == paddr) {
> +			list_del(&entry->list);
> +			kfree(entry);
> +			break;
> +		}
> +	}
> +	spin_unlock(&snp_hv_fixed_pages_lock);
> +}
> +
> +static int snp_extend_hypervisor_fixed_pages(struct sev_data_range_list *range_list)
> +{
> +	struct sev_data_range *range = &range_list->ranges[range_list->num_elements];
> +	struct snp_hv_fixed_pages_entry *entry;
> +	int new_element_count, ret = 0;
> +
> +	spin_lock(&snp_hv_fixed_pages_lock);

guard()

> +	if (list_empty(&snp_hv_fixed_pages))
> +		goto out;
> +
> +	new_element_count = list_count_nodes(&snp_hv_fixed_pages) +
> +			    range_list->num_elements;
> +
> +	/*
> +	 * Ensure the list of HV_FIXED pages that will be passed to firmware
> +	 * do not exceed the page-sized argument buffer.
> +	 */
> +	if (new_element_count * sizeof(struct sev_data_range) +
> +	    sizeof(struct sev_data_range_list) > PAGE_SIZE) {
> +		ret = -E2BIG;
> +		goto out;
> +	}
> +
> +	list_for_each_entry(entry, &snp_hv_fixed_pages, list) {
> +		range->base = entry->base;
> +		range->page_count = entry->npages;

Will there be an issue if the size is not 2MB aligned? I think a PSMASH
will be done, but something to test if you are going to allow any page
alignment and page count.

> +		range++;
> +	}
> +	range_list->num_elements = new_element_count;
> +out:
> +	spin_unlock(&snp_hv_fixed_pages_lock);
> +
> +	return ret;
> +}
> +
>  static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>  {
>  	struct sev_data_range_list *range_list = arg;
> @@ -1163,6 +1241,16 @@ static int __sev_snp_init_locked(int *error)
>  			return rc;
>  		}
>  
> +		/*
> +		 * Extend the HV_Fixed pages list with HV_Fixed pages added from other
> +		 * PSP sub-devices such as SFS. Warn if the list can't be extended
> +		 * but continue with SNP_INIT_EX.
> +		 */
> +		rc = snp_extend_hypervisor_fixed_pages(snp_range_list);
> +		if (rc)
> +			dev_warn(sev->dev,
> +				 "SEV: SNP_INIT_EX extend HV_Fixed pages failed rc = %d\n", rc);

If you aren't going to do anything with the error other than print a
warning, this should be moved to the snp_extend_hypervisor_fixed_pages()
function and have it be a void function.

I would assume we'll see a failure in the SFS component if this fails, though.

Thanks,
Tom

> +
>  		memset(&data, 0, sizeof(data));
>  		data.init_rmp = 1;
>  		data.list_paddr_en = 1;
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index 3e4e5574e88a..444d7fffd801 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -65,4 +65,7 @@ void sev_dev_destroy(struct psp_device *psp);
>  void sev_pci_init(void);
>  void sev_pci_exit(void);
>  
> +int snp_insert_hypervisor_fixed_pages_list(u64 paddr, int npages);
> +void snp_delete_hypervisor_fixed_pages_list(u64 paddr);
> +
>  #endif /* __SEV_DEV_H */
