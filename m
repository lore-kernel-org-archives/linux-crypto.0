From: Max Vozeler <max@hinterhof.net>
Subject: [RFC PATCH] crypto: loop-AES support
Date: Mon, 28 Dec 2009 19:59:11 +0100
Message-ID: <1262026755-23056-1-git-send-email-max@hinterhof.net>
Cc: linux-crypto@nl.linux.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.nusquama.org ([85.131.211.20]:39052 "EHLO
	mail.nusquama.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbZL1Tcy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Dec 2009 14:32:54 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This set adds an implementation of the Loop-AES block
encryption modes for dm-crypt.

It consists of two main parts:

 (1) blkcipher implementation of the Loop-AES block 
     chaining modes (lmk2, lmk3)

 (2) Support for alternating keys in dm-crypt.

The patches are based on cryptodev-2.6.

Together they can be used to access encrypted images
created with loop-AES.

Loop-AES v2.x multi-key-v2 mode corresponds to the
dm-crypt cipher spec "aes-lmk2-plain64-multi:64", v2.x
corresponds to "aes-lmk3-plain64-multi:64".

Tested on mips32 and x86_64. 

To actually use this with Loop-AES encrypted images
you will need a key derivator which converts Loop-AES
format keyfiles into a hexstring for dm-crypt.

I'm putting some rough code for testing up on 
http://hinterhof.net/~max/keyderive-0.1.tar.gz

Please note that this is not intended to be used with
any valuable keys yet. I'll work on a robust derivator
once the kernel side is done.

Looking forward to comments and review,

	Max
