From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/2] HWRNG/PCI: Add driver for Cavium Thunder RNG
Date: Wed, 31 Aug 2016 23:17:45 +0800
Message-ID: <20160831151745.GA28366@gondor.apana.org.au>
References: <1471994835-2423-1-git-send-email-okhaliq@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bhelgaas@google.com, mpm@selenic.com, Ananth.Jasty@cavium.com,
        David.Daney@cavium.com, clabbe.montjoie@gmail.com
To: Omer Khaliq <okhaliq@caviumnetworks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1471994835-2423-1-git-send-email-okhaliq@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 23, 2016 at 04:27:13PM -0700, Omer Khaliq wrote:
> There is a hardware error rendering the FDL field incorrect for the some
> Thunder RNG devices. The first patch adds a PCI quirk to fix the problem.
> 
> The second patch adds the driver.
> 
> Changes from v1:
> 	Use PCI quirks as advised.
> 	Removed unecessary headers
> 	Format changes as advised

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
