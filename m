Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723E213F43A
	for <linux-crypto@vger.kernel.org>; Wed, 15 May 2024 14:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715782823; cv=none; b=tYfyrSRTzMLBjYEceo++vqZfEm0cyNbTWJ0Oq9nVC5exlzDTAkKDsai1mR6t2QDVxtz8aDFyoDc+8LtCFgyPP/C212gpAlA+VGuBo0yhbq+z2SurxA6OClHrcRkr6Ln5mt4B9Xhle9kP0A8BnFMxAcrOdnGGHbCX4HA+klalT+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715782823; c=relaxed/simple;
	bh=1C57CUiL1Kka2D5i9WpkZM2PY3ffkcQ24tMi/9DBSTQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kJKSwWA2zVROtTFQZOayT5t/IXXoUQABr78PGtykdoRiNLIzMwN8O5FemeUMkawRWPB3xCi+aADD34cdStziTkjH7ErdSTFXu44uiYEMrg9gl1Bvg/qIUs8PstIS3f0JdMouODQijbjDWsbuxMCP9ejzzuQFc9HxewWaT3BhqQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org; spf=pass smtp.mailfrom=cryptogams.org; dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b=UwqTwUIA; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b="UwqTwUIA"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-51f74fa2a82so8214837e87.0
        for <linux-crypto@vger.kernel.org>; Wed, 15 May 2024 07:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cryptogams.org; s=gmail; t=1715782818; x=1716387618; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=16qftxrB5EgdSgH7j+99BTnIlGUnb8pcrY5C9J7hC3I=;
        b=UwqTwUIA2IgoMWanw9qiSqp+JKR0knI3sUIFvJR7l7wYRYsNjPv+xFWCZsRuolhrQ1
         QvuGR8FIwva5i34IF699WPDgAdPnV0tJVFDnU1C11cGd19u1dJd6UnSL8VuG7m4/ShkX
         /1JVjmfMem/hB2xg2ak0S7jGFiymSVm46tdlIpZ1CuzeM1nIz/auT0spSgC8BRDD+mnx
         bUDjQyvQYGwSCgc710JrlY3YUyo39f4d2Wa2qrX9Xa7KAdx5kgn17lKCQwu/soTqlcBi
         A3YXPTY39QLE6M1DnjXVqibZPstFyAM2Sd7kW6yop4rf6GzZuZmQFJBGeF75Ib15wgf4
         SrFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715782818; x=1716387618;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=16qftxrB5EgdSgH7j+99BTnIlGUnb8pcrY5C9J7hC3I=;
        b=rWvVJvcOM0na/ZbzPqGMKZ0JUBvPBUOPE0FvVu6CFrVL1W6sgKXGebd2v/7poeDeJ5
         D8Jb2p2kDrrMZ3zQDshx8S9aWM8MP7ddmSLRUNn6VzlgM7/RJS53BPGPn/W/fWlZPMwG
         h2JRV+5tnaqm/iTFL5CuLdZga1X/AL5MBPaAc8OPSOLof8K5d0m0s4FB0NySRsbfhZoW
         wndmux7wumV1Fk+A1w+k06LXhbpHbXs7/eCQ44fkdBAScUr/6/u4ePTRKU2N1DALjfAo
         mFvZOwIxh6dvIikr4ZRwIdfK4T+X9YGwqu1SVT14SaQlbBmMV3hMTj5nWyyYZ6NIY4Im
         6KOQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2GuAonV3BspW/9R8YQdR4su0C0Zvbxp3PRJhheITPAB7s0BKip6VrI22yOjrQ5jdvb5x8wYG5bfBps43ICShPFAo2PQyN5dCr9Vs9
X-Gm-Message-State: AOJu0YyxJEwv1aWcJWjBn8wfv87rH89E934IQeLPXUnBAYWqA/9/QXzV
	Jc/yKxb7RRr7eHppmBiYotwQADOsIrSyLkWzFIpg4vSegEHtXqu6IaAkXOKCYJI=
X-Google-Smtp-Source: AGHT+IFpgBj/DAxqhrrPpTiW6l24RSbRhMtwGY7avTDZ4wHHSHq0yDBMJDQD8AtftGZW6eRvsGhAAg==
X-Received: by 2002:ac2:5f89:0:b0:51d:6790:b788 with SMTP id 2adb3069b0e04-522102779dbmr13134213e87.56.1715782816422;
        Wed, 15 May 2024 07:20:16 -0700 (PDT)
Received: from [10.0.1.129] (c-922370d5.012-252-67626723.bbcust.telenor.se. [213.112.35.146])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-521f39d2cbbsm2531960e87.277.2024.05.15.07.20.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 May 2024 07:20:15 -0700 (PDT)
Message-ID: <200be7b8-a245-4d72-9514-eb5402a61b77@cryptogams.org>
Date: Wed, 15 May 2024 16:20:14 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] crypto: X25519 core functions for ppc64le
To: Danny Tsen <dtsen@linux.ibm.com>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, leitao@debian.org, nayna@linux.ibm.com,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 mpe@ellerman.id.au, ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com
References: <20240514173835.4814-1-dtsen@linux.ibm.com>
 <20240514173835.4814-3-dtsen@linux.ibm.com>
 <847f2e4f-ace1-415d-b129-ed2751429eec@cryptogams.org>
 <7eb6bf4b-5510-48fe-aa6c-ac5207d5a2c1@cryptogams.org>
 <7859e867-ddf4-494f-8ddb-2949aafbb40a@linux.ibm.com>
Content-Language: en-US
From: Andy Polyakov <appro@cryptogams.org>
In-Reply-To: <7859e867-ddf4-494f-8ddb-2949aafbb40a@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

> Thanks for the info.  I should be able to do it.  I was hoping an 
> assembly guru like you can show me some tricks here if there is :)

No tricks in cswap, it's as straightforward as it gets, so go ahead :-)

