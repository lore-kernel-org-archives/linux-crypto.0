From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: padata: Fixes for 3.4
Date: Wed, 28 Mar 2012 08:41:57 +0200
Message-ID: <20120328064157.GD16191@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:49116 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab2C1GmE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Mar 2012 02:42:04 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patchset contains the following changes:

1) Add a reference to the padata api documentation to the code.
   Suggested by Peter Zijlstra.

2) We use the active cpumask to determine the superset of cpus
   to use for parallelization. The active cpumask is not the appropriate
   cpumask for these purposes. Replace the cpu active usage by cpu online.
   Reported by Peter Zijlstra.

3)  On cpu hotplug, we don't remove the cpu that went offline from our cpumasks.
    Fix this by removing this cpu from the padata cpumasks.

Please pull or apply.

The patchset is based on the crypto-2.6 tree and is available via git:

The following changes since commit ff0a70fe053614e763eb3ac88bfea9c5615fce3b:
  Jussi Kivilinna (1):
        crypto: twofish-x86_64-3way - module init/exit functions should be static

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/linux-stk padata-fixes

Steffen Klassert (3):
      padata: Add a reference to the api documentation
      padata: Use the online cpumask as the default
      padata: Fix cpu hotplug

 kernel/padata.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)
