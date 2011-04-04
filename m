From: Phil Sutter <phil@nwl.cc>
Subject: aead: driver side documentation
Date: Mon, 4 Apr 2011 19:03:37 +0200
Message-ID: <20110404170337.GA1511@orbit.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orbit.nwl.cc ([91.121.141.167]:33721 "EHLO orbit.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab1DDRJX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Apr 2011 13:09:23 -0400
Received: from orbit.nwl.cc (localhost [127.0.0.1])
	by orbit.nwl.cc (Postfix) with ESMTP id 2D1771044A91
	for <linux-crypto@vger.kernel.org>; Mon,  4 Apr 2011 19:03:37 +0200 (CEST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dear list,

I would like to enhance drivers/crypto/mv_cesa.c by an AEAD algorithm
(at least authenc(hmac(sha1),cbc(aes))), since the driver is able to do
both operations in one go.

Unfortunately, I have found little information about this task in
Documentation/ or the web. Am I missing something? It would be really
great if you could point me to the right direction here.

Greetings, Phil
