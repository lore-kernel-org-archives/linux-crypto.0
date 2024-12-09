Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7EE1F63FE;
	Mon,  9 Dec 2024 23:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733786851; cv=none; b=UFelkxWlI6bGoiV1oiMeY80/rHKLZar8tL0EhXImtmPOlQr0yE8V8p9RpNWAkKxOZ7VMxHrLjoAWVONCD0c0ALgyzGpe03FmbGACG+cF1uxcLwOKZ8loortnzc2UwSRzxP2VBBJDKO8G0yZPL6rjWnt4qr7s4VD8j1gPwGJ52uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733786851; c=relaxed/simple;
	bh=sib2JIsnpaJ4xFop5I9w3oSpRI1Wmim0nseZDPgA/uQ=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rSHYC0zdoMdu14F62rtIc07rzeGAofMyJOnsCP579kX8pT/YfKAhCx99s89YOxR/l8n8Uc9GHGQsZVJ43lRFi6FL+6thCYnJa+O/OdHnsNT5+QEtzuTZf5k2c9hBvnDf0yNzwbO6xFQ/sHuHo6E8dXI4u5oPHvv1/1EqZqOFjks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kLSXNKtK; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kLSXNKtK"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-434f30ba149so12491965e9.0;
        Mon, 09 Dec 2024 15:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733786848; x=1734391648; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=YUkySfBwBkhhjkuJlpR0sFTlCT96jZzoa4DO4d+b/nA=;
        b=kLSXNKtK2q+jw0s3rWD+pkirSnkLSlmwP2GpmN644Q++gq+5fbK4qJEecsW54iG3Zk
         HP43JKnahMn5vJN5ZRpbFQb995RWHlnv1KDuSil7zZFmHNY+RmO5yP1bA/y3Y/9z5nbJ
         EyR/mADCFHNMk02Aj26oT2o8VRfEhQg+Eh8418cfRA+Vr6iSYSh+wUiQrMrOuQCIeHLx
         YFe8/J51H0WtII4UMoTn8xQQzGp0eXFR7AfrVJ5eEtOQ1T6WYw5ot14DsG8/r+0RvElf
         F73PyotwUce3NY7akcxnLXHDeHVWsRR7JRBJBB453taNQT1r0qD3J1kMgRuogXJr8Vqq
         afwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733786848; x=1734391648;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YUkySfBwBkhhjkuJlpR0sFTlCT96jZzoa4DO4d+b/nA=;
        b=aFPoQIXh3L3lEuSwcLhxqvYzlRdr8d6JSU7fWAU7Hb8Dn723PajE3hug/GHEgxM6ST
         EXwSogTFIuLvbOCziWjf4S83LrQ3QiL8NJMam0HYVWSnI+Snm07CKbrlSngOxYrA5J7R
         CpM2N4ny6BZ5Q+QD8rc7ydrSZEH7lFVhevX5wNjA3igc1sdRWvRyLVsSJp8lzQOYaxU7
         E+mn411ZH1y8aX9ZPD3YbOe/MgWtpBov+NGsAEhpexjT31vtj31nMVCNKciVF3tV0VK3
         GajbuDbU5H0RvqhBo+CJGiC/NlSmmpU6Lc+wHs56uXXkVY/z++ys1GPEpcpzhnlyNjsf
         r/wQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsaJ4Ugaddf0zNpaghCC+wvXRBu+Jknri+87vHgHPWUeThSPnTEys+0yLnwxvfGliOf05+qknkziup@vger.kernel.org, AJvYcCWQB9tR3Xzen7HWuL0pS1zrmRP8uk1jrCxAfP8at7lmwm6KjcFa1T11RDZS8r6E7r6gblcWVkmJODkWxihy@vger.kernel.org, AJvYcCWze0VLOfR6sZ8y9Q2Ta4w7LX41TnSsowZfCcoxA+ODUMb8dNbHGFrFsBblrmTDmb1AL8hRdk6Nq7DpzCDh@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+x3A1Lp6n8mbGcl+agLweTuGhS9g+Gh58vbcyGBhPCIS3qirL
	yEobLkcXikCvC8X77oDyR0bouZoIHvN2yBO1wV00ZAHwbs/S5bF+
X-Gm-Gg: ASbGncsnHiwJ7uUghdAsGWsW9BXxkENDeQbWiDNGYUb2sOHS2Tj+3rjH9PnkMBBM4HS
	afuB4IqF79FzGtRL8QjZxF/jYq84PfParSgy5tqtk2+vGKfpJaRrsBkApzAJL/d7MRS4yeqq1a8
	tI/NB0Zh48S6D68CcEn4x4uYQJ6jwBa5hgKUKEABeg8hSLmtS7iwG4GzqsNjrpmRHvgnp0OscS6
	i9iGu5/1eOA1WuxgmKINJxo1edxHmsddAS8MWa1Y4Wq7+IJ+Pf7tlZfqJyXX+aHYB+OKXdKR4ar
	WosCkJ1XQg==
X-Google-Smtp-Source: AGHT+IG+AB1Ph1Dj5geXxUnKA8iVEw8ecVqYIcxVzRThCcrVKOuP+9lqU9OBDnF6U9HvS4qSlC1FZg==
X-Received: by 2002:a05:6000:1f8c:b0:385:f280:d55 with SMTP id ffacd0b85a97d-386453fe853mr1676974f8f.37.1733786847561;
        Mon, 09 Dec 2024 15:27:27 -0800 (PST)
Received: from Ansuel-XPS. (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-386219096adsm14666431f8f.85.2024.12.09.15.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 15:27:26 -0800 (PST)
Message-ID: <67577cde.df0a0220.128dd3.75a0@mx.google.com>
X-Google-Original-Message-ID: <Z1d82uNcCx7EcU0n@Ansuel-XPS.>
Date: Tue, 10 Dec 2024 00:27:22 +0100
From: Christian Marangi <ansuelsmth@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, upstream@airoha.com
Cc: Richard van Schagen <vschagen@icloud.com>
Subject: Re: [PATCH v7 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
References: <20241112015920.22564-1-ansuelsmth@gmail.com>
 <20241112015920.22564-4-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241112015920.22564-4-ansuelsmth@gmail.com>

On Tue, Nov 12, 2024 at 02:59:00AM +0100, Christian Marangi wrote:
> Add support for the Inside Secure SafeXcel EIP-93 Crypto Engine used on
> Mediatek MT7621 SoC and new Airoha SoC.
> 
> EIP-93 IP supports AES/DES/3DES ciphers in ECB/CBC and CTR modes as well as
> authenc(HMAC(x), cipher(y)) using HMAC MD5, SHA1, SHA224 and SHA256.
> 
> EIP-93 provide regs to signal support for specific chipers and the
> driver dynamically register only the supported one by the chip.
> 
> Signed-off-by: Richard van Schagen <vschagen@icloud.com>
> Co-developed-by: Christian Marangi <ansuelsmth@gmail.com>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Any news with this?


