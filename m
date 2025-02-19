Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8AC1F4623
	for <linux-crypto@vger.kernel.org>; Wed, 19 Feb 2025 15:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739980367; cv=none; b=GuH+306g1QtHYPRTrz0zxCBQtOnQdDXVmySXlScC8hJt/KgKQc7iheY8sUYTF1IXB6PA8jHhb4Wl0QdT6GqRDKxtmNnGZVnJJ6DnDcdA1zGpK//KQnemEA4zEmggzIFPG/6ziRebZWZBQxLmKXiH4szuM1KFO8xkTePlVhNwSzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739980367; c=relaxed/simple;
	bh=pEcxwQpBp3v3mtfwUr9cTBv0rgYK4fF8S41XDym7D9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eflx0ARaaR395+nFpbTAriaPqXmLNvqX2DbmlQrguE5ANwPD8QrYQ/nmNsm3UI/lJ3Dp4iwwaGWO9tgNVfiftoWMQI46tS9tsIp7tt90MmavD7rW4n7OpQzFbv2Zk4dXQDN7IFbNBM+7ogE/UFmBiTem2we5jS6akqpKRuSKUl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=D+1UDFHo; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="D+1UDFHo"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-abbb12bea54so482693666b.0
        for <linux-crypto@vger.kernel.org>; Wed, 19 Feb 2025 07:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739980364; x=1740585164; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y2qnzAL28gEBKt2chLF3/kynXlu482Vkn7hB2mE3QcM=;
        b=D+1UDFHow8aon359qGnaIXvMn1sxm1Ci2ytor9zB3cve60BlwDB1aGRg0X/GLnOSQ/
         GHGpEBXyt2rxONfTVbxLb3dbpB9pnMBbPbvFVmi+cMzWNCQr/7FeV4Wi6YBtD3FYmsKe
         WQg80hWcwpm+PE/JSCP0axXIBMJEDgLH9rDH1cMUeTYV4M9pk/889PFrDy2qwd2dNooB
         rWmvzszMeVeYSQfC6GrrIUEkIeRdovXgNHE8ye9xPCOr2k1LB8OU2EZTHxmYxnIVbxL0
         KZf+SNddcSh9HA2pBkCQoTXT7t94ZxGZ40xrPOgcJeCWzMhA9jox8KRNlOojm69i8r34
         xYJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739980364; x=1740585164;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y2qnzAL28gEBKt2chLF3/kynXlu482Vkn7hB2mE3QcM=;
        b=pME01dpJou3OGjyzaPkpj8Dk+Mn3bUkileZ3xQqEPtSf1FBXI3QDs85rxzL1QbsIm2
         Wezv03qKnraoIyhnELZB72MTycuhnCKQf1Rx7ZvxEFC3VD4g/BXQ/BScTCDj/Rxu35oC
         zQdme16iphDdZImKamJ87q0fy4pwOC4KqD0bhrK6G7YdgGBeNGwQ1P4lBSddRpiLMCYI
         LkrdFNZRTiRYxo5xHp5hyEe3DGgiUPPfUVBFoTRxolOjR+oi0iEoPR67dNc2SzvNzTvs
         0YBaoHoRY883F/pu8unCA7gACsovuGjPxi/FRYtXPzuUkleABxnA41uRlKUKFWj9h/kn
         Hb0g==
X-Forwarded-Encrypted: i=1; AJvYcCWCqfyJH+RUEieqOFBBQIIfGChkCcrmx+0K8VXRhdvaYbGqxw/0l+2oQNfigDEDD3msusLl484mKYc/uko=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0y60CfPKRJHsZDmaZ8GeF1ctBrLnps1nC5aJ5OACxa9WT8BRW
	WJbiNflOU+sAVvNAbNskqUMtXnPdNFnpQfv75g7YDUUVHGSuHj/yajMtoeZlvPU=
X-Gm-Gg: ASbGncu3N2SujUnhJjC4er4LYdtICXFYll9KLrMH01kUbKtUZYuuVHxnspz4q1jduRf
	XxQeiV9WkEEeRkzFDiW5UvHE9Tv4gRuKqp+KDDRCXhEaZ9NuBcuywEPjgBIWcEh2g2PiQUJdxj9
	H3qfW8CbJ9/rlH71Zk9OLd+22RVVRK28ali88RHoovTfIhw3+IPeIfInWyFPZGyYzdWPc+KARtt
	o5sITRW5gc125QN6EOMYb9kk4ZiKdWodcbxaOFtDNoKoPS+yCO9HhxkuulnVMlrZdrXP+8cUs8H
	6TpqtnZ7ZnL55Uc62BQo
X-Google-Smtp-Source: AGHT+IHLP8OH1Z1QeNaiSlUTemN7jGIJS2Nar9mOVEeblc7NbIn6Q7XAtdRIn85h57qME8hSGTvqHQ==
X-Received: by 2002:a17:907:72d2:b0:ab7:e811:de83 with SMTP id a640c23a62f3a-abb70d9f420mr1759858866b.40.1739980364209;
        Wed, 19 Feb 2025 07:52:44 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-abbdd78ab59sm122018766b.74.2025.02.19.07.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 07:52:43 -0800 (PST)
Date: Wed, 19 Feb 2025 18:52:39 +0300
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
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH 6.6 000/389] 6.6.76-rc2 review
Message-ID: <381bcb3a-9453-4d19-93ea-3608d3dc5ac9@stanley.mountain>
References: <20250206155234.095034647@linuxfoundation.org>
 <CA+G9fYvKzV=jo9AmKH2tJeLr0W8xyjxuVO-P+ZEBdou6C=mKUw@mail.gmail.com>
 <CA+G9fYtqBxt+JwSLCcVBchh94GVRhbo9rTP26ceJ=sf4MDo61Q@mail.gmail.com>
 <Z7Xj-zIe-Sa1syG7@arm.com>
 <b44dc8f6-7abf-4168-b96d-54f1562008e6@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b44dc8f6-7abf-4168-b96d-54f1562008e6@stanley.mountain>

On Wed, Feb 19, 2025 at 06:43:52PM +0300, Dan Carpenter wrote:
> Hi Catalin and Yang Shi,
> 
> What's happening is that we backport the latest kselftests and run
> them on the old kernels.  This is a supported thing so kselftests
> are supposed to be able to handle that.
> 
> So we need to modify the testing/selftests/arm64/mte/check_hugetlb_options.c
> to check if the feature is present and disable the test for older
> kernels.
> 
> This is not an issue with the stable kernel it's an issue with the
> new selftest.

Gar, nope.  It's me who is wrong.  Greg is right.  Why is usespace
triggering a WARN_ON_ONCE()?

regards,
dan carpenter

