Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B878C2594BE;
	Sun, 29 Dec 2024 23:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735516731; cv=none; b=SOc1HfwkvvjVznXtc5N1EZQN5XcPz9Ib1mKUrNAeQE/FBhOHdNlOBlQuZoXT+gnh6xUKiOBQCi68JdnEK9orDniJlPWYJ3yOh3eZOeIZx9kb6JNWE0QNAg9btaLUdTN9r6xGr5t65WxtCtsJLhDo8X0eXR3ZWzbDwG0zsYWwYxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735516731; c=relaxed/simple;
	bh=Pjryt1slVNrMPGYKYdSXHUd7LW0P2kFhlwf/OqOyHCk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gw9lLO1mHdw2/GaoG63UhT5RF/y4uZPeY1pOcZ6tgSxpG2HdLM4d9rad0NuyTU5ClJNsRlNOfOHsO6Qthaq+cRzaFDsL0Kg7/YvGjNnS0UPLZEqgAYyTbW1JEIUCwehYP8FQ6jO9q0z1wtNwaSnt1Bwt3UcWZ6myqC/XsKXlcI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OO5MzpFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OO5MzpFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D87C4CED4;
	Sun, 29 Dec 2024 23:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735516731;
	bh=Pjryt1slVNrMPGYKYdSXHUd7LW0P2kFhlwf/OqOyHCk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OO5MzpFnShUKt6uPgmSzvmeVIAYWdoGp1X/HQJnJ0t+6jtCSD/p0EBQXdEcWOBNaU
	 32TO6qrHO0+fdDmfkooMgSkgFof6725aImP5x1Z9FIw6gDneKAjtoh7pCVG8578gaf
	 DxOCTwMgyRtUiq4tJD9T/r7sVew0M8gsNtFSiW84kiz6Jcc9Ebqe4nflBNs5aXsGaB
	 TrXS0QKSny1JX1sRRnlRk0Jkrm+vNCCAuj8RpfFt+XThA9eDyIYCIqGiC8Gz1EMjPC
	 ztOIsZH3LSDxqL5TGPXsUIKPgu/+x0stkRQwWajHFOUXlwR1vbqR5yhaWfCr5qwfcO
	 +u+sBfscGtBoA==
Date: Sun, 29 Dec 2024 15:58:44 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: linux-crypto@vger.kernel.org, Boris Pismenny <borisp@nvidia.com>,
	John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 26/29] net/tls: use the new scatterwalk functions
Message-ID: <20241229235844.GB1332@quark.localdomain>
References: <20241221091056.282098-1-ebiggers@kernel.org>
 <20241221091056.282098-27-ebiggers@kernel.org>
 <20241223074825.7c4c74a0@kernel.org>
 <20241223194249.GB2032@quark.localdomain>
 <20241223124431.1d34888f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241223124431.1d34888f@kernel.org>

On Mon, Dec 23, 2024 at 12:44:31PM -0800, Jakub Kicinski wrote:
> FWIW tls has a relatively solid selftest:
> tools/testing/selftests/net/tls.c

Apparently not; all the test cases pass without actually executing any of the
code in net/tls/tls_device_fallback.c.

- Eric
