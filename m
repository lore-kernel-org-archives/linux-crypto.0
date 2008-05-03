From: =?ISO-8859-1?Q?Adrian-Ken_R=FCegsegger?= <rueegsegger@swiss-it.ch>
Subject: tcrypt: hmac test with keys > blocksize fail
Date: Sat, 03 May 2008 02:10:34 +0200
Message-ID: <481BAD7A.3010003@swiss-it.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@ml.breakpoint.cc
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:2338 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904AbYECAmD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 2 May 2008 20:42:03 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

using the cryptodev-2.6 tree I noticed that the hmac tests that have
keys larger than blocksize for md5 and the various sha algorithms all
fail (tcrypt mode=10[0-5]). The other tests seem to pass just fine.

The issue seems to have come from commit
de224c309b5631bdaae3fcd6880cfb93b52f5a53.


I have tested 48c8949ea8460216783dd33640121187b9531b60 which does not
contain this bug.  It's just before the various tcrypt-changes from
Sebastian Siewior.

-Adrian
