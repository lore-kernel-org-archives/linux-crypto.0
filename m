Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [83.223.78.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18753F8226;
	Mon, 27 Jul 2026 10:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.78.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785148223; cv=none; b=aMdrrD1RnlGNRUKW9mcK/fkBVEz9PjMFLViLbq7Cjx/l9qvxRO3EhId+zitXLT45GgqUPt2vxfMkZYUWk6pZVO7kthlycyMczRkIhLrBcn4tdm9+L+gHh1xbN+ET4X1qC73gjODvRkPVElPCFhJtVoKMO2x3iayUqC5/ktvUl2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785148223; c=relaxed/simple;
	bh=iauf0BKp0xo+6DTgCLZADueg9gaLqPItW8OWe7jqZks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sUN32uELEkwPmkEsDK6kCo11VpWsB0QDvvXjHYuELC0XoaJSAR5ZVWa34RLX1t0IA0HbAbtvDWBBreq1KSgZX80roUTUt4GAcrwCeJ1l7cVnG7nCYJpahdMFyp//W90NTA8mApQBx1Yxj4TSxG5urRI21MctuvWcpiWHLb1tAAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.78.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout2.hostsharing.net (Postfix) with ESMTPS id 5978D10DF0;
	Mon, 27 Jul 2026 12:29:58 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 558FA60332E5; Mon, 27 Jul 2026 12:29:58 +0200 (CEST)
Date: Mon, 27 Jul 2026 12:29:58 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Doruk Tan Ozturk <doruk@0sec.ai>
Cc: stable@vger.kernel.org, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ignat Korchagin <ignat@linux.win>
Subject: Re: [PATCH 6.1/6.6/6.12.y] crypto: rsa-pkcs1pad: Don't WARN on an
 empty digest
Message-ID: <amczJhA6T8UcthZp@wunner.de>
References: <20260720191525.15450-1-doruk@0sec.ai>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720191525.15450-1-doruk@0sec.ai>

On Mon, Jul 20, 2026 at 09:15:25PM +0200, Doruk Tan Ozturk wrote:
> KEYCTL_PKEY_VERIFY lets an unprivileged caller supply a zero-length
> digest (in_len == 0).  keyctl_pkey_params_get_2() accepts the zero
> length and the request reaches pkcs1pad_verify(), where the empty
> digest is rejected but only after being passed through
> WARN_ON(!digest_size).  The warning is therefore directly
> user-triggerable, and on kernels built with panic_on_warn=1 an
> unprivileged process can panic the machine -- a local denial of
> service.  Reproduced as UID 65534 in a setuid sandbox.
> 
> Keep rejecting the invalid request with -EINVAL, but do not emit a
> warning for the user-controlled length.
> 
> Mainline does not contain this code path; commit 1e562deacecc
> ("crypto: rsassa-pkcs1 - Migrate to sig_alg backend") removed
> pkcs1pad_verify() in v6.13-rc1.  This is a minimal fix for the
> affected stable branches.  It applies as-is to 6.1.y, 6.6.y and
> 6.12.y (identical pkcs1pad_verify); the 5.10.y/5.15.y form is sent
> as a separate patch due to the older req->dst_len spelling.
> 
> Found by 0sec automated security-research tooling (https://0sec.ai).
> 
> Fixes: c7381b012872 ("crypto: akcipher - new verify API for public key algorithms")
> Cc: stable@vger.kernel.org
> Assisted-by: 0sec:multi-model
> Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>

Reviewed-by: Lukas Wunner <lukas@wunner.de>
