Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794522178;
	b=iA57aTxN5P5LvmfyFZDJKe+3qZMi9raWUKklpz683K8sHOMfu1lDqW0Z7Yi7c8D772+Z
	 WOaxc/wKRrGu0jnetVyjXdC1vtec3mKZ039zhIJ9mT8QAVKI1hNzKnIWsvzH0q+spNv5F
	 U7lLDiQpR5iqLiXEG988xi2LKhYK5cpnGyDsrJN4TPq5hwQGPZc8UTQcyKGvqZibOkrBS
	 JGAVD8rCIulEQkQdEEK+2wnezM9fg421wPYsE2nszj4nlv2kHzPhEAywS0EIA8EIUS6ni
	 qbdHeQyqAu0LxuzVVwhbuqAlV+nzDMZuqscmPVb9aw5TwgdmZ6y7Np6z+3MKRuFC4tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794522178;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=FXTOhNrZ12I8y3GDlfhK3N8wnDJl6WeN76bC3bk11uk=;
	b=N6hGtSbOC7ys5/f4dp2ORUS7unj/koWDHvCxzGMQUxfG6u/23XHhxbCAph1Frt2orVgp
	 BJ3ZdQHYCahZX+DBrN8rDoaKOpf1jeCITirFVen9lmFeGoZRVlfcGsIPt6Tlo5vUU0bvU
	 mscLgcohR/9fMLk0GNE8Zn4ifuG2SZk+0RS3oyyZztx2bODlTSo1c7iSfVEinyhRZl7+X
	 idg/brW8PglyidmP9QFvrap2xv7Pjo3AIJul5dCNjOt2KD2kRxyaWASeE1P8AWI5XKYwp
	 cD9BdaEhjRimiYXcGygU1CIfZTgveg0M0/XEcH5RWxOKrVeXUFrOObMpXy5aLpleIZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VKgMTrM7;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EDB606A321
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 22:22:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23EDB606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VKgMTrM7
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so3499445e9.2
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 14:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794522176; x=1795126976; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FXTOhNrZ12I8y3GDlfhK3N8wnDJl6WeN76bC3bk11uk=;
        b=VKgMTrM7SkuqCfLXRm8oIqQtXQaQg4lM4s3hpKYGN7ivNEDwILpr2e39a/+jaXAuAf
         A4fdb62eS1rjuakiYLg0++7PUtYg5owAE4dbaQAoVIMudOmFooROpAfZfogsKdN7Buw1
         QjkTqb+O1lEkS6QQMFwup97XWn4lpiqkDCPuObkh1RcrSMYqhFwpech0PWBbtvov+e+i
         WbiIkSd01U7AHb7DUeiQrIt3ljTnF0KbTLEVNRGxJPkjYzbsirirTqLRZTctI+1BMxCu
         atO0pg+yOIWUsKCP7y8406cF0Yyo5SRZFqrLxWp9NeY6gfn4ey/UsreATSym25zAvzUh
         K2Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794522176; x=1795126976;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FXTOhNrZ12I8y3GDlfhK3N8wnDJl6WeN76bC3bk11uk=;
        b=gOskquDUsaTsELIleFx5n0Xl+McPrDw0OznJdXhH0mxAqfJvdTPNc3wVUalH54YqMN
         E9p5Ihfo2F1DQEK65R9xr4ceZBKiE0FhC5p5aYhffd/jLooOabXwNgvNragqfN3LlEbn
         jZVLKeQlRXzXStnnVu1CtTH/Z8E/QWYT6DJTojaot2mB5oHpKclWcnP0TIjIZw1T0dST
         wPiXYNOkTe8BSu262ElH9hDFt7zXjosbtDr3xX1zni4qz2gCJRGZyyPmPljOPiwbbXHB
         7eN+UQ7HgsWTDkmSszFQVHx/LFczSy6+VnYa5GHlUlrw+44H69TDfrHDQWbrSQ1bJmOp
         9Ufg==
X-Gm-Message-State: APuU4Z+Hv5qfWGZPsE/f83hyq1U2tkx15dskk+o8Z1Oor2bEUd/p0jN0
	Z5SsPWMls4/Pt99Szlxf9x32y6OSrCcmCi83IQjsBeHLh3OHwrs38P9YTztNrdH6
X-Gm-Gg: AYBFou1tKoB4FqEeybgLGkXecq3fUAb8BPJpPQAn4C26IMi73oEUGNNK6BFQyTljgIb
	ljGxoFCFfG2U2aaKdxKqzzPEqW7ItWkhdtl8eCnlI6/Vbu6L+9Z4EGiXxJuy1NDmqA71rot2K4T
	yI2W7LCcT2EMYbXJxe7n9N2cofPMdqr3j3BFU6XkUW1o7HEebOWixc2cZBld1V11BSCKGMdsVXx
	SxlNxZLBz+J5e/JekdPqSuSVcSEhZfw+v58AB5KVs7p+ME7H2H2zrfieTxhZR0lLq75vgLvg+Px
	kEFzdU4Fe+aPvuSWONo1P8qQgnIYUvdz+1ecZDZxoy0TfOvPxFicC71cNh4Y36JTsJHkSWDk+qH
	zNL2h7dJ+7l0ER8fDbKvC4OyUndysML2K/pr19eOvsCmHO7x7DaLKfHgSta4nMznfqdwzhz7f+b
	dphorYptCzYkf0vJtesMh5aMCyTOnx0S8yTl+6Caaux8ZL45glc33iWXH4lAd8BtEjeBRgLrAxI
	mVitP16L4OauVN9iyU+R1ZdAmFzk1dVIW9h5/GHl7z94RlXMJEOAzYd4yXaK2sEGQKQrhkOYHlu
	MNENPLfjNA9Tl1x81kFpCnFL+voOIIImEDdC/sfogGEaCcrC60Bc1Q==
X-Received: by 2002:a05:600c:8b05:b0:4a4:4d57:8462 with SMTP id 5b1f17b1804b1-4bb55a99ed0mr13271495e9.24.1794522176352;
        Thu, 12 Nov 2026 14:22:56 -0800 (PST)
Received: from [192.168.2.14] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2842e6sm100830085e9.4.2026.11.12.14.22.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 14:22:56 -0800 (PST)
Message-ID: <01e0bd88-9033-4244-baea-9a1fda095b96@gmail.com>
Date: Thu, 12 Nov 2026 23:22:55 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] crypto: x86 - remove aegis128 support
To: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
 Ard Biesheuvel <ardb@kernel.org>, Antonio Quartulli <antonio@mandelbit.com>,
 =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>,
 dm-devel@lists.linux.dev
References: <20261112164419.1769428-4-ardb+git@google.com>
 <20261112164419.1769428-5-ardb+git@google.com>
 <20261112202329.GA815040@google.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <20261112202329.GA815040@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/12/26 9:23 PM, Eric Biggers wrote:
> On Thu, Nov 12, 2026 at 05:44:17PM +0100, Ard Biesheuvel wrote:
>> From: Ard Biesheuvel <ardb@kernel.org>
>>
>> Even the people that are invested in Aegis appear to have lost interest
>> in aegis128: it did win the CAESAR competition but is no longer covered
>> by RFC 10032, which does list some other variants that competed as well.
>>
>> So let's delete it.
>>
>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> 
> AEGIS-128 might be used by dm-crypt, e.g. if anyone passed
> '-c aegis128-random' to cryptsetup.  I added dm-devel and Milan Broz to
> Cc to comment on the feasibility of removing it.

AEGIS was introduced to kernel for dm-crypt to have real AEAD mode,
I do not think there is any other user.

At that time, there was nothing better.

Unfortunately, I am afraid it is used in some systems and removing it
completely could create issues for users. What you can do is to mark it
obsolete and expect it can be phased out later...

...

> But clearly AEGIS-128 is a mistake.  It has a hardcoded amount of
> parallelism that is much too small for current CPUs.  That was very
> clear when I looked into optimizing it with AVX-512: it just does not
> work, and it uses only a quarter of the CPU's resources.
> 
> That's resulted in AES-GCM now being much faster, as well as the people
> promoting AEGIS having abandoned AEGIS-128 and now advocating entirely
> for other variants like AEGIS-128X4 instead (despite that unfortunately
> still having a hardcoded amount of parallelism).
> 
> AEGIS-128 doesn't fare super well on the nonce front either, with it not
> being nonce-misuse-resistant, and its 128-bit nonce being only an
> incremental upgrade over AES-GCM's 96-bit nonce.  (Compare to
> XChaCha20Poly1305's or XAES-256-GCM's 192-bit nonce, or to AES-GCM-SIV
> which is nonce-misuse-resistant.)

AES-GCM is not good replacement due to that 96bit nonce.

I think other modes cannot be used in dm-crypt for AEAD mode, we will need
to check what is missing.

Milan

