Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B28723ED69;
	Tue, 10 Dec 2024 20:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733863916; cv=none; b=gRugXfKtJypFSBnRFrUwElHr1TU1LJTF3gWbUKOSulYota9YQLt8ZqF/8vYj23uTiIN+DkecYFkIBBSYD3aZ28egnY2/RHgtdxIVPPvjb7rn5CAVOmbzxMIXdJ0+X0q2kylSmZf7bzR/UnL6RIkK9ZbgHusfiLNVy8MzZRJudpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733863916; c=relaxed/simple;
	bh=mRThUMpoJI0H65y7D/bNtmiOmzV709Z7Dn6YssAAgC4=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IZM7iPhV/L47/RoZ3mT+5tCtd39HzUubZkA5CuLrnGIzkt3OJVHY+591p+b9UrQP5WIc6WibcIE0+nEN7TMr5jTrDaVUKQRlal7qlLHaQ1hGdBCdo9E1YIeLJOwqDNUbxaZ9/j/OhPswHvDKFnTCKwzPIVKgyQrMNiO3k/hhqDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mZH9DQh2; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mZH9DQh2"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-434a2033562so53541615e9.1;
        Tue, 10 Dec 2024 12:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733863914; x=1734468714; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=301wRSRs43OjUWzhsOWOTGwAS/3EIoBXGoWH5/9Rzns=;
        b=mZH9DQh2StwV5P18WbEgyvb4J4iMSExsWOaV26NAI6fZekxjOZc9/r4FRfv8wi9aZZ
         wEFwkL1dYuzMpR/xUEVuzXDlwTKZDMonjfnUvO+YBb6UrfGv/UCJzAN3Dr1LB3q0P/IM
         ShKGIMlNM5AELbRRKzgdtMVrskM6cwZZLIGNaHUb0leRd4eFbNKZEE2ToDrYIq3xuGvw
         5zfLx9lza946v+ms9Jkj4/JqLrQWegN/HgW+TuUOqKA7Jvasqe9S0lh0CxfekzY0DXYp
         O1NCMgrEZlckTF+uttWzdrHkKu1KUZMLdUZyQX73cLnc0WLtzjOcIWyAq1m0R4GFLRw5
         JYUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733863914; x=1734468714;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=301wRSRs43OjUWzhsOWOTGwAS/3EIoBXGoWH5/9Rzns=;
        b=uJlx2X7lan42OnWsz5p4wHZvJjBPdRuuPF8HX1Jp1MdwItkm9C6nm8hcIvfpOP+N+Y
         5f+19aMd1s71vjR4RBAa/lViIJiVPhY+jiDCAROLMTW9G3saSggszZSPkoC9jnUWGJu3
         1QEuG7FqAAnsWtQZs8qpsCqBbfgDVf0UftC2fstKNsmoE0tanmTEdNOYNfpJgy9MW0xl
         1poQjNJ41KCzvPBH1U3gr1bf7M+mygVUH17uAoacWB+fX241cSdi3zTLw/CvKubCiU3Y
         lfmxQxapfPSc4G5ALLU1QdtGPPrbiuSbj9k/kU5KiL9m3wtsmwvPJOPDKMW9SEn8yYxr
         Lmsg==
X-Forwarded-Encrypted: i=1; AJvYcCUztqT5z+0WxYA7CrAdZH666AiDET02dVevjfZrKaHAym2VoIl1rP8eVHQrev4b4II1BGlTHXymnFyH@vger.kernel.org, AJvYcCVKLgtk6yguHLCJqsNaAcd9WR6NOPJcRrVIdYbV9+WKd2/H4dJlrOaTrwb98F0yBtS3X6JY9HjDcX+5feSN@vger.kernel.org, AJvYcCW5Tm7pzEJ2oJx0Zq3X4pH4upEfpMD7Z+nQYGo2XGrBMyDDZvxYLSZXcFXzrhEmk2NvgBw5wlnqTUUHmHW+@vger.kernel.org
X-Gm-Message-State: AOJu0YwOQeY47fwlgTGIx1Dv1jFnpOI+a+RBex4pIZlCowGkqYf67Rhw
	e1DoDuF1dDwNe036TMh/QlUqK6tEUqEd/i14MQpOTbcVziIGO4UF
X-Gm-Gg: ASbGncvrulRSZRd86GZdAUku5evzTEP1AYZHID8ZDiBzA4b/EECkvWLXQlwgZXi6US+
	xsRndMXzOyxyuDPLSLyVpNjYUJA7iJUjHxmo+2mV/96gMQHxNpfCAc7GeZCEiZiSmUuHvOM+8Gn
	YDH+xGZ74rXpaA/cbNWygVhIMinz56ymtl8jkdZZ+na13Hld0wfy6vVMMuYTF9VGGDRR7Xof0a0
	ql6qSIHTRkQ2D45jYqS0JENhmmoJuyROI5LCXZGht4ZWAHzzS7SdOZfmWmalrpK6wdHJxv0HSph
	unnAMR7/Gw==
X-Google-Smtp-Source: AGHT+IEtgELmozDZndyAbIw0+22SolVOahQ6RzPmvQx0tKDwUunyJxMT5/Exd2L84f60qzvt/DM14w==
X-Received: by 2002:a05:600c:8718:b0:436:aaf:7eb9 with SMTP id 5b1f17b1804b1-4361c429eaamr1449815e9.20.1733863913580;
        Tue, 10 Dec 2024 12:51:53 -0800 (PST)
Received: from Ansuel-XPS. (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434fe9bff74sm57024695e9.8.2024.12.10.12.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 12:51:52 -0800 (PST)
Message-ID: <6758a9e8.050a0220.b60b3.184c@mx.google.com>
X-Google-Original-Message-ID: <Z1ip5hA_x5WEHz6W@Ansuel-XPS.>
Date: Tue, 10 Dec 2024 21:51:50 +0100
From: Christian Marangi <ansuelsmth@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
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
	llvm@lists.linux.dev, upstream@airoha.com,
	Richard van Schagen <vschagen@icloud.com>
Subject: Re: [PATCH v7 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
References: <20241112015920.22564-1-ansuelsmth@gmail.com>
 <20241112015920.22564-4-ansuelsmth@gmail.com>
 <Z1e0LHycNGcWqd2q@gondor.apana.org.au>
 <67582c1b.050a0220.83ef5.c8df@mx.google.com>
 <Z1guyCJy-Cpo7U11@gondor.apana.org.au>
 <6758312f.df0a0220.100594.1c3a@mx.google.com>
 <Z1hB2WftNhyGt9oj@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1hB2WftNhyGt9oj@gondor.apana.org.au>

On Tue, Dec 10, 2024 at 09:27:53PM +0800, Herbert Xu wrote:
> On Tue, Dec 10, 2024 at 01:16:42PM +0100, Christian Marangi wrote:
> >
> > Oh! Ok, that is neat. Just to make sure everything is clear,
> > to complete the request it's the same used for final, the
> > ahash_request_complete(). I tought the -EINPROGRESS,
> > ahash_request_complete() pattern was only for final.
> 
> Correct, the same calling convention applies whether you're doing
> update or finup/final.  One difference is that after final/finup
> you don't have to export the hash state because it's no longer
> defined.
>

I just sent v8 with the thing fixed. Hope everything is good now!

As always I passed it with the test flag enabled + extra and fuzz set to
10000.

-- 
	Ansuel
