Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2115.outbound.protection.partner.outlook.cn [139.219.17.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E134E3769;
	Tue, 12 May 2026 06:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.115
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778567099; cv=fail; b=qoLzVxAOEWnlpRXm7xznJx9NQZ7NbWM0VnfIshe44bk+0kJ4aznik0WlZwh7xfvM2bcrXIsDUZaQW/ddC8E8aztKq0V58fRnRLofseVWI5z9qByG03VpEBNJALK8ELA6io40IIoyvtkhzeHbq7OAaAsjuAiPoEGXtGvEyWrwfBY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778567099; c=relaxed/simple;
	bh=RixATQMaVoAvyD7ngRCOERWod5nEdk674R8gr7tdyzo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=paBVHpjXcDTkpm+aZECPmEYh2eLvoL9WaHWApMpJsAYKCaEpp/twhvbuq3/NSysa3+BFruD/T7vWINqmDQNHMVcEMeyzF7JCl4y05auwg1Ip+vcV+o2RR2xze4QzwxkRqv/0OV9Qk285ZutyOawABDsglstV30FpkCgMtpv4qJc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YsWMnQeLFngcyPwcHXBIZ5jRnxSrRE8NxMrpAZ6AGMdiBXa+/CIu8f8Ij5CwizR6S9bljbk7ClWgXPuaDnj967fd1hFw28Ce8lSXa/wN1lIHfaB/C2BPcCjyL19pYdDIpbBAGwL3babX9Ir/HE2AYuiSb/iOlh1wrqxVhq9iuPqoFhH5R/qiNpGiCO+yyYs5IU0G3hjrG9xtlvJj7bIoH3J+o3klACxHFMuPVomLHPjKru6bgpxXaDHWBosn29Az8+YNDb/mDAiKIG4CH1aAdD6w1wWVjE9it8Mm1aKReRzgNFK6XSfy0AfsIrtBzvQv2WTg66kJ2Yf0yXn2dTHMSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QRRwMtPva/0gB84XyqBuivbhFaE7p8iyS9nIs/a5Gj8=;
 b=UHhnmPfqKPMTfHFuZJEoAdhBvZVUzoIyymPun0gbvUYI8/qLW+kfeUnY5SqLFtsqM97Wl5iWQXfcBzL8MANTxqG0b1JPw6rBHsWYaU1SxC0+LdSpJpmVE+WLP0KGOr5GXlJaPbu3MA1IYimhU/RZhFuilYdZGiK8KEPEBHQnP9T+xbB6TOzdwbjDvgns8mncdKjCzEzKIirAHNpeCNXK1ais2vlOkJQuvBDOKsXpoIpC0NmPJwEh4VOseQ/OYxrUKO5svPo5l/VYYsYzTIwDVwiL39HeFeidl+eX9PpXPGBHHPpIxlKLcx2cLqTTHtPKZBe5UiZgkwb1D+ahdMohJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1302.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1b::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Tue, 12 May
 2026 06:24:12 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%6]) with mapi id 15.20.9891.021; Tue, 12 May 2026
 06:24:12 +0000
From: "lianfeng.ouyang" <lianfeng.ouyang@starfivetech.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/2] dt-bindings: Add bindings for StarFive JHB100 SoC trng controller.
Date: Tue, 12 May 2026 14:24:03 +0800
Message-Id: <20260512062404.4540-2-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260512062404.4540-1-lianfeng.ouyang@starfivetech.com>
References: <20260512062404.4540-1-lianfeng.ouyang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SHXPR01CA0007.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:1b::16) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1302:EE_
X-MS-Office365-Filtering-Correlation-Id: dc9b9f03-9ced-43a6-7467-08deafef1522
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|366016|1800799024|18002099003|22082099003|38350700014|56012099003;
X-Microsoft-Antispam-Message-Info:
	x//phTdZCVLZmS+5liEK4vZQV2qjoF1tTqdgZ0iwvTYG5AJ5PZVvryxVIjsxftkGbd+RvBONLuEkFeJ4/2CgRlDM3Iy26KPBHwhVivYtLCHs/3HKHYi6TjLPL9SwucK6b738TfAmNtLYGoQ5iOuZMl6DxnudCnvHjvFc+zedoXNbmNh1gJRwTMf40qZldtk6KFg+GYNTXk/Ds0QaGejUc1T9UzVXZFN3WLrAuol/dOzUuIH8jk/HzrUy+3i1etoCku0DwvsAazdvZIZ3W2hdrCN3N3TUFHYIJJ3Z7DbR9DaVorHTCdSqMjhSe+7D7lSZ8DjYocCDqaGAqXz/JtVRgnlOz7vkncebbu06ofliTQfTWhOBFLq5O+mGxA0vGeT10U+pvMgVVDdyytSBEySePRHk8Iq7l4V+ZYaRhFv0ssAqpU08Z3Ye/PgaPM51dNLicTfM9Oq907jbRMvTH21aeCOT3JGZa1L+bpvWNJDfj4FB9C/BoQGvFVu4Rovm2q3ZB5I9dlME3JzXvLrah0lDUHsElFA+aYIslWpGGJNwtd3xkixhUznAEC5TFeRBCzJO
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(366016)(1800799024)(18002099003)(22082099003)(38350700014)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h+Eo4Im7GZl1ihep1op/HCiaYgETgj9s+ffF5kCi0nUlYX4q0/ZkEzXTAmz0?=
 =?us-ascii?Q?0K/V5u8VHK3/GR9VHYat591zA2P4TT1qJfewCzyCDXgG4gnyS8F5PXOdVqMq?=
 =?us-ascii?Q?o4dAD2fDGiANt2JB0nsU77/pIsY4UvJs+ps1ovVQOAfpYy8/qcYAs0M5t/1P?=
 =?us-ascii?Q?rpgEHnKDKIxhJ8+VDvZPabmrEspYchKoBbdw6WlZx3GYUvJ2TJ/lCAATAEP6?=
 =?us-ascii?Q?DRfFNkWH4x10fAcEEUDHmTKYqVkJOuL4zGrajZO7dv2HppRVKif7NdOCjEZU?=
 =?us-ascii?Q?SqQv5yRC99F97SPNv+lI2ro1+gLyzNjyEp4LojFNTcjWdk7MyaUfiOugVmjq?=
 =?us-ascii?Q?jAFGciI2+9DdWMZl8jCmqfYmdsRTFmE6HXdpd2cGRAUEe8yavD1YrVbDnGte?=
 =?us-ascii?Q?Kd53/Wjdzroz9Q2pOWT0fwwomPOdHk5l0zyQDMqtm/iXSSNj5nr/HcbZutB9?=
 =?us-ascii?Q?k1/FYnQGD7shquXSRmxK3F7/AMNrXYY19OrmUrek3M8TxttKQbS2r34TwhZD?=
 =?us-ascii?Q?t4x3I4ABKxYioBf+vhR0gO0kwknj68oGvr6Y/49SeONWX9xu7RE/RZRWy0qK?=
 =?us-ascii?Q?XOCccoRxZzDjXF4MInG+rzjUOfSSwhtsdR6psi87hunxTG2l3hvUhHT4szT9?=
 =?us-ascii?Q?f4ROWvm4kN+JAnv3aThFUojmkEqmDJCKObNtxE74Ejy9ROb0bu5TFpPb3d9V?=
 =?us-ascii?Q?obZiTB2NzEtQjaRO1iLsjoKm6RTZw2uxscFQH+lOIluGc5cBd5CCi5e/8+AG?=
 =?us-ascii?Q?XFOKsw6j7SJx6sd0HaGAgk9NNn+6MLiqnFvkTX8DclF3O8nEHSlgYHsRFnmG?=
 =?us-ascii?Q?jXfS/7pcAtLPkOli3w52RSEWJhLg3PKnulTfyqvAts0dBUSBt2lEDAPIoVMH?=
 =?us-ascii?Q?tWTD/IUus4VtFOruLGFCKzVtMRZRijPzAb+ycp0ajynGGnPZav8IS+t8oaKu?=
 =?us-ascii?Q?w4fdpn7zx3JQKOjqeGhq+S618CBI1upxMOZsZ5AvbWE6Or8q/o4CZ9XtICKs?=
 =?us-ascii?Q?r/PGiKgf63a+sP4Fq+YJ0fQ9QiFiz7RPD5P8Wb4kpjQiC2oBeg+k9PSoKGB6?=
 =?us-ascii?Q?27AWu8/C2l7Rc423bFT8Q/zwEl+4eUtnmSId9h8DwscX/+IR9gGA5I+OTSau?=
 =?us-ascii?Q?yLsveLbwlFHtYnsRQZlbUvyTm4YatzWWBAiLrBOEzm7BPpgQ+Z2OF8wyni3M?=
 =?us-ascii?Q?q0OYOkUgwwz+Sz7I4vFmQEjb5wWVapKgONcxMWCsnFyKzSV/aGobMmfU7Es7?=
 =?us-ascii?Q?NXvrCn+9I1ujEdiU6/06WOjTNE2J0xMMRRXq84FrpcnmDbpRHfJVg8sSq2dw?=
 =?us-ascii?Q?uhkjqIaL3jrFeMWQaXdzGHVbLqNG53SFiH2D0rRPdZsjyrHznARBbLF60okq?=
 =?us-ascii?Q?sHKbdJxXpd7R9zDfJzcxB/AcW2bJKXkU3KIM1qlKqnV+Gpox2vViS692/ZrQ?=
 =?us-ascii?Q?RzanYqwEVH4Vb1vgc8zSj2UpQatR+rvXVDzgUaE/eugpz26DuFjed9/VG4Kz?=
 =?us-ascii?Q?7w3CvZBRjAQ+6QaA+rdUtGG6rO+Vz/y+6I4AI3pFDLbkcdVhX6nC3sOGNmVJ?=
 =?us-ascii?Q?gWiKQdom3w874VhlgWkFQCMjrS418/LbLK4t+gQ1DMDa2Z8BhM6WGb25fJnm?=
 =?us-ascii?Q?NREZSv1r4YtCBJq9y7DuWdOprdRw2VEJWF09mn4yB+H+otKKQEpvNNyx9W6E?=
 =?us-ascii?Q?D7TE1o8OObv2keokzY2o3GmD9821zvQC3kdBaH6wGxhwl/+pS45bKhsVc7g5?=
 =?us-ascii?Q?UqhS4w7d1Uv7f1qeVEfkwbK1NFy1rcYVN6eVXTw6KC1Csg62DOnL?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc9b9f03-9ced-43a6-7467-08deafef1522
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2026 06:24:12.0979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: trb/VAuxF/38sy+PfESFEyIwT+U3fA1fixgkarjZ6lu4mRMXUMlJWLbNYStYG8Lb9f3FAnnoDZYDd6LsIZetti5fEYj2vheJM0ghkzDWUj3GBSfHg/RL26WmpXdSB75B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1302

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

Signed-off-by: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
---
 Documentation/devicetree/bindings/rng/starfive,jh7110-trng.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/rng/starfive,jh7110-trng.yaml b/Documentation/devicetree/bindings/rng/starfive,jh7110-trng.yaml
index 4639247e9e51..11346d77b2f6 100644
--- a/Documentation/devicetree/bindings/rng/starfive,jh7110-trng.yaml
+++ b/Documentation/devicetree/bindings/rng/starfive,jh7110-trng.yaml
@@ -13,8 +13,8 @@ properties:
   compatible:
     oneOf:
       - items:
-          - const: starfive,jh8100-trng
           - const: starfive,jh7110-trng
+          - const: starfive,jhb100-trng
       - const: starfive,jh7110-trng
 
   reg:
-- 
2.43.0

