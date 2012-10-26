From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: Re: [PATCH v2 5/7] crypto: omap-sham: Convert to use pm_runtime API
Date: Fri, 26 Oct 2012 10:10:09 -0700
Message-ID: <20121026171009.GA23528@animalcreek.com>
References: <1351046167-4882-1-git-send-email-mgreer@animalcreek.com>
 <1351046167-4882-6-git-send-email-mgreer@animalcreek.com>
 <87lieunkat.fsf@deeprootsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, dmitry.kasatkin@intel.com,
	rmk+kernel@arm.linux.org.uk, paul@pwsan.com
To: Kevin Hilman <khilman@deeprootsystems.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail20.dotsterhost.com ([66.11.232.73]:34215 "EHLO
	mail20.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab2JZRKM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Oct 2012 13:10:12 -0400
Content-Disposition: inline
In-Reply-To: <87lieunkat.fsf@deeprootsystems.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 25, 2012 at 05:34:02PM -0700, Kevin Hilman wrote:
> Hi Mark,

Hi Kevin.

> "Mark A. Greer" <mgreer@animalcreek.com> writes:
> 
> > From: "Mark A. Greer" <mgreer@animalcreek.com>
> >
> > Convert the omap-sham crypto driver to use the
> > pm_runtime API instead of the clk API.
> >
> > CC: Kevin Hilman <khilman@deeprootsystems.com>
> > CC: Paul Walmsley <paul@pwsan.com>
> > CC: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> > Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
> 
> I can't pretend to fully understand this driver, It looks like the
> current code is doing a bit more fine-grained clock gating, and leaving
> the IP clocked only when needed.
> 
> The proposed version does a 'get' in probe and a 'put' in remove, which
> means the IP will always be enabled (and thus preventing low-power
> states), even when it's not in use.

You're right, and what I did is wrong.  I'll fix this in the next revision.

Thanks,

Mark
--
