From: Theodore Ts'o <tytso@mit.edu>
Subject: [RFC PATCH 0/3] random: replace urandom pool with a CRNG
Date: Mon,  2 May 2016 02:26:50 -0400
Message-ID: <1462170413-7164-1-git-send-email-tytso@mit.edu>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au,
	andi@firstfloor.org, sandyinchina@gmail.com,
	cryptography@lakedaemon.net, jsd@av8n.com, hpa@zytor.com,
	linux-crypto@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34734 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbcEBG1P (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 May 2016 02:27:15 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Everyone is consing up their own random patches, so this is my set.  :-)

By using a CRNG to replace the urandom pool, we address a number of
complaints which Stephan Mueller has been concerned about.  We now use
a much more aggressive interrupt sampling system to quickly initialize
a CRNG which gets used in place of the original non-blocking pool.
This tends to get initialized *very* quickly (before the devices are
finished being proved.)  Like Stephan's proposal this assumes that we
can get a bit of entropy per interrupt, which may be problematic on
some architectures.  So after we do this quick-and-dirty
initialization, we then fall back to the slower, more conservative
interrupt sampling system to fill the input pool, and we will do a
catastrophic reseeding once we get 128 bits using the slower but more
conservative system, and every five minutes afterwards, if possible.

In addition, on NUMA systems we make the CRNG state per-NUMA socket,
to address the NUMA locking contention problem which Andi Kleen has
been complaining about.  I'm not entirely sure this will work on the
crazy big SGI systems, but they are rare.  Whether they are rarer than
abusive userspace programs that are continuously pounding /dev/urandom
is unclear.  If necessary we can make a config option to turn off the
per-NUMA socket hack if it proves to be problematic.

Stephan Mueller (1):
  random: add interrupt callback to VMBus IRQ handler

Theodore Ts'o (2):
  random: replace non-blocking pool with a Chacha20-based CRNG
  random: make /dev/urandom scalable for silly userspace programs

 crypto/chacha20_generic.c |  61 ---------
 drivers/char/random.c     | 340 ++++++++++++++++++++++++++++++++++++----------
 drivers/hv/vmbus_drv.c    |   3 +
 include/crypto/chacha20.h |   1 +
 lib/Makefile              |   2 +-
 lib/chacha20.c            |  79 +++++++++++
 6 files changed, 355 insertions(+), 131 deletions(-)
 create mode 100644 lib/chacha20.c

-- 
2.5.0
