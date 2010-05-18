From: David Miller <davem@davemloft.net>
Subject: [PATCH 0/6] Add Niagara2 crypto driver
Date: Mon, 17 May 2010 22:22:26 -0700 (PDT)
Message-ID: <20100517.222226.42804224.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50938
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754802Ab0ERFWS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 May 2010 01:22:18 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


These patches do the work necessary to add the Niagara2 crypto
driver.

The main enablers are a set of generic ablkcipher_walk helpers, and
testing support for async hash algorithms.

Some work still remains, in particular tcrypt still can't perf test
async ciphers :-/

These changes are also available from the GIT tree at:

	master.kernel.org:/pub/scm/linux/kernel/git/davem/cryptodev-2.6.git

Thanks!
