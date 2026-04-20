Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D103845A0
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2026 09:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776676965; cv=none; b=kYywa2vSg2hn7jFWImtRrOi3vMyHNMvnNKipGGKJtpSB1dC0BgWzk9fwqYWkR260JTitBnaC9SVXyTiXBhWwbU7/dpDyoYKGdzzn7SanWKSF6ZW/Cpp/YObBrC+4jbJkXhRvRFmUS75jh55eC9RAG7fvHI7TXPOjaEDZLpevtfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776676965; c=relaxed/simple;
	bh=yonIjZYbeg+myvDfJIko4hPaHXGOBbgXymT25RYqE5c=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=gtBlRofmwGb3CoE7D5nammGMaeDzZJ3e5I2PoENbg94bsiYQb4fVR6Bu8yLcE905JrG01V1EaFJ5YdrWV6NUcsheWEFT1QZIfMnSY3UJydm3DxmjhAjrKo/jKIvC1gSjT3QqRfzxWDvyQvJChVvZ8Wars3vjecXDMr3nNLGvQBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NwwFSE5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NwwFSE5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17C9C2BCB3;
	Mon, 20 Apr 2026 09:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776676965;
	bh=yonIjZYbeg+myvDfJIko4hPaHXGOBbgXymT25RYqE5c=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=NwwFSE5bjfkHxVsvEvKhUVGSE8E19gG34FQnbYAkgCPR2qm8si+tO6bSMz1nsaOrz
	 5//wvjKW5BoxIEgA1KDgfBz/eFAWZn9Rg8QrPjOI/fEZbxXRIrlC9wjLkMfCKbNl5V
	 Qo/DpCvTilj2bIVczYQdMSqPDLW8rYvl5bKk6weh1z+dzp/ODttzfHGyq1EN4pEGQu
	 HbAw+logpikVu4xUWTqrcorFyh4iqnN+LxDzzrAMvYAjWKASHMoRBE/96uT777H7ag
	 xXDljtlD3X20BnCH0egOTW9oDxyTkjWfWIthn6hY6vLyiXiTqTTq2i44Qr3cOrBgVp
	 VNnouxXEWQgaQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 91CE7F40068;
	Mon, 20 Apr 2026 05:22:43 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Mon, 20 Apr 2026 05:22:43 -0400
X-ME-Sender: <xms:Y_DlabiwMoLakQ_fGFytyW4FAEDJ4iV7cAvNOXhRrhRmwP3lw5hCQw>
    <xme:Y_DlaS1iiU8DZWgMWWKRool5DpR1PbwKU--YsnvUevL_0DibRbJkxvPll13AcM_4d
    ypL2MFiZ073YZLBGtdOWOqeJD4CB9tZy7-NGlXM931cC2jUFuAkaQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdehkeduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepvdeuheeitdevtdelkeduudetgffftdelteefteevjeevjeeiheefhfejieej
    fedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeijedthedttdejledq
    feefvdduieegudehqdgrrhgusgeppehkvghrnhgvlhdrohhrghesfihorhhkohhfrghrug
    drtghomhdpnhgspghrtghpthhtohepuddupdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhrtghpthhtohepkhgrnhholh
    ihtgesghhmrghilhdrtghomhdprhgtphhtthhopehtohhmrghpuhhftghkghhmlhesghhm
    rghilhdrtghomhdprhgtphhtthhopeihihhfrghnfihutghssehgmhgrihhlrdgtohhmpd
    hrtghpthhtohephihurghnthgrnhdtleeksehgmhgrihhlrdgtohhmpdhrtghpthhtohep
    iiduieehvddtjeeggeefvdesghhmrghilhdrtghomhdprhgtphhtthhopehhvghrsggvrh
    htsehgohhnughorhdrrghprghnrgdrohhrghdrrghupdhrtghpthhtohepvggsihhgghgv
    rhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopegsihhrugeslhiiuhdrvgguuhdrtg
    hn
X-ME-Proxy: <xmx:Y_DlacgZ1BizdKKcToTPU5wpe0YqKFlDn6rOCcDAlsiD_akZGoxrUw>
    <xmx:Y_Dlafe3cR8OeWdbQhY-aCpUKTK8Xu7SK_0wnXaEPVgzI4U3KP99xA>
    <xmx:Y_Dlabm80arKZIzzr62vpaw7YrB9CMYib7gFCAumM9rfQ8yuE8n-Kg>
    <xmx:Y_DlaUyyVxAWn1HM3xXOtlfSJ4B9LII1i_tv-q3VM5ourH96IF1CJQ>
    <xmx:Y_DlaezRBGvn-TcbPDUQ5ChApxrMf8PE9vkmn-pGGKIkWGoJaHQQuK7_>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 6CFF9700069; Mon, 20 Apr 2026 05:22:43 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 20 Apr 2026 11:21:54 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Ren Wei" <n05ec@lzu.edu.cn>, linux-crypto@vger.kernel.org,
 "Eric Biggers" <ebiggers@kernel.org>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, davem@davemloft.net,
 yuantan098@gmail.com, yifanwucs@gmail.com, tomapufckgml@gmail.com,
 bird@lzu.edu.cn, z1652074432@gmail.com, kanolyc@gmail.com
Message-Id: <fd3a1c5d-8ebf-48de-91a0-019b05f1dc41@app.fastmail.com>
In-Reply-To: 
 <cb1188757edab9b056961d4d2441be009ac73ce8.1775217403.git.kanolyc@gmail.com>
References: <cover.1775217403.git.kanolyc@gmail.com>
 <cb1188757edab9b056961d4d2441be009ac73ce8.1775217403.git.kanolyc@gmail.com>
Subject: Re: [PATCH 1/1] crypto: authencesn: reject short ahash digests during instance
 creation
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

(cc Eric)

On Mon, 20 Apr 2026, at 10:48, Ren Wei wrote:
> From: Yucheng Lu <kanolyc@gmail.com>
>
> authencesn requires either a zero authsize or an authsize of at least
> 4 bytes because the ESN encrypt/decrypt paths always move 4 bytes of
> high-order sequence number data at the end of the authenticated data.
>
> While crypto_authenc_esn_setauthsize() already rejects explicit
> non-zero authsizes in the range 1..3, crypto_authenc_esn_create()
> still copied auth->digestsize into inst->alg.maxauthsize without
> validating it.  The AEAD core then initialized the tfm's default
> authsize from that value.
>
> As a result, selecting an ahash with digest size 1..3, such as
> cbcmac(cipher_null), exposed authencesn instances whose default
> authsize was invalid even though setauthsize() would have rejected the
> same value.  AF_ALG could then trigger the ESN tail handling with a
> too-short tag and hit an out-of-bounds access.
>
> Reject authencesn instances whose ahash digest size is in the invalid
> non-zero range 1..3 so that no tfm can inherit an unsupported default
> authsize.
>
> Fixes: f15f05b0a5de ("crypto: ccm - switch to separate cbcmac driver")
> Cc: stable@kernel.org
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Yifan Wu <yifanwucs@gmail.com>
> Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> Reported-by: Xin Liu <bird@lzu.edu.cn>
> Tested-by: Yuhang Zheng <z1652074432@gmail.com>
> Signed-off-by: Yucheng Lu <kanolyc@gmail.com>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> ---
>  crypto/authencesn.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/crypto/authencesn.c b/crypto/authencesn.c
> index 542a978663b9..bf44f035f7f8 100644
> --- a/crypto/authencesn.c
> +++ b/crypto/authencesn.c
> @@ -384,6 +384,11 @@ static int crypto_authenc_esn_create(struct 
> crypto_template *tmpl,
>  		goto err_free_inst;
>  	enc = crypto_spawn_skcipher_alg_common(&ctx->enc);
> 
> +	if (auth->digestsize > 0 && auth->digestsize < 4) {
> +		err = -EINVAL;
> +		goto err_free_inst;
> +	}
> +

Is this the best place for this check?

