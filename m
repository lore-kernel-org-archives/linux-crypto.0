Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013068.outbound.protection.outlook.com [40.107.159.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0961348E0DD;
	Thu, 15 Oct 2026 21:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792099105; cv=fail; b=Lht5Z9SDYUkOHtXYlBZH8hYc9b2Us87szKigyJI4J+OzOptGaU8rSjyGc+O/ru+YyIuDjFnTcQbW0zpJXTlKQCAua6AD6k/Kowd4V0GygDnYcURhHROz5p3m2UDjmjgMeT2jgEjvmreqqDMaCvsWBUR28LaZIAAivxwf6cEdCYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792099105; c=relaxed/simple;
	bh=ddjwtWjd3ELTRm6pOTTmcI7W347g/xLea1xnmOXXaLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=g3FD44xj+Z/MREDaCVditVOPsb4ACOLch5bPhIQO71oZ3UtMDeUqTvYWphWsKsWNzGG0Y1VCJoAiHbzR4zJNdVZ4UK+0q3+sV56oCX/zVs+qOPJi4+0Rc3veSpesvelaXhLWMJ2BPDvJjspBxF5JLOLUOO1ua2Q2J2Wz+9gg1ck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=ZD/k4j9E; arc=fail smtp.client-ip=40.107.159.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="ZD/k4j9E"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C/ldh7UgyoOf4SS/AAeyHP5Snl4Fi2NaikkHEXl2VPzkgAFhsCWeHK3ZKeYQM24rkGQ2XV8oyWDTh/rOhJq83Z11w7I+8oFMnnLmKApSJRlAU2COrQ7hXJhd7O5vTVe48zXzzN+vaKJgueaLz76vIXNRc3d9aqZTo5nkve/5oTDHN14+0yIxgf1qvJeZTi3okne6KabVZ/EIiLJXwgobBy1NK4v+A73Yb8viNuQew5MQozm84+HIvaSj2IZVkpFZi7nQtB3Dzns/MOh5PyLTRYJQFUymswQS/S9SyvoCDG+NJLLnwHOChAP7AtnebJVb6Jiq+vJ4dG5sDCgPYePVVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xezBdtShoeA9x/WEvrBj4BmTw7DTrxf/9kI/jmS0448=;
 b=G8FuAYHbTHTsbzOrdaBaqnXZE7KANG08ygwupv6aNNP4QYzp/rM8H35es0WllZRzAESSCXCHvYfOU8+Ez/3D+wPohSFp1mQU78x+VLtC5R3/pPtXSOciplmbxaZdxCQlsXnC+efg82N2CZ/Weuyf+468lmwTm9BahLHm+xedOzxd8MuV+IYQ7JMdGFzM1863C8ULm+XqTo2XxBh/h+c4VIiDVlyfc5JmFRg0T5xekkeWtcZo6AgzNh5JazHY0526Js24lZ1b9trzr7sJ2/hhRM91R5HiHXjplBMQyk2YGczxrp30MRdpLMjQLoV/BD3gnAKYEqGmvjJP2LHNEWanDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xezBdtShoeA9x/WEvrBj4BmTw7DTrxf/9kI/jmS0448=;
 b=ZD/k4j9EGfE4ECZfETKe42ksWppSFo9z8ACZDCgUMM7VehNpBmK7WZj96XRJo8VWiAXQvptsXjqkJY0YXlwtLMumWtVn28K/QX5TdXwWngNZvk/yjBKUgEHYDDQonvmrTKIoLe9spsUbBo7/MngjmKQ+TuBppB4Ar+DUca918Czck/Zg9DQD8dgZPmFIoj2en9Num0WedjUEpFXhAFJYwoeS25ZY3/aOPofiBH4OInkwSwk7+kdupd2rhdYF9mfmkS88lDWdBUqLTnU2PnZg6Cy3gD+Wso9/XW68leTqFdAyr/sNQUP5v/DKOPrNbp9dfLNmqy3bKo1RZZPpO/ZOqw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU4PR04MB11791.eurprd04.prod.outlook.com (2603:10a6:10:623::11)
 by DU4PR04MB10984.eurprd04.prod.outlook.com (2603:10a6:10:586::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 21:18:13 +0000
Received: from DU4PR04MB11791.eurprd04.prod.outlook.com
 ([fe80::11ca:6b74:3234:d7de]) by DU4PR04MB11791.eurprd04.prod.outlook.com
 ([fe80::11ca:6b74:3234:d7de%4]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 21:18:13 +0000
Date: Thu, 15 Oct 2026 16:17:49 -0500
From: Frank Li <Frank.li@oss.nxp.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	dmaengine@vger.kernel.org, imx@lists.linux.dev, vkoul@kernel.org,
	Frank Li <Frank.Li@nxp.com>
Subject: Re: [PATCH 6/6] async_tx: Mark as Deprecated in Kconfig
Message-ID: <atFC_Yi75uRqac8w@SMW015318>
References: <20261014-async_tx_dma-v1-0-35790d01e190@nxp.com>
 <20261014-async_tx_dma-v1-6-35790d01e190@nxp.com>
 <20261015205146.GA2331635@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015205146.GA2331635@google.com>
X-ClientProxiedBy: PH8P220CA0030.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:348::15) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU4PR04MB11791:EE_|DU4PR04MB10984:EE_
X-MS-Office365-Filtering-Correlation-Id: 88f04a02-f961-470b-1a71-08df2b01cb56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|1800799024|366016|376014|6133799003|22082099003|10067099003|18002099003|4143699003|5023799004|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	K3JfN6dznlnv9ezDQqc07WHY0Ir4yBWtabvPMkOnjjsTT+VOHt55u5F0EDaebMD0WEUywjuE+oTXz9wN/wmj/8untqtmSkoEJVg1Hda4PIyHuoRkH0Ca8ydMduwbEVsrXxiGD3OMNKzR9bmHA2UZg6tGZrORZeEkTlu27uvvsq+bktNks9V6nO5l4wI5ePHnWZNBp6pfbVXMLzG4a/w0EaHbHNQRIR2vWvL0hdpsZtFpIzWsY2Z/TuWy8aEnY0NzVQVddDKuFXR819UIXxqtXCjRR0qa0wTy/PDjiy0acGWmLiU7hwc7qvl1jPJ0LWQWxsSE1qD9tkhfOhwh0FJO+u9emVXcuLINTzVpi/6u6H8FxYzeyizz3jV9dpYLls6OhRZGpsbPgKgcpsVv4U8rfzrjhUaK9PyUvJwKNqEVSq7gnTTdmedF30uTpYE4yrklyyc+35AbWYifp2WX5Q1/fUx9t59TWLk7baCdYDw4u1h+GE2UMSCEkskDuDOrPVImLdUPq4GQVCYbA44s2p4nuiEN6nmVPGO1ivb2U6rpWQVgJ3NIs14gncWAg1S2Qc7Lgsfj9LKrzLpXqitheGVDbaRIu3eDyLgNdXWxj1jMJDv931fUtj3nJAAcrJdyoDHV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU4PR04MB11791.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(1800799024)(366016)(376014)(6133799003)(22082099003)(10067099003)(18002099003)(4143699003)(5023799004)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DVndO7kFythL75an7d143P5Jyk3TMZpxcS3noCn+zX/L6p9czt1UPRUQxXVL?=
 =?us-ascii?Q?0E+IuyDkK/N9m5l8SlFZVolXDU6RkGP30wThgV8RX0ynZffKm63QOpPk7Jbc?=
 =?us-ascii?Q?yX8z9exR79IZZJBQBe0bJID6BH53iJVp6dTSpXO25p/xQKE877VEI4jxjGL5?=
 =?us-ascii?Q?e8g+CbN5sdqMLe/oEatR8sltTXDXDT6v2z2BouNEikDCKBDyRVzT62g2gQaN?=
 =?us-ascii?Q?GPjtlL1Vf4v4qfhS3U/yXKOtoRXBg+F6aLJizFVEDUuvIPhuitU2OZQxH/z2?=
 =?us-ascii?Q?GIiN7WNJbRSMKErtP/eQ6/F+0cQu/0KfNcvV4BUXvgB1gpzl0mySO7KOBePO?=
 =?us-ascii?Q?l2xe1dqDmN1p0FM6CLEk/ch1mtepElVXXVPa/sFcFoUQLUizlo3NMjFA1APi?=
 =?us-ascii?Q?T8KqbqsZ0RRn5V1eJAVeQgDaNmw68gaAKZ3SOBcouoISzase7m2vmQSJsLkC?=
 =?us-ascii?Q?J65bSSEBFhUaXgjy5tWEIXFMUOspa574RxFOsFbT51JgR8hw/ml6VwUGPQdl?=
 =?us-ascii?Q?8jNAfuxdq5bHiR4GNShe+FTyFE/PT9gRonnPuEFIAKjBN8LUdDiGw9Ksun0T?=
 =?us-ascii?Q?clSZwQVcl3m4lQjQ5J6WVh7TPYTEEVq8kK+P9GrYfvDOXez6RThxckmgBPns?=
 =?us-ascii?Q?8mkSRRtXHk68Ou/JjEOGJzZ/L+AGdhro05Z2Ffhvs1HYh1TaFJhlX0Ekv3Wk?=
 =?us-ascii?Q?amNp1k3uFexJ8NEdUpdDDGh9oLxJm0DDkdw+ExV7lJ5aIjx+usA0ECxokuYA?=
 =?us-ascii?Q?B/+DX1s63KRGgRV/as3qqAJFVA/Jgba2BzugsVQygFi+Ttq8CvrNivGkA5ba?=
 =?us-ascii?Q?JbCjpkPG+f3vmIpNyZk0nv8d/xOxpxzn81UtPEGvy3h2Lhsh4yFd/GwBe/o2?=
 =?us-ascii?Q?Io/8Gj8lBh07z6V38W+E+7Rih+G4VmeN2nDTmTihXdZuXDvn1Ic6gOPLp7Jn?=
 =?us-ascii?Q?9nHNj6svztULqag1dHdKaQ0UcweNXQCUdghKe/TgOxtmHp58PphfpqurGWMn?=
 =?us-ascii?Q?hx06GOt/eEKhqSC057ku//yHaXrdGGq7aTU1DTGB0qo6yWz0YoQIfKTG1Ob0?=
 =?us-ascii?Q?MNGJe9zXBPX8D/cOpp6pim8tuI82PJQqfzFQHwT/0R3x8FWltB7r1tAEpIbl?=
 =?us-ascii?Q?5HpBfjODZE2kzPZGxcjOGPsoGGKAtzi9UmvyYi7N/ft1oxklPf4GvVHqtZQG?=
 =?us-ascii?Q?1XqOKAI6P26wRp7RUOux1ffa5b3m4W49dWmSd7AipatAfq2Z6AZ9oWXFSsLK?=
 =?us-ascii?Q?fTnK6F2UlvsMMCAaMhbaS6G0Ko5h1DN03vhJYVIBFdJFUjUwAltJbNVWnpt3?=
 =?us-ascii?Q?Eh4Pa9M0+jLvyGroTi7gGnzJNUNOXSdDysWw+o/hcGPR5+4CcVorPHGsPeMi?=
 =?us-ascii?Q?C8yfHp8veHiF6kJG8HG8tMGIeM3mzpPi+YRJSPFLhoEmGp61IaXGFJUPRCe1?=
 =?us-ascii?Q?fPWLdEi4AdlpiyPveoa5SQNRN/0TbnvmNHw/1Ys9FbZxcnO/y4erzzQ942ex?=
 =?us-ascii?Q?S+tUdyuTCX1ajdMEXXcjH/1UTxzjIlWcG5968ez3DvgK2SJGEu0aL3F3rpM2?=
 =?us-ascii?Q?FnjtsV3KITiz/FRamtnTHjY1TKa9uVnzFnxe7JjRk+uqFvwvNweJ9FsWaCpz?=
 =?us-ascii?Q?Sw+2Y+208pgI95Hp3HL/FcD8x0dwbcw0IhKlcY4ouUg1UsWSCX0xU9TcvkWl?=
 =?us-ascii?Q?vRk5wdsfdxEGjDnNuotgO2VoCBizn1NKrwzOWb5gCfIU+E8aPvlNzTERpxS+?=
 =?us-ascii?Q?dwEz+JZniMjGyHWqlAUi5zXyQFwc3JJxCAPLASfDJdHJQDgxlK3E?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88f04a02-f961-470b-1a71-08df2b01cb56
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 21:18:13.4356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bFiKgkzDERkD95Nnd6ZUp7K77DsjculnZ18uUBPLHCou7cplQPpnFBe6idzeDZ+O03owNYK8t3WWanbw4iIoCohuzABIF8jJnGFeotzUZoNiGDwoNtMMhrsXTD9UREef
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB10984

On Thu, Oct 15, 2026 at 08:51:46PM +0000, Eric Biggers wrote:
> On Wed, Oct 14, 2026 at 03:43:50PM -0400, Frank.Li@oss.nxp.com wrote:
> > From: Frank Li <Frank.Li@nxp.com>
> >
> > The async_tx framework was introduced to support asynchronous RAID
> > memory operations and DMA offload engines that were common at the time.
> > Today, adoption is limited, most clients use DMAEngine interfaces
> > directly, and the framework's dependency-chaining and software fallback
> > features provide little value for new users.
> >
> > Maintaining async_tx adds an extra abstraction layer and ongoing
> > maintenance burden while serving a shrinking set of users. Deprecate the
> > framework and discourage new users in favor of direct DMAEngine APIs.
> >
> > Signed-off-by: Frank Li <Frank.Li@nxp.com>
> > ---
> >  crypto/async_tx/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/crypto/async_tx/Kconfig b/crypto/async_tx/Kconfig
> > index 89bafa2efc300..02d472fc7a476 100644
> > --- a/crypto/async_tx/Kconfig
> > +++ b/crypto/async_tx/Kconfig
> > @@ -1,6 +1,6 @@
> >  # SPDX-License-Identifier: GPL-2.0
> >  config ASYNC_CORE
> > -	tristate
> > +	tristate "Async tx core (DEPRECATED)"
>
> If possible we should just remove async_tx entirely
> (https://lore.kernel.org/linux-crypto/20261015-asycn_tx_remove-v1-0-056a7085e0a1@nxp.com/)
> as your other series does.

Yes, I am not sure if it can go smooth, some xor dmaengine added at 2017.

> Adding the prompt here actually does the
> opposite of deprecating it: it starts asking people to unnecessarily
> enable it, while doing nothing to make it easier to disable.

what's good ways if remove meet problem.

Frank

>
> - Eric
