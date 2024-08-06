Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE9F1BDA84
	for <linux-crypto@vger.kernel.org>; Tue,  6 Aug 2024 09:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722938287; cv=none; b=eX9lM93u6jkKuNE/7dSaL/J71OOMrhtlY+cd8PeM/2l6npPA0J1HWAYv4w638TL/+WPVZZg/v2Yk9ndfZBYXj+kqDQvHaV66IrWyfIoLQ3ULAisBus6P84Piwn164TplZXdQdKd6EaunI/aZGMDwVFM7zjh0EgahrGUGy3CWzEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722938287; c=relaxed/simple;
	bh=2HUJZpCAfyNRH8E5Z4HOcNnclfEAlaaKGbM4A2IlwrA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=psuaqLXN+tUBFZHpQnBqzzsaq4ZbzsincTwcUJUS6zw5P6hpKhIohmV1x1nJ5Hi4YJ9jARyk5SyG8EG9TTmkFE+Z3hAz7uvVId86Xq1mxMbt9kwXgo+o5HI/lbjs+P0oVlw0NbhFl9YTP9b0qOauN9hn4DBuAyawUwdHpNGgdMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=0rN046l3; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=J2cTOtxe; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="0rN046l3";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="J2cTOtxe"
Date: Tue, 6 Aug 2024 11:57:56 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1722938277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s4d/A+2BKO2+LeDBYII8yJrMay3NludajAQqBaYb+DA=;
	b=0rN046l3Gjk1M1qAL9quNEke79rSgIsjCzjwOWv1uMbr+h9cMwaubA0luoTI2J3LF58+bC
	7rvO51Gazfe9JCoYANUpq9Mmp9VnGVP11PUlWPZOgfTpdKReFXa6RRUpqbMrfJDHTq8GqM
	2yyYvW88Wx/SpY7loq+/PNN8UezE3ccqlVvjqqZHVmIzgl0LVm6w4Ga527N3iS3W2YsDAC
	Pvo89HHEp3ncKV/336IkJTIWpSy2B4IOm7W1ABzPukU+Fw+qL5vXDfZkg/fFKDsoB/Qyc0
	BhPMtf9+4ir9sN7e7Uy5Jt4P2/BCbdTtIhFWLDFD7XFXOO7bV38C+x9SOFZj+g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1722938277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s4d/A+2BKO2+LeDBYII8yJrMay3NludajAQqBaYb+DA=;
	b=J2cTOtxeljWFMaYrtif71uHjXjFExeIwz8UTSBcQo7XJM7Up1jLNpYyqTQ1s+vcsn75dei
	6r1SjD8bvNO859AA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] crypto: x86/aes-gcm - fix PREEMPT_RT issue in gcm_crypt()
Message-ID: <20240806095756.uLukAZs_@linutronix.de>
References: <20240805182713.161198-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240805182713.161198-1-ebiggers@kernel.org>

On 2024-08-05 11:27:13 [-0700], Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> On PREEMPT_RT, kfree() takes sleeping locks and must not be called with
> preemption disabled.  Therefore, on PREEMPT_RT skcipher_walk_done() must
> not be called from within a kernel_fpu_{begin,end}() pair, even when
> it's the last call which is guaranteed to not allocate memory.
> 
> Therefore, move the last skcipher_walk_done() in gcm_crypt() to the end
> of the function so that it goes after the kernel_fpu_end().  To make
> this work cleanly, rework the data processing loop to handle only
> non-last data segments.
> 
> Fixes: b06affb1cb58 ("crypto: x86/aes-gcm - add VAES and AVX512 / AVX10 optimized AES-GCM")
> Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Closes: https://lore.kernel.org/linux-crypto/20240802102333.itejxOsJ@linutronix.de
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Thank you Eric.

Sebastian
