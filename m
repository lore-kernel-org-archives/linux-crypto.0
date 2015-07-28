From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - remove redundant struct elem
Date: Tue, 28 Jul 2015 15:06:39 +0800
Message-ID: <20150728070639.GC25287@gondor.apana.org.au>
References: <20150724201825.27602.85101.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Bruce Allan <bruce.w.allan@intel.com>, qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57863 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbbG1HGm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Jul 2015 03:06:42 -0400
Content-Disposition: inline
In-Reply-To: <20150724201825.27602.85101.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 24, 2015 at 01:18:25PM -0700, Tadeusz Struk wrote:
> From: Bruce Allan <bruce.w.allan@intel.com>
> 
> The element pci_dev_id in the struct adf_hw_device_data is redundant since
> the PCI device id can be retrieved from the struct pci_dev.
> 
> Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
