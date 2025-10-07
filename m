Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FA82E62C6
	for <linux-crypto@vger.kernel.org>; Tue,  7 Oct 2025 17:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759858041; cv=none; b=OBLw/8a9OqNtuTf127yRqKMbyCCsY4BzfEZ9I3ll+Rp0ysfSAjziuBc+XojzKsPYKsGRkQiTjHgXVb8j9/Zs1Cl7Uvru8nSUkMlm+LnPCYn3VGe3tujs/V+VmalO/caR+BDZeVUhDcAfJ8sNG7H28/YUioflZrAl/d3V7p6daHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759858041; c=relaxed/simple;
	bh=4boE1QySS7dUBhbnewS9thWHVN2+VNmVMuGmc20NrWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ak76OIEqBlhsVQkUF2qSXiVa/gYzhO/u7/bJNBOSkNOoJ4Mf4IsknJ30C5C12HwWB6hgRmHnUCsTRNn5sn9VRwR4ilOKnmAq+VjVXyfcqU7CqXl32wMw3B7zT4gL6Q2dXic1xKiJcbykYhqukuhrrjk1v1OW5cZHa2jrBgfxXf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wxKKh3XT; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wxKKh3XT"
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-917be46c59bso587099839f.1
        for <linux-crypto@vger.kernel.org>; Tue, 07 Oct 2025 10:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1759858038; x=1760462838; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JZs6QfA1xQ2jarGgN7Pc8xUu74ta+A8+eWsu2/uVDsY=;
        b=wxKKh3XTOAIafnqvczSS/0uVyIaWzAW8BjFWE5gkBcAmu2AuuW8Z4py900YR+mGDG7
         vGjnxiqR2jfTBZKYIW6kPsX23qVitZqOmupAYLkRzIJ3eZLctejgNTGbsZ0d2RxWsULu
         epokI9W6RaJPnfLxUOgWdx/eZIBErlQMh2ryDi1h55gAY0RlPt9H4VMEEkFitzRFLUt2
         KtDuipyN3fPjwG9IrR+GtW4TRHS4wpcsftz1QkPxMOXAoWrgk1WCpULycKquRJwwyVcM
         AROhoI04e5oMfdlQ2cQDyS8p+g2s/50i2vsWZdOAVl62OPtnbBriAzFrvNAF1R02AeFM
         LRvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759858038; x=1760462838;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JZs6QfA1xQ2jarGgN7Pc8xUu74ta+A8+eWsu2/uVDsY=;
        b=snOsaj9pqGAXyzq2f/7AzA7UeAU3IZaAp2X6G0KYYcLQwsID39ov5XtKBN6SdaArrL
         04O2BCee6vhGqmUrgip+mdUXYBsAt9zFhEEzBy47DIIpN1bMSP/KGMsKWxpWK2MI8Vr6
         PlcX9kaRPKcGeHj1yCSrQvKQGlOTag+irO40Tgk/3I5jkB87s1Jjgo9ab+94oOzecNok
         s9d3FaxOqNKDghYBqtkpK8MecInxFUF1j4IMxF2gqWMRJRIglX6ORJi4InL/qsxXvtGj
         wxHMOkaQcUKVjvU5WPCT85bQBRCg3Y36J9Khe+dTJXe/MFpHh7X0NLULx0qQaFJpbdEc
         v2SA==
X-Forwarded-Encrypted: i=1; AJvYcCXoOfoit3qb2SzNjCq4DeIQqM7UF7VtsOqwZrbW/1UE6mX0tegxaEmP2Wl62ZXXFEoYY6ouJEb6g8wL5zA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpUYiwSe1SHTcAcsy+NWjZMVHZ0lmx99t0UIiDsNW3QaZrdw83
	0KBKGXIpqN6WTQHIrRTSesUOvkUi1YPOUzAP04vx7dhiJCT/qPavNWoUPumkstKKVGA=
X-Gm-Gg: ASbGnctyyWIIYiUCpuIPUAI7n9ePhI/M265b7xyfso3MJvWzoYTtamrsQ0j3NByAvI6
	dErqguQNbAR6OM8i4okmtwE1yvaGENjp/g/rOHpoiXadSci6QsCfrnudb7ftwVQ1GrPGafQh1JF
	T3wZq7ftfvErfLyTKkhK9dUkjRqg189Dz5PvUAHCNSpf5uP6FdrJgOSEgnWlOOFrMvmLfu4KzRM
	Hq3OEydNgHtOdA9UODY3/tVmHvqwOehJ+9XCTfm8bJP55cb+5AdIOYTrRO/Z+K9/TJhbKMoDsVp
	1qUqouXp0OH5gdv1u238/oqJ3jUiDDux5QX4Q/e1oV5LhOCuRdEgwFq6MoD/DdlGuhlVjLhRSL5
	/KXW7jUzuvI9S2Mq5TCjDLpjgTp59/syhYgHWM8aJcXyOHVLQ6RXvifo=
X-Google-Smtp-Source: AGHT+IFs+LIUotGR5eckp+7ViCNjBpas7WbwugfqfsfW2v5mzGKmII4S9PbLYy2RkfpE2uXpOMc2lw==
X-Received: by 2002:a05:6e02:12e8:b0:42d:7dea:1e09 with SMTP id e9e14a558f8ab-42f873d23aemr1552605ab.21.1759858037872;
        Tue, 07 Oct 2025 10:27:17 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-57b5ea31e13sm6058157173.18.2025.10.07.10.27.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 10:27:17 -0700 (PDT)
Message-ID: <f1e0ef09-572e-4345-b601-b4aea2de1052@kernel.dk>
Date: Tue, 7 Oct 2025 11:27:16 -0600
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring and crypto
To: David Howells <dhowells@redhat.com>
Cc: io-uring@vger.kernel.org, linux-crypto@vger.kernel.org
References: <4016104.1759857082@warthog.procyon.org.uk>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <4016104.1759857082@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/7/25 11:11 AM, David Howells wrote:
> Hi Jens,
> 
> I was wondering if it might be possible to adapt io_uring to make
> crypto requests as io_uring primitives rather than just having
> io_uring call sendmsg and recvmsg on an AF_ALG socket.
> 
> The reason I think this might make sense is that for the certain
> crypto ops we need to pass two buffers, one input and one output
> (encrypt, decrypt, sign) or two input (verify) and this could directly
> translate to an async crypto request.
> 
> Or possibly we should have a sendrecv socket call (RPC sort of thing)
> and have io_uring drive that.

You could certainly wire it up via io_uring in either way. I don't know
the crypto API, but ideally you need something where you the issue and
completions ide split, rather than just a boring sync syscall type
thing. For the latter, io_uring can't really help you outside of punting
to a thread. Having a reliable way to do non-blocking issue and then
poll for readiness if non-blocking failed would suffice, ideally you
want a way to issue/start the operation and get a callback when it
completes.

> The tricky bit is that it would require two buffers and io_uring seems
> geared around one.

io_uring doesn't care, it's just a transport in that sense. You can
define what the SQE looks like entirely for your opcode, and have 3
buffers per operation if you like.

-- 
Jens Axboe
