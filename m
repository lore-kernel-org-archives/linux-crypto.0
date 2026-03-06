Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C0E495503
	for <linux-crypto@vger.kernel.org>; Fri,  6 Mar 2026 22:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772835240; cv=fail; b=fpXSNsq/JRDFrFjv4Z2mxensR90bxl4j+R4RZEbJ9WFgY+EQtfkKaZroa21QNo2SgM9UhTILVAF+okPwQIgbsaqHO87ynnx8iZlMN1KpwPb8FsviLLzLlkCbB5t2+42/UIB23cJj/LVD1st7TgO2ODMTgifWmL5+WSpxfxmCKpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772835240; c=relaxed/simple;
	bh=Gjtp7Y6u7hyaQtADUAqc6XefbvZ5fIcWmO4mFs8GL9k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QCp+sC7YqgAMPHy/BWnJt4XJ5S1se5lMArsA4yezC0IDXazonKh0Dv9EXSKom1rYs93blTfnmTKVlDzYvK3OvT6lZFojZlNw/ElIT0YPhqGsZykQ/QdVPLtkak5rBMBTCHQUhCEztxXJdoNTutMAvGps0E7gLpAifAjIQ9UdiVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lamgPWE/; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lamgPWE/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772835239; x=1804371239;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Gjtp7Y6u7hyaQtADUAqc6XefbvZ5fIcWmO4mFs8GL9k=;
  b=lamgPWE/fZLKkuN7JCPhCDO0xsDzMo/XASsBY5ONmwPortX06k+2p5gi
   dVC8syAJnKjCfL+i6foNlhKOL0KYop4pis0wJ3szFGPtlgfCtxEyGr0gm
   o/GXdG0NfUnTAiuTzszCI6Fu+VjgNCU56OWQednm8jlIWhu5aC89JvYPE
   VR9GNIP7WUL29pvb/zxbSrAsLf6Cb5er69psKBiu2U+2Ej5L+DF402Unf
   25Z5bxzemPnTAB09S4S8L9/SB1iDY1P7Di7h3fd2AnPBUcpTjKNmMw3Ne
   gax/dVid72sXI1uzKF2dipFvslvejAxyH/zXlQ+4hRMixE6hfdRJzbANf
   A==;
X-CSE-ConnectionGUID: ej/oQ1A0QfyZAFRljMsoew==
X-CSE-MsgGUID: EUV0Mx7iR+uzwVM76o1Njw==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="84660929"
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="84660929"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 14:13:56 -0800
X-CSE-ConnectionGUID: vnfuB3SRQbm0rZO68cdVyQ==
X-CSE-MsgGUID: EcSIJUfGRoaXL94Yf8U5Ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="223823516"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 14:13:55 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 14:13:54 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 6 Mar 2026 14:13:54 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.9) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 14:13:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ix6ZhaHKduJhKr3xr3jzqPTClcMCTI+HKWCYWdW5eRxR3r9jw9dS73vmiUoJWeO/t78t+8VQrIytDy/CDHxdwuk2PFxZiKXy92vzICCb6ptEZHeITFeva2J65tAfescx4mVt9+kHxrlAfgfKEbn11lIntDFSqIOFsofE1r4OR26qzQ90XZTC9gjVR1XZrsRRyU8ESRpLr4A9w4hjxFE5bugw20rZQWfey2R9lzAgsGdt4zN2aljd19E/UoKeEI3zPfsmOvAgf8iU4KlEqg40sYe+EjekfSdKiU7NYQ353SuXj/+yQfcymYpFeXmbf0Gcq/zl396TN42BczfZpDxCfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KblOWhUx7qO7Ffl/SSsgNujlULuo+Kx+0y5Pu0DG6z4=;
 b=d356w5VVrH3qClVOQObSCSh3XrtKYCsi/NUYpgoI/gERMujNxLucyru9/kGirMoFek72vg6p3McfOSO6D9zJXQmWDKmxQleEuv87CHs3sNxhvJ5DZR9BXBIoh+4x/orOJNezUpdk8QMbgZTFVO42RyFQmK2miS0erTAEvfNUgsdcPeynxi4+UGFX+GhE3q7DiAqFSAB0jNAvNYqgigkHivSoo75ZZFKInR58gaFJQ3fOnG+qmNAvwmfeseOe51C+K+6rVNZ35O83zR38R4BOTpxGVjMOegAAsAU9ms+KYThm8JLQZ6b/h/1udbafiLPXtadUQfJxkJ7/HTceDUJ2yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB6407.namprd11.prod.outlook.com (2603:10b6:8:b4::11) by
 IA3PR11MB9422.namprd11.prod.outlook.com (2603:10b6:208:57e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Fri, 6 Mar
 2026 22:13:51 +0000
Received: from DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4]) by DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4%6]) with mapi id 15.20.9700.003; Fri, 6 Mar 2026
 22:13:49 +0000
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, qat-linux
	<qat-linux@intel.com>, "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Subject: RE: [PATCH 1/8] crypto: iaa - fix per-node CPU counter reset in
 rebalance_wq_table()
Thread-Topic: [PATCH 1/8] crypto: iaa - fix per-node CPU counter reset in
 rebalance_wq_table()
Thread-Index: AQHcrbXa/9nR66lmn0y89dUkGuShNbWiEXdw
Date: Fri, 6 Mar 2026 22:13:49 +0000
Message-ID: <DM4PR11MB640764C9FB88989295F18AAD827AA@DM4PR11MB6407.namprd11.prod.outlook.com>
References: <20260307031003.28499-1-giovanni.cabiddu@intel.com>
In-Reply-To: <20260307031003.28499-1-giovanni.cabiddu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB6407:EE_|IA3PR11MB9422:EE_
x-ms-office365-filtering-correlation-id: d5f8cfb4-8470-4721-3b2f-08de7bcda4cc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007|38070700021;
x-microsoft-antispam-message-info: 5gergUFYKRIy8szQ8x038rv4kuEWWXSiBpYcxFVetKhFJTYVDuVqgLJ7Ge5BPPbZVX0pxG2fSdl3lwRb/PCpb1p4OnL7Y8Hjh9VA1K01YjcQ1eLp3Iu7MqiZd0XJLl7WgjqbCqrsSLrMpQsxziGMSfkDMur64JaCj/9HcvTGlIih3X9anFT9+98fO7vaywrQScYsVqEFaWdM04940YbWGYb6hDp5uY5XDMjgyxw3UOFvCl7itIN62qnlxNBEmxiqb/3XjhA61eZIyKaG/FbG7ycBtZECvxSQXOw1mnxJFYIRMOR4B8b66PYU4GnepDdJTCF9wnJ4iMNgE/MwKGPA9WrPM3Z9fWAd3FgVQuh5ttPknteKaEUeehDMpWs7P/E4kewZDrm/4d0YjY9CcULRIM22MXnEDY8IqR1fXZcDW7mQz/nYTVOqpiUcTQmKdnJPk9RD/TGYM/I+uaxWpJ8WHIe668wW6YEod7oeW9mwWwOPRcpVhXKBs6OppSylUUfghx5wHodlnApUYBqyy56eMxROS/4+tZUEfPZqHJuqO/mTh0epy9XufM/lR64/wx3WOUPXYuE6zFf+Uau92ahlil2ndOIucrFTdURX30isOiFLOJ5zN0JptNXhqMh6Sj3ecLSKgmLajhccTIzH37FQG6IL+E/KUkeZd8IJc2zbR5T+q4xAU6AFOxjVSz95ymFt3n8wVtgiujC7n0zhTi/ua7NTArra48v7VVwJuo0PpC6uW/08SONSz4LQV2+PwE5QlKSer2va67oWDnBVPvNSyWMM3IciTnqzx001glfe90E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6407.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UFl13UY7u3VdSzDM/dadjXjBQaEMDLtcvXLQW710U0rphNcpT+VKDdpTg2Rw?=
 =?us-ascii?Q?nykKsT+xd0hV+6a8GEJOqH79WW2ev18H8FeJaD+3r6gFkO/BIo1cBxp/fBcF?=
 =?us-ascii?Q?MeIh7+VxUBJ1UAir3gGTBeKwoeS66+MqaxhDCJT+R17j49pxYbl2tkswuZwK?=
 =?us-ascii?Q?Zuuipwl47j7EqCUGAzPA+1hbQNd58OqsMFxBBdRi0yy3l+SHm6NF7iW8kIEF?=
 =?us-ascii?Q?ZFqeOgN6utpQjq6XU/svEw5VI8wQifT5vLVfCHz7jTICckdq46d9pROHD6gJ?=
 =?us-ascii?Q?oje+dbc24J9+IkQvJAmm6xNeAvU0O0A7MEC62GJComIpaSysB5JrmH2anuhA?=
 =?us-ascii?Q?yHDhsLENIIND2Q7SzOpNho5CMPdP8/YFwF3CisgBHb3zTZYdICHwFIaK5slh?=
 =?us-ascii?Q?ZkwFWeNQIHa57+MSTtIxJQKj5C1Ie2J2d7vLFP4R/Gu2A2l/G2M2WJZIGRdc?=
 =?us-ascii?Q?Xrp54Vn3f83CYpOUp6otKHAgusm3eqBo00Q0jecyv27EKAfe+5xz4pYUj/Ke?=
 =?us-ascii?Q?UsPfyYenSiA32D5zNmtnJhbDumNJtLYd1ShSIal2YPHrreldWW2xi6FKx9Fs?=
 =?us-ascii?Q?5RKRW9/sMvf9aRJ1DBJAv5/EmxKzZiMT6WfT6OB6FX6FosUISzpO25TFubav?=
 =?us-ascii?Q?jFKMyYeOjZ1hAF5BpIQrF6BPqpDA4o3BgG+Vspy2072sdonVSDPFRSyGPXwi?=
 =?us-ascii?Q?K1a0ylYivwC94SmAnlY3A35420YmDtdKbBAnwtvSCneuPMX91NyF7p7ux/9G?=
 =?us-ascii?Q?dNJLwD+Tc6pmAXuBSZWhaaoW+C8L6b4+1sE5+2ol4edATxniWtwhpXQqDZ0U?=
 =?us-ascii?Q?UOxx1JJb7frsx0uK1r9evmjuHutoJYI4RCwrJIo3KE8tWs1R8xTl5JjKQ/3u?=
 =?us-ascii?Q?a/uCNlX7QUOOQr4ilzgndMXrRIAHYZCJRK/JS8P0ipUOv2VhM/ipbPp3Ox+5?=
 =?us-ascii?Q?bxLIYAlP7JhtirT0axmfnG4HX0SEB0w574riFPWU/l6JKP7bCgdjlQwb24oI?=
 =?us-ascii?Q?KvVlzN2N7oTjlT64luERm3k9k4lfrEgcLGAtzXvIJvq6+8phU4Xq+p2pV+dk?=
 =?us-ascii?Q?A/lKJQdDzDUFhgd7CZkYAvnI0gZPeywpLm/UR4WtOv+VILydju1K+rytyl+w?=
 =?us-ascii?Q?g1Prg+566ix7+aIxLloNePDNaL24Dl99CfpcVxmL6HXq3VYAghOg84qa/hjV?=
 =?us-ascii?Q?TvdSG15zOrLZ4wxagWTPJxBkgcynnPHDhiPqjFT1alytAd0SBwEPv8szyXV3?=
 =?us-ascii?Q?M28lV/nVHExgTFHW149bYsB4ZmGP7RdHEv93F9bf2rJGj20jaXxZIVPR2lKh?=
 =?us-ascii?Q?2H4AXz0Lr3UvBEDpMBVhaDU1EJPJg10DGdKV9kIjOIxaQd9U4JHeoXUieCXt?=
 =?us-ascii?Q?w2Alk6a7aX4OQ+N9A8zAWvoAy4NnKRAChpRyaY/ZRgZ3ta92cITY83PzlLsq?=
 =?us-ascii?Q?LaUprF4fLwZWyVtkbXE3wnWE9yzLoTkFo9zXg2AoRWsp3688bmGmVX4+RePc?=
 =?us-ascii?Q?jtR+iUQAXyL6h7ZF9ORFhXi+Psn3naXm39jYSHYOxjoqB+HPvf61d8kJcV6P?=
 =?us-ascii?Q?pGbOKH6wLuPCHQifIPJsNvmEkjGtPYbghFpVaK6PD3EvNUnWHfgRF7U65W7C?=
 =?us-ascii?Q?dSBFZGkzTKqxfJ+0BGSeg9WsMt3oXcWcJUtUpJ5zH+G30vPjyBrmGLk8kplE?=
 =?us-ascii?Q?67L/HF04jFenGmUnSYn47HVGkvxFYv3wx/P8/9im/oqOqyfuvzmv6ziga2SS?=
 =?us-ascii?Q?OHnz+puRRw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6407.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5f8cfb4-8470-4721-3b2f-08de7bcda4cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2026 22:13:49.5994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JiC39PGmJanEk00YLHNJF6ZQdHEEm7sl8M+vVWyDG5zJPSeyPgurbJzsiq/oNTkpw7H4uaErf5DyjHSjdzZdn+/aX6fmHXnAUNZKCYyO7pk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9422
X-OriginatorOrg: intel.com

Ignore this. Was sent by mistake.

Regards,

--=20
Giovanni

-----Original Message-----
From: Cabiddu, Giovanni <giovanni.cabiddu@intel.com>=20
Sent: Saturday, March 7, 2026 3:10 AM
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org; qat-linux <qat-linux@intel.com>; Cabiddu,=
 Giovanni <giovanni.cabiddu@intel.com>
Subject: [PATCH 1/8] crypto: iaa - fix per-node CPU counter reset in rebala=
nce_wq_table()

The cpu counter used to compute the IAA device index is reset to zero at th=
e start of each NUMA node iteration. This causes CPUs on every node to map =
starting from IAA index 0 instead of continuing from the previous node's la=
st index. On multi-node systems, this results in all nodes mapping their CP=
Us to the same initial set of IAA devices, leaving higher-indexed devices u=
nused.

Move the cpu counter initialization before the for_each_node_with_cpus() lo=
op so that the IAA index computation accumulates correctly across all nodes=
.

Fixes: 714ca27e9bf4 ("crypto: iaa - Optimize rebalance_wq_table()")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/in=
tel/iaa/iaa_crypto_main.c
index 547abf453d4a..f62b994e18e5 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -906,8 +906,8 @@ static void rebalance_wq_table(void)
 		return;
 	}
=20
+	cpu =3D 0;
 	for_each_node_with_cpus(node) {
-		cpu =3D 0;
 		node_cpus =3D cpumask_of_node(node);
=20
 		for_each_cpu(node_cpu, node_cpus) {

base-commit: a861d7b937a278f462a70311670ab1f13febb6d8
--
2.53.0

