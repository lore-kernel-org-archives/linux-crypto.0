From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH-v3 0/5] random: replace urandom pool with a CRNG
Date: Mon, 30 May 2016 10:53:22 -0700
Message-ID: <20160530175322.GB13997@two.firstfloor.org>
References: <1464586765-14436-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	smueller@chronox.de, herbert@gondor.apana.org.au,
	andi@firstfloor.org, sandyinchina@gmail.com,
	cryptography@lakedaemon.net, jsd@av8n.com, hpa@zytor.com,
	linux-crypto@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from one.firstfloor.org ([193.170.194.197]:52786 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161249AbcE3Rx0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 May 2016 13:53:26 -0400
Content-Disposition: inline
In-Reply-To: <1464586765-14436-1-git-send-email-tytso@mit.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> In addition, on NUMA systems we make the CRNG state per-NUMA socket, to
> address the NUMA locking contention problem which Andi Kleen has been
> complaining about.  I'm not entirely sure this will work well on the
> crazy big SGI systems, but they are rare.  Whether they are rarer than

It should work the same on larger systems, the solution scales
naturally to lots of sockets. It's not clear it'll help enough on systems
with a lot more cores per socket, like a Xeon Phi. But for now it should
be good enough.

-Andi
