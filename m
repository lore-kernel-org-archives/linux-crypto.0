Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794306112;
	b=Stpgwmcw6jjk/mu5WLwKnQOI+imyURAGKZInuUbzuSo8+lJg+KyHmx/3ine4S8z8o3uU
	 ZTRu4v0LM81iiNkkXGpLDOSuPsahkBREIzQi9Z6jVgUPTUVkcW01xPmYxnJ9Y+IUPRyrW
	 uDAVHGqgdnd5oWdtTlTnXTbTmwPsoFrnhC+XAHlPuZeEvb3QQq/hWa3rqhX8H4PGrJ8+N
	 HaXsZBN4wLPByzyytcVgSi0Tq9KAUmliMuxRuYOXkhdSL3OJjOsXZx1ar0+p9FlDRojB7
	 FTKLNVZnuQUQFaIcjpY18Gdg51Bpu0bdwvX03uaiL7sbix0+EizwDag+ZkpVQ7+Zr/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794306112;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=WbsybnRFOJhpqorwJhJNzIdD9PqCdKTdJc2eEHj7W0M=;
	b=jtGaAeuk0IoclyhSGWmLNkGAn9sm5TNBcY2NzvvmtzK30cpEGOAghGt+DjW3CqyMTGet
	 rLIpT8RTNSllWRd3FwP86fYcRVyR36yh5GlVBkaTxApVWMkhKtW3gU+BQe5CsORyvUPKZ
	 r+beEuPUwK5WUBgqgko2W8KkbityI/6kOtd1AWjNu1JC9JYBb0F5qRSbfk/VFmroY44s+
	 sm30/VoHAeV+z+Heey1Ij12GkOaa6glnvPwvfh3zHPUDDotzSy2wNBRmRQwpl/lAaYxKg
	 ADT2PKmLk33BW94YHzp0eRFWqRB0EyFW6ilINxBFWn6HQzONNIih0r1NebuaC+sfE9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	arc=none smtp.remote-ip=195.10.208.42
Received: from mout-b-112.mailbox.org (mout-b-112.mailbox.org [195.10.208.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C02606CD44
	for <linux-crypto@vger.kernel.org>; Tue, 10 Nov 2026 10:21:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1C02606CD44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-112.mailbox.org (Postfix) with ESMTPS id 4jP2kQ4zfJz5x2S;
	Tue, 10 Nov 2026 11:21:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1794306094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WbsybnRFOJhpqorwJhJNzIdD9PqCdKTdJc2eEHj7W0M=;
	b=jpHUu0Wf46ZHmThaRgd6OfjczjUYBxs3SC0ZoovDYn9rMcZoiPeWXH+ERIWwzBM6IhrF8H
	vwLL1bWuqNP6E2ispAD0ylL5C4bAWyju87F3YZgBV7m7LfRNGWY2aGBoQaT//MxLyZkuF6
	fT0W76Q6j6LM/t8Gkym89aOy5vY+8UtwmEEPHyuTPr9l0RuFQ4/FdYU/QtmPgt/6Jpxhin
	skXEE2v2ef437kjp54fH9vY48nAYhknaWllbRkCIm5LlzTh+OY3yde5sRvWIzMmO8vjIpw
	AwAJ4MQspBPIs9dYEGrsVC+qeuXyFO89s5RZjchxQWzRGum6fM7rJwCkHv/ryg==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::102 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
Message-ID: <843f872b-5afb-49f3-bfa3-1930921fd06c@mandelbit.com>
Date: Tue, 10 Nov 2026 11:21:30 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: lib/crypto: AES-GCM x86 arch hooks: any plan?
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <6ce2344c-f6b5-4051-87b0-88a1c258a6d3@mandelbit.com>
 <20261109192053.GA57100@google.com>
Content-Language: en-US
From: Antonio Quartulli <antonio@mandelbit.com>
Organization: Mandelbit SRL
In-Reply-To: <20261109192053.GA57100@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4jP2kQ4zfJz5x2S

Hi Eric,

On 09/11/2026 20:20, Eric Biggers wrote:
> I'm planning it.  I've just been trying to get other things out of the
> way first.  If you're interested you can try to do it; just keep in mind
> it will be quite a bit of work to do properly.
> 

Thanks! Then I'll leave it to you, and I'm happy to test the series on
Zen 5 with ovpn when it's ready.

[...]

> That by itself may result in performance regressions on short messages,
> though, as each AES-GCM operation would be broken up into multiple calls
> to the arch code.  There likely will also need to be new hooks for
> one-shot AES-GCM operations to handle them efficiently.

One data point I wanted to share on this part from the ovpn prototype.

I did split its single FPU section into three (AAD update, en/decrypt
update and final, each in its own kernel_fpu_begin()/kernel_fpu_end(),
same asm otherwise) and measured the receiver, which is the bottleneck
(Ryzen 9 9950X, 100G, 1 stream):

                  one section   split      receiver cycles/record
   920 B records    34.22       33.86      1120 -> 1131 (+11)
   1420 B           45.59       44.95      1306 -> 1317 (+10)
   2420 B           55.43       54.79      1836 -> 1850 (+14)
                   (Gbit/s)

So the split costs at most ~10-14 cycles per record.
The sender showed no difference.
The receiver mostly runs in ksoftirqd, so there is no user FPU state to
save in kernel_fpu_begin().

Therefore I think most of the ~120 cycles per record the direct path
saves come from avoiding the crypto_aead request, scatterlist and walk,
not from the single FPU section: for ovpn, update-level hooks would
already get nearly all of it, as long as the C code between the calls
stays light (that part I couldn't measure).

All in all, a one-shot hook would still be welcome (although it doesn't
look super critical here).

Thanks a lot!

-- 
Antonio Quartulli

CEO and Co-Founder
Mandelbit Srl
https://www.mandelbit.com

