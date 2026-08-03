Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E352224DCF6
	for <linux-crypto@vger.kernel.org>; Mon,  3 Aug 2026 10:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785753742; cv=none; b=nf03xf5mhXq1XbVCHmfIKx4ouS/59NzngMiAglailJ301ptNNYm/8yIlSCJ2rdSUhTGukYEMYpJg7P6ldSI9ATxy1csJujVseRjyQmrcqIIpwE3EvZsEVjCdqnlcGnpVQ+D/PKVTImsA2RPl9zhf658rP7OfRF1e+gBOxL4HOso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785753742; c=relaxed/simple;
	bh=9D6+wqYGg3/Rdwv9smeYyF3ZR/oJkgpSiRAswQUP9GY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=OOqFG/9fzNntpq5E/PDgaWS42hc/LHvZ9Q2qrsnDMLtFMV9mWAy5EBFQIG3EBz9PKkV/gZTeXU0PnsUWPzyJkLiUmMrfGkt2hgixflF1lxsxX53IV+ddqdmkVBi6Ca8xkbJb6ymEu0s0dOmQ3wpHfTOw4tKfRHZDEsLfc2zO9rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com; spf=pass smtp.mailfrom=cknow-tech.com; dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b=DhBe9UeP; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b="DhBe9UeP"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow-tech.com;
	s=key1; t=1785753736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wwlzButQDahdza/3psqiQtfp5jZXmbl6TSSYvMERie4=;
	b=DhBe9UeP1kX4pV506IlEHsn79/+kVoi1zqBb/gNyKjASHhHDWyS1lp98qDb3P+pT8oWYPs
	1kZSRv6ExoxV0AFR6fxiXJPaGx2SaYcj0D2T+58aQoz/+BhBes5hEl0eJJ0rBK4DKkcy6a
	fIa2P+AJghDkozR0bybV3caVYJe++rJUkm2FLmhQBZofLoBSMG+NVZR0Ezg2/8eiVl2yNj
	IQkIjEhujkFKB6V3GsNS1x43LhgbIW/0BpJpcTBZ5Gjer6uzrcEEyIVv9r5LDqNXgKOHfF
	DsYqfcCFwU5ItfTJIfCGsR8NllCHlaNbrK1WrKGpxVbWa3jnk7b8Vpn7csq4Gw==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 03 Aug 2026 12:42:03 +0200
Message-Id: <DKF8V3IHKTL2.1PUA8O5IVIRYC@cknow-tech.com>
Cc: "Conor Dooley" <conor+dt@kernel.org>, "Heiko Stuebner"
 <heiko@sntech.de>, "Corentin Labbe" <clabbe@baylibre.com>,
 <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>,
 <linux-rockchip@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] crypto: rockchip: Add RK356x/RK3588
 cryptographic offloader
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Diederik de Haas" <diederik@cknow-tech.com>
To: "Dawid Olesinski" <dawidro@gmail.com>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
 "Rob Herring" <robh@kernel.org>, "Krzysztof Kozlowski"
 <krzk+dt@kernel.org>, "Eric Biggers" <ebiggers@kernel.org>
References: <20260708175837.1718437-1-dawidro@gmail.com>
In-Reply-To: <20260708175837.1718437-1-dawidro@gmail.com>
X-Migadu-Flow: FLOW_OUT

Hi Dawid,

On Wed Jul 8, 2026 at 7:58 PM CEST, Dawid Olesinski wrote:
> This series adds support for the second-generation (V2) Rockchip
> cryptographic hardware accelerator found on RK3568 and RK3588 SoCs.
>
> The IP block provides AES (ECB, CBC, XTS) and hash (SHA-1, SHA-256,
> SHA-384, SHA-512, MD5, SM3) offload via an LLI-based DMA engine.

I build a 7.2-rc4 kernel (7.2-rc4-arm64-cknow) with CRYPTO_SELFTESTS_FULL
and CRYPTO_BENCHMARK enabled (as module), but without this patch set.
I also build another 7.2-rc4 kernel (7.2-rc4+unreleased-arm64-cknow) on
top of that, but then with this patch set.=20
But I removed the ``status =3D disabled`` line so it would be enabled.

I had not (ie forgot to) enable the CRYPTO_SM4_GENERIC module, so no
test wrt that, which IIUC should also be accelerated.

I added ``tcrypt.dyndbg`` to my cmdline.

I made the following test script/procedure:
```
root@sbc:~# uname -a
root@sbc:~# cat /proc/cmdline
root@sbc:~# cat /proc/crypto | grep -A5 "rk2" | grep -E "driver|selftest"
root@sbc:~# dmesg | grep -E "rk2|crypto|rk3[56]"
root@sbc:~# cat /sys/kernel/debug/fe3?0000.crypto/stats
root@sbc:~# cat /sys/kernel/debug/fe3?0000.crypto/info
root@sbc:~#
root@sbc:~# modprobe tcrypt mode=3D0
root@sbc:~# modprobe tcrypt mode=3D200
root@sbc:~# modprobe tcrypt mode=3D201
root@sbc:~# modprobe tcrypt mode=3D204
root@sbc:~# modprobe tcrypt mode=3D200 sec=3D1
root@sbc:~# modprobe tcrypt mode=3D201 sec=3D1
root@sbc:~# modprobe tcrypt mode=3D204 sec=3D1
root@sbc:~# for test_mode in {302..306} 313 {322..326}; do modprobe tcrypt =
mode=3D${test_mode}; sleep 3; done
root@sbc:~# for test_mode in {402..406} 413 {418..422}; do modprobe tcrypt =
mode=3D${test_mode}; sleep 3; done
root@sbc:~# for test_mode in {500..502}; do modprobe tcrypt mode=3D${test_m=
ode}; sleep 3; done
root@sbc:~# cryptsetup benchmark
root@sbc:~# dmesg | grep -E "rk2|crypto|rk3[56]"
root@sbc:~# dmesg | grep -E "failed"
root@sbc:~#
```

And then went on to test first without and then with your patch set on:
- Quartz64-B    (RK3566)
- NanoPi R5S    (RK3568)
- NanoPC-T6 LTS (RK3588)

crypto-rk3566-test-no-crypto-module-log.txt:
https://paste.sr.ht/~diederik/bb5dbfd59f244a6422b965b30f9796ebbfdb1fcb
crypto-rk3566-test-with-crypto-module-log.txt:
https://paste.sr.ht/~diederik/ea72297678e19cbbc987de9548f9884382e1d1cc
crypto-rk3568-test-no-crypto-module-log.txt:
https://paste.sr.ht/~diederik/309e519e6b1c31f4c1c5bcb1ea16cc8569a54830
crypto-rk3568-test-with-crypto-module-log.txt:
https://paste.sr.ht/~diederik/1e1e938ebbbae75128974fe0a7c240843bce04c8
crypto-rk3588-test-no-crypto-module-log.txt:
https://paste.sr.ht/~diederik/9a2adc2b2e42131445ce4576589e00ecf51ccb4b
crypto-rk3588-test-with-crypto-module-log.txt:
https://paste.sr.ht/~diederik/e04c11c8809031ca45662f7d4c227c1ba6162b65

I can confirm that all crypto test succeeded on all SoCs/SBCs.

I may have tested 'useless' things as I only saw a real change with
``for test_mode in {402..406} 413 {418..422}; do modprobe tcrypt mode=3D${t=
est_mode}; sleep 3; done``
The rest appears to me all within margins of error (so to speak).
Then again, I don't actually understand the numbers, so it's likely
useful to take a look at the numbers yourself in the above links.

The SHA256 test f.e. has much higher ``cycles/operation`` values.
I interpret that as an improvement as those numbers were also much higher
on my AMD Ryzen 7 5800X.

But on f.e. ``cryptsetup benchmark`` I didn't see a relevant change.
Idem on tests involving ECB, CBC, XTS. But maybe I did sth wrong?

There was another thing that caught my eye wrt RK3568 vs RK3588:

```
root@nanopi-r5s:~# cat /sys/kernel/debug/fe3?0000.crypto/info
CRYPTO_CLK_CTL 1
CRYPTO_RST_CTL 0
CRYPTO_AES_VERSION 0
CRYPTO_DES_VERSION 0
CRYPTO_SM4_VERSION 0
CRYPTO_HASH_VERSION 0
CRYPTO_HMAC_VERSION 0
CRYPTO_RNG_VERSION 0
CRYPTO_PKA_VERSION 0
CRYPTO_CRYPTO_VERSION 1010010
```

```
root@nanopc-t6-lts:~# cat /sys/kernel/debug/fe3?0000.crypto/info
CRYPTO_CLK_CTL 1
CRYPTO_RST_CTL 0
CRYPTO_AES_VERSION 707ff
AES 192
CRYPTO_DES_VERSION 30033
CRYPTO_SM4_VERSION 7ff
CRYPTO_HASH_VERSION 1ff
CRYPTO_HMAC_VERSION 1f
CRYPTO_RNG_VERSION 1000000
CRYPTO_PKA_VERSION 1000000
CRYPTO_CRYPTO_VERSION 2000001
```

Maybe there are more improvements possible, but I surely tested your patch
set ;-) and at least various SHA* procedures seem significantly faster :-)
So feel free to add my

Tested-by: Diederik de Haas <diederik@cknow-tech.com>  # Quartz64-B, NanoPi=
 R5S, NanoPC-T6 LTS


Cheers,
  Diederik

> The series is ordered as required: binding first, then driver, then
> the two DTS nodes that reference the binding.
>
> A prerequisite patch removing SECURECRU reset definitions from the
> non-secure CRU driver is sent separately to the clk/reset tree, as it
> touches a different subsystem. That patch is not a hard dependency for
> the driver to build or load, but it is needed for correctness on RK3588:
> those register offsets map into TrustZone-protected MMIO and must not be
> accessed directly by Linux.
>
> This work started from unmerged patches by Corentin Labbe
> <clabbe@baylibre.com> posted at:
> https://patchew.org/linux/20231107155532.3747113-1-clabbe@baylibre.com/
>
> The implementation has been substantially reworked. Notable changes from
> Corentin's original series:
>   - DMA descriptor race condition and DMA mapping leak on timeout fixed
>   - Per-device algorithm copy replaces global device list, removing a
>     locking bottleneck and correctly supporting multiple instances
>   - Runtime PM autosuspend added; clocks and reset gated between requests
>   - Multi-SG hash requests routed to software fallback (hardware padding
>     engine requires total message length upfront and cannot maintain
>     state across LLI boundaries)
>   - Hardware interrupt enable register write corrected to use the
>     HIWORD_UPDATE mask that the hardware requires
>   - Software fallback for all registered algorithms; statesize promotion
>     for export/import compatibility with ARM Crypto Extensions drivers
>   - SCMI reset and clock references in DTS corrected for RK3588
>
> Tested on Orange Pi 5 Pro (RK3588S). All nine algorithm selftests pass.
> AES-CBC throughput measured at ~100 MiB/s with cryptsetup. PM
> autosuspend/resume verified over 1000 consecutive hash requests with no
> errors. 20 modprobe/rmmod cycles produce no DMA coherent memory leaks.
>
> Patch series for the crypto subsystem:
>   [1/4] dt-bindings: crypto: rockchip: Add RK356x/RK3588 crypto engine
>   binding
>   [2/4] crypto: rockchip: Add RK356x/RK3588 cryptographic offloader drive=
r
>   [3/4] arm64: dts: rockchip: Add crypto node to rk356x-base
>   [4/4] arm64: dts: rockchip: Add crypto node to rk3588-base
>
> Separate patch for clk/reset tree:
>   clk: rockchip: rk3588: Remove SECURECRU reset definitions
>
> Changes in v2:
>  - dt-bindings: wrap example in a bus node with #address/#size-cells =3D =
2
>    and add the SCMI clock/reset dt-binding includes so dt_binding_check
>    passes (Rob Herring / Krzysztof Kozlowski review).
>  - crypto: fix Kconfig to select CRYPTO_SM3 instead of the non-existent
>    CRYPTO_SM3_GENERIC.
>  - crypto: drop IRQF_SHARED (the line is dedicated) and request the IRQ
>    only after clocks are enabled and the completion is initialised;
>    reorder probe accordingly.
>  - crypto: set a 32-bit DMA mask before allocating the descriptor table.
>  - crypto: suspend the device explicitly on removal before disabling
>    runtime PM to avoid leaking clocks.
>  - crypto: call synchronize_irq() on the DMA timeout paths to close a
>    race with delayed interrupts.
>  - crypto: convert fallback statistics to atomic_long_t.
>  - crypto: use cpu_to_le32() for all LLI descriptor fields (big-endian
>    correctness).
>  - crypto: read key/IV with get_unaligned_be32() to fix an alignment
>    fault and a big-endian double-swap.
>  - crypto: fix the CBC/XTS IV backup offset to use the processed length
>    instead of the scatterlist capacity.
>  - arm64: dts: rk356x: move the crypto node into unit-address order.
>
> v1: https://patchwork.kernel.org/project/devicetree/cover/20260530160704.=
3453555-1-dawidro@gmail.com/
>
> Build/rebase fixes (not from review):
>  - crypto: use sizeof(struct sm3_ctx) for the SM3 statesize, as
>    struct sm3_state was removed by the lib/crypto SM3 conversion.
>  - crypto: add the missing SHA-224 zero-message case.
>
> Dawid Olesinski (4):
>   dt-bindings: crypto: rockchip: Add RK356x/RK3588 crypto engine binding
>   crypto: rockchip: Add RK356x/RK3588 cryptographic offloader driver
>   arm64: dts: rockchip: Add crypto node to rk356x-base
>   arm64: dts: rockchip: Add crypto node to rk3588-base
>
>  .../crypto/rockchip,rk3588-crypto.yaml        |  75 ++
>  arch/arm64/boot/dts/rockchip/rk356x-base.dtsi |  12 +
>  arch/arm64/boot/dts/rockchip/rk3588-base.dtsi |  12 +
>  drivers/crypto/Kconfig                        |  32 +
>  drivers/crypto/Makefile                       |   1 +
>  drivers/crypto/rockchip/Makefile              |   5 +
>  drivers/crypto/rockchip/rk2_crypto.c          | 746 ++++++++++++++++++
>  drivers/crypto/rockchip/rk2_crypto.h          | 249 ++++++
>  drivers/crypto/rockchip/rk2_crypto_ahash.c    | 565 +++++++++++++
>  drivers/crypto/rockchip/rk2_crypto_skcipher.c | 728 +++++++++++++++++
>  10 files changed, 2425 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3=
588-crypto.yaml
>  create mode 100644 drivers/crypto/rockchip/rk2_crypto.c
>  create mode 100644 drivers/crypto/rockchip/rk2_crypto.h
>  create mode 100644 drivers/crypto/rockchip/rk2_crypto_ahash.c
>  create mode 100644 drivers/crypto/rockchip/rk2_crypto_skcipher.c

