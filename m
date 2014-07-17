From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Thu, 17 Jul 2014 12:57:07 +0200
Message-ID: <1405594627.12194.9.camel@localhost>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
	linux-crypto@vger.kernel.org, beck@openbsd.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405588695-12014-1-git-send-email-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Do, 2014-07-17 at 05:18 -0400, Theodore Ts'o wrote:
> SYNOPSIS
> 	#include <linux/random.h>
> 
> 	int getrandom(void *buf, size_t buflen, unsigned int flags);

Cool, I think the interface is sane.

Btw. couldn't libressl etc. fall back to binary_sysctl
kernel.random.uuid and seed with that as a last resort? We have it
available for few more years.

> +SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
> +		unsigned int, flags)
> +{
> +	int r;
> +
> +	if (count > 256)
> +		return -EINVAL;
> +

Why this "arbitrary" limitation? Couldn't we just check for > SSIZE_MAX
or to be more conservative to INT_MAX?

> +	if (flags & GRND_RANDOM) {
> +		return _random_read(!(flags & GRND_BLOCK), buf, count);
> +	}
> +	if (flags & GRND_BLOCK) {
> +		r = wait_for_completion_interruptible(&urandom_initialized);
> +		if (r)
> +			return r;
> +	} else if (!completion_done(&urandom_initialized))
> +		return -EAGAIN;
> +	return urandom_read(NULL, buf, count, NULL);
> +}
> +

Great, thanks Ted,
Hannes
