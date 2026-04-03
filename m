Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84C32D8DC3
	for <linux-crypto@vger.kernel.org>; Fri,  3 Apr 2026 06:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775198964; cv=none; b=e89d+gAkcWNcSiLpQgJq6AJko2boazgi88ifUAG72d/qE+vN+lB4hbjf5ldvMe4q6nwu2+wfZ2Me7Bpmn+t5fcT6G7MikLDntBqXmi7YPnVyJIWKVWPpN808LUGUoSGIo7lk4GZ4iUoCR0fvuDkWX3eLP0tNCY1MW6REclpn/ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775198964; c=relaxed/simple;
	bh=EsIjX7BTm3rJrR+xnTUlzZBz1FaVfcjsMT+3BL2b6Tk=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=OglhLzusXr0d7ZNXTqnvrMhU0yhiAmoLPTLCKvxUAoGOTtQGWVW1p71vXJ/Ly5Z4+fDI35sBEQlkJuyxLlOZKIzwG/WcgdBv4AE3q+5BCNRJpXtQ5EVc9Y2piT5WuO9lCOGVEcJ/wITVGj3t6RfC6h4hpGSfT0zm+5AS9sN68KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lPU2xYfN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lPU2xYfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C9FC19424;
	Fri,  3 Apr 2026 06:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775198963;
	bh=EsIjX7BTm3rJrR+xnTUlzZBz1FaVfcjsMT+3BL2b6Tk=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=lPU2xYfNVM7mP+/B9dBe/DhMIIc/4yQtOIuWMYy6BsUOG9fxtdUGp8J2TBOlG7q9a
	 A7JhnZe5Xa1n6Wf2amtg0HcXvO+Bj/0aGNHI2Xb615mGjrOyhVZko597VTP05x3tO4
	 tM/uvLb9Tr1MI9tGAiAgcQi3KrWxUpZhy7gzXANam1S2RKBoapBhalCYfYqsGOxxUo
	 8P6mt/DpkhlI2WeuB3wDGnHEYmIfPKVE/QVp3lY1slAFRe3ZQ0dFkMIkUpysfq8X60
	 xaam3N1+COMb2qQTAhJ6zHpvJzz5CD+GFJm3C+iWYXa+WLexLkTdBDeLhJOnWNsGSH
	 oOv/1EF5aOgSg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 66745F4006F;
	Fri,  3 Apr 2026 02:49:22 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Fri, 03 Apr 2026 02:49:22 -0400
X-ME-Sender: <xms:8mLPafDZKbDcCv7rtFg0a1ZRr0tFjiPfSSoflicr1_J9LKwxhsxm0g>
    <xme:8mLPaQU_boBoLNUpgXrLjwHMbsEPmkyJPgljT98SR_M9072DGsABTXVG1tWIxrG8U
    hqvioPBm5g7GL9nHnY6SyLjR0dS17O3PMmfQtEaQctLix_NpB9O3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcuuehi
    vghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeeijeef
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    guodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeelqdef
    fedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrhgurd
    gtohhmpdhnsggprhgtphhtthhopeegpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    peguvghmhigrnhhshhesghhmrghilhdrtghomhdprhgtphhtthhopegvsghighhgvghrsh
    eskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqrghrmhdqkhgvrhhnvghl
    sehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheplhhinhhugidqtg
    hrhihpthhosehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:8mLPaSFZ-ZwcKrj5bnfF9mbOEhU6b78xY-AAkthe2XKwDhS06fH9tA>
    <xmx:8mLPaYuslSy-uIQ_sgVoXWH7zmXRJ_AtjsFJuhgzSsOumQPv3HSdKQ>
    <xmx:8mLPacU_ECrrWwZyQsF_j8e3dhAQiUuatQSMVTB5dFF2NiQSlfoatA>
    <xmx:8mLPacG35MTpfhkBX9kJjScp0eoGHG-70SsoCJosTbyqooBPoP6tqA>
    <xmx:8mLPaW3NBpxr-O7hmDA7augRB9A6FCItVZi0ZtZdwfxUeFwO-IKB2vYL>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 4431D700065; Fri,  3 Apr 2026 02:49:22 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AfnkVD7BdAFw
Date: Fri, 03 Apr 2026 08:49:04 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 "Demian Shulhan" <demyansh@gmail.com>
Message-Id: <9b5affa6-0e04-4256-b740-6ffdad1747b9@app.fastmail.com>
In-Reply-To: <20260402234028.GA2256@sol>
References: <20260330144630.33026-7-ardb@kernel.org>
 <20260401195943.GA2466@quark>
 <dc424b4a-11b5-475f-a53a-987b5813bac5@app.fastmail.com>
 <20260402234028.GA2256@sol>
Subject: Re: [PATCH 0/5] crc64: Tweak intrinsics code and enable it for ARM
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Fri, 3 Apr 2026, at 01:40, Eric Biggers wrote:
> On Thu, Apr 02, 2026 at 10:52:17AM +0200, Ard Biesheuvel wrote:
>> 
>> On Wed, 1 Apr 2026, at 21:59, Eric Biggers wrote:
>> > On Mon, Mar 30, 2026 at 04:46:31PM +0200, Ard Biesheuvel wrote:
>> >> Apply some tweaks to the new arm64 crc64 NEON intrinsics code, and wire
>> >> it up for the 32-bit ARM build. Note that true 32-bit ARM CPUs usually
>> >> don't implement the prerequisite 64x64 PMULL instructions, but 32-bit
>> >> kernels are commonly used on 64-bit capable hardware too, which do
>> >> implement the 32-bit versions of the crypto instructions if they are
>> >> implemented for the 64-bit ISA (as per the architecture).
>> >> 
>> >> Cc: Demian Shulhan <demyansh@gmail.com>
>> >> Cc: Eric Biggers <ebiggers@kernel.org>
>> >> 
>> >> Ard Biesheuvel (5):
>> >>   lib/crc: arm64: Drop unnecessary chunking logic from crc64
>> >>   lib/crc: arm64: Use existing macros for kernel-mode FPU cflags
>> >>   ARM: Add a neon-intrinsics.h header like on arm64
>> >>   lib/crc: arm64: Simplify intrinsics implementation
>> >>   lib/crc: arm: Enable arm64's NEON intrinsics implementation of crc64
>> >
>> > I think patches 3 and 4 should be swapped, so it's cleanups first (which
>> > make sense regardless of the 32-bit ARM support) and then the 32-bit ARM
>> > support.
>> >
>> 
>> Ok.
>
> I can also apply patches 1-2 and 4 now if you want.  Let me know if I
> should do that or if a new version is coming.
>

Yes, good idea. I'll take care of the ARM stuff next cycle.
