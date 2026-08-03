Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C623AFCF0;
	Mon,  3 Aug 2026 21:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785791014; cv=none; b=Bks78D6ZK0pjxmAqS6Gdk1blmx40ZW2WU+T0WkiCFZegOCRPvcg3QVXVlDKtu+Ul9RCAoKyNKpVHUC8UD0PQlhI0+/0WxhBtYu4HurWqFlmy6OPxyvjTtiEb+R1uXOxleGuZQ1QvmmCCG5Svih8Om3yDWzZ6COmmWTz5jvPRaX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785791014; c=relaxed/simple;
	bh=njLqWK/JJwgt68An6mjE3dcetlOv16FtWj6haQMlHqE=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=JkQ+uswdq1nXLgOov+Ne6bTAeyqWca3JxhqyQXC88SmplLAv13gue0c2I4n6zNFGbEpQPa5FTx/tECfRmnemOKqrlmqNaVJ2EbGS40kDawaxbNTMfms9MOpci7oNI96qoH001o3umkKczY9j4PeyMkzul0xozAZBsKxB8Zcqse8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=kGttm5tZ; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="kGttm5tZ"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D75F440E00C3;
	Mon,  3 Aug 2026 21:03:29 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ZSu5exC3bX_2; Mon,  3 Aug 2026 21:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1785790998; bh=njLqWK/JJwgt68An6mjE3dcetlOv16FtWj6haQMlHqE=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=kGttm5tZZEgEcB/xuoHDY2g0ey9gcGtA+fTt9Pwz4EQrCinbfhmXo+uInr0jNU0Wn
	 byka9CzZTciPJqd/XR+vBdpG3Fmb04SGg/MolE4aJf72tqBYp3pTLVcaItbunX3kaB
	 gdOlpY9YK3HVyiVKG+3rGBH6zUTkG8QOCJDJJp168qtfJhDrA/8QyDfhKKrLUv1SB6
	 DzXwcHi0+GRwgsqfQCmvD5bKr3VECHMc8/9QQ5IsKURdmiYEcuOlQnb653V3IRFe1J
	 XTDWDSlf1HQb7GWkeAojbHvkjzvUNINZOVTfHjd6cynHecskIIWUhY+Edik2Ph825U
	 CF+B7FzIcXdcZV+j/pSqd3iJbihVXXICIPT8d6xWQp3XfwojK/xJtik9XYVWnrF/Zt
	 iha2piESoJQ28aTbYwawxaJA/Ejlh8Qf8/FXCQWAXsYIyZwTps3936F6prD04CfEjH
	 7QEKfF4j3HNzTAiQOfjj7ygpIJsWOQp0vn0ipcbFTkhQqDAAJ0/VYIUsLgLfVBn/Hr
	 m/Y7fxMHhFY83hooVx4AP+Oo1TUJrHN9Nz5XpQ10gq49mJBB9YahGW+Tz9WkmBk2j1
	 ba+/0hS64dXhFipQguykQSUStlUDfTiolF2gzpMvSo7gRc/hzzeKQSey1g3ZD8UoTS
	 dPxPJjgbwjD69hX9Vn2NB1v0=
Received: from ehlo.thunderbird.net (mobile-166-170-40-136.mycingular.net [166.170.40.136])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DBCAB40E016E;
	Mon,  3 Aug 2026 21:02:43 +0000 (UTC)
Date: Mon, 03 Aug 2026 21:02:34 +0000
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
In-Reply-To: <df5f5f6f-7278-42e7-bc7d-8e56187d1438@amd.com>
References: <748785f1-f176-4f0a-8b8d-eadf46b20960@amd.com> <178578506318.2377606.14791252769672870038@Ubuntu-2204-jammy-amd64-base> <df5f5f6f-7278-42e7-bc7d-8e56187d1438@amd.com>
Message-ID: <8DAAEA48-F2FA-4D52-8E56-4B7213155F12@alien8.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On August 3, 2026 7:37:59 PM UTC, "Kalra, Ashish" <ashish=2Ekalra@amd=2Ecom=
> wrote:
>RMPOPT_WORK_TIMEOUT is used by snp_rmpopt_all_physmem() (mod_delayed_work=
()), which is added in the next patch =E2=80=94 I'll
>move the define there so each patch is self-contained=2E=20

Yes, very much so=2E

>It isn't periodic either: the handler doesn't re-arm itself=2E The work r=
uns at setup and re-init with queue_delayed_work(),=20
>and then per SNP-guest teardown via mod_delayed_work() (batched by the ti=
meout) once the later patches wire that up=2E

Then I am missing an important aspect here: RMPOPT optimizes RMP checks bu=
t then what's the point if you do this only on SNP guest teardown and I'm a=
ssuming at guest init too?=20

What happens to long-running guests which never get restarted?=20

This would lead to the system fragmenting ad absurdum and us never optimiz=
ing the RMP table practically=2E

But the guest could, in its lifetime, free up a contiguous 1G=2E When are =
we optimizing this one then?

Is that what the sentence about optimizing during 1GB page cleanup in your=
 0th message all about?=20

In any case, your commit message needs to talk about when those optimizati=
on runs are happening and why=2E

Thx=2E

--=20
Small device=2E Typos and formatting crap
