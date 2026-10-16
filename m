Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F91D3EE1EE;
	Fri, 16 Oct 2026 11:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792151321; cv=fail; b=P8N6pVA0wudqgF8yJ/keQxUDZJpR88r4QEy5eY+ekZdVZl/xiW4A/nEK9dJB8eeHiLYPAlmn8CcUrVzbDQy9fEm1PwVaamXiZdK7KZ0ddRxDwSg7splevswXxOhLRvf7Cf+zi1fEb7uFV3ZmVFQ35C8fz4S+VsIrBEH0IfjXUmE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792151321; c=relaxed/simple;
	bh=nYUsW3gR/7I5FBULyFXa84lDGXX94V/Vpt+yy+lUz5g=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Evyk2JdY+jImrRVxb4INIULDbN4wpCcJWwqTSMwCeuk1o9Ns6+M6v80pg5jJNPOG4q4fWQRaJ3qJwcaz+mQv0lnYQFYsDALVHH22nLdvPNCYAlL7YMGtbgMQJfhR5w/6cdT/ETu3Hv5WVYUeZhwjewgecZkqEQFbC4zu2vMvtno=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=P0oHHRNG; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=mskrOXHJ; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="P0oHHRNG";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="mskrOXHJ"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 69GBOQbo492119;
	Fri, 16 Oct 2026 06:48:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint-05-2026; bh=tA2uHNnkXTpOI
	fjaUq+0Oq926jlawI4Yh981qqq18Z4=; b=P0oHHRNGzBAGuSdk3LVAWAjpqcdyE
	V0zVtbNNr36o/PRcpj8qrSGWv6MozNss1hqLIy96HmOoLJaTA7R27Nae6dSYdIX2
	K4nkcgkJ8k8XqAzwOAaCe/32BBwATlMMZ+bVxb7XER+n5wf8IRm4WuTuUUxblJHp
	zZOtd61WEFlNGmKyISN38KKsHiz2xh7UHvPN6jtlLx2EDI4bDotIGkVv0HgUKYA2
	syq9lo8rKWKxVd6/qNQNcffHPleuaduei4JbxMPyfRlfYhzt63L/W1yBS0oPzinl
	Da1/8j5JZpus9rwPsfYeJ8vu0kcmCadCK4ErZHeNqPMxGankXJg/tsxUg==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013065.outbound.protection.outlook.com [40.93.196.65])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hbk12g3hr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 06:48:29 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qYOeqZnQ8JaqTmrZt/b61Yi8sAlJuaxRuJ4/Zbw0cYdRS+VzaxG1J3+CK2wMX0Jy/ay/EUPMLRvtVKbrtH1thfcO2aCUJ2cALXY7jIXRdAJm7zPqiE85Cpk+qD7u4K72HMz3gO0jeUIl4Zso6SsU5G+veaw+2oJAV0/B3Oe5JRcUPDajiqK9paKEES31f6kKXj7hD0LyIWPXYLYenZ+icmRNez61Vp2OS2cysxaB4m4McKQWekda11dI+gBWOw/PWDFZptL57Lui02Qj5LQc/ipstpTVc4Ox/hTiP6icZITP+vHTT3hTk01a38ybJrLwMM5XjrFDq/CjJ1tbRJYlew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tA2uHNnkXTpOIfjaUq+0Oq926jlawI4Yh981qqq18Z4=;
 b=UnbQflAw8ORhGFqz43QZQ6ifvKe2hZ+NvzaGCR98wWULaQHOX7W7VAJe8jET0Bksxs7PbQQnKyVe48nAt6hDD7Dctw6IsojSvpsCqQwKlQOhZpIRFnQgaktI81o2SUgHq+iqUZHEddFz1j21UPzS1HhrtE6LouSTrvCIhYZF/kV5nmutBRb37iUGPN1bK8yiPH0/+tEHYzQ+y/FvzQImZKDduUgAkZ1sIk6vDiqRHqVhgPuCXAS7p2GMi1qpzLbSJhZr6qOBk3Idft/xoZCOCOx1qSnWjalcfOQF0yHVH1UtWDZTJw2W5aoxL5j5LrLUEjX4yknFPSCzkHdgkLKBrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tA2uHNnkXTpOIfjaUq+0Oq926jlawI4Yh981qqq18Z4=;
 b=mskrOXHJyXl8fA22VGabuzxnODWhy3PdyqM1yEu1g7Y5yH5MRcM2G+xtBS9uHMF2ZPOucSEGp0IiU+xqA/FHeWfdVR6oog94afTONp7T6Mt/FKoD0Pova+prNHjqYu+eYzFyTcsxuGAK+IetGQtrMuSnQ19j/sRCdcXvy/A11N8=
Received: from CH0PR04CA0016.namprd04.prod.outlook.com (2603:10b6:610:76::21)
 by SJ0PR10MB4526.namprd10.prod.outlook.com (2603:10b6:a03:2d6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.12; Fri, 16 Oct
 2026 11:48:26 +0000
Received: from CH2PEPF000166C2.namprd04.prod.outlook.com
 (2603:10b6:610:76:cafe::94) by CH0PR04CA0016.outlook.office365.com
 (2603:10b6:610:76::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Fri, 16
 Oct 2026 11:48:25 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 CH2PEPF000166C2.mail.protection.outlook.com (10.167.244.228) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 11:48:24 +0000
Received: from DLEE212.ent.ti.com (157.170.170.114) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:19 -0500
Received: from DLEE215.ent.ti.com (157.170.170.118) by DLEE212.ent.ti.com
 (157.170.170.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:19 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 06:48:19 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GBmHvo1508449;
	Fri, 16 Oct 2026 06:48:18 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sebin Francis <sebin.francis@ti.com>,
        "Manorit Chawdhry" <m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, "Vishal Mahaveer" <vishalm@ti.com>
Subject: [PATCH v9 00/15] Fix several issues in DTHEv2 driver
Date: Fri, 16 Oct 2026 17:17:51 +0530
Message-ID: <20261016114806.1749515-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000166C2:EE_|SJ0PR10MB4526:EE_
X-MS-Office365-Filtering-Correlation-Id: 52fd6868-dfdf-4d9f-cb33-08df2b7b62da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|36860700016|82310400026|56012099006|261009223027099003|10067099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	1wtHXHyTEKy6BKv5Vi9uy8lS/Vcp6pLuYgjlQK9M51sRHRgnYDYrmz93CsMhfuqzbBbOohipJOR2FzLtXjV5ykbGq5l2WFoaSpIfRBFT4BQVISbZS1yc+8l9/m54dgGw5RDwtkBUanRvuqWTNCgJT7mSuN3GCuDs7nWeobjkuNneSLRFlMkDUrraOyf/2XFSHlzeJpBaZDVodxtWdR0khP7enCW+tJ9QRJomL7O72Eb29g1LA3EWfwTX84XFTgJcs3yAb/iGs+L5vkCyIFEs1Aeiu2NZvKN9GBN7vOPC+HK//24gAQTRKrrKySAKiw3Svffv0ROHKyxvUj5rOXFzAlMTsorSkHzc9DxtEuiBQqMjxsjOu0slTHSYp89T+Imc/usPUHwg7IbzCL6+OLXF+oC5eeWKXi7aeDLEzIFjB/Uciam34xU4N7bz6HNw8179/NG5Ja1QbOP7MJvMErZs7gQc31C84a5lh9gVIJEk3m/75w3U82hMlpoi0+52pcp9l9opYqDQhgwZQYjVpGw2qz+qscs1LPjbd6z7ChoF1oikJoTAzUoYSwqCZfB+6R+zAzFxgsWvq37A0P23OK/k9i9lEK0Q3/UILwanKjR8O1noDbjwyry3IfxFPD/KeZAnzaxh39/lQt2O6aER/kpSzg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(36860700016)(82310400026)(56012099006)(261009223027099003)(10067099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	f+JmGBoCvkarP8Dvnsw8Yra6cly79VkzHi8gj+lwQk3CrXa3isukoupt2dmPwrnl76vxdESOsVoaya9uRBvuQbaLnl3v7gg69PL0s1OPeeqtEaPJFtNQcyIOHk2x7nE079E7ZNN+YJfo63A7KVPaBCIFGovaeZcdV5mdHXNz4iFFWkKU991VT6z/4+cQvwaU+RAXjJ75Gehh8r2eF+qSp+2MB2w9/nO3304SsrJA3DEsJdyfZa9ksRaXnUhHyv27Sq12edNh9cDWLuBAuibERqHPgLg3S6EXoAbcwS8vCT4dylTttagtUrs0DWfzRGwiF4bRQ6ExzkDdVnXUTuHLNi+9fbQw+oVeM+69tSYnno8vnhj8kH0OEsynmdgbeVssjp9mWEk7Rmfble8y8etVIviAh2whDFDRKUmwOWm8o1IM39R7Wj01/HQe9p0GM3KD
X-Exchange-RoutingPolicyChecked:
	iteNBs4RMFHttN17rv5edBndJttud3oRouYnSiEuPngRZUhBbpywTwgjdX7QBnMGEiJpkuJF1L5DsXyZMFcDd6R/ZZNOAH+YfG2kexIrjB2Od8M7xDBiodDNAKbdbohxSU+9KGDy9hdOFmyJODO7gmg38XBCJ0bQZjwokHtOozbJq9O8qBU7mUkEdsp5fxKY8yHjsOOe79l6VElJDpy0M5HZN3a/jMuOjqWT3wthJffsPkxYRHJoPEVzickYrKnM5tPp7rAYpUvrn8TT78u6siJ6w8MkxbA3BlOQTYgzKD0pj+83+H9b2dapplUUo2p1YlgQ82NLyvAqNnFNW/LTaw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 11:48:24.8466
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52fd6868-dfdf-4d9f-cb33-08df2b7b62da
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166C2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4526
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfXz+lGu4d5YMmz
 VD6/bouiulpGwrUahsjUPneFRoPW7F5KLmfTlPsBRPCME546FLzF11wrJrlVMK3omwV1EF90BhO
 IP2iuyeLbXXZgX/ITPlSeAUqUShnXnWssgbbLigW//vV7lz/FP4iaPZi7Yq442rNA18+CDnc8pp
 8CYnmnlpQpxMPjzSK30+3Rcw1IQx1ONKMId+7CAVpvcFuS2EWO0mRX4hBYMHpd845Wb+sMC04/5
 4qku2yyYLwC+PqwH4O/icJblIX4PJbQ5XN+J1M28kmHM9j48qtkVS4GOLKM+buoM4WhgLRbb71e
 pb+2CZv7w2wKgHFykKzoDJ1MFFRxmC+9sa+r6Q8EcjMjgmbtd1VAEgPA9W3W9QRHko+9F3bqu1v
 gbTmvOxaIltANiheB3rJ3SodU+QVNM9ew4TQXSzPLsinEc78pDo2UoBwQyVR4VLicDI0Q7P7XUQ
 6VvXK7xyJQ+RkXisNxQ==
X-Proofpoint-GUID: axLvMPvZK3h7LNfCIiXzKIre-lIj67xK
X-Proofpoint-ORIG-GUID: axLvMPvZK3h7LNfCIiXzKIre-lIj67xK
X-Authority-Analysis: v=2.4 cv=fspJ914f c=1 sm=1 tr=0 ts=6ad20f0d cx=c_pps
 a=fgNoY2FrYBgJmLE9YDNrYg==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=c92rfblmAAAA:8 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=UxwojoEslEplIN4H4qAA:9 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfX0Ua2Ie5yGLgj
 UJF9JQrhSYyBC9q2QAgZoyCQBNC56+iWF71XL2lfSBE7lc113jgx0mAosXih0Xn6/QedYy5px4Y
 Q73Tu++xisOlxZLJI12gG/5EmJPzDJw=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 spamscore=0 phishscore=0 impostorscore=0 bulkscore=0 adultscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610160046

This series fixes a handful of independent and mostly benign till now
issues in the DTHEv2 driver which were flagged by bots and AI agents.
Except for the fifth patch in this series which was found in an
internal testing.

The Sashiko review on DTHEv2 hashing driver patch series v5 pointed out
some pre-existing issues which needed to be fixed [1].

One of the issues had already been flagged by kernel test bot and a fix
sent on the list by Mert [2].

I included this patch in this series with minor edits. Then the Sashiko
review page for [2] had more comments [3]

Overall this resulted in a bunch of fixes patches which would have
deviated the DTHEv2 hashing driver series had they been included with
it. So I clubbed them together in a new patch series which is this.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
Links:
[1]: https://sashiko.dev/#/patchset/20260807110501.975130-1-t-pratham%40ti.com
[2]: https://lore.kernel.org/all/20260613085858.32580-1-mertsftl@gmail.com/
[3]: https://sashiko.dev/#/patchset/20260613085858.32580-1-mertsftl%40gmail.com

Changelog:
v9:
 - Changed extensive completion re-init based wait to using kref in
   patch 04/15
v8:
 - Minor fix based on Sashiko comment (corrected spinlock)
v7:
 - Fixes based on Sashiko comments (added locking around
   dthe_put_drvdata)
v6:
 - Fixes based on Sashiko comments (waitqueue -> completion; DMA
   alignment for cache coherency)
v5:
 - Fix spinlock inconsistency patch
v4:
 - Fixes based on Sashiko comments
v3:
 - Fixes based on Sashiko comments
 - Some reordering of patches
v2:
 - Fixes based on Sashiko comments

Link to previous versions:
v8: https://lore.kernel.org/all/20261001085245.2922974-1-t-pratham@ti.com/
v7: https://lore.kernel.org/all/20260930125859.1749849-1-t-pratham@ti.com/
v6: https://lore.kernel.org/all/20260930112533.1593952-1-t-pratham@ti.com/
v5: https://lore.kernel.org/all/20260918102245.2784000-1-t-pratham@ti.com/
v4: https://lore.kernel.org/all/20260910175619.2122149-1-t-pratham@ti.com/
v3: https://lore.kernel.org/all/20260910104202.1537226-1-t-pratham@ti.com/
v2: https://lore.kernel.org/all/20260827132318.613876-1-t-pratham@ti.com/
v1: https://lore.kernel.org/all/20260827105711.527182-1-t-pratham@ti.com/
---


Mert Seftali (1):
  crypto: ti - Use list_first_entry_or_null() in dthe_get_dev()

T Pratham (14):
  crypto: ti - Fix spinlock inconsistency in DTHEv2
  crypto: ti - Fix potential memory corruption on highmem pages
  crypto: ti - Fix use-after-free of dev_data on DTHEv2 driver removal
  crypto: ti - Trim scatterlists to correct length in AES
  crypto: ti - Align buffers to cacheline for DMA
  crypto: ti - Separate padding buffer for src and dst
  crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AES
  crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AEAD
  crypto: ti - Terminate DMA on all error paths in AES to clear
    descriptors
  crypto: ti - Terminate DMA on all error paths in AEAD to clear
    descriptors
  crypto: ti - Do AEAD software fallback on only ENOMEM
  crypto: ti - Correct AEAD tag operations against dma cache
    invalidation
  crypto: ti - Change lengths in AES to u64 to avoid potential overflows
  crypto: ti - Change lengths in AEAD to u64 to avoid potential
    overflows

 drivers/crypto/ti/dthev2-aes.c    | 368 +++++++++++++++++++-----------
 drivers/crypto/ti/dthev2-common.c |  65 ++++--
 drivers/crypto/ti/dthev2-common.h |  66 +++++-
 3 files changed, 344 insertions(+), 155 deletions(-)

-- 
2.34.1

