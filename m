Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00761922F8;
	Fri, 23 Aug 2024 18:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724436615; cv=none; b=RN62Aw7uochpOeykyBBmHGVjCLhJJxbSP3h/qv2s5pcUx9OK3cMc/YWElVW6CukDYho9zQEwCmdTj+pLdryWtyl2AMmd8LsK6GhmB/i+WujIszoA69HxoUhrzqnob/jCZ45Hd38T1wXKGhBjcQ9RaCKspzRTOpa4OyslanLgXco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724436615; c=relaxed/simple;
	bh=PSirfHdojdbXoWdPsYz8mxa9M1VP4fBr2htSgqKXfUg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Okr84ZhJcNA374cC+kW3qPO41YbjrL9ecWgi9K0Ms2L+qZcjLlUC62DCGySeZjLeHMpj+lYNa/eMJj75MKiDaO0TaPuX0acTyYhEKLVXeVgxcgux+LAinPWODuYPmlT9/33JqZAVBzrKRFxLkfhVOBf4Rh5Xd1ypzSimZEiWSEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X8wflIzX; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X8wflIzX"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-270263932d5so1628803fac.2;
        Fri, 23 Aug 2024 11:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724436613; x=1725041413; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NbtN34OztMcTIBRWursUybQnLUd+2YeirAS1R5D30cM=;
        b=X8wflIzX8fwtntV+ms9r7SIE4wSIBlXpsTfmyS/YOLXIsADdhSQg8dS5Pzx8534egJ
         DCkvF/j6F+O4WTKkc8nbISO3FyBXh3R1XsOLJOZP1cdv0RLIovaymGOTQZhS5eo/Vs8a
         Vb+s7Y8+orbHGktGKs81q7mAbFCzwFlcQ6M3XA+qeMgVMkO3Db5EqVCkbQ4lWJt9Lv4N
         YwAWbaXwyIeo7sGpcBu/tvCYPuz5uph/EJjwPfbd7JnRdbFUmgTVv040/IqJJlpyOM0E
         iVM06Cz+21jM9ORIW65d4ci0RVGM2hSsnf0acqIrl1IV6IdpSDNDA6X2BbZVR+Z/EPrj
         62/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724436613; x=1725041413;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NbtN34OztMcTIBRWursUybQnLUd+2YeirAS1R5D30cM=;
        b=GXwa2Xt9heS3z1Hij2EoA4w3HjY2Owf0FvDjw72mlOyUwaT2WciGASuIUECf1YFZrw
         0QmqbP6ueoTQHZRKEmGuFEXjwGWADZcdDsrNIWxApfYvCfWI4ox6zzWiC7dJQLDD+ux/
         NLjkjggn8F7HN2snbo//SjMkd5PwrgtGTtkbZenvZAt/bH5/Vgo9DWhLnAB0IL0JWFEC
         QUGLs4iqCMh9q10L16dSZZzvH4Ze7215AE7dWnQoFpGi4z3wJBZpCVFaBkOtkIAPPlQw
         LrGwQ16GVZ+1wYd78PbBJfIic88YsWa1gnoIc/M5pNlLyfig1q8G8Gx2Yr4i1J04VrMf
         0rtA==
X-Forwarded-Encrypted: i=1; AJvYcCUE+h5itKxxQEgS4DmnD8NVdN2A/wmE71bcyYbGlw6yfLY3gmQxQVojB3e/FAXKzrrZis75qUj4KoKq@vger.kernel.org, AJvYcCX3p1wrd5uqiZbtviiY0VrtRNyTYE5+ca+dflEs/V9ZOSacIVEIDFpyBPpN/FslqOjbNOX0ICzNz+DWIN42@vger.kernel.org, AJvYcCXOlbYHW+VjRTiJxoExw0zhJrxiOIZNEQmoIE2OZC7WO1kilMoBa3U5/aC2k7CcpCr7p+OveciNbsyUAVp9@vger.kernel.org
X-Gm-Message-State: AOJu0YzmtfnYMYjE1zl37bG+RkrtnPTtmLj89qol1btYFtaWkNvv0dZ7
	G59Cj5AtZ9XrEN4qRGJMsytFxeorBFlh7Hbao4JKbISRPQBoSa+OrXIqiNnmmSKKEzRMqMxADPY
	9csT0o050S4JYE6OsVRbA6juO6yU=
X-Google-Smtp-Source: AGHT+IHCk1CU0qiBSKUqy36ZULXUFuPlzCEntBPbtvUIZxFil/4taZiG19VCpHB1UWL9NQRCafYKkjCZbc4xE1Jnlys=
X-Received: by 2002:a05:6870:b525:b0:261:446:c405 with SMTP id
 586e51a60fabf-273e63de2a7mr3349911fac.4.1724436612812; Fri, 23 Aug 2024
 11:10:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240820145623.3500864-1-avromanov@salutedevices.com>
In-Reply-To: <20240820145623.3500864-1-avromanov@salutedevices.com>
From: Anand Moon <linux.amoon@gmail.com>
Date: Fri, 23 Aug 2024 23:39:54 +0530
Message-ID: <CANAwSgSwY+XSfw2styzY49Ti_zDntQBPMnbOLeJUt2srwde-6w@mail.gmail.com>
Subject: Re: [PATCH v9 00/23] Support more Amlogic SoC families in crypto driver
To: Alexey Romanov <avromanov@salutedevices.com>
Cc: neil.armstrong@linaro.org, clabbe@baylibre.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, robh+dt@kernel.org, 
	krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org, khilman@baylibre.com, 
	jbrunet@baylibre.com, martin.blumenstingl@googlemail.com, 
	vadim.fedorenko@linux.dev, linux-crypto@vger.kernel.org, 
	linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kernel@salutedevices.com
Content-Type: text/plain; charset="UTF-8"

Hi Alexey,

Thanks for working on these changes.

On Tue, 20 Aug 2024 at 20:31, Alexey Romanov
<avromanov@salutedevices.com> wrote:
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

I have tried these patches on my G12B, Odorid N2plus.

$ sudo cat /sys/kernel/debug/gxl-crypto/stats
[sudo] password for alarm:
Channel 0: nreq 330
cbc-aes-gxl cbc(aes) 135 2187
ecb-aes-gxl ecb(aes) 97 2005
ctr-aes-gxl ctr(aes) 98 992

But, I am observing the following with crypto/testmgr failed

[    1.915219] Key type .fscrypt registered
[    1.915238] Key type fscrypt-provisioning registered
[    2.418969] Key type encrypted registered
[    4.358508] alg: skcipher: blocksize for ctr-aes-gxl (16) doesn't
match generic impl (1)
[    4.361075] alg: self-tests for ctr(aes) using ctr-aes-gxl failed (rc=-22)
[    4.361089] ------------[ cut here ]------------
[    4.361102] alg: self-tests for ctr(aes) using ctr-aes-gxl failed (rc=-22)
[    4.361153] WARNING: CPU: 4 PID: 154 at crypto/testmgr.c:5887
alg_test+0x56c/0x600
[    4.367839] Modules linked in:
[    4.370871] CPU: 4 PID: 154 Comm: cryptomgr_test Not tainted
6.10.6-MANJARO-ARM+ #3
[    4.378497] Hardware name: Hardkernel ODROID-N2Plus (DT)
[    4.383784] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    4.390716] pc : alg_test+0x56c/0x600
[    4.394356] lr : alg_test+0x56c/0x600
[    4.397996] sp : ffff800084293d40
[    4.401289] x29: ffff800084293d40 x28: ffff80008124ac58 x27: 00000000ffffffff
[    4.408396] x26: 00000000ffffffea x25: 0000000000000048 x24: ffff80008308b000
[    4.415503] x23: ffff80008124ac58 x22: 0000000000010385 x21: ffff000004481c80
[    4.422609] x20: ffff000004481c00 x19: 000000000000003b x18: 00000000fffffffe
[    4.429716] x17: 656e656720686374 x16: 616d2074276e7365 x15: ffff800084293930
[    4.436823] x14: 0000000000000000 x13: ffff800082ed6153 x12: ffff8000821b1508
[    4.443929] x11: 0000000000000001 x10: 0000000000000001 x9 : ffff80008017e6d4
[    4.451036] x8 : c0000000ffffdfff x7 : ffff8000821012d0 x6 : 00000000000affa8
[    4.458143] x5 : ffff8000821b14b0 x4 : 0000000000000000 x3 : 0000000000000000
[    4.465250] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff00000a739dc0
[    4.472357] Call trace:
[    4.474783]  alg_test+0x56c/0x600
[    4.478076]  cryptomgr_test+0x2c/0x50
[    4.481716]  kthread+0x108/0x120
[    4.484923]  ret_from_fork+0x10/0x20
[    4.488477] irq event stamp: 988
[    4.491683] hardirqs last  enabled at (987): [<ffff8000801808fc>]
console_unlock+0x134/0x148
[    4.500090] hardirqs last disabled at (988): [<ffff8000811a0554>]
el1_dbg+0x24/0x98
[    4.507716] softirqs last  enabled at (966): [<ffff8000800c2878>]
handle_softirqs+0x350/0x370
[    4.516209] softirqs last disabled at (959): [<ffff8000800105fc>]
__do_softirq+0x1c/0x28
[    4.524269] ---[ end trace 0000000000000000 ]---

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
>
> Alexey Romanov (23):
>   drivers: crypto: meson: don't hardcode IRQ count
>   drviers: crypto: meson: add platform data
>   drivers: crypto: meson: remove clock input
>   drivers: crypto: meson: add MMIO helpers
>   drivers: crypto: meson: move get_engine_number()
>   drivers: crypto: meson: drop status field from meson_flow
>   drivers: crypto: meson: move algs definition and cipher API to
>     cipher.c
>   drivers: crypto: meson: cleanup defines
>   drivers: crypto: meson: process more than MAXDESCS descriptors
>   drivers: crypto: meson: avoid kzalloc in engine thread
>   drivers: crypto: meson: introduce hasher
>   drivers: crypto: meson: add support for AES-CTR
>   drivers: crypto: meson: use fallback for 192-bit keys
>   drivers: crypto: meson: add support for G12-series
>   drivers: crypto: meson: add support for AXG-series
>   drivers: crypto: meson: add support for A1-series
>   dt-bindings: crypto: meson: correct clk and remove second interrupt
>     line
>   dt-bindings: crypto: meson: support new SoC's
>   arch: arm64: dts: meson: gxl: correct crypto node definition
>   arch: arm64: dts: meson: a1: add crypto node
>   arch: arm64: dts: meson: s4: add crypto node
>   arch: arm64: dts: meson: g12: add crypto node
>   arch: arm64: dts: meson: axg: add crypto node
>
>  .../bindings/crypto/amlogic,gxl-crypto.yaml   |  32 +-
>  arch/arm64/boot/dts/amlogic/meson-a1.dtsi     |  14 +
>  arch/arm64/boot/dts/amlogic/meson-axg.dtsi    |   7 +
>  .../boot/dts/amlogic/meson-g12-common.dtsi    |   7 +
>  arch/arm64/boot/dts/amlogic/meson-gxl.dtsi    |   6 +-
>  arch/arm64/boot/dts/amlogic/meson-s4.dtsi     |  13 +
>  drivers/crypto/amlogic/Makefile               |   2 +-
>  drivers/crypto/amlogic/amlogic-gxl-cipher.c   | 632 ++++++++++++------
>  drivers/crypto/amlogic/amlogic-gxl-core.c     | 292 ++++----
>  drivers/crypto/amlogic/amlogic-gxl-hasher.c   | 507 ++++++++++++++
>  drivers/crypto/amlogic/amlogic-gxl.h          | 118 +++-
>  11 files changed, 1269 insertions(+), 361 deletions(-)
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
