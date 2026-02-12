Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EC8326951;
	Thu, 12 Feb 2026 20:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770928817; cv=none; b=u1+kgN0G9MoJbEsqIR5eTp9+XaM2pYo1YBKisdans/n+kPFYb5o+LiRP2jOVCLzyrqjCCSHiYAwtCNKVbDQEPallQTq4dK2GHUWlvWWjXC0W5OJCBVzcCVnQEs2F6WeOLU9YUIbC8FVfQiwOyi6fNx5Hjei1TsFL5X6myh7w22U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770928817; c=relaxed/simple;
	bh=9Gc0/ilN7j5yF1KCkiGbXMqDqnOtVI+V0w9htJ9T/qI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=qCWvvv1SEC4cMy31y/YJl+ZLYKS/a6HEXxaekgNW+LSkWKe7UP3UHOFCtnzWn365CWy3zDEncDZTDriPGl2jNGkcj3SAnobKhHY2ZOmqOmDnsteGaj2TuKiUDz9/r8nI8aXQBj7EfTkCjWbWva5MTW++4LYDKWtHJwqIhAMzpHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q8YjkqXJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q8YjkqXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CB4C16AAE;
	Thu, 12 Feb 2026 20:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770928817;
	bh=9Gc0/ilN7j5yF1KCkiGbXMqDqnOtVI+V0w9htJ9T/qI=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=Q8YjkqXJDD5HSOHy5mSgIMixKpZNuoEO9D3A2rc3Z0lqKtg67BCJjikGH8RP0EDAH
	 Y2wpmaG6Q/Ur4Qgqzwy2Ye0grkEzxjeK4GJ4zuZ6FhbZ6L1Pkk6dfm+0KDs9ej9lH8
	 fD5Un3GVf7DuqF2yU2nwci0cIBe4J8Ll5QIBWPCZHQ4p5wLtlaE/+dOjpO4l+BXXLf
	 E3hw0CKn5t0NN2czazw5Z00x9yDozDtbIdrxTHBXXSPne+kFMWye8Ww8pCSn2rrqjg
	 NdAiQ5tIwdpNCyfT+2gnIFlgFg75KjWln4J/9riV+HyLiqY0MbXmacQ4BhPjIGxkz0
	 9pwWurobMIFuQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id AE1FCF4006C;
	Thu, 12 Feb 2026 15:40:14 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Thu, 12 Feb 2026 15:40:14 -0500
X-ME-Sender: <xms:rjqOaX0QLjTIfy27c3wPaNPIRvNddaaHAuyOUVu65QyF9gEOyAs6zg>
    <xme:rjqOaQ4nOA_FKbInLAEV68q_4hRhnK5woPvU4rhlsRJsEeBhoAP1d3gKSotK4yszU
    diS42BC7lux8IKxLTptldNVApg6wW4ayjZ8Tsqczw3Wf-rNLaD_vxBU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvtdeifeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnegouf
    hushhpvggtthffohhmrghinhculdegledmnecujfgurhepofggfffhvfevkfgjfhfutgfg
    sehtjeertdertddtnecuhfhrohhmpedftehrugcuuehivghshhgvuhhvvghlfdcuoegrrh
    gusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpeefieefjeetgefhieff
    vdekkeduvdejvddtgfduteehgeefjeekudeltefhkeeugeenucffohhmrghinhepghhith
    hhuhgsrdhiohenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpegrrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtd
    dtjeelqdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhho
    fhgrrhgurdgtohhmpdhnsggprhgtphhtthhopeefuddpmhhouggvpehsmhhtphhouhhtpd
    hrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtohepnhhivhgvughithgr
    segrlhhumhdrmhhithdrvgguuhdprhgtphhtthhopehluhhtohesrghmrggtrghpihhtrg
    hlrdhnvghtpdhrtghpthhtohepughpshhmihhthhesrghpvghrthhushhsohhluhhtihho
    nhhsrdgtohhmpdhrtghpthhtoheprghnughrvgifrdgtohhophgvrhefsegtihhtrhhigi
    drtghomhdprhgtphhtthhopegurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhrtghp
    thhtohepphgvthgvrhhhuhgvfigvsehgmhigrdguvgdprhgtphhtthhopehhvghrsggvrh
    htsehgohhnughorhdrrghprghnrgdrohhrghdrrghupdhrtghpthhtohepthhrvghntghh
    sghoohhtqdguvghvvghlsehgohhoghhlvghgrhhouhhpshdrtghomh
X-ME-Proxy: <xmx:rjqOadtbwIiIHCnUd_j9VP7bPDaeG7coXIhqRD0RRlF78n6PWXxVDA>
    <xmx:rjqOaauqeXbCkuhSUhTE9F-LaZrj4ZUdQ7dIm_TxvXkV89BcojG4Kw>
    <xmx:rjqOadsEr2p-s1zIBvnLMZp83TwcrlzaN8RCINinXrErvtqAAuGemQ>
    <xmx:rjqOaS5UVfIV_ibP30J--5sFuG6QylqzdCiG0GQBcc3n12cZjFu8gw>
    <xmx:rjqOaYB2PGF9YI179RUmYGnz5ol4bRje39RPhYrrBFzGH_3ioDmVMikp>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 7FC76700065; Thu, 12 Feb 2026 15:40:14 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AAnEvm6syrbF
Date: Thu, 12 Feb 2026 21:39:53 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Daniel P. Smith" <dpsmith@apertussolutions.com>,
 "Ross Philipson" <ross.philipson@oracle.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, linux-integrity@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-crypto@vger.kernel.org, kexec@lists.infradead.org,
 linux-efi@vger.kernel.org, iommu@lists.linux.dev, dave.hansen@linux.intel.com
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>,
 mjg59@srcf.ucam.org, James.Bottomley@hansenpartnership.com,
 peterhuewe@gmx.de, "Jarkko Sakkinen" <jarkko@kernel.org>, jgg@ziepe.ca,
 luto@amacapital.net, nivedita@alum.mit.edu,
 "Herbert Xu" <herbert@gondor.apana.org.au>, davem@davemloft.net,
 corbet@lwn.net, ebiederm@xmission.com, dwmw2@infradead.org,
 baolu.lu@linux.intel.com, kanth.ghatraju@oracle.com,
 andrew.cooper3@citrix.com, trenchboot-devel@googlegroups.com
Message-Id: <49d169bf-0ad2-49be-b7d7-fceb9e7f831a@app.fastmail.com>
In-Reply-To: <1ffd3cb5-2c76-4371-a067-3e4849907d80@apertussolutions.com>
References: <20251215233316.1076248-1-ross.philipson@oracle.com>
 <b5f2b5a5-b984-4ed3-a023-c06d634f9146@app.fastmail.com>
 <1ffd3cb5-2c76-4371-a067-3e4849907d80@apertussolutions.com>
Subject: Re: [PATCH v15 00/28] x86: Secure Launch support for Intel TXT
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 12 Feb 2026, at 20:49, Daniel P. Smith wrote:
> On 2/9/26 09:04, Ard Biesheuvel wrote:
...
>> Surprisingly, even when doing a secure launch, the EFI runtime services still work happily, which means (AIUI) that code that was excluded from the D-RTM TCB is still being executed at ring 0? Doesn't this defeat D-RTM entirely in the case some exploit is hidden in the EFI runtime code? Should we measure the contents of EfiRuntimeServicesCode regions too?
>
> Yes, in fact in the early days I specifically stated that we should 
> provide for the ability to measure the RS blocks. Particularly if you 
> are not in an environment where you can isolate the calls to RS from the 
> TCB. While the RS can pose runtime corruption risks, the larger concern 
> is integrating the D-RTM validation of the Intel System Resources 
> Defense (ISRD), aka SMI isolation/SMM Supervisor, provided by the Intel 
> System Security Report (ISSR). Within the ISSR is a list of memory 
> regions which the SMM Policy Shim (SPS) restricts a SMI handler's access 
> when running. This allows a kernel to restrict what access a SMI handler 
> are able to reach, thus allowing them to be removed from the TCB when 
> the appropriate guards are put in place.
>
> If you are interested in understanding these further, Satoshi Tanda has 
> probably the best technical explanation without Intel market speak.
>
> ISRD: https://tandasat.github.io/blog/2024/02/29/ISRD.html
> ISSR: https://tandasat.github.io/blog/2024/03/18/ISSR.html
>

Thanks, I'll take a look at those.

But would it be better to disable the runtime services by default when doing a secure launch? PREEMPT_RT already does the same.

> While you all care about Linux specifically, the 
> goal for TrenchBoot is to build a common approach that we can implement
> across any other open source OS.
>

I'd argue that relying on things like setup_header, boot_params and kernel_info is not a great way to achieve that. The reason I care about this is that you are relying on those things even when doing EFI boot, which makes your approach highly Linux/x86 specific.

Given that arm64 has no decompressor at all, it is highly likely (and acceptable) that only EFI boot can do a secure launch. It also implies that the core kernel is the only place where we can put the pieces that execute afterwards. So adopting a model now for x86 that we know does not generalize well across other architectures is something I am not keen on.

...
>> I've had a stab at implementing all of this in a manner that is more idiomatic for EFI boot:
>> 
>> - GRUB does minimal TXT related preparation upfront, and exposes the remaining functionality via a protocol that is attached to the loaded image by GRUB
>> - The SL stub is moved to the core kernel, with some startup code added to pivot to long mode
>> - the EFI stub executes and decompresses the kernel as usual
>> - if the protocol is present, the EFI stub calls it to pass the bootparams pointer, the base and size of the MLE and the header offset back to the GRUB code
>> - after calling ExitBootServices(), it calls another protocol method to trigger the secure launch.
>> 
...
>
> I think this is a great approach for UEFI, though we need to reconcile 
> this with non-UEFI situations such as booting under coreboot.

There are two approaches that I think are feasible for coreboot in this model:

- just unpack the ELF and boot that - there is already prior art for that with Xen. We can stick the MLE header offset in an ELF note where any loader can find it.

- stick with the current approach as much as possible, i.e., disable physical KASLR so that the decompressed kernel will end up right where the decompressor was loaded, which allows much of the secure launch preparation to be done as before. Only the final bits (including the call into the ACM itself) need to be deferred, and we can propose a generic mechanism for that via boot_params.

I'm working on a prototype of the latter, but GRUB is an odd beast and my x86 fu is weak.

I'd be happy to have a call to compare notes and see if we can come up with something we can all agree on (modulo the SHA-1 :-))


