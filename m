From: Herbert Xu <herbert.xu@redhat.com>
Subject: [0/3] [DM] dm-crypt: Add async crypto support
Date: Wed, 11 Jul 2007 11:03:03 +0800
Message-ID: <20070711030303.GA6730@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christophe Saout <christophe@saout.de>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2494 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753585AbXGKDDW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Jul 2007 23:03:22 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi:

I've rebased the async dm-crypt patches for 2.6.22.  In doing
so I've refactored the kcryptd split so that all crypto operations
happen in kcryptd while all IO submissions occur in kcryptd-io.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
