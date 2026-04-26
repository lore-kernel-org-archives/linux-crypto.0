Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0131A317D
	for <linux-crypto@vger.kernel.org>; Sun, 26 Apr 2026 16:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777220209; cv=pass; b=GFJ1anQ7TPjiUzlb1iKUuH04Jrd/EDHRKVkmqJhuWGSbIhHnIdSS9lkPPw9mFfXikdhty7abYQUeh9qfMu+tLwb71cYJSS94sry8iiduoYydzWLno5+p09IDRVVW08ICrdQk6iWq60hE+3OCnn7thLdFanwjNJxnA66n8NKzCnY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777220209; c=relaxed/simple;
	bh=Sy8YQRlXFMqq09CaaFPTGPZaqT5UhwghzbyWM8yjEtQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=heQBFHBV3/3zg4cYVTvSmqKEoJFhhvQYmhIkwtPWnN+dt0MzMtYItWXcahtMybpT50UB52Q/pLAilo6TsKPzFkIm7zymFMlH7UUecqWopRGIGxAvL+BR4aCjX7hLDJnJGB+J7BWqegITVYOIs2NJoSBCKwplGKzNXkFDOpMBJpE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=heJT5PZw; arc=pass smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="heJT5PZw"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-651c36a7ee9so1321224d50.0
        for <linux-crypto@vger.kernel.org>; Sun, 26 Apr 2026 09:16:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777220207; cv=none;
        d=google.com; s=arc-20240605;
        b=Y0Bqoxnkc5A0u31alMoibrXm+/v6AqXF+LIgKwW2ztqBJxoMg5FQUW3g7H8cz/F7Ci
         YZRXJ10PXCvm6fVOBvcKMRgJ9+7Vq13Vi9Q1Ho0nCNBWU6b18o0WMpLTGOuVA2923kPl
         MoQhcu/zkS7/OBFWI/lCOJTdDmbOkXaM9hUmghXNLFHz+cEDhQOyXeq8jNJrJVVnWHg6
         Px5HVpyg1UgheSPIzRmVpkZTwz2XQg910XBzb9dWKhfCuUPiq9xDYQSLNQxFt2CoZNfM
         HXtMKJgS+E6swdtIkFR2eWl5fIEeVsgLxbd0kfGqcY1ST3/Ctdus1v2G2nrGfwfEqxYI
         Bkog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Sy8YQRlXFMqq09CaaFPTGPZaqT5UhwghzbyWM8yjEtQ=;
        fh=2vz8AjNyGGHgQTTjl4LvA5xYzNVS+43vpOwuSvzBDog=;
        b=eJRfhUARj04eY9tIZjT9Ahlqsm70IkBMW+6apyyknpJyI7DMx/Hv/8ichnaJd5N1/n
         XPGED4eSAs432gqyQt04sPw7TpmstuNpeUO/UJUAlLovhISU+fZ94BSQLHCXUU9IXdGF
         FBWVa+JaH4GSuC+awUaE45Se674TJ/2A4mAtI87bJyTDWu4OqLeu1pbaQP9PSgzpY7C4
         CQoYqRH0qV9uhcKPUfh8wzjgNcZxqdAEuhU/8BPsMCwsn7x71uyKaFuIYvu+fMUOOt3B
         62hybzVoNNRRh6r8aX1Ox9JRNvxFgJhnpharVVr7T71iyHdebenHvW6lciOkZT/fmi10
         yhUA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777220207; x=1777825007; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sy8YQRlXFMqq09CaaFPTGPZaqT5UhwghzbyWM8yjEtQ=;
        b=heJT5PZwxvafqJjWcSPx2IVFRv/xEz1C+KqonS4GCdQvoBE97sRC7uR3QWy/Ka2Wyg
         2EjViJuWVz7Gry/+dby4z8hL6yojhig3yqi22H2TqONrFO/2MCr6KAbZaDGP0ewJF8BN
         O1cx8nDqgxyphFOOfyJGv5lFpycwTGNffIgS01ZhYuEiSoH7bKofc95UFsX4jGLfqLsv
         6XALZHfc3WTMXaJMHvGCLaLB3oBDWDCyjJbkPTdUR1yJ9CYuHFJMQn1s2/fXsEz4eo8f
         HN4z2p9ExfuYZIPPl9CYGkz2kXjo9wppLwJ7a4/y2kU9DwlltMJsbALqsb6/GPkcl9qE
         H9Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777220207; x=1777825007;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sy8YQRlXFMqq09CaaFPTGPZaqT5UhwghzbyWM8yjEtQ=;
        b=rsG17IHhL3yNB4SUBsfkjM9MIYFghXiLvC58BeoGgiKZbFZfS1qLeVn4Jj+XEfFemt
         cLn++nhVPKbhFAjyk84s4k5eiTkhsW4ch+vz0xPejqu7WloGRbi2Y/613dlfefxRe4yD
         RJBVR16kgjCi0VHVWep1MkGwFFrgPqQY5FQkG+AaiKAsUx69CZcgJEbcaJ1jZH4QuSuM
         XJ4otHAmniIyA5C+0lDFlR6j7/ryCvrIzNIQvlqaGYRM9oQRsd4M05nhWkayMJnKfpXr
         ebQpzCNHh6D33HGU82kRPsBzknB/ZqackmkmNrwT8G4Yd2D7U3xAN0XddaCLu3HCp+LE
         uvPw==
X-Forwarded-Encrypted: i=1; AFNElJ9TlZlwKVSentWablQROplX1peCGQ6PbgeevgVd4rtTxWnhCMA+htsjLeghF7VXvJ9ZaJJXdfQVV1iCUJY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIhtbmQZs+Z5b/GarNaj7kNSWdX+8qIgtHCVmji9zXrnmzw6WA
	sSN8FTMQqI395hnIDLrlIf4NSJifBxN0OkvvQp/00bON+agk3us3gGtatxoHRz2zWVPqdNtiasv
	lbeKPf3dZZI81kFHMBTpPeZ9LC9RszbQ=
X-Gm-Gg: AeBDievnoa6iAy0Ny5lzNK+5GmG9FInjBXaqnP1jmEmsYkEa8xTxjfDDWczChw1fKBt
	74eoW7ANehDs5cXIVmFW40nMbSm19DboycF0FnRhs5ZICw69jJloEyBDwkuHaCguUcISAB04KK8
	uLIjup03Q6urXvCF5iMBbdRTNS20SriFhb9+4Weq34EneDnZtjUoptt4faMYV8c96KNCTGDRJfY
	vrSyfmYxgyTwgampqskwsE5ake9V5hit8at80GUkMLO8LFTgSGz1hzhw42EQbXW5TUMfQolz99x
	jSj+cmnpQ0yajwLk9yKPrI0O8w==
X-Received: by 2002:a53:d04a:0:20b0:653:729:d3ab with SMTP id
 956f58d0204a3-65310a14db4mr18143727d50.3.1777220206629; Sun, 26 Apr 2026
 09:16:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260422210936.20095-1-l.rubusch@gmail.com> <20260422210936.20095-2-l.rubusch@gmail.com>
 <ae4UD-JGUarmSMiK@linux.dev>
In-Reply-To: <ae4UD-JGUarmSMiK@linux.dev>
From: Lothar Rubusch <l.rubusch@gmail.com>
Date: Sun, 26 Apr 2026 18:16:09 +0200
X-Gm-Features: AQROBzAdobJWO6tfhp5JyVRYwJsSwcINrh7XtzsayxG_8kLpGQyyKxDyXpGwq9g
Message-ID: <CAFXKEHYMxZ2AP+LHyjB1dWAqx+N+bEZ=xn2HDYpmS3axd7f9wg@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] crypto: atmel-sha204a - fix memory leak at
 non-blocking RNG work_data
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, 
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com, 
	claudiu.beznea@tuxon.dev, ardb@kernel.org, linusw@kernel.org, 
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Thorsten and Ard & ML,

This is just two general questions on some details of this driver.
Perhaps you could
give me some insights here.

On Sun, Apr 26, 2026 at 3:33=E2=80=AFPM Thorsten Blum <thorsten.blum@linux.=
dev> wrote:
>
> On Wed, Apr 22, 2026 at 09:09:34PM +0000, Lothar Rubusch wrote:
> > The driver allocated memory for work_data in the non-blocking read
> > path but never free'd it again.
>
> Yes, 'work_data' is allocated once on the first nonblocking RNG request
> and reused for subsequent requests, but the memory is eventually freed
> on device removal in atmel_sha204a_remove().
>
> The memory might be retained unnecessarily after use when the device is
> idle (probably negligible), but it's not a memory leak.
>
> Best,
> Thorsten

1. Actually, having `work_data` allocated once/rarely and usually re-used.
Stupid question: could it be allocated also with managed device memory? I
usually use devm_ allocs rather in probe for related general instances,
here I'm a bit in doubt. Could it be used here as well, or why not?

2. In `atmel_sha204a_rng_read()` there is the function variable
`struct atmel_i2c_cmd cmd;`.
AFAIR allocation on the heap is preferable to stack variables, particularly
for structs and any non-primitive types. So, wouldn't it be better to have
`*cmd` as a pointer, dynamically allocate memory at the beginning of this
function and free it at the end of this function again?

Best,
L
