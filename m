From: Rik Snel <rsnel@cube.dyndns.org>
Subject: LRW implementation, please comment
Date: Thu, 31 Aug 2006 14:39:30 +0200
Message-ID: <11570279761772-git-send-email-rsnel@cube.dyndns.org>
Reply-To: Rik Snel <rsnel@cube.dyndns.org>
Cc: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:27405 "EHLO
	smtp-vbr4.xs4all.nl") by vger.kernel.org with ESMTP id S932162AbWHaMkM
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 Aug 2006 08:40:12 -0400
To: herbert@gondor.apana.org.au
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Hello Herbert (cc: list),

This is an attempt at implementing LRW for the new blockcipher API.
Please review, test and comment. 

I intend to implement ABL also (arbitrary block length), an unencumbered wide
block cipher mode (it is based on GMC (Galois/Counter Mode) which is explicitly
claimed to be patent free and has the same creators).

The mode has been dropped by its creators (I don't know why) and
is not formally publised, see:

http://grouper.ieee.org/groups/1619/email/pdf00005.pdf
http://grouper.ieee.org/groups/1619/email/rtf00000.rtf

It fulfills the same function as the patent-encumbered EME, CMC and XCB.

Greetings,

Rik.

