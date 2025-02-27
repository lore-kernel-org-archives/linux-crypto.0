Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA75222D4FA
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 13:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740661208; cv=none; b=EQmMdiGwl5Y9UPsk7PUIH1J0XmGtb5jdL+T4CNTcRr40Eg/lDYCM/0Wf+bHL3nd/Ov+kcWsXqJSwiJ7FTX4mUnG+yK70/jZD5apulrfmUJmQnipXcXVRxuREKJ+rHw+wLh5LrrmItOII9d1rO9kxXHo/mqgmgsrM32lZ4Y2GXZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740661208; c=relaxed/simple;
	bh=mnBUHzltagblEitbUoVb0HA3aYVS8Ooboc5YSTNBnys=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=tHjDckH0O6oaDUO2SJ7WqiYAHpINfoR03H7OqPH+JoDyF+rPWBnvk6A5oofaSoTefqD2vhl3F8MUqqrMO+PXfIRSpAb33qwDc7B41FbPL8vlhVpOiqq5teWQ7PfXCFh5ozRaL1sa7Pqv3RUgMO79fYg0O+cLABJ+S1GU83rsDpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=qvIJuwp5; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=uTBFUJob; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="qvIJuwp5";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="uTBFUJob"
Received: from phl-compute-11.internal (phl-compute-11.phl.internal [10.202.2.51])
	by mailfout.stl.internal (Postfix) with ESMTP id A8A69114017C;
	Thu, 27 Feb 2025 08:00:04 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-11.internal (MEProxy); Thu, 27 Feb 2025 08:00:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1740661204;
	 x=1740747604; bh=SiqToDuurU/KwaGIorSxKLL//+SzSxWT1VcljdaRjVA=; b=
	qvIJuwp5YsYtOLVNz+OVVJaCqsZtHcg7NMklJc+0aVtVDyTxFun0dhV8GPMjqajZ
	X82c0t7BrKwfvmRP2U4SJQ4QJB5AUNIs34t2/byTamtAoiSflEBUOc6gT/+zBAQD
	erjjEWx5NlGAOgX1Z1lZ3oZXBge2IlwI5WCA1aN9mksZl9AdyOjE1qCwiTDusju2
	dBctgkcFF+gjRqLkc8UqD8P7bkGAa60o0rqXa85Vb2WoW1S1YtFGLCfEoMftXS6u
	g3uFLZetZnBt5Wu+us/MkHu9gnpXB6oBhIr3acG45UC94YZnlyvumAXjs9WD7yZa
	Ar8paYjbQNuPHXRz4PTXIQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1740661204; x=
	1740747604; bh=SiqToDuurU/KwaGIorSxKLL//+SzSxWT1VcljdaRjVA=; b=u
	TBFUJobLpVrCb5puRjONQ7xevO9klSC07GY9Z3FGo8/w3vbtObMnfg1L41aX3+Wn
	ZI6kDbzpU1NFaQ46pIOKh0zCoHxW1OUCpccspEXOapV2F48EMGn2NLil/QhLnN28
	fDtmOpd4ODugGa7C/K+3fEnOPpLNJUq3Ytd0QPazoYSX1TJ9bMwM6ZUdR7tLJRqs
	UONSWE+ulbPRm+bYwsSGd0gaJHkA2BjtuD6DYbk8U987sPT+h7n5PfuCq7k5rUCC
	UZJA06Os4YsaBfP9sjWszYFFuYDxBMDjcrIbJ7+QMZLhxLLNBIgdHhkInqaRwNn4
	3MpeIM3VTzd0pISUsKHAQ==
X-ME-Sender: <xms:02HAZ1Ld9PTCfymYN7axwERUUOTGo8IEzwWFEtK0l6qSxPzU_LvtgQ>
    <xme:02HAZxIEqLZuawMYzycLIwJijE2Jd49UmcxT_qf2FFp8oqyf4sHzXI2DTYuT4-FDb
    WpLhxh5uMSn2jT6aZc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdekjeehvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthejredtredt
    tdenucfhrhhomhepfdetrhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusg
    druggvqeenucggtffrrghtthgvrhhnpefhtdfhvddtfeehudekteeggffghfejgeegteef
    gffgvedugeduveelvdekhfdvieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgtphhtthhopeeg
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehhvghrsggvrhhtsehgohhnughorh
    drrghprghnrgdrohhrghdrrghupdhrtghpthhtoheprghruggsodhgihhtsehgohhoghhl
    vgdrtghomhdprhgtphhtthhopegrrhgusgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    eplhhinhhugidqtghrhihpthhosehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:02HAZ9s_Kg2-p1uAvdRT41ao0o8DCd4wbIjrfRcaVxgxmftgXs9d3A>
    <xmx:02HAZ2ZeI51_JSCjnSsbI6x0RAvx_n7pc-zchdONXxYgGgY_gN1esw>
    <xmx:02HAZ8aZKmVD-YDFL22vciQ_b2tKVgINmatuR8S-bsflHqrn7NSo7g>
    <xmx:02HAZ6D5uVBUDh0ZXue9rXZEVTCRAb-l6DpjvRvdcL9GHt6y_T9bRg>
    <xmx:1GHAZ0Hzy0PvP9Lmm7ch5ukz1Hsa9yUZhUSuo8aPo4xy7Sqmv15tww4G>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id A52112220077; Thu, 27 Feb 2025 08:00:03 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 27 Feb 2025 13:59:42 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-crypto@vger.kernel.org
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
 "Ard Biesheuvel" <ardb@kernel.org>
Message-Id: <89944059-872e-4013-a025-f01d6d2f51cd@app.fastmail.com>
In-Reply-To: <20250227123338.3033402-1-ardb+git@google.com>
References: <20250227123338.3033402-1-ardb+git@google.com>
Subject: Re: [PATCH] crypto: lib/chachapoly - Drop dependency on CRYPTO_ALGAPI
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, Feb 27, 2025, at 13:33, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> The ChaCha20-Poly1305 library code uses the sg_miter API to process
> input presented via scatterlists, except for the special case where the
> digest buffer is not covered entirely by the same scatterlist entry as
> the last byte of input. In that case, it uses scatterwalk_map_and_copy()
> to access the memory in the input scatterlist where the digest is stored.
>
> This results in a dependency on crypto/scatterwalk.c and therefore on
> CONFIG_CRYPTO_ALGAPI, which is unnecessary, as the sg_miter API already
> provides this functionality via sg_copy_to_buffer(). So use that
> instead, and drop the CRYPTO_ALGAPI dependency.
>
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Thanks for the fixup!

> ---
>  lib/crypto/Kconfig            | 1 -
>  lib/crypto/chacha20poly1305.c | 5 ++---
>  2 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
> index b01253cac70a..a759e6f6a939 100644
> --- a/lib/crypto/Kconfig
> +++ b/lib/crypto/Kconfig
> @@ -135,7 +135,6 @@ config CRYPTO_LIB_CHACHA20POLY1305
>  	depends on CRYPTO
>  	select CRYPTO_LIB_CHACHA
>  	select CRYPTO_LIB_POLY1305
> -	select CRYPTO_ALGAPI

I think importantly, dropping the 'select CRYPTO_ALGAPI'
means that the 'depends on CRYPTO' here can also be dropped:
CRYPTO_LIB_CHACHA20POLY1305 needs nothing else from the
crypto subsystem. Moreover, CONFIG_WIREGUARD can now drop the
'select CRYPTO' because it seems to only need this in
order to 'select CRYPTO_LIB_CHACHA20POLY1305'.

    Arnd
