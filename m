From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v5 1/5] random: Async and sync API for accessing nonblocking_pool
Date: Mon, 11 May 2015 09:30:11 +0200
Message-ID: <3644541.vBsSXgpCaS@tauon>
References: <1887272.cxqymnQQZn@tachyon.chronox.de> <3264123.O3YfJV7UGj@tachyon.chronox.de> <20150511065714.GA2598@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34754 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbbEKHaS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 03:30:18 -0400
In-Reply-To: <20150511065714.GA2598@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 11. Mai 2015, 14:57:14 schrieb Herbert Xu:

Hi Herbert,
>
>There are two problems with this patch:
>
>1) The interface is way too complicated for a once off wait used
>only during boot.  Really there is no need for cancellations.

I will remove that in the next installment. But that means that the DRBG 
kernel module (or any other module) cannot be unloaded until the work 
completes.
>
>2) There is potential for deadlock because you schedule a work that
>then sits around until the entropy is available.  What if whatever
>is generating that entropy used the same work thread in future?
>
>So I suggest instead an interface that simply schedules a work
>when the entropy is available.

Are you suggesting to only leave get_blocking_random_bytes and have the caller 
implementing the appropriate synchronous wait or async work?

Ciao
Stephan
