Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875D23E95B6
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 07:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773128569; cv=none; b=Ly0tIPJ4lglWYXXX8Ja/V+GcpLnuZY8M0Yc0VqXfRbEudZCf00OMqxJCq55d35Q/ZBrlubBtT4UuTtqcLD8YHHCQ4OySeWOs0WIdR+ns3FNw2gvp0L06SqNjVIOwnQsQ4yk0GdTm7RZMqyqZidMNd68Gx034EFeoW77Jm64YmiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773128569; c=relaxed/simple;
	bh=wFKpi7+VVpfaVKhDCrF3fX+ozd5oz7Nfe0OhSYw2oPQ=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=sSZnerBY2Yh64KLpZuN7LtBsAbF71YcaEsOnCltvi97INRmumc6MZRFe8g1oPHhaHFDR1ZSDtQWLmwFvMmgRg6+3bHBG/CeaQSdHtdk/Rax2lwqsCuh0+kKD/k9XEnXfAlQGidSTxEOK0ArmkMjGnC6r+C20EIHHoEt/zzZcdec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IwkWzVEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IwkWzVEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D152C19423;
	Tue, 10 Mar 2026 07:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773128569;
	bh=wFKpi7+VVpfaVKhDCrF3fX+ozd5oz7Nfe0OhSYw2oPQ=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=IwkWzVEnm+DvQN+pxHUfSanGORMRI7ivFSX89iAtsVD9omSSLt3GQIWr35WXUctKn
	 R+XXEHjAMVydRBLqmnZyPXFlXEWYHwnkBuCvZdzA8/DqQPN2NgsV/Xu3DPqAAKcwnB
	 DmitvdR5ks1jVCBqm0uslVMsaUMA60zxCGfrqjMZBMQkrm5RWSvZ5ioE4oKkn4yGvN
	 gXa4sMWKB+dL5gDXcnYLEiDkCmrP72/rer3KOQwTxWo5glpg5DBibAVqTLuWPcvTG8
	 E1Ioi3n54d3/VTCrlN1LNUPCMGOxNwtZOCp343QSGVlYp8eiVOMlhuyI8i1+pqMpP3
	 lk2F9inE0jXIA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id A3900F40068;
	Tue, 10 Mar 2026 03:42:47 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 10 Mar 2026 03:42:47 -0400
X-ME-Sender: <xms:d8uvaThDVLHHu-DYOhdaCEdc-zMRm45QA4b-okuDL_3c33ZhbKGejw>
    <xme:d8uvaa3Cc5iBzuSWZDWwphELLNNICyS-S5W0_iJ90RsMaAjm27rL2tVfrirxj3J67
    2pMDAviw5o11gGfuoVILYKNsTYfLL2vfVD95KD8SoMksFfdGMeekIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkedthedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeeiteehhedvheefieelleevtdeggeejhfdvtdefheefudekjedtieeg
    heevfeenucffohhmrghinhepghhithhhuhgsrdgtohhmpdhnihgtrdgtiienucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhguodhmvghsmhht
    phgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeelqdeffedvudeigeduhe
    dqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrhgurdgtohhmpdhnsggp
    rhgtphhtthhopeduhedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepuggrvhgvmh
    esuggrvhgvmhhlohhfthdrnhgvthdprhgtphhtthhopedtgiejfhegheegtgegieesghhm
    rghilhdrtghomhdprhgtphhtthhopehhvghrsggvrhhtsehgohhnughorhdrrghprghnrg
    drohhrghdrrghupdhrtghpthhtohepvgguuhhmrgiivghtsehgohhoghhlvgdrtghomhdp
    rhgtphhtthhopehkuhhnihihuhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepnhgtrg
    hrugifvghllhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepughsrghhvghrnheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvggsihhgghgvrhhssehkvghrnhgvlhdrohhrgh
    dprhgtphhtthhopehhohhrmhhssehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:d8uvaRmSDr288HDI_tO-u4NcyIj7vMczOTndnBDfV9JbsPqHXTO6Jw>
    <xmx:d8uvaSYKNqcmPJ-lOAA2OYILY9da340-FD9W0X_2tRPTW_i85EJu1A>
    <xmx:d8uvaRP-eSJgs7-9fvZKMmMYD57c6QpTc7CN4tc_IR4CkFwkYBLYfw>
    <xmx:d8uvaSd-QNs_s1toOVe3BG9VvkBU47IsD13-_TjEVIML5eduq5TlrQ>
    <xmx:d8uvaXHcvN_2hujG1JhQYp5RPSPHoCaAf6bsrUSG4v5Pdg4xPkyZZlts>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 785B5700065; Tue, 10 Mar 2026 03:42:47 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AnuwgGJK4Cyg
Date: Tue, 10 Mar 2026 08:42:19 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>,
 "Dmitry Safonov" <0x7f454c46@gmail.com>
Cc: netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Eric Dumazet" <edumazet@google.com>,
 "Neal Cardwell" <ncardwell@google.com>,
 "Kuniyuki Iwashima" <kuniyu@google.com>,
 "David S . Miller" <davem@davemloft.net>, "David Ahern" <dsahern@kernel.org>,
 "Jakub Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>,
 "Simon Horman" <horms@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>
Message-Id: <581a4e71-3978-4305-a5e5-6c46d8e58693@app.fastmail.com>
In-Reply-To: <20260309233007.GA270909@google.com>
References: <20260307224341.5644-1-ebiggers@kernel.org>
 <CAJwJo6YhhK63tMQnMoN=9gsYcO4UCXovhK9S4GOdo8bw9B-49w@mail.gmail.com>
 <20260309233007.GA270909@google.com>
Subject: Re: [RFC PATCH 0/8] Reimplement TCP-AO using crypto library
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Tue, 10 Mar 2026, at 00:30, Eric Biggers wrote:
> On Mon, Mar 09, 2026 at 10:33:32PM +0000, Dmitry Safonov wrote:
>> I like the numbers that you achieved here and tcp_sigpool riddance.
>> If you want to measure the throughput difference, there are iperf
>> hacks I made at the time of upstreaming TCP-AO:
>> https://github.com/0x7f454c46/iperf/tree/tcp-md5-ao
>> 
>> We certainly have to support AES-128-CMAC, HMAC-SHA1 and HMAC-SHA2.
>> For the last one, we specifically had an RFE from a customer.
>> 
>> It's a little pity to go from ">> Additional algorithms, beyond those
>> mandated for TCP-AO, MAY be supported." back to "The
>> mandatory-to-implement MAC algorithms for use with TCP-AO are
>> described in a separate RFC [RFC5926]." as I've always enjoyed Linux
>> (and opensource in general) that provides more flexibility than just
>> strict mandatory required options
>> 
>> I.e.:
>> "Of course, TCP-AO key contains a shared secret key. It is specified
>> by the option secret as a text string or as a sequence of hexadecimal
>> digit pairs (bytestring).
>> Used cryptographic algorithm can be specified for each key with the
>> option algorithm. Possible values are: hmac md5, hmac sha1, hmac
>> sha224, hmac sha256, hmac sha384, hmac sha512, and cmac aes128.
>> Default value is hmac sha1." [1][2]
>> 
>> I guess that may cause a regression for an existing config.
>> So, I don't know, could we get your big speedup and yet let the user
>> choose what algorithm they want to use? Basically, making
>> tcp_ao_hash_skb() a callback with optional algorithms implementation
>> and a faster mandatory algorithms that will use
>> hmac_sha1_init_usingrawkey(), hmac_sha256_init_usingrawkey(),
>> aes_cmac_preparekey()?
>> 
>> [1] https://bird.nic.cz/doc/bird-3.2.0.html
>> [2] https://github.com/CZ-NIC/bird/blob/0ee9f93bd076c5cc425ceaec9acedbbb7c9021ec/sysdep/linux/sysio.h#L246
>
> This series already preserves the nonstandard but reasonable HMAC-SHA256
> support as a Linux extension.  And users retain a choice of algorithms.
> Maybe think of it as helping them make that choice by dropping things
> that we know (but the user may not know) should not be chosen.
>
> I mean, even CRC-32 was an option for the MAC.  Really?  That's
> something that should be a CVE, not a "feature that demonstrates the
> flexibility of open source software".
>
> Offering all four variants of HMAC-SHA2 is also almost entirely
> pointless here, given that TCP-AO MACs are limited to 20 bytes by the
> TCP options space anyway.
>
> If there are specific additional algorithm(s) that are actually needed
> for backwards compatibility, then we can add them to the list of
> algorithms that the new implementation supports.  However, do you
> actually know of any user using anything other than HMAC-SHA1,
> HMAC-SHA256, or AES-128-CMAC?  If so, what is their use case?
>
> But let's not keep the crypto_ahash based implementation of TCP-AO
> around as well, as there's a massive amount of complexity and
> inefficiency in it.  I think this series makes that very clear.
>

Agree that supporting arbitrary algorithms is a bug, not a feature, and if anyone does notice that a combination that actually makes /some/ sense no longer works, we can always add it back in library form (even though generating a 64-byte SHA-512 digest and truncating it to 20 bytes seems kind of pointless). But supporting CRC-32 or HMAC-MD5 is just ridiculous so let's not go there.

