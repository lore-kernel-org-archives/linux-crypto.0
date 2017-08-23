From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v2] dt/bindings: exynos-rng: Move dt binding
 documentation to bindings/crypto
Date: Wed, 23 Aug 2017 18:12:04 +0200
Message-ID: <20170823161204.5cleer2rpgjd5vmz@kozik-lap>
References: <20170823150443.8399-1-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: mchehab@kernel.org, kgene@kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35819 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932251AbdHWQMJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Aug 2017 12:12:09 -0400
Content-Disposition: inline
In-Reply-To: <20170823150443.8399-1-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 23, 2017 at 08:34:43PM +0530, PrasannaKumar Muralidharan wrote:
> Samsung exynos PRNG driver is using crypto framework instead of
> hw_random framework. So move the devicetree binding to crypto folder.
> 
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
> ---
> Changes in v2:
> * Modify MAINTAINERS file to reflect file rename
> 
>  .../devicetree/bindings/{rng => crypto}/samsung,exynos-rng4.txt         | 0
>  MAINTAINERS                                                             | 2 +-
>  2 files changed, 1 insertion(+), 1 deletion(-)
>  rename Documentation/devicetree/bindings/{rng => crypto}/samsung,exynos-rng4.txt (100%)
> 

Patch is okay but CC list is still incomplete. I do not know how you
could get Mauro for this patch... just use get_maintainers.pl.

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
