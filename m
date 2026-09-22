Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CAA43553D;
	Tue, 22 Sep 2026 13:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082277; cv=fail; b=YQQeefDWqMFJ+Th4KRyZUKWahrylr+AZCi/ZZYtgHVAvQA7mNskrsrTjAGBn0uiVHGold9QW+ds9sYhPFCrg5jp/ARvJ/F7k3/ZJockc85U/BavNqSueMzQiTUXB0tHm7z+/xmjyRnto722NjYfKpDfPatukxG5/x4inmMYPrEE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082277; c=relaxed/simple;
	bh=Bt//rt0e1+LDV8/zRLAMmO3va5FkbcBby6vDNFxhTD0=;
	h=Message-ID:Date:MIME-Version:CC:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GZGHHaJ5JsA1TycGZ6HokZ3qGo8uqgFsUTX4mVqiMDi/wmOQW/Ojo3WW2y7Oo2lP3FZMMel0dhZrwkaJM1zIQE/bYLcZgseyLd1atz+1XFAqIltUXW28ztfNofbRTPt1FgifCajErZ2XUI2ZNQudV0tkQSp96qHiJvh36oe39GA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=aYvSQp80; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=qtQG9nQH; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="aYvSQp80";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="qtQG9nQH"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MBPjNF2560674;
	Tue, 22 Sep 2026 08:04:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=nOo5o01FAwFmhCa5Q8CGZuFvQt4fIZckzvOWUjhI3
	ZM=; b=aYvSQp80F8OBPsaw7MsyNbbEiQyZtw55EXZyq5YneJN9XqeT0P5vXLWMY
	4hTDbrrookrHfVRbrA8lDR1pmDMRwxCS60C13OWLxECnyqV/S/3E85PWiy66U+Sx
	rlQSPbTQrenf5BOoGaxuyIH6kz9viDSrOxfOWKVLYEKJaYkjrtjH84d8t4bHDZAz
	/05OI4LBBdcGkRaLU/hFGFVTYcvZ0sFSHiXRpqmw9NVLI9CkcgtS8br/g3yzetYy
	6Upu55VCanLQvsGpKkfUTzAVBMrcZNSJGCeL0eAFnGJFX8eYpx2saL6NXyJKjvTW
	ERPShPEd6F5VgCt/AzaWDrDZsBdWg==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011030.outbound.protection.outlook.com [40.107.208.30])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gugcsu506-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 22 Sep 2026 08:04:24 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lLb3PvsLxqIzr6283x5tJRHosIerwCSD/w9EkWPxewRkly/BCer/Tt2r2Fi/1IJ35J0kcvtB1ye+ipsc22l201sCbo5eRbxwkiX5aljEtERj29N8KA2Dvk1aYo6EapHDvgqsYJ1VFqznKhirutmGJVJ1bGe5/pAL+78nDOlqy4SKt9cUr7QkqAqml4bZtVocgQePleIy/tnr2L281FBUPI/rDuNyoebbFvCLS8Rzl7KD2lJaFMNEPWNO9w8CjU3KsOGLIXS7JxpFrrqc0x9d02jOcYmmvKB6iT9WOtu29amsgs2SJgwJelFoxUtTDHsrUW+Tdtrxe1c+mqHSK2SR9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nOo5o01FAwFmhCa5Q8CGZuFvQt4fIZckzvOWUjhI3ZM=;
 b=GuBt3+y0A/UcPwFLxtxZTNn16BOGgHizTTCzaYXNj9XrXiDKyQHHMuDzhseYZofuPIhNLYkRw2+N7XlovhL7at6Ifu48A5PFaEUJa9fFfYOmxdPB3Ixk2kd5734hi3ngdCRC+JJnJAQH7pacuVYQW8+d/VEqoW1XQZLxIc2gU9U2dOtpbVjjg7yAd45HrE5BQwROaB6MvEN+Xn9eIbNX6lN39X9/XNLNo5dAHwAJSlVuoiWigxle4pqIJdxWExAFI8UAlvP72NScFVtesd0uorIFp2IvBPtTP/T4HzIX0kCWbxUAw9ptb69Phyhy5Q2Er9cZzt5hbvrCJhk3rvjGtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nOo5o01FAwFmhCa5Q8CGZuFvQt4fIZckzvOWUjhI3ZM=;
 b=qtQG9nQHSARRAftq2p0RZ7o5HmWnx9qWXZrkozB4sEthMyfp7JUV6zDjXiP4wOR4sqzoKhs16HcFUNp8xKQ3chHNZBzKQ/E/hTvsYKsva6uYY/V4hS8bZqZsVDKq3yThjHu/ZAfLEVbXZ+O+pkX6YBqzeABRAQKY9wshbZbSymQ=
Received: from CH0PR03CA0246.namprd03.prod.outlook.com (2603:10b6:610:e5::11)
 by SA1PR10MB7556.namprd10.prod.outlook.com (2603:10b6:806:378::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.9; Tue, 22 Sep
 2026 13:04:19 +0000
Received: from BN5PEPF0004698C.namprd02.prod.outlook.com
 (2603:10b6:610:e5:cafe::b) by CH0PR03CA0246.outlook.office365.com
 (2603:10b6:610:e5::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.13 via Frontend Transport; Tue,
 22 Sep 2026 13:04:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BN5PEPF0004698C.mail.protection.outlook.com (10.167.245.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Tue, 22 Sep 2026 13:04:19 +0000
Received: from DLEE207.ent.ti.com (157.170.170.95) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 22 Sep
 2026 08:03:55 -0500
Received: from DLEE208.ent.ti.com (157.170.170.97) by DLEE207.ent.ti.com
 (157.170.170.95) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 22 Sep
 2026 08:03:55 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE208.ent.ti.com
 (157.170.170.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 22 Sep 2026 08:03:55 -0500
Received: from [10.24.68.238] (uhda0492258.dhcp.ti.com [10.24.68.238])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68MD3qZw003262;
	Tue, 22 Sep 2026 08:03:52 -0500
Message-ID: <beba08cf-3e1d-4510-9498-d126482cdaa2@ti.com>
Date: Tue, 22 Sep 2026 18:33:51 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
CC: <davem@davemloft.net>, <stable@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH v2] crypto: sa2ul - Fix stack overflow in
 sa_prepare_iopads
To: Herbert Xu <herbert@gondor.apana.org.au>
References: <20260831055141.1632832-1-s-vadapalli@ti.com>
 <aqpawGagrSvRkpTi@gondor.apana.org.au>
Content-Language: en-US
From: Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <aqpawGagrSvRkpTi@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN5PEPF0004698C:EE_|SA1PR10MB7556:EE_
X-MS-Office365-Filtering-Correlation-Id: 2eeb910b-b237-41bb-76f8-08df18aa03a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|36860700016|82310400026|10067099003|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Dz3guOmkaIE9RpS0d0VreI6aKcOTbmDnPAuyp4s2btUKlETqab+FowjI/h7ZdO++s8y3uYiBl4MPvKUtPmnvAO1srMuMts0t2McHwDrf4YqbrOPRaCzGqMcy4vIXzWYigzh6xupu0Dp2AFVmsuf3jNhtVkBnZzw/MEXPAlKPf2IB7h1Yghu9VRY4GsObu4t8RlzsJr/V7KG63ZwJrxl91SqxaFpnjc5+luCv8ca49ud+p9p/l/MNtCIAUY6IElHapA6U4B//WIEGrrTVdr2mP3T0bJD3JWuz9CPaKXeAck3BzJ0+Tdts7hMxGqfU24nE/D2zgcWFax/2eKbKa0Eu5pzbldzeUvq5awJ89PNpvCMRpjmfy5uTqboVeU8GEJllgVwXbLIOvEyN7qESI7LGcpDkLCNq1de52ffisAXHm8d/sPzr13gHn0w16JEPyRMe1hLP7XpduHCTUdeoBrprmWUXq9yL6H69zQkhbSM7QZA/rA97b/dAxEpRTlpLiHl3ibBycogwlg85/z1kLJd/ZG+8wJI3fJVd8GVky8yAdYeCrU8AuNNj9mNzbe7oJieGRtSRYnMDcr3jTLNO8+YJtpeXHJf4e/PZXXY3VoJ7xmKusDIk4jVvbLoAVH/i6FM66T8BgAZIeJHSH7Mhb70raw==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(36860700016)(82310400026)(10067099003)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hyrqJ/Nqdg6AXLQgT4IOXjy8wdANKD8QpKc2womQQtkh5Y5vAOW7cp8Bx8kOtARqWUTOvl2vNMoNa5d5B/edNjB3cM2jQwmu5jRCPjs1kYK7NR6Xg73A8RZ/Sc/3BNZTzqsKL02AAFxzzXSjzoYN+E0AL891pSdxxYrTaMGmdgo+BiSHUVH7pb4mo71LO2l/kHlmFJFKbaJaGsdjfZPrUDhZPYNrpB/njCVMON8RI48UYV1YuEtRn3eT5KfSeLYAExtphzqeXrxpWe3QaByeXiKKAVeAXzQcXkqsrxblDlE9J5l18Uw9sGsOTE8RPGo57FkhjXj96YOEWEIrpbDgBlAAZNTjDYgIjYFSupvgiAPsk77zmAir7UsmuWOM+PtBLLAI0Y5xVMhzE5z6+oKFEHOjRVYUqFQ+WYEBaA3d+bosh4lcOQaC+7n9LLLgdBhd
X-Exchange-RoutingPolicyChecked:
	EyArNlf56hUGPEzObA/KXaAM/1E+9oHNqTqKbPUlJvU7jbE6+V9kFOdcYBHBwhhtxWIlO+87V1/b/9rjMT/KoNreD2YW4b/3OQECEsyYE3QHV4zvWUzyezGRndBnTKYs+iZH6UT5Ml4Z14QPw2W7BxGKYvjfVtg6gSpjjlB+/LQks3pqey50cX85yYSVBl1HBPrImuKmD3pffddMwZGRu/Sf7v+DrHSIqCfJPV1e6NT038xxxkW+bpxCIB5HHMaWmtfz3clH1bc3UI3kvZYDKPGZUGTZwX1NYHQtquVfkxFzht32Dlnd9plIDuW+3xXgYEB7KeXpgSHrJDxyZhkAbw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 13:04:19.2027
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eeb910b-b237-41bb-76f8-08df18aa03a0
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN5PEPF0004698C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7556
X-Proofpoint-GUID: JRIaYSQTIp63XhuhrnWc3M_vd6s9HWJ1
X-Authority-Analysis: v=2.4 cv=GI+dgeNK c=1 sm=1 tr=0 ts=6ab27cd8 cx=c_pps
 a=ysgzExocFkmHQmNOaQPFvQ==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s63m1ICgrNkA:10 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22 a=c92rfblmAAAA:8
 a=sozttTNsAAAA:8 a=eiy9evC8d4Ca_i_wL6cA:9 a=QEXdDO2ut3YA:10
 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDE4OSBTYWx0ZWRfX9KhbJfQjOOiY
 /WOGFNvQ6iSCNagU/H4OPlvt1FNdtzsEESpVlzDO3XAiBmLnZyDdwKanIzWZNXioSljy57m/g/g
 nrYbr50XZ+exYQPBIgg6fNnp/4so08g=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDE4OSBTYWx0ZWRfX9ehn3AbQ5hqm
 mXQrPbQ0fmPeVjMpGdzuOZqHGVj+hYAFr5Dzhyv7s1rB0GTy7s6NugJnKc3JaiyNena4nwq81oY
 o0lGzcj8VHAG4Q+37YozqZsWxTyQNymmh3Tu8W29i3NJrGKm0TYVeGPo+xVD+U7fHOhUsg65V1f
 1dYIDg+jbO1SoyJ2ODMJ81icN3iL2IpS+x2mVvHuDpOjo6fkq8+Ir3NA4rNIyCmuDFSdXqGlERO
 8OUnUTuHS/o3YbiFVajyELJgqkkNSO2o+TQ0pR/RL8hr4KSncQHs9twiJDe2c9HtwYj+eRurMDB
 qKtJ2dyHatJY0elHR1DgsKlkyQiiGXrSeTboyk1Ms9pTqUbIbZlT/hyFXRSYmxcZm0U62FQcUmX
 ad9c9H2zv17k132cnlgzzs3p3pPMXGVdNKy8ZiRO1rv7jtREkdpLBSyLdtXP9rSL+da29+pWyau
 k3kSD7pz0zgLyRC+Kow==
X-Proofpoint-ORIG-GUID: JRIaYSQTIp63XhuhrnWc3M_vd6s9HWJ1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220189

On 9/16/26 2:30 PM, Herbert Xu wrote:
> On Mon, Aug 31, 2026 at 11:21:38AM +0530, Siddharth Vadapalli wrote:
>>
>> Since crypto_shash_export() writes 105 bytes into this 104-byte union, it
>> overflows by one byte into the adjacent stack frame.
> 
> This should be converted to crypto_shash_export_core which exports
> just the hash state without the partial block buffer.
>   
>> Changes since v1:
>> - Propagated error from sa_prepare_iopads throughout the call chain.
>> - Added missing check for authentication key size being within limits.
>> Above changes are based on Sashiko review of the v1 patch at:
>> https://sashiko.dev/#/patchset/20260819142357.3950463-1-s-vadapalli%40ti.com
> 
> Looks like Sashiko is still not happy:
> 
> https://sashiko.dev/#/patchset/20260831055141.1632832-1-s-vadapalli%40ti.com
> 
> Let's split this up.  Just do a one-liner to switch shash_export
> to shash_export_core, that should fix the stack overrun.  Then
> fix the long key issue in a separate patch.
> 
> I think you should support long keys properly by hashing them as
> crypto/hmac.c does.

Thank you for reviewing the patch and providing your valuable feedback.

I will split the patch as you have suggested with the one-line fix patch 
posted first followed by an independent patch posted later for handling 
long keys.

Regards,
Siddharth.
