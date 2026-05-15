Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011038.outbound.protection.outlook.com [52.101.57.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AB53016E9;
	Fri, 15 May 2026 02:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778812510; cv=fail; b=I/pKofNRVyX0in+3p1ACfcfu3Lk5ZWlKsZX7nYAftsNiugGxmvfaMBrmAUpLNTUNRpaSNYQituegPk4NSW3pLQbfOgM4PoJYMNLg0iVtOcTZpPi7tAK0nc9zjg4KoxQk5ChS/yPN+2J6ZLpfaxEgdhxYix7Hb2cm9yjJfQKyd18=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778812510; c=relaxed/simple;
	bh=rx4QSGSYl/8sTyR/GwoSqTB3lWz+BDXpkudDPZOwxIc=;
	h=From:Subject:Date:Message-Id:Content-Type:To:Cc:MIME-Version; b=lwA91CKlzqUznWgD0gwced1Y+7ChBCLw9yBP1+noCubFvl47CYYqX24i+YNkiZrMMiUR2C1PfjjnIjcd1WjVx63yoh5CwWMtvb/nvcAyXjZ3dySaIUvwlLas/d1l9kfW64nPIVj577ivzDpqUPZLw4HD9snGh7xFB8RFOFzrLEU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NSbJ3Hxx; arc=fail smtp.client-ip=52.101.57.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NSbJ3Hxx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wkGhkM8fwX1rYL6WOlLV8LSeZGiwwl+oKjWBZlAL4tpz+79P6V9VkjlQN2Cl98phkGLahy5Xk4fa5j/8rn+Ncj9y8ZWTaAamGDpVLQL45HJsye5vgDqm/osxiVjJoTDHxbE2x3RlR62wQT18VdTvwgxIeioPXJ3J9nsg4N2XjsBaaVrqWTSRDxu2ghjr84byzIXmwRkd/+THn8cVhkcfveDjxnGxDtWbxCfxx6EqgpAm4qJd03IhRuAuxpUzs28LRjogw7dfE8H4z5t+RxWO2HAc6S1uzhvsZeknwVSk3BzHiyZi4mPT7yE6kBGKxYZ8FD3olP0vAv9frV0VjUDRXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RfUewLfQEpIrya13XjeDWxHNo6T4mhhoKo2av7emPWE=;
 b=x1DE16w1c87eKTrcIhRIL5q35+MCPCBJzx5HjX+IwQJUzdaLKWCNf2eVd+Cyd+eNQ4bFBxtiKdxS7XMMSjaaRDFQmpr0N/bivE3tWUqA9VG4z9M4IOo3c7AUqd4baybrLSRJpugpqXtbCPUdt3LA+baxo91FzIsYLMl5KEEPGSf8lerjBu4YUzC3dV8mdNpdzHWBQh5ypnJddlE2e55Z7sTSpr2X5o5Cpf4pOOVtK3MS7xKdFQuoNweq6gXu3rYVP2CNMVQFCiCCQPudGDvhP9i69JKv4TNeq0zIeqfD9kETGUnEtKUUzplqCCnt2y2/EAaqdLJztxOj0huGdll6jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfUewLfQEpIrya13XjeDWxHNo6T4mhhoKo2av7emPWE=;
 b=NSbJ3HxxoLooZ/8mRh96ZE47Nu3fCBfkKwP/HtA53p9hFF1LkNoO9ZsAoRBqibPdXsuWh6d1SuJ8YCa6205ZubvBclSAq6NBFdUlpeLv/r22+39gng8IzIVrnozcBrwsiBPmrGMeh21RJITMsdrNxrgRuhoCqLLMyOp6ru+Pa5HLThSvSgjPihhM+ObWYBji2aPA4epL8VrqsUfaFZySvHtpoabeCh4QIug8OAlVRsQmHuubuG5swdCWlDCfhvJzKQ+DILKsCPSPrc78GW01vVBdBTPGqoj2e5RIx3E958nXf9e4KkMoC0DRDaa9ewg0jD9ig+jRaku14/kYhd23ow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB9161.namprd12.prod.outlook.com (2603:10b6:a03:566::20)
 by DS7PR12MB5768.namprd12.prod.outlook.com (2603:10b6:8:77::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.12; Fri, 15 May
 2026 02:34:56 +0000
Received: from SJ2PR12MB9161.namprd12.prod.outlook.com
 ([fe80::d9d1:8c49:a703:b017]) by SJ2PR12MB9161.namprd12.prod.outlook.com
 ([fe80::d9d1:8c49:a703:b017%4]) with mapi id 15.21.0025.016; Fri, 15 May 2026
 02:34:56 +0000
From: Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH 0/2] Fix leaking of cached Host1x buffer objects
Date: Fri, 15 May 2026 11:34:50 +0900
Message-Id: <20260515-host1x-bocache-leak-v1-0-a0375f68aeab@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQ6CMBBG4auQWTsJLSDiVYyLtv7aUUNJBw0J4
 e5WXX6L91ZSZIHSsVop4y0qaSwwu4pCdOMNLJdisrXd151pOCadzcI+BRci+An34LbvhubQwve
 DpVJOGVdZftfT+W99+TvC/F3Rtn0AGfNfWXcAAAA=
X-Change-ID: 20260513-host1x-bocache-leak-4759384eb792
To: Thierry Reding <thierry.reding@gmail.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Jonathan Hunter <jonathanh@nvidia.com>, Akhil R <akhilrajeev@nvidia.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Aaron Kling <webgeek1234@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
 Mikko Perttunen <mperttunen@nvidia.com>
X-Mailer: b4 0.16-dev
X-ClientProxiedBy: TY4PR01CA0101.jpnprd01.prod.outlook.com
 (2603:1096:405:378::11) To SJ2PR12MB9161.namprd12.prod.outlook.com
 (2603:10b6:a03:566::20)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB9161:EE_|DS7PR12MB5768:EE_
X-MS-Office365-Filtering-Correlation-Id: 08385c5a-5eec-42b8-52d7-08deb22a8d58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|10070799003|18002099003|56012099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	4w/NZv1TrJ5R7vVAcJT94i9/2ZYOccwUp07ddIk7MXZyoaCWVdVk2t2NC3f7m4M1CIOZ8uhSzBAaXAp/CZn5+L5pYgO+Hqt8Y9bICWUMfDshE+43zr6YhfwJQq7XnK2pkgeVZYqWUuPlhXO9f0ft2WHubvHZrS7TKrbZ1y6cU1bFGqlqQUURBRi4jK5LfkZhlxqSjVnmzXaOgxo+22vS03jK/UrEPRLp3/jWVB2/zvvvo7JjCKRMT7qq3FUq3wLNGJp7xD9dn7//UarJP00c0hwWGMGYWJRQVjVPXmgZl8QSLTTYkJtZaMqDVDa7rqNHopmWxgkYL6ugMHAG2iqKVxvPLXdecerauqMAHi7LgP85s+GI8eCllEmpsu/lXhXTDKV3IZrhj/vC0KfsJWPXuqbnGxBPUSGAfYyqPrE2UWo2zBgn1Kla12mASVUOzau/87jRAqPz6LXDlfmPF/mGMa+j/QWhnaKU/eX228pX3S8ZBmqz1QJ7m7iN1xXBkRfv2LyunfKYkDMhxTRpQA3mBUJhfjXJ9QvtZbM8MNLWyIYAmQp0qt6XM5CupC72RzsIxlop5HXwmlbT/KGLv06FvyekZKSaXzHAsfBa1EOoUUYU4A2RnV3BmGIm9Qs6hMnH/ugUjNREHwSilVawmItcjykaD30h4QOpkpYOisEsUlt2XMRuCOgoVuVEAB9IUjKj
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB9161.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(10070799003)(18002099003)(56012099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NzMvVzFmbWNlNUwxQi9UdzZTUW5qTU1leWV2a1VoK0tOQ3JaM2hTNjYxaitv?=
 =?utf-8?B?ZTVWdzdXQjdvVmNGRXJ2M0JFTXA4eW1aT3dXaThaY1I1eUN6SkVTSk9rU2Fp?=
 =?utf-8?B?YnVTWVNxcVBZMW56d21vL01tQ0pReGoxR1lrNmtkT0FGYXE5U3UvRmgyS2xT?=
 =?utf-8?B?U1hPa3d1dFhZcEUwcW9iT3ZTWDdVRGdVazl0bUlCaDVQNkU4N21RRm9TMWhC?=
 =?utf-8?B?V3pjejJCMEFIb2tnaU9GTlhTS1AxN29CSHB1b2Q5eXFHY0dSZDJrT04vcm1l?=
 =?utf-8?B?L0VoRkh3UDhYdVFRRTdOT0xLbDRITGRsY0FhQUdReEpXVGx5K3N2ZmxpMWY2?=
 =?utf-8?B?NW5qd2loQ1drYlZZZEJLNEk3c05VcUZhRnRqRDZHd3dxeVFwREFGVFhmNzhU?=
 =?utf-8?B?TFJuWHlVbU5QNHlaOGtCZ3RnQlNyZitvbllYSDJaMjVRc3NiL2RuUW1wQ2c1?=
 =?utf-8?B?UXIzVTRtVEk3ampad2l2TkVDZk03dEdnbnN1UzUxalpBeGFOVW0rTGhtTjNk?=
 =?utf-8?B?Zy9xUmhkUnlsV3hrT3F1WW1VTVEzbG5pUkE0b2l3aXRXcHN0c1lVVHFVeE9z?=
 =?utf-8?B?THpKQVBnLytod3VlaTBzSTlpeEgvT0IvN3p1MVZITGZXRHg3VmRvUXRmVDgr?=
 =?utf-8?B?a291RmpWM1RESUlBT0dtVFBTNW83UWlPWkpRTTlEMWNvNDFJZjlHK1lRbTJL?=
 =?utf-8?B?Y0FTWkhYT2xnYXNOb2NwU0ZlQzFqTjZHNktCcElscWFteEpOWnYvbUtmTXho?=
 =?utf-8?B?QzFuVStIUFI2US9ieFYwZzExN3pDc2JJa3Bnby9GRTVHR3dkZWQySC9oUzNy?=
 =?utf-8?B?VUU2UnZYSzRzR01EWnlmU0xMSG50N1k4TSt1a0xCcjlyMkIxejJlcVRtSGw5?=
 =?utf-8?B?SmNxTXQyUmRsSmRtSW0wdGFYQW9HZUFjRDRuR3FWWjJHRi91czZFaEJuOEo1?=
 =?utf-8?B?ZkhMMmU5SEZkN3lBQTk0SEhNYVA3cjFsV3FFRnMvT3ZmT0tjWmRSc04vTEY4?=
 =?utf-8?B?c3ZPMFVHbUYwOHRJai9iMWplMW1lUkhOaW01TzBTZGhjbmgxK0FZbjZtQmcy?=
 =?utf-8?B?UHVnRnJ5Y1lMa3hTaVFmaE84SDF5akx6azF5cEFGSXEvcTVKMWdXZEZ0Z1Yw?=
 =?utf-8?B?VGdDRlExdVU3aEFvUnk5ZmZuTkdud2NuYWFjSHRJODBLRlhVUTd4dGV0ekRq?=
 =?utf-8?B?cUJqVXhpamViMUduNDdPcnZ2YkFNdEQvNyt6LzFGeGpjSFpKTThJa3p2anBw?=
 =?utf-8?B?S0Zadm5mYU04Z0gySTdWcGxDWEVFS2IrZm9qQk5XNk4wVUhXeEtVdU52MTRD?=
 =?utf-8?B?dzYxQkFLT2xyV2NlM1RvdWkrckp3N1ordXNDcGN5Y0tKV1U4cUNKTTZ2NzBO?=
 =?utf-8?B?aHkwTWJvbTl5Y0tialh5TGdYMHE5aGt6T2NuSnkvTzRYRUVPd1k0WXpWRzV6?=
 =?utf-8?B?eGNHRHlxVVovdDhVekkrckJQbWVleUo3bDFnVWlGeHB5MkdIcTIxdW15ZXQ4?=
 =?utf-8?B?djlzcDNuUU5tdlpNdk96L3pwNXVFOVIzQlBiN0p6emQvYVc4YnVvaS9oOU4v?=
 =?utf-8?B?cm9xYVpyTlpsc3dqbFM0aHV1OG15eG4yUXRWVzc5cVlIaHFVK281dnZjdkEw?=
 =?utf-8?B?QjFla29qeGV5RkR2a1NObnBjZTU3WHZuSHYwT052RUFPNkpzU1FHd0ZIQzgw?=
 =?utf-8?B?OXo0V3U5QkRSOS8yb3QwMDZ5WU9OTE5vWnJPWnB1VTNjd2lmdWdCWGFtWkRi?=
 =?utf-8?B?WnczNFNOcU1nL3BqNDBkcEFNSTh3K1g5Q1ZhL28xZCs2aDVwRk52bG9xeHFD?=
 =?utf-8?B?MFBjTk9BUkM3ODYva1RRK01DdmNXMjNTSEc0US8wR3N2WlBPMlYzdTVJM1VK?=
 =?utf-8?B?cEtoZyt4N2VRdVpsSlpOQVJMeDYyMVhZbHl5aEtLUzZ5b1VVR3k2WEoxY1ZD?=
 =?utf-8?B?WGNGbmxUZ1hiSzFUZXpHckVqMDh1MjdwVWx6WkdzUjV1N3VmUDJYQXdreXlK?=
 =?utf-8?B?STNNRDNwU1dtMDVtNXpzc2JEYVpkd3NXNmt0K3FyK0paTFdTRVcrSmR3Yk9R?=
 =?utf-8?B?TnZHVkV4QVRqTys2Z3NwNXdUNnVIM1NTRnorWENNRUJiUFhhUmtTckRFQURM?=
 =?utf-8?B?WjU3azJ3RXpDL2ZiTm9DVm9BZ3RVSzhaTTlCUzh1TFYwSHZtS250WHJqeStN?=
 =?utf-8?B?TDd0UFBEa0ZyUXYxN0lscEFSWit1MVFkNWM5Q3dFdGRpZ05nYWRQcVpBUEpC?=
 =?utf-8?B?SDR6SVVRdEhJbGs1bUd2dy8wNUlUbEpBOHl2a1BhelY5NFo4MGNkTVNkd0k5?=
 =?utf-8?B?NE5JT2dlZEl2N3FDTUVQT1ZLNDJKeGowbXM4SVdFa0Erd295cVdGUnJ3cDc1?=
 =?utf-8?Q?rE+q6yTVszbpsf14uty8kemXWNvXMGlFFLcKya2sEwOb9?=
X-MS-Exchange-AntiSpam-MessageData-1: SwGqvWuPGww8gA==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08385c5a-5eec-42b8-52d7-08deb22a8d58
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB9161.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 02:34:56.5289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WmmQgnggMm2WEAMGzopO/5iWw+WzzGN/tkutQqtHlbrboveY47jIwH6StbdK4UaE+AjTrufEcDRggpr68RJP3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5768

Host1x implements a mechanism to cache buffer object mappings to allow 
skipping costly map/unmap cycles for buffers that where that commonly 
happens (buffers used with display). The intention was that once the 
user frees the buffer, the cache mapping also goes away.

However, the cached mapping was also keeping a refcount on the buffer, 
so the code freeing the buffer -- and releasing the cached mapping -- 
would never run, hence leaking any buffer used with the cache.

Fix by making cache's reference to the buffer weak.

Merging notes:

The change to the crypto driver is safe to merge independently. The 
driver keeps its own refcount regardless so the buffer won't get freed 
incorrectly.

---
Mikko Perttunen (2):
      gpu: host1x: Allow entries in BO caches to be freed
      crypto: tegra - Don't touch bo refcount in host1x bo pin/unpin

 drivers/crypto/tegra/tegra-se-main.c |  3 +-
 drivers/gpu/drm/tegra/gem.c          | 13 ++------
 drivers/gpu/drm/tegra/submit.c       |  3 +-
 drivers/gpu/host1x/bus.c             | 60 +++++++++++++++++++++++++++++++++++-
 include/linux/host1x.h               |  7 +++++
 5 files changed, 70 insertions(+), 16 deletions(-)
---
base-commit: 028ef9c96e96197026887c0f092424679298aae8
change-id: 20260513-host1x-bocache-leak-4759384eb792

