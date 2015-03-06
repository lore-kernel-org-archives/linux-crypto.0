From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 0/17] crypto: talitos - Add support for SEC1
Date: Thu, 5 Mar 2015 18:21:01 -0600
Message-ID: <20150305182101.6db66e228f519476f0751c13@freescale.com>
References: <20150305164605.E65D81A241C@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	<linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0144.outbound.protection.outlook.com ([157.56.111.144]:53871
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753306AbbCFA0X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Mar 2015 19:26:23 -0500
In-Reply-To: <20150305164605.E65D81A241C@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 5 Mar 2015 17:46:05 +0100
Christophe Leroy <christophe.leroy@c-s.fr> wrote:

> [15/17] crypto: talitos - Implementation of SEC1

...

> [16/17] crypto: talitos - SEC1 bugs on 0 data hash
> [17/17] crypto: talitos - Update DT bindings with SEC1

This patchseries doesn't apply, at least on top of Herbert's
cryptodev-2.6 tree, as of today:

Applying: crypto: talitos - Implementation of SEC1
error: patch failed: drivers/crypto/talitos.c:655
error: drivers/crypto/talitos.c: patch does not apply

Kim
