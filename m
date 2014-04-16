From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/ccp: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Date: Wed, 16 Apr 2014 21:50:12 +0800
Message-ID: <20140416135011.GH4684@gondor.apana.org.au>
References: <1397548471-24441-1-git-send-email-agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1397548471-24441-1-git-send-email-agordeev@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Apr 15, 2014 at 09:54:31AM +0200, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-pci@vger.kernel.org

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
