From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC -v3] random: introduce getrandom(2) system call
Date: Fri, 18 Jul 2014 07:51:22 -0400
Message-ID: <20140718115122.GG1491@thunk.org>
References: <1405677564-16802-1-git-send-email-tytso@mit.edu>
 <CAFLxGvy7CwWiagxMHixHnuUwvimBOOJyJqs4g2Rq8hzoUA60mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-abi@vger.kernel.org,
	linux-crypto@vger.kernel.org, beck@openbsd.org,
	deraadt@cvs.openbsd.org
To: Richard Weinberger <richard.weinberger@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43074 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761417AbaGRLvj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Jul 2014 07:51:39 -0400
Content-Disposition: inline
In-Reply-To: <CAFLxGvy7CwWiagxMHixHnuUwvimBOOJyJqs4g2Rq8hzoUA60mw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 18, 2014 at 12:25:17PM +0200, Richard Weinberger wrote:
> >                     if (ret != buflen)
> 
> A small nit-pick, missing "{".

Thanks, good catch.   Fixed.

						- Ted
