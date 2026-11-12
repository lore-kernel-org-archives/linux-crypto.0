Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794471193;
	b=aBqrZGzfKDSmwYmtQKwSKxEuSHfG846FA7Te+ApXHQmSSqvVHWXWH21LsNj048BPUQHt
	 laMMZAqWl+Odc52c/mmueiWBNZlOLj3AoxhjwNBo2A0sPkBATSriee2ZbD1XI3UUN2asg
	 LumWJn/jtAsyiCDnTPC2ngesGlCvPlE03zFUbe7WDtLUFnrcKOW8z0VPFCdOSMuUtWfWn
	 fB0l36dMH9ggDSlqEo2vCPN7Fkm+B8AiW45EXQcXBn2vvPVaUtmiMDsHrAKGnsLTfPkQI
	 AtWBVaRRTyO8iGuy0/HH0Guq5dO/3K4XTQ92e6umyy/KORWbucHHHrMGILqaRhykrRg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794471193;
	h=DMARC-Filter:Received:DKIM-Signature:Received:DKIM-Signature:
	 Received:Received:X-MS-Exchange-Authentication-Results:Received-SPF:
	 Received:Received:Received:Received:Received:From:To:CC:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-OriginatorOrg:X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=G7ilXA3R8kq242rCty31KatfsMVRUuvZ02TJ3o5Equ4=;
	b=ljFfAbjyyVSr4y43vbMA9U2UuCiz78kHgm8o00/sP5Nn2O18qDf13ooFZT/hz+PDQl7B
	 E3Z+aZPcoixlHM5JPID5jBnFRmFyXcthc57e7Bc9CaOoHaVg2+nCzXc72IrajppzXbrZt
	 nlL7VmJFXtcfckNMMxrjjIIU6wZJhbhtuIryxdszYrUPr4uNiNVkzQG9yorRqr2mJJAnc
	 E0RNKcLqYOvgHdyWY5rMSRuY6BbRwQkM1dXYIAZofHqWCjfwxZYS/zT6n75gjdYFinwi9
	 xyZMsI9pkLxUd6yVZLWrX2MbjA4RDGrxk0zEGSRt8zRXJkxIU9TKkf8RrRLPhhKnxiA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=UD2ZnEMW;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=Fu+kBNuQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFF160A3834;
	Thu, 12 Nov 2026 08:13:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDFF160A3834
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=UD2ZnEMW;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=Fu+kBNuQ
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC7N4dG2098016;
	Thu, 12 Nov 2026 02:13:09 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=G7ilXA3R8kq242rCty31KatfsMVRUuvZ02TJ3o5Eq
	u4=; b=UD2ZnEMW3HGnet0AY+CCEAUJ/nKFR3sobKnXOAMaf1r6nnGw5DiHFTBom
	WmIvNzA/uSiGY3Y7jf44CnmxUsdXEtxZ0C9HcE2hZw22wnnExtsrL8jJ1ajCqotv
	07HLw/lkg4O2InS0PRw/KE4SxXe5CCLJgggAdhIsIJVQfpYxnxGTNoCYbycrVnQG
	+Jbe/sHHStY+QSgigOCwWaFZJX0n6anBkX6SDSMiKNPapwrGvD/8VoyafiFk0pik
	6Lxp6D7Y0gdVPdiGWSvdM48T8CvK01Ak68753DRbfHyau5GAXkPXvm9I+FONFHfs
	iUMXNKv0bGkhOK9rLVH7d4A5Jfb7A==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010068.outbound.protection.outlook.com [40.93.198.68])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hw915g8pr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 02:13:09 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b+uP4/csf/2d9dhC/udv3nKEQXA7VfEAPcxaRohd+429leumMxnV4Xp77uIvrY5B9pMjAN2e8axIyrJl9Aa+DQEVxV+776H2APKgae50xsndWOZjazG5lxG233oNPV5rlmTZUG1P+tXEWifzfIrXZJuautNoWmvOrUUpzHKcPsDl8hABtXZX6UkFpp1D3e61RZNfhzPSwtq7I1SO4iHUfXmR3FbJLT7NOoal3fqciRddrnzQJaPWNmalo/TMCw8oRk47D6pj8opyU486uUFS54kyOOFv+hIEeOYlU4LDZBYp+7xzMt/3wJA9fpwkDEYb3pyS/A3/YBRfRuH+xjRI4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G7ilXA3R8kq242rCty31KatfsMVRUuvZ02TJ3o5Equ4=;
 b=l+rcLQjPe1FdQMloC0Q+NuPEInUXEvm3tUeVsctHqcbXR74dJw/PpDw4qxxW8XY1ROFS/os3sJe/VHFhUz7P78Kuu/EH3+K/xGAPxtsglFJwTYqAcJIsBozyJwolMkz7NJfRsYY3bZiby/f8mriOJ8xpKeM3wfE5UZDbg/GPj01VVPtPeQR0SGHUMJF0yOZB6rSx9GG/D/G3k6zSVXhfKrY8PrZqCibzwGGsYzclVnMZS+SZIUsE8fs44ztRiuQOC1XOMBJICVlf0GHwOF5Aup3+lQSk8gMN7Ws/btgbdNsuiN10dk2OZPrxBCR+BIyAJeSnTY8FK4aH8lvYEBqtWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G7ilXA3R8kq242rCty31KatfsMVRUuvZ02TJ3o5Equ4=;
 b=Fu+kBNuQ5younWDQN+NlnX1mpTP61M8RdmNCeHCdNVoIlBnDlIACvOoy/mcHRc9UX+plubtVZAkvFee0xGL6h4FHwu4kA+RuugZiiA15sRydf7sJ5Cb+ehN/SC0YSNOuQxgZtDb3zl0/Mr4n5cC2xyrQcq0n1/+3N9QlYZpxRF0=
Received: from BN9PR03CA0062.namprd03.prod.outlook.com (2603:10b6:408:fc::7)
 by IA4PR10MB8520.namprd10.prod.outlook.com (2603:10b6:208:55d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Thu, 12 Nov
 2026 08:13:06 +0000
Received: from LV8PEPF00000060.namprd02.prod.outlook.com
 (2603:10b6:408:fc:cafe::88) by BN9PR03CA0062.outlook.office365.com
 (2603:10b6:408:fc::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.13 via Frontend Transport; Thu,
 12 Nov 2026 08:13:06 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 LV8PEPF00000060.mail.protection.outlook.com (10.167.245.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 12 Nov 2026 08:13:05 +0000
Received: from DLEE202.ent.ti.com (157.170.170.77) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:55 -0600
Received: from DLEE200.ent.ti.com (157.170.170.75) by DLEE202.ent.ti.com
 (157.170.170.77) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:55 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE200.ent.ti.com
 (157.170.170.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 12 Nov 2026 02:12:55 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6AC8CraI1456224;
	Thu, 12 Nov 2026 02:12:54 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v13 13/15] crypto: ti - Correct AEAD tag operations against dma cache invalidation
Date: Thu, 12 Nov 2026 13:42:01 +0530
Message-ID: <20261112081204.1146395-14-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261112081204.1146395-1-t-pratham@ti.com>
References: <20261112081204.1146395-1-t-pratham@ti.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PEPF00000060:EE_|IA4PR10MB8520:EE_
X-MS-Office365-Filtering-Correlation-Id: bb0dfcea-20d9-47d3-623f-08df4094c759
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700016|23010399003|56012099006|261021135927099003|261021123027099003|10067099003|261026121527099003|261021121427099003|261102123227099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	5nY/yjATE1ko+5iLQi7rZvSMEMttLyQ2AN88maV5DdXoaS7125z7xWf2p7k8lxTFJqnINUe7yn4pYYdgYHNNhCAaF2+WzJ9FTgGoy9Mn9vVxOhGoX/J/CCdUYylraBhonSUSTxnFktnECd/t7pywElzkG4c6GqAGSJVq+6c0I664EnI4fbLBtGDa0KgFpKq0H0LosOrWjF6ALEjGNJVfCI0MytC1gc/JItNv8vlIXo4ElAxg4yfWkrOkcNrl36/TcmEnbD+FUsnqWRl+AweOwwOSvgYV7MIwxFbCuaHlbYSu3UCFAR3dW/vvUmAldDaRmZ2uKuAfvHjDrGmX66XXgD0HsimbY/e7QRqu0V9LhO30HLYR03KDUl59Kav51UAdeSJ2joA6QIFOiJk1LJVgHO6n9g4FCDrr7aNP2JoJYC/TZYJC+phz6RfyWv1qu1nLkt3z0E9pP5gdW9JiB/h6NmV7kjJ0Xn1E7C6Y1HGIwhAR5jlJygBkyP1EDhtuWj0on7q/MJtpZf47hP0ErH5VIappuMlMvB/Rki1CGnZDoS0m7Zjb7vnm6d+1IavHOx1M217Z1FKZ+LrgSjn6EAcjyAF1h3HUGdu6zmurPsBw1zfZ4Pz5TIeyW+vqt0Str5V833/kj6CRu/skv4ElBoyJPIWsEVWgxfpqLyXjhdvPibAdOeZ/PW5WVqf4QxX77aq9cwAo0O5u6wIGFPDafIuoRw==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700016)(23010399003)(56012099006)(261021135927099003)(261021123027099003)(10067099003)(261026121527099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BehSTZiG6MYYk+OkaaQPuhWGGZr1FBv1vlr40g7v4kAoNnthT+VpLzNZXKe5Cb/N3VE9gI6e5klYNKLd/VLmlAsr/nrlfLZRVEj1fImQIR9eCIWgTCxZYIyMbNqV/ReQ6jXiMxnL2JfbNj4B4A3I2RM1T5Atv3S07mx9yykX1jNcU2FsLMIgqIbGroWlZDuc+iRvqSkqpS8oUhQnxpa6x5JHB+0WEfVoGL3WIa4DxJXvl5Wt09NoV94vCJCHiw/EImh1trioCrJ4TsyPX34V1OEuAk9tqEgG1iRk9yfiomvDmtOydRy6sx+iXuuB0oUCQavC3PYD4KDtmjJ1QZTxIMmE/ohMwCi6cYktM5cg2uPpA9uk2GKP9opD4k8eyxMV6Qkd3xrUa/BjKqYMJPFUJrY3nD2cIXoJQbuQzt8F7cgTA9560wBDIrApQ4apqFKZ
X-Exchange-RoutingPolicyChecked:
	t5kfekH7iMST8eRoQ9VzaSU70q0Fa+xdBqpiOF3otobd7srQLwuwfl0JhUQAjh8wdYbMHG2vCFFbNSPAOh7m1CF4zZVOjyYQs82rDTbhOOo1AYfRPNNyQjWWMqUkBgllcllN6Sw/JnKOV9fCUDqvzx8FCWADBcNXU5jzIXG8mbNWT/8ZBEBmJXWOd7LHKHtGfKFRrTvMKtDk0iEKpeg2dZQYvH6n9QDddkipsr0QIUeour9dsf4B6E587zFrmkJ4WaI34c87Xf6ZL4UsIo4e3pdmqK3Jn12YuXfIIGfeDHntnPz5SDAIPB7pVzH4x2ZebvGIL4e4qITDit+WDJRBqw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 08:13:05.2536
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb0dfcea-20d9-47d3-623f-08df4094c759
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000060.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8520
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX6AtbyYk2SYc9
 feoBki2u18HS4GeP3hNOTpPa3LoM7Ul0+h0K6IOoF15rm8W8fWjaNTRucGpvSuLbcOlUeHwvcXn
 pVFZ1oKr7Kyce6NpFMUQEfMtGy2/G8o=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX8u3volfyyuX7
 78IBquX+t1ye5CYBn84v2R3a/jym2HptdbQb42WBhC1VayNvX4HuZUTM7YdrtDKRSGwSSHrlHBx
 o1kCjhOE7pk7+cUWKngZbz/RHk6do21Sx7QUEvxFbz8V+djoXgbFbrW8/O9z+sUFOa3CgbRoTr8
 YzenaS5JDkhEwufOSUKcVvgJoGpmdSTAoRWHBMa1qgv482ZEWZJ19p60EDVBCjtWXq8EOkvcz5u
 7kPKhjkQ/9puKtjHFXuZtxFHmB59OzMh/d9odRxSX6klJqNFh/cqPCwfyLvOP5b8Yij+cfQklsU
 o4z6RuNlQuFGtC0tgPm3wl4EQj2x/oAkKij94MfVVO7JhzHSyojAlR4ByZVbv2DuVCtRr2J9nfN
 Py1l9UX+G5yHcVaD58XmgncpIaqhrHqwVym2pFJU5tkwvh2DNTS2w+GIFn62MTivBzjjIO5LZzj
 WQI8eYzjukD4z3vj3jQ==
X-Authority-Analysis: v=2.4 cv=a8WlZkSF c=1 sm=1 tr=0 ts=6af57515 cx=c_pps
 a=48c6PaPq82/B1OY+thwv9A==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=BSBB0G2mMgAadyb2BJkA:9
X-Proofpoint-GUID: 5mPvoMe1iVbrqYddEViz34E6v3aZsOyZ
X-Proofpoint-ORIG-GUID: 5mPvoMe1iVbrqYddEViz34E6v3aZsOyZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 phishscore=0
 clxscore=1015 adultscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120032

There are two issues wrt tag operations (tag read/write in AEAD
algorithms) pointed out by Sashiko:
1. dma_sync_sg_for_cpu() before tag operations always uses rx_dev. But
   dst is mapped with tx_dev in case of inline operations. This is
   "technically" a no-issue right now as both devices use different
   channels from the same dma device. But it is nice to be correct.
2. dma_unmap_sg() is being called after tag operations. But between
   them, there is no synchronisation step. So tag operations writing TAG
   into the dst scatterlist could in theory be lost in the cache
   invalidation done as part of unmapping scatterlists.

Now, in the current code, we can correct both of these with some
conditional logic and repeating the sync (this time with
sync_for_device). However, it felt more elegant to move the TAG
operations to occur after all the scatterlists are unmapped. This
ensures all buffers are properly synced as well as avoids unnecessary
repeated syncing of caches.

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index e7a7024f19cbd..220f08fd38977 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -915,6 +915,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	struct device *tx_dev, *rx_dev;
 	struct dma_async_tx_descriptor *desc_in, *desc_out, *desc_aad_out;
 	bool cleanup_tx_chan = false;
+	bool do_tag_ops = false;
 
 	int ret;
 	int err;
@@ -1138,15 +1139,11 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		ret = 0;
 	}
 
-	if (cryptlen != 0)
-		dma_sync_sg_for_cpu(rx_dev, dst, dst_nents, dst_dir);
-
-	if (rctx->enc)
-		err = dthe_aead_enc_get_tag(req);
-	else
-		err = dthe_aead_dec_verify_tag(req);
-
-	ret = (ret) ? ret : err;
+	/*
+	 * Need to read TAG registers if data is submitted, even in case
+	 * of DMA timeout, to clear the hardware states
+	 */
+	do_tag_ops = true;
 
 aead_dma_prep_dst_err:
 	if (diff_dst && cryptlen != 0)
@@ -1162,6 +1159,16 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	if (assoclen != 0)
 		dma_unmap_sg(tx_dev, aad_sg, aad_nents, aad_dir);
 
+	/* Do tag ops after scatterlist unmapping syncs caches */
+	if (do_tag_ops) {
+		if (rctx->enc)
+			err = dthe_aead_enc_get_tag(req);
+		else
+			err = dthe_aead_dec_verify_tag(req);
+
+		ret = (ret) ? ret : err;
+	}
+
 aead_dma_map_aad_err:
 	if (diff_dst && cryptlen != 0)
 		kfree(dst);
-- 
2.34.1

