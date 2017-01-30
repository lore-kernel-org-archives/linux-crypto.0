From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v3 0/3] Add Broadcom SPU Crypto Driver
Date: Mon, 30 Jan 2017 15:35:54 -0800
Message-ID: <6fe4cad2-6fc9-bd69-f5ad-67957335fe55@gmail.com>
References: <1485362689-11294-1-git-send-email-rob.rice@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rob Rice <rob.rice@broadcom.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon
 <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1485362689-11294-1-git-send-email-rob.rice@broadcom.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On 01/25/2017 08:44 AM, Rob Rice wrote:
> Changes in v3:
> - rebase to 4.10-rc3 in cryptodev-2.6 tree
> - in bindings doc, list all valid compatibility strings
> - rename DT nodes "crypto" rather than "spu-crypto"
> - include a separate DT node for each SPU hardware block. Previously,
>  there was a single SPU node listing a register range for each
>  hw block.
> - select hash algos in Kconfig. Driver HMAC implementation uses hash
>  sw algos for inner and outer hashes.
> - Fix crash for AES CCM decrypt when AAD and data are both empty
> 
> Change in v2:
> - select CRYPTO_DES in Kconfig
> 
> The Broadcom SPU crypto driver provides access to SPU hardware
> for symmetric crypto offload. The driver supports ablkcipher,
> ahash, and aead operations. The driver supports several
> Broadcom SoCs with different revisions of the SPU hardware.
> The driver supports SPU-M and SPU2 hardware revisions, and
> a couple versions of each hw revision, each version with minor
> differences.

Herbert, can you take patches 1-2, and I will take patch 3 through my
arm64-soc git pull requests? Thanks!!

> 
> Rob Rice (3):
>   crypto: brcm: DT documentation for Broadcom SPU hardware
>   crypto: brcm: Add Broadcom SPU driver
>   arm64: dts: ns2: Add Broadcom SPU driver DT entry.
> 
>  .../devicetree/bindings/crypto/brcm,spu-crypto.txt |   22 +
>  arch/arm64/boot/dts/broadcom/ns2.dtsi              |   24 +
>  drivers/crypto/Kconfig                             |   15 +
>  drivers/crypto/Makefile                            |    2 +
>  drivers/crypto/bcm/Makefile                        |   15 +
>  drivers/crypto/bcm/cipher.c                        | 4955 ++++++++++++++++++++
>  drivers/crypto/bcm/cipher.h                        |  475 ++
>  drivers/crypto/bcm/spu.c                           | 1252 +++++
>  drivers/crypto/bcm/spu.h                           |  288 ++
>  drivers/crypto/bcm/spu2.c                          | 1402 ++++++
>  drivers/crypto/bcm/spu2.h                          |  228 +
>  drivers/crypto/bcm/spum.h                          |  174 +
>  drivers/crypto/bcm/util.c                          |  581 +++
>  drivers/crypto/bcm/util.h                          |  116 +
>  14 files changed, 9549 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt
>  create mode 100644 drivers/crypto/bcm/Makefile
>  create mode 100644 drivers/crypto/bcm/cipher.c
>  create mode 100644 drivers/crypto/bcm/cipher.h
>  create mode 100644 drivers/crypto/bcm/spu.c
>  create mode 100644 drivers/crypto/bcm/spu.h
>  create mode 100644 drivers/crypto/bcm/spu2.c
>  create mode 100644 drivers/crypto/bcm/spu2.h
>  create mode 100644 drivers/crypto/bcm/spum.h
>  create mode 100644 drivers/crypto/bcm/util.c
>  create mode 100644 drivers/crypto/bcm/util.h
> 


-- 
Florian
