From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - do not duplicate string containing
 firmware name
Date: Tue, 28 Apr 2015 10:43:35 +0800
Message-ID: <20150428024335.GA29652@gondor.apana.org.au>
References: <20150427205827.27002.45117.stgit@bwallan-smackover2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Bruce Allan <bruce.w.allan@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36310 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbbD1Cnl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2015 22:43:41 -0400
Content-Disposition: inline
In-Reply-To: <20150427205827.27002.45117.stgit@bwallan-smackover2.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Bruce Allan <bruce.w.allan@intel.com> wrote:
> Use ADF_DH895XCC_FW instead of duplicating the string "qat_895xcc.bin"
> when referring to the DH895xCC firmware.
> 
> Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
