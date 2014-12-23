From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [0/5] hwrng: Fix kref warning and underlying bugs
Date: Tue, 23 Dec 2014 16:39:09 +1100
Message-ID: <20141223053909.GA28001@gondor.apana.org.au>
References: <20141223030956.GA26839@wfg-t540p.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKP <lkp@01.org>,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Amos Kong <akong@redhat.com>, m@bues.ch, mpm@selenic.com,
	amit.shah@redhat.com
To: Fengguang Wu <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:56646 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaLWFj0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Dec 2014 00:39:26 -0500
Content-Disposition: inline
In-Reply-To: <20141223030956.GA26839@wfg-t540p.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 22, 2014 at 07:09:56PM -0800, Fengguang Wu wrote:
> Greetings,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is

Sigh, looks like more work is needed on this.

Here is a series of patches that should fix this along with the
underlying issue exposed by it and some other related problems.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
