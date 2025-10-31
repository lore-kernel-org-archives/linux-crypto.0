Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012050.outbound.protection.outlook.com [40.107.209.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9135235957;
	Fri, 31 Oct 2025 13:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761916044; cv=fail; b=h6gXYwd2g6Kq40wT2FMDoXvqc8KvMyW0bAL0SYNzkz9Doa84R5fPNJBLxxs43BWf/jLIUc2J9SGvi97kkVK1QAHRZ0fWZXh3S1g9K3vyKayY/uaU7i09zjxa0D67e1aTSeweTZJvlD/K3mjn9x63/b3bm32hkpHGFY7HvAWVkBc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761916044; c=relaxed/simple;
	bh=XESAF2gcoNqzBXN/rT9JcTJbGtotcRVJPh6JgFsxceg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OhlGxowcJwQ2mOyd9IOZ3yLEP6a7LZY1IyPUUsjesSNDcBhXHTLGNVaD9ilISIwTFb8pkOKcWlUaOe3qRSVQyRM3P4whaLretTfncQin+hlwDa48StPXGhouMWeYHcNJm36uMYFF0qGJlAKpZPtnqc1gvkbkuD0jAbuTNphLHG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tuBaAxSI; arc=fail smtp.client-ip=40.107.209.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tuBaAxSI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=maOelpxgo9pp8svYCTIn39zTilbI2SQUfoQGsV3ZokflOtVZRYUZbb/zTATSxnML+ot0NE2FbWZ7oCGCql55royYjHlARCJ9Ci7JUBf2P9mVDCEXaZ4uQxsjpYW9GeOVa+UgDUfs4AS5bvI6XM3RhwxyiH9E6sLBTjoBvEs0IS2pQqmDg5TqkHbr0xTlgC3iXi8gwljgoTddHbKZ4qfzGIcpZgZB7Nfz2Yc4SARpSpZIzZ4GMAZOE3ZLPgq4NuJKJMQUFu6FLAdkAYeYy099ZSAaAyAXvj8QtuznxqlCuc89FVGsvz1nHgRb+WDkOzTZVwtXdpvj8zCQ5wf7W3jf8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m126+cJMHNHrExOSFwi+TjuySlB0IMkrX2TWc4QMFYA=;
 b=HeRQrTk0c/h0yIMFlvyf1wfKejSBVtci+1jJ6wsy3Nk8zHlX1Ww5g10H7vwyB+i9sVJCoibtQ6e9aUFWWUtA8HVI3X038m6hPXK6T0KlaYkPaWLESpog/RPocHnvPPqU0eyDPHUCwlJiVU4IvcUpu+1DZQEJpfk5jZHk164xmAXVorjs/hxzqCqFR+ileI7ebV2xmUJOVzI97pO+KMq6dfHxuR/hi+I5hDeAZUReFCOOLL4eog5zwVYJFN1yCRlv8yXyol7DGyMcBPd5RsN+R4+He4FzenoP9jjWEpACnVtyhvFKS1GT95vbM5sH/gkBFAa9AJGRagFGhKup1yC7oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m126+cJMHNHrExOSFwi+TjuySlB0IMkrX2TWc4QMFYA=;
 b=tuBaAxSIEOpBDtazQDQFDVF9DWOCu6HMI/wGYquCnaKOPjn9YbCYNKoXdYRO1Gswykord5B1Xs+loCxk8slMFK5zW2FYzgQ5knjGlW4shskRuQE8tAqebRj+fAoIZvl3EmdNlrHNup5bD8Bq03M9dXGYMWIe09hdvk3K9fbU7+cHKnQ9Tr8OuCs+qWgraoFSWnt9G8/CY2SWHAOc44vndeX12eIDnKFEt7zk+5TrnMyznpf8Nf0EgbbdVgLDvp0xJ4DALCWBR4xhhxyCZX5BwqYJu5HDlDoD7juDuDalc+Pj4yWd2rgliRZRvSDBxqsRXdJPBS3wKrHqhqnZtJMQKQ==
Received: from BYAPR12MB3015.namprd12.prod.outlook.com (2603:10b6:a03:df::14)
 by SJ1PR12MB6145.namprd12.prod.outlook.com (2603:10b6:a03:45c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Fri, 31 Oct
 2025 13:07:18 +0000
Received: from BYAPR12MB3015.namprd12.prod.outlook.com
 ([fe80::db88:47e8:4619:e06b]) by BYAPR12MB3015.namprd12.prod.outlook.com
 ([fe80::db88:47e8:4619:e06b%5]) with mapi id 15.20.9275.013; Fri, 31 Oct 2025
 13:07:17 +0000
From: Ron Li <xiangrongl@nvidia.com>
To: "hdegoede@redhat.com" <hdegoede@redhat.com>,
	"ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>, Vadim
 Pasternak <vadimp@nvidia.com>, "alok.a.tiwari@oracle.com"
	<alok.a.tiwari@oracle.com>, Khalil Blaiech <kblaiech@nvidia.com>, David
 Thompson <davthompson@nvidia.com>
CC: "platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>
Subject: RE: [PATCH v3 0/3] platform/mellanox: Add mlxbf_pka driver for
 BlueField DPU
Thread-Topic: [PATCH v3 0/3] platform/mellanox: Add mlxbf_pka driver for
 BlueField DPU
Thread-Index: AQHcKZ8Gl+BSsmsolk6LqJ36cprvhbTceycg
Date: Fri, 31 Oct 2025 13:07:17 +0000
Message-ID:
 <BYAPR12MB30158345E1327BD4FFECC8C6A9F8A@BYAPR12MB3015.namprd12.prod.outlook.com>
References: <20250919195132.1088515-1-xiangrongl@nvidia.com>
In-Reply-To: <20250919195132.1088515-1-xiangrongl@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB3015:EE_|SJ1PR12MB6145:EE_
x-ms-office365-filtering-correlation-id: 5c465b01-cbc1-422f-a8a2-08de187e6b39
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|7053199007|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?gBRScdV7galuEEUoqyJZSybjI5A7/GvzcK9ixus05LNaAYU2tSH3TO9aAVcG?=
 =?us-ascii?Q?bb4VoYlqcB6BMRb3IFsuh/AWB7wws3w3A/UA7q5enbpCxeys5AI73PzEwdwb?=
 =?us-ascii?Q?FZf/zxe/BAPWD2rDDMu82BUgV3gcClzA4nJkeyVdUSkqtNtKRlNZZdMZCXHV?=
 =?us-ascii?Q?ShBcO1yQ1s2+EQE5aS46zLR9lpc2kkGX6mbmKlZ/PqQvMgZKQtqD+GpVxgIP?=
 =?us-ascii?Q?C8q5G/ZW53/nJTQCQgpUsX22eNm1vfnKmQb7gLBxNQahf2Jdb65g0Os8dHv7?=
 =?us-ascii?Q?LBNQ3h82RXxZHmM4WSHumk2Rswd756OtgTC/NS7JaWlmqFIaXAjh8qXyMONd?=
 =?us-ascii?Q?V0B8P/ImzYxV/wLbCQzZOK8TlkcvSZ4IBW85sk2vLROwhrc+Asjn8bPP9TAm?=
 =?us-ascii?Q?Wp4HABg8a4XAd17RKGtYX+ot4srcvW99wfsppjlttHAq0H9jWdXeVB+XQMy9?=
 =?us-ascii?Q?idYM7JvPqJLK6w0jDtCCJDOIulJ36eHP7nGO6hAdHz4B+QWeNgZ2XCPQfLI7?=
 =?us-ascii?Q?kECxUvUyz6FgxKLvC510GXHfC1+ZxGMgCQNn3y/zm9tXQibDTw/OHzzNS5yH?=
 =?us-ascii?Q?O8tUGE8QnALCImAzT2dwGhp4MafdmqFxO9xiNsgBKoD2fdN4BSlP22JbZjuL?=
 =?us-ascii?Q?EHNU1Z3ViGEcghQHXQ2R509Xts/70a2fIQKpLodaHyy2/JZZqxvYQIgFWN4b?=
 =?us-ascii?Q?33SJ4mSrzvZwDr2w3P2u1DdFkMnSnnF7v5OXh38kh7UAsGftUe7KSDMFhI9u?=
 =?us-ascii?Q?LIKDEdnJBASypkdAbnD0plMlj0ELb7LP02U4gfYloYVoNtmGHduJVzsq0KxQ?=
 =?us-ascii?Q?s8OUohLE4eAtSL/jWSkPF3cDm2YOY1XT5idQAQnsVcZdkGHsb91+Y6rXWgpG?=
 =?us-ascii?Q?RfGE6XI2rp7ZP0Qe6J5trchUrYM9gxYFVg9axOOQa4FpGY5zNfIVVFZ+oeTZ?=
 =?us-ascii?Q?ES5DsjfH0z1ZWQRFRm14N1At+r+IAlXI2OJuVuPTxOuJZsc5cY+H78IgdT1a?=
 =?us-ascii?Q?jA4K8ko8g/9aI+FhA8/rM4IMzLQJ791w0ujs7SqcFPvzQbp8mi7OvaeObO5a?=
 =?us-ascii?Q?9B3F4MZshNE8mjzVkGJ96iPYxwGtk3yhsTEpzBwC7b8dlEnSOWZ1Z/ER83Ia?=
 =?us-ascii?Q?bIrZ/8iSgvRgs+XGzzXf6NZgrl0lK8ysNgi7dRvc5T5DDL22IDiiT9OnMe0F?=
 =?us-ascii?Q?oYdolBVjgRtEIw8VD5rQxFdYcScXVk4YskR7HOU8XFKAeY/8/QciCvq5zR5N?=
 =?us-ascii?Q?Sb3xvqZKC6hAaPVfidYalR41YuflaN44e7r9Fqr9XQSBBVj0e/LVxPRucN27?=
 =?us-ascii?Q?Y3d0MYJfgvJaASRASyFrw5DWnHps0KeWSqJ60EqfRRifsBzQOSuvrTC/j7x5?=
 =?us-ascii?Q?6sLB7YaOJm914lij8Ckz+WZpuqpLgp70R9LiWqgWAnU5J/S+XRy0sXxGsU6k?=
 =?us-ascii?Q?Zq3cGLO++NHBbKuicVTy9EbJU+kEwSX7Tabl2EPGIO3YPmf5gS/PTpW8Iu2o?=
 =?us-ascii?Q?7Ht1TI36MuyIAUIXW4FvrqXiLhKBh/r1hT8x?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3015.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?LE6OfpIrdEcwXtS5EuhtT/8yZosBSp63DIUG8tAZsRZd1tOCi5Lw+C+tvsEJ?=
 =?us-ascii?Q?Tizu9rrMBEqxOWegFaLpZyI75RP/QwsnBre1bjAZnPxPnDjaY3Gmq50CeS62?=
 =?us-ascii?Q?LJ/wmLLz42r8NfgpOr7L1QI6DnsEfX+xmnDFOj9OgFe5vaFBBsv2DB/rzk/I?=
 =?us-ascii?Q?7QIEHbxHEnlNccoN/5OzLFWlCSoXI0CLX5TF1ZYVUjqHqI2aZFzvjIcMVoK5?=
 =?us-ascii?Q?JCzIoLU+nl9G1+PyWTbmXRJ9NAiryk5hqfRfuCipwZh113zcPj/QMflt6yuV?=
 =?us-ascii?Q?JPXj1t/XovUfNTD34EqSeG0BFR8m5BOFZ5XIBkGpfDykamDzFpZSUCCoKOxK?=
 =?us-ascii?Q?a4tOxpYgSNzwPzHjeIXa1dDpudiwoM+9hW2Cxn9/qyrXzVvrxj0+DOPW/7re?=
 =?us-ascii?Q?j7uO9i3jj1BANxi0G48x9CFoP7wN5bbEDGsZ6qDh60fQohJcJGR9NvNcXlDD?=
 =?us-ascii?Q?ETxdFwjNDgCxeXW5sSfhPJAGKOxQ0Dx+t/dqPIABim7ncRHnRB12vRGKlTG7?=
 =?us-ascii?Q?pF9C408PXRHtsRKkHlaq4JzHLhdMmJ1G/s9x6TSvcvc+HangtgtU6RxAN/wS?=
 =?us-ascii?Q?NOKTx7RMu+KvC8/WyZr70OFYsifbo55J56Y7yejirkRNSZU/oFwNe7g8Je42?=
 =?us-ascii?Q?PWYB4b/nwzDzagAQ0WbOiTHRFG/HgJgrp2yiMWKr0mw8uxLfnNXE7oXteeBG?=
 =?us-ascii?Q?Va7ftpEQ+iTG+PXkYW/iqubJJmw7M3bnp8lOiT8Z/P2fP1NluTBM1IxXyWWN?=
 =?us-ascii?Q?M/UVpoQhXptB31BbyZHruPhhsb2WcvhaGpDy1W9zlkMoKBRWLldBOlUZ/k51?=
 =?us-ascii?Q?M2Rg1lMUXNVv2iNImkl8NZjHVCQAqXnw59FAW2iVjXb4N9EtvH3rU31gQOLK?=
 =?us-ascii?Q?q8omq22juuIbGb0lnyI4Bw1Fo7LvrHFzd3uROE8J3k9ey6McWZ7RAujn+58a?=
 =?us-ascii?Q?IK43XBh4hj5V8/BGb+0wd0phDO79Nbt1ixc1LBLnKf+u7qMoEFI7dN/iG/qq?=
 =?us-ascii?Q?LYhEztq0iJRJOr0ItdZKLkHdBqqnQmjy3eK/XmY79nplgJKpOItDI4j19y3F?=
 =?us-ascii?Q?WXHwILB9NjhaMHa17a67O4/DCTj1zgAUW1AZWgdf9nHAdcr+86aw7UpdeAcp?=
 =?us-ascii?Q?94Nl3pZkp+xHIta3p9nFSby6HyUJka7gnnDJn2bX1k7mwlSLu/7zJ87O+4gX?=
 =?us-ascii?Q?uC1mWyHKJwWaHjr9w3Q6YIK5Ffa18LXIaGYUQmqA6QfjPQkDrLOi0nbl+IYU?=
 =?us-ascii?Q?1u42tw3WLLVwlrqcpwlBD44lhmpLdmsShFMkVlRzuWARS47a9ZY1TTBuIo/w?=
 =?us-ascii?Q?t+GjFdcyD8dhGDphgzj2mBKEm6DOQUfOCaApbDNpQ3A7tFygOMZ3ai1zeL9Z?=
 =?us-ascii?Q?/Tv4PgRRtwjypOklS+aKXfCXaxORioNt6V2h75YOOMJNmNFPr++KJXvOrCSr?=
 =?us-ascii?Q?kuJaOyqDW6OPl5BmTt1pTvFfB05bInVHkUTRkNGECITCjej+1RcTOJCVry/5?=
 =?us-ascii?Q?j00O6WRPY5YohXeBr+R2Zg/5pPI6CsyxywgGdeUzdxj/k5+BC6u02h6zdQW5?=
 =?us-ascii?Q?nf/UW0eWa5sz04pH+1TfrH8l0PcX/rofLHY02MvB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3015.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c465b01-cbc1-422f-a8a2-08de187e6b39
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2025 13:07:17.6593
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9UdstijYViQUoPzQNTJ1TMa75rrN+BJOvszFlR1Z/+EYx1E/k+0KJjIrTO+YZDHjDUVnxZ3VbhK1Rf3HgJo3QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6145

Gentle reminder.

Thanks
Ron

> -----Original Message-----
> From: Ron Li <xiangrongl@nvidia.com>
> Sent: Friday, September 19, 2025 3:51 PM
> To: hdegoede@redhat.com; ilpo.jarvinen@linux.intel.com; Vadim Pasternak
> <vadimp@nvidia.com>; alok.a.tiwari@oracle.com; Khalil Blaiech
> <kblaiech@nvidia.com>; David Thompson <davthompson@nvidia.com>
> Cc: platform-driver-x86@vger.kernel.org; linux-kernel@vger.kernel.org; li=
nux-
> crypto@vger.kernel.org; Ron Li <xiangrongl@nvidia.com>
> Subject: [PATCH v3 0/3] platform/mellanox: Add mlxbf_pka driver for
> BlueField DPU
>=20
> This patch series adds the mlxbf_pka driver to support the BlueField DPU
> Public Key Acceleration (PKA) hardware. The three patches in this series =
are:
>=20
> Patch 1: Base implementation that wires up the platform driver and the
>          device/shim layer:
>=20
> Patch 2: Add userspace PKA ring device interface.
>=20
> Patch 3: Add True Random Number Generator support to the BlueField PKA
> driver
>          and wire it into the HWRNG core to feed kernel entropy (/dev/hwr=
ng).
>=20
> Testing:
> - Kernel builds for ARM64
> - Tested ARM64 build on several Mellanox BlueField 2 and 3 SoC boards tha=
t
>   include the PKA hardware.
> - PKA shim devices probe and remove successfully
> - The PKA ring devices presented at /dev/mlxbf_pka/.
> - The PKA device validation test passed.
> - /dev/hwrng present; rng_available lists mlxbf_pka
> - Generating random numbers succeeds on BlueField platforms
>=20
> Signed-off-by: Ron Li <xiangrongl@nvidia.com>
> ---
> v2->v3:
> - Split the source code into three patches to improve the readability. Ea=
ch
>   patch introduces new device features and functions.
> - The latest kernel APIs are used for each patch in the series.
> - Updated some variable names to improve the readability.
> - Fixed the logic in the mlxbf_pka_ring_mem_addr() function.
> - Update all the pr_xxx() to dev_xxx(). Except for one pr_xxx() print whe=
n
>   the PKA device is not available yet.
>=20
> v1->v2:
> For patch 0001:
> - Move ioctl related definition to include/uapi/linux/mlxbf-pka.h.
> - Changed the ioctl number from 0xB7 to 0xBF, to avoid conflict with othe=
r
>   drivers.
> - Remove interrupt related code, since the PKA driver uses polling instre=
ad
>   of interrupt.
> - Use devm_kcalloc() to allocate memory with calculated length.
> - Use read_poll_timeout() to handle infinite loop checking.
> - Use lockdep_assert_held() to enforce serialization.
> - Create mlxbf_pka_drv_verify_bootup_status() to handle duplicated code.
> - Remove error handling in ***_remove_device functions since nothing usef=
ul
>   can be done.
> - Fix the rollbacks in some functions by adding proper goto rollback path=
.
> - Updated all comments to under 80 characters per line.
> - Upgrade some constant with kernel definitions.
> - Include missing kernel libraries.
> - Update some pr_xxx() to dev_xxx().
> - Use FIELD_PREP and GENMASK to handle mask and offset of register access=
.
> - Refactor some code snippet to improve readability.
> - Update the comments of some functions and type definitions.
> - The FRO in the source code stands for Free Running Oscillator.
> - Fix typos.
> ---
>=20
> Ron Li (3):
>   platform/mellanox/mlxbf_pka: Add core BlueField PKA platform driver
>   platform/mellanox/mlxbf_pka: Add userspace PKA ring device interface
>   platform/mellanox/mlxbf_pka: Add TRNG support and hwrng integration
>=20
>  .../ABI/testing/sysfs-platform-mellanox-pka   |   35 +
>  .../userspace-api/ioctl/ioctl-number.rst      |    2 +
>  MAINTAINERS                                   |    8 +
>  drivers/platform/mellanox/Kconfig             |   10 +
>  drivers/platform/mellanox/Makefile            |    1 +
>  drivers/platform/mellanox/mlxbf_pka/Makefile  |   12 +
>  .../mellanox/mlxbf_pka/mlxbf_pka_dev.c        |  481 ++++++++
>  .../mellanox/mlxbf_pka/mlxbf_pka_dev.h        |  327 ++++++
>  .../mellanox/mlxbf_pka/mlxbf_pka_drv.c        | 1016 +++++++++++++++++
>  .../mellanox/mlxbf_pka/mlxbf_pka_ring.c       |  563 +++++++++
>  .../mellanox/mlxbf_pka/mlxbf_pka_ring.h       |  255 +++++
>  .../mellanox/mlxbf_pka/mlxbf_pka_trng.c       |  874 ++++++++++++++
>  .../mellanox/mlxbf_pka/mlxbf_pka_trng.h       |  152 +++
>  include/uapi/linux/mlxbf-pka.h                |  112 ++
>  14 files changed, 3848 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-platform-mellanox-
> pka
>  create mode 100644 drivers/platform/mellanox/mlxbf_pka/Makefile
>  create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.c
>  create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.h
>  create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_drv.c
>  create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_ring.c
>  create mode 100644
> drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_ring.h
>  create mode 100644
> drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_trng.c
>  create mode 100644
> drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_trng.h
>  create mode 100644 include/uapi/linux/mlxbf-pka.h
>=20
> --
> 2.34.1

