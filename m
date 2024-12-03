Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8841F942C
	for <linux-crypto@vger.kernel.org>; Tue,  3 Dec 2024 15:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238618; cv=none; b=lXSiY1yR4MwqHdkwY1ob5PiZzbcbKRFiKtxzwoBctQam9OAnbUT26kQaZkBoLHvy6CBbxvLXkzuCc8P39gN278b2VeryfdtnDh5INKQwaN1FKKFeaSBJ9x75MxmAGxGYxyES76Y0kozdtCn2XMRb/uvf6JHzOjJyyKx/v2pwPpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238618; c=relaxed/simple;
	bh=U/OoOzXsIi2r7sSP/cLR0FzyZqfuU3DiHqvIkCvcvj8=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uzq9INFTFhKvyHEb3nNf03E82D4VvByKLvLfuY5NBBoHEKSW9CxdPnJUz70SUTgrdJ9/JUTluLsIm8XJoPGL07KFH9l4rpRTUC4HTcAV+2UyqiuATZaRuK7GGCPXzEtXih/+hkR/8+M3tvYMcztnGbNzrLT5P1/KL488fio63bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=SouZNHzi; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="SouZNHzi"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7fc41b4c78bso3265370a12.3
        for <linux-crypto@vger.kernel.org>; Tue, 03 Dec 2024 07:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1733238616; x=1733843416; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:references:mime-version:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=p0ezAqCKNWBAiuxAl3Y2kJKU1te23QxF0JI4IxEegt0=;
        b=SouZNHzingFWow5COB5W5tgVUhP/qi8eFeiHs4lESYZtkRSF2bGbFC1c5NmE97OfZq
         DKb5APHfqw8Q9OIT2nSClQ6gAWzIuHc9ZI7DwsPmX+taeYs9kSVKyg9TYLDFDZud5Up8
         vfIrWcXGdfk+U4eZ3f5Cs4hGQrNpbNSR/6XywidzeuDOqN0XHoeu3S090pUaGOxse7z2
         whcN4x8YlDM5yRkqrvy7vJmnVOG5z+LL73ozPlsYYWCIaDm2UkyvFJ+l84/7oLnpR2rO
         JUDy4k6+sDFzL9DHoY3k537qGV+rFV8pDRZm3dr96hIr9XE4ZHQYw+/zrac1Sxg44i3h
         wU7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733238616; x=1733843416;
        h=cc:to:subject:message-id:date:references:mime-version:in-reply-to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p0ezAqCKNWBAiuxAl3Y2kJKU1te23QxF0JI4IxEegt0=;
        b=k/eTaJz5RjrElbQQN8xsHDMzu2HuxGSGmGVjEBqllvWOk22boM9rtjwzivVbZH3l0y
         RDdTFn5y2R2YBIsLGIknXfgXYigqhg7fpXS/iY6QLbJcs89jHSptCYD1sD3P5jaw1FXK
         zJDEgbEpPAbQ1DJvCuGrTTL1/Wf47PWS/M0zW320AuehwIj4o45KpHfUr0lPVhbkKtqv
         tt6pWvN6wIQ57a+HS8/OXAIs0v7J+uvHpQgIqy6Em2coEk9m2XPlt9dWTsPFAhgxQspN
         o9mrKFTNXC1HVbVmVT8M+XZ39tTEcIPCcXGCCdikJxKd1NLfPelZM8fa/W2G+VRXOATd
         yyaA==
X-Gm-Message-State: AOJu0YxARX6KXNwNT8gep0vqgHTZpBWyxPQz4a3p8t7m17KxbN1QUYTB
	P+4Cluq6QunsHumOIiRSLWCK7wV+3ASZCWoQgT0E0o+a1N1VSWQvzLmUmu8e03ymyWY4I2XjzAd
	dn9tiY5h0rzzBeQRbLUve0Gd9+u6KcQ292wgSSg==
X-Gm-Gg: ASbGncvU0UX9plSDor1jXAOCypVQrHMThpj79rPFrZ4DGKIf9vp8Sj74j8cemrWKpeu
	wlz4Fjrtw6MU5yp0e/UKLcPsDoSE5rnc=
X-Google-Smtp-Source: AGHT+IGIUqVE82b+dvpoCo08vBA9hrCj+aCzVv5qZgUaQJourUSn2MQUzu2S39lm+R0r8d/vqoADCueK4RgwsGjH9Bk=
X-Received: by 2002:a05:6a21:38b:b0:1e0:d9e9:a2c7 with SMTP id
 adf61e73a8af0-1e1653b9c06mr3889882637.15.1733238616139; Tue, 03 Dec 2024
 07:10:16 -0800 (PST)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 3 Dec 2024 10:10:13 -0500
From: Bartosz Golaszewski <brgl@bgdev.pl>
In-Reply-To: <d6220576-eaf5-4415-b25f-b5984255ab78@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241203-crypto-qce-refactor-v1-0-c5901d2dd45c@linaro.org>
 <20241203-crypto-qce-refactor-v1-9-c5901d2dd45c@linaro.org> <d6220576-eaf5-4415-b25f-b5984255ab78@linaro.org>
Date: Tue, 3 Dec 2024 10:10:13 -0500
Message-ID: <CAMRc=MevaM4tUNQUs_LjFYaUtDH=YqE-t2gBponGqtK5xE9Gpw@mail.gmail.com>
Subject: Re: [PATCH 9/9] crypto: qce - switch to using a mutex
To: neil.armstrong@linaro.org
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, Bartosz Golaszewski <brgl@bgdev.pl>, 
	Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Stanimir Varbanov <svarbanov@mm-sol.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 3 Dec 2024 14:53:21 +0100, neil.armstrong@linaro.org said:
> On 03/12/2024 10:19, Bartosz Golaszewski wrote:
>> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>>
>> Having switched to workqueue from tasklet, we are no longer limited to
>> atomic APIs and can now convert the spinlock to a mutex. This, along
>> with the conversion from tasklet to workqueue grants us ~15% improvement
>> in cryptsetup benchmarks for AES encryption.
>
> Can you share on which platforms you did the tests and the results you got ?
>

Sure, I tested on sm8650 with the following results (they vary from
one run to other but are more or less in this range):

With this series:

#     Algorithm |       Key |      Encryption |      Decryption
        aes-cbc        128b        94.1 MiB/s       138.6 MiB/s
    serpent-cbc        128b               N/A               N/A
    twofish-cbc        128b               N/A               N/A
        aes-cbc        256b        94.8 MiB/s       128.5 MiB/s
    serpent-cbc        256b               N/A               N/A
    twofish-cbc        256b               N/A               N/A
        aes-xts        256b       132.9 MiB/s       131.8 MiB/s
    serpent-xts        256b               N/A               N/A
    twofish-xts        256b               N/A               N/A
        aes-xts        512b       122.6 MiB/s       122.4 MiB/s
    serpent-xts        512b               N/A               N/A
    twofish-xts        512b               N/A               N/A

Without it:

#     Algorithm |       Key |      Encryption |      Decryption
        aes-cbc        128b        96.4 MiB/s       141.0 MiB/s
    serpent-cbc        128b               N/A               N/A
    twofish-cbc        128b               N/A               N/A
        aes-cbc        256b        67.0 MiB/s        97.8 MiB/s
    serpent-cbc        256b               N/A               N/A
    twofish-cbc        256b               N/A               N/A
        aes-xts        256b       131.7 MiB/s       132.0 MiB/s
    serpent-xts        256b               N/A               N/A
    twofish-xts        256b               N/A               N/A
        aes-xts        512b        93.9 MiB/s        96.8 MiB/s
    serpent-xts        512b               N/A               N/A
    twofish-xts        512b               N/A               N/A

AES-CBC and AES-XTS with shorter keys remain pretty much the same. I'm not
sure why that is. I also tested on sa8775p but there are no visible
improvements there. :(

Bart
