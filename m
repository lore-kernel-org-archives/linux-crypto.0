From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] /dev/random driver fix for 4.8
Date: Thu, 28 Jul 2016 11:49:10 -0400
Message-ID: <20160728154910.GA28242@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53330 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173AbcG1PtP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Jul 2016 11:49:15 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following changes since commit 86a574de4590ffe6fd3f3ca34cdcf655a78e36ec:

  random: strengthen input validation for RNDADDTOENTCNT (2016-07-03 17:09:33 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/random.git tags/random_for_linus_stable

for you to fetch changes up to 59b8d4f1f5d26e4ca92172ff6dcd1492cdb39613:

  random: use for_each_online_node() to iterate over NUMA nodes (2016-07-27 23:30:25 -0400)

----------------------------------------------------------------
Fix a boot failure on systems with non-contiguous NUMA id's.

----------------------------------------------------------------
Theodore Ts'o (1):
      random: use for_each_online_node() to iterate over NUMA nodes

 drivers/char/random.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)
