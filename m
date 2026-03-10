Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010046.outbound.protection.outlook.com [52.101.56.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0F036B05F;
	Tue, 10 Mar 2026 21:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773177029; cv=fail; b=bBnltCf0wF6WRz1/Ses0hJQFelFBMke9JdT9JbbET1JwSLby6muXblmirGriJ0bUw/JrQl77DB3ZZuKTOD8Ie3YejqWWAN/g9rRyKcJUj6KsZIL3rYBJwisOUQCaZ67DZHs02hRFFpur9en+mW2o+P2tDBQN2p2TD8lMAL09Oog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773177029; c=relaxed/simple;
	bh=3rmpIxGIhuCJkxEtKPfk8vIlYHfQC2UM7W6UyXmCRMw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=EdNloKjrP3Ctz6LdqnRBP8UR7KWMot7pS2eDpuPn2KvMPaV8cRxiBClDuT1t2MRmzS6ioBleWkDRPN+KrkCh7MesobjdzpJUFjnX+YW19K3/z7AgXymJ92hCumL6L3DoUrNycn/itO1MYkF70btwb0PlfBkDSHG18wL0oRoE0m0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Su72mYuv; arc=fail smtp.client-ip=52.101.56.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Su72mYuv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A3X1mOe7u3zc9zkKrcIgpZSNcdnE8j63x2jWcnOYLk3RLnmIrIY5XaWR7N01A4Y5CZUjywoq1C90Ee9mJViiS8uKMwyk3LDsSXi7ICVjn3SuCT9O2jLYOzmncpmdP7keiG3O/OOfllsvdfcsmPOliOGDShqUPlfPCaglIhOH2wpKvlM1FAY2747y882K55TgCfWkBqCztgUyqZiXQH0EnCdfJNOT1LPW4tecIwi72ilpmo6QkIY4+h0eqxnx5KHAr2Dp9jCpJYYOA2Xak5zP4ec78MLcMy5s8IEUg8riHUyOqF/3UKInJeBdbfdTUHmuiVhMdM61wTi6369kGzI75A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=doW2AwRrCFlR2woAEFOgsQmBGDTIlA0VM13D/jtZdPg=;
 b=E6Z+axgHnAMbSHmsmWpFM8fQWg0XdxihB5G8m/ht2fRZmwa3gl9ZD9uQQQ6bB4f3xRWUvPQYK9BK1f+YUI7e1WXSElel2X1u9SkkQ77QNJNF1z9N0/VSOETNG0N6kn4K92fk1H78qubN4Y5UL1BHZQ5XO5o4d+Y6+fNAeGxxeC9mSPYKV3H08r2ypZsTz3WUQBdAASc3y6IwrrqtMt7qNACo80rG1T/aGUnPhGPFaSHZ1l8k5F/AuqzGB1vy9w3tR3D7kmdxb5SZmz37xrhtk+5tlBZ1J2LdIOknA62uLo5ZgPJ8EJDXjXQpzO+dUEGx/c291gGP9QcUrNHDjP6p0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=doW2AwRrCFlR2woAEFOgsQmBGDTIlA0VM13D/jtZdPg=;
 b=Su72mYuv9VQS9OguN6sde+VTMAM1e37nCLIhZLO6Z6jXiP6IfvrffTRx8Rz4u5F9e5ZZnA2amfRLDEU4xp0pYhxd3cV40XYaMlDNVaxX+Ba/rrec9ZaS6yE+5SvuSWAdihGPgaNffg7yPjlCvwqyaEDKD8XoL1c0aIJ1Zp4GqkBxyBhM6fxHA7B4ry/Gn6FwEP0UEvcG1LfddalJr4cJ/t2c3JR+1wtAHw64COXbE0wXkl/EfZpO1vA+Ds2vf2alQhtkPv83YVAFFRRW/Rs5Q48A4YBlWfsAqwbXoKidTg7b8NUgqtiZjeXBqd9Od9kz0R6tyo6NpYEOskavTSy3UQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB8800.namprd12.prod.outlook.com (2603:10b6:510:26f::12)
 by MW4PR12MB6999.namprd12.prod.outlook.com (2603:10b6:303:20a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 21:10:24 +0000
Received: from PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d]) by PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d%4]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 21:10:24 +0000
From: Yury Norov <ynorov@nvidia.com>
To: Yury Norov <yury.norov@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: Yury Norov <ynorov@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH] lib: crypto: fix comments for count_leading_zeros()
Date: Tue, 10 Mar 2026 17:10:20 -0400
Message-ID: <20260310211021.95362-1-ynorov@nvidia.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0145.namprd03.prod.outlook.com
 (2603:10b6:408:fe::30) To PH0PR12MB8800.namprd12.prod.outlook.com
 (2603:10b6:510:26f::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB8800:EE_|MW4PR12MB6999:EE_
X-MS-Office365-Filtering-Correlation-Id: 68d0be97-e25d-4ce3-81ef-08de7ee97228
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|1800799024|366016|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	nnaLp5VgJ8BkSyErY/i2fkewG00whca+52i+7WVmZwCjW0ggrqFRffSTs470cCR3ldw+UqYErM5OWwZiQmOJPoeZu95cGmzx2VfgwodrhV3lkzSlLTWCAFMpyUkF/OyfjMhJO9LnsSL6jb7T8iVkRvqE7B97/xACu1xQdCjgQv7TIeMn6/Z+g3c9jxa0WyajKvEp+60dxYScl8aF/H0XsQ4hFOwm8i/vvNP8ooM/tf89DmA7m5X1G9IWTimpE+0GxHJhnD1dn3OURUp6jmwvyAL4kUqvx8le+wY50o2cnyzQL63i6sR00UGrUCY0+oAohANOcxUEmTGLJUFm6k7gOjdFLxoNDX/9jDi9MJ8TfpiSK7DB0PvWgWWiibR5kVcRKcdf7s9bq4+cwTXfKmaqsmGqxrBU6RLFJAPtirR7vtdnjutY28f8GDTPmrja7xXFeZOx3aa7MuHYpMpKNyWhfT+Ikf5+iYo8u9C36/dd+lG0vNluECAl9ODmD7M2DrqDl56WDve0rS5+jypKDj9JWuqbqY/1QxtGmxEnz5nvbiOJKtJ4j+jvzNNKGB+XiaYThHTeDCtxSGF12HSwru5kRl5MEWY7EwJcobr3L9xvKfA8kP2GvntDDmdP3gBq28oJUBXuTepr8jHykuQ1ylGV1/v6oM2b/jlOPCoHwJ5i7VC3a9I9ksnskI4MVe5qrEuRgXF3FfZMTMHE+lxr7Gf5quiR+frg4bPkEGa3b14VEbo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB8800.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(366016)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NRQdLvllKqi1WBsyYvqCEfUtqT5OPGV/GMqbeDSGNGasAtAJEY/8AQVxqCFD?=
 =?us-ascii?Q?Xw/bjF3Iwov2OpNe7I6hu+IfyR2vBKKXS5AVJfq4pMrH56BOR1r7vzriNR3r?=
 =?us-ascii?Q?/I8mKzLvuP/W35wDYRLCN0jCzOtERzhtEEaz4h5ctxOh6iEjN2pXC8yH5BCW?=
 =?us-ascii?Q?8YEPWTAx3KGXyx0SXGW9+zn0OgKuAIxSFCMNwd3U2VqJlfRofS/UKLezBQH/?=
 =?us-ascii?Q?7JoRfp+smQJIvO2mWvZkLgZP6lo7ww7LKZJoDKF9LICYA1ATNUqUPNUYU0Cl?=
 =?us-ascii?Q?+zg3QUyD862n9IgAX9aI4KDTSpr8RKz71F4IOAICDGVsHUCxiQ4SRZh09UvK?=
 =?us-ascii?Q?m4lOuyOM6Fc0aByclgykWuriAbgtevmuviS9TUZBw2KcOLqpbVIfzAPmaK2C?=
 =?us-ascii?Q?KFKmSShebMKJKSKyRGmIgMIo37LiSRze8VsgzR4so5QHwUsmrfdslPbYtks3?=
 =?us-ascii?Q?A0/VgS+h50/P3mxxHMB0A79jNHdxXdC2uoc7UOhkK1seUlbzJIACEBEQj54z?=
 =?us-ascii?Q?xwGSytE4sPZQk2J67O+n8wXuIPQ+DA+7A8VAoAC+RAidlsUawEwiU+NSYpfz?=
 =?us-ascii?Q?UG+o+8Nqe9E6EorQg6rQM2xWMkuwV7A/Gn/YxlZILVn+M6cnveF/FpbNB511?=
 =?us-ascii?Q?NUcAtur35CJ+zP170u22sKPScIr3R0i/b5jzZIyzambTTuDyNznHkGGp2N2a?=
 =?us-ascii?Q?3FEFKyIl20rweHpmy4A4gaMloCt4yReYWdHEWciZfr6ouEJtUC44u8L/5kzu?=
 =?us-ascii?Q?o11NoTfslRp8TzT/QjjjycQ2VFxiu1B2YtQjij6xvPf0siOvJuABAz2anG9P?=
 =?us-ascii?Q?l9uYh/QfR36T8sNWf4vgQayf/wF65UzHoMZkUugrwha1hGdXvaG2lokrEKJK?=
 =?us-ascii?Q?/uqMTE2ojxwU2/qWiVN48Pg+LDmDu3Q2c7PdlldZF2peCVotVHPjXjREmv2u?=
 =?us-ascii?Q?MiPKWjJES/6p7rW7C4R9su50/S9liWvaVGCIpvLrJFg+V2fCdHmcBBKZV+Z5?=
 =?us-ascii?Q?k6FqG2WbnqzuKMdZkJg2pJmnI2YziX+8xcqOfpDmB/0kjap3413mZVZymn+i?=
 =?us-ascii?Q?mX9Up27rgmhx30xxNxRdZuVmB4SpNsBRCEPC8SbLQMEL5TSdcJILC1V05IZg?=
 =?us-ascii?Q?Zr0lHSovrRug4fkBjesKkO1xs5X49vrAIFBb/n6cu/Ig9UDEkVWlzCgCsgrx?=
 =?us-ascii?Q?CrOzh+/89dlEDhQMiUnGAVoD4yQtYlfTScvVl+fedfY6k3pISNI7drbMWfUL?=
 =?us-ascii?Q?KhvUkOfl6w/VnS9zdATg67/ZJwMmRyOdnYeW4moGDDuXw3bQ/yLpoxXBUSZK?=
 =?us-ascii?Q?oqAEqZ7P8xk2qumx4OZd98Ycg/iSrKVMw/DNLevRpynx4vnkWv/on+YCILxJ?=
 =?us-ascii?Q?J9G/scCVlcLy4zRwc9oKCWZH1peuOBp/E6GKeXn8prZZt4gM2JX5cxDKCzj6?=
 =?us-ascii?Q?AXvdXVFZGoU7JIQGNQTMjwvuhZOhYLmEUPSUrS60U+SA2uCFzA1dZSpFeMwY?=
 =?us-ascii?Q?jyrZP5wmbEH7aYP3Zgk353FTHH8tYrRkM/QbCRyVj8/083IefJfyP1/YklsV?=
 =?us-ascii?Q?RE6MUxnvDsK0ma3LG5Kdga3rJQ/UZc17iar5cyP7NoEvjYe/Wzw70B3TeY60?=
 =?us-ascii?Q?RD6uB/6rfUdK4C3ZO8qv33b9OFxo9fp6syvvIPf/eF4NxRkrYY/r7VWsSjZA?=
 =?us-ascii?Q?4oLaRArDbihu5xt0PY4P55B33vrZN9M6+Zdjt00FgkMc+7Q4Qxja3X/U068z?=
 =?us-ascii?Q?30VIW9Dlrt6azrOqBZF9FKcrLOXUsDbha4od0lxdtz8+xTeC/pPt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68d0be97-e25d-4ce3-81ef-08de7ee97228
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB8800.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 21:10:24.2192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sMNsI/JQGGJMlHYKmUxztjwfRpdKZ/rgC4xPg2hjRiB5RofF+Z4ljI6B848+Bp9z/uwMRwCuZOyJlxjaevqoqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6999

count_leading_zeros() is based on fls(), which is defined for x == 0,
contrary to ffs() family. The comment in crypto/mpi erroneously states
that the function may return undef in such case. 

Fix the comment together with the outdated function signature, and now
that COUNT_LEADING_ZEROS_0 is not referenced in the codebase, get rid of
it too.

Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 include/linux/count_zeros.h | 4 +---
 lib/crypto/mpi/longlong.h   | 8 ++++----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/count_zeros.h b/include/linux/count_zeros.h
index 5b8ff5ac660d..4e5680327ece 100644
--- a/include/linux/count_zeros.h
+++ b/include/linux/count_zeros.h
@@ -18,7 +18,7 @@
  *
  * If the MSB of @x is set, the result is 0.
  * If only the LSB of @x is set, then the result is BITS_PER_LONG-1.
- * If @x is 0 then the result is COUNT_LEADING_ZEROS_0.
+ * If @x is 0 then the result is BITS_PER_LONG.
  */
 static inline int count_leading_zeros(unsigned long x)
 {
@@ -28,8 +28,6 @@ static inline int count_leading_zeros(unsigned long x)
 		return BITS_PER_LONG - fls64(x);
 }
 
-#define COUNT_LEADING_ZEROS_0 BITS_PER_LONG
-
 /**
  * count_trailing_zeros - Count the number of zeros from the LSB forwards
  * @x: The value
diff --git a/lib/crypto/mpi/longlong.h b/lib/crypto/mpi/longlong.h
index b6fa1d08fb55..a5ef41c8f85d 100644
--- a/lib/crypto/mpi/longlong.h
+++ b/lib/crypto/mpi/longlong.h
@@ -66,12 +66,12 @@
  * denominator).  Like udiv_qrnnd but the numbers are signed.  The quotient
  * is rounded towards 0.
  *
- * 5) count_leading_zeros(count, x) counts the number of zero-bits from the
+ * 5) count_leading_zeros(x) counts the number of zero-bits from the
  * msb to the first non-zero bit in the UWtype X.  This is the number of
- * steps X needs to be shifted left to set the msb.  Undefined for X == 0,
- * unless the symbol COUNT_LEADING_ZEROS_0 is defined to some value.
+ * steps X needs to be shifted left to set the msb.
+ * count_leading_zeros(0) == BITS_PER_LONG
  *
- * 6) count_trailing_zeros(count, x) like count_leading_zeros, but counts
+ * 6) count_trailing_zeros() like count_leading_zeros, but counts
  * from the least significant end.
  *
  * 7) add_ssaaaa(high_sum, low_sum, high_addend_1, low_addend_1,
-- 
2.43.0

