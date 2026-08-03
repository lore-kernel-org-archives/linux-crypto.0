Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEE93B19A6;
	Mon,  3 Aug 2026 21:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785791460; cv=none; b=ujqOQdGmOCpTvZ4v0sB3n+37nWxezio1i8O6LeX98CtXLgV0m1CQ4DM4ByAGiUPVoElbof9dMO63XJy1bNVUJ41U8Sp2bddDCJQOT0OzQ4p96C2PPABSR0pNJi6zAOjzRBhquWOZFbnYt1EbB97kDv8hbKIiPhwER5Gl4Oe94LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785791460; c=relaxed/simple;
	bh=Uyyfe+O3e55l7Vrfebs/9BP0OIeQjxFkNs3ChTS+CuE=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=mMkn5IB36XtW70aDPJahyWLuDpeoPUAjmMr91sUWbAEjODu+qhmfcDeKFNNlQRqtwZ0i7lyJkJZUHE55YHQSKywRq3m9+mYWnopCyHcadmdQpfOTwKUV5YExpaSzEChL5uCXNWu1J71qH8Gj4a/1d5SzGV0m4w1BH0FHTfazZkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ivmZ8cxU; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ivmZ8cxU"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id AB1EA40E029F;
	Mon,  3 Aug 2026 21:10:54 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id o9-mGQxJUWVb; Mon,  3 Aug 2026 21:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1785791443; bh=Uyyfe+O3e55l7Vrfebs/9BP0OIeQjxFkNs3ChTS+CuE=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=ivmZ8cxUyjCPAi75hkyQqE25OrL0G2JAV6XCNcBAztsCZBn21va81TCyn2PL+TLyI
	 NFkAODlIl76wJG801TlZzrJAhNjailNxlLOuSgOF7bTOLTrfvGjZ03w6hFIhLv93g6
	 CfRfDS/c8ah/sWrPGnYCEwS08SoiVmi+IFedxftAUyWizPVF1Xt4twQymZq0WN5G8Q
	 T5pOTxYvZgNx44k/f9vkr/2zjPUhXtogSfQ9deKjiewFFEKV7REkju17xWlzd8k4Gy
	 XG5AAW0xho4r5hx7RyPXjNnReSgOTMRJZyrXajDCdElCkPmweWWbg9rd2xAzU1DJlX
	 oLYBfzDSDheadv25PSp1VfxqFTE/sHGHXl5NAYsiBZqgDNXtlgzt0Qm+WcbWGDPlf9
	 cuAyA2xj9aBRD/ez064CUJrfb1HhhfRiqFJ2+XO/tGhPuf1r+JYRtijdEg8tYo/M7a
	 Zov9jCmRjhL80Lm1GfK9sOpOn9+FxY1ESuTBG3QkpdhGW9yebcbl1DSJ8tOU0oXbUL
	 tolbemIAKC08Fck2/GhasxT8972mdcCHOKABCfB47T3E7C6ty3j7jxEend+A5OOt2z
	 r/f79G8Xkl8i20dvV3eaEIDtPNtEs1oeFW4I15NcxaiFYMnFeptbpKhz4MucIq+x2h
	 lrjVjTCbkonS7EIYJ+Bxlcxc=
Received: from ehlo.thunderbird.net (mobile-166-170-40-136.mycingular.net [166.170.40.136])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 25EB940E00C3;
	Mon,  3 Aug 2026 21:10:08 +0000 (UTC)
Date: Mon, 03 Aug 2026 21:10:03 +0000
From: Borislav Petkov <bp@alien8.de>
To: "Kalra, Ashish" <ashish.kalra@amd.com>
CC: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
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
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v11_4/6=5D_x86/sev=3A_Add_support_t?=
 =?US-ASCII?Q?o_perform_RMP_optimizations_asynchronously?=
User-Agent: K-9 Mail for Android
In-Reply-To: <ecd09557-ed93-4d05-9850-d02c31900f87@amd.com>
References: <cover.1784844080.git.ashish.kalra@amd.com> <7f582569acea933c3045be604a81975e29b5ee2b.1784844080.git.ashish.kalra@amd.com> <20260731054425.GNamw2OelKuNhVwnrU@fat_crate.local> <ecd09557-ed93-4d05-9850-d02c31900f87@amd.com>
Message-ID: <49A3D2F7-D823-4968-8E80-4486226838A3@alien8.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On July 31, 2026 12:37:15 PM UTC, "Kalra, Ashish" <ashish=2Ekalra@amd=2Ecom=
> wrote:
>Yes, the checks are done on *all* memory but for ensuring the integrity o=
f SNP=20
>guest memory, so that is what the above paragraph is mentioning=2E

I don't understand: we're checking *all* memory in order to ensure SNP gue=
st memory integrity?=20

We're ensuring the integrity of the other memory just as well :-)

>The other way i can put it is: "RMP checks are skipped for 1-GB ranges th=
at don't contain SNP guest memory and=20
>as SNP guests are launched, RMPUPDATE disables the corresponding optimiza=
tions"=2E

Ok=2E

--=20
Small device=2E Typos and formatting crap
