Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69651433CB
	for <linux-crypto@vger.kernel.org>; Mon, 27 Jan 2025 16:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737996843; cv=pass; b=cwXKu2RnP6cfeJd4Ubo3mRrrel1NwI8LgAieWW+fDd5SBjEv4JiTjnHO4ee+086Vt7rR67Od9dkLY0GAUZCvIcUJIg/BG5vvXczci5DIbqPTaSiWaDAj4wXXh73ma6CW6pZz4AAzGdnEjOsk+76WGCTfL8E7t9owNYq28RuHaG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737996843; c=relaxed/simple;
	bh=PjJIxtAeDXDUjijkocX7Y5ycRoDLahMjT8xXVDO72Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eHamH6hg1Ev3UG5tE8sFvkXO7r6vQdhgKvqvKpYirTIH1Qy85BuQM6dxgPfe6v4ro5YsSHyIUBiGJorFvQioqOuEAfuUi7IK+NUuDrF2P8bx0C17CP+ONCAJPLV5yEs913IOB5CA4wEDAIO/1GXKBaHgZJGwNogPROT23ABBRDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chronox.de; spf=none smtp.mailfrom=chronox.de; dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b=rtZpClXi; dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b=x2OFYNxu; arc=pass smtp.client-ip=85.215.255.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chronox.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chronox.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="rtZpClXi";
	dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b="x2OFYNxu"
ARC-Seal: i=1; a=rsa-sha256; t=1737996656; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=TwhqGrt0sWUGE61LfDuGI07qIweqZjiQhrfcqGMeJQwFF9sLk+iJZ/miE5fBRQij5X
    iTu7BxBG+NRS4KyJ+ZVEQniWUXgvM0SZ0373TkOI3dZO/OvdX36MPkVFkyKe6hm1IjTS
    vGR78FHcEaXgFEq16fP7gGzKJDWi5Z1vA3dbYmsRRBkRk9NvwV94+JGuF44NZE9xm1I8
    v1LfRt5qZvBiLGihNAJP2yneI1gpmwZIB79wk9Hgh4MrbPGX8uRsxCOPelqjI2eQ4GFQ
    wDIOPltMSvEky9pFsZIu2IPROtloJ9156BrF05Fxqwouew+S2YX/ac4T+hiuc1M86+yO
    SfFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1737996656;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=fdv42ZOGO0h9dSMCl0Z6TuNxjRUhqaDKZgTq7avgw/I=;
    b=kUD3mDknBlTLrY2VGsj9pIMzRLgEcr3f9PayhCgArtnjoifG53219M40RJj9LdFBze
    dQqwZ4QuHJ38NKpyd+zP9CswP2s4qGj5F7q8+RIMIyiTyU0K0asLluYV5Ptc9e6OGrfW
    dwwzYPYCPF7KjLkLqpoNMALnCchOLgSR2b9k4QxRiN9cceWFlNiG4MdS5IV4z0TgBEZY
    7tPMzRURaWFrUfJsahmruyEFfMoMpZ8kdNbN/U/Wo+uoiNx9ktkjnbyQJ8g/VCuhCj0N
    Z1e4xE6oT8r73kFVWl0ze2shQjemydy7v5ENCnDrXlt4TiwGO9ADVIXthR7XET/1N464
    eZGQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1737996656;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=fdv42ZOGO0h9dSMCl0Z6TuNxjRUhqaDKZgTq7avgw/I=;
    b=rtZpClXi4vle49Imzy+0jTfR6vKPti//iDeuoGph3ETbVYTI148/mutkFoDw/Y8l1a
    LmPjHuWceIPfc7zB/wNjm7MIoYz93qLCVR4fu/jsn4ZsEd8b0MBoBiuXw3o2TWNGAH3V
    h7IjO8MQtlnAlDKRHe8SfGkKoUWRBTa1TVg37u9U1tq6VNOsMTJcdG93BRKAPRLeSvkm
    DHHGDCsikQlUXLcT7Ow5RAuGtv4o/VP+bNHhGyio3nUfJKSjs/g503Xtl0p6IaAYY6ar
    2jL0kH5gasaWzXJh5AHnDlMlRisCYNhI5Qfq6GZyLvR2S78a6aEilRSnLPuJXCnOeLjH
    LHpw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1737996656;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=fdv42ZOGO0h9dSMCl0Z6TuNxjRUhqaDKZgTq7avgw/I=;
    b=x2OFYNxuSdu8OjSwlcHLzbGMr5m0ksO8FHiHsbEjIgt8MitDInQHsq+u2aLnPEEpO3
    5C7TvMXe5ooDGqzXbzAw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzHHXDYJPScjek="
Received: from tauon.localnet
    by smtp.strato.de (RZmta 51.2.17 DYNA|AUTH)
    with ESMTPSA id f18d7d10RGotEXI
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 27 Jan 2025 17:50:55 +0100 (CET)
From: Stephan Mueller <smueller@chronox.de>
To: linux-crypto@vger.kernel.org, Markus Theil <theil.markus@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
 Markus Theil <theil.markus@gmail.com>
Subject: Re: [PATCH] crypto: jitter - add cmdline oversampling overrides
Date: Mon, 27 Jan 2025 17:50:54 +0100
Message-ID: <5742149.hdabSGCPeI@tauon>
In-Reply-To: <20250127160236.7821-1-theil.markus@gmail.com>
References: <20250127160236.7821-1-theil.markus@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Montag, 27. Januar 2025, 17:02:36 CET schrieb Markus Theil:

Hi Markus,

> As already mentioned in the comments, using a cryptographic
> hash function, like SHA3-256, decreases the expected entropy
> due to properties of random mappings (collisions and unused values).
> 
> When mapping 256 bit of entropy to 256 output bits, this results
> in roughly 6 bit entropy loss (depending on the estimate formula
> for mapping 256 bit to 256 bit via a random mapping):
> 
> NIST approximation (count all input bits as input): 255.0
> NIST approximation (count only entropy bits as input): 251.69 Bit
> BSI approximation (count only entropy bits as input): 250.11 Bit
> 
> Therefore add a cmdline override for the 64 bit oversampling safety margin,
> This results in an expected entropy of nearly 256 bit also after hashing,
> when desired.
> 
> Only enable this, when you are aware of the increased runtime per
> iteration.
> 
> This override is only possible, when not in FIPS mode (as FIPS mandates
> this to be true for a full entropy claim).
> 
> Signed-off-by: Markus Theil <theil.markus@gmail.com>

Reviewed-by: Stephan Mueller <smueller@chronox.de>

Ciao
Stephan


