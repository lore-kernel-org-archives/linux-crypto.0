Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F8642FCD9;
	Fri,  7 Aug 2026 11:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786100763; cv=fail; b=Z2VYYHr+V34hYONHandrvxvGdfZhqEVr7BARRk9WXIKXo7E7xy4IhNlfB809l1EoLkEhtOMowQKkeXVgZDRT3PXUjn5HUf6ssVQroFDT13zgIWmUyi5vO9qeAEZ2Ic6/czoMQY+LmWhoWEZa8gx+fLcEzaeLQLFEo5QGd4o7CyY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786100763; c=relaxed/simple;
	bh=ZS4IqbkAc2J4tI7If/CLd7dyUzcuFNF2BsP0DhpiGhA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Y49AkZsZtd6v/7y5MBJcJFgGaFIDNV4fwYVPGpJxRmcANwxF6WOcl2TW2IUC/0WEfNEzxN5u7w9ucyIv2WlTtfLu9UkdS9RR9Yo6ou6US1gG6uepWHK4Vc3mS7/bqMo3Me3mfVksYMG9xB9vxcwpLtWCVnogNVolHUHZvXtP8qs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=CxxheJ6g; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=EJQkHUBZ; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="CxxheJ6g";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="EJQkHUBZ"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6777j7qM2584467;
	Fri, 7 Aug 2026 06:05:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint-05-2026; bh=vJ5+o2U+SWq4F
	Rnh4RGZGrsiA3pg6f1HzxW+cmXUenI=; b=CxxheJ6gZSGV1Fyfiv2Zo8Me6liOf
	fvlJpZaYhwGqY+jnht5ueIm9N1qCDUzgIRikhJvbkGlOKgEF9QWaP4g4BnFjG5Rg
	fzrgh+fWlOH5NL2P0CXBKhL1wZoN7/9c8NrRmKa1b4HbzX2Ham9fSIaL2LXyRbHy
	2UmhgCVhNqaeEHvip4ON9sTI6KyXjrQE6DSIQVQQk9RlrAHUJBz3X200mC3rrGzd
	b+CxPqbophSgSCsSFHnQSI4uJu7+ENB7DE00fo6jG0+UbpaZAsUwFS3edEjBxlce
	5uk4R+nJ3ca4PeGRs+bHOQQqya2sQB6hg8yj/JbNIJcqvrM5xfaejv1qQ==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010019.outbound.protection.outlook.com [52.101.85.19])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4fwb8dgwkp-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2026 06:05:48 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oYCQKMwdePnUu484dYnK8rQ98rVSfPwCSib3M32vF2hfjDjrQeSAz6ZIwLB99zi6JFKVbSsq4KCyQKYvGoqq6OUM8kJchb7UnlNUQS/WMOBi1ec9VcpSJdT40T1xRFplWSXPHILtJsSNJwHazFeJ2aVgGNtJz2yZoYRXcL62rz+ggyvKwt0suSaao/VWHLw9t4xiaWI7eF20G58DWl7oybMm+FYbY8LRvRHioK4nuz/XYN7bd3CtR3LXuhtftoMg9S+qUefxP8ryiEJGV4Nv6FFEI4HeTqnGl100K+SjoDRqWRX1lztMHNIK3SarEY8vRNh24mjuOFe5x137m9y1jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJ5+o2U+SWq4FRnh4RGZGrsiA3pg6f1HzxW+cmXUenI=;
 b=mF+EHLnK8VtpzCnDGJzWGEx7sUaZU2fZGIURohouv8YdrQZiDenzOLJATZBcjys7SWw+JkmbtFOAJi8gP5Cvrq5XUXGX40Lu6orBLOGW+PvlZkvJ5meTKzdP3VmVVfz/REmJRDW13X7mTrk3mwwwRwpXNu1DkDj3AVcQ9eA67ilENo1DGzieedsr+H9USs72E7+hnbstEorYdxACRPNoc22Ffig2PGIM4mQF7RsSTSTs4VT4z+C/TAWI6YuOlQzN6Tm9I4WCnc1drnUqgFI/Dc07zir3z+0qKkY5H1whjO8fOk78MlqjQTcTVfW6FPMWweNOof3extA61Aq16dXZ8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJ5+o2U+SWq4FRnh4RGZGrsiA3pg6f1HzxW+cmXUenI=;
 b=EJQkHUBZ1KiEe5Vxmxji/yASJQKat0SWZ7nRkxTo1YOUInnia1Yb0I3+LUdapPOjPH7ipz0puhgqBoT4SXNPQx3vSWd8JSwZOMH6dfWIj15craA2umT8kQXl2qqihWp/tSVG7mfUgGJeIxYKhfegMAWHKcD2Dy3hn2OcF6Nfv6w=
Received: from MW4PR04CA0268.namprd04.prod.outlook.com (2603:10b6:303:88::33)
 by DS0PR10MB7429.namprd10.prod.outlook.com (2603:10b6:8:15d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Fri, 7 Aug
 2026 11:05:45 +0000
Received: from CO1PEPF00012E66.namprd05.prod.outlook.com
 (2603:10b6:303:88:cafe::7) by MW4PR04CA0268.outlook.office365.com
 (2603:10b6:303:88::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.24 via Frontend Transport; Fri, 7
 Aug 2026 11:05:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 CO1PEPF00012E66.mail.protection.outlook.com (10.167.249.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Fri, 7 Aug 2026 11:05:44 +0000
Received: from DLEE210.ent.ti.com (157.170.170.112) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Fri, 7 Aug
 2026 06:05:29 -0500
Received: from DLEE209.ent.ti.com (157.170.170.98) by DLEE210.ent.ti.com
 (157.170.170.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Fri, 7 Aug
 2026 06:05:29 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37 via Frontend
 Transport; Fri, 7 Aug 2026 06:05:29 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 677B5SEI1704592;
	Fri, 7 Aug 2026 06:05:28 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Manorit Chawdhry <m-chawdhry@ti.com>,
        "Shiva
 Tripathi" <s-tripathi1@ti.com>,
        Sebin Francis <sebin.francis@ti.com>,
        "Vishal
 Mahaveer" <vishalm@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>
Subject: [PATCH v5 0/3] Add support for hashing algorithms in TI DTHE V2
Date: Fri, 7 Aug 2026 16:34:56 +0530
Message-ID: <20260807110501.975130-1-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E66:EE_|DS0PR10MB7429:EE_
X-MS-Office365-Filtering-Correlation-Id: 089fffd5-f225-4b33-679a-08def473d3ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|82310400026|1800799024|13003099007|10067099003|56012099006|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	F1yEG8+Mf8Ka/KFAsP7drb7aEPwcdJdbXhZ4lwlat4+V/8OOGMVrRC/hvOXAF08TgOsZVuyzfHqkyzKymNqXhaR0/pRKhxUlaGm7E+26qqG+ErsYippmVPnhT7MTDQsuEyqsHmkjEYj+gN0RPw2qozA011dbwT56S5IFYJ67kvKNyZD7y2F8NsvqE8/b7F5DKvswBnjVGKmpUi5Brt1BSGUuvGyYgnikHoQq7sg22fZj6F11WBMA+qc6Au9Q/oZNWUrY83jqUdqQhTzz5BxUbx7xJyWdzzhy7SSlWvYQwPK1nSgEka/YPHDDZ21DAX1n/GK3NIWSwfH1AJmHylYZcSF3tt3gLy/FneNRGzSGhB4thHkdopJOIv1Zug2P0lWrk4TtJB6sjjNGfKFlMZP3E2wYNXnz7BElx52OJCna5MPtq8Bgv17XAVnoeyJ280U+3N2RbN0sYGw/Mv85dTcvqqEqpjy4YTdnD6IMCAc2Sic7fR72N2yGL9bsPrym/M49JrnBu3tJGCO9f1XFJMl+YQlkSTp9mGFlOOg/CJaUEI/BwHcJnl95T1tep7JPFzP0E/pDmho9C9aveOwUFI9LEjUn5oeCPWuu2XYC3kdg4Q/shcUf0oJx7fQsp2kg4yJc5XE/gzbrkBMBt0xv5t0A5q6/zXK9W+wt+qKyU67IUdySmuvft2VAZ7e6xAUf+/TJGBDY0WXoPHGO+YB/aHIMIQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(82310400026)(1800799024)(13003099007)(10067099003)(56012099006)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8aWapXq68Fk96KNW4b5d4yi9zX+azjwitgQ0bbrZajkSe2SENMUk2k8wkuuWobq/Nv3rdnNhY44fgC4XPNUs9Ui2aac41JHnPA++mxIj1smdAooLAvu/MDFx9ZSATy9bxrb/NRjYYu8d76Garhllr8SJQBLOm/xz6OUjaEZg/RJ2hFOBUqkDU+jXteWzyzEF6dbSYzHbJI/kE3jlHMxamnItvpSoqYAIRxp8C1Tr3inDJ57pSyVGb1RDdmpRLT/MHTCiFIpm3061bS/siV7OuC4EfzaEYKmSrP0YOPmf+ODeftRNzqA+aARlKxDDQ7nZ2YEjqSibY4VFpERGhC1xtiS9qLytiJfPBjL5tTcX4eXI6y2PsTl/3qhF/O7kvU6mp5AlBNYrv1ce48WTnv6yNe/oCeGmkbajqr4vYKiEJTyai4C8KPtbFnBFINFMk51x
X-Exchange-RoutingPolicyChecked:
	pzuxGl3l+/B0LLSsDDAV2FWebfZ0wrZBxp8PNersrrDoz67Ub3QhKm9RxSNHHokRBV5LRw5qYwZoQEdV97rj0vBt5058edvIhjDyjFK1iY2iRq4s0lKJ9JORSFTqw7V2eYMIPWnqLtu8isAwKPQI3C9WZvM3ZFeTIJxxxzWdcuMUhP7qJNK9uCoWU/gjybVybjaiU/1B38CIhF8oDPHZBRuBIxKyX3ed0V+8uRIlN9f337ukvJpFEqqb/gw3nOIVnp1xnQG/VfvzefObsIoya9RE3yPBTAfzW02GT1b3sd0LHD2Jn/IbIcF5v9C9B/nXGdAfcBjlUETGNGei1741OA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:05:44.3736
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 089fffd5-f225-4b33-679a-08def473d3ce
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E66.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7429
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDA4NCBTYWx0ZWRfX4WLR+2NYB/Xs
 TgECav5pGaeNRRP01QEEujz4CbOupF+a0NWWAsrFLULXIHGmv32mtteredrHKnKq2aR7PlZf8Gr
 c4rlTFi3LljhsHcnP50x9Bz1dnKk202MvivMBnR/8DTe39WRCQUyR68z3MnwAmk07RNsYopPMms
 4mNkEPh/XK4rBh86STrgb5SkE7up0bLC0ItSJDA1sC9eH+r8H80eF7fQU0QjChbGIW9Z4aPz6Sz
 caDvCy5N5Wy1pq6PUrq9EExpoP5KGuxvceVM20SCvtk5f/7oJAglBe+k0BMeXFmR4/C8nK1mPSx
 RlDO8gkNValzx3L9StN2Lr0zeCl9VQtmI+nny32m3qj7QuqnYxnPh6koWL2V5kZJZ2lW0G+C3vk
 iC6UJTLLYHN+EeLtzKNAge0iycH4lCpqUzcPVaAsULB8veH7rxJaQm/LLe0Aw+N5FQAhc9gGddo
 q0Rxeh8vH1JPTO6gQ8g==
X-Proofpoint-ORIG-GUID: rGCSMPwBYURTazwbqubzwgs9BVNJNB4j
X-Proofpoint-GUID: rGCSMPwBYURTazwbqubzwgs9BVNJNB4j
X-Authority-Analysis: v=2.4 cv=Ouh/DS/t c=1 sm=1 tr=0 ts=6a75bc0c cx=c_pps
 a=fdYRkKHAJehZsuGPaltaPA==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=Sv0fKeRqtYgA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=VwQbUJbxAAAA:8 a=sozttTNsAAAA:8 a=NEAV23lmAAAA:8
 a=bPMwzqFypLsuyV-WarQA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDA4NCBTYWx0ZWRfX3esajaLpEr3F
 dkgAo8zRsfCMY+2uSewshKWtTrfPej0/YqRaGIuoM0eUceN2Kz7rKBZGblpXjZIDs00pM/sfap0
 pG8eAlNwLcZf79X0/LtszeP8NufJD+8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_01,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 adultscore=0 phishscore=0 priorityscore=1501
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608070084

DTHEv2 is a new cryptography engine introduced in TI AM62L SoC. The
features of DTHEv2 were detailed in [1]. Additional hardware details
available in SoC TRM [2]. DTHEv2 includes, among its various
sub-components, a hashing engine which is compliant with various IETF
and NIST standards, including FIPS 180-3 and FIPS PUB 198.

This patch series adds support for the hashing algorithms
SHA224/256/384/512 and MD5 as well as their HMAC counnterparts for the
hashing engine of Texas Instruments DTHE V2 crypto driver.

The driver is tested using full kernel crypto selftests
(CRYPTO_SELFTESTS_FULL) which all pass successfully [3].

Signed-off-by: T Pratham <t-pratham@ti.com>
---
[1]: [PATCH v7 0/2] Add support for Texas Instruments DTHEv2 Crypto Engine
Link: https://lore.kernel.org/all/20250820092710.3510788-1-t-pratham@ti.com/

[2]: Section 14.6.3 (DMA Control Registers -> DMASS_DTHE)
Link: https://www.ti.com/lit/ug/sprujb4/sprujb4.pdf

[3]: DTHEv2 kernel self-tests logs
Link: https://gist.github.com/Pratham-T/fd15b8e0ee815bcb420a60d451a0cf18

Changelog:
v5:
 - Removed CRYPTO_AHASH_ALG_FINAL_NON_ZERO and FINUP_MAX. Implemented
   the same mechanism in the driver itself by witholding one block in
   the req ctx. 
v4:
 - Export initial state when phash_available = 0
v3:
 - Check for error in registration individualy for hash and aes driver
   algos.
 - Fixed comment style in dthev2-common.c
v2:
 - Completely revamped the driver to use the new CRYPTO_AHASH_BLOCK_ONLY
   framework for handling partial blocks and crypto_engine for queueing.
 - Added HMAC as well.

Link to previous versions:
v3: https://lore.kernel.org/all/20260226131103.3560884-1-t-pratham@ti.com/
v2: https://lore.kernel.org/all/20260121132408.743777-1-t-pratham@ti.com/
v1: https://lore.kernel.org/all/20250218104943.2304730-1-t-pratham@ti.com/
---

T Pratham (3):
  crypto: ti - Add support for SHA224/256/384/512 in DTHEv2 driver
  crypto: ti - Add support for MD5 in DTHEv2 Hashing Engine driver
  crypto: ti - Add support for HMAC in DTHEv2 Hashing Engine driver

 drivers/crypto/ti/Kconfig         |    4 +
 drivers/crypto/ti/Makefile        |    2 +-
 drivers/crypto/ti/dthev2-aes.c    |    6 +-
 drivers/crypto/ti/dthev2-common.c |   43 +-
 drivers/crypto/ti/dthev2-common.h |   61 +-
 drivers/crypto/ti/dthev2-hash.c   | 1074 +++++++++++++++++++++++++++++
 6 files changed, 1172 insertions(+), 18 deletions(-)
 create mode 100644 drivers/crypto/ti/dthev2-hash.c

-- 
2.34.1

