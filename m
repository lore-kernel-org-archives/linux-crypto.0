Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CA8314D05;
	Mon,  3 Aug 2026 19:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785785108; cv=none; b=qBglPYYsRvXIetWy3RrhpcXrorakgk3lysFdyRb6dd+ftcODxkHzD/6qRgVUMLvGcKVKrCJfl0Uu9VV6neD/OAWbn0oQD3MFe94uc3SyjY8JizV+MeDkdU/+2e/jqMDEYZNYCyHYnQxN63FvurE4Fr3J4qdTwWg8C/frmr8nWog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785785108; c=relaxed/simple;
	bh=OgQAkU2Yhklbb3bpcX/7lRMRxLXY1GE0uevDDVfrYMg=;
	h=Content-Type:MIME-Version:Subject:From:To:Cc:Date:Message-ID:
	 References:In-Reply-To; b=D0C03snDL57fK3Yn3gm7LHs0h7pdBaY0UwouH5POaGfB+LbW4kwJnIZRoZgmElyfv8dt4mPeKnbL4CN+2eWUA8n8xgouA+DVmSlI2+/znpit/bMT1nDTb3Wlh0/7voe3t4PVMhnu29dZWM08NvwKqhavg+RXl+ca/a82FgF4LIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=h35yKu+O; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="h35yKu+O"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 758D540E016E;
	Mon,  3 Aug 2026 19:25:02 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o3mcuYsbi382; Mon,  3 Aug 2026 19:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1785785096; bh=OgQAkU2Yhklbb3bpcX/7lRMRxLXY1GE0uevDDVfrYMg=;
	h=Subject:From:To:Cc:Date:References:In-Reply-To:From;
	b=h35yKu+Ohn+g8Mv9yKg/KH5QZWVl+DLb+NW6L0cVq/xq+KPsZBkfyHQ4k9II8Bz1l
	 3SPJE0fMCMD7zwhsFMkrULGMhajBUxGXmWXMP9rgoBfHqBtBCZS7RZtVNbjU+Oie5q
	 hCTFwJdm1884ACxlAlz1kp5i4Z1AkuYrjDkA8VWRZj+t3eQlEtxQv/OOL0GjnFC12Q
	 Amgu+QQfZoHCCa8dF8YEO2kpQKMOGTROHxL/OD3dPKmp/m1EYnyvm9KPgb0GqQamX3
	 BPwBUPGKcMvM/w3ywhyOzhxR3GAzrUsvM2ztGuYfBnMkF2XH3sSPMTXKryB5LvGfJR
	 5u4fAxYiFpWa9yGygneWNun9ve/iJSyUL2TVoRRoREgQSWGmfape/ZcnFWWCQHpBAN
	 hcaV1VW2kRqGNUjyChDbajMBYXNFbxZRcoWgkuz7tB39uzhuge1kBgVw2YmKisTlAP
	 OXutabcBqQ6Rsl3kjGes+NU+HJhxxCR+7rKp0Me1lGpb8tW6ev7VXuR6duuEIRif8P
	 8elbJ7hDpZU7GX8CeEV9Jogb3OPBqI4VyqWpLqCMXrjKTQ9NXCkaQ4HG+FAJ3ivq/U
	 BuylDPd8fuyuci+JS/TuwWfANKYmEf4iZjCntv3TVrn0H6DUi2sE3aR1rLUyoAbzD5
	 g550NqqjOUS1GTCAkrfVh1l0=
Received: from Ubuntu-2204-jammy-amd64-base (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2FFB540E0140;
	Mon,  3 Aug 2026 19:24:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v11 4/6] x86/sev: Add support to perform RMP optimizations
 asynchronously
From: "Borislav Petkov" <bp@alien8.de>
To: ashish.kalra@amd.com
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org, pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
Date: Mon, 03 Aug 2026 19:24:23 -0000
Message-ID: 
 <178578506318.2377606.14791252769672870038@Ubuntu-2204-jammy-amd64-base>
User-Agent: Modoboa 2.2.2
References: <748785f1-f176-4f0a-8b8d-eadf46b20960@amd.com>
In-Reply-To: <748785f1-f176-4f0a-8b8d-eadf46b20960@amd.com>

Kalra, Ashish <ashish.kalra@amd.com> wrote:
>Followers are RMP-scan cache hits (cheap) and this only runs at setup/teardown

How?

I see the workqueue running periodically. And in talking about periodically, RMPOPT_WORK_TIMEOUT is not used anywhere.

What's up?
