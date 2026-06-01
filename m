Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2108.outbound.protection.partner.outlook.cn [139.219.17.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A30F3090D5;
	Mon,  1 Jun 2026 10:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.108
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780308663; cv=fail; b=oyOM9gXXTopgLkXmZZs1pOQHGr34ax2jQjZM/ul6Lcscp9x0D6tYwO76u8+2lGmFNvI1nuzSw/RW+S9he1304Ek5IfH6Ajjn9iu1xlEBeSbNYvq1qKoECTABiDeKj2jRj18nCZfk/eDKvkjOK1LLQ1zSK6FEUsCtCobfDFXSuck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780308663; c=relaxed/simple;
	bh=SiTRVyy2kS4xcxrEP5mjR+ygAO+AhcnuSycaMaXhxzM=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=kUSesuy8fPCWiBolWkPRRUtV5nfa72D3kUPVPE7agos7b7EwycNTc22kHMqmmGpfUrq07uo7VotFGrZ0z1F5jTDshYZxXJkS+s4umFAztCxYUm+XUljCp6eWKDyqYdMyGQ3zHeImbIjrnROawx6AYxA1oqm2MXBa6ZRRD6yrbOU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AUE0QNvadUcrrjb10gXiWek/B04lDFN/oqicjGIGk17YHsKKh3Qbk+KgViU61o3mAzMIiQOZSJ7ODsvgbllul4ePfvQ0LoZI6/CsnuLLkt2P3pmA3+uCAGDM3hKG8T9i3d0N5wB1J1We4cM4UzkGRWE0EjhCyLuH8gKJAR5Dwzm4crSTGttaJE6ebQNmfpMl5Dao6dVmMOMuHYmlBnymxwLv3Tfq8mO7xtSy/qVg0ZrCKwVuqzE8c45erpbqqeABsTIqJsNDo5Tqoi1Yqij4L696qZ5xM3ssqNHSiP5DYvJaQnrrVz8ryYvaSuiZnHZwjLXtlFjflKIcNGNxHnrJEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NXe/VaFiY5mfmZrFDM1NvQftVtpAqQ0cGC7QJUHpkp4=;
 b=DMst1mcfITCIlGKpKkuCQPm3A0v27HmWaP5SsprciyNHj+Us98/oYKPkzr+IiXFHcwLBaPut3a20aSNbpoMuoV2fKzaYOLZAqjooWBK7xsgo2fVFyvuMHx6B9zWuKXNBrwc0/yFi/xdqt9LnCp/tV7DEJIcsRrSkAL5ikC7yrfJKSJ9Sy7z+7CmU3oxh4ZAtXaR849ATAxaV1JYPL6c/heftntCKFGx3DbmH7ePGlUOpN6G6S6VZQOo06vxICAjkGtTPa/ofNkXf4w7V1ZDxIB1m/ruoL8MeGnYYp4/8umoNX/w97VfstlraZ/kp22cGyfxoC2by5d3MxIDQclVGpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB0982.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Mon, 1 Jun 2026
 09:37:52 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%6]) with mapi id 15.21.0071.017; Mon, 1 Jun 2026
 09:37:52 +0000
From: "lianfeng.ouyang" <lianfeng.ouyang@starfivetech.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
Subject: [PATCH v3 0/2] hwrng: starfive: updates for jh7110-trng DT binding and driver fixes
Date: Mon,  1 Jun 2026 17:37:42 +0800
Message-Id: <20260601093744.84210-1-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SH0PR01CA0009.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:5::21) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB0982:EE_
X-MS-Office365-Filtering-Correlation-Id: 651c7071-3275-425a-79b1-08debfc1738b
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|3023799007|56012099006|18002099003|38350700014;
X-Microsoft-Antispam-Message-Info:
	cN5J/ANaSXDB8oxoFvdzo5jjb1Z49kdInOrZbJFwizkz5QZZYLEjtR88cT05oXetCnIIJJmsH+GT/iUdkGp7jlK4MLMsfoxkkH+IUpfvC/4zkQR+KayWsWR2h4gSxkgqOellIFjUOymJCt0M/rcN2Ufv0xdAEonPEjs9oreu6v4VzOKy0cSCrlP9zG1ZfQ7z+AtD0s99YuyyMGzpOQ9jUeKJkj8sBzNkD6KbtCpmeWs5IfIW0GOsEarnBH+Nr9P/sjEXh8hPBdm0ywambdyQzxC05EXsgts/pP6izOkb0pEUeQmfwbEgaDJSKmK3UcTarRNPwmk9sdrizNGslNR6AdmoabyNcky6wYIxvXuOJfJF5TJOcyVvesblJm4nuGbZDfAJJhn7dq2+62QlMrDDNM/LHS6gCDSLa2p2gE7HhZk/x3NtaRbKnDN8LeoZx5/ZMB3yaUaO8oV8ydwbOZEFBcGnTmsvzkZIy+vkPWF4YjKqCuMo4UJuNgHTv6DtYpUM+KIAHV8kmRDPP6CapShpxRyRpEyRL2oGtjmOk0/rkGEeeDOEHvAHnuzr2lRWXuvy
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(3023799007)(56012099006)(18002099003)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PaxaIqFMFh766Hy5EF+TUQpuWkd4wYyrYLGmeqJL/LWVG2Ato0Jg8Ptx9amL?=
 =?us-ascii?Q?unQR6ZCoG7TGwOBiF4GvbG8S+kOS8jVo/50yqfASNZ5I0eQPW9Q8CzOq4LhM?=
 =?us-ascii?Q?3JBddpSN4ZmZ8rq7WwBc1FgaMzYiUf47uzDpOtx5KlcK2C1yTFS+SnRBtTO8?=
 =?us-ascii?Q?lCjE3GTvvvC48v93r49uU2ZIcwsDIHx/EzGlx7fBAxQiCSO40EKzTu2X5WQf?=
 =?us-ascii?Q?oOuET8AywS2GCD74IYGE/pFumKmMF9q6xnLX26r5hJSFHbpUOzqVoYnuxtyK?=
 =?us-ascii?Q?ulV5XfCNYiF2dZ7dG96WsmoGmMp6PWrugch3ogr6PLf7W9Tp7dGYetaLDi/c?=
 =?us-ascii?Q?l6HkWDMsWHjqS50+s+RJT2R+Y5cxssUa3UkJA0fnCPSp27bvSDVrwqYjvRde?=
 =?us-ascii?Q?kBHRR7aBjK1QOym4p/1Umy2VwfWWzZvahLzhIkpE0U6vRkmIKKJsxtHc3YzG?=
 =?us-ascii?Q?aJcxvzsEGgIUeqUND3r+0XdfpzZwEC7rcBPoKZPyi6C9AycJFquWxFL9him4?=
 =?us-ascii?Q?+LoKFXqwuFVstUdY77cgxdWxoJEo4rve6rIzmUgbUHWCEb7MUlqsrsmY/e5e?=
 =?us-ascii?Q?yUw/fk0SiMeh7p5q8h5Tqx+vMNtSrBrt3IOG7VeIeQuE0KpGUzSv2ckWH7vV?=
 =?us-ascii?Q?8kT5C5OjS3uGHveIDbx65cf6kBC8WnB6AtR7UbPvqccNgm/9AeFtYarvOwCj?=
 =?us-ascii?Q?D/zHgSzc434Z/Bab9Mh0PM21FZi36P6MheN3IE7o8ufJplFHyxzfc+uNviAO?=
 =?us-ascii?Q?nJsphPwAkseomL/0mDS7dgoFQLmWamW1QXiBxmLftvhVaZmELw21SbLNgilJ?=
 =?us-ascii?Q?3Fv9f54x8vYI22SsWeVlgEYQ74mXk60+tEXcioaddmLhoTOO9QbBZ2XOu7G3?=
 =?us-ascii?Q?/yjQ0ud0FsG2UP7l6IWz5/idp/H/EIQatzTt5FUFaxuhJNEOdz+pcDQMuNDJ?=
 =?us-ascii?Q?5D4WT70yrUEZDBsrU/ertLr50vp7c24notCzIF+o6+UxrjrbLp8XTDKdeN1/?=
 =?us-ascii?Q?4WPNhBB+lGj93UOfNn8pdwlu6hPiqlDox2Exdxiop3YexK7EPlY1lwrdJZh/?=
 =?us-ascii?Q?4gGLGyWixcUmWs+yBv7gcF8yIdW2x2wsKHVbon8Xcx7EBi8CtmKe0ghcFa3W?=
 =?us-ascii?Q?pLaBiLXz809U2d72K++DzpAmvtkPptik9DVvvGPoNX15nR9++Noo2drwAFFE?=
 =?us-ascii?Q?3wcx0/+6gNwFwmOjdX/Ujt+xqae8f9v6PcB1arAfkNOe8VgSjkXj3lsWeZyr?=
 =?us-ascii?Q?dh3WjZLnA3EF94bqbgQyTmSnI/Ewdm+XHp0DWoOgasER9Pyyd+V/Izx6TROY?=
 =?us-ascii?Q?QVmfuAOoJaYzLvsPYVQWU7Z0PCwx+eN95j9KmSK3r7CH5P0MTFSIznuA3B/n?=
 =?us-ascii?Q?aKO7ABZtTT3oa+bq79Gt7N+H7+sFf+WZHW0lmGyBn5lw5T68qpIN/rT1UWLj?=
 =?us-ascii?Q?pJVL9c093n956oVidhHpgeKzjQVYjVasp5k/mYLdCkGx7K7OsR6cWeSsI5HF?=
 =?us-ascii?Q?m3VrpQfORdb7zW/zba0dP7TY0gkvO8OVS0CSw7GwQ/CosyKH7gCKSQGuE+tc?=
 =?us-ascii?Q?orsC20fjWcl4fmYSDgqsKvZTKlniBDNyoKh/mrcNSdHTlaGFj1qX0fof16C6?=
 =?us-ascii?Q?jeodxoQiiwCImDhWe9CRalQf34FY8W9BV91MZuZpERh7qyItUgiRdY2IFD21?=
 =?us-ascii?Q?ac4SeqHQWjU0yzOLkbjo9QHRiKWwl+7dTHws/7GMEOTxvJAc58LkAz4qok6L?=
 =?us-ascii?Q?zbWbRX63Kr6JFNhjiDdZxwlQZRjyxDTUZvftpR6HpusZqjWVfUcC?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 651c7071-3275-425a-79b1-08debfc1738b
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 09:37:52.3403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NkBGkARh6zr0joJGD0jzuINwrt1NlCIP9k5OO4nsVvUUMxod5FwHPfnxuvA5HRjaJiCmg4ijiYeQC3lqOC9WIP+cUHYSh3ms6nM34wpEIgN2HZW6+iMhW9k8lM3mJT+q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB0982

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

- the obsolete JH8100 compatible string is dropped, support for the new
  JHB100 SoC is added, and the schema is simplified to an enum.
- The driver is updated to handle the JHB100's specific hardware
  requirement where clocks must be disabled beforeasserting reset during
  teardown, to avoid glitches. This is implemented via a per-compatible
  data flag (SEQ_CLK_FIRSTfor JHB100, preserving SEQ_RST_FIRSTfor JH7110).
- Several Runtime Power Management (RPM) fixes are included to ensure
  proper autosuspend behavior, balanced runtime usage counting, and
  correct cleanup ordering on probe failure or device removal.

Lianfeng Ouyang (2):
  dt-bindings: rng: starfive,jh7110-trng: add jhb100, drop jh8100
  hwrng: starfive: rework clk/reset teardown order for JHB100 & fix RPM

 .../bindings/rng/starfive,jh7110-trng.yaml    |  10 +-
 MAINTAINERS                                   |   2 +-
 drivers/char/hw_random/jh7110-trng.c          | 191 ++++++++++++++----
 3 files changed, 152 insertions(+), 51 deletions(-)

--
2.43.0

