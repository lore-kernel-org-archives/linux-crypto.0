Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB994756C2;
	Wed, 29 Jul 2026 11:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785326170; cv=fail; b=lg6hnYa2xjCRu4G7cU7DD6TV0zGnrMrir3ZvvErbrDy7JR+RbD1Y2Z2IunDC4RyDGLwA6u+FlYjT34dvt0QfZldK+Jg3Tqvj80aIT7RTdVEp7vvb47M3wd+ThtYDWCnDy7KKM8L7XO77rRU18AjYzfQXv1I8jUWaa/qzTt1RTTc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785326170; c=relaxed/simple;
	bh=6Mj+2YI2NIQIqeD2sKwboNSlsPliEko9UIo7aOVc3Eg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=MGpzHRW7s+73uBLDeTiyAEDNivH9E/EkWnShoVbYvLphzpBuKa9rEyswSM+spe/dRDqHgmHuqfj5xXpvuapbilc8psaOarCteCiS4t33gCWZvH3a4qS/bppOvS071XyV8dw38RAgdyU+Xdqz6SzbW/eOd0zu4gIddynFwGaCAZo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=HduiZHVq; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=tyYHERj/; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="HduiZHVq";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="tyYHERj/"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 66TBox6X4021729;
	Wed, 29 Jul 2026 06:55:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=Yfy/npWwdnJrYxb8A2HxqKaUKs4QM83MOSBLvS0tG
	Ec=; b=HduiZHVqgohe52IUkzjxjV/NCq9cY+B1/zFBMrE2B2VtEUkKkifqda9f5
	sQlfG+jb4zP9OJj4ZSMChuKMxxhxSrlNEOBCeGiA8rmUTlUxijg2Lhk5GiQ+Ti5F
	k06rZQ8hiS0OIhhfYMeqjbAt0sK1vv0DZO1uzulXl4EoX6snUUpI3tY9/U3cXLhK
	vs0nEGApbVMDzs/jj7lTo2Fe2FtLzls/6S8ORt8q1jF104klur0qFzLNeL/wxjvJ
	k1Zb9EgjkPm62OtLq1NQJbPyjMABNAdnAXtorxUq+vrV2vrxsNxW3dNszawer7OT
	EuscqETSYPnBbBEigaTSush6Leciw==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013067.outbound.protection.outlook.com [40.93.201.67])
	by m0384305.ppops.net (PPS) with ESMTPS id 4fqh0p00pb-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 29 Jul 2026 06:55:55 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AAxISoFBV0lyzN5+u8rHGWZwBOWVEhmTxWcYFxvNOUeNyJ+FTQ8i6btza63a41ovm0OWOBof//wPbrJ0AJkWW6grlq9u4pmYJCdxvu76WmXYUadGEewpWyqSVD+yRKmwjfrU33P3cmIx3414f+QgVUGOCN6WbgveqnE8Uht38O7CzVpUy7B9PkDcVWl+z3t0bydsNJheSU8ZzKt08Z8hH8Mrw0xAnpX+am1Ye8muMiTCJvGziYwqlnJCwt7myn91acdqxgEy2uVWYo/VPr22tmyj+9oTvO+9efv6z63v8VOiBWQkaq6WzwHm4k3u1KflCzVK5CIXKSBHyzKIgaQjIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yfy/npWwdnJrYxb8A2HxqKaUKs4QM83MOSBLvS0tGEc=;
 b=Q9JjMPglSudm5OxWUKzLinw3ptZnyXSFGJgJJ+xoq3SCwNTCyhqY1lloTBCTOcLS0LwBUNBEeAF5NMX1fBymFfNhOikBt2Hn/PD+SUvizzWSbKPlnr1wAY4hRNGCOEaMq1jX+kApLic2okX54RyzFwIGN1O6ES+XkSGUgXEnw0Q/l9N6l32iDoOdaKHj1WsG7u209iuTdDbtxiSO/se6PHnDvjE/LHXE2itX1B3j3s0lV0v/HPk3iEWnGJ8kV9An35XLn5tOTaWzvBZpqwz1bAGA6BIcR6Re2LWN8TnNPblaSuL2V+oDXT33lwu5zLICAV24iWoDVvfY7xB+fob2ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=intel.com smtp.mailfrom=ti.com; dmarc=pass
 (p=quarantine sp=none pct=100) action=none header.from=ti.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yfy/npWwdnJrYxb8A2HxqKaUKs4QM83MOSBLvS0tGEc=;
 b=tyYHERj/yj2mPd6m5+8cRHZ7NVAPHFJ12Vsk6kKc94KGEQ253qxmJ1Xpl6XreKXm9qQx0lYSfkiLxK2P8OvrxD3uOdLQ41QvdzHRgaFXadcAi3BO9l3RI/Bj9r7wRBc3s2DPQPtAW8vl4RpFpurmhFtkw3BUFz3Efcy8YCInbMo=
Received: from DM6PR07CA0116.namprd07.prod.outlook.com (2603:10b6:5:330::13)
 by PH8PR10MB997954.namprd10.prod.outlook.com (2603:10b6:510:3d2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 11:55:50 +0000
Received: from SN1PEPF0002BA51.namprd03.prod.outlook.com
 (2603:10b6:5:330:cafe::97) by DM6PR07CA0116.outlook.office365.com
 (2603:10b6:5:330::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.13 via Frontend Transport; Wed,
 29 Jul 2026 11:55:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 SN1PEPF0002BA51.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Wed, 29 Jul 2026 11:55:49 +0000
Received: from DLEE214.ent.ti.com (157.170.170.117) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 29 Jul
 2026 06:55:49 -0500
Received: from DLEE205.ent.ti.com (157.170.170.85) by DLEE214.ent.ti.com
 (157.170.170.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 29 Jul
 2026 06:55:48 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE205.ent.ti.com
 (157.170.170.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37 via Frontend
 Transport; Wed, 29 Jul 2026 06:55:49 -0500
Received: from [10.24.53.205] (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 66TBtknW1223007;
	Wed, 29 Jul 2026 06:55:47 -0500
Message-ID: <f985e848-cc87-44b5-95ee-0533447e67f7@ti.com>
Date: Wed, 29 Jul 2026 17:25:46 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ti - Use list_first_entry_or_null() in
 dthe_get_dev()
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Mert Seftali
	<mertsftl@gmail.com>
CC: "David S . Miller" <davem@davemloft.net>,
        Dan Carpenter
	<error27@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, kernel test robot <lkp@intel.com>
References: <20260613085858.32580-1-mertsftl@gmail.com>
 <akd0zGzVZSG_45hK@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <akd0zGzVZSG_45hK@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA51:EE_|PH8PR10MB997954:EE_
X-MS-Office365-Filtering-Correlation-Id: b1e10692-f9f7-4c71-8088-08deed68557b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|23010399003|36860700016|376014|10067099003|4143699003|56012099006|22082099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	2FqwV3wSyUKeH5fwe7zOZt4vmICR7dn5Atp0O39gTupwfxHa8d0+HUFQyzyHQRwzHvbQpSDAaKN8MWTx/XBZ71L3CdWx1XJsjhCMnda1d3XKOv/zYWEGNreZPpjtwvfvH+rX8E12oyO9j7kL3D9k6KPwLf4M1ZepvAmDWHn3jKdiDzon6ObGgXlUbUyWuqe7UcXom3jNtmIw5lfbXqV2AzgGib0WYtTcy68h99O6MwsAvjLn4detZpzjm30iXgsLamccGafBM/AsqimkYUx4vuRLOkRaOYr+VyLc1lkRrCGgiMBPWiivMmnikxV0KOyL03yoCfgZwZi3EuwbJy+tVs06xT4P3qIt5+ZEgHFdclLxsmIgjeUNmu54nD7O8XBzt+99KvrXeRXu1MM3H2CqKte3FwdhrpnFnky63gP5zdkU/tN1fFTSzyloL0HLPCf8O+zOirAP3JwDzBEp4wrr2V/ID9Sw89gYCfCWqoDkeqy5AO9oumeo6TuMvHAlFZ8ABu1p3ZCjpiRTpL/LucpbEU3v+TWYEwW3RNwgSGx9MS0YxOrFOXkgOWKZjaGYlL2z+kSY61TH4pNZvk1AnFVLvL5YomUTt7PvV8DdAMjJKDrmi5e75ZemekFl8hitM4USYDhOHGEdgdpZ6uB9B8bXDpqGXVePVgmw3weWrcF023QNeqjRTQlPMPj0vujOVkOzRviyg+bZ/gVir8H669VPog==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(23010399003)(36860700016)(376014)(10067099003)(4143699003)(56012099006)(22082099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	blAvnVxI418XyudcgJ0k8CwKh5qME8vRAev4/nDhDH2zM79IHo8k/OxOMkH0W7spTLAIMvbsx/kM29at+506DABeZrfTPNhLuLLjrAOWMcwtt4HquI4dbOETJcXdR6sZSNhf0Chi2DAUbyLbMw9BNEFdggxYMGRbXw0UxF+Br+ayCex8aL1q3vzalxwRYea/KmI6sPjGGquee0IjY1jstlka2Dat4x7YmuwITcl0YkkuGcYexS2V1hzbUs+2+3gZaPMjar12EmAMpviF2KUimxHJAvFmpVjZ4LfPrVpqy2NgsFPZcLRFvKCAEZ1n/DIa8Z1GjCyq/Y8HicyivLUyCXOjHE1ev/nCMrH0cPHhcFc9jGwihj23w2XZGNx4oDCIS2QPtLYUPwxHz/9IjeAKOE6fY7/REiDC1/GgBmzH8onwN62xGcJY/b1ku5QPOzsQ
X-Exchange-RoutingPolicyChecked:
	KRrf2ipe2q2t2kgsPZ+ApkuTNjNnQoYs0CqrBunPb/ZdmqFUBbcLGSijTPuf/6VZGlP5fNhc/dK5TUVE917otcnPiWf775MkOBIIDLfTbJ54PY19V9DJmgnWCvnd3Ny1wV1mJTb5PojJJptzJkQ85veKNs7dguf3wpv/HaBNIWOjhHLmoBpdnt25nwmcsnWZ/F+ts2WunPbzBPdMvpZVF2LBe3sUsAAHTJx5Opm1iubmsM5VF/lNWE7wEiRpNQStYwPN/JgIIqDxooQdx8WepmTcvaR9EXvijfI+PsCP+h88WeU8R1fm3bJElYH6YTlGk0AqnwaYaZpJz7BCA/lVxg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 11:55:49.8994
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1e10692-f9f7-4c71-8088-08deed68557b
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA51.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB997954
X-Proofpoint-ORIG-GUID: KOliPXf4orVxkNvJkvXOT5hwoPBVvmAq
X-Proofpoint-GUID: KOliPXf4orVxkNvJkvXOT5hwoPBVvmAq
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA5OCBTYWx0ZWRfX+zozmlOAuT9n
 rIPpHBs2IsxqlFwX7EeNPJ/mQAvvMVh6z/KI9brvpxFzCXzhxQhyV++vo5k6ZHEHE+n6HIcLr8M
 km/AdOm7IKe0+CILzyRpFVqa8xDtsuQ=
X-Authority-Analysis: v=2.4 cv=dtvrzVg4 c=1 sm=1 tr=0 ts=6a69ea4b cx=c_pps
 a=R3Nq4yRH+PcKhTCrdXTq7w==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=s63m1ICgrNkA:10 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22 a=VwQbUJbxAAAA:8
 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=sozttTNsAAAA:8 a=YanmO4Q36i9NzQjYVZ4A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA5OCBTYWx0ZWRfXw2CXlLJI/lML
 X1h7pobI69uj5FxtTShmmegXRh5f0Qpgod/OwskPTlcNlC6B3t6JgipWCPedZ2ni4jph2ckdSIi
 v38SX9H43VeV3Bu97yDEDye0+ACFsBkH9X6SdwKIUTpwd94pk7pUFvOq/hBRL4urEp0Yywz+kvr
 /xeW8QdUmNDQ8GeAvR3oRHGk+onbAlmCgkAA0psDUFuQU8/G3ZhxUeXr5JacQPMJOk4JUFj31O1
 TD8mNqCX+IUKXg2f9fRQwfUrHtmKd7rLXw05dRZe/5nYjbz3UP+mERihjRMVWMmDt0lbXScycbv
 h1pubOc5ULxQ9RMno6X+3ZUNRD5uT1yunjDGjtYW9+lrXIgcS1pcFg/K2KeJUew7VArXz1fUQJH
 P1F9epo67UmwFsaddI477SY0HlXimf2bZ+XO38QIhOWIzXUK/9JMK2IglXqYtA20Jr8VtTU49Tu
 R/RjiL2bjSlNpshhltw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_04,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 clxscore=1011 suspectscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290098

On 7/3/26 14:07, Herbert Xu wrote:
> On Sat, Jun 13, 2026 at 10:58:58AM +0200, Mert Seftali wrote:
>> dthe_get_dev() fetches a device from the global device list with
>> list_first_entry() and then checks the result for NULL. However,
>> list_first_entry() never returns NULL: on an empty list it returns a
>> bogus pointer computed from the list head. The NULL check is therefore
>> dead code, and an empty list would be treated as a valid entry and
>> moved around as if it were a real device.
>>
>> Use list_first_entry_or_null() so the existing NULL check works as
>> intended and an empty list is handled gracefully.
>>
>> Fixes: 52f641bc63a4 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
>> Reported-by: kernel test robot <lkp@intel.com>
>> Reported-by: Dan Carpenter <error27@gmail.com>
>> Closes: https://lore.kernel.org/r/202606111933.69GGTKxr-lkp@intel.com/
>> Signed-off-by: Mert Seftali <mertsftl@gmail.com>
>> ---
>>  drivers/crypto/ti/dthev2-common.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> This only fixes the symptom of the problem.  But the root goes
> deeper.
> 
> The main issue is that the device can go away in the middle of
> an operation.  The driver needs to be handle it gracefully, and
> certainly not by crashing the system because the associated memory
> has been freed.
> 
> Thanks,

This is not possible here as the device is part of the SoC. That being
said, I'll implement this handling to have a more correct driver. In the
meanwhile, the above empty list fix can be applied.

-- 
Regards
T Pratham <t-pratham@ti.com>
