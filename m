From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/2] Keystone2 HW random generator
Date: Sat, 24 Mar 2018 00:02:05 +0800
Message-ID: <20180323160205.GD2186@gondor.apana.org.au>
References: <1520962411-18208-1-git-send-email-vitalya@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, t-kristo@ti.com, m-karicheri2@ti.com
To: Vitaly Andrianov <vitalya@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1520962411-18208-1-git-send-email-vitalya@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Mar 13, 2018 at 01:33:29PM -0400, Vitaly Andrianov wrote:
> Keyston2 Security Accelerator has a hardware random generator sub-module.
> This series adds the driver for the sub-module.
> 
> Changes in v2:
> - Changed subject prefix in 1/2 patch
> - renamed dts node 
> 
> Vitaly Andrianov (2):
>   dt-bindings: rng: add bindings doc for Keystone SA HWRNG driver
>   hw_random: keystone2: add hw_random driver
> 
>  .../devicetree/bindings/rng/ks-sa-rng.txt          |  21 ++
>  drivers/char/hw_random/Kconfig                     |   7 +
>  drivers/char/hw_random/Makefile                    |   1 +
>  drivers/char/hw_random/ks-sa-rng.c                 | 257 +++++++++++++++++++++
>  4 files changed, 286 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/ks-sa-rng.txt
>  create mode 100644 drivers/char/hw_random/ks-sa-rng.c

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
