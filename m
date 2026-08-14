Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F348747606E;
	Fri, 14 Aug 2026 15:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786721132; cv=none; b=VKXO/cAj9mLhnY2FWX+g4lwhJS5jeWIZj59IKTYQjdYaD5LAwyFdQ4Xe/mcG0f2A4y3GG3je84uOQa5Mvun8WxnUxCE+4cPf+2hQJHDasUsmGz10LvxqRwOsd5FCb3FQfoXiRfXbQb+XcwkyNwBqV1fREDeWWuOfWWb1y9h5Drg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786721132; c=relaxed/simple;
	bh=838AlsARiLXp1gp2xc6UY1z6hk0yHVkAlY7Zzxfzh9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lpzVXzSiER5kkGl0321wfumt5Ad86rp3j9Z733sNopzrJLKfI2Mi4fOVd7AkhJxpEPy2eNGcWJUOSkMolAL2HeSyTiZiWM7S9DncFBrWrWOVhI7M/kYn4+sMtnaZBpLh/fU9/uS/SqgTfl+Ga1vEEMFNm7as70B8tAIVheABl0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=UGQ17PKB; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="UGQ17PKB"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C768740E02DE;
	Fri, 14 Aug 2026 15:25:24 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id r1lL61FWpTxp; Fri, 14 Aug 2026 15:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1786721114; bh=thiV6sf7u0CczMNVHmn8LMQQWE/Mbh3T3SkLGrfkGTo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UGQ17PKBMJmzTxIcJqdQRmxv5MFWpi1g5DNSBm/DfX4sckjX/EBefFgultvfyf3H/
	 5DTPRFXZqKTDf8zPcWKms4otw4QwyKRBIe7AoQxFGHDjwBMiTNAZ6Tnp9gLTj18OLC
	 xaEKzwIhqbNIajRk//aNiwtpqMPDniW/zItKfKz6bY/r9kSPszI3tgHOLfggdEUOxZ
	 tL0LWowu5k85dSfEcHwNxQRIh2/8OcSMxYR4WxMj2tagbRkw2X08NNWQuZyAHywXBF
	 0T7H8Rmj0mz10hVLYpkJv1hmUYTxHh0JdtV2fKk2IsgtghhctEO9/jzc6W4Mo/bJ0v
	 ojiYz7EVCuY6bZjZ3WdOoLbolqOwBmITsA1hOw2sXLLawh0BEi3jIEzExpWF91WRW3
	 Q924KeK9LwO9jRv7iScRhA+yZWh0VpeM5MR+sCnnxBejHaPRvWvClUgSII6h0BOFJ+
	 L/l6QRKKVtRjH71UI747cSMAoFSDwVmwOa3SRsAXXWPpS6dhqc503y/Y5OHWXy/x7G
	 I5rk7N9xd28gHLoqToG8bqolyWIOgI9M13AOIeWPjJtC4Z96NK2dgM6CytVwD1BMRq
	 OlQc7YOcb7L/VbUEkNo50eb+Lkzf9lgcY4f1/DlDiGNspDers3uUcFsZ3RzvtvU3m8
	 S3zajPeZW8x0KDs470qUY4QA=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 185E840E014A;
	Fri, 14 Aug 2026 15:25:00 +0000 (UTC)
Date: Fri, 14 Aug 2026 08:24:57 -0700
From: Borislav Petkov <bp@alien8.de>
To: Thomas Huth <thuth@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 10/11] x86/purgatory: Compile purgatory.c with
 -D__NO_FORTIFY
Message-ID: <20260814152457.GBan8zSeYlWd_1oWkz@fat_crate.local>
References: <20260813134953.979481-1-thuth@redhat.com>
 <20260813134953.979481-11-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260813134953.979481-11-thuth@redhat.com>

On Thu, Aug 13, 2026 at 03:49:48PM +0200, Thomas Huth wrote:
> From: Thomas Huth <thuth@redhat.com>
> 
> purgatory.c includes both, the <crypto/sha2.h> header and the
> arch/x86/boot/string.h header. The latter provides its own prototypes
> for a lot of string functions which clash with the fortified macros
> from <linux/string.h>.
> The next patch will add #include <linux/string.h> to sha2.h to be able

This is exactly the problem - people are adding main include namespace headers
from linux/ to arch/x86/boot, or, as you do, to purgatory, which are special
- and then they have to do all kinds of hacks so that it builds.

(btw, there's no "next patch" in git history).

> to use memzero_explicit() there, so we have to compile the code in
> purgatory.c with -D__NO_FORTIFY to avoid compilation problems in this
> file.

How about you extract memzero_explicit() to a separate header in
include/asm-generic/ or simply put it in include/asm-generic/string.h and then
use that header instead?

Then you shouldn't have prototype clashes...

It does sound cleaner to me but you'd have to try it to see whether it
actually works.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
