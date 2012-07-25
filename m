From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: iproute2 - IPsec ESN support
Date: Wed, 25 Jul 2012 11:51:34 +0200
Message-ID: <20120725095134.GO1869@secunet.com>
References: <FD18E5D573A8AB48A365D4D78185DE992602BD@039-SN1MPN1-001.039d.mgd.msft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Stephen Hemminger <shemminger@vyatta.com>
To: Geanta Neag Horia Ioan-B05471 <B05471@freescale.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <FD18E5D573A8AB48A365D4D78185DE992602BD@039-SN1MPN1-001.039d.mgd.msft.net>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 25, 2012 at 06:14:52AM +0000, Geanta Neag Horia Ioan-B05471 wrote:
> Hello,
> 
> Is there any way to create an IPsec tunnel and indicate using
> extended sequnce numbers?

The strongswan ike deamon supports extended sequnce numbers.

> 
> It seems that currently iproute2 doesn't support this.
> Grepping for "esn" reveals that XFRM_STATE_ESN shows only in kernel headers.
> 
> The only relevant thing I found was a RFC sent by Steffen (Cc-ed),
> but it was never applied (don't know why):
> [RFC] iproute2: Add IPsec extended sequence number support

I'll take this as a reminder to respin this patch.
