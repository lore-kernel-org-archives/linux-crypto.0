Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08AB30C168;
	Tue, 28 Jul 2026 15:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785252648; cv=none; b=iDBHJRkZrkGz99/kdd/hpJMKmo33t+Gr09KrngE2x4b3clHXEfg7HRQJv2x38Qcv6XTF5jAgmxjfCLbfFvk5+0UI7PnyUprD8vRTZ1PGgx2SXep+MhI0Mpw3AyMXTTHZB/oTkUinS743b1IivAe5Sow2+YdXMB+mvzIQEuWv9FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785252648; c=relaxed/simple;
	bh=MYbNmLe6tGbD++gPa/vzN6VGuD1uhIfoQMBv3TyhoDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CLxKKMStVqeL0MV73MQF3+Gorf1heAcKQ5+djOoYGHwjRAS31HycjKayYldR/Xksc/ySwRMPKWcXvJDemG5pNRDcGPI7qvoZjQKhIc85tdDDRkBOh1w+N3pVYq5dch2XNhho+mLcEwC6iAaxr1sqjWiauNtoXL7O+qCKV4JmemE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RNWL2ctA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RNWL2ctA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1AC1F000E9;
	Tue, 28 Jul 2026 15:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785252647;
	bh=mrOxIAfNdwTWJDcLnpqXv5maxVUX/AcXpAUf66B2atY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RNWL2ctAHAFUtAXYu+10aBsk6Vc6+1R43xl5g5WKB220lX61TfgwKc9GGgdcTDYyv
	 SWB9v7iz6iJ3/Zilh5KxYPJrzrO7bY+3bDGRcQIYOZnFvMPa3HdGq3PtbdDiMrGVr1
	 ESJBRzYHuEAydCwrsc/2OZlu6RMfQyXyAu6xroZau9JJpZ4t2jYZCwrlsUPCQNbwvz
	 OA+6pA+TdhEN8hhQGkokvjaQvQTVp/wYoyF58zhnLKyeptLeg+buXRxvOcX/Q4PwiW
	 2swS+Oydt4jFiVNDEhdsQq0jHynT6V+QHgghhUJGXY7q7UHc3qPKIAq6ELWtwxTBjT
	 ILdDycqcRswFA==
Date: Tue, 28 Jul 2026 08:30:45 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] crypto: qce - Remove driver
Message-ID: <20260728153045.GB4281@quark>
References: <CAMRc=MdJTFokXLEbJMQW3V4FAMQid50Vx3fDB+CaNGUrzX-Pwg@mail.gmail.com>
 <2026072412-decrease-sandbag-70a1@gregkh>
 <CAMRc=MeFoG0UXYOAqYhCiKBTs12EjX2-Bz4wDnbeYXmQA3-OaQ@mail.gmail.com>
 <20260724141414.GB1876@sol>
 <CAMRc=MfU1egvJwmgPEN-GXPbz8_JL2XnP-LV0T2+jG-drfXYwg@mail.gmail.com>
 <2026072455-subtly-prayer-0a8a@gregkh>
 <20260724150932.GA6763@sol>
 <2026072428-ungodly-outsource-b20c@gregkh>
 <20260724155144.GA2032@sol>
 <CAMRc=Me_uO0oMqjyuZzs7AxjWoSyy-=rT1eshmFQcNH_3H2ygw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMRc=Me_uO0oMqjyuZzs7AxjWoSyy-=rT1eshmFQcNH_3H2ygw@mail.gmail.com>

On Mon, Jul 27, 2026 at 06:26:56AM -0700, Bartosz Golaszewski wrote:
> Is disabling it in defconfig an acceptable compromise?

No, that completely misses the point.  The defconfig doesn't matter all
that much.

- Eric
