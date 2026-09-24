Received: from avas.easytechitalia.it (avas.easytechitalia.it [213.217.29.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3572E7165
	for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2026 13:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.217.29.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790258048; cv=none; b=c8LgTnqbWOw/L7a676hPEiO+jRMhT9FmeiyLKZqSRllDmWrcBTgq3gGCT4ULEfDWHXAz+JJXvFAXOy4anjggBTXAisNa8zrwZWW8UlnIuJpFz+PI3gM/R0/XC9GmzTkP/FPVquX7mEGhHcpnENojpGPnvmrM0d8n7S4ugBDwZJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790258048; c=relaxed/simple;
	bh=w59vAarjQED26OtWYRcJPUeriJuNUEo1SNn3fTDv4sU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ad1NxT1hDTaFeX8wYK+9yVac5KuxaiV3bl4RVbqCALUuse9b8UxKgZHHkGtnZEMRs6YbX7zIvHYk4nNa8AnqSYto8fuO90KTKS/qc/Gz2PAHPLFAT1NortLom/C0cqyV2BgtywPLOuvEyGT7xchN3rPTovbqVKDrpodTx4hTpTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mtsistemi.it; spf=pass smtp.mailfrom=mtsistemi.it; dkim=fail (0-bit key) header.d=mtsistemi.it header.i=@mtsistemi.it header.b=XHluIrHn reason="key not found in DNS"; arc=none smtp.client-ip=213.217.29.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mtsistemi.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mtsistemi.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mtsistemi.it header.i=@mtsistemi.it header.b="XHluIrHn"
X-Envelope-From: <info@mtsistemi.it>
Received: from ngmx.easytechitalia.it (unknown [185.76.140.216])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by avas.easytechitalia.it (Postfix) with ESMTPS id 4hrFg26cXBzGnv7;
	Thu, 24 Sep 2026 15:53:50 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by ngmx.easytechitalia.it (Postfix) with ESMTP id 6E93517C481;
	Thu, 24 Sep 2026 15:52:04 +0200 (CEST)
Received: from ngmx.easytechitalia.it ([127.0.0.1])
 by localhost (ngmx.easytechitalia.it [127.0.0.1]) (amavis, port 10032)
 with ESMTP id FHEFsjg1oR3b; Thu, 24 Sep 2026 15:52:03 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by ngmx.easytechitalia.it (Postfix) with ESMTP id 177CC17DC3B;
	Thu, 24 Sep 2026 15:52:03 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 ngmx.easytechitalia.it 177CC17DC3B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mtsistemi.it;
	s=AD82E3E6-03E3-11EF-83D2-AF8217D6D3C6; t=1790257923;
	bh=w59vAarjQED26OtWYRcJPUeriJuNUEo1SNn3fTDv4sU=;
	h=From:To:Date:Message-ID:MIME-Version;
	b=XHluIrHnAQJjPoWHr+LStiD30Lc8FD5rm7DaGoJztA//c5ZxQMLd19dSevvCE3wTt
	 2/QVrdbEQUC9y7VS6jg93tiDpF+Z2ZexHPuc53DzwxsvfeRYEIkGvH08zzCF65f4FU
	 wvMZumHugfP4fpiRblqbRpqaTE/YQJ+CM4XJdRppjhD9nlphwQRv1qmQch1uDDwh7L
	 IMxELcDSDEO5BxbpkniS+TfbmQY+SBAVmzW6EaADgJLaeFlB8pR3xw/vAHTde5NGz3
	 XtgFb9C3KafRS6hRxLZTGunUFKtf4E7WpIowa7dV8ybxwErr6CD0M+cV0t9v71gNod
	 s2kHHSFoJtB+w==
X-Virus-Scanned: amavis at ngmx.easytechitalia.it
Received: from ngmx.easytechitalia.it ([127.0.0.1])
 by localhost (ngmx.easytechitalia.it [127.0.0.1]) (amavis, port 10026)
 with ESMTP id TsJJSNHAAwj2; Thu, 24 Sep 2026 15:52:03 +0200 (CEST)
Received: from [192.168.56.1] (93-38-124-109.ip70.fastwebnet.it [93.38.124.109])
	by ngmx.easytechitalia.it (Postfix) with ESMTPSA id B20CD17C481;
	Thu, 24 Sep 2026 15:52:02 +0200 (CEST)
From: Mattia Tadini <info@mtsistemi.it>
To: Tom Lendacky <thomas.lendacky@amd.com>,
 Mario Limonciello <mario.limonciello@amd.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] crypto: ccp - two PSP init fixes, and the AMD BC-250
Date: Thu, 24 Sep 2026 15:53:48 +0200
Message-ID: <17902580289.11296.7403498173307596661@mtsistemi.it>
In-Reply-To: <0902307a-52d2-41c9-9552-289d05c05153@amd.com>
References: <178984289056.12336.17662860552012704364@mtsistemi.it>
 <10469a97-1e55-438b-a9cc-7a7cf650c104@amd.com>
 <179007151736.36856.17325391038801459309@mtsistemi.it>
 <99667c45-b44b-4378-9d92-7fd9eb64ff16@amd.com>
 <0902307a-52d2-41c9-9552-289d05c05153@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Easytech-Libra-ESVA-Information: Please contact Easytech S.r.l. for more information
X-Easytech-Libra-ESVA-ID: 4hrFg26cXBzGnv7
X-Easytech-Libra-ESVA: No virus found
X-Easytech-Libra-ESVA-From: info@mtsistemi.it
X-Easytech-Libra-ESVA-Watermark: 1790862832.75239@MmQpJ95n2/K83gQad8cFKg

On 9/22/26 09:42, Tom Lendacky wrote:
> My take is to just drop it.

Understood, I'm dropping the series.

Thanks to both of you for the time and for the careful review.

Mattia
