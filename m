Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7AE748D;
	Thu, 12 Dec 2024 19:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734032103; cv=none; b=fcWMMyqr65djECrsGNI4L5+zGU8ziCOWDA4voH56HtjVD4lT2sa+WFiErhIk6+KBa01Y9I2bqqHXwHCraW7IcOlpyF8cgojVN1tPqsa0FxiQ0jwdGsr5sdAUr3zu0eubr7Lj9OePs8yIj3aeh+xvpQeKVbZI1LTlOlqFMUsFRck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734032103; c=relaxed/simple;
	bh=6JdMreTDwk9D8qAAZmhrdOeS15T/F7eJ303s9Wr39t0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DMTaGylIjC2AjW3bq92psQww5jDUH3Ossy2uObEuMCwluY3dMJmrsOVpjIGH8DHy6b+1wgntwfTDs3npULP6Aoj6oqVpeUkVcMD3ESXjXG6vnCsfEIhAEkcFRXwtVJEABGcMzP/d5UcCzxylbPC2Ta63Q7w3fP9xmAhridAreZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZG0okCRc; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZG0okCRc"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-72764c995e5so635216b3a.2;
        Thu, 12 Dec 2024 11:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734032101; x=1734636901; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G0Pjt/zid57BkOmERd5gJSPlvgPaAJnd3no1gt/xlhI=;
        b=ZG0okCRcSZQ1svJ5xmUixID1+/jdSqNVkQjvd0Ddo1jiZX+rWREiAIgR6e4wdgW4sf
         IfR5QgiS/cIc02QBFJNYLL4a6ekMQbOIPrQHJunOZcueeQKDk94iGJmdfT+zi6wRtLuJ
         5blvReGVbK0T60Qs9HNivCaqlJiGBI7+AQxPA1fAzmFhttLq/HzirwtyyWNMxCYk3xei
         YPLan0XlXLu2cteb2sUZZ6o6oxbb8S3oUaA1Xe9NwKY5Q7NfUloxe4YcyBcwzS/94ZZq
         772rUCCngBVLaUaLCm8zpWIVHumWv30LrIwwQkSSVo6k51EwN+ZT/NHzu44yMe79c53c
         1Rpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734032101; x=1734636901;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G0Pjt/zid57BkOmERd5gJSPlvgPaAJnd3no1gt/xlhI=;
        b=CONOrhFZoE6sRO8f983e6ZM5hMCzodPUZjfOpUB6QS+SgLD8vgiXPcWt51HU1aO5B8
         xEt7zkMVpOiwvNgPCKSUrzUVCeNgDNGFmVI/OVbp4y3OcCojpNUpCMrtCihwYCocJoIY
         x7aMa3hjY2/vrRdw3G8es6QMAgj/km1dt602zFRmO953jiUsfAkc79HfQuLlOK2shCNR
         DihXaXVL7gR3doSz155SKG6MDGuuVDXtrv2mHIFjo5sJUFZFGthxQXBuAc20qU3lpajQ
         zBfvW9rgA+YbXhW9viIwq+CMTtJzm3v6Nid4U0WcWPju4dyzIYtnNdR9BvMroaH1MU9r
         0wkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLpfAxIk5+gZkOK9OJY6S/SbzUWD4ftjDLfs2CCB9e75q3mWgsghw0BuHzDaYpHSSEaSJV/sGW0BblQMv7@vger.kernel.org, AJvYcCWWph13hLulhzSmcLdWvCgGVjYo+XEgnYz2TLZeJAAV1RBHGfS/xzKeDiW4eRj5HGgUb7ptAHqwgq7uVAk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4XAtpASQ+uPNmty9IeBWXEl7xf9t69QEDJqy5r5NE7YshMKY8
	dJzH7YvaLXhoBrO9eKRQw4VALHMYRozcooiIf7tNzvs3wTO/QAYQ
X-Gm-Gg: ASbGncsGiPS1iyLqb7/n7TwluUj64BVvA2DlnuZpZnfxW25ej9+9LKN90pqWGA8axbD
	dBPB5TvsuP/HUGR8svFtiRxFSweJbdOfBBuXzmWHf5jQ25CHga3vEX6ozmzteCsxsWcrj13IPpq
	HnUjxWCYdqBCt5LPhrBeX0jX5m4WqQ7h8ieJIVNFNS7wNvV4vxqUbdyccofaIrD03f2aZJ4Zx3a
	P95Du3HiEFVpxHm0LLn8IH+zdaZqlJbyCvr/PVk1RErEo2Q1sJS9wqk
X-Google-Smtp-Source: AGHT+IFpZrArj5dfWzcAxW8eYWwtVbo6EQUT3Kf0VPIjAmEVJrckT+MqWXA/49i23H/Oixxoz/l1Mg==
X-Received: by 2002:a05:6a00:1a8d:b0:727:d55e:4be3 with SMTP id d2e1a72fcca58-7290698d07cmr1898537b3a.7.1734032101328;
        Thu, 12 Dec 2024 11:35:01 -0800 (PST)
Received: from localhost ([216.228.125.129])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-725c7cba42fsm10906017b3a.123.2024.12.12.11.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 11:35:00 -0800 (PST)
Date: Thu, 12 Dec 2024 11:34:58 -0800
From: Yury Norov <yury.norov@gmail.com>
To: Kees Cook <kees@kernel.org>
Cc: Nilay Shroff <nilay@linux.ibm.com>, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	briannorris@chromium.org, gustavoars@kernel.org, nathan@kernel.org,
	steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
	gjoyce@ibm.com, linux-crypto@vger.kernel.org, linux@weissschuh.net
Subject: Re: [PATCHv3] gcc: disable '-Wstrignop-overread' universally for
 gcc-13+ and FORTIFY_SOURCE
Message-ID: <Z1s64indfQHyLJt-@yury-ThinkPad>
References: <20241208161315.730138-1-nilay@linux.ibm.com>
 <202412120953.87F2827497@keescook>
 <202412121046.FD6F96C63@keescook>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202412121046.FD6F96C63@keescook>

On Thu, Dec 12, 2024 at 10:47:40AM -0800, Kees Cook wrote:
> On Thu, Dec 12, 2024 at 10:24:36AM -0800, Kees Cook wrote:
> > Or we could unconditionally put the OPTIMIZER_HIDE_VAR() inside
> > bitmap_copy() itself:
> > 
> > 
> > diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
> > index 262b6596eca5..5503ccabe05a 100644
> > --- a/include/linux/bitmap.h
> > +++ b/include/linux/bitmap.h
> > @@ -251,12 +251,14 @@ static __always_inline void bitmap_fill(unsigned long *dst, unsigned int nbits)
> >  static __always_inline
> >  void bitmap_copy(unsigned long *dst, const unsigned long *src, unsigned int nbits)
> >  {
> > -	unsigned int len = bitmap_size(nbits);
> > -
> > -	if (small_const_nbits(nbits))
> > +	if (small_const_nbits(nbits)) {
> >  		*dst = *src;
> > -	else
> > +	} else {
> > +		unsigned int len = bitmap_size(nbits);
> > +
> > +		OPTIMIZER_HIDE_VAR(len);
> >  		memcpy(dst, src, len);
> > +	}
> >  }
> >  
> >  /*
> > 
> > I prefer any of these to doing the build-system disabling of the
> > warning.
> 
> Actually, this should probably be done in the FORTIFY macro instead --
> it's what actually tripping the GCC warning since it is the code that is
> gleefully issuing a warning and then continuing with a overflowing copy
> anyway...
> 
> 
> diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
> index 0d99bf11d260..7203acfb9f17 100644
> --- a/include/linux/fortify-string.h
> +++ b/include/linux/fortify-string.h
> @@ -630,7 +630,13 @@ __FORTIFY_INLINE bool fortify_memcpy_chk(__kernel_size_t size,
>  		  __fortify_size,					\
>  		  "field \"" #p "\" at " FILE_LINE,			\
>  		  __p_size_field);					\
> -	__underlying_##op(p, q, __fortify_size);			\
> +	if (__builtin_constant_p(__fortify_size)) {			\
> +		__underlying_##op(p, q, __fortify_size);		\
> +	} else {							\
> +		size_t ___fortify_size = __fortify_size;		\
> +		OPTIMIZER_HIDE_VAR(___fortify_size);			\
> +		__underlying_##op(p, q, ___fortify_size);		\
> +	}								\
>  })

I like this more than anything else. Bitmap API is an innocent victim,
and trashing it with unrelated warning suppressors is just bad. If GCC
will get more aggressive, we'll end up with the kernel all trashed with
this OPTIMIZER_HIDE_VAR() stuff.

I tried to formulate it when discussed __always_inline story, but now I
think I can do it clear. Bitmaps is an example of very basic coding. It's
not very complicated, but it's the 2nd most popular kernel API after
spinlocks.

People literally spent hundreds hours on every single line of core APIs.
I think all that people expect that the most reviewed system code in
the world will be somewhat a reference for compilers and other tools.

If compiler can't inline a pure wrapper with no additional
functionality at all, or if modpost can't understand that inline
function declared in header can't be a 'section mismatch', or 
if CONFIG_FORTIFY complains about an overread that can never happen,
it's not a reason to pollute bitmaps, spinlocks, atomics or whatever
else, or even touch them. The tools should be fixed, not the code.

Acked-by: Yury Norov <yury.norov@gmail.com>
