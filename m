Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BE33783D1;
	Mon,  9 Feb 2026 14:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770645987; cv=none; b=sqSTkReX5lud3qQ/DuYfthl4o9Qn/8KES4nfInHOFvTp1ROv23QG4OcdGd3V0Qrv8H/ho2nwKltoEz7V30G7zZQjnES2NmD6rGdC6kmj8xdLeNXplsPuJUbqOYLmqRHc4HUySBhcooHQvDZuxTu7URlnEogOR+15Nvf/dA8ig7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770645987; c=relaxed/simple;
	bh=WYECX5SXJ228M5jBGqJxP6dlxH7z8FBmfDhplBvQyNA=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=VYhD8N7s4Z6v8O/mekhitWkQWZw9gEhnRmTmdp/ovnI44kJ5JYTQj7NNCbwTifxFHPA6J7IQ7Eh+S8EcZQ8nDFhSLvGWg+SU9aoWqSubkamywpojhG0xBucdYHr6MF4iwj3OvHwccpKFLlQw0NkuQ3p/eMOJIueT4X+ZoM9ao3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nqaei6k0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nqaei6k0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D061C19424;
	Mon,  9 Feb 2026 14:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770645986;
	bh=WYECX5SXJ228M5jBGqJxP6dlxH7z8FBmfDhplBvQyNA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=Nqaei6k05Q/DhlRq9r1x/EcPXoaFx+9YhtkVy51zs8T5adcEb8G5bApEMw+mdUOOj
	 /BM58X9WiMvkKCaSx3BqPxyHiwOyDmZF/MzDaHkUxG0VHWujRE0vZmjBszeid+uQhD
	 x1GdKQW8DyIotjSoD+FNEPiOKcWzdASOyeMCV/ujYMnpfMHM3IGNq4z0xy0DGxqxpv
	 M/NIlgbrPnyB4/GLvJ/uLX08b3bF5Ik8SNL91g9Al4vHkpa4vgN6KjHcMd3uen2ZN5
	 rVXPxC8PjYipmaaMWOss0DKBV5t35yjU+a5WA40GtzvbCuzNH9w2ITmtEyiao0CE83
	 On4LBRFXW05lQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 1BD8AF40068;
	Mon,  9 Feb 2026 09:06:25 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Mon, 09 Feb 2026 09:06:25 -0500
X-ME-Sender: <xms:4emJaTad_Wco9m3j7o3lgpax2A6VgGCE8LZeGlO9i5g2yHyEDNUiHw>
    <xme:4emJadNHkb9EKjKmR5ad65jXJKhI9WcoOxoazz_YJlip6wBxlVxBeuygzzZ21Nwrv
    KHso3jK22jchQasdrWQMQ3oh9QNVDuPbfnhAnDLDBRUXmvb2K1YWAo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduleejtddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedtgefgheeutdeivdegiefgueeghfekhfffhfetheeggefhheeuvdegieev
    tdefudenucffohhmrghinhepthhrvghntghhsghoohhtrdhorhhgpdhkvghrnhgvlhdroh
    hrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegr
    rhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeelqd
    effedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrhgu
    rdgtohhmpdhnsggprhgtphhtthhopeefuddpmhhouggvpehsmhhtphhouhhtpdhrtghpth
    htohepsghpsegrlhhivghnkedruggvpdhrtghpthhtohepnhhivhgvughithgrsegrlhhu
    mhdrmhhithdrvgguuhdprhgtphhtthhopehluhhtohesrghmrggtrghpihhtrghlrdhnvg
    htpdhrtghpthhtohepughpshhmihhthhesrghpvghrthhushhsohhluhhtihhonhhsrdgt
    ohhmpdhrtghpthhtoheprghnughrvgifrdgtohhophgvrhefsegtihhtrhhigidrtghomh
    dprhgtphhtthhopegurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhrtghpthhtohep
    phgvthgvrhhhuhgvfigvsehgmhigrdguvgdprhgtphhtthhopehhvghrsggvrhhtsehgoh
    hnughorhdrrghprghnrgdrohhrghdrrghupdhrtghpthhtohepthhrvghntghhsghoohht
    qdguvghvvghlsehgohhoghhlvghgrhhouhhpshdrtghomh
X-ME-Proxy: <xmx:4emJaQzUmyPR98OS0DVfVCBs7nP2yOprhVntmSFyFqqjCmSR2Op5vA>
    <xmx:4emJaYjdE9_HEUdD0T7A9LUZNY5kj5IvupGKg9KTA8aXMCOAi4HI0Q>
    <xmx:4emJafQ6xQcu41rnAo5XeQjx4pSSvTX8JVKYhyLWPcyn_t6QftTgKQ>
    <xmx:4emJadPScFbmSVydk2_hRmtKQrY0ItBJpYwS2Vv8kIokJLoMdP3xtA>
    <xmx:4emJacGg1Yqc0Zi7oImUY8WRMQf-r0h2LVcpe4s-75BQFRJhA66uOmpp>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id DEDB1700065; Mon,  9 Feb 2026 09:06:24 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AAnEvm6syrbF
Date: Mon, 09 Feb 2026 15:04:36 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Ross Philipson" <ross.philipson@oracle.com>,
 linux-kernel@vger.kernel.org, x86@kernel.org,
 linux-integrity@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-crypto@vger.kernel.org, kexec@lists.infradead.org,
 linux-efi@vger.kernel.org, iommu@lists.linux.dev
Cc: dpsmith@apertussolutions.com, "Thomas Gleixner" <tglx@linutronix.de>,
 mingo@redhat.com, bp@alien8.de, "H . Peter Anvin" <hpa@zytor.com>,
 dave.hansen@linux.intel.com, mjg59@srcf.ucam.org,
 James.Bottomley@hansenpartnership.com, peterhuewe@gmx.de, jarkko@kernel.org,
 jgg@ziepe.ca, luto@amacapital.net, nivedita@alum.mit.edu,
 herbert@gondor.apana.org.au, davem@davemloft.net, corbet@lwn.net,
 ebiederm@xmission.com, dwmw2@infradead.org, baolu.lu@linux.intel.com,
 kanth.ghatraju@oracle.com, andrew.cooper3@citrix.com,
 trenchboot-devel@googlegroups.com
Message-Id: <b5f2b5a5-b984-4ed3-a023-c06d634f9146@app.fastmail.com>
In-Reply-To: <20251215233316.1076248-1-ross.philipson@oracle.com>
References: <20251215233316.1076248-1-ross.philipson@oracle.com>
Subject: Re: [PATCH v15 00/28] x86: Secure Launch support for Intel TXT
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 16 Dec 2025, at 00:32, Ross Philipson wrote:
> Secure Launch is a vendor-neutral approach to implementing TGC Dynamic
> Root of Trust (DRTM) support in the kernel. This is complementary to
> better known Static Root of Trust (SRTM) schemes such as UEFI SecureBoot.
>
> This series provides the common infrastructure along with Intel TXT
> support, without needing the tboot exokernel. Support for AMD SKINIT is
> pending the common infrastructure getting nailed down, and ARM are
> looking to build on it too.
>
> Originally, tboot were approached to see if they'd take support for
> other vendors, but they elected not to. Hence this approach instead.
>
> Work is being coordinated by the Trenchboot project, 
> https://trenchboot.org/,
> organising Secure Launch support for upstream open source projects 
> including
> Grub, iPXE and Xen. The goal of the Trenchboot project is to make DTRM 
> easy
> to use.  e.g. for Grub, it's simply adding "slaunch" as a command in 
> the boot
> stanza.  See 
> https://trenchboot.org/user-docs/QUICKSTART/#linux-quick-start-guide
> for more details
>
> Patch set based on commit:
> torvalds/master/fd57572253bc356330dbe5b233c2e1d8426c66fd
>
> Depends on v3 of the following TPM patch set (note this patch
> set is being actively worked on separately):
> [PATCH v3 00/10]  tpm: Decouple Trenchboot dependencies
> Message ID: 20250929194832.2913286-1-jarkko@kernel.org
>
> Finally we would like to thank everyone for their input and
> assistance. It has all been very helpful in improving the quality of
> our solution and in reviewing/strengthening our security posture.
>

Hi Daniel and Ross,

I have finally gotten around to getting the right hardware and building GRUB and Linux with your patches, and I have managed to get them running on an old Skylake HP laptop successfully.

Surprisingly, even when doing a secure launch, the EFI runtime services still work happily, which means (AIUI) that code that was excluded from the D-RTM TCB is still being executed at ring 0? Doesn't this defeat D-RTM entirely in the case some exploit is hidden in the EFI runtime code? Should we measure the contents of EfiRuntimeServicesCode regions too?

In any case, I am aware that upstreaming this work has been a painful experience so far. Unfortunately, I don't think we're quite there yet.

The way the work is divided between GRUB and Linux seems to be predicated entirely (at least originally) on the idea that the GRUB->Linux handover and the secure launch should be one and the same. I.e., GRUB sets the stage, pokes the ACM, which returns to the loaded linux image and boots it. This requires a lot of coordination, e.g., putting a MLE header in the kernel image and exposing it to GRUB in a certain manner, resource tables and other things that have to remain in sync between both sides.

There also appears to be an assumption that the fact that the ACM returns to the loaded image in 32-bit mode requires a round trip through the decompressor, which may relocate itself in memory and do other things that the slaunch code then has to work around again.

Due to the changes to the EFI boot path, this design has been watered down a bit already, in the sense that GRUB invokes the EFI entry point as usual, and only later, the pivot via the ACM is made.

Other than the SHA-1 debate [*], the main issue I have with this approach is that it adds things to the boot ABI that are closely tied to TXT on the one hand, and bzImage oddities on the other (kernel_info, setup block etc). IOW, the complete lack of abstractions is going to make this a maintenance burden going forward.

I've had a stab at implementing all of this in a manner that is more idiomatic for EFI boot:

- GRUB does minimal TXT related preparation upfront, and exposes the remaining functionality via a protocol that is attached to the loaded image by GRUB
- The SL stub is moved to the core kernel, with some startup code added to pivot to long mode
- the EFI stub executes and decompresses the kernel as usual
- if the protocol is present, the EFI stub calls it to pass the bootparams pointer, the base and size of the MLE and the header offset back to the GRUB code
- after calling ExitBootServices(), it calls another protocol method to trigger the secure launch.

The only pre-launch ABI that is being added here is a GRUB-specific protocol that is not necessarily tied to TXT. (For legacy boot, it should be feasible to call back into GRUB too, although it would be more of a ad-hoc construction, via the SLR table perhaps.) But no kernel_info and MLE headers etc being added to the ABI surface. Also, there is no longer a need for the GRUB code to understand how the decompressor is constructed, with a setup block etc, or take special care to perform PMR checks when its moves itself around in memory.

Code can be found here:

https://git.kernel.org/pub/scm/linux/kernel/git/ardb/grub.git/log/?h=sl-v2
https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=x86-slaunch

I am aware that this is not the feedback you are waiting for at this point, given that we're at v15 already. But there are some warts in the current design that really need to be addressed before we can proceed with this IMHO.

-- 
Ard.


[*] which I still don't get: why is it fine to cap other banks with a single 0x1 byte [as the ACM does too, apparently], but do we require an SHA-1 implementation for capping the SHA-1 banks? Also, the TXT spec dropped all support for TPM1.2 so I wonder if that should be dropped from this series as well.
