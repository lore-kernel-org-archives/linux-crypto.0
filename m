Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C9030F53E;
	Mon,  8 Sep 2025 16:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757350104; cv=none; b=Mpu8i6Qx6eJaY6ZDwgjUvWD8xP23EMFNpsSsfYcfaclLkDO1CrQOUJp3BlRA02x3fPYKGMo6quWE+ky5ywynxZhNSGqURlI5p6EcGVPosHnQfQ8MjwynbBfReunA8VqI9SnPT8C2KtEt225nzirPX2qwjFgTaFSIbmj/qV3ywJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757350104; c=relaxed/simple;
	bh=s02kopzJSlYiqLDMIOwawddi1A/EA0OWXDvYYK5KGXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ELwXoxZPJB+3WwfiySLdSbQ2aatj24Z50PLEzHWCMb58uXLv2yygmB1ZDoyu8wo2BBtt+dU/0JvWc+B5kV9epMcrgetAhnf8hIdsVdltpnM3TDcKO3RRUi4RtQzuvuGx1UO6Pex2mMdk2F14aDRJqg4mb64rutA37e6xnqbEBP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OvVeuPPl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OvVeuPPl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E08FC4CEF5;
	Mon,  8 Sep 2025 16:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757350103;
	bh=s02kopzJSlYiqLDMIOwawddi1A/EA0OWXDvYYK5KGXo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OvVeuPPlqrgkwm4Pwfx2gBHC5PxzGc63nQRmK+0toXwiytOzIAQ4MkK7bBNEulbzg
	 rLqfUwrk0xPM7YLnH+wBIxkurrkEZ4StvdPFDqeq1QNfzBHusy1WuUoZTo6II6CF4W
	 J8gDrH5Bildq1JqbhzEXWsFG7q17Mw/EFt1OeF/GGDRMGX62WH2k+eIGhn8uJ4ZLvd
	 bHlQByov+zZ5mLeHJqNB1EPHKspjAGQoHkzuI75fDGydkYku3i2Brjccrn32M+H4fx
	 QD6C6N+YzGYrlZqVMOpZxhPdT/uBjp7zcvQxMY89q3ADIUfUjO2Qj5MLSCyj2QQJ5e
	 K+99E/YRZhmAA==
Date: Mon, 8 Sep 2025 09:47:06 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Zhiqi Song <songzhiqi1@huawei.com>,
	Longfang Liu <liulongfang@huawei.com>, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 12/12] wireguard: kconfig: Simplify crypto kconfig
 selections
Message-ID: <20250908164706.GA1331@sol>
References: <20250906213523.84915-1-ebiggers@kernel.org>
 <20250906213523.84915-13-ebiggers@kernel.org>
 <CAHmME9qyfbn539Um9xoFJu2Mm9mM0zuOxyLgeOjF-R5nktbz4w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9qyfbn539Um9xoFJu2Mm9mM0zuOxyLgeOjF-R5nktbz4w@mail.gmail.com>

On Mon, Sep 08, 2025 at 06:35:04PM +0200, Jason A. Donenfeld wrote:
> Hi Eric,
> 
> Just a small nit -- would you commit this with the subject line all
> lower case, like the other wireguard commits?

Done.

> By the way, I have been reading every single one of your patches. It
> didn't seem like it'd be useful for me to respond endlessly with
> Acked-by/Reviewed-by, so I haven't. But I have quite actively been
> looking through these series. Thanks for doing these cleanups and
> reorganizations. This patch here especially is quite the relief...

Thanks!  I think Acks/Reviews would still be helpful, as it shows that
someone else really read the patches.  Maybe you'd at least like to send
those for the cleanups for the algorithms used by WireGuard?

- Eric
