Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65A817BA3;
	Thu,  3 Jul 2025 05:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751521698; cv=none; b=mrj0Ec0G0yyUW6BEX+sUYTKXt070Pdns2/u6qOcy/JBMOjQgYE3GtqOasSCowBnJbz41Vdp4Tz7jpCtzgrC+fILGG0NtSOQirhJ/VEBayR1kmRGkfzHk4/ssvx+Bz38/16IXjzHtafQi+K99l3zydnx6So5P9A0PkJ34E6pQ5Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751521698; c=relaxed/simple;
	bh=s/0ASVxWkl+DUk9Fc9PcXkeV9l+ngQ6HsiuuvYu/+Ec=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ljT2Y1ipvaNwaA3gWaLW4/HgO3SKwWyEjOjKgwhggGJsj0iNNoPnvsWkRPp4t2mRHfm1S1dArMZgRL99Yf0VcI7162Gr4m15Y2Lp0mU8QIqKf8BkzuNXS6Mxqm1+BdD5p7tEmBQYZHRLF7kgroWtz1bccER0lSOMQtTw5K1dnwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N4qZs273; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N4qZs273"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ae0de1c378fso738821066b.3;
        Wed, 02 Jul 2025 22:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751521695; x=1752126495; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mVj3wbnpG5hZNCBW23hwPMbmFGflIAtjMdLxGwdCGg8=;
        b=N4qZs273SfHw+Nq1LCSa8wWWS7LdEp5/mkob1ot8E8BHVstj6ZRIjkbH4nUx/W+NoH
         C/otLcpWkHgbDPnbzKhCOIUVJvKVr0YZkG3IdB9vGUoXxgQFvd00NNwLwK8nKqyunSb+
         P1pN3M8KkVHVNOSBOYoIc45FstOL6BWeKtBT8UtYVeTmxnCx5MT2UwKMXhDDJD0R1skj
         N28IEIXkfgAsnd41SFNcklmIEZf8gZeBnkvywXrsmGV3hmSY+8/neuNN81Tb9SFMcHBJ
         i1G5AEVfXSW6OgnR9gVNriI0F04fp8IgB4FBwJkMSmSXQp3OLhNsYsptqTonfNHFslJK
         84UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751521695; x=1752126495;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mVj3wbnpG5hZNCBW23hwPMbmFGflIAtjMdLxGwdCGg8=;
        b=nVqlgk46Y0k/iVr35T8BabWxAF2deQFnc+Sh92fed0vEZHuqolKqfwBUCbIzpbblPl
         wKydSUeOprCq3o5J4/TG3P5XmMFaBh1kuGgh+xBWitmODlnesqBcX1MTwF58/nPmnkWf
         gjbfDspMkUlWyH0ylYPzSEbzEZbpHRGY0rffUR9UvU9iQrbcHqBPVG7RC0+czjpiH3Yp
         tbpscBjGfZEnoRdFTbVzASLckCCNiosR6R69kzAvCaSBKboy7+HYwuuhmf95ZajD7I1h
         5uJE2USZdJw3bkoADLh3cXU4e+wIT98dC5mLBhYTZ7a3gTCbrWxudNaFPA5Hlwxqu2zQ
         xA5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUdoGQQ2xwJqizCY5DUsA1aQ9YwMnbgodiPRkPAhvsipEJxA9knstBgiYRDzDrsgrNV/LJHGIS+VMq3@vger.kernel.org, AJvYcCVB/HVPqWo8yaFP5Ea2w5EEBvTtWehwbIxMHYMi3d40e5tmLcxr5u1C6CRwigRu6MMDE2y4O3Y9oMlpCpzY@vger.kernel.org, AJvYcCX8ivKK9bCkbOYY6sbnumK1PSWNCk0jbICZH1f8G26Rw4haN/iSsECuiH9uP9K6qUGKxSPkVfJwlQ3KmyyL@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb2aixJEP1EmPaCXw0Edkb+sG0OdFJhIre4mcLyJ/4fQhBkLIf
	V+9qhQ7s8/RTNh1DaTLSyoMvyE9zILj665yOzBuZW3flyfEOfQhTvsuN6JRgXdGug3t4WBzMIeG
	ik+M2APE7VFA7yHGHZfsQCBOHhrT3HDQ=
X-Gm-Gg: ASbGncuABNiDXch0y8lmzkNMGo3EX6MJ6xG4geva6RC/PoCmm/baVxhz5zWYLL8qabL
	+mIDbkTHCS1x0FP6oAdoMtbELxFHLwXIg8OPeNHirCjY30eqLk0ejVqMB37qzfNJbdujcMVdPDf
	onB0d9jxqS14EVquxclNDLdf7zYc0D8faltzyMlQuptsi5fWMw9KU=
X-Google-Smtp-Source: AGHT+IEHsVPE3MDluqiXrzyqwGMpX8WERAG/uuR5m6RypAsfJLS1wDinsd9LROKX8eiMRN45fBicLWwb1QGhfOCCjXw=
X-Received: by 2002:a17:907:94c1:b0:ae3:53b3:b67d with SMTP id
 a640c23a62f3a-ae3d83d9a6fmr176784666b.1.1751521694551; Wed, 02 Jul 2025
 22:48:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250624135214.1355051-1-romanov.alexey2000@gmail.com>
In-Reply-To: <20250624135214.1355051-1-romanov.alexey2000@gmail.com>
From: Anand Moon <linux.amoon@gmail.com>
Date: Thu, 3 Jul 2025 11:17:57 +0530
X-Gm-Features: Ac12FXyST0hXGZG3XMCb1p96mhr--D9oLQ205yN9d2sNvp8JX62uy4InGQKfyz4
Message-ID: <CANAwSgRcO9sq_+pYLTwpANi2fkVAxe_3RPtSvTuqmoNnUwtU=g@mail.gmail.com>
Subject: Re: [PATCH v12 00/22] Support more Amlogic SoC families in crypto driver
To: Alexey Romanov <romanov.alexey2000@gmail.com>
Cc: neil.armstrong@linaro.org, clabbe@baylibre.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, khilman@baylibre.com, 
	jbrunet@baylibre.com, martin.blumenstingl@googlemail.com, 
	linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Hi Alexey,

On Tue, 24 Jun 2025 at 20:29, Alexey Romanov
<romanov.alexey2000@gmail.com> wrote:
>
> Hello!
>
> This patchset expand the funcionality of the Amlogic
> crypto driver by adding support for more SoC families:
> AXG, G12A, G12B, SM1, A1, S4.
>
> Also specify and enable crypto node in device tree
> for reference Amlogic devices.
>
> Tested on GXL, AXG, G12A/B, SM1, A1 and S4 devices via
> custom tests [1] and tcrypt module.
>
Is it possible to enable this module on GXBB platforms
that use the older crypto architecture?

Crypto Engine
o AES block cipher with 128/192/256 bits keys, standard 16 bytes block
size and streaming ECB, CBC and CTR modes
o DES/TDES block cipher with ECB and CBC modes supporting 64 bits key
for DES and 192 bits key for 3DES
o Hardware key-ladder operation and DVB-CSA for transport stream encryption
o Built-in hardware True Random Number Generator (TRNG), CRC and
SHA-1/SHA-2 (SHA-224/SHA-256) engine

Thanks I have tested using the following command on G12B Odroid N2plus.

$ sudo modprobe tcrypt sec=1 mode=200
[   42.857936] tcrypt: testing speed of sync ecb(aes) (ecb-aes-ce) encryption
[   42.859184] tcrypt: test 0 (128 bit key, 16 byte blocks): 7019057
operations in 1 seconds (112304912 bytes)
[   43.861782] tcrypt: test 1 (128 bit key, 64 byte blocks): 6136472
operations in 1 seconds (392734208 bytes)
[   44.865778] tcrypt: test 2 (128 bit key, 128 byte blocks): 5506574
operations in 1 seconds (704841472 bytes)
[   45.869854] tcrypt: test 3 (128 bit key, 256 byte blocks): 4460371
operations in 1 seconds (1141854976 bytes)
[   46.873939] tcrypt: test 4 (128 bit key, 1024 byte blocks): 2014161
operations in 1 seconds (2062500864 bytes)
[   47.878034] tcrypt: test 5 (128 bit key, 1424 byte blocks): 1553828
operations in 1 seconds (2212651072 bytes)
[   48.882023] tcrypt: test 6 (128 bit key, 4096 byte blocks): 599874
operations in 1 seconds (2457083904 bytes)

Please add my

Tested-by: Anand Moon <linux.amoon@gmail.com>

Thanks
-Anand
> ---
>
> Changes V1 -> V2 [2]:
>
> - Rebased over linux-next.
> - Adjusted device tree bindings description.
> - A1 and S4 dts use their own compatible, which is a G12 fallback.
>
> Changes V2 -> V3 [3]:
>
> - Fix errors in dt-bindings and device tree.
> - Add new field in platform data, which determines
> whether clock controller should be used for crypto IP.
> - Place back MODULE_DEVICE_TABLE.
> - Correct commit messages.
>
> Changes V3 -> V4 [4]:
>
> - Update dt-bindings as per Krzysztof Kozlowski comments.
> - Fix bisection: get rid of compiler errors in some patches.
>
> Changes V4 -> V5 [5]:
>
> - Tested on GXL board:
>   1. Fix panic detected by Corentin Labbe [6].
>   2. Disable hasher backend for GXL: in its current realization
>      is doesn't work. And there are no examples or docs in the
>      vendor SDK.
> - Fix AES-CTR realization: legacy boards (gxl, g12, axg) requires
>   inversion of the keyiv at keys setup stage.
> - A1 now uses its own compatible string.
> - S4 uses A1 compatible as fallback.
> - Code fixes based on comments Neil Atrmstrong and Rob Herring.
> - Style fixes (set correct indentations)
>
> Changes V5 -> V6 [7]:
>
> - Fix DMA sync warning reported by Corentin Labbe [8].
> - Remove CLK input from driver. Remove clk definition
>   and second interrput line from crypto node inside GXL dtsi.
>
> Changes V6 -> V7 [9]:
>
> - Fix dt-schema: power domain now required only for A1.
> - Use crypto_skcipher_ctx_dma() helper for cipher instead of
>   ____cacheline_aligned.
> - Add import/export functions for hasher.
> - Fix commit message for patch 17, acorrding to discussion [10].
>
> Changes V7 -> V8 [11]:
>
> - Test patchset with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS: fix some bugs
>   in hasher logic.
> - Use crypto crypto_ahash_ctx_dma in hasher code.
> - Correct clock definition: clk81 is required for all SoC's.
> - Add fixed-clock (clk81) definition for A1/S4.
> - Add information (in commit messages) why different compatibles are used.
>
> Changes V8 -> V9 [12]:
>
> - Remove required field clk-names from dt-schema according to Rob Herring
> recommendation [13].
> - Fix commit order: all dt-bindings schema commits now located earlier
> than any changes in device tree.
> - Fix typos and add more clarifications in dt-schema patches.
>
> Changes V9 -> V10 [14]:
>
> - Rebased over linux-next (20241106).
> - Remove patches with AES-CTR support. This was a dishonest implementation of CTR algo.
> - Update commit headers in accordance with the accepted rules in each
>   of the subsystems.
> - Moved adding power-domains (dt-bindings) in desired commit.
>
> Changes V10 -> V11 [15]:
>
> - Rebased over linux-next (20241213).
> - Fix unused variable warnings reported by kernel test robot [16].
> - Fix dts warnings reported by kernel test robot. [17].
> - Add Rob Herring RvB tags for dt-bindings patches.
> - Remove ____cacheline_aligned macro. Use crypto_ahash/tfm_ctx_dma(),
>   crypto_ahash_set_reqsize_dma() and crypto_dma_align() instead.
>
> Changes V11 -> V12 [18]:
>
> - Rebased over linux-next (20250624).
> - Remove digest() method for hasher.
> - Add ____cacheline_aligned for meson_hasher_req_ctx structure. Hardware requires
>   that these buffers be located in different cache lines.
>
> Links:
>   - [1] https://gist.github.com/mRrvz/3fb8943a7487ab7b943ec140706995e7
>   - [2] https://lore.kernel.org/all/20240110201216.18016-1-avromanov@salutedevices.com/
>   - [3] https://lore.kernel.org/all/20240123165831.970023-1-avromanov@salutedevices.com/
>   - [4] https://lore.kernel.org/all/20240205155521.1795552-1-avromanov@salutedevices.com/
>   - [5] https://lore.kernel.org/all/20240212135108.549755-1-avromanov@salutedevices.com/
>   - [6] https://lore.kernel.org/all/ZcsYaPIUrBSg8iXu@Red/
>   - [7] https://lore.kernel.org/all/20240301132936.621238-1-avromanov@salutedevices.com/
>   - [8] https://lore.kernel.org/all/Zf1BAlYtiwPOG-Os@Red/
>   - [9] https://lore.kernel.org/all/20240326153219.2915080-1-avromanov@salutedevices.com/
>   - [10] https://lore.kernel.org/all/20240329-dotted-illusive-9f0593805a05@wendy/
>   - [11] https://lore.kernel.org/all/20240411133832.2896463-1-avromanov@salutedevices.com/
>   - [12] https://lore.kernel.org/all/20240607141242.2616580-1-avromanov@salutedevices.com/
>   - [13] https://lore.kernel.org/all/20240610222827.GA3166929-robh@kernel.org/
>   - [14] https://lore.kernel.org/all/20240820145623.3500864-1-avromanov@salutedevices.com/
>   - [15] https://lore.kernel.org/all/20241108102907.1788584-1-avromanov@salutedevices.com/
>   - [16] https://lore.kernel.org/all/202411090235.a7vEgZQo-lkp@intel.com/
>   - [17] https://lore.kernel.org/all/202411090619.fQTDHg7w-lkp@intel.com/
>   - [18] https://lore.kernel.org/all/20241213140755.1298323-1-avromanov@salutedevices.com/#t
>
> Alexey Romanov (22):
>   crypto: amlogic - Don't hardcode IRQ count
>   crypto: amlogic - Add platform data
>   crypto: amlogic - Remove clock input
>   crypto: amlogic - Add MMIO helpers
>   crypto: amlogic - Move get_engine_number()
>   crypto: amlogic - Drop status field from meson_flow
>   crypto: amlogic - Move algs definition and cipher API to cipher.c
>   crypto: amlogic - Cleanup defines
>   crypto: amlogic - Process more than MAXDESCS descriptors
>   crypto: amlogic - Avoid kzalloc in engine thread
>   crypto: amlogic - Introduce hasher
>   crypto: amlogic - Use fallback for 192-bit keys
>   crypto: amlogic - Add support for G12-series
>   crypto: amlogic - Add support for AXG-series
>   crypto: amlogic - Add support for A1-series
>   dt-bindings: crypto: amlogic,gxl-crypto: correct clk and interrupt
>     lines
>   dt-bindings: crypto: amlogic,gxl-crypto: support new SoC's
>   arm64: dts: amlogic: gxl: correct crypto node definition
>   arm64: dts: amlogic: a1: add crypto node
>   arm64: dts: amlogic: s4: add crypto node
>   arm64: dts: amlogic: g12: add crypto node
>   arm64: dts: amlogic: axg: add crypto node
>
>  .../bindings/crypto/amlogic,gxl-crypto.yaml   |  32 +-
>  arch/arm64/boot/dts/amlogic/meson-a1.dtsi     |  14 +
>  arch/arm64/boot/dts/amlogic/meson-axg.dtsi    |   7 +
>  .../boot/dts/amlogic/meson-g12-common.dtsi    |   7 +
>  arch/arm64/boot/dts/amlogic/meson-gxl.dtsi    |   6 +-
>  arch/arm64/boot/dts/amlogic/meson-s4.dtsi     |  13 +
>  drivers/crypto/amlogic/Makefile               |   2 +-
>  drivers/crypto/amlogic/amlogic-gxl-cipher.c   | 587 ++++++++++++------
>  drivers/crypto/amlogic/amlogic-gxl-core.c     | 289 +++++----
>  drivers/crypto/amlogic/amlogic-gxl-hasher.c   | 485 +++++++++++++++
>  drivers/crypto/amlogic/amlogic-gxl.h          | 111 +++-
>  11 files changed, 1191 insertions(+), 362 deletions(-)
>  create mode 100644 drivers/crypto/amlogic/amlogic-gxl-hasher.c
>
> --
> 2.34.1
>
>
> _______________________________________________
> linux-amlogic mailing list
> linux-amlogic@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-amlogic
