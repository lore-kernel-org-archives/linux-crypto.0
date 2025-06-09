Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013060.outbound.protection.outlook.com [40.107.162.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509AF1E51FE;
	Mon,  9 Jun 2025 09:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749461968; cv=fail; b=ZXEoVqF64IhJyJgiakv6n45CHAsG0+jqeTB2tsJJacEM68PgWTTyXO6RV+KPY0CHrOcccX+RkABbauJz2b0J/sAEAEBKYSILBYPMgeokAqDmXWN7HkhmeiN/Nk+LldVSR2vyTQ2Ofu9Hmhhc1x83j6+ePPPs+abdF4D4b5A5PoM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749461968; c=relaxed/simple;
	bh=G3JwZNnTciHdU432jLcNs1LX8pCNIV5mrthb0k8xEaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Gcjbzg7BgVfxlRK1nOqY6ruug+dCeMjfBxF19ZpWx9I4GYYrLNIPY0J9UWJhH7TuVrvuPUnzMojp89vYx3SOzV5EKeRW6crEz6ZR6WCN4MBWQuPceJFApxSM82L5LbjStOYvs8ft8EWbbUbh7LFKtO1vtVt7jRnQUcdCdWMR58A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=JwnDlHGx; arc=fail smtp.client-ip=40.107.162.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="JwnDlHGx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=elr5d51BKpvu15JDo0BsnYBJ72gw7Gd+8WPpMi8bgemQMhBh2IOx0PeNpbgxXnLD3w4EGfkCt7MZZVj5IKcJ7YgPRqf/KgowscsYJaYoC+ukaqx8c2xQrNTn7qd/u1WCYvUlTvVeFylp0tGWLHhF2wjUMTHooR4caeNjwbLc1c4VnBPtRPBQ1xzhW0l+J7O4ZQCnob9NEJHtS3aCxZXJlMaA91mu+xiCwjNv7f5ZGvYP5LwGHZWQLYfRoKkmzfnuuzIOZ6GC7HQz3rnKf2GuWk10vR1u4TWYGv/YY+t884LKZQwS17wYDUtC2rqDAfPixiyEgfeAdI4DnJyPAazMLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G3JwZNnTciHdU432jLcNs1LX8pCNIV5mrthb0k8xEaY=;
 b=SS5Tud0KZfvz5vthJHAsYXYMJTDsH4NSrgWNU/nTK18UVlKtsit/f8H9uPi0SKzQxtjxxD7kJBl7wDxFANf7OskHb39TsdLVzXnVbUayIOJ8MJA/ZW4VOH9zzJYiZsmK1zYGxGBcCTjfTjxOu43657P2KZQPZ5INPu3egtOAXPPbwkTxpGmdXq8Jd0VPkRRMezo7evkkxo9/u8kBMwboJzxj4ZLg0Lt3VKoLlRZY1yJLZ27Ku7bCP9+rjA/aqkR+UsxuP+hvlutHjjUEaxPjRgFD5kwBty4wD8yThHfJnOK3gHPGLwFXVGF/YvA2zj4a0BRoCHsyvmYeqKvk+9fY9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G3JwZNnTciHdU432jLcNs1LX8pCNIV5mrthb0k8xEaY=;
 b=JwnDlHGxg9cmiNfAMOC1QID7EAVGrgJabaZHUHwjp+6kb1WMQ1Mat+nqCptHIpELa8otPe3WyE0KuzBGAhhb61csdFWk6n33NnTqimruRBJ8rmPFfBy8IPLbAORkfJ/TNroPoPzaW7bPN8L2dILYsbDH6eXQDsIyUiHLa1AZIMUgjSTxjPOVKGf72cYr4DuqtioqZ8Nw+cSB35w+n8PuaeNq+fmTLns5b2GXRZ3At+BtJoP03TjL8Qqr5FgfAmWWR4IZJMT/o6grjNoueIhS5wAZRNfjThJ50BH6zPLAUzTGk6SLe0ui5/GFCDqrj2TXsJg0OfVSU1S5gNDWIo8a/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from PAXPR04MB8459.eurprd04.prod.outlook.com (2603:10a6:102:1da::15)
 by AS8PR04MB7736.eurprd04.prod.outlook.com (2603:10a6:20b:2af::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.27; Mon, 9 Jun
 2025 09:39:22 +0000
Received: from PAXPR04MB8459.eurprd04.prod.outlook.com
 ([fe80::165a:30a2:5835:9630]) by PAXPR04MB8459.eurprd04.prod.outlook.com
 ([fe80::165a:30a2:5835:9630%3]) with mapi id 15.20.8813.024; Mon, 9 Jun 2025
 09:39:22 +0000
Date: Mon, 9 Jun 2025 18:49:27 +0800
From: Peng Fan <peng.fan@oss.nxp.com>
To: John Ernberg <john.ernberg@actia.se>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>, Frank Li <Frank.li@nxp.com>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"imx@lists.linux.dev" <imx@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 4/4] arm64: dts: freescale: imx8qxp/imx8qm: Add CAAM
 support
Message-ID: <20250609104927.GR13113@nxa18884-linux>
References: <20250605132754.1771368-1-john.ernberg@actia.se>
 <20250605132754.1771368-5-john.ernberg@actia.se>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250605132754.1771368-5-john.ernberg@actia.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: SG2PR02CA0006.apcprd02.prod.outlook.com
 (2603:1096:3:17::18) To PAXPR04MB8459.eurprd04.prod.outlook.com
 (2603:10a6:102:1da::15)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB8459:EE_|AS8PR04MB7736:EE_
X-MS-Office365-Filtering-Correlation-Id: 6af749f9-6846-45a7-4ab0-08dda7398397
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|52116014|376014|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SmhUZXZPbHJpWkVyUmZiSFVwbmFNb05iQTdpalFDMmRNQlEwbFVYUDl0N1lt?=
 =?utf-8?B?UExVRzJHbEkweFovcXNBQ3pJYklGN2poSnhVc2dzTVRsMkVZOUlJNmVvVkI3?=
 =?utf-8?B?SzIzazh5VGtVRnpyY3QwRWxnZUU4NlFxQmxYNTE0Z0xaTW1EUEdvVmlhMEgr?=
 =?utf-8?B?dDdyUVdST081WDhQa2dIbDdxVXhzVkltNE4xRE0vOGVFR25kSkZrbkNsR2dV?=
 =?utf-8?B?ckU1M2Z2d0pEWWdzd3h3bE1RZUltMlJvTnFobGxOL0VkOXNvKzZvODBPVWk5?=
 =?utf-8?B?ZHN1cVF5N1c4V3M2M0Job040Nm16MDNxbzNrZVhJdWdIVmRORFhuYmNJdmd1?=
 =?utf-8?B?b0U4L2NMRlAxajllU2ZyN2d5b2I1QzNCUWJTZXhhaDQyQkJEQ1hiek5Pd3Vt?=
 =?utf-8?B?UVFDdGxrQW95dGFtRkFJMk1KamJlc2w2MkZ2ZFdtRm1WRHpOd0J3emtISUtj?=
 =?utf-8?B?bjVHSkk0dFJSSC9ZaGpqTVI2UW1uOWwvaFVIRnptZFZKUm95NjQ4NnNCUkdw?=
 =?utf-8?B?YXB0aE1Va0t5anVmOFAxaDF1MWVpdXEwSEZiVzduVTB1Sy9vUVo3eWJESkhl?=
 =?utf-8?B?YmFTTlY3YmdzUUJPR0taVExJYkczNzN4U0FSUjdWOUtFM24rSEFBZ1cwYis0?=
 =?utf-8?B?cGVwSTFSU0FzN3V4ckpEVU1aaVpEaTFsM3owNWdWTjFpeVBHOFJQUER2S1E3?=
 =?utf-8?B?Ui8rOXQwQm16OE1NakYvSlJzaVdDTS92MnE2MnJuK2REQzdMRDB4eUhlcGNY?=
 =?utf-8?B?Mm9OeDAvYW55Z1IxeWo5ZjY3bFI3ZTlnak1BelhUdkx3bitFVTBKaTdmaEFZ?=
 =?utf-8?B?cnZBS3lhcDRxeHBzNkF3VWt0Ukd1N0xpMldNTmErM0ZNS0IvQlJVSTdZTUhU?=
 =?utf-8?B?dkRlNUx0bmJFVVhGaTBxTkdRMGFCc2JMVXF4d0lzblZpWjRWc2d3Tlo1cHBW?=
 =?utf-8?B?NEtwOGkvd1NZVVl4WjBxQlQvKzYrc0dhL0diQU5IRUZ1T1g3OExEL3lhQ0Rz?=
 =?utf-8?B?R2xFck9VUDNOQU5rL1lOVTFvWlhWZ1ZONUZnSlA1ZVMzd0swczBUbG95N2pY?=
 =?utf-8?B?Q2ViWXdmQW5vRlFwc2hlMVNJNVhMRzBWTVBBMFk1ZTkyVnNrVm9Gc3ovVDlS?=
 =?utf-8?B?MVdpRHVTVlM3SW9aMTk1elBKZUFwM0tKMVhrdXlheHFGWnpHMlhXekVtM0or?=
 =?utf-8?B?WlNaY3lmYW92SGRHMm10U1BiYjdaWXRKdDhyZXpGbGFzWnQzajMzT0hkVHU1?=
 =?utf-8?B?MUZKSXBlbkZSUE81ZDc3elF2S1ZSNnd4b2EreGp3UDRhSXRHVHBXQmZ5dk5X?=
 =?utf-8?B?MGl0WmFmVWFYWWNvY2IvaGV4VS9XcXpTcUpDT2MzNWxPOUt6Q3ZtMklnYnRv?=
 =?utf-8?B?bWlIQU4vZE8zM3dKRzF5Z3NIVDl5YU8rVGxlYUtqTTk3cjB5V2V4eXlGMjVQ?=
 =?utf-8?B?RWg3QkI5MDJkb01hd05kSGVKRHZkSG45UHNMcGR4K1BoYU9ZVElSc2UvajB0?=
 =?utf-8?B?a3o2ZGY4dnQyUDJxTEFTT0ZlRXJ0N2pCOXhXK0hiS0xQVHh5SEkreE84eXlR?=
 =?utf-8?B?WnpVU1lFOU1RVm5nQm5ZVENucWRTQjJRWXl1TndJdENXNjZxcitxcFh0aklW?=
 =?utf-8?B?M21DcGZkdXF2UVdrMWlmaEZ1VnFra3Rmb2pGeGlHUGhYYncrMEhic3ZiZVlz?=
 =?utf-8?B?L2NkNjExb0IrdDAzb0xRUjFrdU5NMUZGbTRhQXBFcHRjODBxajdSZ1BjZm01?=
 =?utf-8?B?dkxCZTNsZEdnc2RHNTF2cGd2bUFkTUlwa3BkaEVPVDIvUmFMZktwZk1XeTAv?=
 =?utf-8?B?b0VqcS9La0p0THREUXV4ODRRYi95KzhHKzhQV2JsdnBuRzlZSlk1Kzl3cEdT?=
 =?utf-8?B?SFo3N0RiOUx6WFBSV0lNazlXVlI3YkxySm9pM2RYYk14ZDVVSEZXSjRIUGwx?=
 =?utf-8?B?dlk1a0cvRFBJSG9iZURUWHREb3ZrYmJaOTVwZEx0MFRjMzJnWmJVb1lGK2M0?=
 =?utf-8?B?a2lBWmFRdm9RPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB8459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(52116014)(376014)(38350700014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZEdqaEMvRVU1RFRuaTJWcDVtekVtcW42blgvdnpDT2QyREZWQkZVMFNJcFE3?=
 =?utf-8?B?QTQ4bGpZUkI5V0taRENTc3d4REJTTGpJZFB6Szd2Wi8xN0N3YVlvYW41N2FP?=
 =?utf-8?B?N0FNTmx1M3FvenoxYkdybm1lemM3Z1RNWm53MnMvbjh6VDVFVnBFVlBKN1NN?=
 =?utf-8?B?bmhZWGZwNm1VYm53R25pVS90aWhJNkZVdnFjVFVlcXg2YVM0RUpid0ttYWJR?=
 =?utf-8?B?cXlSMnpQWndzbzJscFJ2WHVlTzEwcFQ5MXVjZERpMXE5dTBGRVNhZXkvNGlu?=
 =?utf-8?B?eFNGUFU2YlcxSUxjY0VNSWIraWV3SUxTNGE5aWdpRVFLREFNa1RrS1pSZUVG?=
 =?utf-8?B?amdVczNMVHBCbnM4M3F2dVMzRzV3Mkt2RzJRcnZFOUFFZ2pZcWhUTGhzWUNM?=
 =?utf-8?B?ZTBPL2FGcjdtUGl5NjBJL0hUQVk1Z2xrVWJJTEZQVGJvdUJLOVUzcDR4bUw3?=
 =?utf-8?B?Rml1amhaT3dzY2xaUVdiV2cyeTNPcitmYWd0bURHdzVsd0FudmNESnU1QWZv?=
 =?utf-8?B?Yy93YjNQUlNrcG0wUWw0RFZ0TTAzMDlkbFY0L1NURmQ3blBlY2VTbzdEeE14?=
 =?utf-8?B?dlNGT3N3RCtiWko0NUczaDk2cG5QRUxhd01sOHd2TGRnbUprSmkrZ0dJTHBZ?=
 =?utf-8?B?c1BRb2g4N2hEU0s1UXlZUFU2R2dNdmZ5c0pENDc1NnVWV1JVcjN5dEVqZTkw?=
 =?utf-8?B?dTBsQkp4RHluMmtMYWd4dk9IcU5yNUNNN1Q1aXFWSTY3VS95STJnMEhFZ09j?=
 =?utf-8?B?M3ljdGlFelFMVEFKYVJ3dWZMUThwdmhJYk9oQmo2SGxiSWlDdUI2K2ZHOEQ1?=
 =?utf-8?B?R25RYTFKUFpkRUlrL1VtNGhKd2gzVG5jelFTbjhqeXl2UXdMaUtKOGFreUNU?=
 =?utf-8?B?ZlFIZUlaNzRNc2tpaDVncVZxVU9jWitETVpyVVVVMXB1dDhxK21aS1hhWjFX?=
 =?utf-8?B?d1d0S0J6OExyNFVWRTVJYTRtaVF3YjBPQ3YzTncvMnFIb0xoS3pwWDZLUUJq?=
 =?utf-8?B?WmtSTWUyQUpnOGgwZGtsRDVDN3cxOHAweHA4cHQrN3diNFRZZEZEZm1TTlBG?=
 =?utf-8?B?UmNiOTY1TDlUcWRpVk9hUU16cmkySHphQk0xcUtObUZxZUpnVk5Rd2lNNkMx?=
 =?utf-8?B?WmcvK3VxcGFWWFF1VFFoQkd0ai9WWWJJcG1OSW1qTURtZmoyTk1EMlNaZlMy?=
 =?utf-8?B?QWs1WWdVeWFHaWk2TWI4RHlaa0xTUXk0N0ZLUGJtSlV3YWU0cGpLUW40UGpV?=
 =?utf-8?B?Z0VnSDEwNngwa1V2OUJYT3FlMHZEb0dlS3UvbmZ5aWhHOFVrMStoRlRjUFJS?=
 =?utf-8?B?VVBpU1IxUmRUUFBNMnpRUjcyU3VxYkJDU085K0RTZzhGT21Ld0Y1bmxOZVFo?=
 =?utf-8?B?c1BrTFF0ZXhWMGNsZ1B4U3RJN2I5T2txWmRZVGp4SWlrMzIrU3NOK1BsQzlj?=
 =?utf-8?B?Sm9OVUNWNUJEVlFzbjNUMFFzcHQ1QjdNL3NpdjlKdmhqOWwrcEV6ck1VeldP?=
 =?utf-8?B?SXhRajUwREgxSXFXcS85S0R1cDNqd05pVDEreDJqZm9HenV2NmdIdzVCNnVI?=
 =?utf-8?B?clcwcXJTbGxrL09Ca2loV2VzbmszaTIzZG5JSXduRDUvVGNpei9KczhXM2Uw?=
 =?utf-8?B?YmNOQ240VXNVYmw5RmQ4NG5mRXQvNDRSNExNY05NSGVabC9ZMHpRcWdCbXZX?=
 =?utf-8?B?M1BYUW1FRGFyKzluSFozUEFHWVE5RUJNUDIzSHR5TkRXTG8wVjZoVUJEOEdn?=
 =?utf-8?B?UGpST2k1MVNtb3hheWhnMkZjQkt6V2dlN2NWSXltYnBZcGtBdkkyUmJRMjZm?=
 =?utf-8?B?dFEzb1Q0ZWdJNmdXWGZ4ckVRb0JSS0VOckRiN3ZxcmdFSXZPZzZWRUVJdG1X?=
 =?utf-8?B?ZHp1QU9Ob0lCQlI1OGZCMEE0NzQwWFBXK3JBVEsrSnZSaU1lNjZmWHp2bUNE?=
 =?utf-8?B?ek9DTHc2b3lXMlpka1c2L2tkRU5KaHplZEVNZ2RnY0d1eGlaZklPejFxK3Nu?=
 =?utf-8?B?QU40REUvQkpqMGNqL1dBOTVVbmE3Q0I1UnE5WVNMR3Fsa3dGUlFQUkQxWEVt?=
 =?utf-8?B?Lytkanl5RDZMSUJRckY0dkRrMFZWdDFleFV2bkorOUxFLzg4NXloSTlxdTlB?=
 =?utf-8?Q?tfgBX46PSVDRhzPfPgfT/6Xdz?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6af749f9-6846-45a7-4ab0-08dda7398397
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 09:39:22.0896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZXgi2Q2Rc/SwnTdTfIPP056kMEJlFWeBNb9CgWKKcogj3E97mpIg6+sMgAasrNBszxB+dGOpkeFa1Wld5bwM8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7736

On Thu, Jun 05, 2025 at 01:28:02PM +0000, John Ernberg wrote:
>From: Horia Geantă <horia.geanta@nxp.com>
>
>The iMX8QXP and iMX8QM have a CAAM (Cryptographic Acceleration and
>Assurance Module) like many other iMXs.
>
>Add the definitions for it.
>
>Job Rings 0 and 1 are bound to the SECO (Security Controller) ARM core
>and are not exposed outside it. There's no point to define them in the
>bindings as they cannot be used outside the SECO.
>
>Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
>Signed-off-by: John Ernberg <john.ernberg@actia.se>
>

Reviewed-by: Peng Fan <peng.fan@nxp.com>
