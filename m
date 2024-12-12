Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441D716FF4E;
	Thu, 12 Dec 2024 18:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734029264; cv=none; b=Rt4Q5F9NXkfnZoajrAdQ3atCoewnrMGabSzqwaP896pyc+pMo0JnnJ3I6r9V0Qo/Xc4OsU3Km7volzczWfsK5bJjQcX0nScJefhPlfHkzS/8S7JZF0PnodjrYv79YHi6vbIfhTVbUm4nHFCt2hwKkbijyQTmSvl+yoN2m9bNhY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734029264; c=relaxed/simple;
	bh=ZS+9nw/OfE/ulmhXlhMpSJ/3dWJ9u/H5qnHLqvSULEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WC7mHor1gtENqKtflqZXmyLSaioGSNKcSSvdJ3U+izZbb0tKFcp5TJM2NuZ1quTo86SC9E8ismzUnh4oMRZnS45Bspy7aL8Z30Mc0CbTD2OyTzQNq1F3sGqIWlQ6TLO5lNT/b+FXUFHh/G302F4T9ELAEM2tOFyn6ybF/s4VLY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mfWLUP2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mfWLUP2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E92C4CED0;
	Thu, 12 Dec 2024 18:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734029263;
	bh=ZS+9nw/OfE/ulmhXlhMpSJ/3dWJ9u/H5qnHLqvSULEE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mfWLUP2Q1CyiZfa1tJXdDvP3L7ym9Hl1Fn9ICBXm9Y7C/3BYKPC53f+XW/j6kc3p/
	 hHKESG7XHReDoBfc0OPmzTGpUvkbsk+Fr9o2x4nRJXWSgciMc2rBgplHU4WKejjdzv
	 sM4p/QVqikreeR20Y6n+UCG6FMarQ8hTO0Z1jA1lxDJ3J6mzQEZefYr6m/474vf9DQ
	 5kVksC748CZg+ITwXw7QwZDxDhqtbhminMPK2dm9YUSqGZe5VUfAml9hKBpYUtwSc4
	 9iQ5Nibu0xchmLG0cX8SkFXEHp795pJKhSsMK+OnK5WL+sPaUOmwx2c7iRqm8SMyhP
	 r3/KU4tJDd3iA==
Date: Thu, 12 Dec 2024 10:47:40 -0800
From: Kees Cook <kees@kernel.org>
To: Nilay Shroff <nilay@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	briannorris@chromium.org, yury.norov@gmail.com,
	gustavoars@kernel.org, nathan@kernel.org,
	steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
	gjoyce@ibm.com, linux-crypto@vger.kernel.org, linux@weissschuh.net
Subject: Re: [PATCHv3] gcc: disable '-Wstrignop-overread' universally for
 gcc-13+ and FORTIFY_SOURCE
Message-ID: <202412121046.FD6F96C63@keescook>
References: <20241208161315.730138-1-nilay@linux.ibm.com>
 <202412120953.87F2827497@keescook>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202412120953.87F2827497@keescook>

On Thu, Dec 12, 2024 at 10:24:36AM -0800, Kees Cook wrote:
> Or we could unconditionally put the OPTIMIZER_HIDE_VAR() inside
> bitmap_copy() itself:
> 
> 
> diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
> index 262b6596eca5..5503ccabe05a 100644
> --- a/include/linux/bitmap.h
> +++ b/include/linux/bitmap.h
> @@ -251,12 +251,14 @@ static __always_inline void bitmap_fill(unsigned long *dst, unsigned int nbits)
>  static __always_inline
>  void bitmap_copy(unsigned long *dst, const unsigned long *src, unsigned int nbits)
>  {
> -	unsigned int len = bitmap_size(nbits);
> -
> -	if (small_const_nbits(nbits))
> +	if (small_const_nbits(nbits)) {
>  		*dst = *src;
> -	else
> +	} else {
> +		unsigned int len = bitmap_size(nbits);
> +
> +		OPTIMIZER_HIDE_VAR(len);
>  		memcpy(dst, src, len);
> +	}
>  }
>  
>  /*
> 
> I prefer any of these to doing the build-system disabling of the
> warning.

Actually, this should probably be done in the FORTIFY macro instead --
it's what actually tripping the GCC warning since it is the code that is
gleefully issuing a warning and then continuing with a overflowing copy
anyway...


diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
index 0d99bf11d260..7203acfb9f17 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -630,7 +630,13 @@ __FORTIFY_INLINE bool fortify_memcpy_chk(__kernel_size_t size,
 		  __fortify_size,					\
 		  "field \"" #p "\" at " FILE_LINE,			\
 		  __p_size_field);					\
-	__underlying_##op(p, q, __fortify_size);			\
+	if (__builtin_constant_p(__fortify_size)) {			\
+		__underlying_##op(p, q, __fortify_size);		\
+	} else {							\
+		size_t ___fortify_size = __fortify_size;		\
+		OPTIMIZER_HIDE_VAR(___fortify_size);			\
+		__underlying_##op(p, q, ___fortify_size);		\
+	}								\
 })
 
 /*

-- 
Kees Cook
