Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795090199;
	b=46uq+7V/YOxdqTCOhteaAnMXzpD57tEBBttjksq3WvlZ+wb7yptRh7KLGIdjbQAoOFda
	 wUEWeUDUSDIfJE+snhPYiye7gYC03UHLEHABMVCKB7oAlrCjBeapVcddu0KvbbjDME+JA
	 iHxULalFI4UWDZHZeu8n1VCLaTbQzzyhP3p526Ixzkxi0+ytSH/u5ZTuzi7wWCNRcvu5C
	 rbFUcCdxf5yw6rsfEqGCgy58iS034HVvOmkBDOXN3p6Hpnb7hFjCj57tM3ez1L/jgg9DI
	 l5h2We41Qoi3d3R9i76xQ0Tv50NcBpzokegqRNGvufNQgY8cvJz4uJs280o4cWuEx7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795090199;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=6LJFWn3naggMAxxma3yUUM8v/APlUEqWWVGbEV4Kg+A=;
	b=Kb+hrU9Y5P+KFtvsqwEcxmRwEhqpxV/xpqxmspF71z5cqFxYza0yjkG/pFC71aBH92f3
	 6caRfCrKsT3o0yZgpvWmPQfMhKnNLL5sg1G2/MFKcL9JMg4HYg/XcB9roP61bCGEJyDRD
	 +7lLJuYXx8S4dIBNqRpdJ7fJR8imCClF9z7qzIsUhXkEjfIJNbmuCBn26EaV8EmQn7/Iy
	 8Pp4wdUQwkby5KLzyRgnsS1RhUqQiQGbvNBHeux3sxPKn9ViIja6WizmgFv7LvyPClzsq
	 WYcifBSSzQIhZw9lLNm1Tm7+9Y1hJirLk5LCpphCd+FpbFHGdOctcadvXPWJvzGmBHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fcgORxgO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF98606A320;
	Thu, 19 Nov 2026 12:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fcgORxgO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F6D1F000C4;
	Thu, 19 Nov 2026 12:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795090198;
	bh=6LJFWn3naggMAxxma3yUUM8v/APlUEqWWVGbEV4Kg+A=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=fcgORxgOTFTuJZyidlrsUUseH2vw9WpMTkfQDAVvYR7921OVWKMjmyj+rjjwgL7+c
	 0/CvXMswfb2i5J8d/hLqnUJ+wKtgKFOk81307Ld5WyiquK4c1SMZGz6gg9m98GdzoN
	 ETMTWLG7N/AgkNdMlGDLPLZxLDjUuanuwyj4ryXhUEbHfi18qxAUvOARL0MKsCKgif
	 0WbxnyZUf2hazIUfKNn3ogbOudmEDAtlEDkgcbPBDAPLQYyq44pjvtrwbp0RqCpfVL
	 5iZVIMTNV7SrlQwLcMqv6ESOjilovK8P0MSoQrq0DxHqU4/MdAVWc2g2xSwJkEL/eY
	 ikdDBohcn9Meg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 94C71198003A;
	Thu, 19 Nov 2026 07:09:55 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 19 Nov 2026 07:09:55 -0500
X-ME-Sender: <xms:Eef-amJK9l_BCMUK2VhzFR1XdMSN7C1qlDVsDnpNTuHobvGOCG6cgw>
    <xme:Eef-ao-LmIxDK6wsJTjDNuHfenEWmvjjwYmcoGZpmf9qGvURuRavzzWfGWhiCX5Gq
    w4YSi1UWrsfRqGyJRHlZiXS0fDwgFBVe1-GvC0CpNSQnqemFjrqZT8N>
X-ME-Proxy-Cause: dmFkZTEPs+pTpqsSykY0cHn8c3BjhxpWToJiI2d/WvNYOSBG5WbHAr4gB9HwYeU1rI+Ukl
    5yA9K3fbxfsUtwDGWCHV/8dhNihfd2JY+HMqLzqWki8fEpEXvjhQOWxtLtconhoNRUF+4P
    eD09na/GCkvUysprk0D9XkfzhwFmtE2Kkiqv2603VnWx0+q8QXUm5JNtKXmdVb0tpNKpgn
    01xd3RAR8279rk2TxToCkXVkp+ha4x6iPaF2+bkfjAjevONpVhdjfsHjAqQVYHi5HRjeoQ
    b+bYC0axENB2f1bvWIioBLS5R/yyH4w+3tByB1jbP1Gulu4L+Ztpe3HdpnH6E7w64XijS3
    numlyc1/tAECXmBVFpzbNv7wB4n16Bk32112lre6VUG/ITFMtfVC8t9DAxiwxP8NOOqr4H
    CiYUufFqFGtnoP0LXSup9l3xDUnMoIxPgPRFbSaXSJvCG/F1VZuOV4S7pf7uswpQ9oBFau
    UXBVH7nD4K1Rz4u7ntrbjW5CScugEbf3h0kaq7GneH4Uf5lEMaTlXyY4glT/hMeFq0OVP9
    S16GHTD41LvnB2c2+TrcWtwFpS9gXdKwL3QHkPriI8IFEg2wEVzHV0qA+TLZCdEKfLWPt3
    pPlsEN+5HFtuIflxA4sXRy9QUfRbr/wmtCPrWJ3SkaZGmPK4aJo6GSterkxg
X-ME-Proxy: <xmx:E-f-anxm5dJqKIdkGVW5MtA2k-hz5LHbH7LFp1h9XPksXu0xkmqgug>
    <xmx:E-f-arF1QaWLcvdE_vhONoBCIf4oKqEa8r10vdEe6yfhkfDm8-IkXA>
    <xmx:E-f-astbGfJCr1wl-V_CzKxJox6W21sfE_cWclC2wBeepmQnc14n9g>
    <xmx:E-f-arC0Frlx7QZxhQjsm06xY-OzeyiZmcvnzdmtEE9A2GXEc-yEuA>
    <xmx:E-f-anCly603lB59av9yA27dK3qjpnFFYFAkrUFmL4CmjiJsFVPIwxIc>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 35476F80096; Thu, 19 Nov 2026 07:09:53 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Thu, 19 Nov 2026 13:08:51 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Catalin Marinas" <catalin.marinas@arm.com>, linux-kbuild@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 "Ard Biesheuvel" <ardb+git@google.com>
Cc: "Will Deacon" <will@kernel.org>, "Christoph Hellwig" <hch@lst.de>,
 "Eric Biggers" <ebiggers@kernel.org>,
 "Nathan Chancellor" <nathan@kernel.org>, "Song Liu" <song@kernel.org>,
 "Yu Kuai" <yukuai@fygo.io>
Message-Id: <81ddf2f1-faec-47ec-b3b1-7210b4e7712b@app.fastmail.com>
In-Reply-To: <179508547602.2557572.9682726373932810888.b4-ty@b4>
References: <20261029135020.272082-6-ardb+git@google.com>
 <179508547602.2557572.9682726373932810888.b4-ty@b4>
Subject: Re: (subset) [PATCH 0/4] Get rid of all NEON intrinsics stdint.h type hacks
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Thu, 19 Nov 2026, at 11:51, Catalin Marinas wrote:
> On Thu, 29 Oct 2026 14:50:20 +0100, Ard Biesheuvel wrote:
>> Recent Clang has become more finicky when it comes to overriding the
>> type macros that the freestanding stdint.h consumes when defining the
>> uintXX_t types, and so it is time to finally get rid of this entirely.
>> 
>> So instead of making stdint.h (which comes from the compiler when
>> -ffreestanding is set on the command line) agree with the kernel's
>> linux/types.h header, avoid the latter entirely in the compilation units
>> that actually use the NEON intrinsics (which are always leaf functions
>> that are not tightly coupled to kernel APIs).
>> 
>> [...]
>
> Applied the first three patches to arm64 (for-next/fixes), thanks! I
> also added a cc stable, though it won't be a straightforward
> cherry-pick.

Thanks!


> I left the last patch out, IIUC it's just clean-up rather
> than fixing a problem on arm32 and can go separately via Russell's tree
> during the next merge window (let me know if you think otherwise).
>

I'll let Nathan respond to that.


