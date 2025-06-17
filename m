Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B000C1DE3DC;
	Tue, 17 Jun 2025 08:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750149363; cv=none; b=CWuIfmftazZ2lWw4bzOI3X/xhqb4WgIch/IET1ca0g4j/X520ujznu0UWYHIZqKf/YXK72Y6qg75GNI1dv5WjPMAT1TYIYLV9IAI06LQaWaDHx/tow5bQmfMVYgPFNimwDvrjBoVX3T+1vfE7DPoeXz7CDLvQ1QJ/PfHOeyzz8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750149363; c=relaxed/simple;
	bh=ezz4lE7sCwKuZi/6AbszrayMOAwrhTX2escfHWD9cqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KqC/zpAzzJ39dW71OzGvMFm5mh5b3ZryhX2ZcBHfsGS8g3P/fO7EX0NlP2JuCLbqPmqOmJVN1nF8R/9/MITt4PC3bA0MeZI4FbSHDqeZPI55n7Wb58+IsF/wCSXLL/q9nToVyIEOKH2uhFMImRrCNRgNerS41HA3f5Y7jVHB6IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YeX9ppl+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YeX9ppl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00E1C4CEEE;
	Tue, 17 Jun 2025 08:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750149363;
	bh=ezz4lE7sCwKuZi/6AbszrayMOAwrhTX2escfHWD9cqk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YeX9ppl+usWZjhWaSTeH+L+G7OEmA3udghh5ZgbhiDYOx17Mfh+D7zqyst7zG3+lH
	 U9juUZPjvvoBUc38NeKuAFFzIt3fDwZApWktCldOhorMPoX8q3W01O54hzBDBmi19r
	 QgcalRNdhnqVd5ymrJn4kV6dD9UFTSWW4Tj9B7VJFsISJRbDzH5tZEjFzG3cXVGqLA
	 WgzByTClrkdSjnzssnVLf8AJ0mxWEvlwXLRaFxWX2Pr8uRy/JwHTXjUsGKHZR/7Row
	 ONtu7TXuCFbg40bo3zFsPs5cpNYMFkrF/PH9iv+CVGlm/dK5YDIqaabYpXpFhATQeJ
	 80q4+Yk8AFUSA==
Date: Tue, 17 Jun 2025 10:36:00 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Aaro Koskinen <aaro.koskinen@iki.fi>, 
	Andreas Kemnade <andreas@kemnade.info>, Kevin Hilman <khilman@baylibre.com>, 
	Roger Quadros <rogerq@kernel.org>, Tony Lindgren <tony@atomide.com>, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: crypto: Convert ti,omap2-aes to DT schema
Message-ID: <20250617-auspicious-wrasse-of-upgrade-cba30b@kuoka>
References: <20250611231047.1400566-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250611231047.1400566-1-robh@kernel.org>

On Wed, Jun 11, 2025 at 06:10:45PM GMT, Rob Herring (Arm) wrote:
> Convert the TI OMAP AES binding to DT schema format. It's a straight
> forward conversion.
> 
> Make "ti,hwmods" not required as it is deprecated and only used on
> OMAP2.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

