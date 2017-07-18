From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH v12 1/4] crypto: make Jitter RNG directly accessible
Date: Tue, 18 Jul 2017 10:30:14 +0200
Message-ID: <20170718083014.GA18340@kroah.com>
References: <3910055.ntkqcq1Chb@positron.chronox.de>
 <22067042.Wh8NKMhEMa@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: "Jason A. Donenfeld" <jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42700 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751349AbdGRIaU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 04:30:20 -0400
Content-Disposition: inline
In-Reply-To: <22067042.Wh8NKMhEMa@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 18, 2017 at 09:57:55AM +0200, Stephan Müller wrote:
> --- /dev/null
> +++ b/include/crypto/jitterentropy.h
> @@ -0,0 +1,80 @@
> +/*
> + * Copyright (C) 2017, Stephan Mueller <smueller@chronox.de>
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + * 1. Redistributions of source code must retain the above copyright
> + *    notice, and the entire permission notice in its entirety,
> + *    including the disclaimer of warranties.
> + * 2. Redistributions in binary form must reproduce the above copyright
> + *    notice, this list of conditions and the following disclaimer in the
> + *    documentation and/or other materials provided with the distribution.
> + * 3. The name of the author may not be used to endorse or promote
> + *    products derived from this software without specific prior
> + *    written permission.
> + *
> + * ALTERNATIVELY, this product may be distributed under the terms of
> + * the GNU General Public License, in which case the provisions of the GPL2 are
> + * required INSTEAD OF the above restrictions.  (This clause is
> + * necessary due to a potential bad interaction between the GPL and
> + * the restrictions contained in a BSD-style copyright.)
> + *
> + * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
> + * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
> + * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ALL OF
> + * WHICH ARE HEREBY DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE
> + * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
> + * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
> + * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
> + * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
> + * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
> + * USE OF THIS SOFTWARE, EVEN IF NOT ADVISED OF THE POSSIBILITY OF SUCH
> + * DAMAGE.
> + */
> +
> +#ifndef _JITTERENTROPY_H
> +#define _JITTERENTROPY_H
> +
> +typedef	unsigned long long	__u64;
> +typedef	long long		__s64;

types.h already has these defines, don't re-typedef them again...
