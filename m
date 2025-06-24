Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBD61DE3A8
	for <linux-crypto@vger.kernel.org>; Tue, 24 Jun 2025 16:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750784374; cv=none; b=lVL2kHEMejrfOt6H5EVcVZO5nkGMxNhx5NPbcQG72dQas58IuoWacEfdthInDcKcnqBLkCm23DtEWwfievREmPySsT9BJ2M/d4ZS6WOlPwIlG+Z+wYcq3xzsW3GZczBd/K7Vaftw92ZfWQU206GN9mbiPyq1ThOgWTfHsPYUnck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750784374; c=relaxed/simple;
	bh=YmsbocVnIlhfSaNjW9qsOsI1HiD8gvJ/Np72MfmeELU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TjZB9qYLHMPisYL9v5ngsnxcYjeyji2uy3IX6q/rFKnhbLBJ+xWCPGgEZFMMdj5ygwt3F+p/Xwn8r5K8b0IlxDb742BwowpiPTduXG20i+m2nzAfKETScCqJOXS/LspUljdajrZhUk88keEYsDiVqoGFMvaS1smIa1o6pui2lFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LWelTjH2; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LWelTjH2"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6088d856c6eso1353533a12.0
        for <linux-crypto@vger.kernel.org>; Tue, 24 Jun 2025 09:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750784371; x=1751389171; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qLvCI9IlKlBvbuZFtuXzcwAeH/KzwYDiyDeecJEoUqI=;
        b=LWelTjH2Ijo4cVUK19mUAaTAgoGof25SGYg6FWT+Hvd2yREL15RJCrpRxfYJuaWein
         0psJghaHO1z9p3f96c8kmkGHyprL7tomsvzC860OdymH5DUj9Tk26CyMsFfKj0JboK77
         Sem8hE4j+Bkwqd9DJtn/08FgSL3mo6FNiu14PnJ8mlgxwzJEYAxR9CLtlaWbinIvtW3N
         s2u4OggXqeVMsRHxk3OtHytxYvvH3nARvpfp691eJ9KZu5u5gQaCdsfBa5XTboOGGiVP
         qLjr5YIlcwXBUhlMsoAMmGkMOwTT9SawcbxAkQ9MAPoSUyVMsT1/+wps/7qrlSy+Yz1X
         t5Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750784371; x=1751389171;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qLvCI9IlKlBvbuZFtuXzcwAeH/KzwYDiyDeecJEoUqI=;
        b=kIrO20YDCv/3LBoh3bU7DelR4+S8iA6/WCc9czJa12APqdXBTqxJsrLIAKQ381aIEb
         8a2MNDFKbiu1C1bdv1Ajh5oW4asysVbJoKICAwCYXBEko896s0I6DRFDFujhaXxJFhIN
         AawmOEaISz+VVSf0oJwo+e8g25Q4bJlUgNmDxONCwLeQlyxRwZVnfqRNdkS6VqCD6AZO
         yH4wVbHLHR1C63qBw8ZtmvbuY2gTt3FoU2PAq8Em2Ayg3O9t6hBkb8XT10MmY20c+KzY
         p7jVTiBy9y+uRQ8CfaF6S/YBGUPNTP+0jXxPhMwT1anJ/WPJhYLp/RCrsw85coINgZXG
         tH+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWSVBaRyVI1wbFD06Nt88+M3lYuAITUrOnJ0dZKSOhdPytgFCPygnArBRrKiLEdcxtZgFV2XX2T6tlNxFM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdWpuSNKU2yjnyqByJ/zwmwnLF9NN2aH8N/3gFke3U9z1GWDY7
	NfOSeogeOTsBkt+bmwuaYEg1HxzWxTB/3pnatgnXC8K9SxeVmb+4NCW/
X-Gm-Gg: ASbGncs1oEiQDqk6ODRXSja8UOGEFs+VhNo5nee64xCznn2De751I37Aa6DSKNu60c/
	Fg8SOYQoAK02hjhx/bMBRtpqiTvO9+uW+sAg9YWG3HxrW0wCZjVeoBVNqI5Giz706iFaH+117DS
	sPE41PJ6dIKvepgL6xUn3jSKx+/55WgV/HNOhdpDMXieTu88eTIHL9RaWEJ685i331PXZT2w97X
	AWoE7AYEZOBRwpKyRWHGMR4Kvqk9orV/gYyOVfJhkMDiZkbK8MnZCM/haoPGM0ttygXWePWSlO5
	A0i5V4I9Q1IgxIYVNjOc8+3Rpf0LHDkWcIF3cttlH5zE9hB+j/jmlTjXMzLfi8eYyq2ISEYKDi+
	+h9zY1/0eKII=
X-Google-Smtp-Source: AGHT+IFyMnDVOnSBJq5hxAkT+GdQQ/918SMwMPDYHC8c2sdpAF41UArKDafYENUdD33P9rYphhvQ5w==
X-Received: by 2002:a05:6402:2694:b0:601:89d4:968e with SMTP id 4fb4d7f45d1cf-60c465ae802mr270636a12.27.1750784371049;
        Tue, 24 Jun 2025 09:59:31 -0700 (PDT)
Received: from [192.168.2.22] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60c2f1ae6d4sm1307156a12.22.2025.06.24.09.59.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 09:59:30 -0700 (PDT)
Message-ID: <20eb7dd0-5f81-45b9-bcbf-83bc4510463a@gmail.com>
Date: Tue, 24 Jun 2025 18:59:29 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: dm-crypt: Extend state buffer size in crypt_iv_lmk_one
To: Eric Biggers <ebiggers@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@lists.linux.dev
References: <f1625ddc-e82e-4b77-80c2-dc8e45b54848@gmail.com>
 <aFTe3kDZXCAzcwNq@gondor.apana.org.au>
 <afeb759d-0f6d-4868-8242-01157f144662@gmail.com>
 <cc21e81d-e03c-a8c8-e32c-f4e52ce18891@redhat.com>
 <20250623182238.GA1261119@google.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <20250623182238.GA1261119@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/23/25 8:22 PM, Eric Biggers wrote:
> Of course, the correct solution is to just add MD5 support to lib/crypto/ and
> use that here.  All that's needed is a single MD5 context (88 bytes), and direct
> calls to the MD5 code...

Feel free to port dm-crypt to this code once MD5 is in lib ;-)

(Use of that small context was what I tried to do initially when implementing loopaes-compatible IV in dm-crypt.)

Milan

