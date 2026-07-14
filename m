Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620172D7DEF
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 04:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784003347; cv=none; b=fkmcs+t0NqTDy9q9kMl7p+1IGj8uqnr4ArH6Z5/C3xR8kKHwV1bTqfZKNj95NK22kcbxgG7TQD2huyjyM9Ab5r9JZi2pMvJhit3KJ2SSmpPvPUTaO4SohbiiWmj8PTTwLHBG19NZM9Ot5O+TqtyWeVu763YQ7NNSOkRxs7yOVjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784003347; c=relaxed/simple;
	bh=4QfcCRLcU0kNhBP6p/zkXE5wTlb1ErHRgMVmRNnSlkU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k2TjJrbiykQ43/OhJCDZHtL8Ke0nMpaGql1bbUYh2TQcpHpKdQrPiYHgn4jLh+2Ha54KdwYbkn6L8L202XjXlUDkmFMNJ5QyF/bc8JHGM8q9e+a3xC6e14nnTqdRVJkzI4x/3l+C613HgWOG86KsDrVd12lLU+uVrhus7fdYSQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gdi+YAnD; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=eryeoF8p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gdi+YAnD";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="eryeoF8p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784003345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SmIZ4DZ5UHZkChftLBOyBJmLHvpi5F5/b2ljO8TtHaY=;
	b=gdi+YAnD5CwuhDRukfEjmVm0qOHFaF8v+rt48vO0ix0LNQiuTWSMC7QbmvklzXTfyaQz4e
	e8hoz3tsIqtFReQNrlqJvKVXtCJomQWHxpHVDqxiQAWRB2roA+tSi/4gOvPH8Hh2KWUGeh
	ynSqX0wHc35VbQQGfSwxR7e1o6m0FS4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-255-mx1qPVHDPRax10jMdtdu9Q-1; Tue, 14 Jul 2026 00:29:03 -0400
X-MC-Unique: mx1qPVHDPRax10jMdtdu9Q-1
X-Mimecast-MFC-AGG-ID: mx1qPVHDPRax10jMdtdu9Q_1784003342
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-47f2b84db9eso2566448f8f.0
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 21:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784003342; x=1784608142; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=SmIZ4DZ5UHZkChftLBOyBJmLHvpi5F5/b2ljO8TtHaY=;
        b=eryeoF8pGvyfA6mea9ANmWJ7S82GGHLjqkFv9xQjet5y6P6lxXFSzxJe8e/CbSJmqG
         gNF1qmvecaNqMCaVMV7vN36PfhzeSPvFu5Asl3+jvdoUrU9qIcZbNPcTgY4h3W4VxuaT
         55bXyaUGPnRv25jVgoUcBN00dFK+1111WL1xIGV/E+ywsAakHCvnhx7qPrbnVNV7n/0r
         nV0Jb1KnGSCOhq5z4YNHFmd90GIZllpEwQoUcwvOlLC0maJEfibpiwbfshIKdU8B3uOS
         qeC2L51Ii80pyFSrvKxFtQyi9XjFvb/nN8mMlSQlDCwdMOwgpgUGaQmHr8yfqbrDus56
         HqaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784003342; x=1784608142;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SmIZ4DZ5UHZkChftLBOyBJmLHvpi5F5/b2ljO8TtHaY=;
        b=PM2Nl/OVC2TYerbQp9H6pUfG89fQbiFG6EwU2BQu7xkVAgAK4dUnFlbQKyM9ahskNZ
         yzKmXCjf+Sv+Th+YBZquXMRt40C3BbFP1mwT2Ce7txooSD7e+Ayg9ryVimkUWAFGtLiO
         v4BU/lz71Jl/O/WLDq7oK/WS8Fjk2l4AlKC/0E0e8jQ24SB/sCTl3mBV4byAAwcsyg0e
         /NBUKmE7go0x9Y9TepUkFXRScgwLSI/Ze+YsUc/PHs2roK8leATE3GlipILN57nU+w1h
         /Q8F92k5emjKBc7qAQNAnHAAqJBsJ72Gxkdzys6lYoWw25cU/d+zyGMoIoi5MQYwQJcy
         SpTQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpra4/jqBivJDxM8KOXbO3Mvxlkzei5WOluMWEKPj2d50fZXA8lkcPcViyyTiST/KwImwepbDpCYtOrvCg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoPdumHjTdSYZccyJ1dQ50xSuTx1yotewG0CuT8GflMw3koS/H
	4zVCjV8ghzuM+47B9qqjbPMohPw+jHZhIn2IYqM/N28eCkb+vtLtEv47biIKA6hseRYeHs5GkW9
	tIrv3z3PU8w63Yp6/7EQg5a/BDx9kOC/KPuwl6z7icExoM7uGQsuKmJSWkxUNJSLr9Q==
X-Gm-Gg: AfdE7ck7nuncqt8Y6yLlMg2aXt/VWgvrffwnK9MLqVzk3My+5tp7xWKVyA9evPfitaj
	d3rTP1tOVQ3zloWzjmDBi4632hiLi1T+Uuw1fbbeModZ9Xd+4Z8AjZtAF3AvwDXLEqb71ixdafs
	OzFCWBW8mgPb1CbQfvwGzijJrIASH0s6oN5kZ4Z+MG7jdQvp7Dk5U5amABpGeSXccrJ7VB/yx8Z
	php+hNqZ4NT/lmJ+57NieHFH0pDTdpptYcBXFO+krdcRkc+6naaCwkqHr4WMceJffmLtMKhRs7p
	2WtmyG5ftAowVROfPkklLZ5s1O7LnfhM/x+cRu1tQn6CZXX6x6+o1j6mG3lgdE36PXgRaoy0eOV
	AlNjASYSP
X-Received: by 2002:a5d:6e52:0:b0:47f:4602:66e9 with SMTP id ffacd0b85a97d-47f46386a9dmr1707322f8f.40.1784003342338;
        Mon, 13 Jul 2026 21:29:02 -0700 (PDT)
X-Received: by 2002:a5d:6e52:0:b0:47f:4602:66e9 with SMTP id ffacd0b85a97d-47f46386a9dmr1707305f8f.40.1784003342045;
        Mon, 13 Jul 2026 21:29:02 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.112.144])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464a9879sm5451047f8f.22.2026.07.13.21.29.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2026 21:29:00 -0700 (PDT)
Message-ID: <f1d4197d-55e4-423d-bb18-edebc773075a@redhat.com>
Date: Tue, 14 Jul 2026 06:28:59 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] padata: Remove serialized job support
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Steffen Klassert <steffen.klassert@secunet.com>
References: <20260713223234.24812-1-ebiggers@kernel.org>
 <20260713223234.24812-3-ebiggers@kernel.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260713223234.24812-3-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/07/2026 00.32, Eric Biggers wrote:
> Now that pcrypt has been removed, also remove all the code in padata
> whose only user was pcrypt.
> 
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   Documentation/core-api/padata.rst | 145 +----
>   include/linux/padata.h            | 145 +----
>   kernel/padata.c                   | 902 +-----------------------------
>   3 files changed, 16 insertions(+), 1176 deletions(-)
Nice clean-up!

Reviewed-by: Thomas Huth <thuth@redhat.com>

