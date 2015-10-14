From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] crypto: x86: Remove duplicate define of
 SHA1_DIGEST_SIZE
Date: Wed, 14 Oct 2015 22:44:39 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1510142242030.3960@nanos>
References: <1444850171-17931-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ameenali023@gmail.com, bp@alien8.de, dan.carpenter@oracle.com,
	davem@davemloft.net, firogm@gmail.com, herbert@gondor.apana.org.au,
	hpa@zytor.com, mingo@redhat.com, minipli@googlemail.com,
	smueller@chronox.de, tim.c.chen@linux.intel.com, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:57167 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbbJNUpt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 16:45:49 -0400
In-Reply-To: <1444850171-17931-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 14 Oct 2015, LABBE Corentin wrote:

> The sha x86 crypto code use two define for the same thing:
> NUM_SHA1_DIGEST_WORDS and SHA1_DIGEST_LENGTH
> Replace them by SHA1_DIGEST_SIZE/4

That's wrong. Use only one for the number of words and make the define
so it's derived from the LENGTH.

Thanks,

	tglx
