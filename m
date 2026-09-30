Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11021101.outbound.protection.outlook.com [40.107.130.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0BD4DDB23;
	Wed, 30 Sep 2026 16:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.101
ARC-Seal:i=4; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787320; cv=fail; b=rs0CVpR4Fi+DkHq3Xbo5zc+6XdnEOL0wZveOn1G+94Tp/2k64W1Bp0rOhNRmhl8o/Lckanm8Igj2rME7/8hIqC7JY/8eAAyOk3CRUPsIQx0hsKZsCKpSe+QFPLOJvjNJrpd6PGFgJYgOWCAyJOu7SKSrE7Z1D9Tvm8F3ZyTYEJk=
ARC-Message-Signature:i=4; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787320; c=relaxed/simple;
	bh=qVJhgyrH98QEF5aaZW9FVk8tWI3dEDTdDSFfdFgi+IQ=;
	h=From:Subject:Date:Message-Id:Content-Type:To:Cc:MIME-Version; b=GdMT67avPjhbi8Q5G6f0s7o8kFgwJpsqTaANbDTt93BIXcMSokaK4FYTxlHj11Qk1pHU8dZ+8HharzZyeaubeHEJd8YD55gVOQjZXATO+xsVXzNWLpNiDiwew5JCB1VVYp3e8Bxlj+2NFFvbVRwJMAVu00FpdHRslWeEQye/rhU=
ARC-Authentication-Results:i=4; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=solid-run.com; spf=pass smtp.mailfrom=solid-run.com; dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b=fZMoT0bq; dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b=fZMoT0bq; arc=fail smtp.client-ip=40.107.130.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=solid-run.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=solid-run.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b="fZMoT0bq";
	dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b="fZMoT0bq"
ARC-Seal: i=3; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ed8VRjQQ1+5+pNMhUE9Yhpw8CGX4ixEB7tfeyJNZuZJC41NWsd3BMP72+dtFpB1ehQ/AIAlLtq+uy06deA9Ni/S+nrk5bhYvM06WE9XtIU48V/XPPn054ky3BkJ6qzMadQ2H9OEgbQAATLwH3g8dMm01Cp2hkBd+kZeXeWHlTQyxkrNuU4pAsU457GeJ7Y/0NxrKCLw2qDevzw2HviTyFOUEVpW2b/7NPsqQCsvIHx+rcP/1DKckpOfBH01zLZ1BBTEdS+ZAAkpk28IoVdyIKHKcmJu5nBmnMGd49M3Ssowj8bihcgQhtee+1DMVUkV6xU699XKymxtTrpWxhTqQPQ==
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yc/4rx/shdZLDUyui4f3LZNqRXnW+Yyu5/nmVcpXHq4=;
 b=IVYjegOLGz++TpiAZPd3j+BidGOMYTPKGhQ20sUodshUohI0Uoa4qkBp7ryNidksrL6HkLjLlswh++NP90idztAuock2xtQWzGxcgG+zwbbgxf6Z0pfsGd2DKmfkKpxH+rZgz6JzWITEU0XtAZ0Q39DJ0PCDDC9nw5SbGUwYOb3P/qWNZ6IVnxdtRiXFxaldcVZ0AEv1HmC67r2PTfH194GffKySMUfMqZbP5qnriVCc0TrNL8w07j0ILhJeCSHgDDBHFri8SUgnx25QsfnIAOP4BZ0ytaIUic114oWdpZ6/FOvXgqyERAQfYrDTU3SbBzHZ21W+DzOO8cYCWZxs/w==
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
 bh=Yc/4rx/shdZLDUyui4f3LZNqRXnW+Yyu5/nmVcpXHq4=;
 b=fZMoT0bq6VvfFHULZHJ1BAGV/framCD1Pt5nw7/aqlwkxsr8JjgQLz9dzH99U55EeiWEsorcAZw1zP0FyKB2sI0793HlWuGWgXC0Pjnaq6A5Uq03RrVVnADUHOp3eqsVFDK6gt92iT3sWQAVGekF5n6JCB2waJ4FuaWU+dPE4WmexmDsvTLeuaFj5pexjHuo2DDcYibifes6GBNdoc0xdXITv+wveWd1K3+HpqMjdVehQCj2yxQZ0SL4Hx6X1QJMkxGXw19La7H0FmcD/cMbqqyZA1HOQuLkV3Hq+yg2EE3TZ8NMNkICEX0tDCvbrYhmnX+ykj1jQHB4n2VPs2XiOQ==
Received: from CPBP307CA0017.DNKP307.PROD.OUTLOOK.COM (2603:10a6:380:2::13) by
 PA4PR04MB9709.eurprd04.prod.outlook.com (2603:10a6:102:26b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 16:55:14 +0000
Received: from CPH1EPF00000530.eurprd05.prod.outlook.com
 (2603:10a6:380:2:cafe::47) by CPBP307CA0017.outlook.office365.com
 (2603:10a6:380:2::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.13 via Frontend Transport; Wed,
 30 Sep 2026 16:55:14 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=fail (sender IP
 is 52.17.62.50) smtp.mailfrom=solid-run.com; dkim=pass (signature was
 verified) header.d=solid-run.com;dmarc=pass action=none
 header.from=solid-run.com;
Received-SPF: Fail (protection.outlook.com: domain of solid-run.com does not
 designate 52.17.62.50 as permitted sender) receiver=protection.outlook.com;
 client-ip=52.17.62.50; helo=eu-dlp.cloud-sec-av.com;
Received: from eu-dlp.cloud-sec-av.com (52.17.62.50) by
 CPH1EPF00000530.mail.protection.outlook.com (10.167.241.171) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14
 via Frontend Transport; Wed, 30 Sep 2026 16:55:13 +0000
Received: from emails-5762875-12-mt-prod-cp-eu-2.checkpointcloudsec.com (ip-10-20-5-37.eu-west-1.compute.internal [10.20.5.37])
	by mta-outgoing-dlp-272-mt-prod-cp-eu-2.checkpointcloudsec.com (Postfix) with ESMTPS id CC32780F54;
	Wed, 30 Sep 2026 16:55:12 +0000 (UTC)
ARC-Seal: i=2; cv=pass; a=rsa-sha256; d=checkpointcloudsec.com;
 s=arcselector01; t=1790787312;
 b=OKRFwIxpYgxSSUm8T/WPf+z6sVzQWmEvX9SsQbud6V7a8F6TIE22AdxBK7nV/fRGajhMf
 oCIOcX/YfMVAAQc5iFdcu2vgjc7Mt1b4TIY5eahD3ze1hmnd/cSftVPlC/xLrIEO6QTfSK+
 gHfCHoix4RpZeszwTqe+RcI8QD85mFo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed;
 d=checkpointcloudsec.com; s=arcselector01; t=1790787312; h=from : to :
 subject : date : message-id : content-type : mime-version;
 bh=Yc/4rx/shdZLDUyui4f3LZNqRXnW+Yyu5/nmVcpXHq4=;
 b=Mf/9l8vCJFP+M+bnbUAdcHOAp7Kd4rF3IB9U9tarognZdIy6R7TjqowSmZOvsshU+Codq
 8BfaaWxccPYnCzjB1jzng1GwnL1Yp7veqDbfJYjgp0bXtjWU4p58dr9fPR87ASFMrLUX5kI
 pc2EToyN9QNCddyyosoGwFLKFd+vYN4=
ARC-Authentication-Results: i=2; mx.checkpointcloudsec.com;
 arc=pass;
 dkim=pass header.d=solid-run.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=solid-run.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yc/4rx/shdZLDUyui4f3LZNqRXnW+Yyu5/nmVcpXHq4=;
 b=fZMoT0bq6VvfFHULZHJ1BAGV/framCD1Pt5nw7/aqlwkxsr8JjgQLz9dzH99U55EeiWEsorcAZw1zP0FyKB2sI0793HlWuGWgXC0Pjnaq6A5Uq03RrVVnADUHOp3eqsVFDK6gt92iT3sWQAVGekF5n6JCB2waJ4FuaWU+dPE4WmexmDsvTLeuaFj5pexjHuo2DDcYibifes6GBNdoc0xdXITv+wveWd1K3+HpqMjdVehQCj2yxQZ0SL4Hx6X1QJMkxGXw19La7H0FmcD/cMbqqyZA1HOQuLkV3Hq+yg2EE3TZ8NMNkICEX0tDCvbrYhmnX+ykj1jQHB4n2VPs2XiOQ==
Authentication-Results-Original: mx.checkpointcloudsec.com; arc=pass;
 dkim=pass header.d=solid-run.com
Received: from MMZPR04MB400504.eurprd04.prod.outlook.com (2603:10a6:190:28::8)
 by DBBPR04MB7499.eurprd04.prod.outlook.com (2603:10a6:10:203::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 16:55:03 +0000
Received: from MMZPR04MB400504.eurprd04.prod.outlook.com
 ([fe80::2f52:2d22:c7b3:4292]) by MMZPR04MB400504.eurprd04.prod.outlook.com
 ([fe80::2f52:2d22:c7b3:4292%5]) with mapi id 15.21.0451.022; Wed, 30 Sep 2026
 16:55:03 +0000
From: Josua Mayer <josua@solid-run.com>
Subject: [PATCH RFC net-next 0/3] dpaa2: avoid scheduling dpio interrupts
 on isolated CPUs
Date: Wed, 30 Sep 2026 18:54:57 +0200
Message-Id: <20260930-dpaa2-isolcpus-v1-0-66c13f4fd75b@solid-run.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOE+vWoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDS2MD3ZSCxEQj3czi/JzkgtJi3dTkJHND0zQjAwOTFCWgpoKi1LTMCrC
 B0UpBbs4KeaklunmpFSVKsbW1AAprIxVuAAAA
X-Change-ID: 20260930-dpaa2-isolcpus-ecb715f2004d
To: Ioana Ciornei <ioana.ciornei@nxp.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 =?utf-8?q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>, 
 Pankaj Gupta <pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: Yazan Shhady <yazan.shhady@solid-run.com>, 
 Jon Nettleton <jon@solid-run.com>, linux-kernel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org, 
 netdev@vger.kernel.org, linux-crypto@vger.kernel.org, 
 Josua Mayer <josua@solid-run.com>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: FR4P281CA0174.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b7::20) To MMZPR04MB400504.eurprd04.prod.outlook.com
 (2603:10a6:190:28::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	MMZPR04MB400504:EE_|DBBPR04MB7499:EE_|CPH1EPF00000530:EE_|PA4PR04MB9709:EE_
X-MS-Office365-Filtering-Correlation-Id: f20ec116-c696-4faf-60b6-08df1f139885
X-CLOUD-SEC-AV-Info: solidrun,office365_emails,sent,inline
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|10070799003|1800799024|376014|7416014|52116014|18002099003|921020|10067099003|260925022911599003|260925021311599003|260925021911599003|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 ijiXv0iasWMP8tCMUaXwPs0S5pwj0NHIQ1jQNMvt3T3/o9ZpqxvGWFV7S3Gjxt787XoBuMxalo1bGAgNgTqFdTVjAvSEtXHSSLzHuk+V6ieeE3nsXj+48N22vptqnZpvdR7DUDehCl98Wb6v3EcfTJL3wJolwYB1E39YXkouqmZ9UJmr7WIOschfOjI9BTDTB2PYFHcGKH1CYwRqnpnmo9RsgciOkB0hssHYIRASFnBVo7M8JRs0r/lmWJZ7MR7DWhrFOcQmjo62Wf44Kx4ID4z+Vt8SCK7U2C3QvbSRByPcgDTqcbETEyol4KG23FzeAFyt7tD+yOAnd+Ik+uSGaU75umwC225TrrQNHpooPEmcjJ9yNZTKZNwf2CDA8CNHopfqVndJcPIPRp6ziVqfVR4MXawLRuU7/N7wEGJiJGzN3pdqzw2V+qHtQxdtz+61e4MqP2VWVfvHVEb5qjIabYY5YEQwVfBOKPwA+gwaRKN3OMQ1JXQ/x8yzXganljdJd+6pGWjTAPrmXv2BThySdxO1TAfBVqULD0RqbqLV7WrQpNRf0JJVKBGBLCEmkOHa8N7uKpNYgW/zA0jFIRh8d85RNPuaghi1L73JgO2K6Jmf7b1Dv8R+rwkoYV8FaquIhse6N35Qp43qVG3J0J4Xj07nceP6t0yW/fraoVFemMQWYOncg2w4M8S6H6zCchcJaqjZu9Wc3Dh+UyXn2wazBA==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MMZPR04MB400504.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(10070799003)(1800799024)(376014)(7416014)(52116014)(18002099003)(921020)(10067099003)(260925022911599003)(260925021311599003)(260925021911599003)(56012099006);DIR:OUT;SFP:1102;
X-Exchange-RoutingPolicyChecked:
 HlF+HIMiP1NLccFRF/ZJHcKwWKlkpoPNqVLsxZnQwapUPbGdH7259vueHALtdCS69ugoHdrLk/Fl7aXV+aACltu16KAV3WDWw1AvQFF73R2ZHBuyZw97CmA2hCA/NNvgVgs1W04xKcKDOq2QxgKUlxrSL5lj2EoAf1DBDSzp1aydYpzCSDFT8sAoLtbJgcWT6wgcRZWrzBjYpLO8Hx+bQDm6c+JjDGgKjNvZyAbhF4bfiljWwsWYVnSTlTynMBRBemEaPp+3dPlOgxmiRg4+Lws0w1+9TezObXTNfzj2kWiI3HhnyyfpRNDEI37bGJckfG1R0tNJfMm69nM133x1Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7499
X-CLOUD-SEC-AV-INT-Relay: sent<mta-outgoing-dlp-mt-prod-cp-eu-2.checkpointcloudsec.com>
X-CLOUD-SEC-AV-UUID: 713ae4c4c25a4e5a933b2bd299afe363:solidrun,office365_emails,sent,inline:776544cf20a4f6cb347dc8a29c053d94
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HbJExt4n3pOXm/kAZMGJM9EpCva11MpibC0o0TaR9w+W/y0Cspkudf6r7eYQM529yMWQkhhZt1KYn/fOJRcOSCtJAUruO4HKrDi46bYnR7jLNwakZ1pgMI/M4RmhVbq9i0HcV5dgy10EYracZFMJUudYkr2PbAFelQzpJ6Apoqmuj7OToSBc/QqzKAZ40CK3AQKdJypqdoBMX2jQDVBf7yumbQzEBWBk/Tubn9kRDFwFkc0gEYskWDRylAdv2uug1YiAxHtm02ixDQNwrDdNP2OgsVxr2eh3/H026q8Oopj83u2dH7XXKqGJgIgOCkJfuyriNIdWp10VxPQm7IKCQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yc/4rx/shdZLDUyui4f3LZNqRXnW+Yyu5/nmVcpXHq4=;
 b=LP0147VjuNtRTmSvakYhZM+U70BGDBXzKfl7Sy8Td6W/dpBqARqRHLJJBOe3GVkZTzNYz8yQ6B42+mXyOfNzFLqocpMNvltabgcWYnWGhVjC0pNRV5o+1CtS3xvIRg/FTCluNrmmfyeDRS8Y5Nvi0653CE6iB5GqfjHk+mUkn71v/X4UEkjTcBSTz63JmgvUVU9i7UHUV9SUCZiJMyBxxsLDtoj/dB5p9alYuCsOgoizIcIo6lEf9//LJWfEZGT+yNAuA1VqlGPYuNIefs6xv5dBZ//Q9Ds8cYg5nLi4FuCqd2lhn6n9ocu/RPZRvlVWkar2a1y5mNBdo8L57eoTRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 CPH1EPF00000530.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	477fe3d5-398c-48b4-fcd5-08df1f1392b4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|14060799003|35042699022|36860700016|23010399003|10067099003|56012099006|260925021911599003|260925021311599003|260925022911599003|921020|18002099003;
X-Microsoft-Antispam-Message-Info:
	xASxTJsP48cu/pk6H4hmbMcxqu63kz6oQ5cB+8Bl2pbgV4Pu/uT7njLQyP3WAvgxa0NaejNYiegCMJ9a62NAjJB2iOnOfKjIE8TmaZY2XcnXfUXUKAYSGZ2lZneGfDYLp69u7zKksDW4D+IOHdWsgj95ZQoeVjm49E8VDZypG38MZ9Jme8CI9SISCZj7kNgPuOyR77BdgkKIkhs7wwPsH+/qSvCoagqOlN+JWSPbFyzf3Bz7+CqiiUqiHzsfZwK8cMNBh7n0H16EtBnRjAIUfhOxEP6K/ns6sAPH2+Pux1ebSkAICXjV67Mk7YCN1lgjui97zliFNstRKSEbFCGam5u0fPnEwHSCk/GXqdeog6KPgVyLr9JD/ZuIX7QU7MyybCwFB0F/7Gn3JlnP4TWyjvmOEZpRsOKzcb3ZnZn89d4bFNELgklA/E1k+6K57vH0QHxh9MNsr2JCRo+SqhZzONi/lBXe7JapOldRXKH0/D3S+gPOspIn8Ve1SO5djNMkw3DCzyYr4vqhCo1Np0swLAHmUM6gCjk65RQtjTTCstkDY5RBLTzW+l0WHS+8K5JOV1ElYMi7XjMznN02PudCmmtL6mI+omTvNXim0Sm8YlGri3UR4VbkcAaftDZxG0Y7b69PDkrvYhxVKNggKQyH0pbNGXvbwf7mozKXuGXzbCDixFj7bl+7xpyqA2A85U8U0pkGAxeCTKAwnPGORqeZMwHi7VmHmoDSyh1M2NBs3qE5a+jHUodHUZviSj0e0w16
X-Forefront-Antispam-Report:
	CIP:52.17.62.50;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:eu-dlp.cloud-sec-av.com;PTR:eu-dlp.cloud-sec-av.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(14060799003)(35042699022)(36860700016)(23010399003)(10067099003)(56012099006)(260925021911599003)(260925021311599003)(260925022911599003)(921020)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DHVKV05ZxjjWGwSem2T10aOr7MGXkKbLbtPPbjPNqrpl1gVK8RIQoYdjz+xFTnV8iBLhUicwGEp1SfkvAT6mArErkks83xo5rnrZ4XoKFNqiFGKZBMXZ0KnWDPHm84ZROKC1ASyfZG9cncXzR7kvV95+EARn8ow3AdhTC7flhx1RTxIa9g2RlyDW0HYSP3e5nOJCu+8/baIbU3WtxWCcgUjLGRWZMZfwfQjCZNv6+NIaaRYljKbLsBbFmZHIlUd9iWdC6lxcLAISwiy7wahuNjL00qdAQjiHaWP73RC/0MLs4I0MXx/Bg9mnAT+n/hQaNoIk0bBF4YUSShItdgk1afBiuJ78HwpGi0VYl1yD6+SKthkiggpD9kHFGGYjQeD130gmk4qGH+tFAYatYS1rI96UDsIhKDvTynOoqIBzjqfhQzG5GtwvEj7Gnl4NMwdL
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 16:55:13.2276
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f20ec116-c696-4faf-60b6-08df1f139885
X-MS-Exchange-CrossTenant-Id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=a4a8aaf3-fd27-4e27-add2-604707ce5b82;Ip=[52.17.62.50];Helo=[eu-dlp.cloud-sec-av.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CPH1EPF00000530.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9709

Sent as RFC due to very superficial testing, and confusion wrt. which
list/tree to target. Suggest net-next. Last patch is logical first, but
must be applied last.

Each DPAA2 software portal (DPIO) is bound to one CPU. The dpaa2-eth and
caam qi2 drivers allocate channels and queues for each online CPU.
Notifications, and NAPI polling are processed on each DPIO's affine CPU.
This balances I/O load nicely across all available CPU cores while
keeping data on the hot path.

When isolcpus=managed_irq is used to reserve CPUs for latency-sensitive
applications, those CPUs are expected to be free of routine device
interrupts. However, DPIO interrupts currently continue to arrive on
isolated CPUs, interrupting any application running there.

This series assigns DPIOs only to CPUs in the HK_TYPE_MANAGED_IRQ
housekeeping mask, and changes dpaa2-eth and caam qi2 to set up their
per-CPU channels and queue pairs only on those CPUs. Without the driver
changes, both would defer probe indefinitely, waiting for a DPIO on an
isolated CPU.

Isolated CPUs can still transmit frames and enqueue crypto requests;
the resulting ingress, Tx confirmation and response processing runs on
housekeeping CPUs. Systems without isolcpus=managed_irq are unaffected.

Note: This series is submitted in reverse, to ease bisecting.
Otherwise caam/dpaa2-eth would defer probe iondefinitely when booted
with one or more isolated CPUs.

Signed-off-by: Josua Mayer <josua@solid-run.com>
---
Josua Mayer (3):
      dpaa2-eth: skip isolated CPUs when allocating channels
      crypto: caam/qi2 - skip isolated CPUs when setting up queue pairs
      soc: fsl: dpio: skip isolated CPUs when assigning portals

 drivers/crypto/caam/caamalg_qi2.c                | 26 +++++++++++++++---------
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 10 +++++++--
 drivers/soc/fsl/dpio/dpio-driver.c               |  7 +++++--
 3 files changed, 29 insertions(+), 14 deletions(-)
---
base-commit: 47a1446725732cd3996edf607e8739334bbf4d78
change-id: 20260930-dpaa2-isolcpus-ecb715f2004d

Best regards,
-- 
Josua Mayer <josua@solid-run.com>

