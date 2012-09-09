From: Romain Francoise <romain@orebokech.com>
Subject: Re: Linux 3.6-rc5
Date: Sun, 09 Sep 2012 16:23:11 +0200
Message-ID: <87wr038ecw.fsf@silenus.orebokech.com>
References: <CA+55aFwnPfdyTTG6WTuhChomg=t9nSS18xracq3iQ3F5+PWOog@mail.gmail.com>
	<87har7h84h.fsf@silenus.orebokech.com>
	<20120909155424.862635h7ncykg9s0@www.81.fi>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stringer.orebokech.com ([88.190.240.207]:41756 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab2IIOXN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 9 Sep 2012 10:23:13 -0400
In-Reply-To: <20120909155424.862635h7ncykg9s0@www.81.fi> (Jussi Kivilinna's
	message of "Sun, 09 Sep 2012 15:54:24 +0300")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Jussi Kivilinna <jussi.kivilinna@mbnet.fi> writes:

> Does reverting e46e9a46386bca8e80a6467b5c643dc494861896 help?

It does, thanks.
