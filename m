Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11022079.outbound.protection.outlook.com [52.101.66.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4DA3F12EF;
	Thu,  8 Oct 2026 10:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.79
ARC-Seal:i=4; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791456616; cv=fail; b=AYxmRre0Lm1BvCZilhB6DVst06v1G/wuJ/qKoQhp1guzOb63JN2Uuo622YUEXd+4QEp6kve0j1VQ229IAXSPvj2bIl0kYzIcGxldn1Vs+4oZdbQfiOCk63g1W4bIpCM2V7JTDVIuWrWQ0ZA57dsBH9gjGb+MR4aeuxLwJjA6lI8=
ARC-Message-Signature:i=4; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791456616; c=relaxed/simple;
	bh=8zk52ZY07EI28o1l7j7zbQKCmp2g3L40BCojdLbWFvM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uklb43FcPmXyzGVQFunHUwdMmIB1RfO+KNNUeKZw6iXcTnMdV/YPInCKcCuzVADxVFIQbZIA+KEhvI+00bCBd3V8OFuMk79OUcAkPslRXW0dmD3gp8LpCP5k9LV6B9ujkFYTE4jTFRYZlI8cTiPJrg8HADSLN7/qaTcKyCKbnaQ=
ARC-Authentication-Results:i=4; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=solid-run.com; spf=pass smtp.mailfrom=solid-run.com; dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b=kZB8qdph; dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b=kZB8qdph; arc=fail smtp.client-ip=52.101.66.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=solid-run.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=solid-run.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b="kZB8qdph";
	dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b="kZB8qdph"
ARC-Seal: i=3; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=eIUydKcN+vnOHNSRXqmrd1CMsolJbJsV1N1sqH38zcybAx1F3evWffwjGfACYFjyTIyOtU4gmO3BIYkhXGkrihcm1mmyvFtPA7mhuIKEdrAlUAjumHviJ7l4581pZS8YCKD7DONU4aFTunisaaGtEXl/F8seMxXI9AF+taJX2lthJlv9VS6SdXwfFLmEzeuN5jQMd/wXpKBgYWD73BJVK8ybxt0I546Ruj/cBFMg6lxMlXkxxYt92sOLQXaP+N9b0310R/bJQjoGzBnG0AJf9cvbmMd1Cw0hOIPQ2J3pZ8FMSWu36uZaKWLr+2ppWol1go5vmVjY/FKd/Cq4fkYZ5A==
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zk52ZY07EI28o1l7j7zbQKCmp2g3L40BCojdLbWFvM=;
 b=bPd+jy01fVjXwqW8Xip9Yc+1Qvf/bYgkO/s4wMEOe3kBkf1BSop3KX488X27YDEXpwa+HBXKtZuHOJTaZOt0b0+C18TI7eYF4Si209vTKmrjnm2DQNUpz5Rb8gpwmjmo58Rt7MgqmFYaAKGNjATver0ca6aiWCH4XJsUEW8SqAeFHRgaJmt6+unr7W6AEtx5KoJDHaGMNvT4s70ftXW3tpl9io3N3xuNzzvWDsit6T7yPM9lUzaYNl0Mm/HJwrpqKmTDzJbklFzPbkRD2hv5aPOCrcY0uspUXUmCX7asUFZnO02/VZkjBtUhh2Hrmgd3nlrI3oTIa0mvQhSvJff56Q==
ARC-Authentication-Results: i=3; mx.microsoft.com 1; spf=fail (sender ip is
 52.17.62.50) smtp.rcpttodomain=davemloft.net smtp.mailfrom=solid-run.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=solid-run.com; dkim=pass (signature was verified)
 header.d=solid-run.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=solid-run.com] dkim=[1,2,header.d=solid-run.com]
 dmarc=[1,1,header.from=solid-run.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=solid-run.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zk52ZY07EI28o1l7j7zbQKCmp2g3L40BCojdLbWFvM=;
 b=kZB8qdphat4oC5GeUgaaKccjzEpoU3BghpOeZCV8CxKwf15Lg83cH4jvP4yl6gJaW1BOtxVbgpqUOIvVhdQhepI/1ggumofMsF35k6l2CQ3Hw+LKXoHLqMS56sZ4mZwgepN9mywJp+CGXq4HhDz3XGOn18suHdsaPHcoTx1mCtMeoUTifZhOvRTO8QRa1gm08E7U0GA7kLp31i74AK2WQHB7HgfeyMwEO+MmuNNC8AGKhHTYKPqFBFFsKOv27nn0KamvINUOJpW6W8yL6a86yK9RK0sqwC30B3bJkg9k0fE9JgF7TkXAIjYaxSHkTxJX3BJy2nO9bYEklnfQmNO++g==
Received: from PR3P193CA0019.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:50::24)
 by DU4PR04MB11962.eurprd04.prod.outlook.com (2603:10a6:10:617::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Thu, 8 Oct
 2026 10:50:09 +0000
Received: from MAD0EPF000008C1.eurprd05.prod.outlook.com
 (2603:10a6:102:50:cafe::19) by PR3P193CA0019.outlook.office365.com
 (2603:10a6:102:50::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.21 via Frontend Transport; Thu, 8
 Oct 2026 10:50:08 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=fail (sender IP
 is 52.17.62.50) smtp.mailfrom=solid-run.com; dkim=pass (signature was
 verified) header.d=solid-run.com;dmarc=pass action=none
 header.from=solid-run.com;
Received-SPF: Fail (protection.outlook.com: domain of solid-run.com does not
 designate 52.17.62.50 as permitted sender) receiver=protection.outlook.com;
 client-ip=52.17.62.50; helo=eu-dlp.cloud-sec-av.com;
Received: from eu-dlp.cloud-sec-av.com (52.17.62.50) by
 MAD0EPF000008C1.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.14
 via Frontend Transport; Thu, 8 Oct 2026 10:50:07 +0000
Received: from emails-5374845-12-mt-prod-cp-eu-2.checkpointcloudsec.com (ip-10-20-6-117.eu-west-1.compute.internal [10.20.6.117])
	by mta-outgoing-dlp-814-mt-prod-cp-eu-2.checkpointcloudsec.com (Postfix) with ESMTPS id 0C317810F0;
	Thu,  8 Oct 2026 10:50:07 +0000 (UTC)
ARC-Seal: i=2; cv=pass; a=rsa-sha256; d=checkpointcloudsec.com;
 s=arcselector01; t=1791456607;
 b=iZWzfzntHJy3bCQXKhdfIZqS6xmbwhgZqQbXBZyIqK1sep/UzgY8H48CphZc1dNPBmbRe
 qSiFMl3MTKh54Mf71QH4up2n5eXgbruovhTH1/CylUj7CCDXv1En4OW3+Kp56+4XfeScF6h
 kSCEOVX/uKyxLikn0xfOyLeXwr4Lck4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed;
 d=checkpointcloudsec.com; s=arcselector01; t=1791456607; h=from : to :
 subject : date : message-id : content-type : mime-version;
 bh=8zk52ZY07EI28o1l7j7zbQKCmp2g3L40BCojdLbWFvM=;
 b=VKaR99gSuUKkBMG75MqNppQ8UcV7v3qSR+i1I2rASosXuCaFVKYSyCb561Hia7PlXL9tv
 yESifN2xtNIZK21C8HQEm7XCjX3tw2Yf6WTNsJZdiV+nEnI5qsqYTK3AP5gb1EhGrUrbXV7
 94PJZhx1YFBCM++OA+HW7tbsjTrLQiY=
ARC-Authentication-Results: i=2; mx.checkpointcloudsec.com;
 arc=pass;
 dkim=pass header.d=solid-run.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=solid-run.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zk52ZY07EI28o1l7j7zbQKCmp2g3L40BCojdLbWFvM=;
 b=kZB8qdphat4oC5GeUgaaKccjzEpoU3BghpOeZCV8CxKwf15Lg83cH4jvP4yl6gJaW1BOtxVbgpqUOIvVhdQhepI/1ggumofMsF35k6l2CQ3Hw+LKXoHLqMS56sZ4mZwgepN9mywJp+CGXq4HhDz3XGOn18suHdsaPHcoTx1mCtMeoUTifZhOvRTO8QRa1gm08E7U0GA7kLp31i74AK2WQHB7HgfeyMwEO+MmuNNC8AGKhHTYKPqFBFFsKOv27nn0KamvINUOJpW6W8yL6a86yK9RK0sqwC30B3bJkg9k0fE9JgF7TkXAIjYaxSHkTxJX3BJy2nO9bYEklnfQmNO++g==
Received: from BR0PR04MB686055.eurprd04.prod.outlook.com (2603:10a6:2c8:45::7)
 by DB8PR04MB7114.eurprd04.prod.outlook.com (2603:10a6:10:fe::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.16; Thu, 8 Oct
 2026 10:49:57 +0000
Received: from BR0PR04MB686055.eurprd04.prod.outlook.com
 ([fe80::2a90:2c88:134:2086]) by BR0PR04MB686055.eurprd04.prod.outlook.com
 ([fe80::2a90:2c88:134:2086%5]) with mapi id 15.21.0496.015; Thu, 8 Oct 2026
 10:49:57 +0000
From: Josua Mayer <josua@solid-run.com>
To: Ioana Ciornei <ioana.ciornei@nxp.com>
CC: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, =?utf-8?B?SG9yaWEgR2VhbnTDhA==?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, Yazan Shhady
	<yazan.shhady@solid-run.com>, Jon Nettleton <jon@solid-run.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>
Subject: Re: [PATCH RFC net-next 2/3] crypto: caam/qi2 - skip isolated CPUs
 when setting up queue pairs
Thread-Topic: [PATCH RFC net-next 2/3] crypto: caam/qi2 - skip isolated CPUs
 when setting up queue pairs
Thread-Index: AQHdUPxwz1ayOdNbzkyQEcmXADciwLbwNxAAgANMNwA=
Date: Thu, 8 Oct 2026 10:49:57 +0000
Message-ID: <6d6f2e02-afd3-4e24-8b54-68cb93ce8174@solid-run.com>
References: <20260930-dpaa2-isolcpus-v1-0-66c13f4fd75b@solid-run.com>
 <20260930-dpaa2-isolcpus-v1-2-66c13f4fd75b@solid-run.com>
 <cozavqeupdtr7cyn33nvtfqoqkw3sop5tffou6753vwg63hgwf@jr6gx236yblx>
In-Reply-To: <cozavqeupdtr7cyn33nvtfqoqkw3sop5tffou6753vwg63hgwf@jr6gx236yblx>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=solid-run.com;
x-ms-traffictypediagnostic:
	BR0PR04MB686055:EE_|DB8PR04MB7114:EE_|MAD0EPF000008C1:EE_|DU4PR04MB11962:EE_
X-MS-Office365-Filtering-Correlation-Id: dfff3482-d04f-43c0-03ae-08df2529eaf5
x-cloud-sec-av-info: solidrun,office365_emails,sent,inline
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|38070700021|56012099006|4143699003|5023799004|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 w9itzw2dkS621iXX13oDl0UdTe2bg4syqScL6pBSSrJbkf6ngUdoMHOM+sfunMu2Pn7eArjRCK/LL90vHFR19QeG7jBn+VksC20pcSQGt9ek7/tPfFX6Em4bnjSgzg3ldf2f9Zg56QahnoTJRrXFu1aeMD7uWU/GSCZsojBNFFT0BMxfQAhRK5akeyyVMphJHPkFJkCVHvPBiThUk45DHH2E2Hx0sIsSC6ivWcxt6R+BjGwQKfjUph5atmhFzR9vtYAGhIsbFmGO0h9RTm98Djmo/L1+4jIDfAK576EaX40hsE9WrQnpHnQ8M1t+RecNGZHOx8laZBgd+HS3j45W8OoT2g6VnzXhBHA4juH70DzBn6vvEqeevvrMwowT7u6tLBWW+JTSMy/jHd2WmnqxGG0mS7poo7eHe5bDkN/A/CG0NItzkQ8I0c/SzCuMl8mZgNvOLvKWlnr3DeINnEAYg5D99hDOY92GwRMHFSQm1EcqRRuhSG4E5HWmKFC9YftDMXVPkq+hVEcO/mXcT12/f1RVuFM0dnO78yG3aJndFgGAfvyUHqhHMLxQqkDEri8DdP1Zu8ycI2Ryf1S5QfHGm/rSAhkARFzcAAbuHKwUY1Qpq3C4O75c/SPzUegQAsedCu+ujjaF6LwL7vOi3fb+W9pH1LUYSRP9YZoaJTTI5i8UfrB7tYJ5uwi88MI3MpRiAWW3QvfbdBps0bvNtkcqVn0T9Xt3gkXiXMree/BSA5Y=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BR0PR04MB686055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(38070700021)(56012099006)(4143699003)(5023799004)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE5FCA43F50A604CB14D2BB8CF713E77@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 iFpScXRd71cQ6n0TSs4nY+bkydJ/sIHjKHOawyJ6/LTfEawY6LbWIcxDv5uTx4514nu39JVgSh7Zy7k04YzFbQb5vABPGnpztUVSMPikeEmVT4fvTDudI14DjdNZDv1jFiuKNiwh+TMXWbLECuNcgEw/tYJIlNywaCFRrEsDPPcxJTiD1lUcNL2cAaFpyYse27JVqzRWE2urrWBDvp+/MDmJoh81dnzU+cxCvinmb9IOdINlkBu9Aj+6gFuiWpDJGKDYkmbmLUxu5QGN9pUQ2ON2/iPh54JDV9hTYVkJqXjuDPYHAK5/XVmQ+N3P9K+YK6oBIZmN3Ls8XMz2EbF+Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7114
X-CLOUD-SEC-AV-INT-Relay: sent<mta-outgoing-dlp-mt-prod-cp-eu-2.checkpointcloudsec.com>
X-CLOUD-SEC-AV-UUID: 66f8020a3de94a18ba3401e09e39b763:solidrun,office365_emails,sent,inline:80c504baf986e5b6950ea801bb2db396
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cbcgWrePp3DbzYoBB1uKIxD7ST724IB02RxzjbO2ka9h95zUwK6ilZgAS9OtSPpUbbQAcr3esOZ9fpwqZSuoN4z1X/GwzCIlXRgClrdUYZoAjgTySH72WsvV2iBV2TBQhh9wLeERl13fdNIFxlNsrd7LMcnykfEzGDUc1icdshmyA41b5XcacyiD/puf2P0hl0FPn5UQX0SPufYsU5VOVgr4YCeS1CkA4+X1znwVKi0SIEaU3crP6/HPP50l9/Ej7vbv4Lv5jY6aebIQUKEXay3UBGdT3JvRE1zmE3o19YoTpWbm3EBCBY3aKZcVPzD8SS++VV84ETkx2A4dcqvb+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zk52ZY07EI28o1l7j7zbQKCmp2g3L40BCojdLbWFvM=;
 b=DLOaddgQgQtC8X5L+r53ONAvIyD75LBIjqNE0NexGj34dyOKI0qLa9NoqK2X6mEJevFEtRfDazGq7kxey0W/3ttcN7Uou8+hc6Q073a5FFgmCuagfKygVnFIckr+dK5G3DTYs9PydydoSESlatybSkWLBfb/xp6ZLYajS8XTI/RPXAu6LfDwt0WUN2f8spU/C0DaH7udXs/YgTb/UuGE4aGy7tDuwBGA+n84lZITzl5sr4+GqB2iEHQ4PjTyD9MSZT/hs8TFN3csLOSzS8qNYX/yURgE0X4XBg6Xu45ExWPM9T1LRNdlviiWINAxge2t0e+wQaWm6sWIIZMuS2+kmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
Authentication-Results-Original: mx.checkpointcloudsec.com; arc=pass;
 dkim=pass header.d=solid-run.com
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MAD0EPF000008C1.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	725a56a8-f4c9-49c7-6fcb-08df2529e4f2
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|7416014|82310400026|36860700016|14060799003|1800799024|23010399003|22082099003|18002099003|10067099003|4143699003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	wRuQN7DBIP/VJsCblVijLaHpLi95nmMy9FLfv53yDivlsa4amxEpyYUFSah99IxEDEPf41zVKIcBQzon5v/4BA34ym4AyI2SQz8rzRx15jOYXNj+Iler3nT1ZLs6Qs/VRVzYcwvtDagm9cUSzyfqtC5/AhVGmzr4WeCrHvFbkY+Pd8vUIxTgGSExCJgBHRnjIipc0TPFmQSdvi+/M0CKE5djplisehlntR2mBQmUue6KXW/NTxJOpBars8Uqh9BSqhhVT+lEMgHRDRHfU6Y/TUcJYBJI6+LUzfrO6jWwG4/c9z3LVdP+anz0nxMeKVICRM+nCZ70EWSjBkhV00HXOpYTcqCUkXHEhvS/nVTqj+HSSP7+3BForuoW2MCAW45c+FysksMjes3gFYKaPyIGZEl2d4Kj+mli7gxk1VVAsd0RNr21O0wG1rCPjZuN4U80eVmBhGLAnZXAzKcJjNv3uusBpiIc9bPo/GmMkIn8IqEdG2+ujguoPd3mATgCieTzqvFXkqYgI7G6W/26pUpa+nd19OepDzURgSeGV/V+E2Py5lCiP+x6KGakRBWG8btnohO2+zNvMdAKDxcN2IudchszzqPqUGb8MFm7vwx2ewdnM/3J2z43whNkIVna5nHQrFayabDLNRxCSfQq4OX6JJPs57lg+r4DfSiUnksI+ip0+HluvoMXvUAj1mndln0WkU2rEutH4yKzvjjrviBCag==
X-Forefront-Antispam-Report:
	CIP:52.17.62.50;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:eu-dlp.cloud-sec-av.com;PTR:eu-dlp.cloud-sec-av.com;CAT:NONE;SFS:(13230040)(376014)(35042699022)(7416014)(82310400026)(36860700016)(14060799003)(1800799024)(23010399003)(22082099003)(18002099003)(10067099003)(4143699003)(5023799004)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NyQ2HQk/N9q9Nef3NC2Gv//+3rTZVEkKob3fD10EUri/JCIHasQhu6y+0PzuPsGG6MRo4Xp8bsn22WZCoX9PT8xNjPqJOGGr+mOcHfsQC/MrCtWrM0/JgE4cTZBNioK/EJMPz8dFoVdfqQyYmysExxtwHT7QIW2zk55M7d2ciKnXTTqbNjQK4vfoFo9rKheX+NWc0L0npI2gvYGMexzUcqn7NrLu/kQ/fOA67fmaXWhllJD6ou174y+6ja76/pXlTsNoPf1oQoKnG1P4N1RW05maNwFkT948qAG0KkwsvNMF/snWZSW5Z1mwtrYKkUtJ58musxYhmyix7auT2yE8Fofq7zq16tMPiDTFl8BWHI4spyE+XMwTKrsBe6GBWYJ5I98L8vRKAb543eQGT87BJrFItWz/rHBM6Tw08WPEEUwDVexfW9+wQ1zijVI+lf8L
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 10:50:07.4322
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dfff3482-d04f-43c0-03ae-08df2529eaf5
X-MS-Exchange-CrossTenant-Id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=a4a8aaf3-fd27-4e27-add2-604707ce5b82;Ip=[52.17.62.50];Helo=[eu-dlp.cloud-sec-av.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MAD0EPF000008C1.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB11962

SGkgSW9hbmEsDQoNClRoYW5rIHlvdSBmb3IgdGFraW5nIGEgbG9vayBhdCBteSBwYXRjaCENCg0K
T24gMTAvNi8yNiAxMToyNywgSW9hbmEgQ2lvcm5laSB3cm90ZToNCj4gT24gV2VkLCBTZXAgMzAs
IDIwMjYgYXQgMDY6NTQ6NTlQTSArMDIwMCwgSm9zdWEgTWF5ZXIgd3JvdGU6DQo+PiBUaGUgZHJp
dmVyIGxvb2tzIHVwIHRoZSBhZmZpbmUgRFBJTyBhbmQgc2V0cyB1cCBvbmUgUngvVHggcXVldWUg
cGFpciBmb3INCj4+IGVhY2ggb25saW5lIENQVSwgdXAgdG8gdGhlIG51bWJlciBvZiBxdWV1ZXMu
IFJlc3BvbnNlIG5vdGlmaWNhdGlvbnMgYW5kDQo+PiBOQVBJIHBvbGxpbmcgYXJlIGhhbmRsZWQg
b24gdGhlIERQSU8gb2JqZWN0J3MgYXNzaWduZWQgQ1BVLiBBbGwgb25saW5lDQo+PiBtYXkgZW5x
dWV1ZSByZXF1ZXN0cy4NCj4+DQo+PiBXaGVuIGlzb2xjcHVzPW1hbmFnZWRfaXJxIGlzIHVzZWQg
dG8gcmVzZXJ2ZSBDUFVzIGZvciBsYXRlbmN5LXNlbnNpdGl2ZQ0KPj4gYXBwbGljYXRpb25zLCB0
aG9zZSBDUFVzIGFyZSBleHBlY3RlZCB0byBiZSBmcmVlIG9mIHJvdXRpbmUgZGV2aWNlDQo+PiBp
bnRlcnJ1cHRzLg0KPj4NCj4+IFRoZSBEUElPIGRyaXZlciBhc3NpZ25zIGFmZmluZSBDUFVzIG9u
bHkgZnJvbSB0aGUgSEtfVFlQRV9NQU5BR0VEX0lSUQ0KPj4gaG91c2VrZWVwaW5nIG1hc2ssIGxl
YXZpbmcgaXNvbGF0ZWQgQ1BVcyB3aXRob3V0IGFuIGFmZmluZSBEUElPLiBUaGlzDQo+PiBkZWZl
cnMgY2FhbSBxaTIgcHJvYmUgaW5kZWZpbml0ZWx5IG9uY2UgRFBJTyBzZXR1cCByZWFjaGVzIGFu
IGlzb2xhdGVkDQo+PiBDUFUuDQo+Pg0KPj4gUmVzdHJpY3QgcXVldWUgcGFpcnMsIG5vdGlmaWNh
dGlvbnMgYW5kIE5BUEkgcG9sbGluZyB0byB0aGUgb25saW5lIENQVXMNCj4+IGluIHRoZSBIS19U
WVBFX01BTkFHRURfSVJRIGhvdXNla2VlcGluZyBtYXNrLCBzbyB0aGF0IGlzb2xhdGVkIENQVXMg
YXJlDQo+PiBza2lwcGVkIGFuZCBkb24ndCBkZWZlciBwcm9iZS4gSXNvbGF0ZWQgQ1BVcyBtYXkg
c3RpbGwgZW5xdWV1ZSByZXF1ZXN0cywNCj4+IHdpdGggcmVzcG9uc2VzIGhhbmRsZWQgb24gaG91
c2VrZWVwaW5nIENQVXMuDQo+DQo+IERvbid0IHlvdSBuZWVkIHRvIGFsc28gY2hhbmdlIHRoZSBm
b3JfZWFjaF9vbmxpbmVfY3B1KCkgZnJvbQ0KPiBkcGFhMl9kcHNlY2lfc2V0dXAoKSB0byB0YWtl
IGludG8gYWNjb3VudCBvbmx5IHRoZSBob3VzZWtlZXBpbmcNCj4gbWFuYWdlZF9pcnEgY29yZXM/
DQpJIGluaXRpYWxseSB0aG91Z2h0IG5vLCBiZWNhdXNlIG9mIHRoZSAiQWxsb3cgYWxsIGNvcmVz
IHRvIGVucXVldWUiDQpjb21tZW50IGluIGNvZGUuDQo+DQo+DQo+IFNvbWV0aGluZyBsaWtlOg0K
Pg0KPiAtLS0gYS9kcml2ZXJzL2NyeXB0by9jYWFtL2NhYW1hbGdfcWkyLmMNCj4gKysrIGIvZHJp
dmVycy9jcnlwdG8vY2FhbS9jYWFtYWxnX3FpMi5jDQo+IEBAIC01MTAxLDcgKzUxMDEsNyBAQCBz
dGF0aWMgaW50IF9fY29sZCBkcGFhMl9kcHNlY2lfc2V0dXAoc3RydWN0IGZzbF9tY19kZXZpY2Ug
KmxzX2RldikNCj4gICAgICAgICAgfQ0KPg0KPiAgICAgICAgICBpID0gMDsNCj4gLSAgICAgICBm
b3JfZWFjaF9vbmxpbmVfY3B1KGNwdSkgew0KPiArICAgICAgIGZvcl9lYWNoX2NwdV9hbmQoY3B1
LCBjcHVfb25saW5lX21hc2ssIGhrX21hc2spIHsNCj4gICAgICAgICAgICAgICAgICB1OCBqOw0K
Pg0KPiAgICAgICAgICAgICAgICAgIGogPSBpICUgcHJpdi0+bnVtX3BhaXJzOw0KDQpDb3JyZWN0
Lg0KDQpUaGUgbG9vcCBpcyBkb2luZyB0d28gdGhpbmdzIGluIG9uZTogYXNzaWduIHR4IHF1ZXVl
IHRvIGVhY2ggY3B1LA0KYW5kIGFzc2lnbiByeCBxdWV1ZSB0byBlYWNoIGNwdS4NCg0KT25seSBy
eCBzaWRlIGlzIGFuIGlzc3VlIGZvciBpc29sY3B1cy4gRG8geW91IGhhdmUgYW55IGlkZWEgd2h5
IGVhY2ggY3B1DQpnb3QgYSB0eCBxdWV1ZSBhc3NpZ25lZCwgYW5kIGlmIHRoaXMgbWF5IGJlIGNo
YW5nZWQ/DQoNCg0KSGVyZSBpcyBhIGNvcHkgb2YgdGhlIGNvbXBsZXRlIGxvb3AsIHdpdGggaW5s
aW5lIGNvbW1lbnRzIG9uIHRoZQ0KY29udHJvbCBmbG93Og0KDQo+IAlpID0gMDsNCj4gCWZvcl9l
YWNoX29ubGluZV9jcHUoY3B1KSB7DQo+IAkJdTggajsNCj4NCj4gCQlqID0gaSAlIHByaXYtPm51
bV9wYWlyczsNCj4NCj4gCQlwcHJpdiA9IHBlcl9jcHVfcHRyKHByaXYtPnBwcml2LCBjcHUpOw0K
PiAJCXBwcml2LT5yZXFfZnFpZCA9IHByaXYtPnR4X3F1ZXVlX2F0dHJbal0uZnFpZDsNCkFzc2ln
bnMgYSB0eCBxdWV1ZSB0byB0aGUgY3B1LCBvbmUgdHggcXVldWUgbWF5IGJlIGFzc2lnbmVkIHRv
DQptdWx0aXBsZSBjb3JlcyBkdWUgdG8gbW9kdWxvIGFib3ZlIChpZiBpID49IG51bV9wYWlycyku
DQo+IAkJLyoNCj4gCQkgKiBBbGxvdyBhbGwgY29yZXMgdG8gZW5xdWV1ZSwgd2hpbGUgb25seSBz
b21lIG9mIHRoZW0NCj4gCQkgKiB3aWxsIHRha2UgcGFydCBpbiBkZXF1ZXVpbmcuDQo+IAkJICov
DQo+IAkJaWYgKCsraSA+IHByaXYtPm51bV9wYWlycykNCj4gCQkJY29udGludWU7DQpBZnRlciB0
aGlzIGkgPD0gbnVtX3BhaXJzLg0KPiAJCXBwcml2LT5yc3BfZnFpZCA9IHByaXYtPnJ4X3F1ZXVl
X2F0dHJbal0uZnFpZDsNCj4gCQlwcHJpdi0+cHJpbyA9IGo7DQpBc3NpZ25zIGEgcnggcXVldWUg
dG8gdGhlIGNwdS4NClRoaXMgaXMgdGhlIGNhc2Ugd2hpY2ggY2F1c2VzIGlzc3VlcyB3aXRoIGlz
b2xjcHVzLCBhbmQgaXQgc2hvdWxkDQpiZSBhdm9pZGVkIGZvciBub24taG91c2VrZWVwaW5nIGNw
dXMuDQo+IAkJZGV2X2RiZyhkZXYsICJwYWlyICVkOiByeCBxdWV1ZSAlZCwgdHggcXVldWUgJWRc
biIsIGosDQo+IAkJCXByaXYtPnJ4X3F1ZXVlX2F0dHJbal0uZnFpZCwNCj4gCQkJcHJpdi0+dHhf
cXVldWVfYXR0cltqXS5mcWlkKTsNCj4NCj4gCQlwcHJpdi0+bmV0X2RldiA9IGFsbG9jX25ldGRl
dl9kdW1teSgwKTsNCj4gCQlpZiAoIXBwcml2LT5uZXRfZGV2KSB7DQo+IAkJCWVyciA9IC1FTk9N
RU07DQo+IAkJCWdvdG8gZXJyX2FsbG9jX25ldGRldjsNCj4gCQl9DQo+IAkJY3B1bWFza19zZXRf
Y3B1KGNwdSwgcHJpdi0+Y2xlYW5fbWFzayk7DQo+IAkJcHByaXYtPm5ldF9kZXYtPmRldiA9ICpk
ZXY7DQo+DQo+IAkJbmV0aWZfbmFwaV9hZGRfdHhfd2VpZ2h0KHBwcml2LT5uZXRfZGV2LCAmcHBy
aXYtPm5hcGksDQo+IAkJCQkJIGRwYWEyX2Rwc2VjaV9wb2xsLA0KPiAJCQkJCSBEUEFBMl9DQUFN
X05BUElfV0VJR0hUKTsNCj4gCX0NCmRwYWEyX2NhYW1fZW5xdWV1ZSB1bmNvbmRpdGlvbmFsbHkg
YWNjZXNzZXMgcHByaXYtPmRwaW8gcGVyLWNwdQ0KYW5kIHBwcml2LT5yZXFfZnFpZCwgbm90IGdh
dGVkIGJ5IGFueSBjaGVja3MsIHBlcmNwdSAoYW55IGNwdSkuDQoNClRoaXMgY2F1c2VzIHR3byBp
c3N1ZXM6DQoxLiBlYWNoIGNwdSBpcyBzdGlsbCBleHBlY3RlZCB0byBoYXZlIGEgZHBpbyBvYmpl
Y3QNCjIuIGVhY2ggY3B1IGlzIHN0aWxsIGV4cGVjdGVkIHRvIGhhdmUgYW4gYXNzaWduZWQgdHgg
cXVldWUNCg0KSSBkb24ndCBxdWl0ZSB1bmRlcnN0YW5kIGhvdyB3ZSBnZXQgaW50byBkcGFhMl9j
YWFtX2VucXVldWUsDQpJIHN1cHBvc2UgaXQgY2FuIGxlZ2l0aW1hdGVseSBoYXBwZW4gb24gYW55
IGNwdSBjb3JlIHdoYXRzb2V2ZXI/DQoNCnNpbmNlcmVseQ0KSm9zdWEgTWF5ZXINCg==
