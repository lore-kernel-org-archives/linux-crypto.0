Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F80422CBF9;
	Thu,  8 May 2025 13:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711795; cv=none; b=TIIbvY6A3hESwhrTBfrRP/jahuu04uhf6Z3f2UH3e0Atiy/lhzd4oTmk5Xe+4aFa0f8iuZ/GOk8yZY3fIJsV3qYOnDWZbkIE0erRxCgHtbuseqSVeHS5qzrPSKkx2bRPy3q0SsiVYB3pueUE8rZ+Gl3SW48elbxuEPYi2bHQpi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711795; c=relaxed/simple;
	bh=aCE6iYiciFIdKSqWV0byF7RoB3J0cxLu0LwihXHKXtE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tp2zPkaeoRul5D2xBGdJ6w2tJZSMBpbvJPTyj3qFU8l8icvmqsPffLouKsQPcICFlTX3d5lm06/c073K+1/e8KkPFC7yMXd+uzusiKhIY70TVE24fth1FHLKDNz7r+Lp+qh009Xqhrde9GobMze8Jp7vdDnQsi5C1zmkjEeIlXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nkno3eCI; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nkno3eCI"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43cfe63c592so9669895e9.2;
        Thu, 08 May 2025 06:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746711792; x=1747316592; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=b4tVbEi1qNi8E/gdy3VXy8wc9mnT2zzjATf4UbjgX20=;
        b=Nkno3eCILxmRVDvO5oOCpjK12OI0brqL1xOrmvzb7RswBo04BrOECG/K5+Bn4LXd+D
         /yNXMPptg3wCnENpxOFwjnv7tFutThYtyjAXyeX2fTTnGfFwCl2pkktj+qya2CdPSQK2
         EvmKqHgC/5MJSTyKdj7wu8Ge6qmv6BzRMiln4P7/ucefPPDDw3j7HMosFHeXszBrDafP
         aKB0oXtZFL+u6VWSSWBbVOF963h1l03Z0lBWuVswgHXRqpYfmOhlqpit9tiSk7Ku9Wr7
         6sO9JE7o3B8qE7r1SrBxerFAZA2kfTWnazfoGihnJjlsU6ZIKhEqJIOPbDw6XewWmSJ7
         xsBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711792; x=1747316592;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b4tVbEi1qNi8E/gdy3VXy8wc9mnT2zzjATf4UbjgX20=;
        b=LspWhLnSegwwmTgcS8UstHHfR0OOraJmxUbErj7Lty/ZXaam5jo8tJNIKIIC0IDmtw
         ycA7dg+LIx5SENjKZpD70EaQb+NhbpipgRKQ7TNjz5+o/0zBRDrf3tz9LSpTNUPlzY9t
         sEBSVz/ynzPYJOFpH5ae7UsAw//l/t4qM43C8oWPjTqjmz0/VGdVIpdY9Ytf6VAbfYIa
         ApoxWeZTaN119nncfCVDvWuZZzfJh0CB3lw3pnDvmny0CpcDO/ns5Wt7SDnOptf5kaQ4
         ZaoOX9ALimIc6YNlMY6A6lt51t23CrZ1fYJAY1gIVx2SoxVo9//x8nme2JSxZ5NS0Cxq
         I/WA==
X-Forwarded-Encrypted: i=1; AJvYcCUDgBo1zRypLWVYTkmJMRxFtSI++iz8YMv89Qeqrx1fa3WN7RUzkHt0FAb2KrIz/9el4KkA4Z1vj/rIvQJg@vger.kernel.org, AJvYcCUR0BSU6x5FEdJW1j2FJ/u0uGbFowAXLQjimN9qSvfFvVT6HCbnvdN57Hv+DBgQjcj96BgOPAtjY0ZmziA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyzw4TzzZco1KhEteSo8AuADsHavuxm67ZTLOc9THLkGh59/VPw
	Q1pwOK34ZRTBCxOPokASkhJENRps3HkKVQJW31+YiUNNF47t+1A9
X-Gm-Gg: ASbGncv5CHqVDY/qjBal4EIlagkeBh84eIjOjyNKA42ARz28WuukLdihS4WOXvwwJg6
	CYaHJ/e8LhUkvR+IWKK3J7kvCkPy3CtKlOuHjpkucC7Fklva+qYvFIABGicCA8mkZP/oeEr9Iy7
	DDO4nXKJbQFG603m03Kb0cd73pxqyEfcyQ6Guc69qZLcsn4YWdb8IJprroWZRChuvEsn2OgRPJO
	j42jIGjDt6bzE3+zkcHSFIuy0DBSpi0jFu673NeZ0ZNYZ68VKdYCvK1CW61ryu+gNpRaHxKS3o2
	jYNmwLCIl96igHWeG/jIfRqyWc9l8HOKPIEBVde7PA==
X-Google-Smtp-Source: AGHT+IHFMBcxHiIp52o0F6tt+d3OgA2roN5kK/YH6p9byXgvoy9nOMhe4gnHT98HwmtQZBwp+sWs1g==
X-Received: by 2002:a05:600c:3b29:b0:43d:83a:417d with SMTP id 5b1f17b1804b1-442d02ecb69mr33139155e9.12.1746711790720;
        Thu, 08 May 2025 06:43:10 -0700 (PDT)
Received: from Red ([2a01:cb1d:898:ab00:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-442d14e0437sm29360495e9.36.2025.05.08.06.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 06:43:09 -0700 (PDT)
Date: Thu, 8 May 2025 15:43:07 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [v3 PATCH] crypto: marvell/cesa - Do not chain submitted requests
Message-ID: <aBy06xyzh5kKC48a@Red>
References: <Zw31JIEyh28vK9q7@gondor.apana.org.au>
 <5db212655dc98945fa3f529925821879a03ff554.camel@gmail.com>
 <Zw9AsgqKHJfySScx@gondor.apana.org.au>
 <aBoMSHEMYj6FbH8o@gondor.apana.org.au>
 <aBsdTJUAcQgW4ink@gondor.apana.org.au>
 <aBt5Mxq1MeefwXGJ@Red>
 <aBw-C_krkNsIoPlT@gondor.apana.org.au>
 <aBw_iC_4okpiKglQ@gondor.apana.org.au>
 <aBypVwhHHzmqqN5K@Red>
 <aBytNdRyd5Ywh1Pq@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aBytNdRyd5Ywh1Pq@gondor.apana.org.au>

Le Thu, May 08, 2025 at 09:10:13PM +0800, Herbert Xu a écrit :
> On Thu, May 08, 2025 at 02:53:43PM +0200, Corentin Labbe wrote:
> >
> > The board do not panic anymore, but have still selftest errors:
> > See the full boot log at kernel.montjoie.ovh/477935.log
> 
> Do you have a boot log without this patch to compare? You seem
> to be getting skcipher failures as well as hash failures while
> the original report only had hash failures.
> 

6.14.4 boot log at http://kernel.montjoie.ovh/477911.log
