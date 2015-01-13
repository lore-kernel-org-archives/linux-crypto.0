From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: qat - fix device reset flow
Date: Tue, 13 Jan 2015 22:33:31 +1100
Message-ID: <20150113113331.GA6764@gondor.apana.org.au>
References: <20150109195457.28205.23092.stgit@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: "Allan, Bruce W" <bruce.w.allan@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:59574 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbbAMLdi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Jan 2015 06:33:38 -0500
Content-Disposition: inline
In-Reply-To: <20150109195457.28205.23092.stgit@gitlad.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 09, 2015 at 11:54:58AM -0800, Allan, Bruce W wrote:
> When the device needs a reset, e.g. when an uncorrectable PCIe AER event
> occurs, various services/data structures need to be cleaned up, the
> hardware reset and the services/data structures initialized and started.
> The code to perform the cleanup and initialization was not performed when
> a device reset was done.

All five qat patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
