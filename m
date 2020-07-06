Return-Path: <SRS0=JF+M=AR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9FD5C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jul 2020 19:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CDA1206DF
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jul 2020 19:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594062440;
	bh=g+EcRxgNTaWqGbySsBDOrH0fzlI1OukJrP4d1xs4fZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=KDSMG1SufdAb6/bjFUdG3QxPVUIVNxgeamw9MfbslYBX5PhwAT4MnVg4n/by04O/z
	 MfrNCpT5yQuCLVCQhSUYifuNkwsPmrUt7Wexy0QRHUC5EI7+Ugppx/KROI5QVFwPTT
	 K7pZl0dbzQWJ7b4luONRVs2geCYtWbx7XgkfqdJg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbgGFTHU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Jul 2020 15:07:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725898AbgGFTHT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Jul 2020 15:07:19 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 437DF206CD;
        Mon,  6 Jul 2020 19:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594062439;
        bh=g+EcRxgNTaWqGbySsBDOrH0fzlI1OukJrP4d1xs4fZM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZE41gFeHlunj1Qe8qe+t/I7rfFakfgW69YjdbBOvLtAcRl0MZ0mWM/qFGKjptiG7B
         4M5mRMCxLhGoYmKBsQ29O386ErvbqMyg4XxGQ/Cbp37oVf2EzMFWuZKaJAgTKJTDhF
         Ffh4MIj0ESUek+0DbkmZrPp9V3IBoAGkvpRtMenk=
Date:   Mon, 6 Jul 2020 12:07:17 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: chacha - Add DEFINE_CHACHA_STATE macro
Message-ID: <20200706190717.GB736284@gmail.com>
References: <20200706133733.GA6479@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706133733.GA6479@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 06, 2020 at 11:37:34PM +1000, Herbert Xu wrote:
> diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
> index ad0699ce702f9..1d7bb0b91b83c 100644
> --- a/lib/crypto/chacha20poly1305.c
> +++ b/lib/crypto/chacha20poly1305.c
> @@ -94,7 +94,7 @@ void chacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
>  			      const u64 nonce,
>  			      const u8 key[CHACHA20POLY1305_KEY_SIZE])
>  {
> -	u32 chacha_state[CHACHA_STATE_WORDS];
> +	DEFINE_CHACHA_STATE(chacha_state);
>  	u32 k[CHACHA_KEY_WORDS];
>  	__le64 iv[2];
>  
> @@ -116,7 +116,7 @@ void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
>  			       const u8 nonce[XCHACHA20POLY1305_NONCE_SIZE],
>  			       const u8 key[CHACHA20POLY1305_KEY_SIZE])
>  {
> -	u32 chacha_state[CHACHA_STATE_WORDS];
> +	DEFINE_CHACHA_STATE(chacha_state);
>  
>  	xchacha_init(chacha_state, key, nonce);
>  	__chacha20poly1305_encrypt(dst, src, src_len, ad, ad_len, chacha_state);
> @@ -172,7 +172,7 @@ bool chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
>  			      const u64 nonce,
>  			      const u8 key[CHACHA20POLY1305_KEY_SIZE])
>  {
> -	u32 chacha_state[CHACHA_STATE_WORDS];
> +	DEFINE_CHACHA_STATE(chacha_state);
>  	u32 k[CHACHA_KEY_WORDS];
>  	__le64 iv[2];
>  	bool ret;
> @@ -198,7 +198,7 @@ bool xchacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
>  			       const u8 nonce[XCHACHA20POLY1305_NONCE_SIZE],
>  			       const u8 key[CHACHA20POLY1305_KEY_SIZE])
>  {
> -	u32 chacha_state[CHACHA_STATE_WORDS];
> +	DEFINE_CHACHA_STATE(chacha_state);
>  
>  	xchacha_init(chacha_state, key, nonce);
>  	return __chacha20poly1305_decrypt(dst, src, src_len, ad, ad_len,
> @@ -216,7 +216,7 @@ bool chacha20poly1305_crypt_sg_inplace(struct scatterlist *src,
>  {
>  	const u8 *pad0 = page_address(ZERO_PAGE(0));
>  	struct poly1305_desc_ctx poly1305_state;
> -	u32 chacha_state[CHACHA_STATE_WORDS];
> +	DEFINE_CHACHA_STATE(chacha_state);
>  	struct sg_mapping_iter miter;
>  	size_t partial = 0;
>  	unsigned int flags;

This changes chacha_state to be a pointer, which breaks clearing the state
because that uses sizeof(chacha_state):

	memzero_explicit(chacha_state, sizeof(chacha_state));

It would need to be changed to use CHACHA_BLOCK_SIZE.

- Eric
