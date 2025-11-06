Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013060.outbound.protection.outlook.com [40.107.159.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAD934F265;
	Thu,  6 Nov 2025 19:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762457116; cv=fail; b=JaqJi8DCly+kH01a3cqMCFzKJawOcktfVuO23X0BSiIYtGdL0mIDqzBcWnsFpK8GJheHl5RKUUONrR6xyz6DxGrL7GggsA0OOq53GGFLJczxxEyCTSGABV/3J4mYIkKu/Ya2pVY+ZiryJCjKt8JkRTIPEAubXJetKBzfu7FPF8E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762457116; c=relaxed/simple;
	bh=xr9LqKBoVLfuHXlM7W1KfGhgMs0R1auRFFeXtPwPK8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GNH8bx4TOLE7avTiLbv8QpgZeTot7JEduB7xfRUABa/6s18QWLmYZ99oMs09X80R5+Y7KkYj2xkfCkXXnHIzTjE7KV6vDUbvO3mUzn195FrpwW0HPWc9B7q/K7ztGRfu5aJwDBAMhmVAyrPmlQNxqiueTJbTEqMf/yWHozk5whI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=S3cPsn13; arc=fail smtp.client-ip=40.107.159.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="S3cPsn13"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q9qySICGH/GOjQfK9UIClglP/wSP+BmMZR7sp3ILBQ0zTz03KSBmKyNfc0uMDFg3G2fFDA8jbNVlcNJbiSBPSrPudahvjQv+/HWc6fpsBoXCU4buL7ikv10yHSKpo6GlW2OcbAfU8XIY60D6pOpTW09MlP/DSPS3h1k3XWI+cTulqQKi5lRYBTei6Pj/2CRgDlIYCIFBJth0XkcGaSIv0GZDmbUSgztmezjHLfLVpT6Cek58yDHlz5ILoYOXcPPecExPebFqyD/O5DIr/IvLegMVR2VZssW5WVuEhGzQNvtk5tZEd7/N1rzihhWYuc7cLYVrp4k58xtXa14gThQVTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qhIFThudr+VyNoRDp1KNErZlm0B7ALBfjudKfLqtTbc=;
 b=dceVKQZsaraNVh0hiw2laZXlwh+aFpp3x0fJ5Qdiey9YdCXkTiFCGj+QN7AIfjWJdl1wucLGo335TVK2rf/fpnCTpUP/1tqpOCJbgVrK9Xzq2VuG0nOwaHykOD5HUO9NCcC8PBNTVaAbTjMyTEAm3cEsV0kcbtgAKTqGJzla4lDISSxb3HzpCT7/IiHvsEViabuPnjJ0MgCnaST8n8I49NTJmG6szeUoizS4D+PVeXt0Nj8WzQSyxmx2K5YQ6t1GNhuvAcOhoXbLoeUc3f0LXoCO8mJ3GhXioNRsnUZJbWhXAFuw42vKSuo3Qr8/iMRAqgw/DqV4KN9xvQfIcJW3+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qhIFThudr+VyNoRDp1KNErZlm0B7ALBfjudKfLqtTbc=;
 b=S3cPsn13dpFEzdvIURgkObgw6R+P7dasVae08eGena9s1LDnLieZ+3AySGZgxbV9hKjM4jE01G6+O8lgkiz7+5cjFO9/oq+hEb3+ImxheGOcUSvmdqnk4Pftl6sgezV2ve0nE/CuMQc5JwglW+Gs/ZWS5aH174HEVik06T0u3yJzAtZ9g054TMF/7B0HBXxsoTquyCaDVmAZ4nIcvqzXq+nK88/gZKg/JP6Ccf6tAQu9/xs+3mSICAa/76AZpxhhzAnrxpD+171UgFXZtsTCnu1+5XySN0jHmnIlkUQMJfnzRCu5pQzFWQUOq+9+YBV2vRFE431hROq83gs/DztQ8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXSPRMB0053.eurprd04.prod.outlook.com (2603:10a6:102:23f::21)
 by AM9PR04MB8714.eurprd04.prod.outlook.com (2603:10a6:20b:43d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Thu, 6 Nov
 2025 19:25:09 +0000
Received: from PAXSPRMB0053.eurprd04.prod.outlook.com
 ([fe80::504f:2a06:4579:5f15]) by PAXSPRMB0053.eurprd04.prod.outlook.com
 ([fe80::504f:2a06:4579:5f15%6]) with mapi id 15.20.9298.006; Thu, 6 Nov 2025
 19:25:09 +0000
Date: Thu, 6 Nov 2025 14:25:01 -0500
From: Frank Li <Frank.li@nxp.com>
To: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>, linux-m68k@lists.linux-m68k.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] m68k: coldfire: Add RNG support for MCF54418
Message-ID: <aQz2DZ4fm4BrHytj@lizhi-Precision-Tower-5810>
References: <20251106-m5441x-add-rng-support-v1-1-ee8230910d17@yoseli.org>
 <aQzHO6Ty+l1Bwt6N@lizhi-Precision-Tower-5810>
 <4689159.LvFx2qVVIh@jeanmichel-ms7b89>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4689159.LvFx2qVVIh@jeanmichel-ms7b89>
X-ClientProxiedBy: SJ0PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::27) To PAXSPRMB0053.eurprd04.prod.outlook.com
 (2603:10a6:102:23f::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXSPRMB0053:EE_|AM9PR04MB8714:EE_
X-MS-Office365-Filtering-Correlation-Id: af4a7c41-e120-48d2-e4e6-08de1d6a332a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|52116014|19092799006|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?clErc2lUZWZLaWlSWUxMd2VtOEpseVVQeVJkMllnVUdwUmtvTDhkVFFaWE1z?=
 =?utf-8?B?RlRUVk1FdWZlQVNteWl5NEVKaXFoSVdVZlYzNmFlV3I5UFp4amVjLzUwSkNX?=
 =?utf-8?B?c2RBZXZsNEU4S3pBZmYzK0llVUZUSFlMc2QrWVRyZ0ZnczhnMGE1aVZKdk5v?=
 =?utf-8?B?d24wdDBSMU5pRk9WWDVBWG96ZGVUL2k1M1J6RVV4MS9OYVp6THY0cEVSK1JZ?=
 =?utf-8?B?NUIrcU1pQmRIRWpFMkJPZEdmcFhjTnpTNWVZK0cwU0pqeWFJSUM3bjdqYU9N?=
 =?utf-8?B?TytBZHZ6TS9uU3BKU21qNU5vcXo1cWQ3MFcxNFVaVnpQaGFrMmF2aWlpUDdh?=
 =?utf-8?B?YUlyYlhjdElKRnRvZDBFLzRTY3ZMcVc1S0lqblk2bmx1YllPbk9kOG9rRys5?=
 =?utf-8?B?SnNHQTY1cHZ5cGRyKzZiSC84dEdDQVhnUWhGUzF6bmc3ZUJtZWZWZHFVazJ3?=
 =?utf-8?B?OGJTYzNlaW4zTnlHMnZRZkh6LzErc0IySDNoNFRwSnZxRU5jcHl3N1QxQ3Za?=
 =?utf-8?B?SmY1ZEViUTRvRnYwVzZIVTVZZUJkelA3NVZCOEo3VE9zQ2lpc3pjOTVIR0tX?=
 =?utf-8?B?dWdtcG5WZWE5RGFoeTl0YVZXeEgzaG5BdG1oV3JBOUFnaDlDSGl6dktiTUVU?=
 =?utf-8?B?cTlPWFlkWFl0NjVkcy9aaHp4N0FUNDJ4dkZZTWdoR0RTK2R6SDRVNGd2TUJm?=
 =?utf-8?B?RUwwNTJoN0JOR3JCcEovb2VmcmhFakxobEpDR2d6M2xKazhTQkduV3RDS2d5?=
 =?utf-8?B?RFN2dkozRGNOek5CbkRXODB0UG4yNmNRVDkvSWdkZ29aVnlPUE40Umlib0hj?=
 =?utf-8?B?UGU0c0dqWFpZbm5GUHpSNjRPSUJEYkxOY2lVTlJmcmNyM3hJZXE1WmVDMkVC?=
 =?utf-8?B?WU5rL3VIbVlQeVRNSVN5MGZoVUNBRGkxZE11amhjWlNNZWxST1ptYUlSdEFH?=
 =?utf-8?B?T01IUVN0Q2xCQTJ5ejJWc1BCWUJzL3oxOHpITENkZksvb2ptakJ6VXZGUE9L?=
 =?utf-8?B?NnZvWGRBdU16ekJEd01jT25BM09sbyszUnRXaTVVZGN1M0FEam1FREZqby9m?=
 =?utf-8?B?L3FkRlJGazRDdk9ZRERrT1lIM1lMOUM1Tk8wSE5IdjlJSk4xOGowdDN1TnJR?=
 =?utf-8?B?Vjg4MCtHOEk0TC9JZkRpdnFCQ1pHRURxQ09qYU9yMGdROThqdFB6WlQwdkhn?=
 =?utf-8?B?bm1ZVTQvdXZJaE9UZmM2Vm80VElvVjFhQW9PdGFkZGpmeS82b3dNSmVBTWVG?=
 =?utf-8?B?a3MvTjdsZXFtZytOdVhucTVqc1pyS1RVdzNqWmw5cmRKUmJGanRMREw4R0dM?=
 =?utf-8?B?eDM1TjcvNG5jcVJlUWJIZUJVcW1MdzI0Q1A2SUduYWFVQ1Vxd1hGSHgrT2ZT?=
 =?utf-8?B?bnlpdHNQV2JFdm84ZVl5UFNaYkRCR2lCaWlRV0djakE4RXcvT2loZzVmdlNs?=
 =?utf-8?B?UnBCb2hzTUppTnd0VzlLSjdROVVOTm55eDdzQXVJaGhjREN6WHd6cTNwdTZn?=
 =?utf-8?B?Z3JpMTFzaFY3MThuNkdWUlJROFFlQlVhOE9tdkZHaWd0NklNWHl6TkhaRHY2?=
 =?utf-8?B?UjI1WDlPL3hKWFl0d3U4eDA5Zm8yNzZzQitsaTZ2UVFTQnFRUGsvb2x5M1RK?=
 =?utf-8?B?WGdUaUxhQmg0WUtPajBPRHdReGoxKzJ1b3k1RUp2aUR6bmJFVTV6Nitmak9P?=
 =?utf-8?B?SU4veFM0WEpkUTVaQVV4MExPODBmT3BHdzEzTWNRZVBLZEFBM3BjTGhiUTJF?=
 =?utf-8?B?eldBNFU2SVZFQ0I2TWZ6WWVSSTk1aklJcVRUbldXeXBqdG4wRzVLcFlGRFBC?=
 =?utf-8?B?T2kzTXNJcmNxUlFYeXR4NkxZTVJaOTkxcEtVTDNOWEI0R0hqdkNMeEVJOXlI?=
 =?utf-8?B?eDc0Vm1PU2ZQQkxBMGxLRDY2NjhIaEdjTXhoUGI3eWlHVzNGTk9kdWR3V1RI?=
 =?utf-8?B?eTA5S1c1Wkp2WlNiand4T2NWYkRrNzVlMWJJV3BHUFpFeVhleUgrSHhXb3dm?=
 =?utf-8?B?d1BmRWFQQlNtV0dUcXVmdzZVN1NFcWxSTnpoUUROTkt2VjJDR1M0YWR6OFd5?=
 =?utf-8?Q?XPIJY9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXSPRMB0053.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(52116014)(19092799006)(38350700014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bW53S3JJVmJaTVArRzl3T2lhZUY2UzlDbTlmUUxKeDc0d1NYV1V3VXJyV3h1?=
 =?utf-8?B?YW1BVzdQNXNtVnZKMlVvbXp6R0FIMFlNM3crazlzZEYyTFFid2ptWStXMnhM?=
 =?utf-8?B?UUNad2Qzbm9Ndnoxd3Z4Vk85T3JhWWpXWGgxU0Y5VFpxb09SUmpXdW9LczI4?=
 =?utf-8?B?V0xMTmhxSlJ3M1Z2QmVkNXd0L2N6Skt4d3RhVit6U2tlakp6elZ5M1lzWVhM?=
 =?utf-8?B?bE9SRG5lV0hyenhmRkZzSGo0RlZQd3doM1dCRTlRTWtNVXZhRGZiL3NkYVBG?=
 =?utf-8?B?VHA1b0FCUk1VYXQwc202cnpRV2RPWCsxRXp2cTFtNG4vU1FtZHA2d0NhcERj?=
 =?utf-8?B?OWsxQWJTUnNpSnNVUkhVL09INHJocm9WUlpBa0drUkh2MEl5RWJscnJtb295?=
 =?utf-8?B?SWRMaE5NWmdkNWNZTm02YjNYVkNGZTd3YlVOcE9Sb1l3TmMvTjM1NGc5b1Ux?=
 =?utf-8?B?OGcvcW9xS2VKK3JsSm1UWmdmRit6YjJqTHdxbkhxakJsZFhZM09Pa3BiN25i?=
 =?utf-8?B?OVFpb1J6Q3pEU0lSelBmOGd1WXpvbmJ1bURCclNpeTJ1V0Rta2pVTlVON1hu?=
 =?utf-8?B?RFhKcDRzdjNmL00yT2d5Ti9uaUFwK0pHQkZ0SnNENDh1a1NvNGhyejRDQVBO?=
 =?utf-8?B?dGZHZHprZEZBZjZ6QjNjK1ZvS1NjTE1tQThuSC8vdmdHWGRiV2NicTRRT3hq?=
 =?utf-8?B?Q3Ftenl5b1ZoY1lnNndaMFJJNjkyUmh1MHV3L1ZkbHVaRHhlbkYya3g2QXFU?=
 =?utf-8?B?WExMUndydVoycGdzMFRVeUpmSWkyWlRxbE5TeitWdmMrempCN0JScTNYRXJX?=
 =?utf-8?B?ZzAzSWxpRW5aVHA1N1pOdGkwOGNNazFaTkg0VVR0VVhTRXVYWjg1ZVBVblJk?=
 =?utf-8?B?dHZTdFdlZUhrYXV4ZDFVb0ZyUU1IT2RuRnlSRm1PUkZTeVo2QmFFeWlScUhy?=
 =?utf-8?B?ZTlwZ0tXL2NRcGc4czYzUUxSVU9rc0ExdGd1R3F1UzRyOWZjcjBmVjlwQ3pG?=
 =?utf-8?B?VmtBaGliQzNpTG5HaVRyeFdBL3dLUkI4cjFkL01ZVDRGckZXYTljajVmWk5D?=
 =?utf-8?B?SmgzT1VFai8wdmR1TllkQjVKaE1qRmJnRWw5MEQ3Q0w0SW9FdUtpZ0tGcFdi?=
 =?utf-8?B?RXRpK3NaTTRuN1ErRjJqQmxoc3REVjJrbjFkVDFOcmF3RHZQSTlma2dlWGVm?=
 =?utf-8?B?MHNRMWNqY05ER01MZkJWNlNEYnQrNlZXY2VGdG1MTU9YWHQ2Z21zQ0tocnV2?=
 =?utf-8?B?cUcxWGxuNHo4eExJbFNlc0JoTlE5YU53ZFRXaGdNZXdkczNnaCs2alNFTUI2?=
 =?utf-8?B?UDlaYUtYYWdRTGlkeDcrUDZVMjVJWnFnWXovVG5xTnNtc1hLbmVQK2JVMXNV?=
 =?utf-8?B?cUhraklxcXgydnBHV1FWS1F1T1RydHlMTVk5TXFvMXU2UkpkWDRoTFZmU2RW?=
 =?utf-8?B?YnQyRWcvc25vSjdZZVNQY0pxRG92eGN4NWMrQTdUM1cyWHJEQjJhWHNkK2JL?=
 =?utf-8?B?N2RIMDYwdlNsYlhCV2pDTlhaNFVEOFZlOWV1eTFUMG5VVnNBRis0UFdCZmpi?=
 =?utf-8?B?VFBtYm9XL2kycUp0YmFJVC9iWVZBOXMzYityc1ZQMHhteE1lRkNDTXdZdmJS?=
 =?utf-8?B?eWRWc3NMOHRZOWJ4d05iOGkwUU5EeFBSWHVta0dvNzlEMVVWbFFISEJBUmpT?=
 =?utf-8?B?cnJ5ZURHQ1o2UGQ0d0JPSWlDbHUraUYxdngzdUIrNE1ycmpGNTNsQlE1RDBn?=
 =?utf-8?B?RFNCN0R2RjF0WHZuL0Z6dkQ3V0dxNjlKbzZvdTgybVdBZlBEcGxhc3VNNXZ3?=
 =?utf-8?B?UGJiVnI0NkFENjlpNkJYSGUyWFU4SmFnRGpCQ3RibFhlSm9lb1BVUWYyVWNQ?=
 =?utf-8?B?YmZNdFkzWHEzeWFtdUdxQWdhZFkzZWRzcnZSU3NOUGFEZTRiN3kwc2ZldU5J?=
 =?utf-8?B?QytlZkpmMzhWT2FIeFNkUGZnWTFDRkZuVm9vZ2ZmWWVOZ2lBOXE2d0kvVW9G?=
 =?utf-8?B?T1VUaDNVbGhUd1d4K3ZMWWJscm5yQUZtMFh0eWZqV2FmQUJKYUFQdjZjU3JS?=
 =?utf-8?B?NWxZL1dFN2k4OEZGZG5ic01wM3VKTWpLMmk3ampKZjdGNENDQnUzS3VQK2g1?=
 =?utf-8?Q?qlY0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af4a7c41-e120-48d2-e4e6-08de1d6a332a
X-MS-Exchange-CrossTenant-AuthSource: PAXSPRMB0053.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 19:25:09.7416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vfw0Fp83+MkjBV9n0AR2Js2oUq8o9Rm9F35/Ep5P7sKQ4ocVwJ9EL7kmxTFHXTlq/LYxq2ORTmvk709qNZ5Btw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8714

On Thu, Nov 06, 2025 at 07:16:17PM +0100, Jean-Michel Hautbois wrote:
> Hi Frank,
>
> Le jeudi 6 novembre 2025, 17:05:15 heure normale d’Europe centrale Frank Li a
> écrit :
> > On Thu, Nov 06, 2025 at 08:10:08AM +0100, Jean-Michel Hautbois wrote:
> > > Add platform device support for the MCF54418 RNGB hardware with clock
> > > enabled at platform initialization.
> > >
> > > The imx-rngc driver now uses devm_clk_get_optional() to support both
> > > Coldfire (always-on clock) and i.MX platforms (managed clock).
> > >
> > > Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
> > > ---
> > >
> > >  arch/m68k/coldfire/device.c       | 28 ++++++++++++++++++++++++++++
> > >  arch/m68k/coldfire/m5441x.c       |  2 +-
> > >  arch/m68k/include/asm/m5441xsim.h |  9 +++++++++
> > >  drivers/char/hw_random/Kconfig    |  3 ++-
> > >  drivers/char/hw_random/imx-rngc.c |  9 ++++++++-
> > >  5 files changed, 48 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/arch/m68k/coldfire/device.c b/arch/m68k/coldfire/device.c
> > > index
> > > b6958ec2a220cf91a78a14fc7fa18749451412f7..9d8f844e319a98f0afb79cceb544c2d
> > > 3029482a4 100644 --- a/arch/m68k/coldfire/device.c
> > > +++ b/arch/m68k/coldfire/device.c
> > > @@ -622,6 +622,31 @@ static struct platform_device mcf_flexcan0 = {
> > >
> > >  };
> > >  #endif /* MCFFLEXCAN_SIZE */
> > >
> > > +#ifdef MCF_RNG_BASE
> > > +/*
> > > + * Random Number Generator (RNG) - only on MCF54418
> > > + */
> > > +static struct resource mcf_rng_resource[] = {
> >
> > const?
>
> Why not, but I wanted to be consistent with all the other structures in this
> file.

You can add new patch before this one, which just add const.

Frank
>
> JM
>
> > Frank
> >
> > > +	{
> > > +		.start = MCF_RNG_BASE,
> > > +		.end   = MCF_RNG_BASE + MCF_RNG_SIZE - 1,
> > > +		.flags = IORESOURCE_MEM,
> > > +	},
> > > +	{
> > > +		.start = MCF_IRQ_RNG,
> > > +		.end   = MCF_IRQ_RNG,
> > > +		.flags = IORESOURCE_IRQ,
> > > +	},
> > > +};
> >
> > ...
>
>
>
>
