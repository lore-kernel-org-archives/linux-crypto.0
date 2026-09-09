Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5680F2E229F;
	Wed,  9 Sep 2026 01:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788918802; cv=none; b=O7/KHnUXGeaadwrQcaZugRgs/AxF2eOTDtjTKq5GQf7fka6EIxN8X7VMWfHcDu3YZrEpwt+8npBDqiHJkBuFliKKUf5+lZo1Oko7RyOocax4QAhr54Jv3XXTyqaVkeuqNSxUdPk/3IoXfQAs/Emy18wmHkXlJa9XEQagQDCoBKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788918802; c=relaxed/simple;
	bh=7DrbTt0IzkCllsja452BCL3xroRKJmVPC6YFP2vBfj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qM63QxHOslBVqwxpMtWbJB4e7roXPTMFgg8vks7MM7hsJV//TWwv+J8+vKnHHwBoGKMbMdlaKYgFNIu7QB6lzVhXY/8M9Eyrm/TgZpYm0woOLMmmzjWLN/d4KscJRUs70qiClW7V3saYCvSw5C0B82BXKcx6qdD7kEdxZ6REp0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=fAOIEoJa reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="fAOIEoJa"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id CCF6B40E015D;
	Wed,  9 Sep 2026 01:53:17 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id JntrNfHcO6X8; Wed,  9 Sep 2026 01:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1788918785; bh=JKFSKtJABr8R3dcGxNXFu7BWTYdeMQYuM0L/vU9gMVU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fAOIEoJaWFwpHEXMoCkuRZisSwP/rvzOfavyw8VtswWf8lpYhbmBEoPzCy6NH4UMi
	 pJj9R8QmxKUVXrc4YJnh/WnX3SLTayl8TNaW9lLKcYIf584HoLkovST//xqrbY5fju
	 btCTtlbKHKR4tHikmf8YdzwnzC45/93Inm7hqaQweZUtBcSCbSQGT2cfJxRqHxtEPO
	 BLTaJwDEuNS10/nxinNjhmZjr5yFWQAwnGfvUzsPIheBpTLS0PxGhJpbb4BtV84QS1
	 P70q63xNNCrkeEE/OBpDdX5r+ZDyH0wljNgDYKQX3+QJG0vld1bxlXJfZ3s0apZM4b
	 BQTPB5gcUuWWTdc3lSTjmm9oNfU2JPmOYogD+aGg7Uyw1nNzPmZZ9L23VIrpau5crU
	 qm+crU7T71oWR6gJul2uvGFc4grKQvqFbw0XiDjOX+dn5vL2ayUYuN1tQbJ+7VcnMh
	 zqhu/Ha/wPuMxwAt+jt7hFHkwHiluIvx1ehTHWjGkF38fGtisjIEQVG/JicT/HQVkT
	 EUbM0cF6JkW+txggiwXAqC6t3zsK2Vqc8MYKNSva4anPgCHm808H0z/j6vO8ICOvTf
	 e/wKMvg1ZDcbIKRcecONvTonH+k5z6XjtQeCck3UJbzm4jqXAjTqNpG3exAtCrZTNG
	 0M3CvilkFl7c79KGCnOBqCag=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 78F6640E01E1;
	Wed,  9 Sep 2026 01:52:31 +0000 (UTC)
Date: Tue, 8 Sep 2026 18:52:28 -0700
From: Borislav Petkov <bp@alien8.de>
To: "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, seanjc@google.com,
	peterz@infradead.org, thomas.lendacky@amd.com,
	herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
	pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
	KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com,
	Nathan.Fontenot@amd.com, ackerleytng@google.com, jackyli@google.com,
	pgonda@google.com, rientjes@google.com, jacobhxu@google.com,
	xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
	babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com,
	darwi@linutronix.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev
Subject: Re: [PATCH v13 4/5] x86/sev: Add support to perform RMP
 optimizations asynchronously
Message-ID: <20260909015228.GBaqC73LJDUow_Xu6v@fat_crate.local>
References: <cover.1788296083.git.ashish.kalra@amd.com>
 <a31fc8c6d3f6c6bbe50dc4542c7091b0899d3e1b.1788296083.git.ashish.kalra@amd.com>
 <20260905012945.GPaptwicVjJ-SwXYzl@fat_crate.local>
 <4b940989-1c27-49a5-8112-d9f991ad1d48@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4b940989-1c27-49a5-8112-d9f991ad1d48@amd.com>
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 08, 2026 at 03:21:31PM -0500, Kalra, Ashish wrote:
> >> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
> >> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> >> Suggested-by: K Prateek Nayak <kprateek.nayak@amd.com>
> >> Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
> >> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
> >> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> >=20
> > R-by's need to get dropped when a patch changes in more or less signi=
ficant
> > way.
>=20
> Tom and Dave gave their R-by's on v12/v13 series, so probably i will ke=
ep their
> R-b's.

Tom gave you a R-by on v12 before I asked you to axe off a bunch of stuff=
 from
that patch. Dave gave you a R-by to this revision which is still under
discussion and you wanna keep it regardless.

There's a R-by Ackerley which you carry at least since v5:

https://lore.kernel.org/r/6f1ec3d8ebcf3aaceccc099c07d0deb545dd4ab9.177913=
3590.git.ashish.kalra@amd.com

to which Ackerley is STILL GIVING YOU review feedback ON THAT SAME THREAD=
:

https://lore.kernel.org/r/CAEvNRgGfyb7zvZ1u1j7YLomD%2BJdAxnVW36gtvNG9gxgZ=
80vMyQ@mail.gmail.com

and yet you're still debating.

From where I'm standing, it looks like you don't understand how those tag=
s
should be used.

Do you need to go refresh up on the docs:

"Both Tested-by and Reviewed-by tags, once received on mailing list from =
tester
or reviewer, should be added by author to the applicable patches when sen=
ding
next versions.  However if the patch has changed substantially in followi=
ng
version, these tags might not be applicable anymore and thus should be re=
moved.
Usually removal of someone's Acked-by, Tested-by or Reviewed-by tags shou=
ld be
mentioned in the patch changelog with an explanation (after the '---'
separator)."

?

You're using Suggested-by tags also willy-nilly:

"A Suggested-by: tag indicates that the patch idea is suggested by the pe=
rson
named and ensures credit to the person for the idea: if we diligently cre=
dit
our idea reporters, they will, hopefully, be inspired to help us again in=
 the
future. Note, this is one of only three tags you might be able to use wit=
hout
explicit permission of the person named (see 'Tagging people requires
permission' below for details)."

So all 4 people have suggested this patch?

No, ofc not. You have simply received review comments from them which you=
've
decided to integrate into your patch. This doesn't need a Suggested-by ta=
g.
This is normal patch review process. You should try it sometimes.

And this is damn well documented but you're still debating.

Well, you can debate all you want - those patches are not going anywhere =
until
you do them right. This is solely your call.

> So the fix is: keep the setup allocated once, but make setup always
> (re)program RMPOPT_BASE =E2=80=94 then we never need to clear it on dis=
able, and the
> cycle case is covered on re-init. Proposed fix:=20

Yes, you basically do the *minimal* work that is absolutely necessary and
leave everything else untouched because it is unnecessary complication to=
 all
the code and if one is going to toggle SNP and hotplug, then one has bigg=
er
problems than some leftover facilities.

> A full=E2=80=91physmem RMPOPT pass is a warm=E2=80=91up scan plus an IP=
I fan=E2=80=91out over up to 2TB. The default system_wq is per=E2=80=91CP=
U and concurrency=E2=80=91managed,
> a long=E2=80=91running item there runs on the queueing CPU's worker poo=
l and can stall (or be stalled by) other work on that pool. So we wanted =
it
> off system_wq and use a dedicated RMPOPT specific workqueue.
>=20
> Another thing i looked at is for long-running unbound work, probably th=
e standard shared queue is system_unbound_wq, which is probably built
> for this use case and won't clog the per-CPU system_wq.

You can't:

system_unbound_wq =3D alloc_workqueue("events_unbound", WQ_UNBOUND | __WQ=
_DEPRECATED, WQ_MAX_ACTIVE);
								   ^^^^^^^^^^^^^^^

	__WQ_DEPRECATED         =3D 1 << 19, /* internal: workqueue is deprecate=
d */

So if you do an unbound workqueue and then block migration around it, you=
're
basically doing a WQ_PERCPU one. So why don't you do one of those and dro=
p the
migration toggles around it?

All this talking is to get you to get the hint that *whatever* you do, it
needs to have a good comment above it explaining why it has been chosen t=
his
way. Or put that info in the commit message.

So that people who look at that code in the future, can change it after
knowing why.

And you should not do excessive commenting - it suffices if you put a cou=
ple
of key comments which explain non-trivial things only. The rest people ca=
n
figure out by simply reading the code.

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
