Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF86D1F09A5;
	Tue,  1 Apr 2025 10:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743504859; cv=none; b=pUgOcuscdoUMFPmIivoyr3rC5dy2WgWovKwLJUgQi25mBQ57QyP33ckx3DQepO5iWegrcC8y+G55UXq2DlbWzFDfSILCdeW/78GpG9/8aGnY8zDPgnEtQIZAH0p5xG0OO+W6HuAAbKFM2C9JXP1HracqGPARXLEV1kMPjveKm28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743504859; c=relaxed/simple;
	bh=X5Os4a3UyZegJZHpfRnnbX8gNK59hG9Lbyfs3JOXSZY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a2doCim1nV75Y8JwInKZ1smpknWZphYVL6c4/Pfsz4623a5xBqfPTA8FYN+yOZcb29BdN0oXXNAT7/RLiN1bkG5Acc4do0XkyiBYwmuP12NCSR2CboC2LP6IvW34tKTp6F1SmvF7YUCajZgI11bqQjw41l6UAJ+MaX0tos4jr8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L3faZBnP; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L3faZBnP"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6e8f254b875so50002026d6.1;
        Tue, 01 Apr 2025 03:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743504857; x=1744109657; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xrrNmnVXe62DiAkl/WS3t3m868nCMqWuMBB1Lhr06l8=;
        b=L3faZBnPszwrNhoqir5kZKQgNd3l+Hd3bu7/U3u7mjl040vO0Y7lpfNlAWs7t2JAr2
         X3zugYTBmQSdbFN2/sJbxEh9K1BhWPGmfyr/TdD55tzx54Ts76hVpHtzkqmqzbQXS0oj
         LcB5nSxlvP8Q6/wvjGAlcaNAZE1Ul9jvL6VmpP9A9dQuxs2AM+w3Y9P6elijMArDYs1x
         as1WNWfzbDHy4Ksvum6thUIOdMwnsH6Gve/CkqPJh+EprQ7iwdF664PW/Npqy+ecOvuX
         8TDOyEKQ4Z5/UmQE4I5jb3XdBlb110ipVdOECUcsS9sRKhIhfakaOqS4wHbOxZSKwPug
         rpUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743504857; x=1744109657;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xrrNmnVXe62DiAkl/WS3t3m868nCMqWuMBB1Lhr06l8=;
        b=gtWDVFt6PKD4eMnKOZbNOcFw3uIrY8AdaIqMKIgjW66jjqw8en2OvZYRLSXhCHHbnb
         WKol+Tqmd1/tLPBdimOy8zvu3mJIpVnERqUBg+CrXqDq0ofAjm0Mr3W7bOtEi4fwCXP6
         k7r7z8b/uZ39R1iwhfVpyZyKo/Rd8VbOBm5Q5RHY21BXXH8g2fK1zR2ZaJgGE1rU8a35
         RuIJcKTGHujHPn+fI1DWUddzQ9FoRHCCb+lFHKPa/UUTgSSzx2TFtoDG7mLY8Yr/nxsr
         XUwgD3OrGOA1v6QfJJsieEE2Uid7ezoWe2MotNCRO7SFycfQwgBCv/M8ICNIem8biFio
         FWDg==
X-Forwarded-Encrypted: i=1; AJvYcCVqtfZSEsnMSH/8kFZO1zEmDJAZU9/0XV74z7ShyzdyI+lv+hYcu3xMvTmNjrnp4e+viTulmauROfwu2wwP@vger.kernel.org, AJvYcCWB2XwEbvv5Gqr2DEZrrKbn7woYaD8I63GOuiYm4bO0GfEbJDp3xsot7HxGcDbUaayOzqR6+3dalGAJ@vger.kernel.org, AJvYcCXZCIMJTg8mcvmQn7Tv96qCXrUgGpHbeq57g+msAqSJ2Sexaw+x+RVVq9Fy/lWdgsUlufAa7NqnmPrUm/KU@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+r+YVDZ9KQaGTR4jDb3RY5K3fayJffl3QUwA4OW+FOxJ7Bgo9
	cCn9Y6GTNN2HNiSdenLlIo+ZIPWUkJITaVMpeyaFF3i+qkhhxBCaCLZFpgNyNGcLoYg0ZVJB5sU
	W7WEq7ZZlpO8H6df3k4tp44WijfM=
X-Gm-Gg: ASbGnctttodEz/DN4ZLTt80u61bFYCVo+QaJ/Vx5DjZML/A5GAjlXphkejf7QNZth6h
	8gSEznWqU1XdamPqLG7rc7QJ5puEN1pcZWfouYVST8cOJHHtuzu22S3drF4iAJmgeyEFwqfdfpf
	ECAhxZWxJOq0rEqu3HRGdLxj3q
X-Google-Smtp-Source: AGHT+IGjklB7zttrEykPwzu/uhqSetSxLjCa0c9CmOp+KGR0ls7clhJCH6ITB6pCWyc2LLSi+8nRzPfxfQ0+ULkUuPk=
X-Received: by 2002:a05:6214:19eb:b0:6e6:5f08:e77d with SMTP id
 6a1803df08f44-6eed603410cmr160553986d6.19.1743504856865; Tue, 01 Apr 2025
 03:54:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250114123935.18346-1-ansuelsmth@gmail.com> <20250114123935.18346-4-ansuelsmth@gmail.com>
 <Z-u67D7xl2_SR-hg@gondor.apana.org.au>
In-Reply-To: <Z-u67D7xl2_SR-hg@gondor.apana.org.au>
From: "Christian Marangi (Ansuel)" <ansuelsmth@gmail.com>
Date: Tue, 1 Apr 2025 12:54:05 +0200
X-Gm-Features: AQ5f1JqAHbUgXCPSpYMsP6fOYVU3DU1D6Rjb-5J2YSPy0QuYLzvnvkFIIg1s8kY
Message-ID: <CA+_ehUzZruhT7Bko2Xm2kyOaZxUPA4vNLQhq_5V30gfjgmfcng@mail.gmail.com>
Subject: Re: [PATCH v11 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Antoine Tenart <atenart@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, upstream@airoha.com, 
	Richard van Schagen <vschagen@icloud.com>
Content-Type: text/plain; charset="UTF-8"

Il giorno mar 1 apr 2025 alle ore 12:08 Herbert Xu
<herbert@gondor.apana.org.au> ha scritto:
>
> On Tue, Jan 14, 2025 at 01:36:36PM +0100, Christian Marangi wrote:
> >
> > +static int eip93_send_hash_req(struct crypto_async_request *async, u8 *data,
> > +                            dma_addr_t *data_dma, u32 len, bool last)
> > +{
>
> ...
>
> > +again:
> > +     ret = eip93_put_descriptor(eip93, &cdesc);
> > +     if (ret) {
> > +             usleep_range(EIP93_RING_BUSY_DELAY,
> > +                          EIP93_RING_BUSY_DELAY * 2);
> > +             goto again;
> > +     }
> > +
> > +     /* Writing new descriptor count starts DMA action */
> > +     writel(1, eip93->base + EIP93_REG_PE_CD_COUNT);
>
> Why is there no locking here? Shouldn't this be under ring->write_lock?
>

Hi Herbert,
this is really to tell DMA that there is new packet to process and
gets decreased instantly.
The lock is used to track what descriptor index should be used in the
ring in the put and get
functions.
