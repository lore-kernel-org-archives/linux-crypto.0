From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v9 3/5] crypto: drbg - add async seeding operation
Date: Thu, 21 May 2015 08:53:13 +0200
Message-ID: <1887173.hBZISiAer1@tauon>
References: <3340545.QDDPvU7BuN@tachyon.chronox.de> <23102012.0an2QbkQix@tachyon.chronox.de> <20150521063618.GA21348@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58144 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921AbbEUGxQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 02:53:16 -0400
In-Reply-To: <20150521063618.GA21348@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 21. Mai 2015, 14:36:18 schrieb Herbert Xu:

Hi Herbert,

>On Thu, May 21, 2015 at 08:10:13AM +0200, Stephan Mueller wrote:
>> The cancel operation is needed as otherwise my drbg context handle will be
>> removed by the crypto API during the sleep. That is the whole reason why
>> wait_event_interruptible is used.
>> 
>> So, even when using an uninterruptible sleep, the crypto API has no
>> knowledge about it and I have to serialize the destruction code path with
>> the async callback.
>
>I understand.  But if you use the uniterruptible version at least
>you won't have to deal with bogus early returns.

Thank you for pointing that out - I have seen that too. But the crux is that 
when using wait_event, the cancel function to serialize the destruction code 
path will *not* return at all, even when the async callback function completed 
successfully. Hence the choice for wait_event_interruptible
>
>The cancel by itself will *not* cause wait_event_interruptible
>to return early.  Somebody has to send it a signal for that to
>happen.

Correct. But I can only wake it up with a handle on urandom_init_wait on which 
the wait sleeps. That handle lives in random.c. So, to wake it up, I need 
another piece of code in random.c. That piece of code used to be the 
get_blocking_random_bytes_cancel function I offered in previous patches.

As Ted mentioned, he did not want to much code in random.c for this. In 
addition, if I understand you correctly in previous emails, it would be 
acceptable to wait until the callback was triggered (and thus causing the 
caller module to be not unloadable for that period of time.


Ciao
Stephan
