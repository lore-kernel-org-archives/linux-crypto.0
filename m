Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE961411D8
	for <linux-crypto@vger.kernel.org>; Thu, 16 May 2024 08:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715848728; cv=none; b=nRAtSH0vSdGAG59NQthCleBcTNNvuKgYDGqrZ5ffaHvFnUF+wgVbhd2GNbpkPo5DmBE3gUlRrBwE0erLuudbkY7sdGhqhxJKOdoJ6aqrWxnCe6cBY6LCCO8IWb2wrVCjzQXfrm99avaA5C8IGcWK1E9Renccfcpb26ldMQ+ZBh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715848728; c=relaxed/simple;
	bh=lh7fMWPMcn5n6bL+jz5HkQSkNBuVEDIGI5wL//wYXuw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MysUABalfPG9iIfgZCJ5wlvwSATBUXP+ZTqIlFF8ZSqbPTFEbmY17pClLQjoiQYugl9kfc+HmJpdSU+IAFH/fotUOtRLSCm6paoNNKAN1EON7ZpomXXiT0Cj1UmuZPkUQBdIMfgdYMsR5qKVaoOjiuzOhW2DGeoK8si+uNpty90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org; spf=pass smtp.mailfrom=cryptogams.org; dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b=TcacwMIE; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b="TcacwMIE"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-51f72a29f13so591154e87.3
        for <linux-crypto@vger.kernel.org>; Thu, 16 May 2024 01:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cryptogams.org; s=gmail; t=1715848725; x=1716453525; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VOeW1i0XSjN8EcRDRG2ima3ZBqcENGXoN19rlekIi1o=;
        b=TcacwMIEwD+LM78G/WEdMeKWTC6AccDZLRdgHOkTlUVYxVAZeGAF5dwjSJ2KMlRSaz
         mIVTpcOL73Xc4v+lYk1YboR+1gOzIzY4YAIYBWTd+l//K3EL+imVNnGIJgJJLbtWV4Un
         NpZvuvAkrFea/VsStB3kWf/7G5VJ9aco4UOduTQfrPLnA9vzmRljNC8l6w6+Rj0KKJsw
         Y0VsBQYeyWBHrNghbt8HwfkiEe+duiT7vLw1tYbNQM4KSo9/1dB2gUwE9bv6yOTuCqff
         dVqQ13DOD5SjiIDiaEgQn8OyO7zlFIaTGFnDPndXBFFdRLOFSopVCwiUZr6leUwh2r7H
         zNHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715848725; x=1716453525;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VOeW1i0XSjN8EcRDRG2ima3ZBqcENGXoN19rlekIi1o=;
        b=hS0oE26pEtmhqbDBdfa4TpJg4NPL7SfyBu2ivW2SowqN5ZxCfWJ56u/0Wsuhzpq1sJ
         ZnTS3GGLTG5GoqCBhGqX9+noSxlTsvWJ55dNGdjpcZZ3YCSi7Kf2xODlECPc83+suZif
         Q55huWLtsL8aeoAYSfJSerqrX95mwK0qcgQp5DwL45n8j7UEt3sVhYCSVPPLxd9VDd+r
         YVsKyXr2ZnHN41YIM1f/cJVKo8F8T/hl71vug/fTCjW13D9DizVOaU+PPGrnftuCu1j0
         FdACKPfJDoZKEfosgaFVcRZP4Cl56W6vCiC83/fIegpco0MChbmpBPZeqpvIuzxfRgTY
         RPiA==
X-Forwarded-Encrypted: i=1; AJvYcCXBxpft2WU0+qckVyL4eBIHrJ9/LDoy6DkAfDzM9fHe+FwDAXoAKWj6A6HD9KA6GifwWc5QMox4UMXypsRoEzc+rHGxaWi7KUrIti3E
X-Gm-Message-State: AOJu0YxCEaekpWbBALqBiyzIDvfLpEpZZE91+DWh391hXmfBVP8GI0EH
	VkDmlrUI9RzYozF2t/MsYTZ/bq1Qr6slJf3i8iNwWniaSeiGPkT8uN0OclnJjNw=
X-Google-Smtp-Source: AGHT+IH4ciVi2WPFfN4wIB15qPhRg9zSbcHYMDpqRPhOgTsgCJ+nsPiQObpBhEe9fHl4yk1Q/wux9A==
X-Received: by 2002:a19:5f41:0:b0:518:9362:f63 with SMTP id 2adb3069b0e04-5220f97041fmr11199702e87.0.1715848724887;
        Thu, 16 May 2024 01:38:44 -0700 (PDT)
Received: from [10.0.1.129] (c-922370d5.012-252-67626723.bbcust.telenor.se. [213.112.35.146])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-521f35ad461sm2876576e87.33.2024.05.16.01.38.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 May 2024 01:38:44 -0700 (PDT)
Message-ID: <89e7b4b0-9804-41be-b9b1-aeba57cd3cc6@cryptogams.org>
Date: Thu, 16 May 2024 10:38:43 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] crypto: X25519 low-level primitives for ppc64le.
To: Michael Ellerman <mpe@ellerman.id.au>, Danny Tsen <dtsen@linux.ibm.com>,
 linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, leitao@debian.org, nayna@linux.ibm.com,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com
References: <20240514173835.4814-1-dtsen@linux.ibm.com>
 <20240514173835.4814-2-dtsen@linux.ibm.com> <87a5kqwe59.fsf@mail.lhotse>
Content-Language: en-US
From: Andy Polyakov <appro@cryptogams.org>
In-Reply-To: <87a5kqwe59.fsf@mail.lhotse>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

>> +.abiversion	2
> 
> I'd prefer that was left to the compiler flags.

Problem is that it's the compiler that is responsible for providing this 
directive in the intermediate .s prior invoking the assembler. And there 
is no assembler flag to pass through -Wa. If concern is ABI neutrality, 
then solution would rather be #if (_CALL_ELF-0) == 2/#endif. One can 
also make a case for

#ifdef _CALL_ELF
.abiversion _CALL_ELF
#endif

Cheers.

