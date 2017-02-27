From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 2/4] ARM64: dts: meson-gx: add clock to DT binding
 documentation for hwrng
Date: Mon, 27 Feb 2017 16:34:49 -0600
Message-ID: <20170227223449.f24ppbk3wx4gguc4@rob-hp-laptop>
References: <4e2d12e5-f75b-3ac6-a3f7-18e8a8b7283b@gmail.com>
 <86db7397-8355-0d07-5180-c78d6cd06c84@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jerome Brunet <jbrunet@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, linux-crypto@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Michael Turquette <mturquette@baylibre.com>,
        linux-clk@vger.kernel.org, devicetree@vger.kernel.org
To: Heiner Kallweit <hkallweit1@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:35969 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751465AbdB0Wfk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Feb 2017 17:35:40 -0500
Content-Disposition: inline
In-Reply-To: <86db7397-8355-0d07-5180-c78d6cd06c84@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 22, 2017 at 07:59:08AM +0100, Heiner Kallweit wrote:
> Add clock to DT binding documentation.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
> v2:
> - splitted first version of patch into two
> - add DT binding documentation
> - mention that clock is optional
> - replace spaces with tabs in DT binding example
> v3:
> - splitted DT extension and binding documentation update into two patches
> ---
>  Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)

Now the subject should really be: "dt-bindings: rng: ..."

Acked-by: Rob Herring <robh@kernel.org>
