Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794067630;
	b=irNL6DaBh9YTgGaqLMEzcG6MO6hDMo8B2LYk3SBW/Rybl+lCgFNsZzv+zv/vSbutgYl5
	 057t+3hZi1qCdqsJCGl2hl/fVGIkUw/ewWXwnhFoYpREGHNMFyMXuTTj2m+CA9XWlSBmw
	 84GftcoQweqWdSnmTfgD0rn+LocNAAIf11HPO11lFYN5dqz8E+MpnPw8Q2hxJ3sLx0SSU
	 5JCCnqHtR6HBe7nxaY4Oxd5rY4o9WGpRiJZ9SCdYbYWrPVv3NGn8ML0n3aLXDXv6Od+In
	 ToveVkVBVpyK2PXegqT5bbCAmHoSXsVpZGlvfZoGX03pa8j62AxVKY2wMdtPSMvOIfQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794067630;
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
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=qdr1sxsSWfErkbdpkpjqc22HIHrIyzwqIDBJo0L5tzg=;
	b=GAvbqkVRIDnFo3pZwjI1yGEjMTG8Y0e2jsOnc/k/rctMw3hfKtjDjKpMaZgE8adOE6LU
	 XYwvAwKL9dshKp3KH+nCQ8MwcV9cJUIEX4npr1QWI/pQ0uwiXmJyd4ui47ZXP0sMNk0bi
	 GLEOBrzl/Zrg6D0BohZBfEB5S4X+8H0vcsbMvSnTmmlSsTj01aAUo27upgbw4U3A7OJoU
	 4biWoeLTumtuUsSHiFQgSW/TA55BzrU4gCzZf0UYf6g5+K1MdsbHQur8EcBv7FrVEMV21
	 PzMbYsWGKhHZApHH+NxrpeDstxYSI0MFA6VxqvETND1MPdr9RrKSWKbp5HeN+WDUWvA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=Cra5bZls;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=T4byseIb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145C8606A32C;
	Sat,  7 Nov 2026 16:07:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 145C8606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=Cra5bZls;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=T4byseIb
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7Exg282334662;
	Sat, 7 Nov 2026 10:07:07 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=qdr1sxsSWfErkbdpkpjqc22HIHrIyzwqIDBJo0L5t
	zg=; b=Cra5bZls/jQKngRRmYgJSLXf3upS/a4Yp7EDU0zp6cqAF35r3EWJ7YyKr
	xcKdaEJcmXyVVk8Mhf/gyRq/bAgph7z46RmEm84Z0Y14yNL0pMmCy0CtUwdY7oa6
	BEaxZPnfgpORngfSZmTVMw7k9JvYryhR0whPinLs6hb5jQzv8gFaLYsJWDwpqv7+
	5YlVhPm2XrVfsL9imosof6CKaRRVC4UM2AcgGF/yqIUuNKVLhrj+20VBtrNDLVGR
	G+hGrucokCkkKlCgREzidBRMFCdqtAe6CawAyBtkAy702JM08CoVa+kbi1wgkTHz
	jiK1ypcX1jefxP+ZaEGOIsZegHmYQ==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013068.outbound.protection.outlook.com [40.107.201.68])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hsbwyydtv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 10:07:06 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PAV/9WM6NeZTsSwYJDTTUWiKWJJRKHNiiGlntH7SGgoMa2PpwBO98D/LawLybEznnWI2gJBO+xWz26F97QJJDTgbDgqUlPCmY9hxlgrpRLnMRGIdUI0GTqfKKHI9C32XwqapSG8WjX7anYtQyaTjPQaSyK6dkLeelioPJj/yfbR3wzBnZf9x/SEV091cXQqwKwavWacJACxM+uclN3TH/0f2pOKnsWgxb8O91hGyLC0TTIbm1JCisQarDJTF5n7u04fYqis4eMzJhtHFH3xaPJ0b0ImUf3PJ5s49WvFaR5lzMkgsJ5i4V0yOdCTVD5+/f5uLLqK1iZOCx1U1nDHZlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qdr1sxsSWfErkbdpkpjqc22HIHrIyzwqIDBJo0L5tzg=;
 b=Zl7RUQdpO7NlGpNHeO9piWgNQ3WhQv0xu5bJ6fiwvq6q8q+IcHqZhv6RnNmC4W9y34eO08q9lhHHWFjFKFWcUY8uNhs+uye9NNAJpALUy+ygrVqlOKLr3vv07+MCjIMq0WEwRFa6QeSqAvc+kZ08op53CVnjh6eL7mpNUiF3ogsXKNfa6MqkNIf2wxcz4gkw5/JC2LdUEw1XFvuDGZeUCT0wCAQRO09xT0i5szRtR8ruNdOsWC12/m/mKTPMFDEKFdr6kPf4sNq1PFu9L+x6B9VkTb0JfWgz52DsF2SbfJ2sq82Na8nF3UfcDar01O90UZohvk0I2bLWPqr1P3OCQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdr1sxsSWfErkbdpkpjqc22HIHrIyzwqIDBJo0L5tzg=;
 b=T4byseIbZeI52/kQQPXbmoixxlBiEMTi89SJfNLZfvDX8tuJf4CoE4aC/3Z1dCszy9avYLL602q62xaOzuO02Cg68TMVYqF3X5D6RcIwHxAp5KKKExkrlJFTsDveGV5467GgsdBIt9uDEE4QyYhyBxmej/Iv8HwO724bIpUpy7I=
Received: from CH2PR14CA0055.namprd14.prod.outlook.com (2603:10b6:610:56::35)
 by CH0PR10MB5050.namprd10.prod.outlook.com (2603:10b6:610:c3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sat, 7 Nov
 2026 16:07:03 +0000
Received: from CH1PEPF0005BD5C.namprd02.prod.outlook.com
 (2603:10b6:610:56:cafe::62) by CH2PR14CA0055.outlook.office365.com
 (2603:10b6:610:56::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 16:07:03 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 CH1PEPF0005BD5C.mail.protection.outlook.com (10.167.244.245) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Sat, 7 Nov 2026 16:07:02 +0000
Received: from DLEE202.ent.ti.com (157.170.170.77) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:06:55 -0600
Received: from DLEE208.ent.ti.com (157.170.170.97) by DLEE202.ent.ti.com
 (157.170.170.77) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:06:55 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE208.ent.ti.com
 (157.170.170.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 10:06:55 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7G6reP3459556;
	Sat, 7 Nov 2026 10:06:54 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v12 03/15] crypto: ti - Fix potential memory corruption on highmem pages
Date: Sat, 7 Nov 2026 21:36:18 +0530
Message-ID: <20261107160631.2592763-4-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107160631.2592763-1-t-pratham@ti.com>
References: <20261107160631.2592763-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0005BD5C:EE_|CH0PR10MB5050:EE_
X-MS-Office365-Filtering-Correlation-Id: 537a7847-ff1a-40d7-3dcc-08df3ce9293a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|82310400026|36860700016|261009223027099003|261021123027099003|261022105027099003|56012099006|261026140227099003|261021121427099003|261028144727099003|261102123227099003|18002099003|22082099003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	HUxiyk9BjyowjzpVaaxLthkHu5rSOimzoJtLYPD6/Qf0r5i2wygKKLx6SaOo+xg2YPmmsJocM8eEFvFoApNQTSty5wlUowxiEHg/lWXoyCIykVTUumPeYlzpMUGcR5HmfucLwdt84TAAoQ7H8ULebe9Erb5YnCl8nV1Tqn1oSioWfF1IiJMJWfYaEiMqQoQhNto2qI0jVbSa5DrNuaVwXaWdI2PaLB9Z/Fswc0clS0mjiN/GrLJKR4QpAQGtmFYrVmCr8NkCmduR6pMA0evHgpsYf50iMH/FsJcG6vbzFieBZ0oFzPOPK1BciPnkRTtN7Wptnsa5j9FliuKuVqbD3IZXQBTsaurMtjnGSDaZR2lG/dGfkbG65l8jnzZ2uEDzjjvs/Qot9R5FqvPgdOc7jgWjQnYWyVP9cdFWEZlL00rSr87MYqZyjIcsKEsQqJOII3c0PWd4xhydzYRb5BPJ0+CfQYr7s6/rYbpTM76dXFZpHP6Q8Pa8Z0rVMRQin9sjEFi4rZEaSROL6qwfW3B3D+Hn06C3sIzBxMZXaLviQL3hQr2lxjZaVb4vw9MVAFOE5TaFKxaGQ6L3k6ddiwRbFLZN6GaQa8C/CFVpSV+J1xk23HBIoAdI0aJnm6CCzABzls/6BcywFbjJIKn/iTFpwv2GlCLZkaZoBrbgroWa/yLNhpx0WTTegvIxwCFZ0iejw7y1jeXQsAoJCTBkVwsWMQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(82310400026)(36860700016)(261009223027099003)(261021123027099003)(261022105027099003)(56012099006)(261026140227099003)(261021121427099003)(261028144727099003)(261102123227099003)(18002099003)(22082099003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Q6jMubJycZB17ZO6oZTNgPvytL1eJhEevE3hwvAMsoECtrhrwU9X+f45TVaWc+AchgJwHXe7VyqlzwcuaABSwMQ3G628I0tTPpXwebKgsBQ7xSBhbVbbAgBi5vsxpdznwfiUBs+GoA866zL9xWu/v3FYpuEDOZePppbP8phBNj1XrAAHpAbFZVzjcHbwFZcoIJjWgFy6eGV6hmv1nPX6r227kSQPMX1zroJ7PZIzwONdw8zkR9hl4f4lkaynWmJL69l1g3TCNt1CKVyPd5NfpHZXTDhkuSzFHxBIFvMXrBM+DYkcX9HeJEcXsGGQxdck7zLNGd5pJB+/dwA61Ir7neg64WA+XEWpDNJCklKf3Cs7WWOi65FJjJ78I3LuaMxOSeMEw8L4MPijSBS+jG7bRL+Kul3vksXspRygxjY9g+vyGxQxYRM4IMtnMBE+fvQY
X-Exchange-RoutingPolicyChecked:
	xtv7J05tYSEGCgQnhEQN7/JHxy4aucxxZrMBpkxRoML8PXiDzhWO5iN4Bz7Rz0FOm2/OlMwRYl3hEMpiA+yCMtSoWeMlN32Tm1K6agbASPXhdraiFEp0iZhAYJvecEP79OdK53k4j42JrNUNl6fwQkL+ZXDMlqZu30CWN9Dug1+IUrzeOZmBOyzhTkzIELBLT4M0eZg54SzfsqFvfHc53b+6ZdpFMkbYP14jfLFdUEjQ78iqX1CRxLlouIOnbJOq4fpJBUe2tqT8bSOxZB2GxfcreLA1MPmXeMNtGaDIByU5X5R/cGJ1aFmfK8PzMd2Qc8KTsg3k0Tc5uR7PZm+/yQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 16:07:02.5903
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 537a7847-ff1a-40d7-3dcc-08df3ce9293a
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0005BD5C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5050
X-Proofpoint-GUID: Ihmj-m2iPnAdmArI80-kpfEAycAGI0zW
X-Proofpoint-ORIG-GUID: Ihmj-m2iPnAdmArI80-kpfEAycAGI0zW
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA2MyBTYWx0ZWRfX7QolWcly33IW
 kWteYb3ta89sDI66/ldKJCgQuw+eCsTQBcl/VEtfV7xULrXHs8OsKy36LrPMKGx2hEVPGHICiky
 PhecCKcXIlM2iTHc3V5x/PyRB+njHGo=
X-Authority-Analysis: v=2.4 cv=fvNJ914f c=1 sm=1 tr=0 ts=6aef4caa cx=c_pps
 a=QwCZ9Ep3279coiJ7nb8JBQ==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=IXP722aH8NCvtdUuCEcA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA2MyBTYWx0ZWRfXxJUEvkGiu/eB
 bfd8tfJo1ooyno3fdCzZiKlf/jfHzhjsp2T5sRUyWQLXFxxpVvfGnb9+vhkGJn35Ug+QXlhVmcL
 yU/S8fnia3W1oKLy37Ylg/sUTA00paugcryJbflQX7lGP2RTx/q5ZiGbwrIRd4iV462zk2QyMGc
 lnRLuO2Sidxex0SAgvfkRNkP2yeTNZ0AtHFnq+JxxRkUZ0Ocx6cwpt2b6Kd7Jkz8qKkOfQScZAb
 GL4ZOd0deDoahtfx2R7ouwoZ9yeKMv20KCVLMTtpw5ilvF/aEJfxagG5QOzFXii0uUG2qbQWLRj
 z6QO2ZmjtbDE/jbnpYAK4IWGYytJrbWEMRWBE02cR65V1QIVeEj2Xu/4k6yGM6JE85ojMpJShNe
 3dnheeruny7wbwNjwo88K+dx1eT/zOur3YSeGvhEAk0c8Z9B1GzK5ExddqZt1ibJQ0POY4cTJas
 u4CBIWAiaHcUl4u7m6g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070063

Change sg_set_buf to sg_set_page in DTHEv2 dthe_copy_sg function to
avoid using sg_virt() on scatterlists. For scatterlists containing a
highmem page, sg_virt() yields invalid or null adrdess, causing
potential memory corruption. While we are here, also change function
signature to change buflen from int to unsigned int.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-common.c | 4 ++--
 drivers/crypto/ti/dthev2-common.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index a7d3831f2f9cb..911e6bbe4d241 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -49,7 +49,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 
 struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 				 struct scatterlist *src,
-				 int buflen)
+				 unsigned int buflen)
 {
 	struct scatterlist *from_sg, *to_sg;
 	int sglen;
@@ -58,7 +58,7 @@ struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 		sglen = from_sg->length;
 		if (sglen > buflen)
 			sglen = buflen;
-		sg_set_buf(to_sg, sg_virt(from_sg), sglen);
+		sg_set_page(to_sg, sg_page(from_sg), sglen, from_sg->offset);
 		from_sg = sg_next(from_sg);
 		to_sg = sg_next(to_sg);
 	}
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index d4a3b9c18bbc1..75d9a097650da 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -126,7 +126,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx);
  **/
 struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 				 struct scatterlist *src,
-				 int buflen);
+				 unsigned int buflen);
 
 int dthe_register_aes_algs(void);
 void dthe_unregister_aes_algs(void);
-- 
2.34.1

