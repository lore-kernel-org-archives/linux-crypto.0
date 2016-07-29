From: Stephan Mueller <smueller@chronox.de>
Subject: Re: getrandom waits for a long time when /dev/random is insufficiently read from
Date: Fri, 29 Jul 2016 07:40:02 +0200
Message-ID: <2481163.nONN48TG9I@tauon.atsec.com>
References: <20160728180732.12d38880@alex-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org,
	virtualization@lists.linux-foundation.org
To: Alex Xu <alex_y_xu@yahoo.ca>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33846 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbcG2FkH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jul 2016 01:40:07 -0400
In-Reply-To: <20160728180732.12d38880@alex-desktop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 28. Juli 2016, 18:07:32 CEST schrieb Alex Xu:

Hi Alex,

> Linux 4.6, also tried 4.7, qemu 2.6, using this C program:

I am not sure what problem you are referring to, but that is an expected 
behavior.

You get partial reads when reading from /dev/random with a minimum of 64 
bits. On the other hand getrandom(2) is woken up after the input_pool 
received 128 bits of entropy.

In you strace you see that after reading 16 bytes from /dev/random, the 
getrandom unblocks and starts delivering.

Note, in virtualized environments the current Linux /dev/random 
implementation collects massively less entropy compared to a bare-metal 
system. Hence the long wait time of your 90 to 100 secs until getrandom 
unblocks.

Besides, even without reading from /dev/random, your getrandom will wait that 
long.

And finally, you have a coding error that is very very common but fatal when 
reading from /dev/random: you do not account for short reads which implies 
that your loop continues even in the case of short reads.

Fix your code with something like the following:

int read_random(char *buf, size_t buflen)
{
        int fd = 0;
        ssize_t ret = 0;
        size_t len = 0;

        fd = open("/dev/random", O_RDONLY|O_CLOEXEC);
        if(0 > fd)
                return fd;
        do {
                ret = read(fd, (buf + len), (buflen - len));
                if (0 < ret)
                        len += ret;
        } while ((0 < ret || EINTR == errno || ERESTART == errno)
                 && buflen > len);

...

Ciao
Stephan
