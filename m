From: "Rik Snel" <rsnel@cube.dyndns.org>
Subject: preliminary ABL implementation
Date: Sat, 23 Sep 2006 19:41:02 +0200
Message-ID: <11590332641118-git-send-email-rsnel@cube.dyndns.org>
Cc: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:58635 "EHLO
	smtp-vbr15.xs4all.nl") by vger.kernel.org with ESMTP
	id S1751363AbWIWRlM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 23 Sep 2006 13:41:12 -0400
To: herbert@gondor.apana.org.au
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Hello Herbert/list,

These patches implement the 'Arbitrary Block Length' blockcipher mode
as proposed by John Viega and David McGrew in
http://grouper.ieee.org/groups/1619/email/rtf00000.rtf (October 28, 2004) and
http://grouper.ieee.org/groups/1619/email/pdf00005.pdf (April 15, 2004).

The spec is unreviewed. Are there cryptologists on this list who are willing
to review the security proof of ABL in the April 15th paper and my
implementations (both this one and the "independent" implementation at
http://cube.dyndns.org/~rsnel/abl/).

ABL is the only patent-unencumbered wide block cipher mode that I know.
It can encrypt whole 512 byte sectors as whole blocks, this means that if
one bit in the unencrypted sector, it changes the corresponding cipherblock
completely. It can also operate on 4k blocks (or larger), this is useful for
deniable harddisk encryption. (it means all in-filesystem-block modifications
look like total block modifications). (operation on 4k block through dm-crypt 
requires a patch which will be sent seperately)

I have emailed the authors, David McGrew confirmed that ABL is unencumbered
by patents (as far as he and John Viega know). David had no test vectors.
John might have some, but he hasn't responed yet. 

Unfortunately the SISWG (http://siswg.org/) seems to be uninterested in
making ABL a standard because another contender (XCF) is faster. XCF
is however patented by Cisco.

Greetings,

Rik.
