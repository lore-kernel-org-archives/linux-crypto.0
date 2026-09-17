Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC794B1CE3;
	Thu, 17 Sep 2026 10:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789640049; cv=fail; b=m5TsOAJip78fl+AhRgFP2AHttoMfmiPEZPLhZIppx8mbLulWcYcSSHHjJ64lAKyV2yxYucXBRjS2gNo8Y3zjizWsNogVHCpkhHOD5ak2nJIyp+2RZg1z1PjoSn8+BlYgroZnVYQWNXWDGdfPv9psbRYYOh509VfZPAJSmATHb8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789640049; c=relaxed/simple;
	bh=F5h02IQonpmIuEajs2ej7qYoU7xwzEZsd7B2XYefczU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Z/0Rgq1pEEDWpiPVK4Miwo3adhpMRVTGxZpmTWgTRO5cn2crDSfPvCu0e8iHTWl7fb+ssyJ3w+opOkt/78+ccs+1VmuRrF5M+uqYQ6tmkbzjRm6c0KZzTK9bFdFYnSpVzG4DtVJE47wlonsId98X517YVkQM2KwuehDqRQEOIAw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=CpYpXK0B; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=OmKirrfw; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="CpYpXK0B";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="OmKirrfw"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H9amhd1437719;
	Thu, 17 Sep 2026 05:13:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=TCIRqjra/CDtqMt5VM3IAqEoT34q/DF2Ov2kUU2Pu
	5s=; b=CpYpXK0Bi0vqW//rKLHjeltTK6kVMvfkp4Uo6w6CJoPhl22J4L1/a1rV6
	vxQMefCOysc+QesZFR3fOIP6BX+s38rXt80VWl86TviKDPhwwobuyB+yWUNl+nfe
	aaN1wHXFWexYAEgYhebeczl0RBL6O6x4RkvA4T1D+Fkh+wbCjp0JXweDmpsDIcez
	WmCz7vN1GhKRWnQPSXDPCR+BGdjCGhYBEE4arGD+4MDhUjDcwSZCbf59Ndw3flbW
	a2dqJuIF2ZM7b7GUvZOWeh2MA0IAT/wcyOCviADWNwqPdTq9/b89JRYH2+0AL1gB
	T6wA07iiGwm8Y65YXUQTVR9v8kBTw==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010051.outbound.protection.outlook.com [52.101.46.51])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gr4wnkd8n-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 17 Sep 2026 05:13:55 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gMRIhMP8fDTJPuZhrZf+rHe6IJr+ktPdnCghgQEC0mHtdk0KHWhUyyubwtL1OKM866Io60IrTiQJ8hIWah8RuyLwKk1YvO8QJC++Pf1cfIMHSW+Fe6VDx0JcuSfY1mSZouNy3r8JCyoQYYL1Js7PjxHLgrzW0qA6nB50d47G+TxWinfwiSb0PICXu3IWJtFhsSsmX35vW6VrikLCOrirtI9jQYk4mIOTDw8lNDqvE+k22EFGfVG3KIMBUXyk9BTSKNdkCc81kuo25JzHpi6hFBclrFXfiCyUdixcHjjhv9PF7cBHnxrlCZFsg9zHAftOoZZaybxr+OuVRVODluUOeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TCIRqjra/CDtqMt5VM3IAqEoT34q/DF2Ov2kUU2Pu5s=;
 b=DsZjZDOQsZOO2vLpoYlxWkwFWNTnvKZeIgzbRVU2lMRh2JUOp3Rd5JzJhoQtrN8PjtQtqn942LRKFlu5GbGns6vhoyAZyQ9DjEbrNAiIl3OeWF644xX45WjmXh0Ow+k0tP2+w/fiRpBse78exRVipqggFGoTXUYHd+BKkKHpiTIPen3UoaAz72jKAdx1YxeT0ClV9xVVLq3IBudFKsQSHUFlprv33s8GtXPk2egov9JaVGN1TVkP3iQ8ya72eZBPVKV6bhK3llDVlgQtAF8f1S1qUX19GdNjCdP4hPlMjcVjv41TmeNDYZNa2EQgAbe/u5QXmI2vlNFx+AHBh6vXOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TCIRqjra/CDtqMt5VM3IAqEoT34q/DF2Ov2kUU2Pu5s=;
 b=OmKirrfwHCTlIstvkF0iroik/d8EietfnQuxArS7NA87pgalybq9438Lbjhx7ZyF9rC1QgLKDbet80nmJG3fFTqpEh4rUtmys1T1AZVZHm98kG+lh1tgF7HcE3ZADU2S3s0lVfxqzf5Hb7fbaErJJP2DUOJugiyc1XHvcJGwXkk=
Received: from CH0PR04CA0005.namprd04.prod.outlook.com (2603:10b6:610:76::10)
 by IA0PR10MB7547.namprd10.prod.outlook.com (2603:10b6:208:493::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.12; Thu, 17 Sep
 2026 10:13:51 +0000
Received: from CH1PEPF0000AD7E.namprd04.prod.outlook.com
 (2603:10b6:610:76:cafe::e) by CH0PR04CA0005.outlook.office365.com
 (2603:10b6:610:76::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Thu,
 17 Sep 2026 10:13:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 CH1PEPF0000AD7E.mail.protection.outlook.com (10.167.244.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 17 Sep 2026 10:13:51 +0000
Received: from DLEE201.ent.ti.com (157.170.170.76) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 17 Sep
 2026 05:13:49 -0500
Received: from DLEE201.ent.ti.com (157.170.170.76) by DLEE201.ent.ti.com
 (157.170.170.76) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 17 Sep
 2026 05:13:49 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE201.ent.ti.com
 (157.170.170.76) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 17 Sep 2026 05:13:49 -0500
Received: from [10.24.53.205] (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68HADkBv2804567;
	Thu, 17 Sep 2026 05:13:46 -0500
Message-ID: <dfddf92e-1547-4cad-94c4-b5fbba098134@ti.com>
Date: Thu, 17 Sep 2026 15:43:45 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 23/30] crypto: sa2ul - fix stack overflow in
 sa_prepare_iopads
To: Manorit Chawdhry <m-chawdhry@ti.com>,
        Herbert Xu
	<herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Keerthy <j-keerthy@ti.com>,
        Colin Ian King <colin.i.king@gmail.com>
CC: Andrew Davis <afd@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
        Udit Kumar
	<u-kumar1@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162@ti.com>
 <20260915-b4-upstream-sa2ul-cleanup-v1-23-57ab34e97162@ti.com>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <20260915-b4-upstream-sa2ul-cleanup-v1-23-57ab34e97162@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7E:EE_|IA0PR10MB7547:EE_
X-MS-Office365-Filtering-Correlation-Id: e5106153-879c-48f3-5445-08df14a45f66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|82310400026|1800799024|23010399003|10067099003|22082099003|18002099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	K8Z3EJzGguOsUzjYYDo1NitDI4VrhsGJMM2NbNXyPsvmw3MXlCGBr3qS07rZN4zV6QYWFcGB+h7RpxAmRbcFtlA2xQKeYodi3i+zFgMOaw0F5EAW+30L/bfrTqTkoiayf6KwFExqvuAjxj6zKdzdxvPRIKy78cm6DSi7NZ79hIsv0qtS9ztb9PZSskO6/63oOu7/JGDd0gPZUeP227e0j64PTOvAF1rEKWFdTuWx9VKGprJA/SEK236Yk0Wm0JumMGE9RmmJw26MkaTQoNtVeYKCqvtASY8fk50p9hkNh9yqC/1xxZYtPp0E6qTfGyCRRWFmA1qj+TJ0hzQ6330m57RsGR4kmtTWHnbsLTjAM9jUk5zWUWlU4N/QbJZSfN+LlLu5LypqU9s26CYbyx363urPzz1e71jizeI11vQ0gsQfgcjZfLY4nIciZkFI1P0qPmjgyvsDvjdblp2gdQlJkjikbJVIYi6hNCHEmPNktHGs+cfmv7wIO46o5aGfTAH+chE/0zXfM4tlHaBIlAfCBo+vj8DVPV8dJWK/Qx/VMB7g3hozYNPE1vDwGdQSXjA4txHWsqUJAcEdkfGJdcykDM+LkEhhxM3m3CSFnEElTBoD4My/EEFkOws2cae8Mzoy5hE9eDL4JHISedUMH9DyeLvbK2Df3MNg9VpV6BVNZGZHOWvpzXhcDrGNES+o+IQos89enYxTiIqfMGk16g7xKQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(82310400026)(1800799024)(23010399003)(10067099003)(22082099003)(18002099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YRkhZRdJ0bR8mBcMHoxSngAQDnQmOna5/gqr7JFG73N5V+i3jcoEJLCfXUSBuvtCZIZK6YhjksycjaqIDZO+4grJaa55S8Gk1klJTA+GRtS/rqU2iTzZgayCB40CPf5y4h76U9pX9tpKvIL+LJq7Z619lCTGJPelvGlcHj/9wBTBzvvTP7QUGoRAa4o+M89mpNXiXBSxvEWgWRpkFVfRpOLBs/VuJeGsIVts7PtPzmHFLI12hDe0PzhkdOr+HggIihvc87mM2WPsHDqY//zqjN0fiPTmPxOzPyK/TDNpzNNpyJEvfy7SzCoQft/ZeM3zLoDFa8LfrL9fAwALdl21V92Wp4nA6elI0vU/7PsRo/1vcD5Hi5DcFgmKd/xsJLo6VIluvqZPVcYg4VyQJQpRnsBu+H8S9XUtBGQlUPJzZbQkfzvhbtuTW1HE/LBOMndB
X-Exchange-RoutingPolicyChecked:
	46IKrR77UHPRTgvoO8Y0dOcsNqaSao3wUiRzlBI/0/lPMh60e8vUlaULn8q5oI2Z4zCHZvC6OjTP6tGozfNbJlvQvOe9AEcz15H7+G2pgLo1VwkB54zDNqIOyXiac2wbkBpKVSyb/4SCC+YgEDgShIK3DLZYBkhrA/ZakYcCAaLFllqptwYqPvHTR8FgT7pJf1YUaf3UURLtIhdQmdv1rRqF7N8vLQLQ5drxAaTRACQmleOZPcAs56Fgl0Nm0AFJI2b48Em5jYfj4yBD/C0tz/z9sDYQm1fGdka+qs5LgqiyA9gnv8USv6xIvRq45SCgVqdms7M20ijSwzbR/Etw+w==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 10:13:51.6647
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5106153-879c-48f3-5445-08df14a45f66
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7547
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDE0MCBTYWx0ZWRfX1d1wlLzOGMVF
 hv/99Fy4WqvIwOuMRFs2UDGJzcF78KfDHzj0PpjpURaPDATCej6M8/+GVAP9rshchb/YRajDISj
 jluYmq16+UYluYYt1Y2sAW/svOvJIZ8=
X-Proofpoint-GUID: mHJ0qVxypdNlpTP7EE3knYhZhHtdBZPL
X-Authority-Analysis: v=2.4 cv=OPOyTiaB c=1 sm=1 tr=0 ts=6aabbd63 cx=c_pps
 a=6wX/tLcgNF/HagpTIcwFsg==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s63m1ICgrNkA:10 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8
 a=deXQ5rYGxmprgFreiB4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: mHJ0qVxypdNlpTP7EE3knYhZhHtdBZPL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDE0MCBTYWx0ZWRfX4RPtBNg9J+g/
 vAgz6FI+v9182WblpbMhV9D7f+MoJ6e54sxUO82E/QkFkwuIyuGA5SVzQrpOWWO+03oCPIT45v/
 RwSZRlJPb9xSZGg52k2DPgbbo1lcFjEHhzLX77x0xhzfqI+mgeAWG8m5pRZpb01or6eZjsCLKE4
 KJq4WuSjJyF5KEJKgK0/ibyLDMlKR24pJg1ALheNcYzoXJV4bcDg9TXvTk+103eFssEI/NigMPq
 Ay+/BHCeFkfDXaP0G9tLBY/WUnOasggWTnwnj/5AhQm+jG25KunDrcMLb1PmKhSaraCJ4EyUhRX
 nF/xiBARf4YK8+BnM0ORIczVHRbK2wXgnOAUSumdWYPcP4HhL2iLcoh1bUNqWd6RxWxObzWAKoC
 GlvJ21TWIItXyMD5O4/n7KOk4qi1sT7pbNkPFtv+8ELKnt7Yp13LxTEe4UqWHLryVAfO4+frLzU
 pdJTzz1+dUiZZAr1gRA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-17_02,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 priorityscore=1501 impostorscore=0 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609170140

On 9/15/26 15:25, Manorit Chawdhry wrote:
[...]
>  
> -static int sa_export_shash(void *state, struct shash_desc *hash,
> -			   int digest_size, __be32 *out)
> +static int sa_export_shash(struct shash_desc *hash, int digest_size,
> +			   __be32 *out)
>  {
> -	struct sha1_state *sha1;
> -	struct sha256_state *sha256;
>  	u32 *result;
>  	int ret = 0;
> +	int state_size;
> +	u8 *sha;
> +
> +	state_size = crypto_shash_statesize(hash->tfm);
> +	if (state_size <= 0) {
> +		dev_err(sa_k3_dev, "%s: invalid state_size=%d\n", __func__,
> +			state_size);
> +		return -EINVAL;
> +	}
> +
> +	sha = kmalloc(state_size, GFP_KERNEL);
> +	if (!sha)
> +		return -ENOMEM;
>  
>  	/* Export the intermediate digest to program into SA2UL */
> -	ret = crypto_shash_export(hash, state);
> +	ret = crypto_shash_export(hash, sha);
>  	if (ret) {
>  		dev_err(sa_k3_dev, "%s: crypto_shash_export failed\n",
>  			__func__);
> +		kfree_sensitive(sha);
>  		return ret;
>  	}
>  
>  	switch (digest_size) {
>  	case SHA1_DIGEST_SIZE:
> -		sha1 = state;
> -		result = sha1->state;
> +		result = (u32 *)sha;
>  		break;
>  	case SHA256_DIGEST_SIZE:
> -		sha256 = state;
> -		result = sha256->state;
> +		result = (u32 *)sha;
>  		break;
>  	default:
>  		dev_err(sa_k3_dev, "%s: bad digest_size=%d\n", __func__,
>  			digest_size);
> +		kfree_sensitive(sha);
>  		return -EINVAL;
>  	}
>  
All the arms in this switch-case are now doing the exact same thing. If
digest_size is guaranteed to be supplied correct in this function, this
can be removed.

-- 
Regards
T Pratham <t-pratham@ti.com>
