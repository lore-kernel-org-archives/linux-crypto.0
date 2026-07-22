Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD044C0433
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 10:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784714530; cv=none; b=kfb4Bt/sO6v+oFN2DY4MHcN0erSgI0gfxmCP6UpMzn9NyDJcFKh1B2hH/GbQzHzsTpK0BudpUZ8mZPcayAnVuUANSVec13vflJ7mwEvQApSol/CHA8eHL5Q5CjsRUmHoru5flVcQjG3LlDsU6pixlVB6QzbX8NQoPnakimOzhgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784714530; c=relaxed/simple;
	bh=lCWkUikEMVyXwdxL9Iyij/amNd+ieE4VUpm91dRStWE=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=m6FckdOSi5bvk/sNx59CIC15vUV5WlXX1E1kpAGvnXqLLBxkYbDywtPc3kp2hQbCvZLfav8ITRPX6FNFVOQ0V1OQ/GALaSFRe3HmlQfPypeCqu5Mz00o0p9pGnhmYVO8GO+u4PvoU+uQCUBNiBQXnmexy+d+bu1YizGgdVuinCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eIYRj02d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eIYRj02d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0611F00A3A;
	Wed, 22 Jul 2026 10:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784714525;
	bh=Q7BLW8X2n74rVaip6q/hEUpwxZvS8P1MI8U+IlSKB6A=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=eIYRj02d58PWkVC3OQKMgxTfoOIiSXvyf7SkUkhlSdPHyGQlKXVjWPAofS4EdgbSA
	 udJQLS+gvJ/ZEYmBrXWuKtgHrUPuk8FNGOoWyai9vu3WmTZ6FbcTNTojHgiZiCbb1r
	 2QXnwbKMqzey/rua/asguuNYmnpato4ivbLn4V3oZYqOiWP9OE4wGD6IWNS8nFHXuA
	 mozxatLOyKEUGWet8v693S8efjUo9wRGGF1vQYpr/O0NkY7xiiZbxJRc/hcjbU/H3V
	 aVVyD4LM6TzVDDFnzD3eEeLtUPYudh8/Xjx/M4Nr8ljBkcySXy0mReEnj7+/6De7yA
	 xl1/zQigNvKrg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 75053F4006C;
	Wed, 22 Jul 2026 06:02:04 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Wed, 22 Jul 2026 06:02:04 -0400
X-ME-Sender: <xms:HJVgaqDhNm1EFV8tcQKN69Qm9opHbmLt0sONwmDOglgaiirUbkTamA>
    <xme:HJVgavWkImrO1KziQ__-Qa1ioOC2fRvjLrtCDFbem6-xPoo7hKU30ssbRoEUl2iwr
    w9ul-6qUug3ES0DGRQuJBFN9_yHdX9q0vt7M0jcRLPyzTrc2x7mSg>
X-ME-Proxy-Cause: dmFkZTFMZATNrzP3LfdLOyisleNugli2MXU0ML3qp7+t8ZZMPYm3KTqjHSo2nzRpxJ/L8a
    0k36eaa6J18HiUb8lv9U3pn9FevzkRMSMTyfGEsEqKss1QUY6tYi+COLoVtG6ui4U5k9+L
    DQdn9KnawOH5sgQFpYrY/cRgATyYhgoaDd52eT6XW95pUqpwqffT5v8j8udoM7b2OM6WMA
    JCwOuM01d91/OG2OxRB7F9yDuX060APLYVw7hQuD1MXJOlSxcEoLrSBF/cEspZTJEvHbKZ
    TCoMoRMnD2Vb4HxOIQosASxzXIBxKNHlsDOX5CYa0nnPz+QQ4O/ARMqKMEAE4wjyNTkkib
    rMaMcYc7V3TVaBYQgAw3wMWoMnMeGX0shJiT552eImZhpJlnCdfXfQvt3VwQxpwuF5JveS
    2VMZ5IB/FfC/AAvRckI0tWS48TkQv1DsW9YR/1o6h99npPMNRl+V3xCOJJ/3l9/0oRftG1
    g+cB/3OOwNfmM7XYmCr9nFIBKyJU3QkP08zMJVS2kYW/JDcLZWQkZHrBk/V+akmVNGnVq0
    M6us1yaSVsxF2bIcqLCyEHJs+y4jHrCugKxoktzr7zjLvylzW/lvcBBqoysfDytWfLTYxu
    UdTZCS8SnHyOKUpxkvntX04o3r+oc8atPFZZrVoa8Qe4JdfzDUYH1+mT/qnw
X-ME-Proxy: <xmx:HJVgalil56HxhlZD-F_3rkzt_S2o6hyFyVZwPhiR5U2nyYr6KCr5cw>
    <xmx:HJVgatF3w_tzUgqxluGlUvO-yns1DRalcD6pHoD62O7OOGsm7PSGag>
    <xmx:HJVgavuhqd5QdgWWn790GM0MKdh8Qr59h-mefGBfBa-GL5SPOXpL1Q>
    <xmx:HJVgamfxJwyCQ3JGj1ns_mbOXs57RhXw6q2KLym93C-oeOdwHKo2Ug>
    <xmx:HJVgatm7mIBwHVgEo8jeFyYE6ChC5wg3G_pTuevetY716mNx_5iUAlFl>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 56620182007E; Wed, 22 Jul 2026 06:02:04 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 22 Jul 2026 12:01:43 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, x86@kernel.org,
 "Borislav Petkov" <bp@alien8.de>,
 =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>,
 "Alexey Kardashevskiy" <aik@amd.com>
Message-Id: <6ecb06b9-2543-4155-8ddf-4d58861a1cea@app.fastmail.com>
In-Reply-To: <20260722025338.33354-3-ebiggers@kernel.org>
References: <20260722025338.33354-1-ebiggers@kernel.org>
 <20260722025338.33354-3-ebiggers@kernel.org>
Subject: Re: [PATCH 2/3] x86/sev: Remove obsolete virtual address check
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 22 Jul 2026, at 04:53, Eric Biggers wrote:
> Virtual addresses used with the AES-GCM library don't have to be in the
> linear mapping.  Remove the virt_addr_valid() checks from
> snp_send_guest_request(), which were a workaround left over from when
> this code used crypto_aead, which required scatterlists.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  arch/x86/coco/sev/core.c | 9 ---------
>  1 file changed, 9 deletions(-)
>

Link: https://lore.kernel.org/all/20251010151036.42241-2-ardb+git@google.com/


> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index 54b122f6ef96a..cc292d7c6fd1e 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -1867,15 +1867,6 @@ int snp_send_guest_request(struct snp_msg_desc 
> *mdesc, struct snp_guest_req *req
>  	u64 seqno;
>  	int rc;
> 
> -	/*
> -	 * enc_payload() calls aesgcm_encrypt(), which can potentially offload to HW.
> -	 * The offload's DMA SG list of data to encrypt has to be in linear mapping.
> -	 */
> -	if (!virt_addr_valid(req->req_buf) || !virt_addr_valid(req->resp_buf)) {
> -		pr_warn("AES-GSM buffers must be in linear mapping");
> -		return -EINVAL;
> -	}
> -
>  	guard(mutex)(&snp_cmd_mutex);
> 
>  	/* Check if the VMPCK is not empty */
> -- 
> 2.55.0
