Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794562267;
	b=1mfX02X0ep5LMu6kmhb3ljXXb0guZhdV4b2YGbPq7+o7dMG9d94En9ekPKpvtpxtspRd
	 XYF+kWqvdRIucr6qphigTBw6Z0D04tziIjX/X8/lQ/HQzCVX+rGoVuaWIO6PpOAiBxtnL
	 VdZqwJ8biGAbLCgFjxSvWjNzv5g0hPVkrqZg88HDYemWvkD10Z73c2+WBwabNWdPYqRNP
	 79RQKpOb2Gt384K89r6POh3kpQgSBAXfJPEIJ5TI6HsPyqZdnwAaCVf2KXtu/ErmqoKmN
	 jdOFeIgnfauGI6BcpTfkSgH5HvWzpeEC1y7zttkksWvm6mCTr7G1AtLjqySrCnnOD9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794562267;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=UNn6vOjsYFPYZjGTR74zpoRm/qknf4uPRejPZHJGTpo=;
	b=J0X7hF25HlyYJFlDrmdIlmO0AxEdWK5ycUbiTS86UpL3Dtz54Kld/GbiZYrThvhFqVXo
	 oKlXc24V+tJ1B9iXMAFI1kccQeaRc7pgyqr41bz2sVd7Fpl3/7UvfbgWCI0gt7EGD2BXH
	 7/7V36QlgpSZV2aD3gtlZzPy7aK1nsDgPWfmmOppiolq/pCQQvojk//8l5mLddQ4QK53S
	 tb6DWM0kZl99sTJT6KXC8U2r+sfPVFgkM8DAzk5aKGyc/yF6/ZNc0n/PLk00Z+1RrTdKz
	 oxtMyXqLDMGrPuSLyaGxRFCSRRnKB1nfXeQFzqaIYzU6z23zl+FCF14yAl5UDXktwKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=q5hwdcJF;
	arc=none smtp.remote-ip=195.10.208.47
Received: from mout-b-107.mailbox.org (mout-b-107.mailbox.org [195.10.208.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03AE606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 09:31:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F03AE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=q5hwdcJF
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-107.mailbox.org (Postfix) with ESMTPS id 4jQsSV4JDDz404p;
	Fri, 13 Nov 2026 10:30:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1794562250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UNn6vOjsYFPYZjGTR74zpoRm/qknf4uPRejPZHJGTpo=;
	b=q5hwdcJF6ltgy5qQXoiI8D/AmHhEHZqDh8LGo3FBkwrKQVLhKxn57KerV13bkIFitirEkw
	EQgGsmviHaffkQXZR22FHZIk+6DZ/EIdACKk7x8ICcH8fjVgRWYJgKM8uWu6R41qKSWAxW
	quP8tPZbqgtG8tiq5vbm6sZr5l5+gvMByk5gvcP27wKjTSRlHmdTXDN/EAD0UIqUdoISyi
	OCUJZVhxiaB+3bT1KXt+SyAOulRPUoubqmv46P4XLnL2ESSkXSQ6ql8pdSob5lnnug8qS7
	k1+3Ycb2Htuus+q0JZxYp7vWBfqn9rNQVmPNiKN4Svk2jZHpIM6H11sK+/uyzA==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::1 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
Message-ID: <5c2cc660-645e-4c8c-8380-fec0f3939f99@mandelbit.com>
Date: Fri, 13 Nov 2026 10:30:48 +0100
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
Subject: Re: [PATCH v2] lib/crypto: x86/chacha: Fix mistakes and
 inconsistencies in comments
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld"
 <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Martin Willi <martin@strongswan.org>
References: <20261113031340.63688-1-ebiggers@kernel.org>
Content-Language: en-US
From: Antonio Quartulli <antonio@mandelbit.com>
Organization: Mandelbit SRL
In-Reply-To: <20261113031340.63688-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4jQsSV4JDDz404p

Hi,

On 13/11/2026 04:13, Eric Biggers wrote:
> Fix various mistakes in comments, many probably originating from
> copy+pasting: incorrect block ranges, duplicate words, and stray text.
> 
> Also make chacha_1to4blocks_ssse3() refer to the state matrix using flat
> indexing, like the equivalent AVX2 and AVX512 functions.  It was the
> only place using 2D row-column indexing of the state matrix.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Reviewed-by: Antonio Quartulli <antonio@mandelbit.com>


-- 
Antonio Quartulli

CEO and Co-Founder
Mandelbit Srl
https://www.mandelbit.com

