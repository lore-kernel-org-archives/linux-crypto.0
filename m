Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4EC256C6F;
	Fri, 25 Apr 2025 13:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745587704; cv=none; b=vAEbUx+vMEfQrJUB2eQrGmn82/HmoEODl/SsfxAsvV82nzAuh2ohZOLuwyGnb8b5vivq5DX0A+uewnKiM12Ce0ybxY4ct6Wq/Rxe55bmnEs6Wf0GUEaMa+yu/F9bPjXfujXejILTNvhYYYbKN7eigkkW89lCZxWvPeq3xoF5EGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745587704; c=relaxed/simple;
	bh=mDs1kublQxCA1O7cB2fREvwvXpYdNZzxnOO/aSHfTbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VyNDpb6fM25rm2D9p81mtZt15iXqW5yqhYwfYIMZmIv7mR0sxn/HaVF6jyHOlljF3zono8I3s34aqyVGX+1H6UIGmhm1r53yZ030pMbkNLoDKqxtq9+rtHRrChrAdA+2lZNgItWQmkFhMWxZCu3kWPJY1WGqCAUF8rGYRx/MapA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ac1FfL4g; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ac1FfL4g"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43cebe06e9eso15849965e9.3;
        Fri, 25 Apr 2025 06:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745587700; x=1746192500; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aug+uhhO10dT8SA1KkPf7sPRP/dd7tZddbirMjYFdb0=;
        b=Ac1FfL4gR4m5aSPPSl7gVv+CijBQ+YaPVdP7SpT5swarWLB/rMp670dbqwE8gvYOuh
         c5w+ssWnCJ9Zy9qYQjg8xU2vChunkFIsahJMjQV+gpXEanVEspjNQQvj0yR1Y8/3sopT
         tJn3izENXHxxb4AOROlB2Je9wwheJVxaegV/FA0RgZxe0PJFOl97AsmyqF4x0unryHpV
         HuaEdwnA1ZmvBs8bsnO4+3bjcp/Q6C2HvULjFiPfC5qT2Esh8CtONMZJhMrspHvOCw1Y
         jA2zSllQCBmJUfQx6poRjshFjyL7Dvm0OZT0ClN8igEe4WIXhKv8DGU/XlucNI6vwl+c
         tbow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745587700; x=1746192500;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aug+uhhO10dT8SA1KkPf7sPRP/dd7tZddbirMjYFdb0=;
        b=lzwFaxgES0RwZZ0d71r4KnMVDjd1Z4S9C5+PiDzQKC3X8U77sRiuZ8BMP2TQOYEYu2
         AvE+ooPCVS5fXtHevVa794nqZtPdRWqYF252+MKXW0V1OzJmasm1FKTlWbtkW9A14UXd
         cyr9ppEkH/hNiinBV/8XOrqtjH7OWJ5RJsP7MeLupzOVz6U+t4tqqsnHpjX4ibfBA2sz
         tyTbAsOtimoEMlUNPnCVwjNmWGC4Tzr4kam+u/G0kJMR03dtdLoGvAxxd+Ng9x6/2mf9
         s61BewF4PqS0odOay1Sq4UbKWkaIezmB3KVyMutoMng79ofAq2rBg3Wcg5miXv89Mnna
         YxBw==
X-Forwarded-Encrypted: i=1; AJvYcCX8J4fB8LFzCuB+/XeP3OStsbheY89LObHSJs7/bllfb6yMnuQS8wMgJNmRLOygNa3k8eZKXLzcvsV8Z5E=@vger.kernel.org, AJvYcCXIFYqIA4auXhLPvTXBys2EcAzTKAPRPmVSDo3SZCoIiDiBClKP7AqBBrJb6zWPENSTeceW3IJ3/jfERes0@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7zXicioPOwABb45xMgl6YGOB/OeRwd4KkFShAFAGJpJOUI5/G
	j4ZHOvrZ9B5GbziawdQP7rG9zwQhdcVSlbmxpZ8tJxDCTIjDMySQ
X-Gm-Gg: ASbGncsMIpJhPj142d8i54xr2yVod7q7D/JccNA8yXoZHP6VrtOiCbi0oWvMO3/YPK3
	KzcufNybRiefes8F05LDnnqYDR7fJmGQJ+gqg4yH/fFdZkiMOt9+JDNwzfLCbiqoOchXpb+sKmS
	p+csuJp8Y+jsUsRiazFVAEM/4S3Xz8oWFc/8prBMVilr3ZCtPKJLyKb2oMf+Ero9xzFt46mF/gW
	pDOqzmOWIT/ndm6D6BZutYgKwQsXnOlv5M3s3DWTEKEp5n+OWM3cbmmevvI4Hbr4frgMsEgZXu4
	ZMF9qE7zKtlFnRh0WDyM/1tDVTfocJMfUQiDwq6hVZSp0Ucqlgfi
X-Google-Smtp-Source: AGHT+IFSGC6ia6yK5H9T8nOwC67dP5jiFTss/M9i30fMyhHSIu9i6Cr1xRw6VNVbGW1I/F1aUlxm1w==
X-Received: by 2002:a05:6000:144b:b0:39c:2678:302b with SMTP id ffacd0b85a97d-3a074f14a59mr1999330f8f.45.1745587700424;
        Fri, 25 Apr 2025 06:28:20 -0700 (PDT)
Received: from Red ([2a01:cb1d:898:ab00:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3a073c8c7fesm2394207f8f.6.2025.04.25.06.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 06:28:19 -0700 (PDT)
Date: Fri, 25 Apr 2025 15:28:18 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, wens@csie.org,
	jernej.skrabec@gmail.com, samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] crypto: sun8i-ce-cipher - use
 pm_runtime_resume_and_get()
Message-ID: <aAuN8i5p1HlEkFn6@Red>
References: <20250425124517.2225963-1-ovidiu.panait.oss@gmail.com>
 <20250425124517.2225963-4-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250425124517.2225963-4-ovidiu.panait.oss@gmail.com>

Le Fri, Apr 25, 2025 at 03:45:17PM +0300, Ovidiu Panait a écrit :
> Replace pm_runtime_get_sync() usage with pm_runtime_resume_and_get() to
> simplify error handling.
> 
> This is recommended in the documentation of pm_runtime_get_sync():
> /**
>  * pm_runtime_get_sync - Bump up usage counter of a device and resume it.
> ...
>  * Consider using pm_runtime_resume_and_get() instead of it, especially
>  * if its return value is checked by the caller, as this is likely to result
>  * in cleaner code.
> ...
>  */
> 

Tested-by: Corentin LABBE <clabbe.montjoie@gmail.com>
Acked-by: Corentin LABBE <clabbe.montjoie@gmail.com>

Thanks
Regards
