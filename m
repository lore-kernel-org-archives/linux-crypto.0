Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97226E56F;
	Mon, 17 Mar 2025 13:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742216753; cv=none; b=VZ0ZkZfIxJf0AYkEdyqIpgClIecqsuDOUmJwEma5N3tMZKOfbIRrqypexRv10T6fbFJZj5cQW3/kjEAvRj5i8r6sdowk0jC33tOLnkg71u+qLBYMVVg8m0Q963VvfEOzOZyXb6KDYhTSqWYM3cpdNUbFgBLhq7Dkv9j5bN4COt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742216753; c=relaxed/simple;
	bh=9+BayI/3W2fli9bAbhq9aYLeJiIaK+dexWqAfoA1wkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=azJUt5TnpIkX5YiOyQJhRdH9HLYlB7qBf6UfAKH1t5sDFpuqpXpFGCdrX+0TaUycZxxzJRLqI0/d6Afbmm90TheP+QPSPdOc5v1VDPhANQQCS1IlDk7wvihDA9jJjtZl+3X/reyzyspnt7TWwegfREtYS6EACwi1L4Z1+tSqfb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xu0sbxoU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xu0sbxoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C8AC4CEE3;
	Mon, 17 Mar 2025 13:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742216753;
	bh=9+BayI/3W2fli9bAbhq9aYLeJiIaK+dexWqAfoA1wkc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xu0sbxoU17DvK07bubIAXV45lnRVYQ+ZQS+e0K1RwoyrTzGSVAN4TBBg2lwhvK1d3
	 8ttJYl+KSfSdtRVtSJBELfSVh6DjMlMzVwugRfq3d5DKFLm2ZtswngNaCfoj2X1wa3
	 PBuDu6VGeyULJmaVtOepfnu5yHfJsMNsRGQH+XNk=
Date: Mon, 17 Mar 2025 14:04:27 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-kernel@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/9] hwrng: arm-smccc-trng - transition to the faux
 device interface
Message-ID: <2025031748-deface-wasting-b635@gregkh>
References: <20250317-plat2faux_dev-v1-0-5fe67c085ad5@arm.com>
 <20250317-plat2faux_dev-v1-2-5fe67c085ad5@arm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250317-plat2faux_dev-v1-2-5fe67c085ad5@arm.com>

On Mon, Mar 17, 2025 at 10:13:14AM +0000, Sudeep Holla wrote:
> +MODULE_ALIAS("faux:smccc_trng");

Why do you need a branch new alias you just made up?  Please don't add
that for these types of devices, that's not going to work at all (just
like the platform alias really doesn't work well.

thanks,

greg k-h
