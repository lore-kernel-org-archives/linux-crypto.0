Received: from gauss.telenet-ops.be (gauss.telenet-ops.be [195.130.132.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A566018A94A
	for <linux-crypto@vger.kernel.org>; Tue, 20 Aug 2024 09:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.132.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724146154; cv=none; b=ue/veM/Bzgt8WiMie1n1rJh5aPmNS6MmNfo32COYTGQZY3rInetgev+qOb7fjPE2CI79BD2bjRlIzRDmMLxc9NpL3npVuHEI5gF1GqwWN8o2QlkPt2zIR68lQUlDRtAGUiYpVkqLDtiRLBusDpt6VlX8FEzim4uj02zf+4OiKu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724146154; c=relaxed/simple;
	bh=1p3JZfIy57+yQxzEAuW3lsEC0DcOCf65qWJ1CHrK5V4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=XLgSPzCxB4Y3HoA1BGrtq1V+mR8g8SAwHqhM7AaGC45O69hLn7X9fXtlnwEK6c/YhMS4VdcKf10+/AIh2T3CBpI8KooFg+uybELh2d9FSpX4AYbRnMRAb0sfWmT17cFlyo+j5Dvzc5HyIOg+2ZHJcRhrbXBxWVn+UCNgW34HtdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.132.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
	by gauss.telenet-ops.be (Postfix) with ESMTPS id 4Wp40d3jHfz4xKqw
	for <linux-crypto@vger.kernel.org>; Tue, 20 Aug 2024 11:29:05 +0200 (CEST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed80:a2e4:464c:5828:2da3])
	by michel.telenet-ops.be with bizsmtp
	id 29Ux2D0092WQTnu069Uxui; Tue, 20 Aug 2024 11:28:58 +0200
Received: from geert (helo=localhost)
	by ramsan.of.borg with local-esmtp (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1sgLAf-000Md9-4T;
	Tue, 20 Aug 2024 11:28:57 +0200
Date: Tue, 20 Aug 2024 11:28:57 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
    Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com, 
    bhoomikak@vayavyalabs.com, Rob Herring <robh@kernel.org>, 
    Krzysztof Kozlowski <krzk+dt@kernel.org>, 
    Conor Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 0/7] Add SPAcc Crypto Driver Support
In-Reply-To: <20240618042750.485720-1-pavitrakumarm@vayavyalabs.com>
Message-ID: <2c9014b3-efd-101d-6fe5-4d436059c9@linux-m68k.org>
References: <20240618042750.485720-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

 	Hi Pavitrakumar,

CC devicetree

On Tue, 18 Jun 2024, Pavitrakumar M wrote:
> Add the driver for SPAcc(Security Protocol Accelerator), which is a
> crypto acceleration IP from Synopsys. The SPAcc supports many cipher,
> hash, aead algorithms and various modes.The driver currently supports
> below,

[...]

> Pavitrakumar M (7):
>  Add SPAcc Skcipher support
>  Enable SPAcc AUTODETECT
>  Add SPAcc ahash support
>  Add SPAcc aead support
>  Add SPAcc Kconfig and Makefile
>  Add SPAcc dts overlay
>  Enable Driver compilation in crypto Kconfig and Makefile

Thanks for your series, of which all but the dts patches have been
applied to the crypto tree (commits fc61c658c94cb740 ("crypto: spacc -
Enable Driver compilation in crypto Kconfig and Makefile") and before).

This driver uses device tree, but lacks DT bindings, which are a
requirement for new DT drivers.  So please provide DT bindings.

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
