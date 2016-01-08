From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: ahash alg that does not implement import/export failed to
 register
Date: Fri, 8 Jan 2016 18:54:54 +0900
Message-ID: <20160108095454.GB3472@gondor.apana.org.au>
References: <1450488694.30844.11.camel@schen9-desk2.jf.intel.com>
 <20151219023308.GA27731@gondor.apana.org.au>
 <568E7AFB.8080905@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	"megha.dey" <megha.dey@intel.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <568E7AFB.8080905@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jan 07, 2016 at 08:49:31AM -0600, Tom Lendacky wrote:
> 
> Is it expected that import and export should work across algorithm
> implementations (eg. export sha1 state from hardware driver and import
> into sha1-generic algorithm)?  Or is the state purely meant for use by
> the driver only? I see a few hardware drivers exporting/importing
> to/from sha1_state and sha256_state and that is what prompts this
> question.

For algorithms in general there is no requirement for the states
to be exported in a particular format.  For certain special cases
such as crc32c we do require a specific format but you don't have
to worry about this for SHA.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
