Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F15392820;
	Fri, 27 Mar 2026 20:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774642260; cv=none; b=g02CaIuH2wKFfXuT4SoInybkPCvqfXotK/mwS/XrPWmIOZcjz2xHCDG6T+Vrczy0G4ekNaTsj9oPqKCXjtmQqwYpWPlJz7vqCUE0dQUvkUUGsd+b0ahZtZdViOQRAlfnYJht+6bAbLA2Cw1FAiflE7JQKneJ2FxZGmObTTYVkt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774642260; c=relaxed/simple;
	bh=mPlt0fwCrjwYwW71s5RXcDjC/hgG4hSANbbbud3x+iQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TMLZI4Tm6fR9JeTf3HN3ahgrVxycS3EudL0IWbO6b+NBnvy29SYjaqaypxFfHFQqidbSfnyXLAV8mbI3+jg8fBX7u+yOYs1yLZV39rwdd0ub03Qypq0YiICxrk5eiRPkJpNktSaJnWYzW6EaxIBWgLMNJZLaP7AIt80HN1hTEu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=PbfeHNWn; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="PbfeHNWn"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 12EBB1A3032;
	Fri, 27 Mar 2026 20:10:58 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id DBEF060268;
	Fri, 27 Mar 2026 20:10:57 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id EBC9D10451AF7;
	Fri, 27 Mar 2026 21:10:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1774642256; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=rL9r1/GJspqmlIUASiShMPJp3IBiTzpcrlWKfB5DDEU=;
	b=PbfeHNWnYlmEhFjZsdQ8eMWrtlO4fut3zQO/skj7euezHvhq/BVoVu6VtTWtqzrIbGGPkv
	M+3R26y90B5n8synVnisE7f2AHErRhWHykROtDoQxbLqZF5JtBtFyz/RjzNzwd/+Ipu4Qk
	I+B//l8aidERiFZ3bVmgSvtZ5VlAD6Juu4RGGpuJvWrnSUrkf1GPdC0feeY9UCXwKtTJbz
	uG95QpW2kDhdOIpJrA7QXG3D1YgHUMEIy57CkV3xuGfY0xllHOlCyE7BOY9AtcRTOyu+2G
	utj4YClgstzG4d1gx4SjUqTnoH2uDx3QXjEOxiZgHwB3Abo2rYwMjLJSOrKmVg==
From: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>
Date: Fri, 27 Mar 2026 21:09:32 +0100
Subject: [PATCH 10/16] clk: Add support for clock nexus dt bindings
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260327-schneider-v7-0-rc1-crypto-v1-10-5e6ff7853994@bootlin.com>
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
In-Reply-To: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
To: Michael Turquette <mturquette@baylibre.com>, 
 Stephen Boyd <sboyd@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Jayesh Choudhary <j-choudhary@ti.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Christian Marangi <ansuelsmth@gmail.com>, 
 Antoine Tenart <atenart@kernel.org>, 
 Geert Uytterhoeven <geert+renesas@glider.be>, 
 Magnus Damm <magnus.damm@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Pascal EBERHARD <pascal.eberhard@se.com>, 
 Wolfram Sang <wsa+renesas@sang-engineering.com>, linux-clk@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
 "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>
X-Mailer: b4 0.14.3
X-Last-TLS-Session-Version: TLSv1.3

A nexus node is some kind of parent device abstracting the outer
connections. They are particularly useful for describing connectors-like
interfaces but not only. Certain IP blocks will typically include inner
blocks and distribute resources to them.

In the case of clocks, there is already the concept of clock controller,
but this usually indicates some kind of control over the said clock,
ie. gate or rate control. When there is none of this, an existing
approach is to reference the upper clock, which is wrong from a hardware
point of view.

Nexus nodes are already part of the device-tree specification and clocks
are already mentioned:
https://github.com/devicetree-org/devicetree-specification/blob/v0.4/source/chapter2-devicetree-basics.rst#nexus-nodes-and-specifier-mapping

Following the introductions of nexus nodes support for interrupts, gpios
and pwms, here is the same logic applied again to the clk subsystem,
just by transitioning from of_parse_phandle_with_args() to
of_parse_phandle_with_args_map():

* Nexus OF support:
commit bd6f2fd5a1d5 ("of: Support parsing phandle argument lists through a nexus node")
* GPIO adoption:
commit c11e6f0f04db ("gpio: Support gpio nexus dt bindings")
* PWM adoption:
commit e71e46a6f19c ("pwm: Add support for pwm nexus dt bindings")

Expected Nexus properties supported:
- clock-map: maps inner clocks to inlet clocks,
- clock-map-mask: specifier cell(s) which will be remapped,
- clock-map-pass-thru: specifier cell(s) not used for remapping,
  forwarded as-is.

In my own usage I had to deal with controllers where clock-map-mask and
clock-map-pass-thru were not relevant, but here is a made up example
showing how all these properties could go together:

Example:
    soc_clk: clock-controller {
        #clock-cells = <2>;
    };

    container: container {
        #clock-cells = <2>;
        clock-map = <0 0 &soc_clk 2 0>,
                    <1 0 &soc_clk 6 0>;
        clock-map-mask = <0xffffffff 0x0>;
        clock-map-pass-thru = <0x0 0xffffffff>;

        child-device {
            clocks = <&container 1 0>;
	    /* This is equivalent to <&soc_clk 6 0> */
        };
    };

The child device does not need to know about the outer implementation,
and only knows about what the nexus provides. The nexus acts as a
pass-through, with no extra control.

Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>
Reviewed-by: Herve Codina <herve.codina@bootlin.com>
---
 drivers/clk/clk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 93e33ff30f3a..196ba727e84b 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -5218,8 +5218,8 @@ static int of_parse_clkspec(const struct device_node *np, int index,
 		 */
 		if (name)
 			index = of_property_match_string(np, "clock-names", name);
-		ret = of_parse_phandle_with_args(np, "clocks", "#clock-cells",
-						 index, out_args);
+		ret = of_parse_phandle_with_args_map(np, "clocks", "clock",
+						     index, out_args);
 		if (!ret)
 			break;
 		if (name && index >= 0)

-- 
2.51.1

