Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218A81B808
	for <linux-crypto@vger.kernel.org>; Sun, 16 Feb 2025 16:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739723050; cv=none; b=n2tX0fQjfW8FHC+pJIRawRil5RapC8nZFvOXugtF0hMcdfy4drz36J1ZAEgRCERJSn87uIpAJSv7Q+xyxJHcArjXdt0CbRG7L+H+gDtEMp4EzOGs5d7oRIHUUSxDul96Jvwcp4z26AClFxqdD1eRmB4DYZzUFkW6NTUvfcDRn4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739723050; c=relaxed/simple;
	bh=vBzH3Bx7JA+ZtuGII1BqJFgi0PM0CQBNVNzw+929y4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YewuB4A3oL2SeUd+8qAhWm4bRFVDTKYnp+4OmvyaANXIfEjVCWQi7e5N572ufYRl5lF/iHGpZM6Hs79rrQVkiciwr6+N1ZUdoW4/a2G+5918tNTLRayGr4kGWOWGNxXBznRl9VI1F1+d7L4U2gm/IEADFE7Zlp8byxfC1SjLBPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yXLfPT4P; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yXLfPT4P"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-abb75200275so157679066b.3
        for <linux-crypto@vger.kernel.org>; Sun, 16 Feb 2025 08:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739723046; x=1740327846; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oef0lI60XKJ4r62kZ4qBExl4oYf0hGjxAlC0q+vCbdg=;
        b=yXLfPT4PRLPet1GPMmk3P0ajR+R7+cV382rsmolPFos5uuQlKRLRNg/PHKGeIIKiku
         8CThjVXTeQbABKi50+4KXNxh7xM08XM4MTaujZn4u2im43lUHC9wjt0EH7Nf/IiaTHRl
         MsH1/VIV1b/cP421WuLdb6GNqAwuDgugL0VVa4Yk9ARcWdiLkNWPcR/CAu8kdr+ZvmzI
         tSURnIeR4IzyZj7rI2iMWpbxjbxNvDEyJFYZ7/ADtParlCQa1sDJFN6fSD606OI+9fBs
         9+ry6SvYLe5dWZuGNNv8kwjthno8Rz0iqBtWLkdbmOpa3mZWXQAEIR7e54YztBhrNetL
         9ilA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739723046; x=1740327846;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oef0lI60XKJ4r62kZ4qBExl4oYf0hGjxAlC0q+vCbdg=;
        b=lqvRjxav6fUiTMhm+f4MdxWKir46PWy2Qz7WsGG9uZhcqxxFwU2VdxTIj1RiJZvp57
         xTGo3GQpgLN4VH6vb0VuI7xvgp8jwtbfADdeZEMU52uSJ2Gd0o3LU2FD1wJD/VTMW7Lx
         PrOn95lJ7HStD/7GzqrxDlPdsusl56509gZg4xmjubeVeLm98uv1aobmpDvK3SwUXpgO
         n5DOU6jPjdnVh9OUpWtaH7BBZ7Sg8yLvNqfAfNsHe38Rey/iQyaAU7yBzx20ALZHC9qJ
         WWYwbFYvn7ZOF0j/4cCRyqC7y/ttnbB5s1zeWnXRFsIej/v1LY4LQCHha5MTIAcgGXYH
         WJVw==
X-Gm-Message-State: AOJu0YyWnqZ7TXBmXmsGlnx92dYChQ1CIoPv1S/oyE3P8gib5DdyWgFg
	7qz/jn6xxvqU+V+xJ/uIpaGCWWvjKPxSEgbvcxWu34NmQv97jd99QDPxSNSb79s=
X-Gm-Gg: ASbGncsgymhqsXMytKaq61TjRn0nsz7aECvyX0UCi7uz99lrejg4gQaTO6bK6Y/tGmd
	/PHLD6+kR+O2QTrs0e5qNMdig6f/mGadUdxwVbaM5zQ73yt0ZFu851XAIh1oTnB81hPMq3FYyo1
	j8myvvck0wh6K6wXr+yQhuMtsq39igPewT6C/aZWnSTiOLORI/A1paR3SXZlAEk3vWfvcZVcOfz
	LVOjXQ6hsV39vbSlk8eJw0EVBtKHkOoZ+fmjTe9G8TiPmTl7c1hz34W9zRilWJcm1jlImQz8Zky
	W+HxI4N1/BBnHFja04U2
X-Google-Smtp-Source: AGHT+IHucXk/pLP5vjlI6fehiUJ88SFq80kV4DNTXa8W0NIx80r2CHKN/T7Ez+W8H6vX2fEnhXT+IA==
X-Received: by 2002:a17:907:78b:b0:ab7:c115:68fd with SMTP id a640c23a62f3a-abb70e61a23mr673447866b.53.1739723046246;
        Sun, 16 Feb 2025 08:24:06 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-abb98640619sm77136166b.54.2025.02.16.08.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Feb 2025 08:24:05 -0800 (PST)
Date: Sun, 16 Feb 2025 19:24:01 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [bug report] crypto: eip93 - Add Inside Secure SafeXcel EIP-93
 crypto engine support
Message-ID: <02d25648-e223-43d0-be12-a1ba836d319f@stanley.mountain>
References: <cea9bafd-3dde-4028-9b20-4832dd2977e6@stanley.mountain>
 <67b09353.5d0a0220.245b91.dc34@mx.google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67b09353.5d0a0220.245b91.dc34@mx.google.com>

On Sat, Feb 15, 2025 at 02:14:52PM +0100, Christian Marangi wrote:
> Thanks, this wasn't reported in the first run so sorry for not noticing
> this. I will take care of sending a follow-up patch to address this.

> On Wed, Feb 12, 2025 at 06:23:01PM +0300, Dan Carpenter wrote:
>
> > drivers/crypto/inside-secure/eip93/eip93-common.c:233 check_valid_request() warn: 'src_nents' unsigned <= 0
> > drivers/crypto/inside-secure/eip93/eip93-common.c:237 check_valid_request() warn: error code type promoted to positive: 'src_nents'
> > drivers/crypto/inside-secure/eip93/eip93-common.c:240 check_valid_request() warn: error code type promoted to positive: 'dst_nents'

The first one isn't a published check.  I should clean it up and publish
it.  It has a few false positives where the less than zero is harmless
but it doesn't print too many warnings.

The latter two warnings require the cross function database to work.
The check needs to know which functions return negative error codes.

regards,
dan carpenter

