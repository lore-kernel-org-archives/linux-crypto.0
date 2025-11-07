Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013004.outbound.protection.outlook.com [40.107.159.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A5B225788;
	Fri,  7 Nov 2025 16:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762531357; cv=fail; b=DPVF19nHBYJ+8SghmS20yzoOb776MPmlBxv1waPWFmnZJdH1o4k0P0jKI7LdiIDynR3/dHeGykAZKy5qg4T0jOQadYZMD4oPWdAaloqgdE6avMNrPk8hDEqIkN+nKAtjIBsyzvBSnr6BDSPq2cmuxOnSLpwedR4oliRFH+hAtZs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762531357; c=relaxed/simple;
	bh=9x72Za0ndo18cfYHW5fNgB7VjudwwzqgDLinXFo6OgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eENfWypdZnSZUEoYxrJI+gNRDuse56gB7e9t0dn2g6WpkGoPd4f65VGPoz9C4a7c94JrNcQc4IzYK5K76v+2jS/j1oVLW2HfB+grA3P8280wPUPftUZVyuWljcy209+WfD+zUHbHnngUVyyVVg8MlucSqIhHpsoo74OLMW1Yaj0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=EvA3T1/C; arc=fail smtp.client-ip=40.107.159.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="EvA3T1/C"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BxjKE97SGA91BT2dVJeQHWIXA8DIImR4ASM8JSpRWziZV9okWgaNItrJ1C/nH7vfjfp0bt7zKEk4I7DldysbmzyCDRVWCMukifBBKOFWjM1duNBnDZAyLrV49RAh5lZMohoa4P58jmetU0cKsgMZUr+8eHdGu3UuVaIlZksU6edUj8uV+ZfP1irVqqdph4NG/5xjHM3afBqxPWhut1k29lamsQ3n9fC3NTGaCvscCfRNLF2orjWhpqmtVGb20flU4oQV+0rBht1oOU7ViPO+P1XtClN0mH64uaoNxBKB3l9AZ6MXB9JPK/8oAC1dejuItySsQFZuwiy5YZPcYuuqPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MJ18My2alBhXqtZVc0vbD2+OYHZaPEX9MyaEHvMAACs=;
 b=NYPSUQq8TxUelgtU3yaPdPOBSK9CNIdTH6jKBOpS+8W/pA7Go7qjh26V+KAKwz98xwuW50idUzxXEFXaKUcmt16bNZC3TKPKxuPQtwuiySrKJkmek21UDH7YteSR6N8PAc3Ps5ewKkbQ0Tbq33B9N+Y8c6zy586pjyNCtwTxLVo7UdKB/F9bIfTHnChQh69nO9Gtoat3GCksGwJVU4OQqYIMfP/FVuugSJe5TDwZ+y0TCSxPSW7AvLt4V0o+x3ZlIKtWxViS32azSuI75k1s2see5ZQMifu0A2DYABHD6lw0nLFYTYx8cMZ6HUmoISsFk8H9H+V7VyZgI4K08bJ3Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJ18My2alBhXqtZVc0vbD2+OYHZaPEX9MyaEHvMAACs=;
 b=EvA3T1/CJnC3KqpTe+tF85TgMP5XNAhgL93RNf43XoatR5kGawqFFryrS/a+8OfvR/KQtAEjl5WddNVQStI5kYsy4LrEVDBmMl5Noib5w/MkcjHg9W4HZlleGKPFpUhDCW1h28E0xnR3QbU+iOIMUI/EMpWimDyFO/QPlQQMa0ixSpT+L2wKPHYGLmxW4d/YquHUsNxJQMB0r96XxAwCd/fvk3UEcCEo0muBj8tX67Ojw1Ja0GrYyRYofXhwxjtpXs35r8iiuXRVO92fwyjSdPJYyRoUPTNIloo96tnPS3spj76YFixw0oaJ9FV4pbEKBY1qeRNDTYm+ALqg83u//g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXSPRMB0053.eurprd04.prod.outlook.com (2603:10a6:102:23f::21)
 by AM9PR04MB8486.eurprd04.prod.outlook.com (2603:10a6:20b:419::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 7 Nov
 2025 16:02:33 +0000
Received: from PAXSPRMB0053.eurprd04.prod.outlook.com
 ([fe80::504f:2a06:4579:5f15]) by PAXSPRMB0053.eurprd04.prod.outlook.com
 ([fe80::504f:2a06:4579:5f15%6]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 16:02:32 +0000
Date: Fri, 7 Nov 2025 11:02:24 -0500
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
Subject: Re: [PATCH v2 1/2] m68k: coldfire: Mark platform device resource
 arrays as const
Message-ID: <aQ4YELHOH/38d2aL@lizhi-Precision-Tower-5810>
References: <20251107-b4-m5441x-add-rng-support-v2-0-f91d685832b9@yoseli.org>
 <20251107-b4-m5441x-add-rng-support-v2-1-f91d685832b9@yoseli.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107-b4-m5441x-add-rng-support-v2-1-f91d685832b9@yoseli.org>
X-ClientProxiedBy: SJ0PR13CA0220.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::15) To PAXSPRMB0053.eurprd04.prod.outlook.com
 (2603:10a6:102:23f::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXSPRMB0053:EE_|AM9PR04MB8486:EE_
X-MS-Office365-Filtering-Correlation-Id: 23e9bf89-b0d3-43df-39c2-08de1e170f92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|52116014|376014|366016|1800799024|19092799006|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?z9H/+EY85YKHCzMzEA4Zz1uku1nGv9rU1LHwFuklWDVP/05fD7b233675esj?=
 =?us-ascii?Q?hJ8/atQ+DcIuBqD86uMqFu3eXBr4Lq8P+7lH4/PoL7vTHPweP1C0OkwsYac5?=
 =?us-ascii?Q?cIDEEpdLQScNafUqMOiF3f6kiYX8PXXZMheGyi5PfOMhkBVWZtbYJ4dly08V?=
 =?us-ascii?Q?l8/gS6SGj9hSsvrMl6jFl3MescCyRF1ICanJYrVRSKbnfpIYnwh2bIq4Odgb?=
 =?us-ascii?Q?kftcLKIIFKRqyNj3vb0MfRlQxkeje13iNpKHTWWNMH2Zj+lvOlIKnxlDK/nc?=
 =?us-ascii?Q?K3U6xg/Y97/UE9wFFhKw9q7jF40/JTRvKVwkDEJJ1N4FO70BxiY8Zp55hUgd?=
 =?us-ascii?Q?J7jSDL2ivDh9BXhE75wZ+WnGWWybISxiSB8byaJrZNsNq5XlOf/q9sQXDPH5?=
 =?us-ascii?Q?XOvzXj+Mk+X/A8U+jc9q/KLxq0EYclIXDtx/FQSWE/fYdQF5qf2/QdGHAYt+?=
 =?us-ascii?Q?o3Za4NaehB9iiabClKQOWoK6EsnpqXplWgYEOM349btdfnnHQyAAnyYdh6/E?=
 =?us-ascii?Q?O3mhKwvBcJtvDlsbJdvYAfJV84xdKafFHXrlUNj0yU9JgH6M9fzVaxmacqj8?=
 =?us-ascii?Q?ksqn1lh4AWpd+JrmmawOUKYpesGBrv4eVg9wYqePeyb6vz/EPjLJFDVrXOZB?=
 =?us-ascii?Q?wwtFuRyj5ZCIEP5t5xK1OqBu86Ew8Xi0lMVNHaJv/tT+iZy3Igg7cQ14862g?=
 =?us-ascii?Q?Yzzd9r+Djd7FT3NKSzxNODHGxYLhsSYdP4GuZflz3mfw4fi4suqD5kpWSUK5?=
 =?us-ascii?Q?uuH8pANPx9kn8fMyw/BOyGI3YgFjDsr3jg11tzdZMNIdCtD9/H7hHIME8fx1?=
 =?us-ascii?Q?7oq2XfbslMbR8GqoaiIgiJigMqWR3UT8LfEkXQCSnmzTaJ/POC6lPpIEoMF6?=
 =?us-ascii?Q?A8gEzIh3P+j+DAvDoZRwB26yfMZXLUZe+YMzu04f95XYdVbJIPFLLDIDn7bO?=
 =?us-ascii?Q?d/mMXbULGMaDnO1Poxnj6ICf1BGGfUndgU6CQiA6Q17PuxoUuAzZTzsIgjjT?=
 =?us-ascii?Q?gnvygSnCgQWttwE6lfIt09jimf3P4oBwFCizgCxTvpNlKzRqZ9TebQ9BseEd?=
 =?us-ascii?Q?/jiZRdMiNlknhhBKg44aiQQ6M2yXlEkbX7gX9uMHEW0wucC3kM4s8df2yk6n?=
 =?us-ascii?Q?k12nwydBWYcbijFIQqyQNLH9Ffjy3DrppyxEIqAKybdQRX6hFu7l1F9ptH2G?=
 =?us-ascii?Q?I+bnSrc9ERHyC9wmh1SCD2hpB/DOVvHtbFwnU4uZJ+yOv7+XzYsAfNUn0laS?=
 =?us-ascii?Q?iq0HhB2UOq+NmZozAhkAPL+cya0AqyIPj1r9WySJ8xk8ugbZkTBU5/UwCAyi?=
 =?us-ascii?Q?O8EFu1MQiSLkSVFP9G12wX7miJk4ydDwnobKPEFmyWI/4baH3zobTP4Nqikt?=
 =?us-ascii?Q?6k4sDqiRg1c9Jt8dZilvBvHmP4baF9itlxoP9ak1LsfoJVMArGqKMwzPt++x?=
 =?us-ascii?Q?PI76EcFaRVlzT6zUgljnkTzQh8FviWMSQbk/uEQ8YXXpaPvT75GTki2tQ5sv?=
 =?us-ascii?Q?JH9NMTSf9eiJvJnV/ucPVodpf8paO3waR5ZZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXSPRMB0053.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(52116014)(376014)(366016)(1800799024)(19092799006)(38350700014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+2eqQGYr+LtpDVOPA7IbOCLRH279WFeDnIMMrme8WBcYnxOIi/3//VENuoG2?=
 =?us-ascii?Q?Kz9eawkcK1I9FtH+agU5eEzmd2RHJYx3KgxzhlvHP1rxfSFXB8TD1OxVMh/V?=
 =?us-ascii?Q?fLd01FI6Gp5Zm4MTLyLYv/PniFG4bouQEcQFaHtqYpo8Np9UVRwP8V///IAS?=
 =?us-ascii?Q?00b3gffDznB+ZrP+EhoHXHJoXKk05xVM1Fuo0yEw5cuZkcMZ4g2MIgYxRBD2?=
 =?us-ascii?Q?au6m+qtJrpGQB0oXEiLWKcCKOKfHTuquxiZZXwIDZCcKEAyv2IlcUNQyffCJ?=
 =?us-ascii?Q?fHuc3/aljPdI3CqLsrRGrr12La6OU8uu1i27hMkREqkSK/IIMCgQLanNINAg?=
 =?us-ascii?Q?pERnGAdYrw1/Bs320i9QVq3jv4Xqi9tQbSBikx6i9n+UwCEOmCx3mE7lwMp3?=
 =?us-ascii?Q?/90F7b+2tLqAs1GdfzdbuwVhuDMC2r29XWzoBY28S8yA3yyu/HWyYDZHQoSL?=
 =?us-ascii?Q?n2qMf+4fQuPltU1rtxEDBQ1k0SjGHz+BKHYulGxUa6n8LhgIMmgKJadtEnOZ?=
 =?us-ascii?Q?08UOZZszWlTfoG0Y21UmCJ62hax3pB5TxtkmKMDi8vro11ar9+Utf4a37Jps?=
 =?us-ascii?Q?zSydoTsTkF5kAG+WdUppn1YFYvgcZi7AF+iVSAj8WA8wBPmfF5LN5o2gNb3s?=
 =?us-ascii?Q?ZP9fNGzibqADSI79dxqOwaFyA2g39+TMTtPQ4NfXEthQb7eksB9CWGWJH9Tp?=
 =?us-ascii?Q?zwFJNgvr2Lyz/3AVhFf/tcJofd/8F5iQsxVXZyCRnnq14s0vgL1tFTY1Pwzd?=
 =?us-ascii?Q?MYn7651sLqvGpz7fxpZxaz2aQsVkAjntDMXmipH3rEV9cX3mm0ntcTBaobE5?=
 =?us-ascii?Q?Dhc+qbK6kGgmwzm1c7EY9vSmi+AIOrKP/Hi2CUujSTQiiaa8iO1zsCT5CUzn?=
 =?us-ascii?Q?Q4GF/SB9YizApGbv161TgBNdMFZMHZE2eV6OGZmqbEEraM52aaXO8UEhd5YM?=
 =?us-ascii?Q?bR9dWVk2M0ua100J0BRAfA7yutLWCk47suoBC9j0sKomanw/unvAwcnMeh7V?=
 =?us-ascii?Q?zYr29TxM3g4FqB9rfnjUlPCZKHdzl3X9ZjS38jkODa6g7SNcheRW+ZzG5+v4?=
 =?us-ascii?Q?T9frXcVxGQIMvsmzadROtP0W6f4hhLu9Idgug4P2oAy2OaLy9SUzrlPZILA2?=
 =?us-ascii?Q?NB1I2zxOuiyGekR/FYwy1bEJreAOEVkn0a+Haw3eqj69THY72C0KR5gr0d7P?=
 =?us-ascii?Q?W4CRyCg0RwtgDsMtmJDEpHMfOmtxSkYy4keXdAZMsAlaDY+LOmf7LL8txsDl?=
 =?us-ascii?Q?Lvw0/3+/8mebSf6Y9CsHkmoOu0LNACG7mueFV9uKrdbTvwaKyEvAIIvnHYn0?=
 =?us-ascii?Q?5AaePsmEFe7V371E0j9CADPSlp7skUkHavJj7Tp5vqlOk3eQ0iYM5xqOnspj?=
 =?us-ascii?Q?I7P/u0C5mTkdD0UScJaQvaTav6Apexi2Ov2P3p9uQx843clZml80wzmd95Pq?=
 =?us-ascii?Q?bLExEuxyOs1r7MTgVshqFSlEGaS3ql8uB+oJu/JrSHwisTfli+ZzafPOzXtI?=
 =?us-ascii?Q?UBntqTh6GIyZ32ngUTCohyXOt8nFM7EVtp1PHhJkhp8WFxSbXAzFy1wNq58M?=
 =?us-ascii?Q?8WjTi3BLuMTL3KuYqe0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e9bf89-b0d3-43df-39c2-08de1e170f92
X-MS-Exchange-CrossTenant-AuthSource: PAXSPRMB0053.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 16:02:32.9056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /CbowS5G/2/fVgVVVoVq20+2CXXN1zHijpj9j1FCCOJgQY7+/LnoL0JSFykLd+kEoyJ2ejWBRxU4l6HY+PlttQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8486

On Fri, Nov 07, 2025 at 11:29:43AM +0100, Jean-Michel Hautbois wrote:
> Add 'const' qualifier to all static resource arrays in device.c.
> These arrays are never modified at runtime, they are only read by
> platform device registration functions.
>
> Suggested-by: Frank Li <Frank.Li@nxp.com>
> Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>

Reviewed-by: Frank Li <Frank.Li@nxp.com>
> ---
>  arch/m68k/coldfire/device.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/arch/m68k/coldfire/device.c b/arch/m68k/coldfire/device.c
> index b6958ec2a220cf91a78a14fc7fa18749451412f7..20adba27a687029ef53249bad71b342d563d612b 100644
> --- a/arch/m68k/coldfire/device.c
> +++ b/arch/m68k/coldfire/device.c
> @@ -111,7 +111,7 @@ static struct fec_platform_data fec_pdata = {
>   *	block. It is Freescale's own hardware block. Some ColdFires
>   *	have 2 of these.
>   */
> -static struct resource mcf_fec0_resources[] = {
> +static const struct resource mcf_fec0_resources[] = {
>  	{
>  		.start		= MCFFEC_BASE0,
>  		.end		= MCFFEC_BASE0 + MCFFEC_SIZE0 - 1,
> @@ -148,7 +148,7 @@ static struct platform_device mcf_fec0 = {
>  #endif /* MCFFEC_BASE0 */
>
>  #ifdef MCFFEC_BASE1
> -static struct resource mcf_fec1_resources[] = {
> +static const struct resource mcf_fec1_resources[] = {
>  	{
>  		.start		= MCFFEC_BASE1,
>  		.end		= MCFFEC_BASE1 + MCFFEC_SIZE1 - 1,
> @@ -189,7 +189,7 @@ static struct platform_device mcf_fec1 = {
>   *	The ColdFire QSPI module is an SPI protocol hardware block used
>   *	on a number of different ColdFire CPUs.
>   */
> -static struct resource mcf_qspi_resources[] = {
> +static const struct resource mcf_qspi_resources[] = {
>  	{
>  		.start		= MCFQSPI_BASE,
>  		.end		= MCFQSPI_BASE + MCFQSPI_SIZE - 1,
> @@ -340,7 +340,7 @@ static struct platform_device mcf_qspi = {
>  #endif /* IS_ENABLED(CONFIG_SPI_COLDFIRE_QSPI) */
>
>  #if IS_ENABLED(CONFIG_I2C_IMX)
> -static struct resource mcf_i2c0_resources[] = {
> +static const struct resource mcf_i2c0_resources[] = {
>  	{
>  		.start          = MCFI2C_BASE0,
>  		.end            = MCFI2C_BASE0 + MCFI2C_SIZE0 - 1,
> @@ -361,7 +361,7 @@ static struct platform_device mcf_i2c0 = {
>  };
>  #ifdef MCFI2C_BASE1
>
> -static struct resource mcf_i2c1_resources[] = {
> +static const struct resource mcf_i2c1_resources[] = {
>  	{
>  		.start          = MCFI2C_BASE1,
>  		.end            = MCFI2C_BASE1 + MCFI2C_SIZE1 - 1,
> @@ -385,7 +385,7 @@ static struct platform_device mcf_i2c1 = {
>
>  #ifdef MCFI2C_BASE2
>
> -static struct resource mcf_i2c2_resources[] = {
> +static const struct resource mcf_i2c2_resources[] = {
>  	{
>  		.start          = MCFI2C_BASE2,
>  		.end            = MCFI2C_BASE2 + MCFI2C_SIZE2 - 1,
> @@ -409,7 +409,7 @@ static struct platform_device mcf_i2c2 = {
>
>  #ifdef MCFI2C_BASE3
>
> -static struct resource mcf_i2c3_resources[] = {
> +static const struct resource mcf_i2c3_resources[] = {
>  	{
>  		.start          = MCFI2C_BASE3,
>  		.end            = MCFI2C_BASE3 + MCFI2C_SIZE3 - 1,
> @@ -433,7 +433,7 @@ static struct platform_device mcf_i2c3 = {
>
>  #ifdef MCFI2C_BASE4
>
> -static struct resource mcf_i2c4_resources[] = {
> +static const struct resource mcf_i2c4_resources[] = {
>  	{
>  		.start          = MCFI2C_BASE4,
>  		.end            = MCFI2C_BASE4 + MCFI2C_SIZE4 - 1,
> @@ -457,7 +457,7 @@ static struct platform_device mcf_i2c4 = {
>
>  #ifdef MCFI2C_BASE5
>
> -static struct resource mcf_i2c5_resources[] = {
> +static const struct resource mcf_i2c5_resources[] = {
>  	{
>  		.start          = MCFI2C_BASE5,
>  		.end            = MCFI2C_BASE5 + MCFI2C_SIZE5 - 1,
> @@ -507,7 +507,7 @@ static struct mcf_edma_platform_data mcf_edma_data = {
>  	.slavecnt		= ARRAY_SIZE(mcf_edma_map),
>  };
>
> -static struct resource mcf_edma_resources[] = {
> +static const struct resource mcf_edma_resources[] = {
>  	{
>  		.start		= MCFEDMA_BASE,
>  		.end		= MCFEDMA_BASE + MCFEDMA_SIZE - 1,
> @@ -560,7 +560,7 @@ static struct mcf_esdhc_platform_data mcf_esdhc_data = {
>  	.cd_type = ESDHC_CD_NONE,
>  };
>
> -static struct resource mcf_esdhc_resources[] = {
> +static const struct resource mcf_esdhc_resources[] = {
>  	{
>  		.start = MCFSDHC_BASE,
>  		.end = MCFSDHC_BASE + MCFSDHC_SIZE - 1,
> @@ -590,7 +590,7 @@ static struct flexcan_platform_data mcf5441x_flexcan_info = {
>  	.clock_frequency = 120000000,
>  };
>
> -static struct resource mcf5441x_flexcan0_resource[] = {
> +static const struct resource mcf5441x_flexcan0_resource[] = {
>  	{
>  		.start = MCFFLEXCAN_BASE0,
>  		.end = MCFFLEXCAN_BASE0 + MCFFLEXCAN_SIZE,
>
> --
> 2.39.5
>
