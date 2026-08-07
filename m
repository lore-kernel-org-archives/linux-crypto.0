Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EE9376A1B;
	Fri,  7 Aug 2026 22:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786141354; cv=none; b=lGUN7qBOWtZK4vcRHscELkEPQHqoM98XAa6X8oMFkbYa27BmdygSE2+hO1kR04KCcLR+9no89ybkYg9PJD5Omsvl8SMxR6yvFaKsAnZm+i7+qGgq/nhxr9mCB0uzbNWqULjle4xZ8+hQu7KzzZshzUj8qnoGFk5fI8GRgAkd18U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786141354; c=relaxed/simple;
	bh=tZBzml8Fw5L4Xn/55Noe+tck+4gGckfNXQ52G76MiVw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F4/9kwYfd0JxvIunO1kPEvquX/Tb9+auPoxB0JAkjo9leOaQI3vzUs4J4X+DyeZ6tTooLoa93izgLoUMLdfWYwELMGkUCTaEeRF0ZufWVH6Qxf2f31XcX0HynlJVx+oVj8rkceqA/x1xYydsLVcNSAf7nFSBR3bM/7WWufsn+y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VT0pPqu6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VT0pPqu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E531F000E9;
	Fri,  7 Aug 2026 22:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786141352;
	bh=RQ7rhgB228BSgQ2eMeueLs7EwanBtWfovMtCVsvv++o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=VT0pPqu6SdZ6kIMCMoAIAFlwsB4VFGcoYIeH9oczqRldg1Fmfr1aZ1MIzfFqfSzWm
	 I/Rm3C8uJnBjNDCLZegErzch1hPx2HSbETd2UNeUda5d/NVH4Vd4+AF8v3YI7MWddp
	 q3S0ljHuF10Cxx8BWZcgKT/Nv4v614lqnlUMt8Pa2M1bQGZS11/kluBouWfFYkwLny
	 /q7WGIkJmbtoxlKjluxX9OY3pySUcw+BtM5w7pIUokmdNYGL38fE+QGiP2AirGT2eE
	 f83FDbGtQ4iG4M0tpm3NoYSvLd6YWJaZaUR6Tirwo0cbQRoGvrDhFCfcqOy1z5eCrg
	 hgSqK662sl+IQ==
Date: Fri, 7 Aug 2026 15:22:31 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Eric Dumazet <edumazet@google.com>,
 Neal Cardwell <ncardwell@google.com>, "David S. Miller"
 <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Steve French <smfrench@gmail.com>, Namjae
 Jeon <linkinjeon@kernel.org>, Kuniyuki Iwashima <kuniyu@google.com>, Simon
 Horman <horms@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 3/6] net/tcp-ao: clear the aes_cmac_key when done
Message-ID: <20260807152231.15b33daf@kernel.org>
In-Reply-To: <20260807125845.1477067-4-thuth@redhat.com>
References: <20260807125845.1477067-1-thuth@redhat.com>
	<20260807125845.1477067-4-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  7 Aug 2026 14:58:40 +0200 Thomas Huth wrote:
> -		struct aes_cmac_key k;
> +		struct aes_cmac_key k __cleanup(aes_cmac_zeroize_key);

Nak, we don't like the auto-cleanup stuff in networking.
If y'all need a garbage collector there're jobs programming in Java.
