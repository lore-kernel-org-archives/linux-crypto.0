Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5E11A8F83;
	Mon, 23 Dec 2024 15:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734968907; cv=none; b=Icez0aJ+uR5AxF2LlRcXb5DkaTebrHTSOjHyIENMxSDNzz4Nf9bQhVQIeMEn1i3bySp3qIbvUzM1udarc3nS3fLEQXkiyTCLWH9+kkzzD2CGMwsqtFiVrS/IYzg738bxDtL8WJ2qwyrpXAXLX1i/BT0037rVu0hpQ0OA3CzNtnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734968907; c=relaxed/simple;
	bh=+gu1/Uc8QFbbs1vXSvNJ5LUPzDupCpYIpnKJaFH+BKM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rsnDDQ805QjCQrFNee+uLgUwW/tI3HaKAUimtMEKlgKYgLiSve7pd5mbX024G2/K/IHi6HlCpk7Axkp+J5E+AwAl2RA4Ffk6gfVZgRnF1Ar38OvlBtEfPO7fWtnBE7coIQNKsEyRFhuMDAdid52EBiXe3Tf8Fo4G1JFW6EF/+y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lypIpu7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lypIpu7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CE0C4CED3;
	Mon, 23 Dec 2024 15:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734968907;
	bh=+gu1/Uc8QFbbs1vXSvNJ5LUPzDupCpYIpnKJaFH+BKM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lypIpu7pFnE5L/N3dTsfgFIWAY8WV5lV/jL7k9KSQpF/C56rDc43PVCM99yq1H8KY
	 6iV8V7Ij/YTs+6HpgUJ9M6jcE6TifogQjZl6KfAeUTZek2fEdq5cBQ08vvGC7U/6xh
	 x0mKpDiA3POgizQqtygJT9ff65DelGfeWiYJH9vdTVHPRtZkQ0WYuT2wHo29k6lU2g
	 TDS3hnwu1QlyfcmUuOuTmrhSYlS+Zagj4eEv0xwNoW8kWWgNh1RCo438+SFCS50ZbF
	 cj7kpwVW3gLXw9Ect2MRl6FvggAu/yfvw0awJClxLEamUAk7Jp71h6jtPnwrw7DpsF
	 7g/BaPIt8aTOw==
Date: Mon, 23 Dec 2024 07:48:25 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Boris Pismenny <borisp@nvidia.com>, John
 Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 26/29] net/tls: use the new scatterwalk functions
Message-ID: <20241223074825.7c4c74a0@kernel.org>
In-Reply-To: <20241221091056.282098-27-ebiggers@kernel.org>
References: <20241221091056.282098-1-ebiggers@kernel.org>
	<20241221091056.282098-27-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 21 Dec 2024 01:10:53 -0800 Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Replace calls to the deprecated function scatterwalk_copychunks() with
> memcpy_from_scatterwalk(), memcpy_to_scatterwalk(), or
> scatterwalk_skip() as appropriate.
> 
> The new functions behave more as expected and eliminate the need to call
> scatterwalk_done() or scatterwalk_pagedone().  This was not always being
> done when needed, and therefore the old code appears to have also had a
> bug where the dcache of the destination page(s) was not always being
> flushed on architectures that need that.
> 
> Cc: Boris Pismenny <borisp@nvidia.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
