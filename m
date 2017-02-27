From: Neil Armstrong <narmstrong@baylibre.com>
Subject: Re: [PATCH v3 1/3] clk: meson-gxbb: expose clock CLKID_RNG0
Date: Mon, 27 Feb 2017 05:28:49 -0800
Message-ID: <80bc00c9-dc3b-5aeb-89a0-8b427dca9b34@baylibre.com>
References: <4e2d12e5-f75b-3ac6-a3f7-18e8a8b7283b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-clk@vger.kernel.org, devicetree@vger.kernel.org
To: Heiner Kallweit <hkallweit1@gmail.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-amlogic@lists.infradead.org, linux-crypto@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Michael Turquette <mturquette@baylibre.com>
Return-path: <linux-clk-owner@vger.kernel.org>
In-Reply-To: <4e2d12e5-f75b-3ac6-a3f7-18e8a8b7283b@gmail.com>
Sender: linux-clk-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 02/21/2017 10:55 PM, Heiner Kallweit wrote:
> Expose clock CLKID_RNG0 which is needed for the HW random number generator.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
> v2:
> - added clk and DT maintainers
> - split exposing the clock and using it in DT into two patches
> - comment out clock definition in drivers/clk/meson/gxbb.h
> - silently move CLKID_SPI to the right place
> v3:
> - no changes
> ---
>  drivers/clk/meson/gxbb.h              | 2 +-
>  include/dt-bindings/clock/gxbb-clkc.h | 3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 


Hi Heiner,

This looks all good to me, but you should always send a cover letter for each revisions
of the patchset.

Using "git send-email" along the "--cover-letter" of "get format-patch" feature would
also help send them in a row with a up-to-date cover letter.

For the third patch, it may be good to also add the same to the GXL dtsi, no ?

Anyway :

Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>

Thanks,
Neil

