Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DBD33F36D
	for <linux-crypto@vger.kernel.org>; Tue,  5 May 2026 07:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777965165; cv=none; b=kp+SB4W1EvOL5j3YVy+qUq4yLD2jY+jGc+xz033TfnpTtkb8zy2T3mIwzxAESUihJ62QPHpWcdOXQLui5tYirpe0fbExsEFd6AD2rRTcPlGkbBiSbLz1xr88zwqIg+OBgyRRd9ilaHQJKJxPicOHJCAjfWedmXogKS/J4t9vloE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777965165; c=relaxed/simple;
	bh=nRbLOHGEyOjk/t0bZalKTB4E8OOIwpFqPuCtBA3zIC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tosgjAZWhSvLQf6Wxiu080mGMfsT5huncwY5Wd4UxJo34zhFxhCFg+7EmBI4zXOOam5FUsNX86zZhYoMaVw+J5CKa6j0aEEYKl0zUcWONG4flZd+vj4GVfZW7HJdNGeYLJFpSWNBuVb4ws5Rf628JoRZEGy/xV6rgp24Z0X4V3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YxHePwsF; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YxHePwsF"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-82418b0178cso2340072b3a.1
        for <linux-crypto@vger.kernel.org>; Tue, 05 May 2026 00:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777965163; x=1778569963; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HbRZ7m/cJH5tgSneixdWn6s/PvzDoEk3eHGZhZSgWB4=;
        b=YxHePwsFX/qaJOxm9aYUxMcRwfgfsZWQwamFm1xzseB6uA/051mzxYfqvUR/lpu9gH
         5XN9afuhlftD0jylaUtLopSAJnh1DAiNEDPyp4QidvLaWvOdCkyQnxq8rdKVCbwhgGjx
         ek7qE2mAcQaYD11oMMPWB3hIYJcq8PGmLJtw/UAd00NVoPzJUe9gSyl6FS1pJt6ME8IT
         2VID1gWEceugCxs6qtfJqUdFZ5YSeIcJjGFSvc62nFZ0I2jnnTuBsWL44Ku1BMItYVCU
         2Qsb3iaF0kPhLWSeZpcbsjnewnCjvaSRpSpdrg0a9ago9Xix/Kh7KbqBx6h0u0xkQM2o
         21iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777965163; x=1778569963;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HbRZ7m/cJH5tgSneixdWn6s/PvzDoEk3eHGZhZSgWB4=;
        b=cWjKIt0S8bVT5cfV/nccpnWiYRKWi4t/yZ/vJAae/Qh283PqcdrA/s+pWmQpFLCr7M
         5c0h+yEDv4K3hpTnmrW26N/mrQcQ6RSKgtioGMhLMbLJC61DBNgv26qYLLg0T6AMFlGV
         s6gphIak+xBWSXk2Xk/5srSP1f7ezm/FPCRDNXix/NQ0QuZxSLmJUYUiBeBcaujk3cwP
         1I/+kqUf6Bvq3ekPElcN15qBOETb9dA7AUstaxwBWU7HfHXBq9TXzWbjXcfoNhZgHLZh
         /X1+nu+Th+DXLqb6tcurJFVolrHlJZ7C5w3QoOUhHdILXskxjSUFnHBkw806IAWPHf7B
         FWog==
X-Forwarded-Encrypted: i=1; AFNElJ98jdbqvJu7bJgAStgOL94asth6DFARtuUsMJ/IbFytys05wRx/pu8wr7tekLJrvq6zOdSuiuLQf1ONy8E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJpeSAFD+K3mlLu4oJ/csPwxlZv3KkAEINXZpXm9jcQgGZ6jk7
	2n/rOqjO7/M8XPpc3zusm2iau0wsuagJjnRLS3RC8xhW09y2mifWxrrt
X-Gm-Gg: AeBDieuuDHJ71gZ63nZymlJyqWe5bw8jtCpIDaKheIm0rLMuh82Pmp9EkWdknWG1V0P
	A6Tybn7PmJd/XAScZg6Yxif/U+pkFl0Q7mYcygcFpM/tA/4mC6ZA2YWHC9orgCdQJD32/odXwEk
	1RdMvVlOSQnPIVUkw/D5Pc180jOPUKgstVRH6rInI8F+e2OjxSgdeH0sczU60O+I+nDOTKDOFZt
	YzKqr1oc4opJOduBA/kwBWa6jMnoesZQPDN/Lb0klYZiBcca/FpQ0FVe5Z6cUyVfxCjkcv83mfP
	1bwEnW3Xof5xJXF129bNveTnC495An6Z5BtWxBmjGgJSdcmkN4Zb6+2CyLgmQJdCbk84NeRrvn4
	VIy9ChCKlPH7CyTDxTb2L6H6A4irQyITaoPD1XGHJySNnxGSFBF7qAoJ0pF947em1bFi1wEh062
	QHLba38k63i0N77n/FNNbAkAjNO5rxIGXO3c0GUG0z3/D6s9eZDdczTz3wuFZwyQ==
X-Received: by 2002:a05:6a00:9502:b0:834:e882:3280 with SMTP id d2e1a72fcca58-8352d20292cmr13455389b3a.31.1777965163295;
        Tue, 05 May 2026 00:12:43 -0700 (PDT)
Received: from Air.local ([198.176.50.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-839682abd39sm1085044b3a.52.2026.05.05.00.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 00:12:42 -0700 (PDT)
Date: Tue, 5 May 2026 15:12:35 +0800
From: Weiming Shi <bestswngs@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	"David S . Miller" <davem@davemloft.net>,
	Vivek Goyal <vgoyal@redhat.com>, Kees Cook <kees@kernel.org>,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>, Jarkko Sakkinen <jarkko@kernel.org>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH] crypto: fix OOB read in pefile_digest_pe_contents
Message-ID: <afmYY6bDIrKwbwBT@Air.local>
References: <20260430173632.277436-3-bestswngs@gmail.com>
 <afmEQ5ove_8fqEhH@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <afmEQ5ove_8fqEhH@gondor.apana.org.au>

On 26-05-05 13:46, Herbert Xu wrote:
> > 
> > diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
> > index 1f3b227ba7f2..cec99db14129 100644
> > --- a/crypto/asymmetric_keys/verify_pefile.c
> > +++ b/crypto/asymmetric_keys/verify_pefile.c
> > @@ -305,6 +305,8 @@ static int pefile_digest_pe_contents(const void *pebuf, unsigned int pelen,
> >  
> >  	if (pelen > hashed_bytes) {
> >  		tmp = hashed_bytes + ctx->certs_size;
> > +		if (tmp <= hashed_bytes || pelen < tmp)
> > +			return -ELIBBAD;
> 
> I know nothing about this but why should pelen == tmp fail?
> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Hi Herbert,

Do you mean this should be `pelen <= tmp` ?

pelen == tmp means the cert table sits right at EOF with no trailing data 
in between - that's a legitimate layout.

Weiming Shi
