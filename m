From: Phil Sutter <phil@nwl.cc>
Subject: RFC: kcrypto - (yet another) user space interface
Date: Thu, 10 Jun 2010 20:22:29 +0200
Message-ID: <20100610182237.1B48E4CD45@orbit.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nico Erfurth <nico.erfurth@viprinet.com>,
	Simon Kissel <simon.kissel@viprinet.com>,
	Sebastian Siewior <bigeasy@breakpoint.cc>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orbit.nwl.cc ([91.121.169.95]:37898 "EHLO orbit.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab0FJSbc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jun 2010 14:31:32 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello everyone,

my employer wants to have a lightweight, zero-copy user space interface
to the Crypto-API and I *think* I'm on the right way to realising this.

What I've got so far is just a proof-of-concept, tested only with
cbc(aes), merely as generic as I'd like it to be, but with zero-copy of
the actual data buffers (which reside in user space) and asynchronous
operation.

You can check it out via git://nwl.cc/~n0-1/kcrypto.git or simply have a
look at http://nwl.cc/cgi-bin/git/gitweb.cgi?p=kcrypto.git;a=summary. If
you do so, you may in return flame me as much as you like to. :)

I know that it's far from being ready for use as the sole crypto API
user space interface, but I'm convinced as well that it will never be
unless someone with Crypto-API skills points out at least the very basic
design flaws I've already created.

As this is not yet being used in production (of course), I'm totally
open to changes. So taking this as start of a collaborative project
would be perfect for me, too.

Greetings (and sorry for yet another interface approach),
Phil
