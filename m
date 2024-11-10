Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED86154BEC;
	Sun, 10 Nov 2024 12:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731240019; cv=none; b=LE6tTLFFJBKcKouw893gZw7y+okzquf4UvhI/w+yBjrLWa0RnmT0F82OrLApk5DgrytYZY2V+P+jNWjCERoHxyWXnWHp3BsDM+SDP52f6YbvSpjDBtGKl9amxzMUNiNQGYHx1fslMTS7ujQL6eCOafHn3L5m/6d4e3OeMtyHDEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731240019; c=relaxed/simple;
	bh=+iGXVv70BjpHo11LPSnc/euVJyQdr2vgH/jCA8gMuB8=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MwxzXfHSLIaI2KzJDV2whB1eXmkTAR+kNzXmqerFzemPI83HUurDfi5TQt9vLxYb/dyRK5NcXBLv/j+yNlNvY+qTKn6/qxzhHzxlFIj3WrlPGPqJ6kEARPzOe82I8N/HPII1YL0Ymopjthapbu5jYTTqJgzyLAWWoeceVLI44NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XtrqhVB9; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XtrqhVB9"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-431481433bdso31595085e9.3;
        Sun, 10 Nov 2024 04:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731240017; x=1731844817; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0JSpHx89Mxpbqklk6UomFHnNHdXyPnoFk3iGSRwdDnw=;
        b=XtrqhVB98ifGkzhk60jn/3DWOCbGz4T6XhNHx8mCzXd/gQ4Y4ySsq91P//AZ2tgeLi
         /ym83mtKPgNtiJiuS2BwOZUt/GzXM2Z0uS0laZ/AW258/RJdkvplv8dcX68iRJI/660g
         gWQuPmhE7GUGVGL/lqiedaELD+Kn3RL1aefyVuy6IXAVJ/z2zXWz+beIkUEyOz5Syt0F
         ZLJBeLH2/bnDO9mM5sdeD4IJwOBLbF9cXoS+haDLkufO9oe8E4vefVDkEExh8pcFetXU
         fcDHnlAH8fM1OEL1kfUo9tNX+pPDJUIQGim8p2vmBTbFDYLOP15CeCNn+1PAVG97kRty
         w5Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731240017; x=1731844817;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0JSpHx89Mxpbqklk6UomFHnNHdXyPnoFk3iGSRwdDnw=;
        b=qZ6YQWhJsuMbQ7GH4fLpsWQKF2Az+JvtpCYeylVEPS5MOrx+QNGsK0STJzv3XdpZ8v
         IWAuZnog15dlXfAp6OzDh4GWGIcst21kQoMmqnIZpx175Rfk8H0XAMEeGkgD5g6x80TJ
         xpm6dy2t/qQdyrHphwNnLAPri6QT62N7zEKy1hkUcJrWFNjoGqs8zF4yptpu7kuu1keQ
         RBVetIV7z4+4m8nHZfKkmpPSohDF0Zy2DxQOL5PUelbJmgMf6Nn1NIL//Pc6w7t5RZnK
         vuRn4JDJC9YwTVbDbdgq/BpvfSfO4xvdnNttTXw4Jv/g7plemyHo/IJRm/bvK00chLa8
         wyjg==
X-Forwarded-Encrypted: i=1; AJvYcCUeA2UT5ED+RtgNPhBnyUVxpTXhgkrOImuw/awvRitXumFygt+Jb3rKFEOyxOkA77+ae4i4MhA3NHKlxD7h@vger.kernel.org, AJvYcCW2O/4RKuZ0A+pJfKMpnrS+aWOHD2d9e03RaSZIhWXqQWv7hCH4pGaF/U6O+SX+duK6xF5CheQs4QTBkZWG@vger.kernel.org, AJvYcCXJFJbB0VZgUdl193UJbqfsTn/oyOcr+YkK7WNTD65UGGrebZat8k2yW0e1ml83Loin95e/vlVySk0b@vger.kernel.org
X-Gm-Message-State: AOJu0YwKYLhxO2N0OKQ1IaMJ9QEqtwITem+7VboAHdHm4wi8drrRnKX7
	bl+VIsMMtEcPI4lQpr1KIba5Bl2w+qsToBuze1mZumVFa+PUkuJk
X-Google-Smtp-Source: AGHT+IHIkJjS6Pb64F4BoNyzDgmoxYJiJsm4/OANqTyDXPHClXYnfnLXWEYNLFC7W1o52YCm516nOA==
X-Received: by 2002:a05:600c:1909:b0:431:58bc:ad5e with SMTP id 5b1f17b1804b1-432b7522abemr70019435e9.28.1731240016543;
        Sun, 10 Nov 2024 04:00:16 -0800 (PST)
Received: from Ansuel-XPS. (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432aa6beea6sm177450915e9.20.2024.11.10.04.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 04:00:15 -0800 (PST)
Message-ID: <6730a04f.050a0220.1633d0.07c2@mx.google.com>
X-Google-Original-Message-ID: <ZzCgTE5OXgCfCUo8@Ansuel-XPS.>
Date: Sun, 10 Nov 2024 13:00:12 +0100
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
Subject: Re: [PATCH v6 3/3] crypto: Add Mediatek EIP-93 crypto engine support
References: <20241102175045.10408-1-ansuelsmth@gmail.com>
 <20241102175045.10408-3-ansuelsmth@gmail.com>
 <ZzAs--iaKCXIY-Kq@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzAs--iaKCXIY-Kq@gondor.apana.org.au>

On Sun, Nov 10, 2024 at 11:48:11AM +0800, Herbert Xu wrote:
> On Sat, Nov 02, 2024 at 06:50:35PM +0100, Christian Marangi wrote:
> > Add support for the Mediatek EIP-93 crypto engine used on MT7621 and new
> > Airoha SoC.
> > 
> > EIP-93 IP supports AES/DES/3DES ciphers in ECB/CBC and CTR modes as well as
> > authenc(HMAC(x), cipher(y)) using HMAC MD5, SHA1, SHA224 and SHA256.
> > 
> > EIP-93 provide regs to signal support for specific chipers and the
> > driver dynamically register only the supported one by the chip.
> > 
> > Signed-off-by: Richard van Schagen <vschagen@icloud.com>
> > Co-developed-by: Christian Marangi <ansuelsmth@gmail.com>
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> 
> Please ensure that this passes the kernel crypto fuzz testing
> (CRYPTO_MANAGER_EXTRA_TESTS).
>

Yep I also tested with setting the fuzzing to 10000 just to make sure
and they all pass correctly.

-- 
	Ansuel
