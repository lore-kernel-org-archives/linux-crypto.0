Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F544A2E11;
	Fri, 16 Oct 2026 12:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154754; cv=fail; b=g42DtU/FVJW7lb98yFTX8zz22WwBiX6ioRGRspN5+otxVQfBS9kzqi/Nwp9m7swhZteoxeSJ0+g8v6Aj1ckFQVqjbVw2ZUIfWZZ5u6IpTlndM0tUx4AqbkzEVDitYEYk60PB6DeKI27mDVRyyPIGYxpiTE1ZvI028CIIDqCktu0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154754; c=relaxed/simple;
	bh=UWNnQQFOWMldlulocf6By0PgAP5rrXm3/StInUh/bDg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eHnv6weA57q6HdeiXcVxkOC5fikQQPpUeKdzIW+22t+ZzGwvfy5h3eNlVuN4QkwUxIOVEVIBCXfFPhAwKYTd4CX/pQ1Wdwe/JOlYCFNGre8JUsd0wBiQe4KRTr7f7L9e2T+1KWMUBktLABety2XU3XRK7NO2YASnZDHerqBZC7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=SYL9PukU; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=ZbJ7Kgw5; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="SYL9PukU";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="ZbJ7Kgw5"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GACxI74171199;
	Fri, 16 Oct 2026 07:45:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=WC4dzdgIyYOQvNxIJmIniLPFWBZ32UcdK5i+uOKE7
	GE=; b=SYL9PukUat/v5Nd4wWjr9PdLe1tB/AkHhCa0b0zauOeq3ix1P4Z6rYZUg
	mKX6gaOcOzHPco2VuoSRNGvQtZ6ocDMVfZ0ISU0zmSlEorWgbvscRM6S9zWyVM9M
	SLhvh1klohilvzGkM4SX9poqNFlGB30ILUJ8SqPMPjE6mTwj604IN1ZZ8kfGFfS3
	yJ0o9kKEterEFTVbFwX6YXlsgt6gOcDexbFgbPJJ/rI39ZzAZTfdTtGerkNtcrX5
	Pwsce2nnQ9EmqEX4K0so8sR1st0U37NjjJ4QGYPEZ4Ah4+GmjwUtpGCLWoP+yU4J
	19ZMDHhOiURG1ILWopIJpViSRqAAw==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012040.outbound.protection.outlook.com [40.93.195.40])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hbhanru8j-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 07:45:45 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xrG0dcnwx+Ll9fcVMpyhr4bnZrUUYswWQltuzBQ7q/yg16Paxq/zWQ+yOJO0ZP+zeXDrhkun+u+8HUK+TRTUBthvlFLnrDTnwACwZy+78oSn5/CtLsPG701dQCU7DI7GNk4bY3VNSQU2FcCYs0RlKNQIe7UjSFE4pmiLCZPsZAcMsvpckxHa7T9YPsFX7u+GStw23/GNIVK4zDF0IyWqoLH/eaAc8h59K71L7stoWdhs+WEkpJU2uBV4gSddFbnXQhilm3ZqTzrzfKVI2Po5TUrgsNTI+cYiDK0hGekU2S9+zW29h/PIZ37nIJtHcbddFqG7EHF+qeerEdtrrMmGuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WC4dzdgIyYOQvNxIJmIniLPFWBZ32UcdK5i+uOKE7GE=;
 b=FY4I8It9p/zQLHK0nByf+6PIZMe7A48J1MF9E85bA5uHnk18lW90cRk09KlRmktCBMuxILIFXlzDyEDIh63fyYeU0mZsbOIOqCp5YG1n0yuBIOGjd8c6sHF6JPh9jPFOft8GKXZHTn1sUbltKf5G4m4HsRw9jh0fUWskXyw9Dinvd3cFHZWhIOmbOJDDQbgYaduSiaPxGxEpxaKhlCIJCYZCHxGSiEnw8Sl14PtV5Y2Mu45dKvsAl/A0/KNhd5fat56S8NY8OoBgqKDw29ev/5QovRToXnJ7LKyISuku4kmjGwqTpfJ5nGyL6tljo9reFckjlurXPfMCr9KKohcqsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WC4dzdgIyYOQvNxIJmIniLPFWBZ32UcdK5i+uOKE7GE=;
 b=ZbJ7Kgw5QdXJp9vfKE2U1OsrXEJxMv/p1VV4gt2t9W3YGDgV/cW9Td0oPZHrdTSwNBDy1j3/aytQuESDweGoarM21VHXoMRdmLLRvM2B0LEjbJCh05YiQnDgVu05G7ntEKW5y+QsolGfJR6iGbeEWHnCtZXliMqYnX7RCvLzQAg=
Received: from BN9P222CA0007.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::12)
 by LV2PR10MB611377.namprd10.prod.outlook.com (2603:10b6:404:302::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.11; Fri, 16 Oct
 2026 12:45:42 +0000
Received: from BN2PEPF0000A991.namprd04.prod.outlook.com
 (2603:10b6:408:10c:cafe::80) by BN9P222CA0007.outlook.office365.com
 (2603:10b6:408:10c::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Fri, 16
 Oct 2026 12:45:42 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BN2PEPF0000A991.mail.protection.outlook.com (10.167.248.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 12:45:41 +0000
Received: from DLEE212.ent.ti.com (157.170.170.114) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:19 -0500
Received: from DLEE200.ent.ti.com (157.170.170.75) by DLEE212.ent.ti.com
 (157.170.170.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:18 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE200.ent.ti.com
 (157.170.170.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 07:45:18 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GCjH6M1587521;
	Fri, 16 Oct 2026 07:45:18 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Mert Seftali <mertsftl@gmail.com>, Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
        kernel test robot <lkp@intel.com>,
        "Dan
 Carpenter" <error27@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v10 01/15] crypto: ti - Use list_first_entry_or_null() in dthe_get_dev()
Date: Fri, 16 Oct 2026 18:14:42 +0530
Message-ID: <20261016124456.1802080-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016124456.1802080-1-t-pratham@ti.com>
References: <20261016124456.1802080-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A991:EE_|LV2PR10MB611377:EE_
X-MS-Office365-Filtering-Correlation-Id: eb095040-6112-404f-b3e2-08df2b83630c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|376014|36860700016|1800799024|10067099003|18002099003|22082099003|13003099007|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	GU1moQfjigIYN2zhqDyOkY0Jv12EGQ7OTU/R6U8ghFrHyvaDp/vL88ryx81MCzgpzF0IaE9ncfq5iJ/khMfdvPVS59i0A2UBECKNFZht83eC+n3uUNRLHtGEVmYsFT27oH7WrIUay7Cq0eaqPRvsbJqcAFEO3Qs/ENFDCwNZem/X30oYBzsCLrswUQmcqDsn1sqtHAMKe9mJFQfDDa/uW5es84wLH3bhz2UIRNmihpJ4S6bUcCiqmd/oXnmCiIbemeK0hQvZjgtIbod4oSo3DXYEaDWPs1Y+xFzfGoR0wmVFHE6r2cmQL7gW4YbEQI/lagQq+VZlALb1tZGVuasxjnCrve9l4tKHgITL6JXmeDpcMD+Ao7ZuAxFcFyBO2QWAja8B9Mk0TEQ5aezFI8U5Q15IOfoPUYVZLMDV5G2FUAstgHsFCqL++0EaVWQ7mV2mzLob9LOh14CaSw8lDgrJB3sOv4A/er7pmgL8jPOBLgULYtDg6g+KgdwiPIph8vEprmdjFMTOxV6hmFt0YoVN0v9iZbhvBGB46gzDhCA4K0nFdLqbMvttwdae03s7VlEVQqQgwV77/oZkgTvcESxr+gmonQiVVa5M9xv+W6O/UIoKa4en2Xm8kL05CMNoGQRWksZOgbb7Ll+m6VSOMdPfow==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(376014)(36860700016)(1800799024)(10067099003)(18002099003)(22082099003)(13003099007)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YXdvkW4MtbXQ8MR9pcdBKP8uUcnzci+j7RkRXlU9GRo+XxLdxNy78GzE7OBl7uDr0EVrRHONDHhCiKsOdXMtWRlXNEOeuG/8WGLl+N1tNKHMLR7Q5KT4o5yFUYPIosSTdBc2NtApBrgyftSFpQuvOAqc3laxSJR57e3mQ0rksbJG015KYFCSx0Y08vd6V0e0yAfETWOIQTKxtjljSYXafjKxB/W5XA0TEtxM6DZ1ZY60VB3lEbpaHOEjKXnJ73vCiFKEQDn+QsyI+YcYlotAQv10n8Qg41MVtjMIaSJMWdlWbPtkrfIC/r1MTZyKzDgKSxW79LwoCwqs97pQZBZ3FnV5/sDlIkjavA0nu9oU1dXUCi4kJt8xXuZjtQbz8brQl4B2G7+t8vCqvdY5if/I99N7Y9gpWq66o6HQzcWWn11q0kU0EUA00gpHTW4m3WPM
X-Exchange-RoutingPolicyChecked:
	vVdjUazPVRW53a45aRflblaN3YAuy9Epggx48e747gyEAhYkYQEWa7ZsaARVTjmY2Z3ScU3yyW4ntdngNtLw1ehag0gygliLsu2dTiFVvMwiurwzzJeq28m+JnYZ0U6n7bcpL6BrI7BdPV1C+SBv1gVJJEQlhHC1yAkL3z/cLU/lUD8thsDjaHgy0oZtge0TUrPz1gZgWurUbrfKL0w4MwYH1hw8/i9ZW0yoEmqcRd7eAwa9Nnfnl0m3Bsb2dZ2QG/879SGh4WbJnNNM7DYxzJEx/T4Zx0a58gF1zWtBYYsO++ZY3zqSUQeZXNOica4TezsBN7NOEFhWUDnWE9vP5A==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 12:45:41.1136
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb095040-6112-404f-b3e2-08df2b83630c
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A991.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR10MB611377
X-Proofpoint-ORIG-GUID: wGtZ8US8-N88LXgJbJYmAgf_rY7jrqPv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfXxq7jQiYANw2H
 YJcPN6/U9/mjXKpF3Vro+ZYgOyJoCFuHAkYplqTDw6WDpX2+fd4hwLB5OsvIq23OglaQoZsoc1+
 DuF2Po9umj3B84FSUpdciHFMOSZuK6JWI1wDgvE+2bjZgtbAFnO8KGCZc1O4AiX7KTC8FCorcZa
 ra5YZpQUayEclEoVRfkvdTkRnJbJ3j8PZun94vGAQEJdsqS6Oi9lmGcgEDArO+5okYSGsVTfp4h
 6XHnHONolS4nSRH6JySsACG0sEb0tCbPJHysUHqfiocZgow7xFMCNkJh4Mi9rDlPity1IwCTP3H
 VSXOTRFf/nVPwFgh2uFiP5wz+FWDdqi08JTjPMyE8CLmHW1IPAphpDv+lWogdnc6jIbcwovcM9L
 s8Yfmxz3PfemI1gPg4RymoJTrqh3aUcqp3ATme1g9+f0980DHI2nrKiaqkmR6sBEdOpiI72yEMa
 V8gu2em7tBHhguA61lw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfX4MdrioiDMg3z
 CpDRrtPse4PLRNfVLsmhpENlfKt4klzNFqCkfgHqtYeghkcjheSF4pnn77F3jXncRMVs4SiwtXs
 J6kjiU9qZ3+5c3tQeyE6IgdJh+YiTA8=
X-Authority-Analysis: v=2.4 cv=NvhE4MdJ c=1 sm=1 tr=0 ts=6ad21c79 cx=c_pps
 a=zWRuVz0++A3eh/KBGeICZg==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8
 a=sozttTNsAAAA:8 a=HYHyqeARaHjSmq2Pe6sA:9
X-Proofpoint-GUID: wGtZ8US8-N88LXgJbJYmAgf_rY7jrqPv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 spamscore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 phishscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610160050

From: Mert Seftali <mertsftl@gmail.com>

dthe_get_dev() fetches a device from the global device list with
list_first_entry() and then checks the result for NULL. However,
list_first_entry() never returns NULL: on an empty list it returns a
bogus pointer computed from the list head. The NULL check is therefore
dead code, and an empty list would be treated as a valid entry and
moved around as if it were a real device.

Use list_first_entry_or_null() so the existing NULL check works as
intended and an empty list is handled gracefully.

[pratham:]
Add null checks on dev_data in callers of dthe_get_dev().

Fixes: 52f641bc63a4 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202606111933.69GGTKxr-lkp@intel.com/
Signed-off-by: Mert Seftali <mertsftl@gmail.com>
Co-developed-by: T Pratham <t-pratham@ti.com>
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 12 ++++++++++--
 drivers/crypto/ti/dthev2-common.c |  2 +-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index eb5cd902dfb59..4fdd24ee91637 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -112,6 +112,9 @@ static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
 
+	if (!dev_data)
+		return -ENODEV;
+
 	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
 
@@ -124,6 +127,9 @@ static int dthe_cipher_init_tfm_fallback(struct crypto_skcipher *tfm)
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
 
+	if (!dev_data)
+		return -ENODEV;
+
 	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
 
@@ -571,10 +577,12 @@ static int dthe_aead_init_tfm(struct crypto_aead *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
 
-	ctx->dev_data = dev_data;
+	if (!dev_data)
+		return -ENODEV;
 
-	const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
+	ctx->dev_data = dev_data;
 
 	ctx->aead_fb = crypto_alloc_sync_aead(alg_name, 0,
 					      CRYPTO_ALG_NEED_FALLBACK);
diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index ba6cde75d3611..cb4b8b38a5ec8 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -39,7 +39,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 		return ctx->dev_data;
 
 	spin_lock_bh(&dthe_dev_list.lock);
-	dev_data = list_first_entry(&dthe_dev_list.dev_list, struct dthe_data, list);
+	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list, struct dthe_data, list);
 	if (dev_data)
 		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
 	spin_unlock_bh(&dthe_dev_list.lock);
-- 
2.34.1

