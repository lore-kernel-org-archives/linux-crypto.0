Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C571BFDE8;
	Wed, 21 Aug 2024 10:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724234579; cv=none; b=Nt7jRciYXr2Zm0RB9qFQOetyAR9G/Hwe3zjIeuCol4xutxcqSxsiVI3V8T32aVPnJNzaVm6Qj498UytSpfObFCGWaNmB/zllzhboUT9rk+2dPG8reivsYestbIBANNbyBf7E+TnT15vWWszwD65Ch7Mvd26F5aDGR3WKFGbIKZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724234579; c=relaxed/simple;
	bh=LBx8b6fa46n9coj8rSupKMXrF5Jk2Vtbna8Hp+EkQqk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rZ7RwoOPdfDq++c36xZaTfmad51WH+TkoMeqKR6GoWSja5J5x+yb3mGJjxS7NKHPcreuwVaTNGNAdhN9Y6cuuU687QRvIHrcc0szKQ7eKXzGou/aF9SucDVmDr1eF/NJvDuisodebh6M+pf95K8EegK4087WC5DJ73oX+f82AKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=s2b.tech; spf=pass smtp.mailfrom=s2b.tech; dkim=fail (0-bit key) header.d=s2b.tech header.i=@s2b.tech header.b=yiEsMJp6 reason="key not found in DNS"; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=s2b.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=s2b.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=s2b.tech header.i=@s2b.tech header.b="yiEsMJp6"
Received: from p-infra-ksmg-sc-msk02.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 6CF4D120009;
	Wed, 21 Aug 2024 13:02:51 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 6CF4D120009
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=s2b.tech;
	s=s2b.tech; t=1724234571;
	bh=COXiy57lY8dzSPNXsiiYnAyzRBL65uPiWZ3K75EEL8s=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version:From;
	b=yiEsMJp6lq7tdEgPiHFXk1xdLN78EScAQP4xLlgVULgr/MBYJfTYTe3A7YkaYowy7
	 ZgyOILRBQuL9HqtYh45ofGS+c5wpup2Kpcllz2toUlI3/67ESMvz4VmWdNV+xLrDEY
	 BVp+9vWBR0gI/kNZ/zW4BAiKTp4eEZ/nzyJggz8qXj63OuxHdWxqYIiM2KiNi190Sp
	 G0m8ZhLEhIvaI2chNCyuLlYHXn+H6gD5u+n5cJlEnco1ZIBfHW5GIOhTnbIvcbPz2c
	 CLHIT3xW1EGujP7yytLg+B4txR5PqjzbAu8qlZ7Gt6V9kEgfh9E2Uetsj4ltrprvnX
	 /rQXZaNI+iFGA==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Wed, 21 Aug 2024 13:02:51 +0300 (MSK)
From: Alexey Romanov <avromanov@s2b.tech>
To: "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>
CC: "clabbe@baylibre.com" <clabbe@baylibre.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>,
	"krzysztof.kozlowski+dt@linaro.org" <krzysztof.kozlowski+dt@linaro.org>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>, "khilman@baylibre.com"
	<khilman@baylibre.com>, "jbrunet@baylibre.com" <jbrunet@baylibre.com>,
	"martin.blumenstingl@googlemail.com" <martin.blumenstingl@googlemail.com>,
	"vadim.fedorenko@linux.dev" <vadim.fedorenko@linux.dev>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-amlogic@lists.infradead.org" <linux-amlogic@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, kernel <kernel@sberdevices.ru>
Subject: Re: [PATCH v9 00/23] Support more Amlogic SoC families in crypto
 driver
Thread-Topic: [PATCH v9 00/23] Support more Amlogic SoC families in crypto
 driver
Thread-Index: AQHa8xEu8HBRFAfkMUCcNq+0g+oZurIwEEOAgAE52YA=
Date: Wed, 21 Aug 2024 10:02:50 +0000
Message-ID: <20240821100245.q5uptswxmx4rk35n@cab-wsm-0029881>
References: <20240820145623.3500864-1-avromanov@salutedevices.com>
 <6e535895-6a06-42f8-abf3-e3b7472c97e0@linaro.org>
In-Reply-To: <6e535895-6a06-42f8-abf3-e3b7472c97e0@linaro.org>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7FC1B060E590BD478A7D229A9792E8A3@sberdevices.ru>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 187202 [Aug 21 2024]
X-KSMG-AntiSpam-Version: 6.1.0.4
X-KSMG-AntiSpam-Envelope-From: avromanov@s2b.tech
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 27 0.3.27 71302da218a62dcd84ac43314e19b5cc6b38e0b6, {Tracking_uf_ne_domains}, {Track_E25351}, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;lore.kernel.org:7.1.1;smtp.sberdevices.ru:7.1.1,5.0.1;gist.github.com:7.1.1;127.0.0.199:7.1.2;s2b.tech:7.1.1, FromAlignment: s
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2024/08/21 05:09:00
X-KSMG-LinksScanning: Clean, bases: 2024/08/21 05:09:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/08/21 06:50:00 #26388227
X-KSMG-AntiVirus-Status: Clean, skipped

Hi Neil,

On Tue, Aug 20, 2024 at 05:19:27PM +0200, neil.armstrong@linaro.org wrote:
> Hi,
>=20
> On 20/08/2024 16:56, Alexey Romanov wrote:
> > Hello!
> >=20
> > This patchset expand the funcionality of the Amlogic
> > crypto driver by adding support for more SoC families:
> > AXG, G12A, G12B, SM1, A1, S4.
> >=20
> > Also specify and enable crypto node in device tree
> > for reference Amlogic devices.
> >=20
> > Tested on GXL, AXG, G12A/B, SM1, A1 and S4 devices via
> > custom tests [1] and tcrypt module.
>=20
> On which tree did you base yourself ? It fails to apply patch 20 on next-=
20240820 and 6.11-rc4

Sorry, my tree is out of date (6.10.1).=20

I can rebase it to linux-next and resend patchset.

>=20
> Neil
>=20
> >=20
> > ---
> >=20
> > Changes V1 -> V2 [2]:
> >=20
> > - Rebased over linux-next.
> > - Adjusted device tree bindings description.
> > - A1 and S4 dts use their own compatible, which is a G12 fallback.
> >=20
> > Changes V2 -> V3 [3]:
> >=20
> > - Fix errors in dt-bindings and device tree.
> > - Add new field in platform data, which determines
> > whether clock controller should be used for crypto IP.
> > - Place back MODULE_DEVICE_TABLE.
> > - Correct commit messages.
> >=20
> > Changes V3 -> V4 [4]:
> >=20
> > - Update dt-bindings as per Krzysztof Kozlowski comments.
> > - Fix bisection: get rid of compiler errors in some patches.
> >=20
> > Changes V4 -> V5 [5]:
> >=20
> > - Tested on GXL board:
> >    1. Fix panic detected by Corentin Labbe [6].
> >    2. Disable hasher backend for GXL: in its current realization
> >       is doesn't work. And there are no examples or docs in the
> >       vendor SDK.
> > - Fix AES-CTR realization: legacy boards (gxl, g12, axg) requires
> >    inversion of the keyiv at keys setup stage.
> > - A1 now uses its own compatible string.
> > - S4 uses A1 compatible as fallback.
> > - Code fixes based on comments Neil Atrmstrong and Rob Herring.
> > - Style fixes (set correct indentations)
> >=20
> > Changes V5 -> V6 [7]:
> >=20
> > - Fix DMA sync warning reported by Corentin Labbe [8].
> > - Remove CLK input from driver. Remove clk definition
> >    and second interrput line from crypto node inside GXL dtsi.
> >=20
> > Changes V6 -> V7 [9]:
> >=20
> > - Fix dt-schema: power domain now required only for A1.
> > - Use crypto_skcipher_ctx_dma() helper for cipher instead of
> >    ____cacheline_aligned.
> > - Add import/export functions for hasher.
> > - Fix commit message for patch 17, acorrding to discussion [10].
> >=20
> > Changes V7 -> V8 [11]:
> >=20
> > - Test patchset with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS: fix some bugs
> >    in hasher logic.
> > - Use crypto crypto_ahash_ctx_dma in hasher code.
> > - Correct clock definition: clk81 is required for all SoC's.
> > - Add fixed-clock (clk81) definition for A1/S4.
> > - Add information (in commit messages) why different compatibles are us=
ed.
> >=20
> > Changes V8 -> V9 [12]:
> >=20
> > - Remove required field clk-names from dt-schema according to Rob Herri=
ng
> > recommendation [13].
> > - Fix commit order: all dt-bindings schema commits now located earlier
> > than any changes in device tree.
> > - Fix typos and add more clarifications in dt-schema patches.
> >=20
> > Links:
> >    - [1] https://gist.github.com/mRrvz/3fb8943a7487ab7b943ec140706995e7
> >    - [2] https://lore.kernel.org/all/20240110201216.18016-1-avromanov@s=
alutedevices.com/
> >    - [3] https://lore.kernel.org/all/20240123165831.970023-1-avromanov@=
salutedevices.com/
> >    - [4] https://lore.kernel.org/all/20240205155521.1795552-1-avromanov=
@salutedevices.com/
> >    - [5] https://lore.kernel.org/all/20240212135108.549755-1-avromanov@=
salutedevices.com/
> >    - [6] https://lore.kernel.org/all/ZcsYaPIUrBSg8iXu@Red/
> >    - [7] https://lore.kernel.org/all/20240301132936.621238-1-avromanov@=
salutedevices.com/
> >    - [8] https://lore.kernel.org/all/Zf1BAlYtiwPOG-Os@Red/
> >    - [9] https://lore.kernel.org/all/20240326153219.2915080-1-avromanov=
@salutedevices.com/
> >    - [10] https://lore.kernel.org/all/20240329-dotted-illusive-9f059380=
5a05@wendy/
> >    - [11] https://lore.kernel.org/all/20240411133832.2896463-1-avromano=
v@salutedevices.com/
> >    - [12] https://lore.kernel.org/all/20240607141242.2616580-1-avromano=
v@salutedevices.com/
> >    - [13] https://lore.kernel.org/all/20240610222827.GA3166929-robh@ker=
nel.org/
> >=20
> > Alexey Romanov (23):
> >    drivers: crypto: meson: don't hardcode IRQ count
> >    drviers: crypto: meson: add platform data
> >    drivers: crypto: meson: remove clock input
> >    drivers: crypto: meson: add MMIO helpers
> >    drivers: crypto: meson: move get_engine_number()
> >    drivers: crypto: meson: drop status field from meson_flow
> >    drivers: crypto: meson: move algs definition and cipher API to
> >      cipher.c
> >    drivers: crypto: meson: cleanup defines
> >    drivers: crypto: meson: process more than MAXDESCS descriptors
> >    drivers: crypto: meson: avoid kzalloc in engine thread
> >    drivers: crypto: meson: introduce hasher
> >    drivers: crypto: meson: add support for AES-CTR
> >    drivers: crypto: meson: use fallback for 192-bit keys
> >    drivers: crypto: meson: add support for G12-series
> >    drivers: crypto: meson: add support for AXG-series
> >    drivers: crypto: meson: add support for A1-series
> >    dt-bindings: crypto: meson: correct clk and remove second interrupt
> >      line
> >    dt-bindings: crypto: meson: support new SoC's
> >    arch: arm64: dts: meson: gxl: correct crypto node definition
> >    arch: arm64: dts: meson: a1: add crypto node
> >    arch: arm64: dts: meson: s4: add crypto node
> >    arch: arm64: dts: meson: g12: add crypto node
> >    arch: arm64: dts: meson: axg: add crypto node
> >=20
> >   .../bindings/crypto/amlogic,gxl-crypto.yaml   |  32 +-
> >   arch/arm64/boot/dts/amlogic/meson-a1.dtsi     |  14 +
> >   arch/arm64/boot/dts/amlogic/meson-axg.dtsi    |   7 +
> >   .../boot/dts/amlogic/meson-g12-common.dtsi    |   7 +
> >   arch/arm64/boot/dts/amlogic/meson-gxl.dtsi    |   6 +-
> >   arch/arm64/boot/dts/amlogic/meson-s4.dtsi     |  13 +
> >   drivers/crypto/amlogic/Makefile               |   2 +-
> >   drivers/crypto/amlogic/amlogic-gxl-cipher.c   | 632 ++++++++++++-----=
-
> >   drivers/crypto/amlogic/amlogic-gxl-core.c     | 292 ++++----
> >   drivers/crypto/amlogic/amlogic-gxl-hasher.c   | 507 ++++++++++++++
> >   drivers/crypto/amlogic/amlogic-gxl.h          | 118 +++-
> >   11 files changed, 1269 insertions(+), 361 deletions(-)
> >   create mode 100644 drivers/crypto/amlogic/amlogic-gxl-hasher.c
> >=20
>=20

--=20
Thank you,
Alexey=
