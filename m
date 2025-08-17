Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84672673AF
	for <linux-crypto@vger.kernel.org>; Sun, 17 Aug 2025 11:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755430872; cv=none; b=bvHIpP/MI4HiGq9x21uVVc4QtGsEnIzPnwvRRNSf//86niQdNoyMv3mYAIgKL2F+gws/T9IFCJpQerN2kSdbYckQE1xsHt/PZqLCRrIBXqKMeUIcn7r68i26qGTqaatTmrXLtIB8/vv1BGy5rGNv95foZ9qY074qRiu6CHDiHcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755430872; c=relaxed/simple;
	bh=2RVxrCzTy+ecfHF7m7O1IyKNkrK0irln//4QRTs6s1U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mklWuC8ciedvqaKnQUDxNyk6pKxMRErDaLpVs4qNbvmQg3p+/Ljl57dW0tMJ+nt7b77DkwBxCItiM/GkGL8WGnxfhkr9SBfpiDvANxmSCWYUNcPgb3MHS4pFpN6D2TqK7Yi6PbBFPmyI93IYolutOrTf4AnwRBxvwkBplr5eUoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org; spf=pass smtp.mailfrom=cryptogams.org; dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b=j07NEzMM; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b="j07NEzMM"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-55ce5247da6so3425033e87.2
        for <linux-crypto@vger.kernel.org>; Sun, 17 Aug 2025 04:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cryptogams.org; s=gmail; t=1755430865; x=1756035665; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EYJ+YmJH/QJFK3QPKh3mCliyXt6+SxftDgDgHhCJCZI=;
        b=j07NEzMMXrTy1opRM6BQc4WOlR7sK19z748XNbyyNHjAfmnIU+xR7uX2D2DLdDDlqq
         0mEwifp3DcheRXu0bYNdpFDGoA89mcRLUFzmezDegif0y/AkM1eGcz122CmzBzwxGGK5
         NBk/9dV3rkJtmrpYLIS55ovEHV5O5HAjGabSnoVQLlZsgnaY3n1Z2tWaj8EPTK576jpG
         PeJJc9TBB6h+V3fx6jn6Q+P9VLl29bTHgz2Eg4ERYNVJkMzm7L1UaTVxUlXBxoN/3L/s
         C0KVnT2Tn4hG8wVA7JH7Q+yz3B9fO9OOPGcWVgjFYyVY8BC7b0DhyMU37OCD4SwVRt+I
         ggyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755430865; x=1756035665;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EYJ+YmJH/QJFK3QPKh3mCliyXt6+SxftDgDgHhCJCZI=;
        b=gR/U7BMuoQdBlGwS1K5QHG8EFeekjPyQsYLnE+ecWuKHZ91iiMSVMU1Ty0FDBvvmEQ
         Lvq8w0S57c1Dwg7QnpTr1QDeW3Wbs3iV3Y1rz0sx1pwtyu3sbKDNfrh5vahgBxNZMR/g
         4qRaQ9NerXm7uJee29P7Lb++xXvfc6QCea2Ga1vXL0IoqqQ5jDj0Q7fb9MEuJoDfLEU/
         EyMiYAyeSRAhb2+ZfLNWMpgsTDIyTsIKH5A/Dsx70gVeAqu5pGFl23DfvArdeKFS0YTZ
         Wq7+Z2ubEO8Dly8+yFDLMsFVkj47yRCrRp8G4oLpmb2ehNEXxOUg+RzVNsTeFN36a1vr
         X8hg==
X-Forwarded-Encrypted: i=1; AJvYcCWx1d0U1ruD2jXRJf1DTCZN16RRQKgtnwy7H9hPP8vN+BY2/A8/u9hL7wbC8pusbj6FxCOlCr9pW9iuN7w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVtP9/m/0swr0ulrmaRDW5p6DgRD0Iqx9xOD6NthrrmqfjsJk7
	GNvqgvN4zcG5VpjSQ0AC8PJAlMn+mkE26xqbq786W4K1xCOBvlPEA88kz80vlieueLI=
X-Gm-Gg: ASbGncvXKBxlqvuPUKvDm8uvogW7BUibNBZ0JPtLR0oJj+ACLOcnPHlcwVRutn4VaxI
	Z+fxroCAE8mCw+Z1qxyN60SzQH/eRipDFMUyv3PWGVpAY2vUyJ7EteGVdpQZA0cv+O+c6tlFLb9
	84O3Viu5e03i4tVJtzMXNOH6iCUsMp82Fw2ESElvyInefByo9QrgIJcRLhh3/9lXJadgP+97nUd
	4bzMCdp4P1HpNchi8Cdb2LvUGwkiGGlea8KOoC0Qd03AfJFu426zYxb28Ebre1pG5WcDXAtQmSn
	4oj8jF1/3Yv4V2LFNNtA4tWTg0aOXDgZYr75autIJJOTW42zIx4ahrG5INLgx0sviXNmSeKIP06
	8h5d0mLQoBz6jm0xJqs1Y+2qbn/ODptDcobL0pDfHOtm91deVhl5WDXiGaWVdVLYv2A==
X-Google-Smtp-Source: AGHT+IE8dO5R02xyu+qWmBSjeSZeP8c+5NZHdslpk+tly4n/ZsJgKJbx69ZDR41YXG62hz0YCsX79w==
X-Received: by 2002:a05:6512:1583:b0:55b:861a:d2cf with SMTP id 2adb3069b0e04-55cf2cdd182mr1262304e87.26.1755430864685;
        Sun, 17 Aug 2025 04:41:04 -0700 (PDT)
Received: from [10.0.1.129] (c-92-32-247-84.bbcust.telenor.se. [92.32.247.84])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55cef36acffsm1212000e87.66.2025.08.17.04.41.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Aug 2025 04:41:04 -0700 (PDT)
Message-ID: <1d962466-dca6-4b0f-accb-efa02a279ca5@cryptogams.org>
Date: Sun, 17 Aug 2025 13:41:03 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] crypto: riscv/poly1305 - import OpenSSL/CRYPTOGAMS
 implementation
To: Zhihang Shao <zhihang.shao.iscas@gmail.com>, linux-crypto@vger.kernel.org
Cc: linux-riscv@lists.infradead.org, herbert@gondor.apana.org.au,
 paul.walmsley@sifive.com, alex@ghiti.fr, zhang.lyra@gmail.com,
 ebiggers@kernel.org
References: <20250816083943.120700-2-zhihang.shao.iscas@gmail.com>
Content-Language: en-US
From: Andy Polyakov <appro@cryptogams.org>
In-Reply-To: <20250816083943.120700-2-zhihang.shao.iscas@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> The file 'poly1305-riscv.pl' is taken straight from this upstream
> GitHub repository [0] at commit
> 5e3fba73576244708a752fa61a8e93e587f271bb.
> This patch was tested on SpacemiT X60, with 2~2.5x improvement
> over generic implementation.

Just in case. The fact that the improvement coefficient is higher than 
one quoted in the poly1305-riscv.pl should not come as a surprise. 
Baselines are simply different. The Linux baseline is 9 widening 
multiplications, while the one used for the assembly module in question 
is 4 widening multiplications plus 2 non-widening ones.

A clarification to my previous message where I mentioned that I've 
adjusted benchmark results for U74. It turned out to be some weird power 
management thing that affected the initial readings.

I've also mentioned vector implementation being developed. It's now 
committed. On a related note, ChaCha20 vector implementation is also 
optimized, though it needs a little bit more work...

Cheers.

