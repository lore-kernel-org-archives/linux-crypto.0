Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3152049652;
	Mon,  9 Dec 2024 20:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733777038; cv=none; b=p4Y7meU+ehDrdmar/x4XZFEY+r7ljuPP8s9QNajzjwIzaxBF9vb/Dzyh0WyN81RVShulHGTbEeTWTGsVQVKDJ9+OtVYRFQ8a4UdULYgam5Yrfye1/7PI0/KXfcKkZHoo/Ep1hwMNRd7eULsNpJqksGF3vndMIRX8AU2FSFKI67I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733777038; c=relaxed/simple;
	bh=/zoI0+bu5NOUtJFzvAWzXL6BbqZTrn6EovR8vhlGX1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bvqGKc9f0axXB9GrGmeI4TPjmMPmrv+vRQKDKAKae+Uvp+Opm9hZI+uUzguDtB/L5V2bumAaYFPo7oW/VrG6RqHkXwfxg5/ICbk9PACYf8RfpPc98yDFANrO1TxYrLcdAIPB2b4/E3hJOp9FhXzW+vzSFps9F50vXDinl8tNT5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KUBuWZ/+; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KUBuWZ/+"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-6ef6ffcc2dcso39532327b3.1;
        Mon, 09 Dec 2024 12:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733777036; x=1734381836; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KjQXgS6bupjTmh7ixKgo/uo0iozElfiUahzhlXIWQRI=;
        b=KUBuWZ/+lAyLkwFujt3dS40B7YeDHvC4udEKSX3buZ7nCO6WX6Nir734UglbCT+ce7
         oKbDUWfnUjS29diUWk28FHZTEVIK9y0fguHvkfrmRgI81rEgRlYjiwzGccPagwJlKpDB
         esGp8NDkcJVBDK9hvN11So4amc+8zGulyPgfMgbtbtYl1OTsEy4WCtEuCzQ3gBhGiqyX
         p2eGahskswYPM6N5nK0/NaP2KcTHU8hVjvUwCSbax+YRqC9A4l/vXXDygta5t4zDmWSJ
         Fwb0d6etA9OB8NwCEjyFoyeV9SHs7S+q3wA8X5+ykd5Ur4NA+AZLRK2ck0jbWHXObn0P
         SHlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733777036; x=1734381836;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KjQXgS6bupjTmh7ixKgo/uo0iozElfiUahzhlXIWQRI=;
        b=magE0GzTVZBL/XI24wSA9OeGhKVoT1SvCVu4efDfKdoL+bEAwkFn/NF4Yp26xA5Bzm
         RXayv4u4SeQ3LmkEiC+KH6MW5/zEgqJLq/zPvApQANZDgao5sIXEguA9ebN2U4mFXBh6
         v2updWIqhz7v5j0aaweT0CJ4QR8exdRqfWlY9eb8r/5b2KL7pxf6gUaFTpP2JaoX8SfE
         mvfKWf4klV303aZJ3BlQ2Re9106zs3fKATXP/puqk0qXaTYzlF/0132hn2BztOcb7PsJ
         0TMTRzhrdw+MFct6D85/mN+3YUm3uUgSh3w2C2SC7ZKoxwO2fdWSdzG/61YQcjBZW89C
         07Vw==
X-Forwarded-Encrypted: i=1; AJvYcCVNUg0572lkYPeGyy0o1HNj9dBMPaTX/Vcr76ki0zbVYrygmnRqd3Omjmj+V9CgwdB+wo0trhhrKZ4hiMvC@vger.kernel.org, AJvYcCXL5yz1tqP1h/gzTamIRUfxW6yGZMFOCKP8MGgQRFmgfRpvbx2bm2U59AnHucKwNn0Ylxlxh3J8zS9YKE0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyX8BaFEqQXc9X3wRI8R0zpLISrdKn3FOhG9UJbbg+JUyPINY1R
	JNJpNoXHIgbc8txbszA1qcOd7UT87TZgUKSu2TM7BTOnG9R7eH8v
X-Gm-Gg: ASbGncvMI0/U2OzDc2P7RmVhvNncbtzstqnWCbtq/4bkA0Lu86eZ7W2oaZaiSMZSOd6
	uvQPFQ+0ZN0fV9zbd0aYnHzzT6LwdhFuB4+AkY3qyXdp+OYtSYcsVW/pJLVqpJLG4MkJymtyHSt
	hvxn6j+IT2Icm02VFrrO+5hngczldP9tF6I31n+D07IOUaQuJmjeocY18vOfbSvR9TNFvJPtoaK
	kxV2U55AQOR6nbx3KgBcfF/4aD0XH9giKy/kI6mwFOSKab1Aahp/qequRjl6PnJI7gOjtoo4+AQ
	Li8X2CA+6HFQBw==
X-Google-Smtp-Source: AGHT+IGkSA3HWv8WQ+hj0AVQT00vrv9yyn4awaPgsXPzyK8iAdmfu8BTvS8Tp39yTlNRp/EqxZQi/w==
X-Received: by 2002:a05:690c:6f86:b0:6e5:adf8:b0a8 with SMTP id 00721157ae682-6f0258377cbmr9682257b3.6.1733777035983;
        Mon, 09 Dec 2024 12:43:55 -0800 (PST)
Received: from localhost (c-24-129-28-254.hsd1.fl.comcast.net. [24.129.28.254])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6efd38b6815sm24277297b3.56.2024.12.09.12.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 12:43:55 -0800 (PST)
Date: Mon, 9 Dec 2024 12:43:54 -0800
From: Yury Norov <yury.norov@gmail.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Nilay Shroff <nilay@linux.ibm.com>, linux-kernel@vger.kernel.org,
	briannorris@chromium.org, kees@kernel.org, gustavoars@kernel.org,
	steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
	gjoyce@ibm.com, linux-crypto@vger.kernel.org, linux@weissschuh.net
Subject: Re: [PATCHv3] gcc: disable '-Wstrignop-overread' universally for
 gcc-13+ and FORTIFY_SOURCE
Message-ID: <Z1dWinzDPuC8iEXk@yury-ThinkPad>
References: <20241208161315.730138-1-nilay@linux.ibm.com>
 <2024120938-kilogram-granite-9a53@gregkh>
 <20241209200300.GB1597021@ax162>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209200300.GB1597021@ax162>

On Mon, Dec 09, 2024 at 01:03:00PM -0700, Nathan Chancellor wrote:
> Maybe people are not using CONFIG_WERROR=y and W=e when hitting this so
> they do not notice? It also only became visible in 6.12 because of the
> 'inline' -> '__always_inline' changes in bitmap.h and cpumask.h, since
> prior to that, the size of the objects being passed to memcpy() were not
> known, so FORTIFY could not catch them (another +1 for that change).

Thanks, but I'm actually not happy with that series (ab6b1010dab68f6d4).
The original motivation was that one part of compiler decided to outline
the pure wrappers or lightweight inline implementation for small bitmaps,
like those fitting inside a machine word. 

After that, another part of compiler started complaining that outlined
helpers mismatch the sections - .text and .init.data.

(Not mentioning that the helpers were not designed to be real outlined
functions, and doing that adds ~3k to kernel image.)

I don't like forcing compiler to do this or that, but in this case I
just don't know how to teach it to outline the function twice, if it
wants to do that. This should be done automatically, I guess...

Similarly, I don't know how to teach it to keep the functions inlined,
other than forcing it to do so. I really wonder what made it thinking
that this deserves to be a real function:

 static __always_inline
 bool cpumask_andnot(struct cpumask *dstp, const struct cpumask *src1p,
                     const struct cpumask *src2p)
 {
         return bitmap_andnot(cpumask_bits(dstp), cpumask_bits(src1p),
                                           cpumask_bits(src2p), small_cpumask_bits);
 }

I guess, there are more 'functions' of that sort that outlined for nothing
in the kernel, and who knows how bloated is it?
