From: Stephan Mueller <smueller@chronox.de>
Subject: key retention service: DH support
Date: Mon, 23 May 2016 20:57:12 +0200
Message-ID: <1522711.HEekpKlqDU@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: keyrings@vger.kernel.org, linux-crypto@vger.kernel.org
To: dhowells@redhat.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39824 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbcEWS53 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 May 2016 14:57:29 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi David,

With the new DH support for the key retention service, support for DH derived 
keys pops up.

The implementation in security/keys/dh.c returns the DH shared secret straight 
to the user space caller.

I implemented a KDF with that exact scenario already in mind: [1].

I am wondering whether the shared secret should be processed by a KDF before 
returning the data to user space?

[1] http://www.chronox.de/kdf.html

Ciao
Stephan
