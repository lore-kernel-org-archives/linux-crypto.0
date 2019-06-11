Return-Path: <SRS0=vn8P=UK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	T_DKIMWL_WL_HIGH,USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B1B6C4321A
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 17:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7263F20896
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 17:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560275663;
	bh=WOLzjtOo0cPYBq8H9pJ7UXlbpV/3DfejycQDMklAFrg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=t7q4dkLUjtbKNE8gCcjdcs1ALWJQgWOY03xUEx00m0eMQKqviAOYtwexq46OG1wcL
	 DSzYJLlvq6lCDngkJJQcUwKwYKOW7nKDiXPjORt0dc+beerKq8FQq/D4dcoB2D96lA
	 aFFchV9pkdt1C6d/KIQm9sh/fMbxc/MoEKhcxP6A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406612AbfFKRyW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jun 2019 13:54:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405972AbfFKRyW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jun 2019 13:54:22 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB2A32086D;
        Tue, 11 Jun 2019 17:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560275661;
        bh=WOLzjtOo0cPYBq8H9pJ7UXlbpV/3DfejycQDMklAFrg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mtutbYLwneUKbgj6JCWJ5TrJ6+mPpPJFVqCNPCUNmnXnZML7MciT5nf9+fkEv/mdJ
         14iTYgr7Wo+1ODlqYzNt8SGt7IfK+sdgNDziJHwn+WwnYfohGZgPpDepND4nAMMXgu
         YW3bfs6TmAO/WYlP5De+IfSb4FwY/hN6c33Xb2Fg=
Date:   Tue, 11 Jun 2019 10:54:20 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v3 2/7] net/mac80211: move WEP handling to ARC4 library
 interface
Message-ID: <20190611175419.GB66728@gmail.com>
References: <20190611134750.2974-1-ard.biesheuvel@linaro.org>
 <20190611134750.2974-3-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611134750.2974-3-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 11, 2019 at 03:47:45PM +0200, Ard Biesheuvel wrote:
>  
> -void ieee80211_wep_free(struct ieee80211_local *local)
> -{
> -	if (!IS_ERR(local->wep_tx_tfm))
> -		crypto_free_cipher(local->wep_tx_tfm);
> -	if (!IS_ERR(local->wep_rx_tfm))
> -		crypto_free_cipher(local->wep_rx_tfm);
> -}
> -

This function was removed, but its declaration in net/mac80211/wep.h was not.

>  static inline bool ieee80211_wep_weak_iv(u32 iv, int keylen)
>  {
>  	/*
> @@ -131,21 +110,16 @@ static void ieee80211_wep_remove_iv(struct ieee80211_local *local,
>  /* Perform WEP encryption using given key. data buffer must have tailroom
>   * for 4-byte ICV. data_len must not include this ICV. Note: this function
>   * does _not_ add IV. data = RC4(data | CRC32(data)) */
> -int ieee80211_wep_encrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
> +int ieee80211_wep_encrypt_data(struct arc4_ctx *ctx, u8 *rc4key,
>  			       size_t klen, u8 *data, size_t data_len)
>  {
>  	__le32 icv;
> -	int i;
> -
> -	if (IS_ERR(tfm))
> -		return -1;
>  
>  	icv = cpu_to_le32(~crc32_le(~0, data, data_len));
>  	put_unaligned(icv, (__le32 *)(data + data_len));
>  
> -	crypto_cipher_setkey(tfm, rc4key, klen);
> -	for (i = 0; i < data_len + IEEE80211_WEP_ICV_LEN; i++)
> -		crypto_cipher_encrypt_one(tfm, data + i, data + i);
> +	arc4_setkey(ctx, rc4key, klen);
> +	arc4_crypt(ctx, data, data, data_len + IEEE80211_WEP_ICV_LEN);

How about adding:

	memzero_explicit(ctx, sizeof(*ctx));

> -int ieee80211_wep_decrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
> +int ieee80211_wep_decrypt_data(struct arc4_ctx *ctx, u8 *rc4key,
>  			       size_t klen, u8 *data, size_t data_len)
>  {
>  	__le32 crc;
> -	int i;
> -
> -	if (IS_ERR(tfm))
> -		return -1;
>  
> -	crypto_cipher_setkey(tfm, rc4key, klen);
> -	for (i = 0; i < data_len + IEEE80211_WEP_ICV_LEN; i++)
> -		crypto_cipher_decrypt_one(tfm, data + i, data + i);
> +	arc4_setkey(ctx, rc4key, klen);
> +	arc4_crypt(ctx, data, data, data_len + IEEE80211_WEP_ICV_LEN);

Same here.

- Eric
