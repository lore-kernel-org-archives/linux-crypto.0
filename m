Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C3546C85E
	for <linux-crypto@vger.kernel.org>; Tue,  4 Aug 2026 15:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785857966; cv=none; b=gp609s+WEOiBAjUlwEybvILbYkN/q5GgKf/F01igBCFTKIIEevNTXR/AxWuvxiS+lP4ghsb7r0rcSL2zEGICGTUvTEWYJSiTWaPW8STi8+AZtraY9d2t9AcrdYXK6OQfZ0PiiwhJHTjj3ZJmeJgPw3Gx6Bv/5Sq2yiv/EUMpXF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785857966; c=relaxed/simple;
	bh=sXiCqlNJXI3CJuO1zVLOIYVT9vhiv5LI4e+m0XwaOyI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=n1Pk7A/9/FQynmOCDzPAPWaReY3RhjM8RJ/hn1klDIwoFYz1nMGz2yrbAgsF79GPZBtgUpfCxmVtuwFdEuvh+2kl6ou/82QC/n4TyUVvPqmcm3wo9Sf+pH9PzmgM+U/PJu99Kj9NE3Yoqxrtnb5/Q7ImTgYU7qYgUGvYtIuUAaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MGgNluVg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MGgNluVg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4FC1F000E9;
	Tue,  4 Aug 2026 15:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785857955;
	bh=oc0oP1Ct2BQKN7wFd+idUzNhRk49DlIKA26EtbXw8IY=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=MGgNluVgu8M+0jZs8M+bajpVt5Hpw3HafMZYuZ66jiJSzNpQgDPm2ULWGqlJe1eTX
	 /QMIhVkA0uiW4SSYab6CQ/c5m6/n2DWVi976QWh8VxWdI3WTtAdWxi/FyeZZ29AxxR
	 wOXH5OHuP5/y4Smi0ylaUHOLv5PCBiyvzHCgzVl3U3KURU4tWttUtHEi96nlUtLCga
	 XTPBs5DVCMHE+EN6Xc5wl/1H0ItmearqkvPUQ1U+lPHzUiiRBbk4p/qjUKQFcFy5gm
	 8h58s+WoYqX7VJZ9gxDaBItnW/TOfX6njDjtovZnxG0FikKbxppqi+UxOgwXzW5ymE
	 MRn7YaxmC7YAw==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id A2968198004A;
	Tue,  4 Aug 2026 11:39:13 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Tue, 04 Aug 2026 11:39:13 -0400
X-ME-Sender: <xms:nwdyaukYxLQOIPL2N1GJpTYLXzLaAaTKIADQc0rIXVZrIC7C43AfOg>
    <xme:nwdyagrFOgaGDbsCIJ8oJw0AaybUkAvLKB-ZmAy7ARLQ_OegDE-qKQpdE7uu37Bft
    ZR5-rDmGYm54EXbFMqlf_5JrTiG1lWoFERjvWTj180RKxgoVef44A>
X-ME-Proxy-Cause: dmFkZTGOumS+svVsEIiYmK5xWEOOcHtq9yofYVBRVCUPcf/QqIv3WSuKq1wQ17wiMoJdOl
    etg6njQIU5UQFBhkamlO1vNYYcLf0v2Zynv4KQeUT6qUaJmXX7uFZi4jnrfQ24MzoOfF1I
    Pw/lyC59zBmqanPnLyMB9eiIAayK4DZ+11SPaYjoSMNAsxm96jfdRH6d18V1akGKplb/rp
    7x9xuZMJ8OKUPr6YmoIdt3BTJ+OPoEFKUosAeVz73rRQ8n49DvgSrCRxEgTslWF5wzHPx8
    3wWWFynPOrE1Ix4ktZWPJnaJpnVL3UiVmHhEffxRrwTpeEVOIsQm+lZ5NHWXgxi6+mH7ET
    QS3w2KWQjCoaA62tyR96+u684ynGvmcsKM/BAEt3PFYKG1CTt/lS1E/QZCxm8/tUTc5AcE
    rik4y1adyIGc+arHROhf5EpDddA5cLOndg8PddJbPl/oigE/w5LKXvfV45soh0o1Ms8gFR
    Ivny27U+gMIvjsIZrfU9uPKqJuJ3esT92vXJ/0KTg9WGlPXLGLJpkH/DEmiQh2qH/xifs1
    31aTYA9s2AEp0bcBoyFmJvchTBqldTiRiR3dW8iNR/v1hbEiO4L4Xre94cZToiyyfog4CE
    FFkGUHCfe/rgYC0xLBLnxzw/amrtJ87V36fQfWVamdnqASeX+U/D25/hI32w
X-ME-Proxy: <xmx:oQdyauJaKeoz2ak3FIppB1c86cXBLycZpOyeR6DDoqOdKII5LcuuxQ>
    <xmx:oQdyaiCRf5Y-_TN5JkpWk7PNXNS4oManisSQI8kr-0KjO-0yLi1RkA>
    <xmx:oQdyarul_gln2yp6VXsSV4H7-WbajZJAuCOepxTmvKzbb5GhE8WVsw>
    <xmx:oQdyaoT957lwKrxmg4fBAXVjK6CG3NPQxuILZ9Ole7aGxCS8V-f1SA>
    <xmx:oQdyaqLCjIuRNGzSeEZC0EDQL2EM6IhCc8fDxsmMoZj4t__hW91xJkOX>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 080C9F80060; Tue,  4 Aug 2026 11:39:11 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 04 Aug 2026 18:38:50 +0300
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, kunit-dev@googlegroups.com,
 "Brendan Higgins" <brendan.higgins@linux.dev>,
 "David Gow" <david@davidgow.net>, "Rae Moar" <raemoar63@gmail.com>,
 stable@vger.kernel.org
Message-Id: <fa5455c2-58c5-4280-9770-0a5da80e3af7@app.fastmail.com>
In-Reply-To: <20260803181842.44648-1-ebiggers@kernel.org>
References: <20260803181842.44648-1-ebiggers@kernel.org>
Subject: Re: [PATCH] kunit: irq: Continue increasing hrtimer interval for longer
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, 3 Aug 2026, at 21:18, Eric Biggers wrote:
> Currently, kunit_irq_test_timer_func() stops increasing the hrtimer
> interval as soon as some forward progress is made in each of softirq and
> task context.  Update it to use a more aggressive strategy: increase the
> interval as long as the hrtimer is running significantly faster than
> either context.
>
> This resolves an occasional hang in the CRC and crypto library tests
> under qemu-system-s390x.  It was exposed by the change in the default
> preemption model on s390 from NONE to LAZY.  That seems to have exposed
> the issue by allowing some forward progress to be made while the actual
> system timer tick is still starved, preventing jiffies from increasing
> or the task context from making much progress towards max_iterations.
>
> Fixes: 201ceb94aa1d ("kunit: irq: Ensure timer doesn't fire too frequently")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This patch is targeting libcrypto-next
>
>  include/kunit/run-in-irq-context.h | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/include/kunit/run-in-irq-context.h 
> b/include/kunit/run-in-irq-context.h
> index bfe60d6cf28d..3802b6fb218e 100644
> --- a/include/kunit/run-in-irq-context.h
> +++ b/include/kunit/run-in-irq-context.h
> @@ -38,11 +38,13 @@ static enum hrtimer_restart 
> kunit_irq_test_timer_func(struct hrtimer *timer)
>  	softirq_calls = atomic_read(&state->softirq_func_calls);
> 
>  	/*
> -	 * If the timer is firing too often for the softirq or task to ever have
> -	 * a chance to run, increase the timer interval.  This is needed on very
> -	 * slow systems.
> +	 * If the hrtimer is running much faster than the bh_work or the task,
> +	 * then it is firing too fast and might be starving those contexts as
> +	 * well as the actual system timer tick.  Increase the interval.
>  	 */
> -	if (hardirq_calls >= 20 && (softirq_calls == 0 || task_calls == 0))
> +	if (hardirq_calls >= 20 &&
> +	    (hardirq_calls / 2 > softirq_calls ||
> +	     hardirq_calls / 2 > task_calls))
>  		state->interval = ktime_add_ns(state->interval, 250);
> 
>  	if (!state->func(state->test_specific_state))
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
