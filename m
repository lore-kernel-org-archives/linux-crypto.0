Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B9921257E;
	Wed, 19 Nov 2025 18:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763577909; cv=none; b=bsKpLyv1PKB/yYrhd8+GlxfXyqWVXjh4+tREYA5LtKQxBfI/DCNkkludmgJuzFgOh2pyqSbWDN3rqheBe2JSqGXziQnmZcSnjVkZxG4Bc+J28Dz3Dj4ZrkH6vvCmWhYfr89qC2jvpQeIFWKOEUsnNJCUetF6dtXPurfmSUgJUQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763577909; c=relaxed/simple;
	bh=lREu9tNPPw7ji/ZfllpGZdKS3aTWW/dNnGWc7GYvBEA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u/KI/N33NKQx+QOJ6nHnMLJ/KqGMKvq6jS81oXp24fTgFCcDrKZYK9dOrmUFFKp35SqDNInk2kEmifGPahZI94PD6nirX/q7BYlQUv8JPkxmtHpf4r4vP+giUyOjk/Pl50FVAK3ba9ZdIKJ3CyGKcLCn49EZxOV9xrieRIgH2x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XG6KJfK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XG6KJfK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFB2C4CEF5;
	Wed, 19 Nov 2025 18:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763577905;
	bh=lREu9tNPPw7ji/ZfllpGZdKS3aTWW/dNnGWc7GYvBEA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XG6KJfK2DmumFoLSpYzy9iwgv2UkuH3HHAlMrJISRMAhTlkWo08RVAJNDN4WJ6nWB
	 JZgqtpMhiUhjHGTyL289YUxD2lY9OTX0HEmqZkWIIZwqXjGY2BFn7KpaTYaj43dwI+
	 Xa8ZA2gyzkIou44jFeZtPRCE5vPJb/aKgY7A0isl4iZWQH7qL7tbSdF0WmpXi5njyX
	 khPoyMlFGQs9xIoop+d+v9v2Tt1pRCGix01MLPg+6TC49/3NxyYGskEbbNCKPCETgN
	 YHyk4Qd1S0xtPtazwqxd7RGq+ESRKmsJC80CYq3jzn0hOl02/2FgwNYjqru/L4d0mB
	 mfTuWds/T//vg==
Date: Wed, 19 Nov 2025 11:45:00 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	kernel test robot <lkp@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH libcrypto 2/2] crypto: chacha20poly1305: statically check
 fixed array lengths
Message-ID: <20251119184500.GA3303394@ax162>
References: <20251118170240.689299-2-Jason@zx2c4.com>
 <202511192000.TLYrcg0Z-lkp@intel.com>
 <CAHk-=wj9+OtEku8u9vfEUzMe5LMN-j5VjkDoo-KyKrcjN0oxrA@mail.gmail.com>
 <CAHmME9pvgyot-PJDbWu1saYagEYutddc_B9qNHf-MZ-vkw4zoQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHmME9pvgyot-PJDbWu1saYagEYutddc_B9qNHf-MZ-vkw4zoQ@mail.gmail.com>

On Wed, Nov 19, 2025 at 05:46:44PM +0100, Jason A. Donenfeld wrote:
> Hey Linus,
> 
> On Wed, Nov 19, 2025 at 5:29 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> >  On Wed, 19 Nov 2025 at 04:46, kernel test robot <lkp@intel.com> wrote:
> > >
> > > >> drivers/net/wireguard/cookie.c:193:2: warning: array argument is too small; contains 31 elements, callee requires at least 32 [-Warray-bounds]
> >
> > Hmm. Is this a compiler bug?
> 
> It's not. It's a 0day test bot bug! My original patch had in it some
> commentary about what a bug would look like when it's caught by the
> compiler. In order to provoke that compiler output, I mentioned in the
> commit message that this diff will produce such and such result:
> 
> diff --git a/drivers/net/wireguard/cookie.h b/drivers/net/wireguard/cookie.h
> index c4bd61ca03f2..2839c46029f8 100644
> --- a/drivers/net/wireguard/cookie.h
> +++ b/drivers/net/wireguard/cookie.h
> @@ -13,7 +13,7 @@ struct wg_peer;
> 
>  struct cookie_checker {
>         u8 secret[NOISE_HASH_LEN];
> -       u8 cookie_encryption_key[NOISE_SYMMETRIC_KEY_LEN];
> +       u8 cookie_encryption_key[NOISE_SYMMETRIC_KEY_LEN - 1];
>         u8 message_mac1_key[NOISE_SYMMETRIC_KEY_LEN];
>         u64 secret_birthdate;
>         struct rw_semaphore secret_lock;
> 
> It looks like the 0day test bot just went through the email and
> applied all the `diff --git ...` hunks, without taking into account
> the context area above where the actual patches start.

I don't think it is a bot issue. Just running 'b4 shazam' (i.e. just
applying the patch with 'git am') on the series results in:

commit 6ddc87109d4bb589d02cc3a8b037c99fdc4cbbf9
Author: Jason A. Donenfeld <Jason@zx2c4.com>
Date:   Tue Nov 18 18:02:40 2025 +0100

    crypto: chacha20poly1305: statically check fixed array lengths
    
    Several parameters of the chacha20poly1305 functions require arrays of
    an exact length. Use the new min_array_size() macro to instruct gcc and
    clang to statically check that the caller is passing an object of at
    least that length.
    
    Here it is in action, with this faulty patch:

diff --git a/drivers/net/wireguard/cookie.h b/drivers/net/wireguard/cookie.h
index c4bd61ca03f2..2839c46029f8 100644
--- a/drivers/net/wireguard/cookie.h
+++ b/drivers/net/wireguard/cookie.h
@@ -13,7 +13,7 @@ struct wg_peer;
 
 struct cookie_checker {
 	u8 secret[NOISE_HASH_LEN];
-	u8 cookie_encryption_key[NOISE_SYMMETRIC_KEY_LEN];
+	u8 cookie_encryption_key[NOISE_SYMMETRIC_KEY_LEN - 1];
 	u8 message_mac1_key[NOISE_SYMMETRIC_KEY_LEN];
 	u64 secret_birthdate;
 	struct rw_semaphore secret_lock;

followed by the rest of the patch for me.

Cheers,
Nathan
