Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B32482E9
	for <linux-crypto@vger.kernel.org>; Wed, 15 May 2024 08:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715761800; cv=none; b=Dq8llaxrA2KvmneN/z99H/T5r587Uy8JP2LQa3VUjpc4kUWoA1yKm0BDR16SMfl7iph1+u2QuI5x7OcIx3NaKdIsTBq0EDnFz1UpTzUm8nDYALb02xNt0TGEWjPs25SyzywFQ5MOMJLizoFw0qegwMYqFdNHhGBfzcUA0hAaOm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715761800; c=relaxed/simple;
	bh=3sJKvBCoJaKkb2UJWlCMu8vxaDXyGjihMzp2hGE2ezY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hytujHKWmunkC7nFTOcj/3C3HYKjk627R+L4QGOmzND5F0z16urupRj34SrDSLvag8cggobmo0XvOxYfiMZ/BUbHzLeaXACEsflhrjvC8jXSEi5/SC2eokez1w8qOryAiyof697yuLZKsxmtapqWZgOXxI1q8XPuc/svLNwej1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org; spf=pass smtp.mailfrom=cryptogams.org; dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b=EeMIzhhW; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b="EeMIzhhW"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2e271acb015so85514691fa.1
        for <linux-crypto@vger.kernel.org>; Wed, 15 May 2024 01:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cryptogams.org; s=gmail; t=1715761797; x=1716366597; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kdZ6+CYbkRe4GWY6A69afts7kPSMUQxevIZoOvytkAk=;
        b=EeMIzhhWQIPsSm5KFm17MA3Vj4U/+Hs/Wgd+g8qm2ZYT0wVYrw4CABaTCj3x/7FF/f
         HRrMzpo5F70GxHwtL0YjUsuVQocmqykCvc5mXGX3oQ5YhTq+g02S3CZlKHxWk7+VUDnu
         5cZQm+5JIpFLCbKoB5SPYU2Z5+BmtrB4XnTUsR45Wle9MX64eqYZzYTQV8gu2297cnRY
         2uxF1v6eQWQawOqAakG+3zLlk6cCduv+zC5ta0LCBkmE5kd5zg4csWOMPXoJydPVjWWs
         X2Hr0gPB4GsAI1HrtAaFl9Opvg7948F3Sb+TokvD8RlqKaKwA6Dr5glPG8Cdv4U43OF8
         yNxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715761797; x=1716366597;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kdZ6+CYbkRe4GWY6A69afts7kPSMUQxevIZoOvytkAk=;
        b=Zue1bCH90kJeBEyVT7GoLOurIqJuN56yRUFXzoz79XOh9q7q/rkOI4KdZ5BDET4kQN
         5/VQ9WoprEtambrKlnPF28JJk34EEEoP8ud+lfmrcr0++DE+gT+jP8pTylXraoqDVqRy
         r0IyqHGcnNdB5R8Wp6kRuCB9EaU5x72Z+N5TxKbxlqob9wdPvx5oZz/dgD7yUHcDeau8
         Cv92oZdLMKZ9e7tXgIR/6O1Sn56igm4tva1qdQ28GsvLtBS8PvV9/BuGoj6I3qW7Fl6N
         KGX6PggOqHoTW4nOVqdlCVlBsafmGtC99e/kUdC2GQkg06RXOz8ErwOPlfE5epXrEokr
         8PnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsCtZPGLMxsUG3exb1R27Hq6wwt7tukDFrqiGyoMyYN12sDxWA6W3KOd+BBV/3weQ600EfQMIk7sg1maAUIJ1g/Sx+OfJj/srv1Qb9
X-Gm-Message-State: AOJu0YylemayvM+uJaqKP3FsAmbNC0DlmViL5LMmM8DZ6gSQ2gUGXZly
	ee6K7kzWYt9ddlUQs6EqIFoE+BC8eBYj//PFEs12KwdiydZih0fIkPEfNE6aTco=
X-Google-Smtp-Source: AGHT+IGrFyIGNekgvi7YvLggWgiFyAjxsuUBqcC1ibM/CNjEyWzWGDg20jTRgwWYO3bbnH8X0/j41Q==
X-Received: by 2002:a2e:a591:0:b0:2e2:9416:a649 with SMTP id 38308e7fff4ca-2e5205c3760mr106145011fa.53.1715761796962;
        Wed, 15 May 2024 01:29:56 -0700 (PDT)
Received: from [10.0.1.129] (c-922370d5.012-252-67626723.bbcust.telenor.se. [213.112.35.146])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2e6a8a64d84sm8110551fa.76.2024.05.15.01.29.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 May 2024 01:29:56 -0700 (PDT)
Message-ID: <847f2e4f-ace1-415d-b129-ed2751429eec@cryptogams.org>
Date: Wed, 15 May 2024 10:29:56 +0200
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
Content-Language: en-US
From: Andy Polyakov <appro@cryptogams.org>
In-Reply-To: <20240514173835.4814-3-dtsen@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

> +static void cswap(fe51 p, fe51 q, unsigned int bit)
> +{
> +	u64 t, i;
> +	u64 c = 0 - (u64) bit;
> +
> +	for (i = 0; i < 5; ++i) {
> +		t = c & (p[i] ^ q[i]);
> +		p[i] ^= t;
> +		q[i] ^= t;
> +	}
> +}

The "c" in cswap stands for "constant-time," and the problem is that 
contemporary compilers have exhibited the ability to produce 
non-constant-time machine code as result of compilation of the above 
kind of technique. The outcome is platform-specific and ironically some 
of PPC code generators were observed to generate "most" 
non-constant-time code. "Most" in sense that execution time variations 
would be most easy to catch. One way to work around the problem, at 
least for the time being, is to add 'asm volatile("" : "+r"(c))' after 
you calculate 'c'. But there is no guarantee that the next compiler 
version won't see through it, hence the permanent solution is to do it 
in assembly. I can put together something...

Cheers.

