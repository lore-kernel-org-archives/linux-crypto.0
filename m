From: Andrew Bresticker <abrestic@chromium.org>
Subject: Re: [PATCH 2/2] Documentation: crypto: Add DT binding info for the
 img hw hash accelerator
Date: Mon, 10 Nov 2014 09:30:10 -0800
Message-ID: <CAL1qeaEp_K2JYXBu1hvFuiJ6Ps3jBoLRtmvw1F7FPKHwKDjXmg@mail.gmail.com>
References: <1415621455-10468-1-git-send-email-james.hartley@imgtec.com>
	<1415621455-10468-3-git-send-email-james.hartley@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	joe@perches.com, mchehab@osg.samsung.com, crope@iki.fi,
	jg1.han@samsung.com, linux-crypto@vger.kernel.org,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Ezequiel Garcia <ezequiel.garcia@imgtec.com>
To: James Hartley <james.hartley@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:44703 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbaKJRaL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Nov 2014 12:30:11 -0500
Received: by mail-pa0-f52.google.com with SMTP id fa1so8687361pad.39
        for <linux-crypto@vger.kernel.org>; Mon, 10 Nov 2014 09:30:10 -0800 (PST)
In-Reply-To: <1415621455-10468-3-git-send-email-james.hartley@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi James,

On Mon, Nov 10, 2014 at 4:10 AM, James Hartley <james.hartley@imgtec.com> wrote:
> Signed-off-by: James Hartley <james.hartley@imgtec.com>

A brief commit message describing the hardware and where it's found
would be nice.

> diff --git a/Documentation/devicetree/bindings/crypto/img-hash.txt b/Documentation/devicetree/bindings/crypto/img-hash.txt

> @@ -0,0 +1,28 @@
> +* Imagination Technologies Ltd. Hash Accelerator
> +
> +The hash accelerator provides hardware hashing acceleration for
> +SHA1, SHA224, SHA256 and MD5 hashes
> +
> +Required properties:
> +
> +- compatible : "img,img-hash-accelerator-rev1"

I know I mentioned in the internal review that it would be good to
have some sort of version indicator, but it looks like from the TRM
that the version is probable (CR_HASH_CORE_REV).  If we expect probing
for the revision number to be sufficient, then perhaps "rev1" can be
dropped?  Also, the second "img" is redundant.

> +- reg : Offset and length of the register set for the module, and the DMA port
> +- interrupts : The designated IRQ line for the hashing module.
> +- dmas : DMA specifier as per Documentation/devicetree/bindings/dma/dma.txt
> +- dma-names : Should be "tx"
> +- bus-addr : The bus address for the input data for hashing block

I think this can be dropped.  This is the same as the second "reg"
entry above, is it not?
