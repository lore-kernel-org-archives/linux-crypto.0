From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: getrandom waits for a long time when /dev/random is
 insufficiently read from
Date: Fri, 29 Jul 2016 12:24:27 +0200
Message-ID: <CAJU7zaL8G28chcwEEYAquApm2ncPaBjKky4UPaWVy=6B+-rsCA@mail.gmail.com>
References: <20160728180732.12d38880@alex-desktop> <2481163.nONN48TG9I@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Alex Xu <alex_y_xu@yahoo.ca>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	virtualization@lists.linux-foundation.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:36133 "EHLO
	mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbcG2KZH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jul 2016 06:25:07 -0400
Received: by mail-ua0-f194.google.com with SMTP id m60so3666576uam.3
        for <linux-crypto@vger.kernel.org>; Fri, 29 Jul 2016 03:25:07 -0700 (PDT)
In-Reply-To: <2481163.nONN48TG9I@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 29, 2016 at 7:40 AM, Stephan Mueller <smueller@chronox.de> wrote:
> And finally, you have a coding error that is very very common but fatal when
> reading from /dev/random: you do not account for short reads which implies
> that your loop continues even in the case of short reads.
>
> Fix your code with something like the following:
> int read_random(char *buf, size_t buflen)
> {
>         int fd = 0;
>         ssize_t ret = 0;
>         size_t len = 0;
>
>         fd = open("/dev/random", O_RDONLY|O_CLOEXEC);
>         if(0 > fd)
>                 return fd;
>         do {
>                 ret = read(fd, (buf + len), (buflen - len));
>                 if (0 < ret)
>                         len += ret;
>         } while ((0 < ret || EINTR == errno || ERESTART == errno)
>                  && buflen > len);

Unless there is a documentation error, the same is required when using
getrandom(). It can also return short as well as to be interrupted.

regards,
Nikos
