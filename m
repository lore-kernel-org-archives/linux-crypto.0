Received: from avas.easytechitalia.it (avas.easytechitalia.it [213.217.29.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D307F424D41
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 10:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.217.29.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790071533; cv=none; b=tbqUGrs+vBU1TnR5pBuq+umpTmZHNqgDeQAM1gHjtzfSOnvXfC0Lr5Ko88EkuWzM+xwfbK/AmudVCmP6s+OsiuNwdZrx+n5ldi/Esxs9eEQBDtWN+y9xA1mpk8YzmxHf+Jt44BIO0tnQTYrjuRVeID42/pc/GQelqNBBFL26FAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790071533; c=relaxed/simple;
	bh=V20wVzEQwN71sYRuTHfqaDprdg00H+nIj9Y+ZGlHEZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oMZAjKlfmVyEhRrp/8KkQxdZry2CtPyiGLdCA483YVL1Y7rmX41rV/PixMrvhK6LMgh0XhsnHm0VYZ9wAYIc+HWHOZvtxmtRVkPUubiIN44FJGF3qyLSybPPyncKAIeCy+zvUw5/7De8OdNH+FhnHUnj3ijid0E/UdzBmjry9aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mtsistemi.it; spf=pass smtp.mailfrom=mtsistemi.it; dkim=fail (0-bit key) header.d=mtsistemi.it header.i=@mtsistemi.it header.b=S9XQXPST reason="key not found in DNS"; arc=none smtp.client-ip=213.217.29.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mtsistemi.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mtsistemi.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mtsistemi.it header.i=@mtsistemi.it header.b="S9XQXPST"
X-Envelope-From: <info@mtsistemi.it>
Received: from ngmx.easytechitalia.it (unknown [185.76.140.216])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by avas.easytechitalia.it (Postfix) with ESMTPS id 4hpwhJ0WRvzGnts;
	Tue, 22 Sep 2026 12:05:20 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by ngmx.easytechitalia.it (Postfix) with ESMTP id 953FE17C481;
	Tue, 22 Sep 2026 12:03:41 +0200 (CEST)
Received: from ngmx.easytechitalia.it ([127.0.0.1])
 by localhost (ngmx.easytechitalia.it [127.0.0.1]) (amavis, port 10032)
 with ESMTP id sVDnlDGrZ312; Tue, 22 Sep 2026 12:03:41 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by ngmx.easytechitalia.it (Postfix) with ESMTP id 2470817ABF9;
	Tue, 22 Sep 2026 12:03:41 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 ngmx.easytechitalia.it 2470817ABF9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mtsistemi.it;
	s=AD82E3E6-03E3-11EF-83D2-AF8217D6D3C6; t=1790071421;
	bh=GW102B8J1MDkdEZb8g+qKIYoQMeYi07Tw2Skekcai7Q=;
	h=From:To:Date:Message-ID:MIME-Version;
	b=S9XQXPSTqVx4v7zyIXMpZdEsSVx5V5eWh6IERO4lvHyvSqq6YPRkOx0vphUU5uplY
	 qmLn3kF7KHx1sjBvzAHvZLpKU9VglCewTbPYXIaqHiAFShtWgcckszBUSFDjwFMQF6
	 V2GY3r2FWLFqML9ZVYj4bPHgrt7iytD7RprNJi0TEqB5PeZ5B6f6eXXn78Mz5Vy1lQ
	 lNlOUgnaSCYYL3S2ymt/8F5MigzIYc8LzrgYZgPSS78IO1qHD1ZBVJ3pPiUgYHxIcF
	 TUTDCD1nY9Sekph5EeUkjVw20Oc5zYHeOj5azeQja45s5/db1hXI2CEcF2pOXCNSD8
	 GDwfKF2lMqDoA==
X-Virus-Scanned: amavis at ngmx.easytechitalia.it
Received: from ngmx.easytechitalia.it ([127.0.0.1])
 by localhost (ngmx.easytechitalia.it [127.0.0.1]) (amavis, port 10026)
 with ESMTP id 3lAbIUpZKdrB; Tue, 22 Sep 2026 12:03:41 +0200 (CEST)
Received: from [192.168.56.1] (93-38-124-109.ip70.fastwebnet.it [93.38.124.109])
	by ngmx.easytechitalia.it (Postfix) with ESMTPSA id BD39C17DC3B;
	Tue, 22 Sep 2026 12:03:40 +0200 (CEST)
From: Mattia Tadini <info@mtsistemi.it>
To: Mario Limonciello <mario.limonciello@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] crypto: ccp - two PSP init fixes, and the AMD BC-250
Date: Tue, 22 Sep 2026 12:05:17 +0200
Message-ID: <179007151736.36856.17325391038801459309@mtsistemi.it>
In-Reply-To: <10469a97-1e55-438b-a9cc-7a7cf650c104@amd.com>
References: <178984289056.12336.17662860552012704364@mtsistemi.it>
 <10469a97-1e55-438b-a9cc-7a7cf650c104@amd.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Easytech-Libra-ESVA-Information: Please contact Easytech S.r.l. for more information
X-Easytech-Libra-ESVA-ID: 4hpwhJ0WRvzGnts
X-Easytech-Libra-ESVA: No virus found
X-Easytech-Libra-ESVA-From: info@mtsistemi.it
X-Easytech-Libra-ESVA-Watermark: 1790676321.31182@yAltYgDXNtICWVI3c/Wa5w

On 9/21/26 10:10, Mario Limonciello wrote:
> Sorry; but what's the point of adding support?  You can't access the
> crypto engine, it doesn't run SEV or TEE, it doesn't support DBC, it
> doesn't report HSTI.

Thanks for looking at it. One correction first, and the mistake is
mine: the cover letter is wrong about HSTI. The security reporting bit
is clear, but psp_populate_hsti() then asks through the platform access
mailbox, and on this board PSP_CMD_HSTI_QUERY does answer. With the
series applied on 7.2.6:

  fused_part=3D1               debug_lock_on=3D1
  boot_integrity=3D0           tsme_status=3D0
  anti_rollback_status=3D0     rom_armor_enforced=3D0
  rpmc_production_enabled=3D0  rpmc_spirom_available=3D0
  hsp_tpm_available=3D0

> It seems that the capability register isn't even populated on this
> system.

It reads 0x00000002, the TEE bit and nothing else. That lone bit, with
no TEE behind it, is what patches 1 and 2 are about.

> To me it appears the patch series is a lot of "fixes" to let you
> read.... the bootloader version.  Am I missing something else?

Only the above. Once the device is bound, userspace gets the bootloader
version (fwupd picks it up as "Secure Processor", bootloader
00.1c.01.02) and the HSTI attributes. Nothing more: no crypto engine,
no SEV, no TEE, and the firmware rejects the DBC command.

If that is not enough to carry an ID, I understand, and patch 3 can go.
Patches 1 and 2 then have no reason to go in either: with the current
table I don't know of a shipped part that sets the TEE bit on a pspv1
or pspv2 function, so they would only guard against a device that is
not there.

So: would you take the series with the HSTI data as the justification
for patch 3 (I would send a v2 with a corrected cover letter), or
should I drop it?

Thanks,
Mattia
