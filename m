Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C991B1FA261
	for <linux-crypto@vger.kernel.org>; Wed, 19 Feb 2025 15:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739979840; cv=none; b=OXBiVWR/CLYcQhUIG5a5DXjXZA2bezFWgrmUSud1dYisQTH4pczIIlboSi9mOzW6IFlR19zW70eNsmCgrKRRlihPQ6ntdF3NsGOyjvWM0puhO0ICCexvpeCbrNCgeV7NGki4dimCbyVSH7Rl0FI6IvnyKxT/w8DO6fbPtRafGzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739979840; c=relaxed/simple;
	bh=YNmYlTClH6f57hMX0irzBAGNNqToOG6S23UwEJ2SIOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fmb/KGyEsxB0TT2a3tDM3cXCyomjCarv4dA9dzl0FuHY1afKCLUJLje6GIMDYlY5kz4YT5W7OwX4Y0bOny9mwLfoXstMVYCTLIB9jwLmXYPyBDgNbHyDRQ4LIcuHU6NA3k6rZB5NpCJ7ugK39y1H+calh9Jrjk4LPjTGUGYfkwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QoSGvJO8; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QoSGvJO8"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5e050b1491eso1861386a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 19 Feb 2025 07:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739979837; x=1740584637; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ztTcSqiM5jchwSh7zNDJUJXvpA9bZcVb5dRh9uYh8nc=;
        b=QoSGvJO83q8cWOJJ8KKjrnClpNxrJ0kdQZzcO3aB88o1NUKX5dQSIXXXqUJfs3YR/5
         6DVZQbJOqSLfag/Gm15Q6deG1TVw2E+Wj//os0FCD8Chr9/v1PH+UuEkEeTxrOutOl+2
         tzcms0G5JyMZ4dtMhx+aY4kO+ZNkMtJYder+9p2yRGK6oY7JuQX7FXEfufSApqVPYqBs
         CWMNn7ytav+OFZJv61mZNB24RzH97CIT6apKcohOToJj1YTkoNVAgGo8GNasIhWKqDbW
         AuYQQsh19to4MC1wDMKWyni3kDwygPJl5adZztkb6KTwBA9tUu7JMJ8JBDuqMgxeu7V/
         s0tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739979837; x=1740584637;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ztTcSqiM5jchwSh7zNDJUJXvpA9bZcVb5dRh9uYh8nc=;
        b=grM7mnwwumnril8KihZoS7vpvfMKGO3ViHAZTXs/NC8cLouqboNmbFeIcC012xpQXL
         lMEYHeHEE/H8/oM0CgktzJLYYLuEvjkIq2s4od2pb0vqEg44t/vl2ulOB3b4mBs9Z6aq
         cvOOfVSC87Hmxe7Gl+cdFul0YGNBfyYPrMgxevHJwYt8BNYjsXiZo5I2QI1DhbNgQfUb
         x/SpGbuFbUVY1Uko/YzW0gAf1bZ/RwS5vVqrH59Ahowg9pvwJZXhMoeCjvx/8Xp8k+B6
         EwXD7KmJ/KptPyZvfnzPdXE9HUK7G5+9iH9Eez70NxBdqjzyNUW0lCcBbZQYgRZc/Zk/
         gDHg==
X-Forwarded-Encrypted: i=1; AJvYcCUe9MS55qYjBxpa122DnTN7yHvsLGeBUGG47RKF8lJ3qDfzb18Zl+oMXFZAqUg8Pedm+cyQQMWXh0bBONc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBySY/y83amhbpvxxpMKWHYteqohjq1Zdhk4LcXrXVLfjhALtS
	JYqpHO0TJjOePj9gWNl7eAY9wsNx6iVKYmmpUeRW6RkaoTH/YNLJFDKsPc45uNs=
X-Gm-Gg: ASbGncsVuIy9CgdRayKu0+wjYdRd1tAKdMv97cJptgX45tbee/NwdH4eLjI2IxaXyiA
	rY1ZbY5pE4EgNvibOxS/GNoL3KiNEXP0DpYZdbI+hCwzbWJAfIF1lmxv9UxQW+xIfwU+1eAqlT6
	imcgbZ7P2UDU9/zJWF9xuRLQks6UMKnkBX2/ZPwUGio8UWMlaZ4UwCXcqpgQs40JBa8D72TPmdy
	qNcbIlUaywKtgpdGJAOiNuN0SYwafTB2gBanxkB93mO89enKGAYydnm2bo+5DOPIwT0soOkSmot
	MFzvB9G8wFVFfzL4y4ve
X-Google-Smtp-Source: AGHT+IEuAZ/31Yw+onuB6dX7P6MBrwUPKEqWPMc6/GLwGLwgBLIZWvMyIkebqkSIVitXPRtyLX0fJg==
X-Received: by 2002:a17:907:d307:b0:abb:aa8f:c9cd with SMTP id a640c23a62f3a-abbcc7f2ab3mr419789166b.28.1739979836924;
        Wed, 19 Feb 2025 07:43:56 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-abbaa56026fsm491684066b.113.2025.02.19.07.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 07:43:56 -0800 (PST)
Date: Wed, 19 Feb 2025 18:43:52 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Herbert Xu <herbert@gondor.apana.org.au>, willy@infradead.org,
	Pankaj Raghav <p.raghav@samsung.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH 6.6 000/389] 6.6.76-rc2 review
Message-ID: <b44dc8f6-7abf-4168-b96d-54f1562008e6@stanley.mountain>
References: <20250206155234.095034647@linuxfoundation.org>
 <CA+G9fYvKzV=jo9AmKH2tJeLr0W8xyjxuVO-P+ZEBdou6C=mKUw@mail.gmail.com>
 <CA+G9fYtqBxt+JwSLCcVBchh94GVRhbo9rTP26ceJ=sf4MDo61Q@mail.gmail.com>
 <Z7Xj-zIe-Sa1syG7@arm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7Xj-zIe-Sa1syG7@arm.com>

Hi Catalin and Yang Shi,

What's happening is that we backport the latest kselftests and run
them on the old kernels.  This is a supported thing so kselftests
are supposed to be able to handle that.

So we need to modify the testing/selftests/arm64/mte/check_hugetlb_options.c
to check if the feature is present and disable the test for older
kernels.

This is not an issue with the stable kernel it's an issue with the
new selftest.

regards,
dan carpenter

