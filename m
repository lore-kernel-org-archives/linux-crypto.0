From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Sun, 20 Jul 2014 13:06:35 -0400
Message-ID: <20140720170635.GF5017@thunk.org>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <871ttg3u8h.fsf@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
	linux-crypto@vger.kernel.org, beck@openbsd.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46132 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbaGTRG6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 20 Jul 2014 13:06:58 -0400
Content-Disposition: inline
In-Reply-To: <871ttg3u8h.fsf@tassilo.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jul 20, 2014 at 08:50:06AM -0700, Andi Kleen wrote:
> Theodore Ts'o <tytso@mit.edu> writes:
> >  
> >  #undef __NR_syscalls
> > -#define __NR_syscalls 277
> > +#define __NR_syscalls 278
> 
> You need to add the syscall to kernel/sys_ni.c too, otherwise it will be
> impossible to build without random device.

The random device is not optional; it is alaways guaranteed to be
present.  From drivers/char/Makefile:

obj-y			+= mem.o random.o

Cheers,

					- Ted
