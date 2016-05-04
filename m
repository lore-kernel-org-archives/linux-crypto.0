From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 1/3] random: replace non-blocking pool with a Chacha20-based CRNG
Date: Wed, 04 May 2016 08:24:28 +0200
Message-ID: <1911535.59KOZ91Nl5@positron.chronox.de>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu> <1462170413-7164-2-git-send-email-tytso@mit.edu> <2341945.hVvssvnSpF@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	andi@firstfloor.org, sandyinchina@gmail.com,
	cryptography@lakedaemon.net, jsd@av8n.com, hpa@zytor.com,
	linux-crypto@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54610 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbcEDGYb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 02:24:31 -0400
In-Reply-To: <2341945.hVvssvnSpF@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 3. Mai 2016, 11:36:12 schrieb Stephan Mueller:

Hi Ted,

> > +
> > +static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
> > +{
> > +	ssize_t ret = 0, i;
> > +	__u8 tmp[CHACHA20_BLOCK_SIZE];
> > +	int large_request = (nbytes > 256);
> > +
> > +	while (nbytes) {
> > +		if (large_request && need_resched()) {
> > +			if (signal_pending(current)) {
> > +				if (ret == 0)
> > +					ret = -ERESTARTSYS;
> > +				break;
> > +			}
> > +			schedule();
> > +		}
> > +
> > +		extract_crng(tmp);
> > +		i = min_t(int, nbytes, CHACHA20_BLOCK_SIZE);
> > +		if (copy_to_user(buf, tmp, i)) {
> > +			ret = -EFAULT;
> > +			break;
> > +		}
> > +
> > +		nbytes -= i;
> > +		buf += i;
> > +		ret += i;
> > +	}
> > +
> > +	/* Wipe data just written to memory */
> > +	memzero_explicit(tmp, sizeof(tmp));
> 
> Would it make sense to add another chacha20_block() call here at the end?
> Note, the one thing about the SP800-90A DRBG I really like is the enhanced
> backward secrecy support which is implemented by "updating" the internal
> state (the key / state) used for one or more random number generation
> rounds after one request for random numbers is satisfied.
> 
> This means that even if the state becomes known or the subsequent caller
> manages to deduce the state of the RNG to some degree of confidence, he
> cannot backtrack the already generated random numbers.
> 
> I see that the ChaCha20 RNG implicitly updates its state while it operates.
> But for the last round of the RNG, there is no more shuffling of the
> internal state. As one round is 64 bytes in size and many callers just want
> 16 or 32 bytes (as seen during testing), a lot of callers trigger only one
> round of the RNG.

After doing some performance tests, I see that we reach a performance of north 
of 200 MB/s on my system (compare that to 12 MB/s for the SHA-1 version).

Thus, I would assume adding another call to chacha20_block should not hurt.

Ciao
Stephan
