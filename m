Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E81288A5;
	Fri, 25 Apr 2025 13:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745588860; cv=none; b=YBpUf+TiS7q0qpOU9QD+XJcjECDoftt6lfGfThk/ioa9w06VB7psdHQGZk7MpS+52YIy+PnTaFRSy+llhasbcvkHPa9mHQX3Rlc3ILtVEp//JmEuI7Bb4Zl504RW91O3iIX4aGTYgnkaslZ8jQBmjIUA+NantQY76mi1CdfEg7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745588860; c=relaxed/simple;
	bh=A0BqI1OhWECGRoHXOwEM5A1fqp0J7utKdtX59nddDMI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IrmaXLaHhqFfTQZeLDBQLow6LO8WRnmRs1F+fNv0jYFImf70SnkjrP1f19RnByFxyszRAspSfOj8lxyaICQPfpk89DkgDJm4yG2wmnGfh0ksR3wZG4uWJkxHGAxdUHci9SptahQlRLfz3wr70Xjvwb5LQvOdjovPCA6n8t/giCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EXdIWQ78; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EXdIWQ78"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5e5e22e6ed2so3601292a12.3;
        Fri, 25 Apr 2025 06:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745588857; x=1746193657; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7b2k/0/MRDFBkYnkScGuwVZ9DXdXvkWRFpO84oyIems=;
        b=EXdIWQ789nRnW0vE8NKmuUGjwMieBqTUJwcoxA5Bw9qmNPrdGbOLNfb6sGnlej8H9o
         eU7H6b5PHx0gea7dmg1dvdOcvqmVUQFJq5xYwkM0IGq+pyRfxoY0VXbhZOUTO3Une+1c
         m1vyDHBgZz5O3sJ3SlZc7lQ2K6fMql95UNqdXJeAI9NGg4Tz0wtNFx77vy1+ITGVhYD+
         S8GM9wfUS5q3xy11m54hpIcJeCXBRkbA4XIb12Ah0m6SadTMPF2sa4k8lvHsja8GKihm
         39/JwX9v8QgzKe7DXv4a6ZWseUGNqlcb1qGOFSa59MwOckMUI/4qyYDzQN6OYXdKU5mk
         vF/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745588857; x=1746193657;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7b2k/0/MRDFBkYnkScGuwVZ9DXdXvkWRFpO84oyIems=;
        b=L/S7FgnjHOACvJG3VvMD6ehBW3/1dZ3iwoZOWtmbTyxOJUhH26RzdqbLGgouXxaDct
         pfBZ6LPSOJePVjcoviNEYQbGHeg06Zxe8ZhKRyYk/CfbzS/2w+1bEs99pGZbNEGPjsTO
         AsKjcgBogSFpiK0I4Vi1U/AWOWAv6oAQi8mOuBtrO8oeZiURdMnytiXgb7X95nKJQ5c6
         PGx/hJZ81XDmOOUi7O4yZF+PXK5asU3SvRKzwpemYtujRi/B+jyHrotRj/66TzVIFK5O
         o1IVyn1/1/RMhKKoVVZpoGmDGzO7uKpGRBgeHchYvPRHaUq4Q5srK7/fUoj91wgdv/3/
         eHYA==
X-Forwarded-Encrypted: i=1; AJvYcCU6OEOU+hyfyAryLYcqLhN9qnKT08x6AoxeHArRSWpJDyhNNtx7iMGRRr4p0vyH3O5aDWUUzNPmfJnlW44Z@vger.kernel.org, AJvYcCV5rdlG8t6Tn0flBlHsTY3hr47bd+Gc/CGYlNmcGk9NmyZ1rFZllf6bHwGEEG8NPkI5+vWMJPedzIuPE6o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzi/BANE3+AUdis50RNDUGHSHyu4RCEvR02dDBiXd2J331pz4XS
	deuwEs04osUASu0j55xCK/sYXBNreuK80YS7EkJAe2clnK7blZQH
X-Gm-Gg: ASbGnctacnwNndKOOXCr/AW1Gt4mqj2T85Z20LVZrS+mjrjRfRXZoa0GVyyhwM8o0Ok
	iDRYBY2I3KKG2AZvkm7apCVzzAfRm0P46sj47IohqaWR6R42LOYjOHVjupIRtG6umEhORHpxMyq
	qcxl06iTBCm6KtCTmfGbXtN6VsF9gcypX1oYztwpkuBBnNOti8ObrcSoovcTzei8S3pis09PTSo
	nObf6hVlhG4KQLWUS9TjAcRVYBh0qIVYntH3xSDi6QWsexc6p5bDgq5NkT//ecvE+CSBvqADvpa
	VXcD2KNJjwN0PlSCXNpnZyfb8uBOKomKxdSMjlY3ptRgN60DSDpkZP6imkY+KDLuClzZEmuPssm
	+Tzv4u5D/D5CnU5/koegAMJyHug0ZRTOP8qst
X-Google-Smtp-Source: AGHT+IE3+U9lKdyIw2HglYpHlU5Ju6Jvd02RlixVwiVpib47lTMUqn1jZXSuE/LNf8JT5D2FHFI2jQ==
X-Received: by 2002:a17:907:3f0b:b0:ac3:3e40:e182 with SMTP id a640c23a62f3a-ace7109ff27mr235634766b.19.1745588856499;
        Fri, 25 Apr 2025 06:47:36 -0700 (PDT)
Received: from ?IPV6:2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6? ([2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e41cb2asm143227566b.10.2025.04.25.06.47.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 06:47:36 -0700 (PDT)
Message-ID: <7653bf7c-03ac-4f94-a80c-2bfa3004d287@gmail.com>
Date: Fri, 25 Apr 2025 16:47:35 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] crypto: sun8i-ce-cipher - use IS_ENABLED() checks for
 debugfs stats
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
 linux-crypto@vger.kernel.org, wens@csie.org, jernej.skrabec@gmail.com,
 samuel@sholland.org, linux-arm-kernel@lists.infradead.org,
 linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250425124517.2225963-1-ovidiu.panait.oss@gmail.com>
 <20250425124517.2225963-3-ovidiu.panait.oss@gmail.com> <aAuOdDhpnLE5bM_y@Red>
Content-Language: en-US
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
In-Reply-To: <aAuOdDhpnLE5bM_y@Red>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

On 4/25/25 4:30 PM, Corentin Labbe wrote:
> Le Fri, Apr 25, 2025 at 03:45:16PM +0300, Ovidiu Panait a écrit :
>> Add IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG) checks before the
>> fallback counter updates to make sure the code is not included when
>> debugfs statistics support is not enabled.
>>
>> Also, drop the existing ifdef guards, since 'struct sun8i_ce_alg_template'
>> is always defined, even with CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG disabled.
>>
>> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
>> ---
>>  .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 46 ++++++++++++-------
>>  1 file changed, 30 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
>> index f03a8fa7bfa2..433cd18f0b5b 100644
>> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
>> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
>> @@ -34,22 +34,30 @@ static int sun8i_ce_cipher_need_fallback(struct skcipher_request *areq)
>>  
...
>> @@ -101,9 +117,7 @@ static int sun8i_ce_cipher_fallback(struct skcipher_request *areq)
>>  		algt = container_of(alg, struct sun8i_ce_alg_template,
>>  				    alg.skcipher.base);
>>  
>> -#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
>>  		algt->stat_fb++;
>> -#endif
> 
> Hello
> 
> You put IS_ENABLED everywhere, but here you remove it, why ?
> I think you forgot it.
> 

This is already part of an IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG)
block, so no need to add an extra IS_ENABLED() check here. Just the
ifdef was dropped, as it was not really necessary.

Original code:

	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG)) {
		struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
		struct sun8i_ce_alg_template *algt __maybe_unused;

		algt = container_of(alg, struct sun8i_ce_alg_template,
				    alg.skcipher.base);

#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
		algt->stat_fb++;
#endif
	}

Thanks,
Ovidiu


> Thanks
> Regards
> 

