From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH] crypto: caam: add support for iMX6UL
Date: Sat, 8 Oct 2016 20:29:20 -0500
Message-ID: <20161009012920.GT18158@rob-hp-laptop>
References: <20161004133259.GA30071@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        mark.rutland@arm.com, horia.geanta@nxp.com,
        tudor-dan.ambarus@nxp.com, alexandru.porosanu@nxp.com,
        arnd@arndb.de, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161004133259.GA30071@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 04, 2016 at 09:32:59AM -0400, Marcus Folkesson wrote:
> i.MX6UL does only require three clocks to enable CAAM module.
> 
> Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
> ---
>  .../devicetree/bindings/crypto/fsl-sec4.txt        | 20 +++++++++++++

Acked-by: Rob Herring <robh@kernel.org>

>  drivers/crypto/caam/ctrl.c                         | 35 ++++++++++++----------
>  2 files changed, 40 insertions(+), 15 deletions(-)
