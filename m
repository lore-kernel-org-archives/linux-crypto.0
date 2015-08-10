From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/5] crypto: qat - Add support for SRIOV
Date: Mon, 10 Aug 2015 23:41:47 +0800
Message-ID: <20150810154147.GD21143@gondor.apana.org.au>
References: <20150807183414.630.25889.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, bhelgaas@google.com,
	linux-pci@vger.kernel.org, qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150807183414.630.25889.stgit@tstruk-mobl1>
Sender: linux-pci-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Aug 07, 2015 at 11:34:14AM -0700, Tadeusz Struk wrote:
> The following series adds SRIOV support for qat dh895xcc HW accelerator.
> First patch moves admin code and hw arbiter code that can be reused by PF
> and VF to common code in qat/qat_common/
> Second patch enables SRIOV support on dh895xcc PF.
> Third patch adds dh895xcc VF specific code.
> Fourth patch adds FW const table initialization,
> which may be required by VFs.
> Fifth patch adds pci quirk for a HW issue on VF.

All applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
