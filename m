Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4127229B78F;
	Mon,  3 Aug 2026 22:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785794784; cv=none; b=UbeRkyvflld8KzN0pZHA2BAijxi26OPbYDx/zUJtVo1EdJhdPWD/2ZS7lglTkbUt+EX6oBo6TnyjNLWUb4LTm9SENhgt+Fu/5dnpkTyRWK5om2iMRDVctQ5pvPkFz75zNxwRr/RTHOunHlV+egDlVc+AnbeBb/hILvgWYBzAdNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785794784; c=relaxed/simple;
	bh=lcZk/1IDbGbx2B6+c5LN6HkRqdK6pR7nTNkeGYnLt6c=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=LXOy9pDMtMX75SbJp/GQKHRIs2tzYvrtPcZvO/VujPkati2yuOJvEkQIxWc9RfGLuP0vAvLWfadDFzp7XiCv2hWkPFenMNC9gR1hB+K2RkT+HBmVC0QDTrHss9SAHod+VWPMgODt6ZRxHvegqLgsAGmxv6E0nQFSGH6AyCZ0xkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=bYxRNVlt; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="bYxRNVlt"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D5C6E40E0171;
	Mon,  3 Aug 2026 22:06:20 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id SIxR4OYYQPo3; Mon,  3 Aug 2026 22:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1785794769; bh=lcZk/1IDbGbx2B6+c5LN6HkRqdK6pR7nTNkeGYnLt6c=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=bYxRNVltiQhZx1b6KoFdhAkrSmKENedZ914BbXU3lhXEJgvQPNQN6Ir0iKSj831ss
	 Q4JiA+XZI364LFDJFPUgKQef5v01Vfn9maD4Rq/tQmpxfz9p3+hYWOLRqHlv9TVG5s
	 Yvyl5eM1v5SIOYWJsfrtbgDKUbq6dK9SNP3JCrIZXK0cw3jfTI6wBsG371/PTPrL0v
	 U8eO5HCZlV48s1Vc5+1Udp3SaCEFb0D+nVbK7NDhyMLdDOvYT5NaeJP08sg05BbL3Z
	 ufZk72iXCZ3Nveq6sY8hCawYAEEPUwHw7JgWJrXYHML3kj/jrfkAmFL3RLzuzDbvKa
	 bAMWnIGbtSvIJoYA6vRLtUBQme5oMx5eZ4hfPDg5tLQqxYy+PlsOU5qN6wdJ75yxot
	 nIcUrKRHYMzF4ySthWoN7sAf58khhEjU04XpYG+Q+AekbZggbzfAGqaZNZykzYuDMU
	 05rT9OHSAwOmSxqlCsrMBAhDpOyFrafh5ZSUgLfNpekXSyTQkzQQrq8yAc/e65Dcl3
	 usfYlYybKsn4LQkkOgJhhJf69rxC4t0KOEU7igk8/NzMAQ5Jc4mhE0KKMVG+CrVrvN
	 sEtHgOi4Uo86h7DQxrm0EODrZPqdDnyp5P4w5RLayHM7Y0pWyHxCvhu1/8+X1WRVt+
	 pKBpsEWm4pwz49I7W5R0uJNA=
Received: from ehlo.thunderbird.net (mobile-166-170-40-136.mycingular.net [166.170.40.136])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E7A1940E016E;
	Mon,  3 Aug 2026 22:05:33 +0000 (UTC)
Date: Mon, 03 Aug 2026 21:38:14 +0000
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
In-Reply-To: <d7a17bde-4af0-45ad-96bc-4717a1fa1545@amd.com>
References: <748785f1-f176-4f0a-8b8d-eadf46b20960@amd.com> <178578506318.2377606.14791252769672870038@Ubuntu-2204-jammy-amd64-base> <df5f5f6f-7278-42e7-bc7d-8e56187d1438@amd.com> <8DAAEA48-F2FA-4D52-8E56-4B7213155F12@alien8.de> <d7a17bde-4af0-45ad-96bc-4717a1fa1545@amd.com>
Message-ID: <60B4B369-19E7-44DF-BCCF-FC8DD851B2E7@alien8.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On August 3, 2026 9:23:41 PM UTC, "Kalra, Ashish" <ashish=2Ekalra@amd=2Ecom=
> wrote:
>yes, that's what the "optimizing during 1 GB page cleanup" sentence is ab=
out:

What about doing the optimization runs periodically?

--=20
Small device=2E Typos and formatting crap
