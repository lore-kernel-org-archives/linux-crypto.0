From: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Subject: [PATCH v2 0/5] Enable CAAM on i.MX7s fix TrustZone issues
Date: Fri, 26 Jan 2018 16:59:59 +0000
Message-ID: <1516986004-25452-1-git-send-email-pure.logic@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: fabio.estevam@nxp.com, peng.fan@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        lukas.auer@aisec.fraunhofer.de, rui.silva@linaro.org,
        ryan.harkin@linaro.org,
        Bryan O'Donoghue <pure.logic@nexus-software.ie>
To: horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:56212 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751374AbeAZRAH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jan 2018 12:00:07 -0500
Received: by mail-wm0-f68.google.com with SMTP id 143so2566917wma.5
        for <linux-crypto@vger.kernel.org>; Fri, 26 Jan 2018 09:00:06 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

V2:
- Endian detection is ok with TrustZone enabled Horia.
  Endian detection logic tested with TrustZone enabled. The register that
  this relies on though isn't affected by the lock-down in the first page.
  Assuming set of affected registers is actually just the 'deco' registers
  though there is no formal statement of that, that I am aware of.

- Moving of TrustZone work-around into u-boot
  This set actually doesn't need to deal with TrustZone at all now but, for
  the sake of consistency keeping thread title

  https://patchwork.ozlabs.org/patch/866460/
  https://patchwork.ozlabs.org/patch/866462/
  https://patchwork.ozlabs.org/patch/865890/

- Reworded endless loop fix to read a bit better

- Fixes to DTS additions - Rui

- Fixes to number of clocks declared - Rui

V1:
This patch-set enables CAAM on the i.MX7s and fixes a number of issues
identified with the CAAM driver and hardware when TrustZone mode is
enabled.

The first block of patches are simple bug-fixes, followed by a second block
of patches which are simple enabling patches for the i.MX7Solo - note we
aren't enabling for the i.MX7Dual since we don't have hardware to test that
out but it should be a 1:1 mapping for others to enable when appropriate.

The final block in this series implements a fix for using the CAAM when
OPTEE/TrustZone is enabled. The various details are logged in these
threads.

Link: https://github.com/OP-TEE/optee_os/issues/1408
Link: https://tinyurl.com/yam5gv9a
Link: https://patchwork.ozlabs.org/cover/865042

In simple terms, when TrustZone is active the first page of the CAAM
becomes inaccessible to Linux as it has a special 'TZ bit' associated with
it that software cannot toggle or even view AFAIK.

The patches here then

1. Detect when TrustZone is active
2. Detect if u-boot (or OPTEE) has already initialized the RNG

and loads the CAAM driver in a different way - skipping over the RNG
initialization that Linux now no-longer has permissions to carry out.

Should #1 be true but #2 not be true, driver loading stops (and Rui's patch
for the NULL pointer dereference fixes a cash on this path). If #2 is true
but #1 is not then it's a NOP as Linux has full permission to rewrite the
deco registers in the first page of CAAM registers.

Finally then if #1 and #2 are true, the fixes here allow the CAAM to come
up and for the RNG to be useable again.

Bryan O'Donoghue (1):
  crypto: caam: Fix endless loop when RNG is already initialized

Rui Miguel Silva (4):
  crypto: caam: Fix null dereference at error path
  crypto: caam: do not use mem and emi_slow clock for imx7x
  clk: imx7d: add CAAM clock
  ARM: dts: imx7s: add CAAM device node

 arch/arm/boot/dts/imx7s.dtsi            | 31 +++++++++++++++++++++++
 drivers/clk/imx/clk-imx7d.c             |  1 +
 drivers/crypto/caam/ctrl.c              | 45 ++++++++++++++++++++-------------
 include/dt-bindings/clock/imx7d-clock.h |  3 ++-
 4 files changed, 61 insertions(+), 19 deletions(-)

-- 
2.7.4
