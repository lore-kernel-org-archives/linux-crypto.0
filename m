From: Alex Xu <alex_y_xu@yahoo.ca>
Subject: Re: getrandom waits for a long time when /dev/random is
 insufficiently read from
Date: Fri, 29 Jul 2016 09:03:45 -0400
Message-ID: <20160729090345.798c3e6f.alex_y_xu@yahoo.ca>
References: <20160728180732.12d38880@alex-desktop>
	<2481163.nONN48TG9I@tauon.atsec.com>
	<CAJU7zaL8G28chcwEEYAquApm2ncPaBjKky4UPaWVy=6B+-rsCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Stephan Mueller <smueller@chronox.de>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	virtualization@lists.linux-foundation.org
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nm3-vm0.bullet.mail.bf1.yahoo.com ([98.139.212.154]:56005 "EHLO
	nm3-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752549AbcG2NJp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jul 2016 09:09:45 -0400
In-Reply-To: <CAJU7zaL8G28chcwEEYAquApm2ncPaBjKky4UPaWVy=6B+-rsCA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 29 Jul 2016 12:24:27 +0200
Nikos Mavrogiannopoulos <nmav@gnutls.org> wrote:

> On Fri, Jul 29, 2016 at 7:40 AM, Stephan Mueller
> <smueller@chronox.de> wrote:
> > And finally, you have a coding error that is very very common but
> > fatal when reading from /dev/random: you do not account for short
> > reads which implies that your loop continues even in the case of
> > short reads.
> >
> > Fix your code with something like the following:
> > int read_random(char *buf, size_t buflen)
> > {
> >         int fd = 0;
> >         ssize_t ret = 0;
> >         size_t len = 0;
> >
> >         fd = open("/dev/random", O_RDONLY|O_CLOEXEC);
> >         if(0 > fd)
> >                 return fd;
> >         do {
> >                 ret = read(fd, (buf + len), (buflen - len));
> >                 if (0 < ret)
> >                         len += ret;
> >         } while ((0 < ret || EINTR == errno || ERESTART == errno)
> >                  && buflen > len);  
> 
> Unless there is a documentation error, the same is required when using
> getrandom(). It can also return short as well as to be interrupted.
> 
> regards,
> Nikos

I am aware that (according to the documentation) both random(4) and
getrandom(2) may not return the full size of the read. However, that is
(as far as I know) not relevant to the point that I am making.

What I am saying is that based on my understanding of random(4) and
getrandom(2), at boot, given the same buffer size, reading
from /dev/random should have the same behavior as calling getrandom
passing no flags.

The buffer size can also be set to 1 with similar results, but the
iteration number for success must be then increased to a large number.
IME 30 worked consistently while 29 hung; your results may vary.

The interesting thing is though, if GRND_RANDOM is passed to getrandom,
then it does not hang and returns 1 byte immediately (whether or not
GRND_NONBLOCK is set).

The following revised program demonstrates this:

#include <fcntl.h>
#include <linux/random.h>
#include <stdlib.h>
#include <string.h>
#include <syscall.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    char buf[1];
    int gr_flags;
    const char *iters;

    if (!strcmp(argv[1], "-r")) {
        gr_flags = GRND_RANDOM;
        iters = argv[2];
    } else {
        gr_flags = 0;
        iters = argv[1];
    }

    for (int i = 0; i < atoi(iters); i++) {
        int fd;
        if ((fd = open("/dev/random", O_RDONLY)) == -1)
            return 2;

        if (read(fd, buf, 1) != 1)
            return 3;

        if (close(fd) == -1)
            return 4;
    }

    if (syscall(SYS_getrandom, buf, 1, gr_flags) != 1)
        return 5;

    return 0;
}

Again, making the buffer size 1 resolves the complaint regarding short
reads.

With the same command line as my original email, running this in QEMU
results in:

1, 2..29: reads all return 1 byte, getrandom pauses for 90-110 secs then
returns 1 byte
30+: reads all return 1 byte, getrandom immediately returns 1 byte
-r 0: getrandom immediately returns 1 byte
-r 1, -r 2, -r 128, -r 256: reads all return 1 byte, getrandom
immediately returns 1 byte

Moving the open and close calls outside of the loop produces the same
results. Writing 4096 bytes to /dev/urandom also has no effect.

In my opinion, assuming I am not doing something terribly wrong, this
constitutes a bug in the kernel's handling of getrandom calls at boot,
possibly only when the primary source of entropy is virtio.
