From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v2 01/11] crypto: Documentation - crypto API high level
 spec
Date: Sat, 8 Nov 2014 21:54:20 -0500
Message-ID: <20141109025420.GN3698@titan.lakedaemon.net>
References: <6375771.bx7QqLJLuR@tachyon.chronox.de>
 <4163724.RCMDlx8dmE@tachyon.chronox.de>
 <20141103083439.635f5cb6@lwn.net>
 <4303532.NGaUQ44sQJ@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jonathan Corbet <corbet@lwn.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Marek Vasut <marex@denx.de>,
	Grant Likely <grant.likely@secretlab.ca>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4303532.NGaUQ44sQJ@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Stephan,

On Mon, Nov 03, 2014 at 03:18:29PM +0100, Stephan Mueller wrote:
> Am Montag, 3. November 2014, 08:34:39 schrieb Jonathan Corbet:
> > These are all useful.  But I wonder if it would be worth the effort to turn
> > this inti a proper docbook document that automatically has everything
> > together in one place?
> 
> How do you suggest that is done? The API comments in the header file follow 
> the Doxygen style. Note, Jason Cooper raised the concern that an API 
> documentation separate from the code will surely deviate from the code 
> relatively fast (although I do not really fear that as the kernel crypto API 
> seems to be quite stable over the last years).

Agreed.  My primary concern was adding it in such a way which
facilitates maintenance and keeping it in sync with the code.  But as
you say, the crypto API doesn't change much.

thx,

Jason.
