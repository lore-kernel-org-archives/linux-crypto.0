Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FE941C63
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jul 2024 11:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721216812; cv=fail; b=StxxVSI8glX0EzPUGpeFlKG7pWUJYSi9RWQnvjVwplDGX4UDyiMh4EYhgU3LrFuFWLHV0E0Krv04Ohzdk+RxDj4FokajgAYlTNr9uvjFSIhHyhewfNDHWr6uMtHsIiXKdc09UFnyOGGi8+lcgJkKkOKniresDZzKMUGV3Ow0/Pw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721216812; c=relaxed/simple;
	bh=gAx8372tY0EGB8c3RX6udjDo4RjCrPx7J6CMR7+S6vk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=V1cOswPSTGWiE83OAnpVD+AgeA/pYepHhrUoyfc51KUE+gq2oU2pGSbwkfCnEWooFtQl8idO6JXPlwtNu9NuylQr7z/Ww1IxGnRox894u/CEyz72BK1nHVyf9OZsxub0kK97cBDl4W2/Ew2qfqH08mdqylQWkZDhO7/4aU/MuLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bIght3ws; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bIght3ws"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721216810; x=1752752810;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=gAx8372tY0EGB8c3RX6udjDo4RjCrPx7J6CMR7+S6vk=;
  b=bIght3wsEjBemHLF7GXPBRqqmD97lRRovTzrN/6VrlxEMrdgRrYZrMwU
   IHl2tlIk4c50XC8z8hMzv3YVqndspZqRLwFTDDZzUo0hU9B/cIfWmCksH
   H/M+Jrm2/1ZKAkPAlH+sNzB69zE0ZqFsKyXK4i4VNuNad8lCoskUtNP6d
   RD1bmFlo1V42xAypx4DvOSF16Raf9I4WSh40nXxUZEMQrhcx9T5bb5qNV
   RTJoniKVWl7GaSzBaco/QZdV7kJ/Dfs1I8kKS50sI1JHPt71y/Kn/ItyX
   RwWudyctCjQ6njUfV+KjEERzs6jS14WzpJ/fFHM8uxsyhoOZalCsheTBm
   w==;
X-CSE-ConnectionGUID: a4ee/l+9SjeojVrXsEKt4g==
X-CSE-MsgGUID: ZaEiqEnLRsSR5V+xPysv7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="22572886"
X-IronPort-AV: E=Sophos;i="6.09,214,1716274800"; 
   d="scan'208";a="22572886"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2024 04:46:49 -0700
X-CSE-ConnectionGUID: pKnHb2lLQRC7AZBQMtaF5w==
X-CSE-MsgGUID: lsD75+zJRJ+RDgHhzUb0VA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,214,1716274800"; 
   d="scan'208";a="50971664"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Jul 2024 04:46:49 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 17 Jul 2024 04:46:48 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 17 Jul 2024 04:46:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 17 Jul 2024 04:46:48 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 17 Jul 2024 04:46:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rWHDVpvFPhOikPGiXFNDKlqEwrKOgJ7RmctFRDFa6Hdt+iY4X/BBOq3BJ8rRfU5sOV5x0VwWKzRLlluingzTbPesi4mkBAS06ujPQylF+FsGvCgCkaJEuJlyteS+amufbwBAlQWCnsjWS3tlX2VzjHAZIFgBJpzxdjJuOyx9HgESq/oSyMI3qq0vR2oExSaeBJ1RuqlgCa2KR4T7Fa1UxZ+IduZ0VYH3Nwyc3jYZnJvuEBd2sVXfsgAISmuMBpvO2j10fJKEQ7TWNh6aTtjFfaN9CUmcbuQFj50fKj6VM2gd46F/ywVetAIlg7KjNn7T22y3xTch7HgM+lM7f6e+qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nyXTAd7qGDr7POckqcydjmUc/q9J+IuqseLF7BUe7VQ=;
 b=IqgLipVGK/kHAa99wEbWzvQV57MIdGG/bH5dN4ya0GtUq68l8G/AWLu1zQISwbhcgSrmkGFXytQvtetT7twd8LikXoJ31uB659cbDmlZbTdmxLIKd6Ftx4C4xRRFkWDngyXSWcp2Gra140OTANvSEpqT3SSySefDAGpG8bgogUamnheQ2v3/WM1ITzSdH4NbL0f6TCMZhuUO3MT+x/VeNmDbnCjJje9nUnEZjpGkdcamXJhyT4zvBinzWWFGQEAuul6LMgGPYHLndqrSki1Ay7IImp60Zozd6baNfGp0fMqqZK+4JrNUYI1M+SwuO8QIMXaNvuhYSautU6+i/PRR+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by PH0PR11MB7710.namprd11.prod.outlook.com (2603:10b6:510:298::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Wed, 17 Jul
 2024 11:46:46 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::c80d:3b17:3f40:10d6]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::c80d:3b17:3f40:10d6%3]) with mapi id 15.20.7762.027; Wed, 17 Jul 2024
 11:46:46 +0000
From: Michal Witwicki <michal.witwicki@intel.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>, Adam Guerin
	<adam.guerin@intel.com>, Michal Witwicki <michal.witwicki@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Przemek Kitszel
	<przemyslaw.kitszel@intel.com>
Subject: [PATCH 1/5] crypto: qat - preserve ADF_GENERAL_SEC
Date: Wed, 17 Jul 2024 07:44:56 -0400
Message-ID: <20240717114544.364892-2-michal.witwicki@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240717114544.364892-1-michal.witwicki@intel.com>
References: <20240717114544.364892-1-michal.witwicki@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DBBPR09CA0046.eurprd09.prod.outlook.com
 (2603:10a6:10:d4::34) To PH0PR11MB5830.namprd11.prod.outlook.com
 (2603:10b6:510:129::20)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5830:EE_|PH0PR11MB7710:EE_
X-MS-Office365-Filtering-Correlation-Id: d35653ad-d484-428b-c394-08dca65622b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?sKLO0Zciq+xnLkTKEpB5PKq99U8l2BYgKJuVuLdEGycqZQpuGWmCvBNR+Qcb?=
 =?us-ascii?Q?MhhN7MSN/IYYcpmxfuy0dRHrZ42J/oU+JfsBjWHCSWHCD81hlnS25orFY0vH?=
 =?us-ascii?Q?QP0ihrUxVyN5a2/N057C9QIYJ7m5ZJUfp4VGwnHhfcONLVV3wUegSCMkEtt2?=
 =?us-ascii?Q?2Ut9Cue4Zqh+atfIOM4KD4WiqS5YxNqqWky6d6QU4D5lSTS5mNeRJTGAQkE5?=
 =?us-ascii?Q?JAckonxWl/G1kQBzUnHPEFPziPk/L8H03qoiTi9pd5pIZochBwnkW8ovPGDS?=
 =?us-ascii?Q?+d4rU2N+OV2Yqc846EGjKFEDMSQDSWDqKk1hlw9FFhFwz7njtlxnSB9qNI/6?=
 =?us-ascii?Q?VmF5dhnzb0OcTQDu9QhOlTZ1V8wMr4IeNsYNHiXiLNVZ/KtmLluEDPhzMD6Y?=
 =?us-ascii?Q?wSQR2C+MPZ0niu34f2+4hJzgRX5h7mWjyjMyYBi9MYzXuqLPYP68TmKHIlFP?=
 =?us-ascii?Q?aqWYPoKGo2HIfelha9E7YvuysOf+T21+sxRfoaJnyGC6xmefLXgGbwrNFalc?=
 =?us-ascii?Q?mfnza8TUleKqm5Ifj9KeBY3ucaZEnw6sEshdsb/Hf9lluLRT+lbtz3Xr8blF?=
 =?us-ascii?Q?E0rDEGPQRCLwu60NDO9gWl6pM0zHIpfekVo5asc5kYiWmZFwc7/WA1X9Nn4i?=
 =?us-ascii?Q?J7DaPfJaH0cGuEverX+k+nKtJeXfHgwQFo3To0AcXLhcj6bCtLocH0QtBqH4?=
 =?us-ascii?Q?QjtZVC3SELE7TB9CpFF3kGYhBx6GUcmzo+cq0kf7s3gxuJ3EZqsuZIk3ivmZ?=
 =?us-ascii?Q?GCkXRXBeQhSjwGXGDWDSKqEQaf7ARyDDwHAcB646HLtFBvXltmwrRhoBBAes?=
 =?us-ascii?Q?ecxexWz3PDyX0bMaetFa1vM8zUhuUPDR7Jag06Vx0dHZwjc5s0odp0oBvJTM?=
 =?us-ascii?Q?xw5pt/CJsigUF38CpxoAg5gaLMu0N3B88qYWNMFXRP5arad+XSVvlbu/McYD?=
 =?us-ascii?Q?KWlsWgzV9jf5oxKHRQKMTYetnmnUSjGwERk7bP7HFtYuZrDusTa+HCz8Lxrd?=
 =?us-ascii?Q?zn1UiObUKchkaFyGH28Tg4BdgMvwk4ccDGXRgh79eE/cWQBCUdX1gtvPl/Oj?=
 =?us-ascii?Q?2shTCfsSdtlW+Uzkxea3uVOHpBcHdSmnwFRy/5CClu7Z8OU/QWm3rMrk2Pug?=
 =?us-ascii?Q?HB8Fg7Za9s7xnLc1y0uN2qlG8o2x3Aw7SDM6FsHl19acZs2CMFs8eozUXrVa?=
 =?us-ascii?Q?D0Kwd+McqxQZmMEVV+wD3S6lLlhmY0Zr0ZCYuuW1E0Aa0Ey5yrutjsWWJVUt?=
 =?us-ascii?Q?QyyDNi9VJVf7Qws4XK4dBTq3pEXoSDNgytmPazQdBSdMztEEBRu7ZzRRaDzy?=
 =?us-ascii?Q?Smhvlre3Ru5e7Y9cz9zA/dQmpm0EjYucf0NJHnCW2HWI1w=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z8qxAZMEcEwve/PZtHDxdPCoUpu/tMxnpskRUQM9ej7CDzmadNMeJbnaC58v?=
 =?us-ascii?Q?4B4q6VkBBFr7Fa4E5eYTt1Uh1IySjSx++hQsrJ0ZaHkChi08OBla2T39EQxp?=
 =?us-ascii?Q?q21wp6h1yg8QrX15OzUR5Uiw/VxB8m5ACC7+p5NI7TLqMPO+vg0Mia54KSjv?=
 =?us-ascii?Q?inEysGWIimMKKTxkRng4IPbGpaNVFQU3yZhUJDvTW9DJHGUSPMug0XgB/g50?=
 =?us-ascii?Q?hoXMwmFJv0OArFYQuHZyrv7WUUBWjVa1jvgRR+ahxrFIKRRFPzeWUU2BueLr?=
 =?us-ascii?Q?/OuXoP+aebPom3+L0RPt0RGe3RPJ9Q2MWK6XRE9F7t3fSNzLfTBhRfNjdsgJ?=
 =?us-ascii?Q?u6KxyZvllI/S852D/yhjfKO29zH+KKUVTIqjZe2JdM3VKXbwx+qEI3dLew82?=
 =?us-ascii?Q?c2AuUgB6L5QojmbXW1n+MwycoC7wPgaFm5AyNZsv3PxvUvKBPkuQGDUjd7P4?=
 =?us-ascii?Q?R8V8RLuicyee7rJMMEO3LyDSIfVSd/wrkj9lNgp0N7hHORs7UB7aU7MTjWOU?=
 =?us-ascii?Q?v6r0SW+qMgpZODbc1BQ+uAw4yiS6QoeitDdgr/6e+G19XdG2Z+HX73fr27QP?=
 =?us-ascii?Q?6K3aDvMn4nobKyOnNJDKMk/0GG9Z+p4eZfaYlnAuQOtsZvDEf7ApxMtbFQel?=
 =?us-ascii?Q?7p6SGKWR74qi1Pwiv04WaYNlXpD7SADr6LOb9QTnqR22vJ1bxPzfAOEQap5q?=
 =?us-ascii?Q?maVpyLBvWCfcdyT+fGDICnVB8I0XbESHxE+CVhrHyfXNUvsSHPju3dlcc0mz?=
 =?us-ascii?Q?kflFJCU/Lewp6bvP/k6dFxjyBhnIVlKU+6ngkF1pYI3jQ2Hj1y7+JghHvRyI?=
 =?us-ascii?Q?5HM0CUFclyIh4/XsIk1JTi6adrOtpnNA6x8h0E124sQElzbeK8dGjBRcNH01?=
 =?us-ascii?Q?QJcuN0yErmaIHImT5B4y0fKh+aYE7/7f3pPvcV6PKe6aPufT+rzSa8VISQ+n?=
 =?us-ascii?Q?iOrEzM9s4CPzHQFO61FDrt+86rDXrW1djtyFWtqsSAfSXsDKGvLAmkGmPfRb?=
 =?us-ascii?Q?p4dRkhpwNqWXkkgG0MW5qp5SyaTfPFXr4hLQUUzTwGVASSWjCOt3HNkSfqE9?=
 =?us-ascii?Q?/Xg7/OjL6cw9P83remFZHzw3/pgJOo5dTzBU0CbFGjiin67sPElAXypkb9Ut?=
 =?us-ascii?Q?W1VjrEHx2ljAHKteMOLROCdA25IYmKUm2CdVvdM05L9k3JRmTW7Q9Kem/9D/?=
 =?us-ascii?Q?7l3eM7u2SVfzOjeoTSjV1WAfVTrZIcwPvTkVAFe/RRqLRRiNltFVm94S4pKe?=
 =?us-ascii?Q?06F+0TAgFh7ZwDfevi1+KDraYz0uxx5R8osBWgNFFEtQF/KBYZ7ehHKzefLt?=
 =?us-ascii?Q?RqGQijaDUUEFBTSycaT+6p6xGG5qgP1tCrSK3+62l3QR8C6cgAMjsO4GQ0LM?=
 =?us-ascii?Q?vrSX69v8CE5bjrXMuu/mAD8SnlXWrTUbUTwIyUCUpPHMvSAY9mxCEnfjKdox?=
 =?us-ascii?Q?wPksfzWfpA9eFoTmTin8WFCJinTYQ6b9QDrMHM2zASUM3RolPn7MPzC/PAHy?=
 =?us-ascii?Q?hpRdxu0nO3msayCQ4TS7mJfxZ1BA8Kp4KcZjDHE6SZ60k1PsSTku4A/YiVdT?=
 =?us-ascii?Q?zsRBUGru93iLgjEiHPMnNC0QKdXaJrwS9fukRHKwlzcXOk6mbA8hI2DhbWIL?=
 =?us-ascii?Q?4A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d35653ad-d484-428b-c394-08dca65622b7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5830.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2024 11:46:46.1246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tk+YXIGrZhw86P27O8YOPJIsiRKP5ADnNFG8Gys9wGnw03NaILwjxMuruhaROSNWqCUKys7Cvsx402j4TtP+QNysfuQIExSUHcbglI5YxPY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7710
X-OriginatorOrg: intel.com

From: Adam Guerin <adam.guerin@intel.com>

The ADF_GENERAL_SEC configuration section contains values that must be
preserved during state transitions (down -> up, up -> down).
This patch modifies the logic in adf_dev_shutdown() to maintain all
key values within this section, rather than selectively saving and
restoring only the ADF_SERVICES_ENABLED attribute.

To achieve this, a new function has been introduced that deletes all
configuration sections except for the one specified by name.
This function is invoked during adf_dev_down(), with ADF_GENERAL_SEC
as the argument. Consequently, the adf_dev_shutdown_cache_cfg() function
has been removed as it is now redundant.

Additionally, this patch eliminates the cache_config parameter from
the adf_dev_down() function since ADF_GENERAL_SEC should always be
retained. This change does not cause any side effects because all
entries in the key-value store are cleared when a module is unloaded.

Signed-off-by: Adam Guerin <adam.guerin@intel.com>
Co-developed-by: Michal Witwicki <michal.witwicki@intel.com>
Signed-off-by: Michal Witwicki <michal.witwicki@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
---
 drivers/crypto/intel/qat/qat_420xx/adf_drv.c  |  4 +-
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   |  4 +-
 drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c  |  4 +-
 .../crypto/intel/qat/qat_c3xxxvf/adf_drv.c    |  4 +-
 drivers/crypto/intel/qat/qat_c62x/adf_drv.c   |  4 +-
 drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c |  4 +-
 drivers/crypto/intel/qat/qat_common/adf_aer.c |  2 +-
 drivers/crypto/intel/qat/qat_common/adf_cfg.c | 29 ++++++++++++++
 drivers/crypto/intel/qat/qat_common/adf_cfg.h |  2 +
 .../intel/qat/qat_common/adf_common_drv.h     |  2 +-
 .../crypto/intel/qat/qat_common/adf_ctl_drv.c |  6 +--
 .../crypto/intel/qat/qat_common/adf_init.c    | 40 ++-----------------
 .../crypto/intel/qat/qat_common/adf_sriov.c   |  2 +-
 .../crypto/intel/qat/qat_common/adf_sysfs.c   |  4 +-
 .../crypto/intel/qat/qat_common/adf_vf_isr.c  |  2 +-
 .../crypto/intel/qat/qat_dh895xcc/adf_drv.c   |  4 +-
 .../crypto/intel/qat/qat_dh895xccvf/adf_drv.c |  4 +-
 17 files changed, 60 insertions(+), 61 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_drv.c b/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
index 2a3598409eeb..f49818a13013 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
@@ -163,7 +163,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return ret;
 
 out_err_dev_stop:
-	adf_dev_down(accel_dev, false);
+	adf_dev_down(accel_dev);
 out_err:
 	adf_cleanup_accel(accel_dev);
 	return ret;
@@ -177,7 +177,7 @@ static void adf_remove(struct pci_dev *pdev)
 		pr_err("QAT: Driver removal failed\n");
 		return;
 	}
-	adf_dev_down(accel_dev, false);
+	adf_dev_down(accel_dev);
 	adf_cleanup_accel(accel_dev);
 }
 
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
index d26564cebdec..659905e45950 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
@@ -165,7 +165,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return ret;
 
 out_err_dev_stop:
-	adf_dev_down(accel_dev, false);
+	adf_dev_down(accel_dev);
 out_err:
 	adf_cleanup_accel(accel_dev);
 	return ret;
@@ -179,7 +179,7 @@ static void adf_remove(struct pci_dev *pdev)
 		pr_err("QAT: Driver removal failed\n");
 		return;
 	}
-	adf_dev_down(accel_dev, false);
+	adf_dev_down(accel_dev);
 	adf_cleanup_accel(accel_dev);
 }
 
diff --git a/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
index 956a4c85609a..4d18057745d4 100644
--- a/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
@@ -202,7 +202,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return ret;
 
 out_err_dev_stop:
-	adf_dev_down(accel_dev, false);
+	adf_dev_down(accel_dev);
 out_err_free_reg:
 	pci_release_regions(accel_pci_dev->pci_dev);
 out_err_disable:
@@ -221,7 +221,7 @@ static void adf_remove(struct pci_dev *pdev)
 		pr_err("QAT: Driver removal failed\n");
 		return;
 	}
-	adf_dev_down(accel_dev, false);
+	adf_dev_down(accel_dev);
 	adf_cleanup_accel(accel_dev);
 	adf_cleanup_pci_dev(accel_dev);
 	kfree(accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c
index a8de9cd09c05..f0023cfb234c 100644
--- a/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c
@@ -176,7 +176,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return ret;
 
 out_err_dev_stop:
-	adf_dev_down(accel_dev, false);
+	adf_dev_down(accel_dev);
 out_err_free_reg:
 	pci_release_regions(accel_pci_dev->pci_dev);
 out_err_disable:
@@ -196,7 +196,7 @@ static void adf_remove(struct pci_dev *pdev)
 		return;
 	}
 	adf_flush_vf_wq(accel_dev);
-	adf_dev_down(accel_dev, false);
+	adf_dev_down(accel_dev);
 	adf_cleanup_accel(accel_dev);
 	adf_cleanup_pci_dev(accel_dev);
 	kfree(accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_c62x/adf_drv.c b/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
index ad0ca4384998..e6b5de55434e 100644
--- a/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
@@ -202,7 +202,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return ret;
 
 out_err_dev_stop:
-	adf_dev_down(accel_dev, false);
+	adf_dev_down(accel_dev);
 out_err_free_reg:
 	pci_release_regions(accel_pci_dev->pci_dev);
 out_err_disable:
@@ -221,7 +221,7 @@ static void adf_remove(struct pci_dev *pdev)
 		pr_err("QAT: Driver removal failed\n");
 		return;
 	}
-	adf_dev_down(accel_dev, false);
+	adf_dev_down(accel_dev);
 	adf_cleanup_accel(accel_dev);
 	adf_cleanup_pci_dev(accel_dev);
 	kfree(accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c
index 53b8ddb63364..2bd5b0ff00e3 100644
--- a/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c
@@ -176,7 +176,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return ret;
 
 out_err_dev_stop:
-	adf_dev_down(accel_dev, false);
+	adf_dev_down(accel_dev);
 out_err_free_reg:
 	pci_release_regions(accel_pci_dev->pci_dev);
 out_err_disable:
@@ -196,7 +196,7 @@ static void adf_remove(struct pci_dev *pdev)
 		return;
 	}
 	adf_flush_vf_wq(accel_dev);
-	adf_dev_down(accel_dev, false);
+	adf_dev_down(accel_dev);
 	adf_cleanup_accel(accel_dev);
 	adf_cleanup_pci_dev(accel_dev);
 	kfree(accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index 04260f61d042..ec7913ab00a2 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -44,7 +44,7 @@ static pci_ers_result_t adf_error_detected(struct pci_dev *pdev,
 	adf_pf2vf_notify_restarting(accel_dev);
 	adf_pf2vf_wait_for_restarting_complete(accel_dev);
 	pci_clear_master(pdev);
-	adf_dev_down(accel_dev, false);
+	adf_dev_down(accel_dev);
 
 	return PCI_ERS_RESULT_NEED_RESET;
 }
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg.c b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
index 2cf102ad4ca8..b0fc453fa3fb 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
@@ -100,6 +100,8 @@ void adf_cfg_dev_dbgfs_rm(struct adf_accel_dev *accel_dev)
 }
 
 static void adf_cfg_section_del_all(struct list_head *head);
+static void adf_cfg_section_del_all_except(struct list_head *head,
+					   const char *section_name);
 
 void adf_cfg_del_all(struct adf_accel_dev *accel_dev)
 {
@@ -111,6 +113,17 @@ void adf_cfg_del_all(struct adf_accel_dev *accel_dev)
 	clear_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
 }
 
+void adf_cfg_del_all_except(struct adf_accel_dev *accel_dev,
+			    const char *section_name)
+{
+	struct adf_cfg_device_data *dev_cfg_data = accel_dev->cfg;
+
+	down_write(&dev_cfg_data->lock);
+	adf_cfg_section_del_all_except(&dev_cfg_data->sec_list, section_name);
+	up_write(&dev_cfg_data->lock);
+	clear_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
+}
+
 /**
  * adf_cfg_dev_remove() - Clears acceleration device configuration table.
  * @accel_dev:  Pointer to acceleration device.
@@ -185,6 +198,22 @@ static void adf_cfg_section_del_all(struct list_head *head)
 	}
 }
 
+static void adf_cfg_section_del_all_except(struct list_head *head,
+					   const char *section_name)
+{
+	struct list_head *list, *tmp;
+	struct adf_cfg_section *ptr;
+
+	list_for_each_prev_safe(list, tmp, head) {
+		ptr = list_entry(list, struct adf_cfg_section, list);
+		if (!strcmp(ptr->name, section_name))
+			continue;
+		adf_cfg_keyval_del_all(&ptr->param_head);
+		list_del(list);
+		kfree(ptr);
+	}
+}
+
 static struct adf_cfg_key_val *adf_cfg_key_value_find(struct adf_cfg_section *s,
 						      const char *key)
 {
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg.h b/drivers/crypto/intel/qat/qat_common/adf_cfg.h
index c0c9052b2213..2afa6f0d15c5 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg.h
@@ -35,6 +35,8 @@ void adf_cfg_dev_dbgfs_add(struct adf_accel_dev *accel_dev);
 void adf_cfg_dev_dbgfs_rm(struct adf_accel_dev *accel_dev);
 int adf_cfg_section_add(struct adf_accel_dev *accel_dev, const char *name);
 void adf_cfg_del_all(struct adf_accel_dev *accel_dev);
+void adf_cfg_del_all_except(struct adf_accel_dev *accel_dev,
+			    const char *section_name);
 int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
 				const char *section_name,
 				const char *key, const void *val,
diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index 3bec9e20bad0..f7ecabdf7805 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -56,7 +56,7 @@ int adf_service_register(struct service_hndl *service);
 int adf_service_unregister(struct service_hndl *service);
 
 int adf_dev_up(struct adf_accel_dev *accel_dev, bool init_config);
-int adf_dev_down(struct adf_accel_dev *accel_dev, bool cache_config);
+int adf_dev_down(struct adf_accel_dev *accel_dev);
 int adf_dev_restart(struct adf_accel_dev *accel_dev);
 
 void adf_devmgr_update_class_index(struct adf_hw_device_data *hw_data);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
index 26a1662fafbb..70fa0f6497a9 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
@@ -247,7 +247,7 @@ static void adf_ctl_stop_devices(u32 id)
 			if (!accel_dev->is_vf)
 				continue;
 
-			adf_dev_down(accel_dev, false);
+			adf_dev_down(accel_dev);
 		}
 	}
 
@@ -256,7 +256,7 @@ static void adf_ctl_stop_devices(u32 id)
 			if (!adf_dev_started(accel_dev))
 				continue;
 
-			adf_dev_down(accel_dev, false);
+			adf_dev_down(accel_dev);
 		}
 	}
 }
@@ -319,7 +319,7 @@ static int adf_ctl_ioctl_dev_start(struct file *fp, unsigned int cmd,
 	if (ret) {
 		dev_err(&GET_DEV(accel_dev), "Failed to start qat_dev%d\n",
 			ctl_data->device_id);
-		adf_dev_down(accel_dev, false);
+		adf_dev_down(accel_dev);
 	}
 out:
 	kfree(ctl_data);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index 74f0818c0703..593fe9abe88c 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -393,9 +393,9 @@ static void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 		clear_bit(ADF_STATUS_IRQ_ALLOCATED, &accel_dev->status);
 	}
 
-	/* Delete configuration only if not restarting */
+	/* If not restarting, delete all cfg sections except for GENERAL */
 	if (!test_bit(ADF_STATUS_RESTARTING, &accel_dev->status))
-		adf_cfg_del_all(accel_dev);
+		adf_cfg_del_all_except(accel_dev, ADF_GENERAL_SEC);
 
 	if (hw_data->exit_arb)
 		hw_data->exit_arb(accel_dev);
@@ -445,33 +445,7 @@ void adf_error_notifier(struct adf_accel_dev *accel_dev)
 	}
 }
 
-static int adf_dev_shutdown_cache_cfg(struct adf_accel_dev *accel_dev)
-{
-	char services[ADF_CFG_MAX_VAL_LEN_IN_BYTES] = {0};
-	int ret;
-
-	ret = adf_cfg_get_param_value(accel_dev, ADF_GENERAL_SEC,
-				      ADF_SERVICES_ENABLED, services);
-
-	adf_dev_stop(accel_dev);
-	adf_dev_shutdown(accel_dev);
-
-	if (!ret) {
-		ret = adf_cfg_section_add(accel_dev, ADF_GENERAL_SEC);
-		if (ret)
-			return ret;
-
-		ret = adf_cfg_add_key_value_param(accel_dev, ADF_GENERAL_SEC,
-						  ADF_SERVICES_ENABLED,
-						  services, ADF_STR);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
-int adf_dev_down(struct adf_accel_dev *accel_dev, bool reconfig)
+int adf_dev_down(struct adf_accel_dev *accel_dev)
 {
 	int ret = 0;
 
@@ -480,15 +454,9 @@ int adf_dev_down(struct adf_accel_dev *accel_dev, bool reconfig)
 
 	mutex_lock(&accel_dev->state_lock);
 
-	if (reconfig) {
-		ret = adf_dev_shutdown_cache_cfg(accel_dev);
-		goto out;
-	}
-
 	adf_dev_stop(accel_dev);
 	adf_dev_shutdown(accel_dev);
 
-out:
 	mutex_unlock(&accel_dev->state_lock);
 	return ret;
 }
@@ -535,7 +503,7 @@ int adf_dev_restart(struct adf_accel_dev *accel_dev)
 	if (!accel_dev)
 		return -EFAULT;
 
-	adf_dev_down(accel_dev, false);
+	adf_dev_down(accel_dev);
 
 	ret = adf_dev_up(accel_dev, false);
 	/* if device is already up return success*/
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sriov.c b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
index 8d645e7e04aa..baf2e1cc1121 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
@@ -192,7 +192,7 @@ int adf_sriov_configure(struct pci_dev *pdev, int numvfs)
 			return -EBUSY;
 		}
 
-		ret = adf_dev_down(accel_dev, true);
+		ret = adf_dev_down(accel_dev);
 		if (ret)
 			return ret;
 	}
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
index 4e7f70d4049d..4fcd61ff70d1 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
@@ -62,7 +62,7 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 			break;
 		}
 
-		ret = adf_dev_down(accel_dev, true);
+		ret = adf_dev_down(accel_dev);
 		if (ret)
 			return ret;
 
@@ -76,7 +76,7 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 		} else if (ret) {
 			dev_err(dev, "Failed to start device qat_dev%d\n",
 				accel_id);
-			adf_dev_down(accel_dev, true);
+			adf_dev_down(accel_dev);
 			return ret;
 		}
 		break;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c b/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
index cdbb2d687b1b..783ee8c0fc14 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
@@ -71,7 +71,7 @@ static void adf_dev_stop_async(struct work_struct *work)
 	struct adf_accel_dev *accel_dev = stop_data->accel_dev;
 
 	adf_dev_restarting_notify(accel_dev);
-	adf_dev_down(accel_dev, false);
+	adf_dev_down(accel_dev);
 
 	/* Re-enable PF2VF interrupts */
 	adf_enable_pf2vf_interrupts(accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
index 40b456b8035b..2a50cce41515 100644
--- a/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
@@ -202,7 +202,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return ret;
 
 out_err_dev_stop:
-	adf_dev_down(accel_dev, false);
+	adf_dev_down(accel_dev);
 out_err_free_reg:
 	pci_release_regions(accel_pci_dev->pci_dev);
 out_err_disable:
@@ -221,7 +221,7 @@ static void adf_remove(struct pci_dev *pdev)
 		pr_err("QAT: Driver removal failed\n");
 		return;
 	}
-	adf_dev_down(accel_dev, false);
+	adf_dev_down(accel_dev);
 	adf_cleanup_accel(accel_dev);
 	adf_cleanup_pci_dev(accel_dev);
 	kfree(accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c
index d59cb1ba2ad5..7cb015b55122 100644
--- a/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c
@@ -176,7 +176,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return ret;
 
 out_err_dev_stop:
-	adf_dev_down(accel_dev, false);
+	adf_dev_down(accel_dev);
 out_err_free_reg:
 	pci_release_regions(accel_pci_dev->pci_dev);
 out_err_disable:
@@ -196,7 +196,7 @@ static void adf_remove(struct pci_dev *pdev)
 		return;
 	}
 	adf_flush_vf_wq(accel_dev);
-	adf_dev_down(accel_dev, false);
+	adf_dev_down(accel_dev);
 	adf_cleanup_accel(accel_dev);
 	adf_cleanup_pci_dev(accel_dev);
 	kfree(accel_dev);
-- 
2.44.0

