From: Mark Kettenis <mark.kettenis@xs4all.nl>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Thu, 17 Jul 2014 20:48:11 +0200 (CEST)
Message-ID: <201407171848.s6HImBb4027900@glazunov.sibelius.xs4all.nl>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	beck@openbsd.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sibelius.xs4all.nl ([83.163.83.176]:26022 "EHLO
	glazunov.sibelius.xs4all.nl" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752118AbaGQTWM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Jul 2014 15:22:12 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 17, 2014, Theodore Ts'o wrote:
> 
> The getrandom(2) system call is a superset of getentropy(2).  When we
> add the support for this into glibc, it won't be terribly difficult
> nor annoying to drop the following in alongside the standard support
> needed for any new system call:
> 
> int getentropy(void *buf, size_t buflen)
> {
> 	int	ret;
> 
> 	ret = getentropy(buf, buflen, 0);
> 	return (ret > 0) ? 0 : ret;
> }

I'm sure you meant to use getrandom() there ;)

Since for LibreSSL we'd want a getentropy() that cannot fail the
getrandom() call should use GRND_BLOCK flag.  Actually it makes sense
(to me) to make blocking the default behaviour and have a
BRND_NONBLOCK flag.  Much in the same way as you need to specify
O_NONBLOCK if you want non-blocking behaviour for files.
