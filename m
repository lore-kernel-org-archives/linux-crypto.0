Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102EC43C7D7;
	Tue,  7 Jul 2026 18:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783448452; cv=none; b=LGWrlP7iyFuovUpVf3XyZBaV/YulWAgqvr9QeWs/jn31y8bxXvqzAYA6KflvIL6gQcRvpRsCgAFtacv4eRvXClW6LerteAwBVaPChSlSVFAuQqhpTcEX5/WCYpT3Kq7eY7GxSbQngPa6E2N1PUg4jsr3AxMPRwTc53xlkfddt4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783448452; c=relaxed/simple;
	bh=gWJXzXKLcHf7IY4tioEeG/0G639EsPVpFeWxLm131p4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AFAED7ishq/pDEy37uEtMg9g+XcIGmXuI6ST0NLjSmcpr48Q9dmb5y572one+Ne4VA7vaV9CSBzti7V0BbmQwd5QKQf4eRdqRXAz+HECAOxW98zh0tfsFroR0o0emimDQXm9Y529mZ+NLXlAE6Tww7f28fssBZ2TOfnsR4GOkak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oYFhFMQn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oYFhFMQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9241F1F00A3F;
	Tue,  7 Jul 2026 18:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783448450;
	bh=94UIFt9BrCvE/AeWosK/Oo9cTU69O83dA6SIDgSMCOU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oYFhFMQn+ajASSJARChnjTumyDPbaL9G5uW91kyc+Eq/htMWUd5b/aaI671sAsrvC
	 D1Xp+rZqwCX2jA3qqKmEBip1rhguVR++v70i43xqqvvPEdhsRxZaBMX8rA19XPwEfd
	 MFud26ly9IzHJNVkb0/kHMXza11w/O5a+V8V/pJrTapeecueZ2iqJC/oxdkVWttrZq
	 AHHEiP2Iz15IAYAzI59jVPCMoa30fcKijHRbJNYgb1uN8JQjNnhtcBhaAkIiuRbFdv
	 QPECb9ux7JOrT0vTXx91C7clu62Gk3U1r0WPCsUYffROgLS+9MrMdZ865qXESNsisP
	 JEcQTDcNJoBDA==
Date: Tue, 7 Jul 2026 11:20:49 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH 29/33] bpf: crypto: Use AES-CBC and AES-ECB libraries
Message-ID: <20260707182049.GA2238@quark>
References: <20260707053503.209874-1-ebiggers@kernel.org>
 <20260707053503.209874-30-ebiggers@kernel.org>
 <10eafa42-1142-4ed2-a485-f46c496bddfb@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10eafa42-1142-4ed2-a485-f46c496bddfb@linux.dev>

On Tue, Jul 07, 2026 at 04:01:13PM +0100, Vadim Fedorenko wrote:
> cc +bpf
> 
> On 07/07/2026 06:34, Eric Biggers wrote:
> > BPF crypto was implemented using the lskcipher API, which doesn't seem
> > to be going anywhere.  It supports only "arc4", "cbc(aes)", "ecb(aes)",
> > and only with unoptimized implementations.
> > 
> > Library APIs also have been found to be a much better approach, for a
> > variety of reasons, including reduced overhead, greater flexibility, and
> > having to be explicit about the crypto algorithms that are supported.
> > 
> > We can safely ignore the theoretical "arc4" support in BPF crypto as
> > unused, which leaves "cbc(aes)" and "ecb(aes)".  Why these algorithms
> > were chosen, it's unclear.  Regardless, I'll assume that "cbc(aes)" and
> > "ecb(aes)" need to continue to be supported for backwards compatibility.
> 
> That was done for single use case of decrypting small blocks in TC
> layer with "cbc(aes)", with assumption of extending it later.

What protocol is using AES-CBC?  And is the kernel encrypting or
decrypting the data elsewhere, or it is just routing an encrypted packet
and only the BPF program decrypts it?

Does this mean the AES-ECB support is unnecessary and can be dropped?

> This change looks great, but it would be great to CC bpf folks just to
> be aware of the refactoring.

Sure.  I'm only looking to apply patches 1-13 for now; the rest (bpf,
fscrypt, keyrings, libceph, mac80211, macsec, mac802154, smb, ksmbd,
tipc) are proof of concept, showing how the library APIs can be used in
a wide range of kernel subsystems.  I didn't want to spam the entire
series to 20 mailing lists.  I'll resend them individually later.

Thanks!

- Eric
