Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E136E4A204E;
	Thu, 24 Sep 2026 15:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790264429; cv=fail; b=go8YCMMKjd/j3DvPXJ9b2CHYdwZZlcVX8bDGP0qPcSmSGkbom2xfTQh5yQXlXRSubkXPiGuSDRBbuiL2NTTjCXBO93oo82Dl42gVTkOYo1vrKNXWZNnpilnkw+At9UVb8jl2fxXJNDVPCKzTcLVy6pLh9fj2HMkIstnfWXOZjjg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790264429; c=relaxed/simple;
	bh=fBQcEBAE2AItc2txiR3crVIaklWj9PSkr/VLF4xgwsU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=PZgyIMYHz9XIeTL5lVuZGWamkTNL6AvZ7W8LyVUk9zW59g7odkDbf6vT/9ZU5MpKHF8k8f/YW5ku5iDB6E05Gtx694AnEtF9KFyizMreYZNnPrf3G2NDTTGWReo7iIso8JdC9knlzE5UV1x277LV9JvMwGuJ9+QOGk0fcnEWrW4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=i80pCDKF; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Zo+7uLNa; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="i80pCDKF";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Zo+7uLNa"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68OC65Ss537103;
	Thu, 24 Sep 2026 10:40:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=BA1fwK9SbYgaNmW8gwt0kxwZX3h9ttvzLzKkGMFhP
	qU=; b=i80pCDKF2gXyUs8VVVZi0xfkxwBV9NtDuvgy4RowUY8oqm3myllN39E/K
	BBUbs+KcEIiOcnp5JtCJxkKNc9WKnYBCHchjidMTh7F4tQe7LYPUO52JLNRoXxjE
	Fk/yGTRnGaqBisTZn4cRkPrflrI23kPsClCTnbkk0SRdued7aHDaXjYvOk1H9tFp
	Qb2nfB7kvy8DFHN74sjPwUpgsejJR/jqPE2+LYuRrNMqiyEMS7wYV5yL2b+cHP1A
	iYcqOqqhyDG7c18pvr7iex5uKAPxUtcEDCJ5Mk9I2BR1PXVNkYjG9EcTOzzdAAvV
	FSB/Cj8paIW706FUQEck+joanAHkg==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010066.outbound.protection.outlook.com [52.101.201.66])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gw13tj754-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 10:40:21 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OrMkEV5wEHmlRJj93/VCVYgu3jkGd+Unc0R83+ktykvrrVvlYI77BNg+zLaeZKu+GYqWqRAO9E8gq9sAfQv21yohtO03bdj/dwNJMXt8jUNK6cUA5Kst2cTnvKEq441nL1Bx0JuxISVzW4X0ZPSbiRIE3TSOQUTeDeLoYE1rIM7p3YJpS0SsUkT3upQ8Q0lQM1hTWm99bwt1azA78lMyUiFnz255ipxdUAgNOHy0ChcjrHlpDFMSxjx7pTn61rLqBaILMx1xS4ak6O6GTw+//bzktaWGxORqI1RL6R04QmRjk1hJIhvjU6YuT6jeXoT/JYDGJAZziRQ6Sawb4adN1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BA1fwK9SbYgaNmW8gwt0kxwZX3h9ttvzLzKkGMFhPqU=;
 b=qJiaproln1XfumwWleM9/l6ZWwhdW6lWlnQpqD5+nBirFUzvvLa0s7J8ZvkNXd/HMTXcJYHOSoU33cYZyAxxJGPYtUMtmHVyX5t0oIP87bsgjtVY820uwE19t9CDFCs/9jq/qbralOPeQ+tSaX1Aieia2MCS9ZXDrvpiDpoQ8/vQ4gf/941gHpVMJOpcN6leqTJQfgAkfcmLjmo5JP/9owxqfU7qF6rKMIQsQypgqldRBR66FHkcvepDtu2zy4Dbg93I3Xa1Al7JgP32juqTfiOUbdO25IqligEStjyUnVJapocl6TADNAsFu9zNL9j6jBUljQ0O/dHlurQQpW9yWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BA1fwK9SbYgaNmW8gwt0kxwZX3h9ttvzLzKkGMFhPqU=;
 b=Zo+7uLNacXH0I3qxggoB47atNLzudj+vGg5g+7vp/7pnptZzbTBR75UL8OtBUTJqE6ByKOIWctdpFlBe542uKWs8XwLvdKJaN44UEgUMl0xE72lMB/522UDLtVRzVxRZU7MITvd2h8t7M+k0ibB9jdSGlqY6FWV8MYOXd7Njb68=
Received: from BN1PR10CA0015.namprd10.prod.outlook.com (2603:10b6:408:e0::20)
 by CH2PR10MB4182.namprd10.prod.outlook.com (2603:10b6:610:7a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.7; Thu, 24 Sep
 2026 15:40:17 +0000
Received: from BN2PEPF00004FC1.namprd04.prod.outlook.com
 (2603:10b6:408:e0:cafe::79) by BN1PR10CA0015.outlook.office365.com
 (2603:10b6:408:e0::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.18 via Frontend Transport; Thu,
 24 Sep 2026 15:40:17 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BN2PEPF00004FC1.mail.protection.outlook.com (10.167.243.187) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 24 Sep 2026 15:40:15 +0000
Received: from DFLE209.ent.ti.com (10.64.6.67) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 24 Sep
 2026 10:39:37 -0500
Received: from DFLE210.ent.ti.com (10.64.6.68) by DFLE209.ent.ti.com
 (10.64.6.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 24 Sep
 2026 10:39:36 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 24 Sep 2026 10:39:36 -0500
Received: from [10.24.53.205] (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68OFdX4Y155129;
	Thu, 24 Sep 2026 10:39:34 -0500
Message-ID: <604ddec3-bf19-4a41-8fc3-c4ec949e4e03@ti.com>
Date: Thu, 24 Sep 2026 21:09:33 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/15] crypto: ti - Fix use-after-free of dev_data on
 DTHEv2 driver removal
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>,
        Sebin Francis
	<sebin.francis@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>,
        Vishal Mahaveer
	<vishalm@ti.com>, Praneeth Bajjuri <praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20260918102245.2784000-1-t-pratham@ti.com>
 <20260918102245.2784000-5-t-pratham@ti.com>
 <arNo63c8NOHkc5CH@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <arNo63c8NOHkc5CH@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FC1:EE_|CH2PR10MB4182:EE_
X-MS-Office365-Filtering-Correlation-Id: 556b0505-ef75-47c5-8641-08df1a522176
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|82310400026|1800799024|23010399003|10067099003|56012099006|18002099003|22082099003|4143699003|13003099007;
X-Microsoft-Antispam-Message-Info:
	k5msb23f4rVMC2u15V8MxJwu3b9Jz+hO9NCzcRKc7RvaNZpHPerKp2qUOZ3Z2RC1Now/u+guXk1k6km4Yo4NGlq8BmOSJQz3IWeJ4MlwMuf32uItaODnQnAJPmSKPsERwS7Ldb6GqfQxiHOtQXfI9IwX2WheXVHxkTNL27zd0IJEfMTdeMOl0xNcPUfwYm2Eie0WLpdq2Wse/fe/J42cFsTzW23EuoPj4VW8dCle2Re+ru5L3Su4n58491XRyjqNYNnS1Hl205bYH+Y/+QSHldoHKhSQpkNelXDhdABjY04aRQ7zCFyxLG6gX/moUT6B7EbakVCCwDNEJ74on+d/bgxxSHa71xYGZaQ3WLS8UxKX2LC9/H+1uZCX8HxBs50WjTrNwHo5qfm0NfjR9MLU5SkJV++XjUP7WbquBwpp2DOB6Q4ChuuHJ6rJND16hr/vNgTA76uTTk3/uenDGA35yh/G6GUpoFLuu9hfJE3DLaDR+TnaLfRCxZYBBlKqMM8Tg0/iVVIB1O2nn7iUsFjeXjY6e8QZMnwZitWFdPFSjg/bHZxBWXGbeN2iQDhFHv0Za7dfe86D18qkhbKQrPm6YQxae4Iv/2TVXZCSYvEmNiPdkA3J+wXOAvy113nEyFekLj4qa9lKCh5DUQdLFDJcJA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(376014)(82310400026)(1800799024)(23010399003)(10067099003)(56012099006)(18002099003)(22082099003)(4143699003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	w5D2IUkmAnjBxBV6EU2BKN3OwDQ/KzBqAc6OaW0dyxemRpK6EdLZGWcvXueY2PS3bJmw/dTo8CytxHSxv0rTc90WlDV7EDlQykpa8IZFo9y0IxTQs3QepZwtuARer8nCmZIdlVfSA14YAOqSFMxHjwtDS42g2NJ66H5Yq8v4lX9iHCLhfbZtR31Ui40LQA36+FCDNRMOetAdbywYIHkvOz+h5+iM0zQr1/IwOeqtpQZpmrrHV4oaSEr7/LNYue2pj3zWjvy3x8u1XcVtg60xjLc9biPB+aE3j3+Y+g9xdv9EJyPoilMVY67clNnpPB+P3UcaworgGJY43YvOoBszpBMGh+JdymrnFdIYU3B/13PgG4oyPiQPQNeqMHeREROgiOYJBgFuAGrmSVOeXq7s87pwpVZiXuha6VlntN7NBjtewv27jzEYaa3Vo9ElD2oP
X-Exchange-RoutingPolicyChecked:
	YiFeP/w4bitxjjq1M4RBi2J6mSc8WRTkvbRC+f7bEJCkM6UH7p4Ucry7P1vh9EAlKzXAw0eIMzFmRvA8ifb/Rdwmi9gg0wUJ46Tlj5NAwqdFb+QUSAoDLvxV9EzSnEMSMo2+pz+0oxiDqjfSm5XOa/+imK8NbMboNS8G+rt2Vz93W79XtgHItvSPltrRWMMFbXDyde4m17hVPihBFtjwuQHXPgN03WIcSCv2eRSsq1mJvuNuqdYUyNbAufj42NNJKi+/wIJslZvUnzuK2dBbOzTKDTKyhBS1g57AuQ1qmwZDiPuM3ijm7FsoQFYTIl0a9b5JKRakhzpP2q3f4wkgyw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 15:40:15.9805
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 556b0505-ef75-47c5-8641-08df1a522176
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FC1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4182
X-Proofpoint-GUID: yYCRNm95pwUjWXI8xfEFWK1RLieyUg-B
X-Authority-Analysis: v=2.4 cv=YKUKWhGx c=1 sm=1 tr=0 ts=6ab54465 cx=c_pps
 a=sAaYeWWHS4LdRs88aTULxQ==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=c92rfblmAAAA:8 a=sozttTNsAAAA:8
 a=-h9YeAuxLZzuZEUGDGsA:9 a=QEXdDO2ut3YA:10 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA2NCBTYWx0ZWRfXwSe/02Rcl9xF
 yJic/ZLaBA5sitCjthulK9ykG7t4f9qbSiK+IVvd+z70hbzuPrWJJ7WOcGsLzShwgWmdFLpcDlp
 G5bu9x92CKp57dF/l7/ULCqb2VrOSjg=
X-Proofpoint-ORIG-GUID: yYCRNm95pwUjWXI8xfEFWK1RLieyUg-B
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA2NCBTYWx0ZWRfXxgEhQtaTNgPl
 QNK62S6cZMrPlQpUe3HSV8RroyNcae6qtwjVF6W+CktXniuzfUvpmdMPfCOVeaoJU3292TEOALX
 unlIKSVJ+/4wT2j7KHZDbD3pF3RHwqIVTaIs5PbHByEuUWfJ/GiiYMdGr4rHfj2xee4FWUvTAUG
 5CBqzF/XsOLWzEp52Ao6sMqRFgGO7lrUHogTFIRfNPudapK1rqk/92MpHHuvRUDKUjeeZzVi0S4
 MkYvm+NpmgX8pxHrsg0x2W8n/MjYhE/qEYEwaE6Q91xrJOBWLru4utOeNC0vAQwwVRo/2YuR7F0
 B5bRHU0fXaHxhwzSO5HB15UFwoXKHXn26qj7esEHzzziwOu+SH1P6YIHpOfW6Wbi6pkH95SlJ80
 7OLlzyI1CiMcV7CoOQMjx+rq3DopnL/Yzmu90Izqot8k9ttCPza33xUHdrwtRFlEJzygNINUVbW
 MUyRhQrLiTBxurcpTGQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 clxscore=1015 adultscore=0 spamscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240064

On 9/23/26 11:21, Herbert Xu wrote:
> On Fri, Sep 18, 2026 at 03:52:34PM +0530, T Pratham wrote:
>> Each *_init_tfm() caches a pointer to the per-instance struct dthe_data
>> in its transform context (ctx->dev_data), but never takes a reference on
>> it. If there are tfms in progress when dthe_remove() is called, the devm
>> allocated dev_data gets freed. Then ctx->dev_data will point to a memory
>> that has been freed.
>>
>> Move dthe_data to req_ctx structs of algorithms, and store the device
>> pointer in tfm_ctx. Add a refcnt to struct dthe_data, which atomically
>> counts the number of requests enqueued in the crypto engine queue which
>> reference the dthe_data object.
>>
>> A waitqueue waits on this atomic counter to get back to zero in
>> dthe_remove() before doing the driver teardown.
>>
>> Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
>> Signed-off-by: T Pratham <t-pratham@ti.com>
>> ---
>>  drivers/crypto/ti/dthev2-aes.c    | 74 +++++++++++++++++++++----------
>>  drivers/crypto/ti/dthev2-common.c | 40 ++++++++++++++---
>>  drivers/crypto/ti/dthev2-common.h | 52 ++++++++++++++++++++--
>>  3 files changed, 134 insertions(+), 32 deletions(-)
> 
> Please check the Sashiko comments:
> 
> https://sashiko.dev/#/patchset/20260918102245.2784000-1-t-pratham%40ti.com
> 
> Thanks,

Hi Herbert,

For the patch 06/15's Sashiko review, it suggests to use
crypto_skcipher_set_reqsize_dma() in init. But this being similar to
crypto_skcipher_set_reqsize() which you have said will be deprecated and
set .cra_reqsize directly instead, this shouldn't be used as the correct
fix, right?

As an aside, my LLM suggests me to instead do:
- .cra_reqsize = sizeof(struct dthe_aes_req_ctx),
+ .cra_reqsize = sizeof(struct dthe_aes_req_ctx) + CRYPTO_DMA_PADDING,

Doesn't look to me that it is doing same thing as
crypto_skcipher_set_reqsize_dma(). Your thoughts?

-- 
Regards
T Pratham <t-pratham@ti.com>
