Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795183937;
	b=tjQmf5xRYFBcQtcIXvju4qdltAGfr13iw4NCCWj5i9CS5LAl76yz11BtJhEoLRZG7MsX
	 qdkOzEq9VcrX13bcXsa1PNeGyWzC9YV3HWM4oqAXQCG5fPYMczGdCe78E+jcSsgcCcZIz
	 NoGAibPYP7DTREbthBXLy9df/hSi9VRsrqTvdMKYr6KMcEr1o8M/cpq66A6eURoOv2Me/
	 3w3ONqLukQas4/BDu+kWnqN9k4jYUyv+mISA8HCC7WmCUORZvjK6bp4hOKKxQuEQZcL8O
	 sP5fvmAxQfgXl6BsRqB++1fvOYqQFgQyqBPzqbGejSl39b9IjKWbfQTTbGPoj5VqiGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795183937;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=xbe6FEnNEDzgOKNdVMSNVPy6O8NMwRnW9Mm8QaM0+hc=;
	b=LabotMr1UaWcr/T2ETM81G0GwyVxiHKlBbVmJCvoZ4Xk2gTD50eJDVKVuu5oFpAy+tSa
	 Ku8wZDGUZbRVYPoPcErYTuhU5CSOjlYWzy00XZ6qklY3cohWlnyUgvIg1CyoFRoT7Qpw4
	 o0lW9jvD1F+G1nbEy9LZ9q7Nu+GG6lfWYsrhLa/ISuzTqLLOT6Z171tK28WN7WvdOLLz5
	 64ISrDoJ4g+jomiLC5xqcFRxZ5bCo8iNJlCe/S6WppOyOpran3DSrG6HZGjG3+Us5emrr
	 jpLmJppBMSCw53Xt6sjDQKh3Fy88sOkmu9h2eXBVfXGBChbmZxSOydCtI9c+nifi4Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x1oBIf8U;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6F7606A325
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 14:12:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A6F7606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x1oBIf8U
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a210470b49so8111785e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 06:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795183936; x=1795788736; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xbe6FEnNEDzgOKNdVMSNVPy6O8NMwRnW9Mm8QaM0+hc=;
        b=x1oBIf8UCCQB9dSubB0VIFuiEhC4yxJ2bx8+aem/zyiJBSiev2PW+qDo9bFGtnMAbr
         JDQxgdBFeyj8zytl1wLzSKbQMdZbtwHM5MExcLCSMLkfKXm+gTbY6uM01I3zT9etSQzD
         kAkISVney4cH+g9uVsITYGRZ4IwFWE3Q4+iduXrtFXEhPqB0h4zWMbgiu/Me0xi0l18N
         5e+zdm7UOnI2RCo+XNLr7PAF52n6geXRtF9UW8XjB4AmbBNLiikbHVsj9V3ifm/NzuE4
         KVGw//mpzWAmMt0DOMe19MrcpwbitUAZE1KZ7QBCDjQQ+LMMfDju/PxADk0YLL1ZzwjF
         emrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795183936; x=1795788736;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xbe6FEnNEDzgOKNdVMSNVPy6O8NMwRnW9Mm8QaM0+hc=;
        b=huqd39kgGEjgViAL0Gx1YeYia3m+hOARpfbKrXTpfvVzM439bt58RlNrFgSh0FzEwH
         orJe3pcJiCb82BKLUubskshhACdKYdUHBG0Fk7jP+zik9FbD5+eh5lTIJcpM5A+DNf3K
         2mMSYr+VgJ1OXscbdiuDcujRRflWqmZK9i0MXudpA1L2FkmdXzbZRSZ2NhuRYFkzmcZ8
         5xbnBUBgTpm8HrXxBRRUZyTjvCfsdQ4RLFjI5O0liH+mNyY/sQEYbRlHhEMYqYwGZKch
         rOHq7003c0D0nWm8R+Sl1rHadbG+pt+EpngipsazuED872s0S6sKsaIuquzuSbDxCvkU
         erkQ==
X-Forwarded-Encrypted: i=1; AL+hErHsZ26ZydK4cuoq/VnGEs76Eew5Ny3cyrdzhmy6wgjeM23jwgjBEL/PbbgyZ0GJkqsr0quYwm+tmbAw0Ww=@vger.kernel.org
X-Gm-Message-State: APuU4Z+ItA+f25FYFAXrnmDhxrwPVR/0RhlrnrfFZRVdsx4RrV117UOr
	Ra0BrdpdCs183DIqDam48xQeoP/dkwf4LIwXko430JOv5CXZfF2DF6DB
X-Gm-Gg: AYBFou1RvvdxoU/s9umTCmDfY6EkFWA9F8390bEgJ1CaAJdDm3yaNysfUOox9w48YJm
	dGxnLk++P7r49bEvBql+3H0JZhPTYU9ri6mygBegqszH8Vs+ebkAHPWQXPqB9nufSboBSH3bHw/
	woni9uOh0qNd8U6yqkY6ovaJ3WZNyltzqUBzGsByKlzJwqMQ82eQ5f96GG4U6J/3HlT3LHWYk1h
	5/oIRtJHJIfOXFeeOY+xEIncKa/jktPxynhQnKJjZw7ulCu4FoY/4G2leazaZSZfMbpAufRixl8
	ptCy9qZkuhajxrEJo0eIlAQYCVUIDyNRFHGc/Rug0usvvOi0eSJMc2TJpn9d+fRrIfVAUSLQopG
	hk/8AbY2zUoOpzv5d3mS9tnvFV5p87FZD+A8F7QXprINdocUnnYSACK44IjlYMbbqS4map4mWn6
	Is1SzkYbzLWdpujl/235gQH/bf6+q4UEb8UDE+1Og0FEO/Ry5jsRfDqAKw6txeEJLrDEune2Ynn
	XRC6AVGl0CXdevJ0NvrPq1g8XPjHH6ZDnTOiyLbKhTTW7uyCaPMQSGrdx6ROMW0vbPe+GxNEUCv
	7vymaelcEjT5bjQ6zy3vAIVFkZwGvJhQ2xo5P2mMav9cadV/ud4inL8QsplWFYpk80WKZdxriGV
	th2ycApW8zG8=
X-Received: by 2002:a05:600c:5249:b0:4bb:665c:a078 with SMTP id 5b1f17b1804b1-4bb8893a89bmr70511015e9.28.1795183935808;
        Fri, 20 Nov 2026 06:12:15 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884865a2sm92007655e9.3.2026.11.20.06.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 06:12:15 -0800 (PST)
Date: Fri, 20 Nov 2026 14:12:14 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org, ardb@kernel.org,
 x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 0/6] lib/crc: x86: convert the CRC assembly to C
 intrinsics
Message-ID: <20261120141214.327eb0f2@pumpkin>
In-Reply-To: <20261120084158.GM2668564@noisy.programming.kicks-ass.net>
References: <cover.1795137348.git.wqu@suse.com>
	<20261120034220.GA11532@sol>
	<20261120084158.GM2668564@noisy.programming.kicks-ass.net>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 20 Nov 2026 09:41:58 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Nov 19, 2026 at 07:42:20PM -0800, Eric Biggers wrote:
> 
> > So if we're going to proceed, I'd at least like to see a version that
> > compares a bit more favorably to the original.  But also I think before
> > diving into this approach I'd like wider agreement in the Linux
> > community (x86 maintainers, crypto, etc.) that the x86 intrinsics are
> > the way to go, and for there to be a path forward for DOITM as well, and
> > hopefully some interest in improving the compilers too.  
> 
> My 2cents go towards keeping the asm. There is no point in fighting
> compilers over this. The very same is true for atomics.
> 

Indeed.

IIRC the code loop had to go asm block because the compiler pretty much
refused to generate the loop that matched the source, instead it
generated one that added extra clock(s) to the loop making it slower.

I've also use some of the 'intrinsics' to write a short C function.
I basically worked out the asm instructions I wanted then tried to find
the correct intrinsic.
The whole thing would have been just as readable in asm
(possibly with some #defines to give the registers names).

David
