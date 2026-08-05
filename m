Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0300C3C1977;
	Wed,  5 Aug 2026 20:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785962777; cv=none; b=FQUmcDWqxHZJfM6JfWIUXptdCqlX21ZRlVb24ktyulny5WuzpnicQFysAWkOrIyK0EsNKAqZO52UttMF7WGvgQwfPAmxB/vvRNGz0YCvw5y+BrP79EQ1iQZjY0Le93LCwz2J6+C/7hIQI5mlTMnNczvl9CoWeIe5Wbk9Xe0GzG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785962777; c=relaxed/simple;
	bh=N02X1ThnyavGYjOEljxqRKDmUUrgPLL/DNj3xftFvTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ofz35/tyvH0MaPrjg/KvCJeZuxlriB9ftRxWig8coqn4xgzajMysOxMnCwz45WgBypTvObVCzRdM71zQPf2Ur+RlHUsSkvaAEQP+Z6vTAFx7P6cNieCwYWhDW1SpYZHjEpwYKujbbroS6Yq0zHkHEd1vEXQ4oyDPsFkKRB2D1u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bmYy1tu8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bmYy1tu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2741F000E9;
	Wed,  5 Aug 2026 20:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785962775;
	bh=9kYsVQ4asjhuE6O129gzj+LK/bl3iPLokXo6xjuB/IQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bmYy1tu8DsWHda3jwOAE5SFf7o+N9W3YOPpIcFYV4EZUKFVJG9FwXiTKCla8fQT2H
	 j273rhjIijd4WNeicc45WQIz/basCYwrksETYBwvWyhWUuZ/lSqyTmTHjpn3OvQv/Z
	 Yb5sJuCZf6D4Z7fzifKwaWAvtE6DYTnv6Ne7egixisbNzdXxURCUwAKwEZ4lN3kbJY
	 1CCFqvQeVVvs7tfzLYD30W/AG/deSnHCIjiJChJDogrUYTAUCVrJdMxZqa6ZlIh2RT
	 e8yS6JLZYRTpSNsGvg/XDWce1xeHEmPuX467DWnzTcgBF6crNWs6M2SNRe1eqrQOHm
	 4CeGaPiHQBUUw==
Date: Wed, 5 Aug 2026 13:46:13 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 4/6] Bluetooth: SMP: clear the aes_cmac_key when done
Message-ID: <20260805204613.GG3438@quark>
References: <20260805143611.818559-1-thuth@redhat.com>
 <20260805143611.818559-5-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805143611.818559-5-thuth@redhat.com>

On Wed, Aug 05, 2026 at 04:36:07PM +0200, Thomas Huth wrote:
> From: Thomas Huth <thuth@redhat.com>
> 
> Clear the local aes_cmac_key structure via __cleanup() function
> when we're done with it to avoid that sensitive data could leak on
> the stack.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  net/bluetooth/smp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
> index 031d3022cb1e5..ed30ca0d773f1 100644
> --- a/net/bluetooth/smp.c
> +++ b/net/bluetooth/smp.c
> @@ -164,7 +164,7 @@ static inline void swap_buf(const u8 *src, u8 *dst, size_t len)
>  static int smp_aes_cmac(const u8 k[16], const u8 *m, size_t len, u8 mac[16])
>  {
>  	uint8_t tmp[16], mac_msb[16], msg_msb[CMAC_MSG_MAX];
> -	struct aes_cmac_key key;
> +	struct aes_cmac_key key __cleanup(aes_cmac_zeroize_key);
>  	int err;
>  
>  	if (len > CMAC_MSG_MAX)

Well, the reason I didn't add a memzero_explicit() here when converting
the code to use the AES-CMAC library is because this same function
already puts the raw key on the stack without zeroizing it.

I guess the __cleanup trick makes zeroizing the struct trivial enough
that we should just do it anyway.  But it is always a bit awkward to be
"fixing" something when the same problem is still present.

Perhaps you'd like to expand this patch a bit to zeroize the other data
too?  (There is the 'tmp' array in this same function of course, but
there may be other places that need "fixing" too.)

- Eric
