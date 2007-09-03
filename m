From: rsnel@cube.dyndns.org
Subject: proposed XTS implementation
Date: Mon, 3 Sep 2007 23:53:13 +0200
Message-ID: <20070903215313.GA3622@cube.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: christoph.sievers@gmail.com, herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2464 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbXICVyj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Sep 2007 17:54:39 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello list (cc: Herbert, Christoph),

In my previous mail you will find a proposed patch to
implement XTS (a block cipher mode alike LRW, but unlike
LRW, no known security problems (LRW has problems encrypting
it's own key)). An email from Cristoph sparked my interest,
and the lrw.c file was a good starting point. You will find
that xts.c includes less weird functions than lrw.c.

xts.c is compilation tested as a module outside the kernel,
it 'hould work(tm).

Herbert: I need to instances of AES, did I do that correctly?

Greetings,

Rik.

-- 
Nothing is ever a total loss; it can always serve as a bad example.
