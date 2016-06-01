From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 1/4] dt-bindings: rng: Northstar Plus SoC rng bindings
Date: Wed, 1 Jun 2016 09:47:03 -0500
Message-ID: <20160601144703.GA6948@rob-hp-laptop>
References: <1464343841-29504-1-git-send-email-yendapally.reddy@broadcom.com>
 <1464343841-29504-2-git-send-email-yendapally.reddy@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Lee Jones <lee@kernel.org>, Eric Anholt <eric@anholt.net>,
	Russell King <linux@arm.linux.org.uk>,
	Ray Jui <rjui@broadcom.com>,
	Scott Branden <sbranden@broadcom.com>,
	Jon Mason <jonmason@broadcom.com>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Kieran Bingham <kieranbingham@gmail.com>,
	Pankaj Dev <pankaj.dev@st.com>,
	Richard Weinberger <richard@nod.at>, noltari@gmail.com,
	Joshua Henderson <joshua.henderson@microchip.com>,
	devicetree@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	bcm-kernel-feedback-list@broadcom.com, linux-crypt
To: Yendapally Reddy Dhananjaya Reddy <yendapally.reddy@broadcom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34139 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbcFAOrF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Jun 2016 10:47:05 -0400
Content-Disposition: inline
In-Reply-To: <1464343841-29504-2-git-send-email-yendapally.reddy@broadcom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 27, 2016 at 06:10:38AM -0400, Yendapally Reddy Dhananjaya Reddy wrote:
> Document the bindings used by Northstar Plus(NSP) SoC random number
> generator.
> 
> Signed-off-by: Yendapally Reddy Dhananjaya Reddy <yendapally.reddy@broadcom.com>
> Acked-by: Eric Anholt <eric@anholt.net>

You missed my ack...

> ---
>  Documentation/devicetree/bindings/rng/brcm,bcm2835.txt | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
