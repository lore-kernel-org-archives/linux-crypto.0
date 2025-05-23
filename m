Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2072.outbound.protection.outlook.com [40.107.20.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF12231850;
	Fri, 23 May 2025 14:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.20.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748009254; cv=fail; b=ahORxn8EIviZsT7VriWRqj9LVGvqVB9LPhPnepf+vz+ET+8wT1F4r2gTAFerA+sBHbB9VZX0zEUtoCSgdtOARQi6SAOHREYKjFgOwf7KUlHZxim4AD6QkuCU4+wgSqR2LcErgIEC/XZ15woSFddF7+u3//+B6r/LACy3CisHk14=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748009254; c=relaxed/simple;
	bh=OcPUvWfnTAygzKGGyLahSpSVqWgHuFhTpiocnKUWXsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mRICaMQWUkFsiGjbvzVyY7zBYUyeavKjRozgB6yv70MsKsS5MKiwBwH6crRSGZXiQMUGYJN8zzWQdNBcHjsIcW0tGkk9fH+WyDzGlbTQ2FROebZaPfvc8pwUN4ECySXfhDBDybycSmGGYHI1woW4zr++Ysl/lk8WdnZEoW9Umuk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=J76994HH; arc=fail smtp.client-ip=40.107.20.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="J76994HH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R/715FO+FBeQDaPFOCosUe7f3NzdX7h6wvlOIwFZ0k76fhw/gzPFjk/wmJFH33JvNKzPOq4Dryqz5QZxmKU3g3864Q3kd2qcD0yjDAqju6dOTpcWwcVI//qORs3NYcBTpdQayUIBMEsklnI0HxDBf8LH7cIuQ51zZr1K04Ox6V3pABITRETOuFC+Xb3u9xU1yCLLFY+QwWrGan+jcIEJ4/yBMfkiEbM4cyOKe46PGiDAa6XyF7EPAytI/1mhEv7BzE8vemvJlfSIFXjxC06YB+7SqnUFXb2ZEpe3uR5iQWV4myh3SyJoXL7IYoGPeFtflPS6Q2V0vR4eQxqIVWJ+RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u7WghztzaYMcbxh+SzIWTACCEyqEyN3FQX5xLI5KunY=;
 b=dv5Uxb9s3guzqqcPSZ3n5ciwlUXwWK3e/4fFCt+bVatuAAFWClaMr3xfZ4PQZ02/xzv8fThvOy2VjNjz5Z2X50Cu2uDvjhtcYIF5WbJYpOVSTG6yHetd3MNA9D5kOkNjGQmkcxwuc6U21G1AVQ8Bvw84L/l7f2ZzcTsMVWeoOFHm69FqZh0SekaMgGUHEpESYNzskEFMlJ9fqBF3jeBX3suFS8pN+tyEa3wPUjaNvSKkhWlHGBXRvBoD1exYpbQyJrkEfrHRjQWe00CwErGJp51fdmkmhoc/IxWIfIk2PTlSJDa5JJoaZ92guEd5JyMo6xM1ng9dfRk9IM1IGUZUaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u7WghztzaYMcbxh+SzIWTACCEyqEyN3FQX5xLI5KunY=;
 b=J76994HH1v0uZTKl8HyhoLs6p9alcRQKxFwQqECL/ZTHEtvJHpBqbtwLcN12T8Ke7BqPwSjALQgjn3fDwrXp2Wz5o6wU1BpgcZ1f+qFVYOdfsdYD08CVusAEYjf+CkQZ00a034xnpdxUth+7CnQvLI6BsNR9H9UfTXqTkhX4zAuqrP9M9lQxz5lPMm7NnvPOn0nJja33dg/P/eIbx+SBoS6tNZ5FSbdpf8WNfnedseDfLTbOP9diWHnXjq85gUxExi19Sz02DevOdy9KMBjDpp1MNbhxc3wj55MbLghG4BtuemivYDhAnvKMG0mYXEl3TuWwlSRdl4l3SJlI6zdO/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9642.eurprd04.prod.outlook.com (2603:10a6:102:240::14)
 by PAWPR04MB9886.eurprd04.prod.outlook.com (2603:10a6:102:37f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Fri, 23 May
 2025 14:07:29 +0000
Received: from PAXPR04MB9642.eurprd04.prod.outlook.com
 ([fe80::9126:a61e:341d:4b06]) by PAXPR04MB9642.eurprd04.prod.outlook.com
 ([fe80::9126:a61e:341d:4b06%2]) with mapi id 15.20.8746.030; Fri, 23 May 2025
 14:07:29 +0000
Date: Fri, 23 May 2025 10:07:20 -0400
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
Subject: Re: [PATCH 3/4] dt-bindings: crypto: fsl,sec-v4.0: Allow supplying
 power-domains
Message-ID: <aDCBGMmdGLcBoSjy@lizhi-Precision-Tower-5810>
References: <20250523131814.1047662-1-john.ernberg@actia.se>
 <20250523131814.1047662-4-john.ernberg@actia.se>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250523131814.1047662-4-john.ernberg@actia.se>
X-ClientProxiedBy: BYAPR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:a03:40::35) To PAXPR04MB9642.eurprd04.prod.outlook.com
 (2603:10a6:102:240::14)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9642:EE_|PAWPR04MB9886:EE_
X-MS-Office365-Filtering-Correlation-Id: 91a88bb6-1236-489e-245e-08dd9a032760
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|52116014|1800799024|366016|7053199007|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?otKpwE44vCD6fswfKKabRFeaWpo6AbSdFaPjz4npLjddKPCqdBNzvNJHPC0j?=
 =?us-ascii?Q?kmePkoMIlFBa0I5/Ni7h5qmbX2Po9xI66pR2Cvaw3oXy2Cu9KsnF8Yui/bgV?=
 =?us-ascii?Q?j9EzDu0/KNfxuCQxtXiSbQvS0jybJJ7U/Mg79/XhNE628uSfHccpDh5b3jYk?=
 =?us-ascii?Q?fvuViXgwNad5e63kWGdsnAt+ZjDUi2FP6Sff7Ng1ryGWJXfZoHZ35reiFpvl?=
 =?us-ascii?Q?R/BojmHCsN26jMFGJ19rNcfSo+CI5Z/nQi2fq/0/F90JlyQsDOBTym6E8f7y?=
 =?us-ascii?Q?5o8kLjNZaKoiEkQ3Lmg2UGWChzCYY71TkjoFl1OIjzU3kQsqTsD5YQuS50Ui?=
 =?us-ascii?Q?9+3KQaVmXj+P5pL4skSQg1aPYQGxwDS1ulX0zlNtWqGHFi24aE/kr7LpIgpk?=
 =?us-ascii?Q?SFaU0CN01tdX4t3J1SSiQr7JCJUus4grgj31WfsE6M5kj+wQLm5Vx9vyVRhn?=
 =?us-ascii?Q?qqqe4UwTtTPG45fAgQ2CvgYiNKfTeiMgxxbKdvR63EW0VyAY80ZnPAODAf9E?=
 =?us-ascii?Q?yVWMl3tvICgpt1znqEblTuSeHUexLe+5r1o6B8oR9RbP8fYYOv4eObFj3aP6?=
 =?us-ascii?Q?HWQqI53S2bY2/dvOY5tsSaOP4LgyPTNGFQpAYWiBqhErQUK08kSuy6+8QV19?=
 =?us-ascii?Q?bsBHhEu5JK6dk5uungrL3Qnz9ukhOLBfMoBi1F2mJQQFgwXi+gvvWyQxMTng?=
 =?us-ascii?Q?1w2iFbHQ6ChT+dvfxMpNNcyJ02cj7RmPLySOxksEGziVh0jMo4p3NaU2gd8z?=
 =?us-ascii?Q?3H5qXNDcf+lyVjdWtCn3sEQgla5YlqXmdIggTmwp6PVuPua+Kk99l4PQMujy?=
 =?us-ascii?Q?zWQCNZs3AF5O3/aa2dwqITqrH5+3zxIGv4ItdmYpHlz0pPmDp+iyBvltM5vJ?=
 =?us-ascii?Q?IAEq//O3M2vWVUwAdVe89SGwpqzTptI7wUKYLL4A0GyMaCZ2/LSZDPXSDo/b?=
 =?us-ascii?Q?7h2QZO+xrlRpHbVIF2gP4hP48q+OrPBJIHy1v1abkwQDq3IOvMOktwKfWE9j?=
 =?us-ascii?Q?XKsq6XjI3WzWzAdW5bpzffhIlF0WSgl/1r/zRyaS1/2oTAxV+r+mY9LmR0zf?=
 =?us-ascii?Q?c4iX7qV8DvZfGyqMvj4/0RS1X9PC3+RLZEZU6jxhJgk8ETNV3CscbtowaMfT?=
 =?us-ascii?Q?83+nIx35Fp8FZcbxQd13yRw+EqEGlsXspoQ+Iw7yd8GUjsBzjm91r9kGekSE?=
 =?us-ascii?Q?VDAIBCm6S69BEuch9sSzBQHns6ECv0o0Nnc9dgqtFKf5AN2+p1kcZOeVzwzF?=
 =?us-ascii?Q?rSRsSs2HrdiqN9yimQt++p5m8GWlRlTNACjLapEgWi8hsh1RmgdBjmfP0qUn?=
 =?us-ascii?Q?LvvZS1dxS6wfFv3Ed9GyxTcjMguBMFP+kC2raCA5o8bgKdype1A7/ANITA9F?=
 =?us-ascii?Q?Z/qq2hADIW9sg85hxckPGytLf96WHjBXc0DI1CfmqUPuiGly3ttnzU9KiIzr?=
 =?us-ascii?Q?gAw/5RmbUrdu1/sE+ZYehGmw70h27kfk5dmqZZe1RyygWX6CqpHkVg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9642.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(52116014)(1800799024)(366016)(7053199007)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SoDO8WtgZXAYTChyRQrZeK50OkC22iuJGHkFOmEHuNSdJzgblfkNgfEpsfkK?=
 =?us-ascii?Q?JAClLos/2Nf9DfoiWVcFGnk+JlmMDr/jJdzq3kXEk6EuSVlzOHiICGjLnaGd?=
 =?us-ascii?Q?Ft43KVkpQSuf7nvrY1ZX6ALFPJ6OtZANcQzEi8hAzKZWZwOQlA3KRAdePeX+?=
 =?us-ascii?Q?p7cuFtpwFeczNQQJmzjlb3dwCMm+a+dHBfVgdEjLdZxri//lwrEkrkJ4y5pu?=
 =?us-ascii?Q?N1vbqhjxiBPQ/RUCe5szhOL1LsasygZehrO6IEj+9ylL2/e/jnQalbLX5CAv?=
 =?us-ascii?Q?29d0mBstRyTvMma6/3UQE9cYQ7hC2Lx3i7obghcH92R5YAQsS8jGFxyOiws4?=
 =?us-ascii?Q?NmflRhHpUBN458155q2XLquYUIwzrP1L7PD3AYdJ4DX8jfl1+PSM2HmtJZ0p?=
 =?us-ascii?Q?RzT124Xtdt5Tzvt2edP9FTVA2XxH4XLtOlZ+vk4DEsKy8Wu0kZEiGXKS/pGG?=
 =?us-ascii?Q?CAz1T8Limm6yvxAqnb1zTokei0mSCuXxXz/miZIizo80hSY7jVdHDgJanJsb?=
 =?us-ascii?Q?dDnYEFhy92B17eiw6KiCdHMc+epUcgXgm3ZNS6k+EFHEQBNr+9BqvCJGTXLG?=
 =?us-ascii?Q?Y+H5AKTKkRyEP+V1BGrAAJ5QWjs91oh2BKM/dETQ/+OrdwYGPmyC45MZs9pY?=
 =?us-ascii?Q?BmlzK2E3nnI95GFE6IP95MIhTogm3mMKJK3YDbQ5hoXrgvVjJv2rcbQeWVF+?=
 =?us-ascii?Q?4Kd+0rBQ9Hho1v78K9rIp3VMpf+YNS22qymf106gAesCm7WJyjTaNntfufyM?=
 =?us-ascii?Q?vALiDodfV4gYkP4cf/Ig7wStVOf56GERYP2J5vTODRyZsTlSjp+0CJ4GTusl?=
 =?us-ascii?Q?UmkOvm0cYebe7bSis4b7vId2te7G1VYIEPvYfDh+JQjZZSOd/TYX2G4I3Q8p?=
 =?us-ascii?Q?vun5HQcxizZLgj9EjpfdvRg04+CQwebsaREvOG5iKopox4bTCWVRs0kJl/p4?=
 =?us-ascii?Q?qpptF4i8Sbau2bQE40Jl+kD8VCEA7ooaKbOpbhwdcOfkObWyl5i9b7R8m1nR?=
 =?us-ascii?Q?kNfbR6Sx+C8dU58mxDfbpGj+nYvNM2jg2Ff8PMW9huTUK6U1Mutith7vQ1wO?=
 =?us-ascii?Q?Q8x8vOLnevX3S7Otsfz7ryuE+2BZehlemPiaPAOnLxnU8qW8O6mYzjJ8dPdg?=
 =?us-ascii?Q?6Fmy8pYsHry8SccSInc510cErZlNRg0zX0sV3HYiJevbbGJCB+oBgczKzht3?=
 =?us-ascii?Q?yRSknmHBQ4GGkkZg5/j6OKGGfMlevj8Z1hAtvyPNqsDMDo8jDPub11EJKbZP?=
 =?us-ascii?Q?przYeymwiUxmsbSqpd0ixbgmhom5DEyxZn4G3HOLIP9l8eXQ6pY3i+LjnlTk?=
 =?us-ascii?Q?vOVoC9qjuCC1rO+IpqXRss4pjcHSgmIhnnjB0BAXvPfYw6wzfOWJp5hx/acJ?=
 =?us-ascii?Q?25tR/3H9ge9OY64vzb0JL7fjfqKgWJhscIVxddnZbQfc3KOg+Lix1QiJHWem?=
 =?us-ascii?Q?dWprbKKW/L/aZVsOpKIJpaRbFrih/QOg4V3SsYWmKbVoSbAnyGLwHmNIz74H?=
 =?us-ascii?Q?jLRgvqWQAIhFe0Ojl+ozBHsvkBmWCjPfqRR0IRzn0WXqO0L0yGNaMKjmTxU3?=
 =?us-ascii?Q?9RzxEem3Y86sCSP9/PE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91a88bb6-1236-489e-245e-08dd9a032760
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9642.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2025 14:07:29.5797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MtQfWBllyPwwFTRAY9V/S/wvLOLw8Zj3KB/sHUdUefq51Sxlay11gdS75Hr7Ne+KU8+b8extEcdW4ok3grAgOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR04MB9886

On Fri, May 23, 2025 at 01:18:32PM +0000, John Ernberg wrote:
> NXP SoCs like the iMX8QM, iMX8QXP or iMX8DXP use power domains for
> resource management.

Add power-domains for iMX8QM and iMX8QXP.

Need keep the same restriction with other platform.

>
> Signed-off-by: John Ernberg <john.ernberg@actia.se>
> ---
>  Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml b/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
> index 75afa441e019..47bbf87a5a5a 100644
> --- a/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
> +++ b/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
> @@ -77,6 +77,9 @@ properties:
>    interrupts:
>      maxItems: 1
>
> +  power-domains:
> +    maxItems: 1
> +
>    fsl,sec-era:
>      description: Defines the 'ERA' of the SEC device.
>      $ref: /schemas/types.yaml#/definitions/uint32
> @@ -116,6 +119,9 @@ patternProperties:
>        interrupts:
>          maxItems: 1
>
> +      power-domains:
> +        maxItems: 1
> +
>        fsl,liodn:
>          description:
>            Specifies the LIODN to be used in conjunction with the ppid-to-liodn


Need add new compatible string for 8qm and 8qxp and fall back to exist one.

Add allOf

allOf:
  - if not contain 8qm and 8qxp
  - then
      property:
        power-domains: false

> --
> 2.49.0
