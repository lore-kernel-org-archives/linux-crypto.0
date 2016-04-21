From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 2/2] crypto: s5p-sss - Remove useless hash interrupt
 handler
Date: Thu, 21 Apr 2016 10:24:56 -0500
Message-ID: <20160421152456.GA8087@rob-hp-laptop>
References: <1461073452-10426-1-git-send-email-k.kozlowski@samsung.com>
 <1461073452-10426-2-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Vladimir Zapolskiy <vz@mleia.com>, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461073452-10426-2-git-send-email-k.kozlowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Apr 19, 2016 at 03:44:12PM +0200, Krzysztof Kozlowski wrote:
> Beside regular feed control interrupt, the driver requires also hash
> interrupt for older SoCs (samsung,s5pv210-secss). However after
> requesting it, the interrupt handler isn't doing anything with it, not
> even clearing the hash interrupt bit.
> 
> Driver does not provide hash functions so it is safe to remove the hash
> interrupt related code and to not require the interrupt in Device Tree.

NAK for the DT change. If the h/w has a 2nd interrupt, then it should be 
defined. Whether the driver uses it or not is a driver problem.

Rob
