Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013006.outbound.protection.outlook.com [40.107.162.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B133D3B42EB;
	Wed, 12 Aug 2026 08:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786523123; cv=fail; b=QNQ8xFcv1HekDu2gmni1BIJfIywKpPPcsgO5DWSfFbeWsEngPhJCJ0GeaMf9khA31xmetrU9lXKvzIF9X0LCCGTBN0tAU3t/AVLn7ys/KTcYCvoIvMAgGKZoLLpUuQrtz7WkSk2JCgtGbCEABfrmhiEQU48cFIF4svbguT6hip8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786523123; c=relaxed/simple;
	bh=KnScxYIFOym4ltAcq8+t49UJ3Dkt+VOTACyTBTk7Vyw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=s+Y+rvhyPojHqM0myHIXQ2XthRRYxuy0MEtKQh0h/178wGzqHHSbP8+k8ayCM6CNs+xCWFXcQz1uzSIXOG3jhgptWMBc/QKX1ADU+Jry1XzRgm6J2LpwFhMt/Y2zOux5Gzen+adN8tYlJf4+OCEta9eeMLEeWL0KReHB7bA2u1A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=NVixfBIv; arc=fail smtp.client-ip=40.107.162.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="NVixfBIv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yPELtnIvF+t8UtjKvyPMHUsnZVytj1R2sDrhDCEJ0xTtftuopubQ3KNAsstuDRdBOx7jJgxP+aDRLsWAZ41EnR3qGWMv7NbODLhzOwxoFad9hSrdXeUX5HvUwL6z540CEXd8AcJGv7ijX0Thu4zZY/YeO2UAgbBdY9t8r0I6e37z3zyXUz2MHZ9hMEgo20gR/ybWB0cdcx6rBOaPfiOfmmavd902AehHeE1EFYyk6afJ4TBJQTCoX4uA6KyMiggK5yFR4obd60BJkA0NBSYIOguFofZraf6wZg8CikhhKQFNSo0P4voK8eFBFRoIF07Z2kMQMjpzvdYVv01T0AEHOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yGxoy4Qr1CTeJR1yFOyNXpJKawHfSlW2niWWCQ9SVds=;
 b=TVs45NZ/bzL6OtZByDSSIhZrviG9BwlMk3eHrIz/hqY/UOp/8fRIqrgDXRXN4oaCUsQVsuM+G0RBs8//esg+kowwn6wxh6Kx+qvB5cKH7FhyA2mai6vSpHXQXOgn9IvAjuF1kQcst/ukUozMEAqEc3yV4szzlhIcpM/jiZFjKJOlklXMmDbT5DkMuD8y1CxjDZYtErH/CrP74oazXsVcaVWSPzNSOUIUNrj9QEE78g+0UAJbU8CRSBuwe77T9TlYJzV3Vyj/slHM0FfuOc7KubNeMoaBWI85bmGfU1Uu5+MDgJVUGoNnTlqd9IT+28YA91SKR+y5+7H/l6qvovmd2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 164.130.1.59) smtp.rcpttodomain=gmail.com smtp.mailfrom=foss.st.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=foss.st.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGxoy4Qr1CTeJR1yFOyNXpJKawHfSlW2niWWCQ9SVds=;
 b=NVixfBIvapc9OHBL7aYoJxm+WBJoc2f9TlXpDG0JIIc+Q0J4su3fnhsmELKp0CpnVA/XaC400I2LnM6ge+US5CMiGdrLnRrszuZ9p9ujIdd4rCD7+0dwpVlz0VO+pNCpQ8agvhL12kDdQaYIxadr9pMfNvhx+PcwQtgcvedJ+WZ1irPWc+n2NJEcKlSZsdASpwh/yJ9O1kgZZiaLvUPeFCSyjAWnnEni22G7nAgGe1sD+o9RBwmM9U+NiiAoqgEHhs6x8CM3ZzA5QBIMzLVMgCyK6v412nZAb6YtKEELHi8lWMl1Je6Egs5+ox1P19MdEdhHll9ltXwgQfBXFj+4Gw==
Received: from DU2PR04CA0039.eurprd04.prod.outlook.com (2603:10a6:10:234::14)
 by AS1PR10MB5745.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:47c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Wed, 12 Aug
 2026 08:25:17 +0000
Received: from DU6PEPF00009523.eurprd02.prod.outlook.com
 (2603:10a6:10:234:cafe::28) by DU2PR04CA0039.outlook.office365.com
 (2603:10a6:10:234::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.13 via Frontend Transport; Wed,
 12 Aug 2026 08:25:17 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 164.130.1.59)
 smtp.mailfrom=foss.st.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=foss.st.com;
Received-SPF: Fail (protection.outlook.com: domain of foss.st.com does not
 designate 164.130.1.59 as permitted sender) receiver=protection.outlook.com;
 client-ip=164.130.1.59; helo=smtpO365.st.com;
Received: from smtpO365.st.com (164.130.1.59) by
 DU6PEPF00009523.mail.protection.outlook.com (10.167.8.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Wed, 12 Aug 2026 08:25:16 +0000
Received: from STKDAG1NODE2.st.com (10.75.128.133) by smtpo365.st.com
 (10.250.44.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Wed, 12 Aug
 2026 10:30:46 +0200
Received: from [10.48.86.103] (10.48.86.103) by STKDAG1NODE2.st.com
 (10.75.128.133) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Wed, 12 Aug
 2026 10:25:15 +0200
Message-ID: <6565654b-8516-4878-b617-7cd65992c2a6@foss.st.com>
Date: Wed, 12 Aug 2026 10:25:15 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] hwrng: stm32: fix usage_count leak when
 autosuspend_delay is negative
To: Guangshuo Li <lgs201920130244@gmail.com>, Olivia Mackall
	<olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, "Maxime
 Coquelin" <mcoquelin.stm32@gmail.com>, Alexandre Torgue
	<alexandre.torgue@foss.st.com>, Daniel Thompson <danielt@kernel.org>, "Linus
 Walleij" <linusw@kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-stm32@st-md-mailman.stormreply.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <stable@vger.kernel.org>
References: <20260811063442.3058074-1-lgs201920130244@gmail.com>
Content-Language: en-US
From: Maxime MERE <maxime.mere@foss.st.com>
In-Reply-To: <20260811063442.3058074-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ENXCAS1NODE2.st.com (10.75.128.138) To STKDAG1NODE2.st.com
 (10.75.128.133)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU6PEPF00009523:EE_|AS1PR10MB5745:EE_
X-MS-Office365-Filtering-Correlation-Id: 55f7c696-db1f-4aae-aab5-08def84b3d6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|7416014|1800799024|376014|921020|18002099003|22082099003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	f1gNIBfA7CPVw0TEzgTmEmnxHHWV0H0oGRJfh5qnsYEkE/czi/OXteD3ekciCPxOyFuGMRkFPUPz9IbDVGsJd4a4sU3G8jFK86ym4Qk7l9bTO6CH99q0ThB1fetlzfzdVjI6OMs3QybU4/3G5qndNZwQuxcB831fpd25jf8NJXyAQwwQAFLoy3soN7eaV/tQ1hGW1BAph1hr24aHvwU19iy8OzV1x7TgZRk6MJBe7IoY2HnyTyfxBGKSz4W0WPotFhUFfHRpvRjTroQfdOWxqR9Z7u6g2pe3wntdT3fSUydChtkjElTE9X65UvchcuKi31ZV6LYDu/ql6pBCStA6PwxGp41/SfOkADHygNTRyPgcelHHo7JRwkogPVAjBLL9QNwWlcPbw8ies/nO8wG/6TKp8F8Mqx609kNKPbhAoY73M5qjqKFEIkjpMl8cJdrR1XkL9KkB65/FIqKWgMvhZO0fKsLzTRLpzW+FOfSnDtmtCsyXKYhPPa9rSZmvA6BrueaIxeCee3yP/KBr0okhYmytCOIirKcu5myAu5CN4hfgKxRKrU9VR/V63ps6YjqVVQ3ylkZKWn5iENkUOeVzeNI/IHWNCYWhm+2kEFv273ahh65vdAFSfXnkXgqsMvTPUXveYE/xS+IETbfkfkFf+0pQGwQrfJC8P6Sn7038w4UKw9+baJca4GJk3WSJXlCzZ0sQ8yL1Lj5tccxDxWJzoHWcB572vaX/aV1RKHW8WSrDwMkQPVFOMP7AHwSbQ8c/
X-Forefront-Antispam-Report:
	CIP:164.130.1.59;CTRY:IT;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:smtpO365.st.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(7416014)(1800799024)(376014)(921020)(18002099003)(22082099003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rCNtZ3RBfN7v1IRzAvXmpQJ8tO7vlI+/Lbd9Y5PMrGP6zArLF7nSzKZLTNboC7GDlWPRcByyXTHahmfUVcut36ogzOJEGLereOd3FBHV57da+MSXEnQyyuXlv8pToIb7chmwp4sBBVpLiNF5KzPOLejUHQIZjn1TjSTEHHUtYMi1Z6YnDHfu9ZHb1nNqN46VSW3Act55/3qedeas7K3naOds93W2BpMKwXrliMkFZ7zK4ficcQ2j3sOHzNxjnBja05zaujsffcm0QHq6EMZTd7y2plWfaz5ppBuHN/WPKWoye6J6AMj7QTzc9scJemk/+fFMvgz2gAlV/AnkC64kplNZb9/pfko/ziXu6bUyf6eRACvXvOCIs7a/XeQeEF0eJwzB+h8M/wDEL+qppbBS6Wt1WiPVE/+JxRH4DPG+pPZ2sdSNKQ26/t7dk9erq07F
X-OriginatorOrg: foss.st.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 08:25:16.8878
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55f7c696-db1f-4aae-aab5-08def84b3d6e
X-MS-Exchange-CrossTenant-Id: 75e027c9-20d5-47d5-b82f-77d7cd041e8f
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=75e027c9-20d5-47d5-b82f-77d7cd041e8f;Ip=[164.130.1.59];Helo=[smtpO365.st.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009523.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR10MB5745

On 8/11/26 08:34, Guangshuo Li wrote:
> stm32_rng_probe() calls pm_runtime_use_autosuspend(), but runtime PM is
> enabled with pm_runtime_enable() and the matching
> pm_runtime_dont_use_autosuspend() is not called on driver teardown.
> 
> If the autosuspend delay is set to a negative value while autosuspend
> is enabled, the runtime PM core increments usage_count to prevent
> runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
> during teardown, this reference is not dropped and usage_count remains
> unbalanced.
> 
> Use devm_pm_runtime_enable() so that pm_runtime_dont_use_autosuspend()
> and pm_runtime_disable() are automatically called on probe failure and
> driver teardown. With runtime PM cleanup handled by devres,
> stm32_rng_remove() is no longer needed.
> 
> This issue was found by manual code inspection.
> 
> Fixes: c6a97c42e399 ("hwrng: stm32 - add support for STM32 HW RNG")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>

Hi Guangshuo,

Thanks for your investigation. You've found one problem, but I think 
you've solved three issues with your patch, and the one you describe is 
the most minor of them.

The usage_count imbalance is real, but the driver never sets a negative 
autosuspend_delay_ms itself, and the count is rebalanced on the next 
probe anyway.

For the two others: when stm32_rng_read() arms a 100 ms autosuspend 
timer, if we unbind within this 100 ms window, stm32_rng_remove() 
cancels the pending suspend and leaves the device RPM_ACTIVE: 
stm32_rng_runtime_suspend() never runs, so the RNG is left enabled with 
its clocks prepared and its power domain held forever. Moreover, the 
remove operation runs before devres released the hwrng registration, so 
reads could still land on a device whose runtime PM was already disabled 
and fail with -EACCES.

Your patch fixes both, because devm_pm_runtime_enable() registered 
before devm_hwrng_register() unwinds in the right order and 
pm_runtime_dont_use_autosuspend() forces a synchronous suspend before 
the disable.

So I recommend adapting your commit message around those points, as I 
think the Cc: stable is justified by those two.

Reviewed-by: Maxime Méré <maxime.mere@foss.st.com>

Cheers,

Maxime
