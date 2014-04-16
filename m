From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V2] crypto: omap-des - handle error of pm_runtime_get_sync
Date: Wed, 16 Apr 2014 21:50:40 +0800
Message-ID: <20140416135039.GJ4684@gondor.apana.org.au>
References: <534D61DF.9090203@ti.com>
 <1397581111-21148-1-git-send-email-nm@ti.com>
 <CAGhQ9Vxv682wD982sNDtc5-Zk4y7H2eULWcm8CJ2SiG=s7V=Pg@mail.gmail.com>
 <534D69D0.207@ti.com>
 <534D71AF.2090808@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nishanth Menon <nm@ti.com>, Joachim Eastwood <manabian@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-omap@vger.kernel.org, balbi@ti.com
To: Joel Fernandes <joelf@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <534D71AF.2090808@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Apr 15, 2014 at 12:51:43PM -0500, Joel Fernandes wrote:
> On 04/15/2014 12:18 PM, Nishanth Menon wrote:
> > On 04/15/2014 12:06 PM, Joachim Eastwood wrote:
> >> On 15 April 2014 18:58, Nishanth Menon <nm@ti.com> wrote:
> >>> pm_runtime_get_sync may not always succeed depending on SoC involved.
> >>> So handle the error appropriately ensuring usage_count is accurate in
> >>> case of failure.
> >>>
> >>> Signed-off-by: Nishanth Menon <nm@ti.com>
> >>> ---
> >>> V2:
> >>>         - review fixes, print function names in error log as well.
> >>>
> >>> V1: https://patchwork.kernel.org/patch/3993861/
> >>>  drivers/crypto/omap-des.c |   26 +++++++++++++++++++++++---
> >>>  1 file changed, 23 insertions(+), 3 deletions(-)
> >>>
> >>
> >> Fixes the runtime warning from omap_l3_noc when omap-des is built-in
> >> on my VAR-SOM-OM44 (OMAP4460) board.
> >>
> >> Tested-by: Joachim Eastwood <manabian@gmail.com>
> > 
> > Thanks Joachim. Looks like in my hurry, I missed proper
> > acknowledgement of your report. adding the following for patchworks to
> > pickup.
> > 
> > Reported-by: Joachim Eastwood <manabian@gmail.com>
> > 
> 
> Acked-by: Joel Fernandes <joelf@ti.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
