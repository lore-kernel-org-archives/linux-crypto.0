Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010044.outbound.protection.outlook.com [52.101.69.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7716024E4AD;
	Mon,  9 Jun 2025 09:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749461791; cv=fail; b=e15JWwkOPhpt3dipftsj8CoOzt6xtN61Eey6V3zJlV2yi02VtpgI90FYg7cj5vJxcK/x6XJ8/B2hIudl52BgwK+8IqTltUK/t3VB2e+JWAOIbUK05M2mcg7gE09Ps4qm12rGLGtcakEzCML0UZufcEU4iO0J7yMQngw97QdIrb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749461791; c=relaxed/simple;
	bh=+GcMZxPhTQ+UGHrUQIKGnhDlM5AMhf0hMy34sYMztYc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BhE/nuaLzAR7albMGf2agfhBjxIFmuKNSS4G/yLrvML/zX013qd6Urv2aCuWKwN7nWtbRmFxT2k2GlIF158ScrwkfJpW4Jd4jTSQFhxJtFRHKvi6dXJQ2vMusMhFg+tRrWEWCGO5Kq4IJ+Qay2zkLbNbS46GdN9l2W2htxRfZVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=VVZ8SN+g; arc=fail smtp.client-ip=52.101.69.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="VVZ8SN+g"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FRPbxfphoSCZBsP54bCF/ILi2+mTMQWb4Y+RajQGBGYkLfoUvAO6qCrux18rtdw7Zl4xG9j6CdK94DAOuF5EozgBSazXTYBQ5nR3t1KESkqjDRjqc2/c2JJNvhGbl3Jqa4fq5zzJF7BCPNqsilAcUNokocWTwCn1K+KQjzJ7+ytx3Cx7FGpmpETpQk4ZegEQbhtw9Ty0OKC1enaCfH9rOF5AVYw7W0u4FZS8d9I9hHNSovcSwTrzVsz1BjM6s5cI2Neo5IjRCbl+Ot9fZhvCR3cVZDCotZnhBOJfERlQdHjFiwdcVfFVWEvYlh2RCKO6uzC8vmE59xLmZDWNzosnbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+GcMZxPhTQ+UGHrUQIKGnhDlM5AMhf0hMy34sYMztYc=;
 b=lFaG+94aWAlUk2kNzze+AhB5BAUrZ7kA+RweBoNtMJvlFK0KjYlirjgaqC5g0TfZDNf2QyGq6GyVPAzriluPYlzX0lf/16/2lZ7G+mGvcuxIdVmUO3xRlZ9vwzuXsFPsnGpcxrCsJbbIodpn43GN6JlbhjDUMBDbiasiQhBkSoOApDZGIn8fZ2biMFbRFnT2EkBE6KARYMU8u1Dl+j6LcpOGfaUE8THkR2YLJGACA/cY1OM2wVss8uRh+paGUEUl2oAiEEK4ZrB/Rf962XgtFiMjZy6oAIYlAvK+FcRCG11x9PArMLvH8Zco4nmR2Qn2VZ1xPaXWCzrEToJEg7c4kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+GcMZxPhTQ+UGHrUQIKGnhDlM5AMhf0hMy34sYMztYc=;
 b=VVZ8SN+gfeq4j2GMJpawFk8Y2DwBlbUbfXnq0dQCJ9VUwazgoYoNii/OhpHUHlDqUOGd66gxdC8FY32zFtwhNFIoaEZpl5NO/+NDS6z9wwcN5JZbuXRPsEWV7Gec0PvAJ8PPYTJxuk91k+mVsGhjv7Te7iCi2tS6EHajsnq9eCIOcfrbEYKj7T/tKA/hkNZqFuep8gp31U3YQoD03pFWhm/0/G9eJL8keNzpH3NabOEmlHp7kWgr+DoulIrNJIDzConi7qHcAODbVn+C3Rpr4I9a/Stas5LjUOrvuCotatVDd/BOxHVn3u+2+f06e+5x6AKCOFVUDFYgKDlXCtQlrA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from PAXPR04MB8459.eurprd04.prod.outlook.com (2603:10a6:102:1da::15)
 by AM9PR04MB8243.eurprd04.prod.outlook.com (2603:10a6:20b:3b4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.25; Mon, 9 Jun
 2025 09:36:26 +0000
Received: from PAXPR04MB8459.eurprd04.prod.outlook.com
 ([fe80::165a:30a2:5835:9630]) by PAXPR04MB8459.eurprd04.prod.outlook.com
 ([fe80::165a:30a2:5835:9630%3]) with mapi id 15.20.8813.024; Mon, 9 Jun 2025
 09:36:26 +0000
Date: Mon, 9 Jun 2025 18:46:32 +0800
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
Subject: Re: [PATCH v4 2/4] crypto: caam - Support iMX8QXP and variants
 thereof
Message-ID: <20250609104632.GQ13113@nxa18884-linux>
References: <20250605132754.1771368-1-john.ernberg@actia.se>
 <20250605132754.1771368-3-john.ernberg@actia.se>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250605132754.1771368-3-john.ernberg@actia.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: SI2PR02CA0028.apcprd02.prod.outlook.com
 (2603:1096:4:195::8) To PAXPR04MB8459.eurprd04.prod.outlook.com
 (2603:10a6:102:1da::15)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB8459:EE_|AM9PR04MB8243:EE_
X-MS-Office365-Filtering-Correlation-Id: 549c28d2-4f03-4eae-6d5c-08dda7391ad9
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|7416014|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WJ0QWx3JsThvyvLMsr6Fl8ezWXSoy2AB/+/LGJtmWh2PKtag7PAOZja5bkwe?=
 =?us-ascii?Q?Z8j/7GZOAWNZk/SzOC4IrsjJccQiQPZm70h6nZZHewCTFPtUf+3oioUBlpMW?=
 =?us-ascii?Q?+YapaD10RCUADEsNrprofTKAqK1OT/OzBqtxjB62+q6tdg8FOLiwysNU7dWc?=
 =?us-ascii?Q?BzJTaqoCrXlIk5/hrcfMH108dyZQRYoldDEyDSPIsaRLofalpTRhfLH2l+16?=
 =?us-ascii?Q?Gx3ywVtnJ8wADFp/kJoEyZ8TQyVM70IFR2/ZLrk/aKv/tf4eZhFDhYKin7sG?=
 =?us-ascii?Q?sbYD1ENPCkExyo8SCYOOi7tdhA3uUG8DiKIXBaWMdd2v/djjdcGzmgp4yI4m?=
 =?us-ascii?Q?MadVhePZIGQ3JuDUDf4PbvyawNNicUiX/X0cd5m2/qKS4KePNctytL1XAyea?=
 =?us-ascii?Q?nMEezc/0dNWYz5nwLKsXAnYUlPzIoW62CmUN9ri9KTzVUPYDNEvip1SpHptN?=
 =?us-ascii?Q?5ZxDqPk/A17xv5zWW2SEwOqTFE8MVajLFh4zHPdqboEq0cHYspwYikRVNqZI?=
 =?us-ascii?Q?Ml2JPdzVGRN80gYqV1vOHJk1AKUyYyceaQ5thupr/yaW1SiK+Bd/fsz1zs7Y?=
 =?us-ascii?Q?4rb+rATqlnjIB+WZlmxBK1seaBaNEZ7bYZKlxyv8VYUPJYEKU7XBzW0OajaD?=
 =?us-ascii?Q?MSwrhJPMByotJNfc4ceTMKpmlh2EmhUxq3YtaMCeDZL/SGkrium5aWAtLPs4?=
 =?us-ascii?Q?LBh/Lcl3n6imqrSsNwo/RaMhsWq8n3OOAHjOsryNZf/0O0UvzJ8GkU911Pf6?=
 =?us-ascii?Q?8Xmtlb0GHipTYhusEwDJnbVXJ2Mul8l+SP4HLooGpvvU7Zm9xFqLPCIdqsWi?=
 =?us-ascii?Q?mZb6Go7BFKPZCziknNsdIlbR/f0b5xdRzib+YXHi8lLIjq7KrkVlaN26OiH7?=
 =?us-ascii?Q?DpNN+YBoMNgy0vkItql5/btaeqe6uHaWcv319JCV8PTP+7rqpGU7vTfutGde?=
 =?us-ascii?Q?MuDeedLw5H6dM5ho00px0D8agWwWI5E13wYnVUAmPOMyTUpCzV5ThApbZR+U?=
 =?us-ascii?Q?KnUpwFzn0QDF5MSeUz+ZZQpnCkYeSJj9jtUCYB41qpHOe3zUMzDBBZw9Qkop?=
 =?us-ascii?Q?xwKbaj3/YTWcFyguFGVswJuWx4xT4YYBLh4/r9FgJ51X+LsSXReNIogFeJtP?=
 =?us-ascii?Q?E1qvfW18iSjdFH8Vw6wkH+n3WaMjmdj2gNXrfzf2IPotXNSPegb/Wbq6e+FI?=
 =?us-ascii?Q?WEQQIVcUItOXed9gAFHMz6YWSdQhHyF/inY41NfPLaz1Gpxtnq7wRk7tvwBv?=
 =?us-ascii?Q?qFF1ZF4X1fzc+bCSNfY2WBFmeQSw/X0/dQcoLbUHEeCekh1V6WGmlfto2pdl?=
 =?us-ascii?Q?n5mYoP69Wz3Jda62FxgE5/tsHJQES9MrrZD4qRh2/+azT41qykeQx3GVe8mS?=
 =?us-ascii?Q?OIu2DEpp+T4MSv5KlHBzAu/v/lzj64GMRDIVWnLuaufakDrbbWA9iPPlylrf?=
 =?us-ascii?Q?xC3Ml4J6JSGDt5iqduAXPS7i1aVYd6H+bnD2mVYaoBxApalF9H203w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB8459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(7416014)(38350700014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tuA1YlyezRpaqSpSIDggdRlpCkFHL7FKjSZXR91+BZgNpAlJbexTYPv7UEkD?=
 =?us-ascii?Q?JN47w7w3b6aWysrz1bFMA3IlLGX4rAUZxvKw3+p4RysvYuUemZEva3tQJywF?=
 =?us-ascii?Q?SievVjWXNLdERUetX44m6iyaMSsQmmnIhpm83UYwdGkkMUc+D1Qr/5azxnFF?=
 =?us-ascii?Q?IuBmm2ILTsmv9NX4yiqOAa96HSCmQxhMQjf+C1RUd70Lh3Ow6X+2tZQp3TKF?=
 =?us-ascii?Q?Rt+PvMNYTiK4kjsoweofYET0hlXZpxdTqGoc3UqASORp8VD5UlhZiQLflzgx?=
 =?us-ascii?Q?YhvQl3Fec/iYFvvvaLC8Zda8OMnGg5TbpqDNjo/DpNir65KsmgXnUlSrFWyQ?=
 =?us-ascii?Q?J3AzUFRi587IXgvi2Y5B8cgesIVR5FL3lrtOg0oR8uwmY7X7aQzQr0uchsVS?=
 =?us-ascii?Q?3LIIWZ5dUYXkZXH+wxGL760/YCpHkJrRZKw2Us2UKYe4Z20FRPfAyBP2Zbe3?=
 =?us-ascii?Q?aOdpwOBhbND6W55qn/cIKUYcO0BSHBdZnp0Tcu3AQ8VkcHGhw7lDeuPKk3Z5?=
 =?us-ascii?Q?evUvP2UpJjCGl26fk/ATk5J0mHzjZcf2IkhV+kFd3tp7DDXyW45EhNrK28sP?=
 =?us-ascii?Q?gHzKP8J0hrhOBvdiJ8h4fKsZpwIum1JPgxJdj7xkt9D417SiRKb3FL1mEaI9?=
 =?us-ascii?Q?e/fI2Hkhmiwh86z9+pk26093ec2H430Hm8507RoQH5MQj1QiwEZ0hVQFgnNT?=
 =?us-ascii?Q?NZF6ZoT5gpSrCQpRGDw7YC4t+aa26kpYKS6kmd+JE87oL6GcD9cLAlflYr+y?=
 =?us-ascii?Q?UzhPquPALttS1uxnxtUvYaRgCLl/hHbWHqQ3UPLDbmkna+tJs5xQbeV7Rd1S?=
 =?us-ascii?Q?uEWFJmGmaj6Gq5grYpeUTyfBJ+OdnGY68lkArF+/sfyNEKQbJhWxQjXr5Vey?=
 =?us-ascii?Q?L0qGJaiavWPm6VwYWzKDHkyP89WiLIQph0JWSS87R2744QKx83rm4oNvrHsg?=
 =?us-ascii?Q?ims4Pbcdq0W34O07/larWNtlGBw4lDEvzGYHcsAb5V1cRgJ2c5g8qxkpSWYb?=
 =?us-ascii?Q?NtK2Vd0NCN53mr6Qiaukx1iViKAeAeJhgDyPDII3XA7Kuzn22DN8KcWF5ttt?=
 =?us-ascii?Q?lF3jEtxNb61yBK0ytU8Sz2zO1RGI8maO6T+d2MzG6h0IZgDdw0meNuAKusOP?=
 =?us-ascii?Q?fHljr4NyOogR6ja4pwKMSG182WljqhWJ8izuy1sDyvJAT2dgx13103GWcbkS?=
 =?us-ascii?Q?4o1Uzs9wbV41sXzfpbafToDo5FhCTJOVJ9L5nEUQqNrIdlwCQ4conJNP3IQw?=
 =?us-ascii?Q?vqOvXC32H+tiQ+zNPDwdjHFcLywasjkfRVjKfBrlVe378nnFElmsICeZ/9Kd?=
 =?us-ascii?Q?WwOKWniK8CJ8MsN51vwaVrXVA0uebwn+SY2zV2MmWHgfD6KbOdU3152//xzt?=
 =?us-ascii?Q?byOyL54eYvlsKKdpUwFXoacwXiufyt1pavFrrj1/alfZxCk+FtHySvC8dNpn?=
 =?us-ascii?Q?YEi/EqCAUL28MVxt0cNVbWguclQYkfrs+vaBlrxLcFNKbR7Fw2ZWl8O/af/D?=
 =?us-ascii?Q?XTGBmD1xPvXS4PzPcZRjL/kao/WsUe74UfHOcJ/+Hd6zFHAw/rfFySAJzidl?=
 =?us-ascii?Q?MAhkn+kmikntv+8IkzQrqTjtxjTnwVsMvYHueV+7?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 549c28d2-4f03-4eae-6d5c-08dda7391ad9
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 09:36:26.3426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c/z0aY8B34Kl0cFtN/Vk9X/KuVukAsPMSZj0TXpi1xJWeCsf3guCJeFEaiZrry70izVY/gqJsdGQ289ki2W1eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8243

On Thu, Jun 05, 2025 at 01:28:02PM +0000, John Ernberg wrote:
>The iMX8QXP (and variants such as the QX, DX, DXP) all identify as iMX8QXP.
>
>They have the exact same restrictions as the supported iMX8QM introduced
>at commit 61bb8db6f682 ("crypto: caam - Add support for i.MX8QM")
>
>Loosen the check a little bit with a wildcard to also match the iMX8QXP
>and its variants.
>
>Signed-off-by: John Ernberg <john.ernberg@actia.se>
>Reviewed-by: Frank Li <Frank.Li@nxp.com>
>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
