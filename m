From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: Re: [PATCH v2 2/2] rng: pic32-rng: Add PIC32 RNG hardware driver
Date: Mon, 8 Feb 2016 21:34:07 +0000
Message-ID: <20160208213407.GA9389@wychelm.lan>
References: <1454966283-14965-1-git-send-email-joshua.henderson@microchip.com>
 <1454966283-14965-2-git-send-email-joshua.henderson@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	Purna Chandra Mandal <purna.mandal@microchip.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kieran Bingham <kieranbingham@gmail.com>,
	Lee Jones <lee.jones@linaro.org>,
	Pankaj Dev <pankaj.dev@st.com>,
	Scott Branden <sbranden@broadcom.com>,
	Ray Jui <rjui@broadcom.com>, linux-crypto@vger.kernel.org
To: Joshua Henderson <joshua.henderson@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:33947 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbcBHVeM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Feb 2016 16:34:12 -0500
Received: by mail-wm0-f46.google.com with SMTP id 128so172780060wmz.1
        for <linux-crypto@vger.kernel.org>; Mon, 08 Feb 2016 13:34:12 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1454966283-14965-2-git-send-email-joshua.henderson@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 08, 2016 at 02:17:53PM -0700, Joshua Henderson wrote:
> Add support for the hardware true random number generator
> peripheral found on PIC32.
> 
> Signed-off-by: Joshua Henderson <joshua.henderson@microchip.com>
> Signed-off-by: Purna Chandra Mandal <purna.mandal@microchip.com>

Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>

> ---
> Changes since v1:
> 	- Reorder includes to be alphabetic.
> 	- Drop use of PRNG and only use TRNG.

Excellent!



> 	- Fix dangling clock ref in error condition.
> 	- Remove unecessary error handling and fix other cases.


Daniel.
