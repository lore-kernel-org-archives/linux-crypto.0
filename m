Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792551050;
	b=IrOzr34oget3EYrAuq9l7TMhyIhNG0ffNkNAaRTulLJiwh3VKagU/g+aDblUMFeL1vIZ
	 PlO0RUgnmUXFRFEZEIIks4/WJRRW5y2DP01gWFaA5Lkk3b272+Z6Kcslo/DmaXX6G5Bs/
	 9/rHLiVVlxtaYiAQgWQYZrag33IJGiojxep6o0T8Sl5pxrfZNb262ViBKtPdTPZbZtIBe
	 AC5rLeGF+Vpl7ehzQ53Ew+TVxhSKJ+YYlbZfzdTqbG9saEUM+WKe484ksoVUXbgUhnS6L
	 S7djfhVbH/E6MJyNgn9VOY2Hyzln/RWfsiqj7P+zMXXTh7aEfp8zZL4D+QmPoeQSHWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792551050;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=/BDUCV75ecZnIf7L+uEa+NmPiDbUKsl6LVs/lrdqGok=;
	b=aVqq4P5k9xF/J1fFhyZHB7EJwy2dFTm5uSPWM9Qsgm+NVXMp7eTssMUJuPPHOscddmFy
	 I6DrOUs/NIM6K3u78rUjVnhVKqg44WW32wI3JJoFzySKM4xFt9sQ7Y4928YpfFNU0nXSB
	 +I4j6gR73WzoJvVAXCvRO+nSbwLvxHuoaFVFrInzmABETCXqmmgU8wlW9jTOmm5lT8/2o
	 AAqf1Kmbq35ZrNii107Dd+l/kU9SQLvhcgUBopoRkYTyf6SXGfj3SNAUibteGZWwCCJaX
	 6sFl65Q7tQo7mgDQY022MM0PuCcIgBv85FgwLENyN4SNNgF/aGqqN/6ouC94pLYuHTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=benboeckel.net;
	spf=pass smtp.mailfrom=benboeckel.net;
	dkim=pass header.d=benboeckel.net header.i=@benboeckel.net header.a=rsa-sha256 header.s=fm1 header.b=Xy3RkWb+;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=Uz2Yaavz;
	arc=none smtp.remote-ip=202.12.124.148
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957C4606A31B
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 02:50:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 957C4606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benboeckel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benboeckel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=benboeckel.net header.i=@benboeckel.net header.a=rsa-sha256 header.s=fm1 header.b=Xy3RkWb+;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=Uz2Yaavz
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.stl.internal (Postfix) with ESMTP id ED3971D000F7
	for <linux-crypto@vger.kernel.org>; Tue, 20 Oct 2026 22:50:48 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Tue, 20 Oct 2026 22:50:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=benboeckel.net;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1792551047;
	 x=1792637447; bh=/BDUCV75ecZnIf7L+uEa+NmPiDbUKsl6LVs/lrdqGok=; b=
	Xy3RkWb+6LhY/fN6uWisXpOCPY5PMwCaPUAkEIS9JZPyJtSgvLgVDuCJduJR+P+R
	cZ2khCV88BgECOieOFbX7KWAxk3DtGwij6t8/1dPpPc0b/R9fokNNS9aCU1Ns7tw
	K9mb7wYSdJL5ucsGC2JrwIy4G1UUWnQ/b921MBlBNA7sQyJJLKo5481E2KOBZ0Zf
	1RLZLHNCMeoleSd0MYonVJCRtFXxnGwPNsCQy5nREIer9+FYJGF6HSD1Az5iYHFf
	0qAiNXDyFLKZV1LBCeXP9XiG6z52M2CbUKV8rpAtQkaQChz1ULKJqJV0MW/+6YJk
	TjsPnPpdZr+2ngk10RibEw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1792551047; x=1792637447; bh=/BDUCV75ecZnIf7L+uEa+NmPiDbU
	Ksl6LVs/lrdqGok=; b=Uz2YaavzGyxINWUTzPg1waBjqcfzkoKdv8vqMc6PIDFm
	bPYSk7GpZ8Jb4y9MyxQ4qk05szyy5MvkSzktig6AhZAe+OTLbZEg3Ntp3/gE7NyP
	v+g0T55mFvQR95LiET1jwksiKEKgqeGywieHIKvmBKMtDBHkj5Dk5BWvSum4ogQI
	vERsufnsqDL+etKN49i5d5wqqdXLBvr75dhzM12cKy3o9iVeBZG91x2ncDSKpda/
	M+Ddq+KWrJP3CcRg5FUNgo6LyIOuLWd2J2n65MYFrIMYSTOGuL3nEf8PESUxOJUt
	HKHBd+bVlNYOk+xXpyWVP7DWU7c4hakhAk/yLQMWRA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=benboeckel.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792551047; d=benboeckel.net;
	mf=PG1lQGJlbmJvZWNrZWwubmV0Pg==;
	rt=PGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm1:rsa-sha256:G3pJpyxCVsdNr6Rmc0yoPg84MXZTWoBxxJMmo9yZc/5uPuX
	yBZ5j3zZtvWjh4B+CTQLvGTHR39jOIwo1qLjdRgYG+u/7fD+A2TeZzE2p4+Hua5Z
	lIAjN8vHFhB1fFG3RE+a4G2+wrHlDJlH9yyV7Ju81wGbbMkTrOUwKWbBEzldcjp+
	lgLKZfAgr3A2N33Xvdb3ICc5KHD2j74G0axfw3kayWC7DNXIWZMyTtXJqJTgupke
	iSYiF26pPxULhsI0NLpmN7etqJy+s8f7U0q1BYw6dVLCvrzzYWFRRRJ4MUlB/sjo
	dYgarFu1+6/IUnQ3i/VPTuABgw+VwAMegeQlhgg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,reply-to,subject,
	to,user-agent;
Message-Instance: m=1; h=sha256:6jnct6a2NNXk6u0eIPv1rlZUTH6XS+zGMm316R32Guc=:sfDckac9qktk2NiIdiLnIKvK25r78Cban5dx0WaOIrw=;
X-ME-Sender: <xms:hijYaigcN-6hXr_PVZngWS-D8UEt3uiVBSneHXbbD0z13fS8ccoqUw>
    <xme:hijYamHuF8YPo6e8fFJkFiBwueYe9oYpwhs_WpfNhhtGIiGpOTPMic9ZdSg5r3mnl
    fNSYdY083DCClY_yBwqs_Ph1Fy63fRr1MtexYjQ0QgKot2FMvgR5-sF>
X-ME-Received: <xmr:hijYakt95RN4EjqmqG_qbFt3Bp0YWH7lDMT1ofnhy6i1W8X9Xoert6Mjew>
X-ME-Proxy-Cause: dmFkZTEX6teufzxfbx3q3Nq8vrCK28j75Fa5daFWBH0MBVYghVtw3ryevWqQZVyTIofoWE
    eJZ43bYcfl4TkW6ehRKXR8Hu2mJx20x0GBvs7nhM0Q4MIBFTgswbBawRdERJ8uo//5DTcG
    oridkpkRRatEzW8aaFOMGlnrvMTb3IozkCawqs/PbNxlj5TE2ye87Z2y0sT+H0meu1U/EZ
    VAxcyWySRuy7p/klLmELrcsS0K9wLpv0p9U3G7dFtxdBL1dc4f8XOEZoXvkQZ6men/yhlw
    AJO7Jynm8McCZKwO0DAdcQKO1PTnaN2xebK1HqKtOJjj2spRaH8Db24XET2cscA7mdhRRz
    xLVu2Vuf6rXjRL6WAFVFw1aazsy+cLTjxZs9sX9+UXz40n+QrYwgUQ8GqdkgDJrKOiJQOM
    MHfncNPrlllyW7hfHBBRAHZnedIfTyb025SzwsfQkTc+thld+8tcoJJvkefvsLcoBq2NI8
    UrjnA1PozaW4u7mw3IdUgrCdjwFbYOOpT+ZSHE8EjDrtEI5LNaX3/Mtj4j1RX+57upWhbG
    5Kg+s85OIA2WRv0HlxNRDeS1hxSXfJLNqVE/EMVmypIwd9dKVq1eV7fUa5bGDhbIMyjK9B
    piJOdqOz/FC291iBmxpc9NeX1IImTqL6LHoBi8KGF2qzW3oj5ZwgTctsOwBA
X-ME-Proxy: <xmx:hijYancybgvusLad9eU62CgDQhiL04qHdR3i8QBibjceLeZ0ikjXqg>
    <xmx:hijYaqnPtioQ37Q3wmWpAvTWg1jc8V2ynPqz63oRv2LFgtIfAr7L5A>
    <xmx:hijYaqBRpi6QaSyiQ66JVbOFaTBwirbfBRi7uckRKxTU7Db226OPBA>
    <xmx:hijYakNDIdN5dd9MibEIm4bmg-ThFoDcGCRwvNaFtRK6k_utrn3xYA>
    <xmx:hyjYakXBe-hlndAAnM7mVkXQSMKXigOIGTvdO8n2u3pyHrsH2jhUJxie>
Feedback-ID: iffc1478b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 20 Oct 2026 22:50:45 -0400 (EDT)
Date: Tue, 20 Oct 2026 22:50:42 -0400
From: Ben Boeckel <me@benboeckel.net>
To: m-amirpour <ampr.mhd@gmail.com>
Cc: keyrings@vger.kernel.org, dhowells@redhat.com, lukas@wunner.de,
	ignat@linux.win, herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: asymmetric_keys: Fix PKCS#7 selftest error
 reporting
Message-ID: <atgogp7ea-UCQLbO@rotor.dev.benboeckel.internal>
Reply-To: list.lkml.keyrings@me.benboeckel.net
References: <20261017210513.135540-1-ampr.mhd@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261017210513.135540-1-ampr.mhd@gmail.com>
User-Agent: Mutt/2.4.2 (2026-08-30)

On Sun, Oct 18, 2026 at 00:35:13 +0330, m-amirpour wrote:
> From: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
> 
> pkcs7_parse_message() returns an error pointer on failure, but the
> selftest prints ret, which still contains the result of the previous
> x509_load_certificate_list() call.
> 
> Print the parser's error pointer with %pe so that a failure reports
> the actual parsing error.
> 
> Signed-off-by: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
> ---
>  crypto/asymmetric_keys/selftest.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/asymmetric_keys/selftest.c b/crypto/asymmetric_keys/selftest.c
> index 98dc5cdfdeb..42857b02258 100644
> --- a/crypto/asymmetric_keys/selftest.c
> +++ b/crypto/asymmetric_keys/selftest.c
> @@ -41,7 +41,7 @@ void fips_signature_selftest(const char *name,
>  
>  	pkcs7 = pkcs7_parse_message(sig, sig_len);
>  	if (IS_ERR(pkcs7))
> -		panic("Certs %s selftest: pkcs7_parse_message() = %d\n", name, ret);
> +		panic("Certs %s selftest: pkcs7_parse_message() = %pe\n", name, pkcs7);
>  
>  	pkcs7_supply_detached_data(pkcs7, data, data_len);

Reviewed-by: Ben Boeckel <mathstuf@gmail.com>

--Ben
