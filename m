Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C274B4867;
	Fri, 18 Sep 2026 10:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789726581; cv=fail; b=TMjClUqrcq3bt/eAD/IpGgsslcRQ6LJr9KUvi7lYvtkvILXqHvrQX2mDLd+YBGx21e/KsRp/dofp6Su2SAgWkRHqDNW40B0JriaF7xNNTKqdML2A4lVt3sTc1Gy20WqQeec4WZ/mWaRRtLQL4tiAi9vvT4TB5NHPnFmW512cTY0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789726581; c=relaxed/simple;
	bh=SealblUbtfXdonyoH02j3hSkNyQzeg5hgqjqS1SjbMw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YAj8w8E9mm15JRPqnJa0QSIAZx8ELLQqhGJ9TqKaTolWkz3/08mPRZBZjpgjqYjl24PD/rzVFTv+66/gMoqL/ah3Ys59hT6CvUBtdL3HY1R81eQNXcjrmah/9tHILfmiRFzd4a6TjkhbIZ8OfmLxfbe7TtxiNMyPhrhNqz9f+Wo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=oAj3759S; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=n6QLuL24; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="oAj3759S";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="n6QLuL24"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68I9eIEc3768370;
	Fri, 18 Sep 2026 05:16:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=Yg5UmHlnAcTf8OpeYl36NrfU0/0zJGZnnkWIBVqFA
	2k=; b=oAj3759Sgs/S5QjrIi88eb0GEKEnUuQAvtzuBKeSnOGu1RyUcqbhz32g2
	u6REjYRq0SKld+vD+GPfdqiPjET51CC7KUnwXV71pJSNC4Yy6bpeWVQ0dZtN4Vze
	hs5AU7a9Xk9D5yITrDDMoc4p6+VEHANBwZiRCT6jYSvV7W2DuLoXEnleDsuuXFxc
	i0EARzu/kOQVYfF9ydL7GngN/y5+ZotOJH8YZIu+AgLdcoSi45VIk64z9a4vilzM
	m61hqAhNsIoRis5xi44FWLOSt3X5GtZ1aR+TxdS5UAfwQ7mWDxbduQMmLnvLAohh
	tBabtGD50vylCcQO0OW8+b679zj6w==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013064.outbound.protection.outlook.com [40.93.196.64])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gs16cgrfp-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 05:16:07 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FcpKAh7qqM8189De2hxTbtBMZYF24xfHWe3oEQCRA5wF/d1IO1ZWfJMSvjluAXuFEibXvRnHbhUWxtrnH4qoqhv5swTyRfeqCThDwQRClCCO3dK7HajkCigVBW84wCRuqZfInELiY2zE3RKynYN5LuTwBiqfAd2KltsCttM65AWJJJ0uIYmWSOxGwpY5ug/+CM5FTMzC0fhvLbF1Lq2qdzGo9rwtXw9OlVYZWArivnyezUndaPRujEhqZecNHKodFd2PX4aQLwko+UyXoOTdRaBcbjqoxxYc8nmL1Wmu5QjQhGBFT9D08RNJxx7x9OjEfFi/YyMyN2rvYA+UHIGsrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yg5UmHlnAcTf8OpeYl36NrfU0/0zJGZnnkWIBVqFA2k=;
 b=Vu6Rae+xZV53kbB97+HyRQyhJJBObPVKZhv4Zz/3IGHBLM1Fy2xrF/qShla4zHCU6IITiubUETe2POUlYbu8ajrMs1MzzrZpMHCS6ZbtAjP1IciUcdbMyEuQMSWaIwtZ01cJfzCJpYhREFrsHsDgTJoEzphPx5IJS/DifoKiyjiK8Yi8g1jQiWX/4AoC+czLJRs5TER4+UKcMMvf+Q6aztEKEa7BMKlgmUSCgMovF7HONOPNCHggvQcB1royJ5YYKm2l7tGqIk7SIY30ZO0nlaP6NB9KtYs9BOytJJCA7KfLuZUSU4f9ruSW6SAY/6y9f+aE4S2D26YVPv5LvrdlVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yg5UmHlnAcTf8OpeYl36NrfU0/0zJGZnnkWIBVqFA2k=;
 b=n6QLuL24itzvu5n4QWfkoLo/lEK/aZPN+CCWXwoxxXkeGrkoaG5usjPvUDnDVxHJ/7vO5Sk8160Zjtn+rq9YSUND1Uw8cNlu0ZyXXNm9LupjAF7eFMsDDIzw4EVDLDHjqCElF2we0Pycap6opRq//4jVRkBsUMSWlMGJ36DOZq0=
Received: from BN9PR03CA0106.namprd03.prod.outlook.com (2603:10b6:408:fd::21)
 by BLAPR10MB5186.namprd10.prod.outlook.com (2603:10b6:208:321::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Fri, 18 Sep
 2026 10:16:04 +0000
Received: from BN1PEPF00018074.namprd04.prod.outlook.com
 (2603:10b6:408:fd:cafe::a3) by BN9PR03CA0106.outlook.office365.com
 (2603:10b6:408:fd::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Fri,
 18 Sep 2026 10:16:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN1PEPF00018074.mail.protection.outlook.com (10.167.245.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 10:16:04 +0000
Received: from DLEE212.ent.ti.com (157.170.170.114) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:15:36 -0500
Received: from DLEE210.ent.ti.com (157.170.170.112) by DLEE212.ent.ti.com
 (157.170.170.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:15:36 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE210.ent.ti.com
 (157.170.170.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 18 Sep 2026 05:15:36 -0500
Received: from [10.24.53.205] (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68IAFXnv590032;
	Fri, 18 Sep 2026 05:15:34 -0500
Message-ID: <dbcca43b-969d-4b43-9216-5790fc82d06c@ti.com>
Date: Fri, 18 Sep 2026 15:45:33 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/15] crypto: ti - Fix spinlock inconsistency in
 DTHEv2
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>,
        Sebin Francis
	<sebin.francis@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>,
        Vishal Mahaveer
	<vishalm@ti.com>, Praneeth Bajjuri <praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20260910175619.2122149-1-t-pratham@ti.com>
 <20260910175619.2122149-3-t-pratham@ti.com>
 <aqz_rKnEDvtobXXB@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <aqz_rKnEDvtobXXB@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00018074:EE_|BLAPR10MB5186:EE_
X-MS-Office365-Filtering-Correlation-Id: 42ab1861-fc0a-4f7e-1760-08df156dd91e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|36860700016|1800799024|82310400026|6133799003|56012099006|4143699003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	T7NjD/d1hHlAaMTmRZKysoh81JJFgw+8Y4qq+TjjHVtDLknhiQHuftpYbzlhS5WBngbo+rnqo1jYDKLEQiF9stQVZojS57TYwWCfjspDkVMpmtCR31t55UJFHXXTZ0KSg2LeHPSX/4cmCCZgWOO9OsciZ/WdEXbJLeu0rLBcgi3rbv6Zj8qKUKyCEMm3cCRw8jwHwX4s57h6qxTPi3PQNl3AFGoOf1cVHPOGd0+1Y8B/A4P1Sddc0WylCxv4XiHRZ8n9p8Y+2A4ZMT/L4uw6WUFqUspXXt1bDqaRS61Ve4ddW0E/XctjmpvF2U9RJK0iDdzUv6DLvx2qgUVIk4OV0vmzd21++Ig7l+qkDD0RfNhkJQFr3Et1IVo8EGwiYpdKPPceH5L/Qdo2LV4lGIUvnR9Sk7bg6jVY5DGOasGDPsvkZpwsjuShLchWqE/1p4WT6gp1ZITfonLHqJVqhZS7FGHXtfPT/0Ea00ll+utZMhdejFOpMupR/fjUSFJdP/sDnQza9kh4KDUqLMttb6pk6ECkCyAgw6VknmY1ohWQdZMb0qo2Fera2/yQiRhAppr87IsZJVDEy4Kmk/mfUq/WbT8PwbSRMKf6Q9dHveV5gNjuJ01QO034YXGY23XJNlu3e8gXXXfXKuGofghXca4Ung==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(36860700016)(1800799024)(82310400026)(6133799003)(56012099006)(4143699003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XFP1PGUhZKAiKUYkMjpjClx1sX1WSTxUCdvQQgW8s4eU83ovCLH6bWS0xfD3YCZTEj5vZwQoFHT5e33zzjQVe8ABqD8NY4welD8QfvYnVVO3l7vYQyo3zydv0JKNoqBgU8LyAiv/fFwWPRMSJfAcQkD1gHNc1YWeQIAxADOJzI0n6d3r0mGYOmF5FaR+0q3FrRNbsSCbL1XUxWSBB+pilvOmW9GfbMy4RpDSrvkABsjr38Yv+YhKk2n6A31c3veGhSMYk4bTo4gtY6U4ERdNPyGEJ52UXQtXAgWIspstlxx0ymgLb7l6X3pKhqPFpZC6QdABdyZUXeaBiU18Fh86a15Y8S7awERQRNjZEnFxhhYIgMq5RJNeFDceW/Yic9qX5rfaaQed3vczKo0T1m2jIc5R9Yy2Dk5qT23B5lEC5Wrf1w1fLku8n/X7FyJRCpjC
X-Exchange-RoutingPolicyChecked:
	4d1X/BGud9Cve9Njk7MNhvslDmRoxp0VhHtvydEXa+2NQL1dHaS4kAFEuadPreuYysllkQB7beuj6+IDlMQV3GNtR5VTTMuFBdLg6sWEmfAJi3wKnpstKSBJOYfaljw5lt1Y7KAGk78QNEU+7A6F1wrXUUQMSk4SsjSjvw6mZsDIcVeEiE482svgtnALzgQg1NtqQP87jl2cNtrie1XkJW1OSMbmNfZOm+yHF83c6GGHoMK7z7eoJDZ+hxpB8XwIRsAltMmmT51w5mfmE+WsyEIQ9RXYYVbqv/2/vSJAMFTNlDyDU2a5krkpxA8sInPn/qiNRrsDo8glsgJGihD4Eg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 10:16:04.6966
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42ab1861-fc0a-4f7e-1760-08df156dd91e
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018074.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5186
X-Proofpoint-GUID: 3bNE4MLoLKYkOh0yguylfTp6MOBNYZm8
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDE0MyBTYWx0ZWRfX3nTR4rfnb1Kh
 cxCqtdaYoUkCkun2pUygs4nTkc6rCuTYa2FKXUDclEy4BA6lL0h0uaPr8iHDi08k4/i92XUBZTZ
 vM8sk5DCeSin+HlSQD30WBbiuNPkYCM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDE0MyBTYWx0ZWRfX9XykgAkAVvyp
 42UYiPuXKuAqWO35x1RjvWbNgwOc/ZlqsGmay4BiCcL1d/DL2TRolz6mYlSZ8auJG7j9uPSmzuy
 ZfuwFxx3BoH/oNLJYbTgZvB731+rRqmHGuAUxBzL9m8OePKyd/9fgvAtwxsZfwUqW0j0oYTe0Tl
 29d3KsWinEQLJ5ncIOE+xp0etqf+MaGZnVBq6HRgXDxAw0+IOOyHwot+8Irl/AGHCqiw25+kxmk
 fRisB5oAbtdmzqG926GLgnDRK1SNsWVIIWvYhTPUMZBf3VUcvUHcNbvCReqmVnVxOEsjZO/H3UA
 keUBrUiIg1lShgjf8FV2/XDnRWQ8L/vNveIiNLJb0FCqijqKsC36ZF50vP8rwJMq/iM8kEB3rHt
 HYa//XMvirll0TcBUFXl6/eMSWHjw8aPLcKSCXqzU7mZrpdy97SJ9ZYjB4XCcanCnDVlLrCYTUm
 RQhWi3+Ke/B5Et0uhTg==
X-Authority-Analysis: v=2.4 cv=cKh1IVeN c=1 sm=1 tr=0 ts=6aad0f67 cx=c_pps
 a=Kac4Oh/pgoirBk7HbaAweA==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s63m1ICgrNkA:10 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=jwouBfj2j3NM8CExmVVE:22 a=c92rfblmAAAA:8
 a=sozttTNsAAAA:8 a=kWnY9tpl4_gDTZ5EVKEA:9 a=QEXdDO2ut3YA:10
 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-ORIG-GUID: 3bNE4MLoLKYkOh0yguylfTp6MOBNYZm8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 spamscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180143

On 9/18/26 14:39, Herbert Xu wrote:
> On Thu, Sep 10, 2026 at 11:26:06PM +0530, T Pratham wrote:
>> Probe and remove functions use spin_(un)lock for acquiring the
>> dthe_dev_list.lock. But dthe_get_dev uses the bh variant. Change
>> spin_(un)lock_bh to spin_(un)lock to avoid potential deadlock when a
>> softIRQ process tries to acquire the already held lock.
>>
>> Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
>> Signed-off-by: T Pratham <t-pratham@ti.com>
>> ---
>>  drivers/crypto/ti/dthev2-common.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
>> index cc02449382673..4c6b72ba104ec 100644
>> --- a/drivers/crypto/ti/dthev2-common.c
>> +++ b/drivers/crypto/ti/dthev2-common.c
>> @@ -39,11 +39,11 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
>>  	if (ctx->dev_data)
>>  		return ctx->dev_data;
>>  
>> -	spin_lock_bh(&dthe_dev_list.lock);
>> +	spin_lock(&dthe_dev_list.lock);
> 
> This makes no sense.  The only time you can use a plain spin lock
> is if all callers are from the same context, e.g., all with BH off
> or all with BH on.
> 
> Because this function is called from the Crypto API, which allows
> mixed BH context, you cannot safely use spin_lock.
> 
> In fact Sashiko reported this issue too:
> 
> https://sashiko.dev/#/patchset/20260910175619.2122149-1-t-pratham%40ti.com
> 
> Cheers,

Reading it carefully, looks like I messed up reading the Sashiko comment
the first time I read it on another patch. It makes much more sense now,
to not downgrade _bh to regular spinlock. Will fix and send.

-- 
Regards
T Pratham <t-pratham@ti.com>
