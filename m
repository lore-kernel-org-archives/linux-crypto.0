Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2084.outbound.protection.outlook.com [40.107.249.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7896E2957A8;
	Fri, 23 May 2025 14:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.249.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748009444; cv=fail; b=EWYCVG5+8OwjLMAmtORZe7z4Exti7IS2OcrCtdzgJ6i1jMtApTQmZaq3BC9bpilUys6Nh/vOmGRzRa7lGz+ys1xaJud1Vp9KNUZwC9pSa7K/F0Jnr8SQXH964ZlSijlcRnLI0hHYY0wPQyDGHqJQK0bZNrA7xtafPnT3Ne9eu6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748009444; c=relaxed/simple;
	bh=pe9hhfPoDA+98BrhPxXeoEFq/mAL6wZclyhBnhHDi8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gZ0Vh9285Ku4rBx7UgeoW1U1XOn6MDzOqGf14cwclVicmS9EZ0xXrrzaCopNv4CEux4q2zUbEXdeolpbZH2SsnYE8l7qM8/O1/EIkSBKySy+lue5AgBb41P0Dzpx4qJ9qC9YOoWpE+2Cq22Vyf7mF9HzTSx/rPlCBBi4K6K9AqA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=TSKhhxkr; arc=fail smtp.client-ip=40.107.249.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="TSKhhxkr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ndPeKpacZAeKYuKr0DD4wO3DuVItoCmBSw/xBIEOWxPU0YzRg531t9B9qkTFSDRBsQnOeA1bcisvxA+ImfG1HjKi0uQ+EDTImSplKR3wM0+zeaGyHywvaI39wPkgz3OU+CBckYTNCRgHHSy3yUAL7iQqmdwPyH41Zy9dh8xglqLUb4TdwYw3+ukijH3bZKMia67iYOeWShM2UfiqQQtzyir/vxvbNLEg5ntVAtTgBORGvtgI+Vt5ommNhNpSUQ1MFf99RgTIF1EuSRLzCzsL3MEUwa4WSNyoa2mHkUZkHl6MuuZn3scxi27ywgF1q+aYyTsY6BdQryQ1VNgmY/mAug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sUr5FiW/hcA9YUjje1K1NqjI9+29THpKX9BwFnPcxZ0=;
 b=li8RMQEFd/DqkeriMquIolMOS4K6qLghkbDYD4iV8O5I5ZmvkK3zHUPBGaTLhBipmYi5Nk6cTXD+H5WP2j5mrXOHg8EpKAt8POTdlF+c7AKz9j3tPftVisjxGGaMZEss91O+pHKKkDnTV6lKI1se+FIPxeOuHpXfRu/utuQZQ5/p559C46IztLu/VN/WYFSYXvNiuyr7yEME2XXRn6DxYb9jueeZhwYuHrHeFHTZqNDe5fzbqkuuHSSzHz3qwr/W7bf7/FHEAvfCwFnnCQRAjre41Epx9uKNkC2Z3OkL7x2X4oYcr5TNGKsF3acubcSmf0aUvgzbGEUfcTqRcc0Buw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sUr5FiW/hcA9YUjje1K1NqjI9+29THpKX9BwFnPcxZ0=;
 b=TSKhhxkr+PsGjHCnNsRgro0MR4G+PFtXXHLX+TOEaDSSyWqg6LVqRxvBRc3QIf5PjtD4wfc+iV9fmlDO4fEnEdabV8SDJ0DcLHvWZ6KSzjAc5YAtFZw5HJKWBFKCijiCTrXIAWzBjYDFu4VHb5AK4mSlgemKh7As603il+ToE2YkpD9FqZkv0ewutFZ/4Z9H/PtHztjOYiW5hvt3RZiYxLU8+YC8gx7ZGbpTiDnSjCfyIqUW/wIl75yPC8f9iBuCVLpAjh+CFXewzT7mkLCXsbSlOPUECHdeTnFB0tBtAOhrn7g0vYP0LhULOns5uNpB+nPPCulNlZwDDV0mHh01PA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9642.eurprd04.prod.outlook.com (2603:10a6:102:240::14)
 by GV1PR04MB9086.eurprd04.prod.outlook.com (2603:10a6:150:21::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.22; Fri, 23 May
 2025 14:10:39 +0000
Received: from PAXPR04MB9642.eurprd04.prod.outlook.com
 ([fe80::9126:a61e:341d:4b06]) by PAXPR04MB9642.eurprd04.prod.outlook.com
 ([fe80::9126:a61e:341d:4b06%2]) with mapi id 15.20.8746.030; Fri, 23 May 2025
 14:10:38 +0000
Date: Fri, 23 May 2025 10:10:20 -0400
From: Frank Li <Frank.li@nxp.com>
To: John Ernberg <john.ernberg@actia.se>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Thomas Richard <thomas.richard@bootlin.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"imx@lists.linux.dev" <imx@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 4/4] arm64: dts: freescale: imx8qxp/imx8qm: Add CAAM
 support
Message-ID: <aDCBzGVBTnuUv+lZ@lizhi-Precision-Tower-5810>
References: <20250523131814.1047662-1-john.ernberg@actia.se>
 <20250523131814.1047662-5-john.ernberg@actia.se>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250523131814.1047662-5-john.ernberg@actia.se>
X-ClientProxiedBy: BY1P220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::9) To PAXPR04MB9642.eurprd04.prod.outlook.com
 (2603:10a6:102:240::14)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9642:EE_|GV1PR04MB9086:EE_
X-MS-Office365-Filtering-Correlation-Id: 1552f796-10eb-48d8-9a37-08dd9a0397fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|7416014|366016|1800799024|7053199007|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UmhjMUxuWWx1cUIvQ3pkYjJ0d1BTWkh4d3pKZ1dXRkZzQ215dXNKV1FhaDhy?=
 =?utf-8?B?WlJMc2lWUGFOb3JSaVdXM0pHUTdrKytsR0xja2wySEVMbU5CYmgxU2tTWll2?=
 =?utf-8?B?QmcrZ0w5SXdNNGdWcjNXaC9xV3FnVFVmUktMOThWbmdXeGh1YXVnSXhkWXFN?=
 =?utf-8?B?aFBiZmxYYUJWUG9lcWcxRXpqMnNuNmd3OFdXZU5oWTcyVm9WS2VncFFzUnlk?=
 =?utf-8?B?ZEt0bWJPdGQ2dzFQVkZTMTZ3VkFmUW1hTFpHb0ErK3lGaERtNWJLMmNZNHhF?=
 =?utf-8?B?c0xFa3ozdEszeUtnVHh4QTYzcXl5SGxwZi9BSkw5OWdjZDlwVm9iK2o0cm1L?=
 =?utf-8?B?a1dVbmhSL3VOVUgrOXRGYXorQnBCZndDS3lCeGF1OHMwOTNTTHN3dDhaUWx5?=
 =?utf-8?B?SktFS1ptbjAxUHFTRXkzd0poU2FYZmIxcUNWSkxrQWxzM1J5cXVkOVJKMDgx?=
 =?utf-8?B?UHh1VnlnTEZxcVB6L09DWXRhVnVHdWNvb3JzWm00cld1Snk3SDRVRzRtTHpq?=
 =?utf-8?B?VFljM0NpYWF4ZmNhaThMRFdYS1ozQXFEd0R3bHFkTzYySWhoMkZ3bUpmZFZz?=
 =?utf-8?B?UFNrNTloNmtiNklaeTRLVzBXZXpXTkh6N0N1eThDRlV4b09LY0l3c09MOGM2?=
 =?utf-8?B?S1RWOEhjVkRHSkN3QnpNYlczQXhHbGxicG1TbXhpQXAwUFQ3RHVUTXo2clp2?=
 =?utf-8?B?cEdPM0JqcExOQzNBN3hPc0QxKy85RnF0dnRkeUpMZ3Zrc25FVkZPZlR4T2Nt?=
 =?utf-8?B?RFRxMVQzSncwY25zcGYvVTB5KzgrR3VyOWVDSDAzNTEya0U1MXM3VVVsMDlk?=
 =?utf-8?B?YWxndndzUDM2Wkp6RzAyV0dHVkRBYnZHU2k2RmxhTDM2TzNnWmpPTlNhcnhC?=
 =?utf-8?B?Rlhjd3BBYWNFejUwRSsyM1pPSHN4TUh2VUgvTVZjbTFkcUE5ZjZXZ2FZaVlh?=
 =?utf-8?B?dU5tcXJxSDNCbXBlRzZGdEthNmMzdGFtclorYzZ5SnhER3RkNVpPNGNYOURh?=
 =?utf-8?B?a01qZFlzeWxROXU3NzQwa3lkMDZPSDZnb1A0STVTbUsrbEpCNnFRRThtVm15?=
 =?utf-8?B?MXE3V09VOWp6djJveDkxdGxkVWNPaWNnRUNxWTdJQ003VTAxVTFoMWlmRk9q?=
 =?utf-8?B?OTBJWUdCbUtZWmt5RlBod2JQTmJLczArTkU3ZDhzLzFtS24xcHBSaXhqSmpQ?=
 =?utf-8?B?VEZyRjl1aVJGd1htekNTRFlVNlZwMmFRWnhZaW5vSTk5MnZTRmlDbDZVNHBS?=
 =?utf-8?B?dURVRXY0aERVNlZ3MU5HczdIRzNhS2s2Vkc3TW5JN3crYWN6bU03MzAyaGND?=
 =?utf-8?B?RlZ3SW1rdTBwVTR3eUJ0TG1NMWI1ekhwdVZnNUg2NCt2VmxUWXl2dWRQazlm?=
 =?utf-8?B?ditvZ1pxNWpnZ1NxZjQwUTIzb1Z2a0J4YWFGdmNvempxSjVIakdDVXBaSUZ1?=
 =?utf-8?B?WCtGQVBITmE5Nm5ZbFBSbGNFRHV2M0ZjK29ab3VPUWx5VUd4ZjlrUHNGOHht?=
 =?utf-8?B?d1N6Skh0YmVrWExKMlRhOG5ENTRUaUpoQVdrUXFmdnU4eEdyc2xKaFMxaFhq?=
 =?utf-8?B?NlBjMTl2S0FlMkdEY2NQcWxrMEVkY3NKc2tSZjNpRm5LdjJZWitTRlBqYzVF?=
 =?utf-8?B?Ri8vTlRpZFZzWDM2U0lEQzBtRmZwWkVOT1d4TnR5bU0vdlFRQUx6akl5TC9J?=
 =?utf-8?B?TE1HZG1Ga0RjUWVjUkt0TDYvS1UyZkhFeU9MWU5aem1YOE9yNGdJbW55MVNl?=
 =?utf-8?B?TjhwMTkvSVRLckQ3bUk1TjgrNDQ2VXFqNmtveVI1cS9kZ0FNOTYvK0ZoTy81?=
 =?utf-8?B?a1R5Q3c0RW00V3UvVlI2czIzWW1KclpFclRlVWZlcDU3b0h5cWZrdER2b2dG?=
 =?utf-8?B?SUJkTSt6aldPdHJYUis1K0VCZ3BkbnM2TFZ6eW5lSWxCQllQTW1JZUd4aWs2?=
 =?utf-8?B?eVU0MHlhcXF6OUlKR0tkWm84UWhuSzZLSnhVZDlHV2dTVHRINlZ1b0E1MVNU?=
 =?utf-8?Q?aXW3Yf442+EK6OhOX0zInArHkdqAmc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9642.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(7416014)(366016)(1800799024)(7053199007)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cm5zMXdQQk0vNk43ZWsvR2VnaVBoUEV5VVMrQkhjUi9UN2xxWEdXK1Ntc1JE?=
 =?utf-8?B?aFZBeWp5MUxEZkVGYW1UWFdaQisrS2t1NTJjSHVuMkh5aG9FVXRGNHIrUXhU?=
 =?utf-8?B?RmNKRzVSQUdlUWdGYVFFWjdSSnZ3R0FSMFBORE9NSHhENC80dXdKbmtWbzZU?=
 =?utf-8?B?cm9Jc29uTUQ5ZjdNTWhCelU1MEVTQU1qMnFYM2tLanFKRk9aWi9yem5ncUdT?=
 =?utf-8?B?MDRiMUNzT2M0UkNENjdYeitVRDVVMmZUMWVCSDdZQTJ0dTZEemZob0RxUExO?=
 =?utf-8?B?b2hKTk0xdlJZOCtQbGc2Y2NGczVESmZ1bGw1VUIwSE1JYmpodm5GSEkzeWZ0?=
 =?utf-8?B?dXViK2FoNXBxcTFmZFJWK2g3YXB5K0U3UW52OHJLNmxTbjB2d0JhOW5lc1dt?=
 =?utf-8?B?UzVDZ1UvK2VNNi9ISFgxOE5sS0pzUUc2L0NKWHRwenZYd3AwbmRMN3lUSHZI?=
 =?utf-8?B?VHlrOTFTWHV2emRiZTlDZmhrYkRibEc4b1B6OFJoRGtNaGNUM2E4YTNZRE9M?=
 =?utf-8?B?OE9xK3hiWWg4M2lXVjRTWmIycXRCVGJUcWp2WmJGaStieGJxZ1pvUkFLQkht?=
 =?utf-8?B?MkpJRHJFcHhDVVd5dFlKSUdMQXp6Q3F6S3crVjAyYzREYWh3RTN5MGtyZ3Mr?=
 =?utf-8?B?TXB4UzFwcFhLdnB2S21KSXcvT29PL090WllFTTJjSDdPV1diS0IyV0NzS1B6?=
 =?utf-8?B?T2dXME9XN1pYUHY2TXJFNThQSnR0UCs0S2FBOFJGcUVBZjhkb1Y2NG41dzZE?=
 =?utf-8?B?MjZBbjU0alNabnZxbWxsWmhpdjB1WHFsYW1FMzNqbXJJRHc3N01LU3Y4R0Z4?=
 =?utf-8?B?d2JIcmJOdE9sZU5mVUVwK3FPamVFT21TQlZ6Zk5jcDdWeUFKYytPTGxLYzkr?=
 =?utf-8?B?akJnQmk3MVlmY2M1RzZZMFRQZUdhM1JGemFtME5DMm1BWitHeXVnY2VjQVlx?=
 =?utf-8?B?NE1sNUFWNnlKZVNQK3F3STBaa3JuZUNTN3UxL3dsZ1F2dHJZaEF4S1lVbGtS?=
 =?utf-8?B?T1Rwa3NEcDVqZU9OdUlSdENSZHFMN0RKcE9Od0ptRDJvRDZUK1NxQzBxQkgz?=
 =?utf-8?B?RzNUOE1SQVFhU0kycUhoaHh5OTg3Rm1VVHF3SWo5S2preWUwMnJNWmpnem1z?=
 =?utf-8?B?OXZlVU5KZW9jZ0h4UzU5T0QrRExkeG1hcFpGRC9odmJ1THJubWdENVFSTjB2?=
 =?utf-8?B?SFNjT0ZqWk1ZTlEzNXF1a2ZYcXp1NVR3U0piTzNJNC84Ry9yZVBTbjU5OFQv?=
 =?utf-8?B?bkZRZ3NmWXlPR2hYOWdsYktmTE5zMmdPNDZwSmFWREM0UVMwWWNCVExCNjRF?=
 =?utf-8?B?ZXZmTnlZb2ZZNSs4aHp4cVBhY2dGY1VlT21Zdm1YWTVjS1lFR2ZLaGp2a2Zw?=
 =?utf-8?B?WWZKL3JJRDVJYkxxM3dzRGE3TzhQd1g0NGVZb0UvMWJFa0FBSkxueUxVZ09s?=
 =?utf-8?B?ZytLQXN2WGRiQ0tuRkZqbG0rVWVKQW8vYUFaZEFTZTJNdUl6TCtyV0xGTFp2?=
 =?utf-8?B?STd0SlRtWlJHeUFqQjFXRFhHSURSTmxvcXM3TGhtNXdLR3l3LzZ2a280WWh0?=
 =?utf-8?B?VEhQTFFJQVhmajdpZXlqSHNITHNib0hqbVo4YS9TbFEveTc5cnFNM25VVTUz?=
 =?utf-8?B?T2hkTmZ2VFNPRG1NamI2bkVHMzhlZjMvd25mMVhrclI4UVh2ZytNZlpja0R5?=
 =?utf-8?B?akcwa3lZcmFkdUZkSFlvUk8xalhoOEtoaWlrVkFZeUNZQ29ueUdNa2J3ai9i?=
 =?utf-8?B?dHdkSEJvamNPeDNMQTQwU3JPTmpsdmNFdEYwWEN2eW1tN2xBYkZURVBPdWli?=
 =?utf-8?B?bjYraTVWQ2xMS3hWc1cvSVlLdmVYWVBPcENQNlRMaWJKMURQai9FK0xjV1pI?=
 =?utf-8?B?TTgzMXpUWG14ZmlqbkxuMVJZYUR6eURmVWc5K2VSY244T0J5Vkc0MXd5YlVv?=
 =?utf-8?B?eSs1MXYwcEZBM2xHTXJFazJhUzB4Qi8zM1k4OVlnQkU0M3AramNXSlFWdzVt?=
 =?utf-8?B?S3lXc2xTZGlpcWpVZkJ0ZFpDY1ZxaXRuaDFIbmxiL3RKQTNOa1ZPOUo5U2xw?=
 =?utf-8?B?Rk1nTE5Fb2NSV3Rmd1RkZUFkbE9PTUMxTUhnRGpxMEFEUEY1MmIxbnNTVDVS?=
 =?utf-8?Q?n3ok=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1552f796-10eb-48d8-9a37-08dd9a0397fa
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9642.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2025 14:10:38.5447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ecTVK09VkK0cYasOia1OC/Y6N0ltf/bSrn/oZ4C3wjHxzRo2qtwAPQxTVu/3NvUZIyV6js5ftv693ZUNE2phg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9086

On Fri, May 23, 2025 at 01:18:32PM +0000, John Ernberg wrote:
> From: Horia Geantă <horia.geanta@nxp.com>
>
> The iMX8QXP and iMX8QM have a CAAM (Cryptographic Acceleration and
> Assurance Module) like many other iMXs.
>
> Add the definitions for it.
>
> Job Rings 0 and 1 are bound to the SECO (Security Controller) ARM core
> and are not exposed outside it. There's no point to define them in the
> bindings as they cannot be used outside the SECO.
>
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> [jernberg: Commit message, fixed dtbs_check warnings, trimmed memory ranges]
> Signed-off-by: John Ernberg <john.ernberg@actia.se>
>
> ---
>
> Imported from NXP tree, trimmed down and fixed the dtbs_check warnings.
> Constrained the ranges to the needed ones.
> Changed the commit message.
> Original here: https://github.com/nxp-imx/linux-imx/commit/699e54b386cb9b53def401798d0a4e646105583d
> ---
>  .../boot/dts/freescale/imx8-ss-security.dtsi  | 38 +++++++++++++++++++
>  arch/arm64/boot/dts/freescale/imx8qm.dtsi     |  1 +
>  arch/arm64/boot/dts/freescale/imx8qxp.dtsi    |  1 +
>  3 files changed, 40 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/freescale/imx8-ss-security.dtsi
>
> diff --git a/arch/arm64/boot/dts/freescale/imx8-ss-security.dtsi b/arch/arm64/boot/dts/freescale/imx8-ss-security.dtsi
> new file mode 100644
> index 000000000000..df04e203e783
> --- /dev/null
> +++ b/arch/arm64/boot/dts/freescale/imx8-ss-security.dtsi
> @@ -0,0 +1,38 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright 2019 NXP
> + */
> +
> +#include <dt-bindings/firmware/imx/rsrc.h>
> +
> +security_subsys: bus@31400000 {
> +	compatible = "simple-bus";
> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +	ranges = <0x31400000 0x0 0x31400000 0x90000>;
> +
> +	crypto: crypto@31400000 {
> +		compatible = "fsl,sec-v4.0";

Need new compatible string like

compatible ="fsl,imx8qm-caam", "fsl,sec-v4.0";

> +		reg = <0x31400000 0x90000>;
> +		interrupts = <GIC_SPI 148 IRQ_TYPE_LEVEL_HIGH>;
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges = <0 0x31400000 0x90000>;
> +		fsl,sec-era = <9>;
> +		power-domains = <&pd IMX_SC_R_CAAM_JR2>;
> +
> +		sec_jr2: jr@30000 {
> +			compatible = "fsl,sec-v4.0-job-ring";

the same here

compatible = "fsl,imx8qm-job-ring", "fsl,sec-v4.0-job-ring";

Frank
> +			reg = <0x30000 0x10000>;
> +			interrupts = <GIC_SPI 453 IRQ_TYPE_LEVEL_HIGH>;
> +			power-domains = <&pd IMX_SC_R_CAAM_JR2>;
> +		};
> +
> +		sec_jr3: jr@40000 {
> +			compatible = "fsl,sec-v4.0-job-ring";
> +			reg = <0x40000 0x10000>;
> +			interrupts = <GIC_SPI 454 IRQ_TYPE_LEVEL_HIGH>;
> +			power-domains = <&pd IMX_SC_R_CAAM_JR3>;
> +		};
> +	};
> +};
> diff --git a/arch/arm64/boot/dts/freescale/imx8qm.dtsi b/arch/arm64/boot/dts/freescale/imx8qm.dtsi
> index 6fa31bc9ece8..6df018643f20 100644
> --- a/arch/arm64/boot/dts/freescale/imx8qm.dtsi
> +++ b/arch/arm64/boot/dts/freescale/imx8qm.dtsi
> @@ -612,6 +612,7 @@ vpu_dsp: dsp@556e8000 {
>  	};
>
>  	/* sorted in register address */
> +	#include "imx8-ss-security.dtsi"
>  	#include "imx8-ss-cm41.dtsi"
>  	#include "imx8-ss-audio.dtsi"
>  	#include "imx8-ss-vpu.dtsi"
> diff --git a/arch/arm64/boot/dts/freescale/imx8qxp.dtsi b/arch/arm64/boot/dts/freescale/imx8qxp.dtsi
> index 05138326f0a5..e140155d65c6 100644
> --- a/arch/arm64/boot/dts/freescale/imx8qxp.dtsi
> +++ b/arch/arm64/boot/dts/freescale/imx8qxp.dtsi
> @@ -321,6 +321,7 @@ map0 {
>  	/* sorted in register address */
>  	#include "imx8-ss-img.dtsi"
>  	#include "imx8-ss-vpu.dtsi"
> +	#include "imx8-ss-security.dtsi"
>  	#include "imx8-ss-cm40.dtsi"
>  	#include "imx8-ss-gpu0.dtsi"
>  	#include "imx8-ss-adma.dtsi"
> --
> 2.49.0
