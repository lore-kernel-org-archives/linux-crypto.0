From: Julia Lawall <julia.lawall@lip6.fr>
Subject: [cryptodev:master 77/100] drivers/crypto/ccp/ccp-debugfs.c:303:3-9:
 preceding lock on line 299 (fwd)
Date: Mon, 19 Jun 2017 11:36:51 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1706191136120.3683@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, kbuild-all@01.org
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:55840
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752389AbdFSJgy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 05:36:54 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Please check whether a lock is needed before line 303.

julia

---------- Forwarded message ----------
Date: Mon, 19 Jun 2017 17:34:11 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [cryptodev:master 77/100] drivers/crypto/ccp/ccp-debugfs.c:303:3-9:
    preceding lock on line 299

CC: kbuild-all@01.org
CC: linux-crypto@vger.kernel.org
TO: Gary R Hook <gary.hook@amd.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   88d58ef891d868303acd7951cb1282c911f736ac
commit: 3cdbe346ed3f380eae1cb3e9febfe703e7d8a7b0 [77/100] crypto: ccp - Add debugfs entries for CCP information
:::::: branch date: 3 hours ago
:::::: commit date: 3 hours ago

>> drivers/crypto/ccp/ccp-debugfs.c:303:3-9: preceding lock on line 299

git remote add cryptodev https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
git remote update cryptodev
git checkout 3cdbe346ed3f380eae1cb3e9febfe703e7d8a7b0
vim +303 drivers/crypto/ccp/ccp-debugfs.c

3cdbe346 Gary R Hook 2017-05-02  293  	unsigned long flags;
3cdbe346 Gary R Hook 2017-05-02  294  	int i;
3cdbe346 Gary R Hook 2017-05-02  295
3cdbe346 Gary R Hook 2017-05-02  296  	if (!debugfs_initialized())
3cdbe346 Gary R Hook 2017-05-02  297  		return;
3cdbe346 Gary R Hook 2017-05-02  298
3cdbe346 Gary R Hook 2017-05-02 @299  	write_lock_irqsave(&ccp_debugfs_lock, flags);
3cdbe346 Gary R Hook 2017-05-02  300  	if (!ccp_debugfs_dir) {
3cdbe346 Gary R Hook 2017-05-02  301  		ccp_debugfs_dir = debugfs_create_dir(KBUILD_MODNAME, NULL);
3cdbe346 Gary R Hook 2017-05-02  302  		if (!ccp_debugfs_dir)
3cdbe346 Gary R Hook 2017-05-02 @303  			return;
3cdbe346 Gary R Hook 2017-05-02  304  	}
3cdbe346 Gary R Hook 2017-05-02  305  	write_unlock_irqrestore(&ccp_debugfs_lock, flags);
3cdbe346 Gary R Hook 2017-05-02  306

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
