From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Allow drivers to build if COMPILE_TEST is enabled
Date: Wed, 14 Oct 2015 22:08:03 +0800
Message-ID: <20151014140803.GA17261@gondor.apana.org.au>
References: <1444743760-15155-1-git-send-email-javier@osg.samsung.com>
 <201510140540.8v7D383Q%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	kbuild-all@01.org, linux-kernel@vger.kernel.org,
	Luis de Bethencourt <luisbg@osg.samsung.com>,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: kbuild test robot <lkp@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41032 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbbJNOIP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 10:08:15 -0400
Content-Disposition: inline
In-Reply-To: <201510140540.8v7D383Q%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 14, 2015 at 05:03:30AM +0800, kbuild test robot wrote:
> Hi Javier,
> 
> [auto build test WARNING on cryptodev/master -- if it's inappropriate base, please suggest rules for selecting the more suitable base]

Javier, please make sure these warnings are fixed before you enable
COMPILE_TEST.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
