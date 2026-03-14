Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46C428E0;
	Sat, 14 Mar 2026 18:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773514213; cv=none; b=NV0rVO8CTjJmCA4b27twZTr2Hc8KcGEUSJXK5Cg+erEI2PlwQckyIir8Belm9dE9ngNAOfjTNGkgCWd/AM+ZIqUujH2dM1obdgt6EY8zkuj12/QvHjgnQ7fe7hmHZbCqNyehSZ6qGv/6Gh+L60kz5cJIGpP9uOb8cMyihdvbj7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773514213; c=relaxed/simple;
	bh=xTVXt6oGEhlw1Rqku1t1Ij4Ip/QpSv9B/I4uRWRlnts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WLNCKxYJZw99rZ7ItZGzt7RriCwNqPzhvfxst3TAadx9dBdI7w/qTzKX5wVYqkK1YfdMhCHSajYGVy7WF4YAokzID2w+IoHGNXXobt/CBHbN/XOprBAO8FIgYGc+VUueWHmy4VcOTwUE3rIch9S8XswxrDutVYcg6uMT4g0gASs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xk6RGXVO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xk6RGXVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B68FC116C6;
	Sat, 14 Mar 2026 18:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773514213;
	bh=xTVXt6oGEhlw1Rqku1t1Ij4Ip/QpSv9B/I4uRWRlnts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xk6RGXVOVVr6S8Iclvmuz1iqASb3mjsrKThXhliRiS3eZnUNdgLeeTKAq/2xJHrd/
	 co975U17qAY5l7BqabWg/AX/7zLmnCPMjA+BEiFSCmQCKGjd51el20exfEZfKQ32Jr
	 14yljs7umIjh13c2Gz37MSd8EGkrIjA+Mq+A8IXBEV+Zr6b4u1M8t+QkEXm4uK0vlI
	 gO8fQD+RGx0gKe65mvm88QrWMgtawUoio65BooPOlaEhRf8VepuHRecYbcHzplJeUg
	 eqf2cQqf0Tw9H24PqjgVHGFM0gSuKlbgi+NqOWoMqVuwPrEqUvqrt6mqEEMa06dgOO
	 7MEXhxQBk/qgA==
Date: Sat, 14 Mar 2026 11:50:10 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: AlanSong-oc <AlanSong-oc@zhaoxin.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, Jason@zx2c4.com,
	ardb@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org, CobeChen@zhaoxin.com,
	TonyWWang-oc@zhaoxin.com, YunShen@zhaoxin.com,
	GeorgeXue@zhaoxin.com, LeoLiu@zhaoxin.com, HansHu@zhaoxin.com
Subject: Re: [PATCH v4 2/2] lib/crypto: x86/sha256: PHE Extensions optimized
 SHA256 transform function
Message-ID: <20260314185010.GC40504@quark>
References: <20260313080150.9393-1-AlanSong-oc@zhaoxin.com>
 <20260313080150.9393-3-AlanSong-oc@zhaoxin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313080150.9393-3-AlanSong-oc@zhaoxin.com>

On Fri, Mar 13, 2026 at 04:01:50PM +0800, AlanSong-oc wrote:
> Zhaoxin CPUs have implemented the SHA(Secure Hash Algorithm) as its CPU
> instructions by PHE(Padlock Hash Engine) Extensions, including XSHA1,
> XSHA256, XSHA384 and XSHA512 instructions. The instruction specification
> is available at the following link.
> (https://gitee.com/openzhaoxin/zhaoxin_specifications/blob/20260227/ZX_Padlock_Reference.pdf)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
