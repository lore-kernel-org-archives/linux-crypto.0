Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0276415F1F;
	Thu, 27 Aug 2026 10:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787828324; cv=fail; b=GUxQeea1dwL5WCXs1ov2eAcq/x6I31dFl48az2P9tAyFqtj0hD2s0KuYBZdWuEg2K4svegDv2pQHU1+X5ZURdR8nIwkpIdox3ToVATcYtC+ykJ1DWxxHFKjCBWdQdyHkWQGmywMw5WlpVro8Ccju4Dw4v0oYPN6rg4Q6pSUepYk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787828324; c=relaxed/simple;
	bh=PMyStMVx8VZOMUxje7sBUqEiKAC8/hlVYaNmCFDJCLk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=g3Y69Npsyrmuhurlvkj/fSApSU0fabU/My1uBSoLH7SmVwAjMANFfmwqihP9X6FpmRtepdVlEt1GnK2/mugpbjjS6m3HGSj6LcJVnQWzIAlOiWQ0q7BXVxtLiQvMCIKXE1a4637FBjvGxG8cj9S5HSgewIzJiIGapmDLlnmkntk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=TIs53Sv4; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Ns2LYD91; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="TIs53Sv4";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Ns2LYD91"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67RAEe222504273;
	Thu, 27 Aug 2026 05:58:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint-05-2026; bh=FNgdYOmk7RVAM
	gz+JVjwGan0oQStINnyjarvOApt+Uc=; b=TIs53Sv4a4uVoiLPeqUz/xS8E6rCH
	B89g/nZdPBigTh6TY77mkbZjWhcrrdhQ/hVIm1JTou58aL8L6ueOP4BJt+ggRLgF
	d7UV2ydOowLkqL1cNQARrZwc8HaVYbZ2XsRpNzmD/KgzZTmvaagwHP8wwbBBeOzf
	qXnk7rsFWyUCXU7cZwLjNUbXxDmEy1y/790L21bHLlAzjQ1YYyDqTOGP7jBOHfS0
	UrFQO7IDDivNSxZhv3nUOeqlW31AWzPtbUZ6PeZF4KGaNnuefF5Inxd9i6hYBF2e
	yDYIw3HAsFSOjjA5OkT2uR2TMym7k+/CDH8EuyxlWd0skCJZ8/MpztbKQ==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010060.outbound.protection.outlook.com [52.101.85.60])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gakag04sb-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 05:58:29 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QJvg1pUbl907Vxi98KRd9OUYJ1SU2ebNck8yd13Rv2Sm5DEEhdWG9YuM6SvLn1fn79ciugSK4w5Nkfhs0RYOIMH8xiaw+puDCrDR6SfFhAAtwBvWhQ45YDMyPWbIimXJKr1N62OS+3/KFGRGPVP2sJqeNfj0xcuRQTViwb19V2UoJRuD3DxW+u0IMtLyV7trl+bAWsFFMAYHYzE96OVlsQAqJmoJWeFsBYVc2ZrZAs9v9WH/vIYH5TFvLZ8aJFm7aHTZSK94u3HxS4M3PGtm41DZi/GVL7/Knvor1YxGRuG6xCX17hLgsozrT4PnRyjXAY1trYKprV4cND9jvPEWcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FNgdYOmk7RVAMgz+JVjwGan0oQStINnyjarvOApt+Uc=;
 b=K35LY8HZpKIvRWKAqWyTjK01ZRzKIUkuLMdLRVFsK6Jw3buduPIH4N8K525nbexeaV2wE2XYugVmanQyGz/4S3UifQYMf+bQaco1XU/Q0g3D/+hhAEOwVntGKqWpDzIgB6ZpJl5pkXAW+UovSX0xkFtYslqYv539e3nLdNJYa/m/kTdKweM2/nVOCDz79uE3brcAcNAuY6FTE11Ux6lJe4r8MleM3IptPJKPeK1d0TkBPjaNWpQbEHnu/p26IokQHYztqFrzAp0qsUjMd3u9QsvfpBu+fbS3/yJL0P9wLyV43Vswr3DWnM07KA/u8eDlyUcBYhQ0oE7MtOZSyRPkyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FNgdYOmk7RVAMgz+JVjwGan0oQStINnyjarvOApt+Uc=;
 b=Ns2LYD91E6tMt/4iFxa4C1aYkz5YcafcJDNb8YXRz7hB1p54PmZXPgIJjwQqwypmGgTA8xa9f2vqbCbUVUqo42CVfoHmllldwAOAfta3aRkToYiLMuNSvjVKuGs2v68OQJq8IhdPpnwyBwEuHY8vjpJPrhVBZOPMYuBWPnI5dj8=
Received: from BN9P221CA0003.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::25)
 by SN7PR10MB6665.namprd10.prod.outlook.com (2603:10b6:806:2af::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.7; Thu, 27 Aug
 2026 10:58:26 +0000
Received: from BL02EPF0001A0FD.namprd03.prod.outlook.com
 (2603:10b6:408:10a:cafe::4) by BN9P221CA0003.outlook.office365.com
 (2603:10b6:408:10a::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.12 via Frontend Transport; Thu,
 27 Aug 2026 10:58:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BL02EPF0001A0FD.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.3 via Frontend Transport; Thu, 27 Aug 2026 10:58:25 +0000
Received: from DLEE209.ent.ti.com (157.170.170.98) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 05:58:10 -0500
Received: from DLEE207.ent.ti.com (157.170.170.95) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 05:58:09 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE207.ent.ti.com
 (157.170.170.95) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 27 Aug 2026 05:58:09 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 67RAw8Ta1730777;
	Thu, 27 Aug 2026 05:58:09 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sebin Francis <sebin.francis@ti.com>,
        "Manorit Chawdhry" <m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, "Praneeth Bajjuri" <praneeth@ti.com>
Subject: [PATCH 0/5] Fix several issues in DTHEv2 driver
Date: Thu, 27 Aug 2026 16:27:06 +0530
Message-ID: <20260827105711.527182-1-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FD:EE_|SN7PR10MB6665:EE_
X-MS-Office365-Filtering-Correlation-Id: c050052c-f68b-464e-f42a-08df042a1e3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|82310400026|1800799024|23010399003|10067099003|56012099006|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	S3bDiLbHZaQ+dWX5PHdOffX6WKIdFBroz06d3Ae51xUwCvH3lViUrvOCQDHk3jei5+yv3adTf17689DcIRYZHnd3J7FCq8EQ7/utyf/MluPnXNheCKoszsZ3Px9fTuXHhi7gJ7nY8Z4WJT4PyQR5MNza4xA8bWGC1MmGJ0g5ua1CYbNXswUiYJydRA5v6ZDovwg/FSGiG6ypntLbJeDqi42FbhWOyZMaNZRc/4cOw7J7366GeyO1ipCY4SAcxhvK+Z/17SDk6RoJkmo6Q0mbKoC1mYgB8OBer+rwlvegwoh2RQkUX5ZZZBARpitaNdzdlCr/HhzaT82Y6S/ikrYhpqkg3ldXuTvNB72IGhWwcB/LSN+Y1c6U73p8otsMdK7pXkHCdk8Gd/rjZnNOQZlA5GMsKkqK1Qsz78UxEpEfso+gJdrbv8mspujDXiUhk4/SpeSVrCrtbFyGOCiUQR1+bRrN2vkXUXARshd1UfsHpXpxmkZFNAud1y22O48mcxlTgSaWHTOThkyaurkDOIKVObWRSZIYDO4j16vQqwxBRWleISbJmnLKMmioPx2mprtG5yrhNWiSQKsmwEZZQO9eBDWl24SA056lQufPlrTH7g9wKPkRmdnnqQZK94IN6zRc6wQ1NXtylzGMNAKwCY91Og==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(82310400026)(1800799024)(23010399003)(10067099003)(56012099006)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nkZssMMQ60lkAQRS27UR4WsoaIcS0womr5k8LQnIJk50GX5S9ZusfOEPCR/2hzqvJY3PSG6TZFiGFJ/8JcQZqmuqSP2OeHOzjj0+9OcYCEp8cNLQmLaTtDz1EQUT3O7kKa/DK8RxzdKR4eqw1zEveiJ9Siq2CcBgh6i9N7X0KLxiVfUYz4O/QgD/TGqx9U6/z/ZO7fFAEAL1JZTMPojeKZIaKqHXq+pMfKJ5olkXDk1FGmxn7GTMfzG0gE1Lu+An9H9GblDbhCd1hEKNTR5OJjkHf1YSVBrDpbSJ4ekX8dVsbhPkaazYmdhQGdB7k86Dc3jX2JnaB0gzaaVkHhQG1Dtlteb/vhFT8p741UWiqd6opF37BFEzM0HoQ9EYf110XUzFp1ImXZ0d6RKuoTif7kZEmjwnSzI/7WSfX/9RN/N1z407+mnmYaBItEIwp1+m
X-Exchange-RoutingPolicyChecked:
	1WMaj6xj9YJueYi69OnMZXMPLZAuIPQN1lWsJXCqsqOh+lnkjbTWay5R98txw3qqrramWyYL2sDyu5+mYVlKXmlHj0H+zo06k3usEzQzkmIlOJw8ih8qwIXu3YZ5Tkf+lh/Q+npkU/bZ23uum/sks7WNISvJ0lFlj0eIi09LLpbxbJh5gTnAKBM/oxNxLslKPBORckQA+np1+XyLFuBZELUGYZWGJ/2x2N2aoTtkkPIFOCkHJshy9VIOvSn5u3JXNo+NdBkvkqe2t3LpdoIaAqu7or9Zlh6Jy/11h3P76B53HupDe7nThMHInHE6aut9kP9XOvfu+Uo9m2mUuXqeqg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 10:58:25.1163
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c050052c-f68b-464e-f42a-08df042a1e3d
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6665
X-Proofpoint-ORIG-GUID: yF0BUROMXmKaR1QY1PFC8NDmWtQyk9QE
X-Proofpoint-GUID: yF0BUROMXmKaR1QY1PFC8NDmWtQyk9QE
X-Authority-Analysis: v=2.4 cv=VrMTxe2n c=1 sm=1 tr=0 ts=6a901855 cx=c_pps
 a=tP1g6Cq6k527JP85+VkTLg==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=Sv0fKeRqtYgA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=c92rfblmAAAA:8 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=8F2zfpSVp_VeWh-fdiAA:9 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDA5MCBTYWx0ZWRfX8fX6CHOVH1P0
 F/yPhPTHtX1LCSGZxh53EoZgpyQ0Ol7Kz7sDH1Zyv4vfRjf2SrXOdUULH1RBVzeiWFMN0v1PPrq
 NN7s4J16HozU1ajwI5kInv571b0hhkpv6AMRkwrH3GjkJmAZ9cqzzVyXuWUAuXov8iHNwMhNzeL
 YgPhM5NuqYceAvBooqIjg3AnCXruFzaHlR0F/Lkd075Pxc6vN7+xZT0X2Np4p/q5lLKqzYnwRTI
 ZplamJUbsUUbPnyjy6cF3krIFOY7J7bJrmbvMvagiCszwW6ZLM2/NpG65pH805NCG7ACRT7HSZ0
 BfhUm5xzsIXeLAfEgAPGlYG4fnsr3SWW2UT/vL19GFkzvtWiCwL7QRpDWIZCFEw9SfscopkMN39
 VrQfbfoOhq8cu3Oj60DIvKkl4JWqh5iKZRCAHoFog+CffneB/Y6Yong5iVlqF/pTPq1HTWmehfP
 Cwfnytykodx8kjhxTAg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDA5MCBTYWx0ZWRfX4lGtS1ZAqg8V
 QIQMDjYCyyb4as9f3lTBP3GV4a3z9rpK3iIuSoI9hY5+Q4pfvIOTKjcTeicNSMfdMPthq+AnCg+
 hLp4FqVYnSmAPDYDG76+zdPqXw0mna4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_04,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608270090

This series fixes a handful of independent and mostly benign till now
issues in the DTHEv2 driver which were flagged by bots and AI agents.
Except for the fourth patch in this series which was found in an
internal testing.

The Sashiko review on DTHEv2 hashing driver patch series v5 pointed out
some pre-existing issues which needed to be fixed.
https://sashiko.dev/#/patchset/20260807110501.975130-1-t-pratham%40ti.com

One of the issues had already been flagged by kernel test bot and a fix
sent on the list by Mert:
https://lore.kernel.org/all/20260613085858.32580-1-mertsftl@gmail.com/
I included this patch in this series with minor edits. Then the Sashiko
review page for this had more comments:
https://sashiko.dev/#/patchset/20260613085858.32580-1-mertsftl%40gmail.com
Overall this resulted in a bunch of fixes patches which would have
deviated the DTHEv2 hashing driver series had they been included with
it. So I clubbed them together in a new patch series which is this.

Signed-off-by: T Pratham <t-pratham@ti.com>
---

Mert Seftali (1):
  crypto: ti - Use list_first_entry_or_null() in dthe_get_dev()

T Pratham (4):
  crypto: ti - Fix potential deadlock and allocation bugs in DTHEv2
  crypto: ti - Fix potential memory corruption on highmem pages
  crypto: ti - Trim scatterlists to correct length in AES
  crypto: ti - Fix use-after-free of dev_data on DTHEv2 driver removal

 drivers/crypto/ti/dthev2-aes.c    | 153 +++++++++++++++---------------
 drivers/crypto/ti/dthev2-common.c |  34 +++++--
 drivers/crypto/ti/dthev2-common.h |   5 +
 3 files changed, 111 insertions(+), 81 deletions(-)

-- 
2.34.1

