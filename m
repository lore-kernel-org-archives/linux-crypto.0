Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795518690;
	b=4Bmi2EbVDQaBdQ3zmfYeDmIIzwFtOyXl5HIN4u+3bYN7Ln0+Q2TBmiFaJ/9Ndm7Hwt9/
	 2jexV6ev0McULQPWqk/RR7dQJzq69MuIerpwYBngrS3DZzclCOUwIyV5QEJ3NH666LbC3
	 9od0xr+Fl0u8HXXqnE9Mtty8z5bP6yL14mT+Et2c+hFW9wTZbFJ2N21vmGVQsQXyKCgJk
	 GN0ZnGFTGdt/oWFirEOzhu0EZWJyaQCiuGySLPrjxmMEroVeerTSTQTfoKapKUj78McI1
	 4/iXQJiuCCQIMMIDlwkCYcet0FWmBu+NDzblAvMX67MOVAc2y5zcLvJuFy0oo72VmVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795518690;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=NSxrWerDVUD4OAZBVBT8f6aipq0wkqN4/k67VkANLuc=;
	b=hJnXPsIHw5+LkmbP8EF5tjMiH5ftuT0pojON/SpCJMluSENxGehe4nC9pxNChjG624e7
	 gn931Rb4GiGW5YZnQdZjVnDcKsvY/K0vFHlXFdJj1CewgQ7fzg9ZEqI6aTfTTlrDtasR/
	 wURtG9BM9TovhwInErMAk8ltcVz/+SLBx0qAbPB9ckI4DJCeQbPCjslF1AdndZDnq1A1v
	 JlA7fEqd9iD+APESFU1aNTzR/an7hV0y0V3bgkS5Qk+txHuUTUlQp+vjggYh3qNz1ibI8
	 wwirRMSCFfjlkTvor8eg+Lx3f/N76Yc++mveXfPLzEPFZzFik0wVUka5FLjhhtimnMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PjsSqSr9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AEC606A32C
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 11:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PjsSqSr9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CB21F000D8;
	Tue, 24 Nov 2026 11:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795518689;
	bh=NSxrWerDVUD4OAZBVBT8f6aipq0wkqN4/k67VkANLuc=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=PjsSqSr9u0NwFamvOlvxXG5jxpGF8/FSmZhX6+Bo6m7HT3SqSUPPVQuLNJksDFNR6
	 /6HxtlId/Qhw3djIMN8D1FCzkvrI5FZmPjVLhKoF+WCeimYWCJGuks+SW8y8v49XI7
	 3HuuchP0WFbqun419aD2PLnzJHbgH5GbCba3PKF4KCAWjR5Y1BS5C+ISshY3T/Gbqp
	 lrxCZ+BLi+QW4xMapcp8tuDJQA9R/MS+vtjoT/MkRmOEzCiGFoCbISwR0WteiipYr4
	 ZQX0Q/IUP0XuRCQF7RpJLSf/DEVkjZynj15ryWAJ+bT3QBIEpPGecG8ZWfpURO8pmr
	 KRBqLRHD0RSbw==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 95AC41980047;
	Tue, 24 Nov 2026 06:11:27 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Tue, 24 Nov 2026 06:11:27 -0500
X-ME-Sender: <xms:33AFa8rjZyxVEuWiZPC8MB_b4jHBfwm9CcaCxHmYDZPQiPt0OOjIrg>
    <xme:33AFa9dMqkTCvGvwQHbyCq8tx2uAuQDeOsCA_09gfeJUzSvKzzYRBvkseXqFB0q5D
    gVwfAWb6uFQOdKhoyF6iaOLwyaIDbHBC5LktkG09mqrz1U02XvsH-s>
X-ME-Proxy-Cause: dmFkZTGOqtGOvzr+VHUOxMo62cqM3udAVEWtGm22R9C85i1IVw07DOw5z2ne0UbiNMh3Xm
    md+GqwxSY9YeA+u7WrSm1o/Iwt5fVYlNT6Rsxey8TbBpc29g4327/k4zoECWwlgoQjSdP8
    gevWXgQn+9CGUGzeIn3zuBxRn7KDZk+L2PwRnD7OT/3bUdEK7vnfxBTzZjQzJwnQFHYhdU
    0OhD1l0I7go5ZfQ/Eb70CrXOhS+RPON65NrktViFQjVmX7U5XBK80Ey6SsPS82P1i03bQi
    H52PoxI+SFo4ADW0smVxhYLHOR7CwWlEM4uA1cc6XpvSJfXGrkTH+xRnFvi3FojshcoCWK
    LZTyALPT6f986gSIJOJZC5Z3h6YXK8EFzeqHiLaBcgY0ii/lMVGteLw5ZiKGH8BHPfDSiG
    qDmOnlTFRrmeniZG2tDvVGB/VhZU384XSPFOh8Kx8sEjMhusaEw4wxyEDPYdeB5uZJZeh6
    wTiwdDHvVlhMvh2mazuoUxd0PagzOZBCEFOV/qyZU2ahsZfSyEQTNd+usaRK6vEyjiJcY1
    /pfqhYpVWqty1u9txqVhG08Yl0OJtCO4FPKNYRIy4qexrWTUQ0IeeqdAm8wPo+y7DU+qmJ
    CP3y9EvNCgqAh40Ac1RX1GdVgabuM1uqFT+xZ4a3+HyxxpLwG+7MC5PKJ7YQ
X-ME-Proxy: <xmx:33AFa0iKJX7EYL6NBrUcto04R7fH6f2YX17BlD8wYkF-Uror-7evnA>
    <xmx:33AFa9v-R-kJ0ZhOBjbV3HNtVlAakUHdK5vv2lsD90LAl3lnwh8wfw>
    <xmx:33AFa6QZOSZ69OLcUhnUoISdnBa4QwHuaSbyxXeAtYbPHS14Qp1aeQ>
    <xmx:33AFa52i1sBhWrwcDG3QS61ufurCkEBxlXbcHYgdCWILhOWIA3KPgg>
    <xmx:33AFa3umEnQbsyl_9BqjvsZUmmx2YYQ2NP5n-51r2PaLY_qGQ4tgj_QK>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 40077F80093; Tue, 24 Nov 2026 06:11:27 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Tue, 24 Nov 2026 12:11:06 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 linux-arm-kernel@lists.infradead.org,
 "Emanuele Rocca" <emanuele.rocca@arm.com>
Message-Id: <fda20d6c-34c1-48fe-9c95-c25db12e9d4c@app.fastmail.com>
In-Reply-To: <20261114204245.67919-1-ebiggers@kernel.org>
References: <20261114204245.67919-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: arm64/sha3: Use assembler for sha3 instructions
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sat, 14 Nov 2026, at 21:42, Eric Biggers wrote:
> All supported assemblers (binutils 2.30 and later, and clang 17.0.1 and
> later) support the sha3 instructions now.
>
> Therefore, drop the use of '.inst' in sha3-ce-core.S and just have the
> assembler generate the instructions.
>
> This requires adding '.arch armv8.2-a+sha3'.  I also tried just
> '.arch_extension sha3', but that doesn't work with binutils 2.40 and
> earlier because they consider sha3 to depend on armv8.2-a or later (and
> this file isn't built with -march=armv8.2-a or later).  This was fixed
> in binutils 2.41 commit 205e4380c800, but the kernel currently supports
> binutils 2.30 and later.
>
> Also prefix the immediate operands to 'xar' with '#', now that they no
> longer need to be plain numbers to generate an .inst.  This isn't
> required, but it follows the standard convention for immediates in arm64
> assembly, including elsewhere in the same file.
>
> No change in the resulting .text section with either binutils or clang.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This patch is intended to be taken through libcrypto-next
>
>  lib/crypto/arm64/sha3-ce-core.S | 73 ++++++++++++---------------------
>  1 file changed, 26 insertions(+), 47 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
