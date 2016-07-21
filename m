From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] crypto: x86/glue_helper make bool
Date: Fri, 22 Jul 2016 01:06:07 +0200
Message-ID: <20160721230607.GA5537@wotan.suse.de>
References: <1469139180-26863-1-git-send-email-mcgrof@kernel.org>
 <20160721230111.GI21225@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	herbert@gondor.apana.org.au, davem@davemloft.net, lkp@01.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160721230111.GI21225@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 21, 2016 at 07:01:11PM -0400, Paul Gortmaker wrote:
> [[PATCH] crypto: x86/glue_helper make bool] On 21/07/2016 (Thu 15:13) Luis R. Rodriguez wrote:
> 
> > Paul's changes to remove MODULE_LICENSE() out of the x86 glue_helper
> > causes a kernel with CONFIG_CRYPTO_GLUE_HELPER_X86=m to taint since
> > it now detects the license is missing if you try to build the driver
> > as a module, log below.
> 
> Reported and fixed two days ago ; the fix went out in yesterday's
> linux-next via the tip tree.
> 
> https://lkml.kernel.org/r/20160719144243.GK21225@windriver.com
> 
> I fixed it by restoring the license, since making it bool might break
> existing use cases,

How so?

  Luis
