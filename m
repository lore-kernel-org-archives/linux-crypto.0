Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1743DBD57;
	Mon, 13 Jul 2026 09:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783933329; cv=none; b=NgsswUFhKnldLe/6CQVWy9fYj752LFsOF4rC7ZvF/qtg5a3x2Lg4a2b+y+R9qPZwYENXRpiGCkTZkeeGB2U3gqbWRCPQAAmPnQoC1FiD88PHPutt7t/3JbhZWIhvdp2quGhT+JDfHqy2+71aj3Pkm2LcqMuFTXG0KG89J+ksRNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783933329; c=relaxed/simple;
	bh=6EXhuE/eB04dFZzHnTVbb+fqxi2+QFcuE2hXEjUmVQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IscPK2YTXKnLTboyzxYSIplQqQqdBJ7q4YocsyhXk61u88q1UrG9QF9/hC3C3OtuixwaNPmYPn8fgtB55thf7rOJs9CmfTs3u2QpnOC8QX8fO0PR7JY/nJx+HbKjDLvDvG+GJ/CGz6bpRlqGa1Nn7T8eT8ZYZ5uQMRyJevTl9Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=IH4bU3lK; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="IH4bU3lK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BNwiur73z9ZKcEaSTwnm4ubr4IDbGUdhOCGvro4ilfc=; b=IH4bU3lKTM1jxZaX9RsJ5oLPux
	VI/tfUrEZwRmRC5tVk7HEG19DkT6jjmtNtggiVf8pUC6vzhWBqry4oapulR8lsoo7iBhEUrhxtXSG
	GJCOxDAmNWB7rJqXgE0bP4Igcie7bmEMlOfdJ5JP9V/BAutaWM9gRAGO+urpk0LzrplbuGjG+6UQA
	/8Wg+2pYmI3jIzIcE1707purm0DLOPEHLImlkbseEvuVJswN5pnUEuFN60cKOpISVoikL/XUo7NYi
	oBuoXdFNsmDRZgYL04AGTIWFoPezklWxvG9/+mvjTt460aEhGys4r9/ueY6bcz3EUy5DR7xQ/+J/A
	vWR7R3jQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wjCXk-001O5g-0O;
	Mon, 13 Jul 2026 09:01:40 +0000
Date: Mon, 13 Jul 2026 02:01:34 -0700
From: Breno Leitao <leitao@debian.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Nayna Jain <nayna@linux.ibm.com>, 
	Paulo Flabiano Smorigo <pfsmorigo@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: powerpc/aes - use bool for encryption/decryption
 flag
Message-ID: <alSpYVYCcT_D4V8K@gmail.com>
References: <20260711145216.747128-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260711145216.747128-3-thorsten.blum@linux.dev>
X-Debian-User: leitao

On Sat, Jul 11, 2026 at 04:52:17PM +0200, Thorsten Blum wrote:
> Use bool for the CBC encryption/decryption flag passed through
> p8_aes_cbc_crypt() to aes_p8_cbc_encrypt().
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Reviewed-by: Breno Leitao <leitao@debian.org>
