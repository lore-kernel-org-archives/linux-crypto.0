Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076903C1419
	for <linux-crypto@vger.kernel.org>; Thu,  2 Apr 2026 08:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775119960; cv=none; b=SzI3wDNDQjLfSVx5ZZWjE0HP5tfuTkkTij/Rp0TaXwbmB+uRZ9DT01dy4KnLjmnJ8V9xQjxPq6zOmx/xNXvoJq0s2qGgi2yGcUGmnxofd4ehnI7em3iPV7Zo7CgFeFaXY4R69Ncvom9JovuWBciS8Mk18NQZYXovnx4+z3eEjY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775119960; c=relaxed/simple;
	bh=aFk5VIQZLPLBAhuZ3QT5cJKl7kQu65ln885pZk6irZw=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=GQ64dLr9w/E7ewlHzLBjfc8xt+8QPqmR8rGvHDuQkV7p4Er8M4dKSLbyh5rokgTl0B2sjHkJeYSZVUBPJ8M6frWjDuKFXHQKBW8YMG6Wy47v9eNiDwsCh3Wr5fvisTJu/aQfdIgFpfJ/YbLATRjBomgZeAd+RZKsh8hVkRUvEko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dlgXU84Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dlgXU84Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631EDC116C6;
	Thu,  2 Apr 2026 08:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775119959;
	bh=aFk5VIQZLPLBAhuZ3QT5cJKl7kQu65ln885pZk6irZw=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=dlgXU84YMpPtmX8D0M3SxY1GpJzaY0VW0KSI4sQMyjwSDWvpV7321hiG3SNCa3l0n
	 pANn2ztGup9LuOUV5j1y/SZsE9/gcX19TxFi1yLiYIOYR8KK6CkcnH6iR4CfzYNfxN
	 w+NG884KJioS3bdaDJdalUUdkPUggf2KG60syQ6Ol/b37GA4wq1WC3iMFIqvNnt5zZ
	 8KtidtbV+81Iq8OgW2b/7ZuP72rkOIlpgTXxnpdQzQhBOMxCQzysiKjrIIkq3Z2eu1
	 +Dp8IEbfGG7cZp5RRYmR1++/bFVdy+yeonLfibLs4QprdkToVJNUNA9H+oucs6SYj/
	 phMb9GjvuMkJQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 57641F40068;
	Thu,  2 Apr 2026 04:52:38 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Thu, 02 Apr 2026 04:52:38 -0400
X-ME-Sender: <xms:Vi7OaXUOX3OR_q7wadGFI1HLHaJzOwizJRERy8ZkEJL_2TNjGlXewg>
    <xme:Vi7OaaYZ4SvwBB4T22fbmuWMtzBO5fUcBUCJeGDOq2Jh_1ROdxeJRW0vewYyipr0F
    yXII37AoYXxY4XoF7_C7EjlI-D9lNscukdwZnM6aqswFTiyjlNncF0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdehheelucetufdoteggodetrfdotf
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
X-ME-Proxy: <xmx:Vi7OaUe3WJ63jWQWN4NFvDE7BXPfsjmVn4PoZK8oD2Ad3k5S1_6dCQ>
    <xmx:Vi7OaRohevZo5IBjUi_wRhdj-MyfLQLXeniIqLsZ_rhTaaHwmuUWIA>
    <xmx:Vi7OaZCHoEPwDm8x9wTlSoL_EhdC1AV9GpZg3JTm_qjhqRzW2SROsg>
    <xmx:Vi7Oaeb-Efn41mnbbupW8mznN12y6zWqXFAVBk9XwlxM2Wre8q1lOg>
    <xmx:Vi7Oac6-xkrIjQhSXf-JxgEz6ixwwTBrg-ldLiSRH2MkcQDyMUxT8QuV>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 33D0D700065; Thu,  2 Apr 2026 04:52:38 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AfnkVD7BdAFw
Date: Thu, 02 Apr 2026 10:52:17 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 "Demian Shulhan" <demyansh@gmail.com>
Message-Id: <dc424b4a-11b5-475f-a53a-987b5813bac5@app.fastmail.com>
In-Reply-To: <20260401195943.GA2466@quark>
References: <20260330144630.33026-7-ardb@kernel.org>
 <20260401195943.GA2466@quark>
Subject: Re: [PATCH 0/5] crc64: Tweak intrinsics code and enable it for ARM
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Wed, 1 Apr 2026, at 21:59, Eric Biggers wrote:
> On Mon, Mar 30, 2026 at 04:46:31PM +0200, Ard Biesheuvel wrote:
>> Apply some tweaks to the new arm64 crc64 NEON intrinsics code, and wire
>> it up for the 32-bit ARM build. Note that true 32-bit ARM CPUs usually
>> don't implement the prerequisite 64x64 PMULL instructions, but 32-bit
>> kernels are commonly used on 64-bit capable hardware too, which do
>> implement the 32-bit versions of the crypto instructions if they are
>> implemented for the 64-bit ISA (as per the architecture).
>> 
>> Cc: Demian Shulhan <demyansh@gmail.com>
>> Cc: Eric Biggers <ebiggers@kernel.org>
>> 
>> Ard Biesheuvel (5):
>>   lib/crc: arm64: Drop unnecessary chunking logic from crc64
>>   lib/crc: arm64: Use existing macros for kernel-mode FPU cflags
>>   ARM: Add a neon-intrinsics.h header like on arm64
>>   lib/crc: arm64: Simplify intrinsics implementation
>>   lib/crc: arm: Enable arm64's NEON intrinsics implementation of crc64
>
> I think patches 3 and 4 should be swapped, so it's cleanups first (which
> make sense regardless of the 32-bit ARM support) and then the 32-bit ARM
> support.
>

Ok.

> I do think we should be aware that even with the code mostly shared
> using the NEON intrinsics, the 32-bit ARM support (which works only on
> CPUs that support PMULL, i.e. are also 64-bit capable) doesn't come for
> free.  We should expect to deal with occasional issues related to the
> intrinsics with certain compiler versions, compiler flags, etc.
>
> I assume that "32-bit kernels on ARMv8 CPUs" is currently still a big
> enough niche to bother with this, despite that niche getting smaller
> over time.

Running a 32-bit kernel on 64-bit capable hardware is usually done to reduce the RAM footprint, and that problem hasn't gotten any smaller lately. And 20x speedup is rather significant.

>  But as I mentioned I do think we should try to simplify it
> as much as possible, e.g. by supporting little-endian only and avoiding
> #ifdefs based on things like the compiler whenever possible.
>

Sure. The only reason I think this is worth the effort is because the same code can be used on ARM and arm64, so once this is no longer the case, I don't think we should bother.

So it makes sense to apply this reasoning to little endian as well - arm64 supports it so we can support in on ARM too.


