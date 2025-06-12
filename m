Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56811E487;
	Thu, 12 Jun 2025 07:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749713619; cv=none; b=p6SgpaC8aXlAPsPLMVlqmva3HGu/c3gXNUb6gpfQGyr5nkWTE8zPm13VlZvhvAQkzJnBEN5hzAQHMjkf+9e9ub2ol5KdlA46ll3tyEOh2i8SBUxSulCtlEz+5+vdJ2v4iVKjTAFeX0sj1qFjR0/DwkHxJmqKT3AeyOR1aeBXG3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749713619; c=relaxed/simple;
	bh=eMVf5i/rjXCwUDBunHluaNYVd2aReIzEbyrk/akS6SE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OrphBWs7N7FLeLAvWxg0G/QAYMyM6VYuo2tdkHlkrxnuRpyiTuv4j5Vm/l3IxFOGWuqpQK1KVA9jhboaMOd2BPVH5HFdUgkT7ZZUqoevzD0axjKO9exhioGSd7dtLG7p1J3Tu0WUbNVklC3BW02SQz2qXL6hbY4/YTEhJUwBz/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nIkEpOh/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nIkEpOh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D83C4CEEA;
	Thu, 12 Jun 2025 07:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749713619;
	bh=eMVf5i/rjXCwUDBunHluaNYVd2aReIzEbyrk/akS6SE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nIkEpOh/leHSAK/TmibTxoCw4LzvIZXA+elH9JggWfUGlAmGa/hCrKKiqM6/2FZnC
	 fM4ny4Lk2eimLk0NqGFpddofiaSaKKdKHL7yL0eRsWEnnxxTA5eKBUZ2YxZSc7bCmK
	 PnSAbKvcu81kRWQHx2YSELgpC6RfyF+qRR930MEg4sVi0FD1yYXM4tA5QOi+1WrDws
	 rEAygblHNaHdxRJdymugTgajQGLK3z39vXhArXjSdB9YkVBfuTswZFW0Mw4Pf0fZ4N
	 rr8ep5j6M2AKyqxLLL4EvEyPN+eyGSM2vykSGHEVfDnjayMP3ZRNb1kV+IS0gYPUrN
	 N0dUPBUyACviA==
Date: Thu, 12 Jun 2025 09:33:36 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Ryan.Wanner@microchip.com
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, nicolas.ferre@microchip.com, 
	alexandre.belloni@bootlin.com, claudiu.beznea@tuxon.dev, olivia@selenic.com, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/10] dt-bindings: crypto: add sama7d65 in Atmel AES
Message-ID: <20250612-economic-teal-nuthatch-30dcad@kuoka>
References: <cover.1749666053.git.Ryan.Wanner@microchip.com>
 <7aa1862f790ea19bf7bb55e07ec4b9295c5f7a44.1749666053.git.Ryan.Wanner@microchip.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7aa1862f790ea19bf7bb55e07ec4b9295c5f7a44.1749666053.git.Ryan.Wanner@microchip.com>

On Wed, Jun 11, 2025 at 12:47:25PM GMT, Ryan.Wanner@microchip.com wrote:
> From: Ryan Wanner <Ryan.Wanner@microchip.com>
> 
> Add DT bindings for SAMA7D65 SoC in atmel AES.
> 
> The SAMA7D65 similar to the SAM9x75 SoC supports HMAC, dual buffer, and
> GCM. And similar all 3 it supports CBC, CFB, CTR, ECB, and XTS.
> 
> Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

