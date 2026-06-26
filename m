Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906873EBF01;
	Fri, 26 Jun 2026 12:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782478691; cv=fail; b=aIcaTZTz2CYhSeANLUwcTAR6xrFdoXv2kJ15u+quQCyr4CBPpyyCLgRLeYfd7BS0y6ajuPo+YIrsj27oVscMms/zQeeaKgm09eY//korTmGmY6i/vtV6nD7nFVKqmchWrqvSRSmG7Gq5ZY9EJ7rc8hTfpznnnH83sg1lbpojcTE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782478691; c=relaxed/simple;
	bh=I9PuxXaZ4putVlOTCECLYyaqFqKTqxniLi3ZVk7+3Hc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=kPtsz0V7AWiVsp+xM0qWsprcQZEpoM1GjZMEIh/E7BVuMo9FdLc2yXen4cN4Db+/gwWJEy876RV7CFT+/7gzUK+enYbmoj/nkzaFZ5SlRXqNgqvYPRIjwNpuO3Qma8YLD0aeL6kTY5UC3b7NkEKnqx3B40mO/ZbzXltIVwY1vBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=S3Jgz9Gs; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=TztMBjnB; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="S3Jgz9Gs";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="TztMBjnB"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65QBSRV31758466;
	Fri, 26 Jun 2026 07:57:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=q4QlKAGBB5aqpNQ6q30suQjbIxWUKhKfaj0runnqV
	i4=; b=S3Jgz9GsYZVor5NMb6+TU6j5R3OnJ7iQqRUKkGqqBD2iXtYRpSnfHTT8G
	AfPl7xt7Zto08+rgLtU7+/wXWS5Us4IVo21MHYtHdtI3U/iWEoOa1RGHi4gxRcs2
	JYSdXgG2MTO8TeLEdo5mFnXQBHlioINVCjWJzP9QuS502t45olCuhHBQzpQuzmRm
	QkcfOMFVbk0iDIficg5xygHpZwmZ5eeJIdqfvJ2PaiCKhESeCRoI0hCVcFLGe4iy
	TtP55OES0mjXVGirKMEV1eXn3t89JlWUuQbV6FpgH7b1G3KKLpsInDD/aO60bAB2
	RwAQbquiYAHj3tEAVE6RCY1yr0eMA==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011047.outbound.protection.outlook.com [52.101.62.47])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4f1rk18b97-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 26 Jun 2026 07:57:56 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j4N9IKrrFlQrPazv+oUnmf6IjkmZ/hfYHLxAtrDX0rLp7HlWHKo29LiEy8QxbjwiGF+wmEB4KVJSINl7HHKoAaGlgpnDFt6j2BVvAusMlLC5rWBAXrHXsThg0S3dZ5AI2QCjOjpe8GY42SaOT1mzRPCLmaT3v2d/rsaaNi4662aHxZHdFv3uXNzvslJnPp9TGdhemr8eJQBIvwlzKJDsE/8jrWT3lJwUXR4O3TuWmbslyF3SERUa3PWIilOqIFZYik6KT6C59GcmbhgHasqctegAk5nBWbqJYi9hmYKiYQzc+t2bZcqBsgRCI7+bRJAGXo91OpsXTq0krDIFeNUhRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q4QlKAGBB5aqpNQ6q30suQjbIxWUKhKfaj0runnqVi4=;
 b=br+/ANAbpia24coDFuLidE9ldEW3nb+flG5/7n6Fqx8nASfIdUgniUXt3Ktarw0159CHPzxTN/tc9ttHGgpXXmsj/o8x6WMfCDvGEnhdyk8ljp+5TT10vvo9WlB2OpT2tmsTwvIVdDdlZFgFdQTOshXjK/ZN6GmL72wa3ZgxELIBRWTgSYNkhiEeH1zKk7S+mQfH7iR+MMEREJLwaTBTr3ZYta0wcAnepiVNn7mwe3mAg9CU6Zy9k8jWHYBVt9iq377ZutqUJNrggVQEET7sob+V7NKYak1+T90wfg7A6N1h7ExwSXQQtTh70kA3SYmOeKbIyqwKCyiZ4iVDID2LQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q4QlKAGBB5aqpNQ6q30suQjbIxWUKhKfaj0runnqVi4=;
 b=TztMBjnBoQ0WE6vmK60M7mzdsib29WR5NcgZ+uq0NGQHQpuOF2adEQn14XUnHG4SiY3f+HlGzwHQYMHZ35zTFGuzlDHmthqzGvD7wjOkA/7R4uPrN82O2H023uFzmzkNwb0nj3bdc71qiH5jWZ7r9vmvzvnEQwa9et3Zd9Q7Ets=
Received: from MW4PR03CA0082.namprd03.prod.outlook.com (2603:10b6:303:b6::27)
 by SA1PR10MB997607.namprd10.prod.outlook.com (2603:10b6:806:4b7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.16; Fri, 26 Jun
 2026 12:57:53 +0000
Received: from SJ5PEPF000001F6.namprd05.prod.outlook.com
 (2603:10b6:303:b6:cafe::63) by MW4PR03CA0082.outlook.office365.com
 (2603:10b6:303:b6::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.17 via Frontend Transport; Fri,
 26 Jun 2026 12:57:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 SJ5PEPF000001F6.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Fri, 26 Jun 2026 12:57:51 +0000
Received: from DFLE201.ent.ti.com (10.64.6.59) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Fri, 26 Jun
 2026 07:57:46 -0500
Received: from DFLE201.ent.ti.com (10.64.6.59) by DFLE201.ent.ti.com
 (10.64.6.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Fri, 26 Jun
 2026 07:57:45 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE201.ent.ti.com
 (10.64.6.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37 via Frontend
 Transport; Fri, 26 Jun 2026 07:57:45 -0500
Received: from [10.24.53.205] (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 65QCvgWn1541100;
	Fri, 26 Jun 2026 07:57:43 -0500
Message-ID: <8502c0bf-5cf8-4042-a1e1-4665d8fa4057@ti.com>
Date: Fri, 26 Jun 2026 18:27:42 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] crypto: ti - Add support for SHA224/256/384/512 in
 DTHEv2 driver
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Kamlesh Gurudasani <kamlesh@ti.com>,
        Shiva Tripathi
	<s-tripathi1@ti.com>,
        Kavitha Malarvizhi <k-malarvizhi@ti.com>,
        "Vishal
 Mahaveer" <vishalm@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
References: <20260526094355.555712-1-t-pratham@ti.com>
 <20260526094355.555712-2-t-pratham@ti.com>
 <aiKgs8ipDLPlz6c4@gondor.apana.org.au>
 <e0aec964-3303-4ca2-8d96-6a5d8f5ec9e5@ti.com>
 <aiKsFNoXryzWul0y@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <aiKsFNoXryzWul0y@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F6:EE_|SA1PR10MB997607:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a8b612c-02f2-4dac-34eb-08ded38287cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|82310400026|36860700016|56012099006|4143699003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	xXFu9/g21vLB3ii5F5G+b1vcQNX4d8dwc7DOUqv/zyCCF+5neuLcs1bFnez3d/OwlS9mHZ77LYAUNAW7+pwKp1vwDVAA6AGYisCBPSejp6LEocqRO8GMJLNLkiU2efNeM3q/tMEIj40l9ZkpjBLOj3IOPNSzmDqtuWTIxlbFO+IQWBt0Aq0my5muSMyUIp0I4cugQ88SWTAgzJptdoYIlAIP5cbgP1kvzpvE38HCQCF5nxB46uFF1PNBMJV+EguLzmJe9Mb3TGGj7TbGJ/mBJ/sSrkSMfBCg2GHVLHthGqICTNncn0AcCkjKMImyMm73GquSfvG4pd0nVYRtPzIczwKsheLY+bIh4M9XAxVxZBp5h6Xh+dgR+7qjotzy8GClPy3Db47nALL+SFgy7yKkyJ27F1bv53jdCG0xLolMxnwOLBEL/Cz0kGwdZRJOatFJrgUf85wKpsi4VNDzkwErhM+z/bYk7LpVY5xQ8mgwuWEo2tQqZ+4KZlc5aGSZsGsiwkCHCDIVQNtsyoBRp48g3UB2KyYbmUS7yCZyV3CRgJsf5rXVLcezGueIS1s8vFREu70ts29nkNi4Ohw4Ktw+xYs18Ntd7y8SFIvZ+QS/RF0UJ5Zw51pLBE4PoxKSgna6bcmldMcZ0/ExnitMJhPlD/sOlPaepLDftI+oB25TQBrCwBmEDd7hZQQ8ph9uXpbSXmg/Wdk1OpBHUicZKhqgyw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(82310400026)(36860700016)(56012099006)(4143699003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YIfXGlWfWv3aYGZldgFohSbi/S9Lbmgg79+w4U7qgCnDU/m6VGoIMsFAyu7skwHDp0dp3cx8qZoLlBukkkiHDiWFBh4WANC/alPV7PJE+mbrNughu2OlxVXQ4oINB9FzPtqFE3fKqGYdEjLZuGUq08U7W070bbLL8B53bWIPm4x9gk+HPOOd0AMEyS+IxwT1egH4a7SMmjpAra+Yjo1+4EfXnW5I7OmqGeRy1RUct6VXSUIgmXOuGKBzAgHSZk6hv71yIm1hXsEWmMIXKvdFbbp8pwbErNOzk8e0FQF6m/3GMPqR6XptdgM+/swKzCEnrPF5/ugSgtKUecqdvK+KjDBQGtDI3dwlK1yyUk+Vky4JTOCXgyC0SkHdIGFnUVa0dAkaRldFOV3EmkHJzEZrERhQ3RCaGtVzH65gYQa+SXRyMMceWC9noTeFoWd7mW/B
X-Exchange-RoutingPolicyChecked:
	kbozNKCrzNXF4rj64RE1A+c3GdJbuZtoZahdrk5fnC5snrRKA/ZQ14JLOTmIzDJ116TnoFG9RSt2VU8Rc2lcCdAOtkly1G1zPmWQ+zGg0dS9AAoYBT0RUX3nt1gXE1KkddjC3LhX4pihXxgTMsrFvvCe6RwhDjmWfHksEy/MyQ7NCRjLx8gQDx5q0unHBrw/dNyISZ7Sk8EfuWDFeD5UsK/p7avBDFCb9LDru0GpXuAwlXRkWT0ld2FWEMtHgj6QtwGygEkS9eXPV6iuad6lirseDWRZEz4guy9uSFw6S5b+onbAGCWlG8fb22vkbzxX1YdL+ljliPAknE3xxY4y4w==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 12:57:51.0116
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a8b612c-02f2-4dac-34eb-08ded38287cd
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997607
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI2MDEwNSBTYWx0ZWRfX5HbRd6YYi0yS
 x4KavFky+PgE7yt77MbAcDy7tJtKKZRBo4w1OjWOCSLi18LwEl+0D71vHAhvlP4utl8LnnJOz28
 BO5T0qKKL7U26YgPDkfdWorYCfmL6UE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI2MDEwNSBTYWx0ZWRfX0/bSEdLWqUon
 laPfL6w432IQFunjiC+/6u4SXI4sonwFgV78C+deJEBsATkVmIk5b+KkldPgjJ0fphVNhG99XER
 UYjSkY1mYKHMkXyKagZUEL1hGXaL7tz2+mEx6uIMY7UAzs9/FS5xvbomPos5ag588Kb5GPw1+UT
 X1a8y/5u20WqCqkCrsqGCiSVuoiS28HHH9BSyv+Orib5T1yhny1bcHSLtBpqaQeB0SI04T7CRaG
 95rDm0VqvjhOYLegzWtdAfLBu10saGguHITRqrHbhm7Xwbo750WXfwmh2ntHc9Xx42wwk2alAi5
 bYrS5GKmvvp7CT9YN7rW9UydpYiuPy1T3XNV1FHFKpJfspHTM9v23xD56bYrZCtcPKB55KhCj0C
 NgpLmqqXX4RL3zkWRtgZy/9EgEpJbFh/NsPPxzpZQjIWsw9KGfJ8e6QjoxY7cC7h0MZo5n6I05d
 3JCHoEgvJ3IpSzW6CUg==
X-Proofpoint-GUID: UtDtriZbqEehMmHYoGbCQe9hLH_SBPjU
X-Authority-Analysis: v=2.4 cv=QahWeMbv c=1 sm=1 tr=0 ts=6a3e7754 cx=c_pps
 a=U8qasQFE1QqC7dgCSsktzg==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=tHpjybqP2qGSE--kWhMA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: UtDtriZbqEehMmHYoGbCQe9hLH_SBPjU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-26_03,2026-06-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 clxscore=1011 malwarescore=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606260105

On 6/5/26 16:29, Herbert Xu wrote:
> On Fri, Jun 05, 2026 at 04:11:49PM +0530, T Pratham wrote:
>>
>> .cra_flags sets CRYPTO_AHASH_ALG_BLOCK_ONLY and
>> CRYPTO_AHASH_ALG_FINAL_NONZERO flags. An update of 64 bytes will do an
>> update of block size and carry over at least one byte to final. We
>> always go into this if block when there is non-zero data coming into update.
> 
> For AHASH_BLOCK_ONLY algorithms, the export format must be identical
> between different implementations.
> 
> Therefore FINAL_NONZERO cannot be used for only one implementation
> since the user can import the partial state from a different
> implementation which does not have FINAL_NONZERO set.
> 
> For sha you cannot use FINAL_NONZERO since the generic implementation
> doesn't use it.
> 
> Cheers,

Thanks for letting me know of the export format constraint.

However, this sounds contradictory to the stated purpose of the flag
itself. Commit 7650f826f7b2 ("crypto: shash - Handle partial blocks in
API"), in which you introduced FINAL_NONZERO, says:

"This will come in handy when this is extended to ahash where hardware
often can't deal with a zero-length final."

This is exactly the case for DTHEv2 hashing engine hardware. Along with
this, using BLOCK_ONLY is also necessary for DTHEv2 to delegate the
partial block management to the crypto layer. So you can see that most
hardware face both these constraints together. The above commit gives
the impression of solving both these issues for hardware hash engines.

If these flags, and the surrounding framework was introduced with hash
drivers in mind, this new constraint of import/export format consistency
makes it completely unusable for any standard hash algorithm like SHA.
In practice, this makes any hardware hash driver unable to utilize the
FINAL_NONZERO feature.

This looks to me like a gap in the framework; the implementation of the
feature does not exactly match the intention. What do you suggest should
be the approach here, and going forward?

-- 
Regards
T Pratham <t-pratham@ti.com>
