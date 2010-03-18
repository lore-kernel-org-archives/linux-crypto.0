From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: fix vmac test fails on s390 (v2)
Date: Thu, 18 Mar 2010 20:26:00 +0800
Message-ID: <20100318122559.GA13676@gondor.apana.org.au>
References: <1268749364-2397-1-git-send-email-shane.wang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, joseph.cihula@intel.com
To: Shane Wang <shane.wang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60009 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752710Ab0CRM0E (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Mar 2010 08:26:04 -0400
Content-Disposition: inline
In-Reply-To: <1268749364-2397-1-git-send-email-shane.wang@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 16, 2010 at 07:22:44AM -0700, Shane Wang wrote:
> This patch is to fix the vmac algorithm, add more test cases for vmac, and fix the test failure on some big endian system like s390.
> 
> Signed-off-by: Shane Wang <shane.wang@intel.com>

Patch applied.  Thanks a lot for following through on this!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
