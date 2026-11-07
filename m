Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794089178;
	b=jboIgK2C9dW7ErtSbXRlgakvGlbLY509rq5t7p7PRnDcg7m63GMgv0sKLzdUvNpwAoyO
	 N0oLE5uSi0J/5u0rTpjQRBR5cxDhSNsTGzvZKWMHKJoeZYKbRL8YzZzdC8QnhjkoLnyTO
	 JsFqbRv68dfCmXhbRy629J3TIU/cEJltp8D6aikhIIA9u1RMxNae2ylLehiW5elr5HHX9
	 CwwXjHs1WPYR/U6oaBAzNEh7EKU2lBo9vcAvh5mIsjJQlSR9ivE2H31BGuwiKxz0NnU+t
	 EbDaz5tMJyY/oP7v8oA/7AH/tZkxnQytReuesrigJZtaIbhO41ZDQ42qwPM5P5qSGvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794089178;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=a+bvPbmAwlqgKMVT1z2mqNwhwfH06O22frw48LwOLnc=;
	b=vfHdOh31KSrkRDCJpmtYr3Klq3m97U+Lt9qjLJ/+C3LRYEwEsTo//vckKnOHoXAT7R29
	 8H+1qQ6imeT4VpxU/H5ePJ1IGHQcOheKNSUI/MoMMmyzHxrjN4VrnoETO2dhcx/bboHqA
	 WeikgPbDE5vLQRDvWFcd9REOuj+LtJpimGrGpviZGFkggS0lY9rxSG2FRx2Bnc6tyflYV
	 vKJrzggKv2ngNyQTvdq5txeaAhpe5kfZrHyA7YHqgBmQ+BKT4P459zH4YWakyyS3W7KLw
	 BGmInwT7VhMUECP0IUOAKVHRaLCEAmuXeqKvn1SVu7xJ82gQliRocnHK+7EcIEZo4Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=juDe2x0U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C803F606A32F;
	Sat,  7 Nov 2026 22:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=juDe2x0U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C86A1F0089F;
	Sat,  7 Nov 2026 22:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794089177;
	bh=a+bvPbmAwlqgKMVT1z2mqNwhwfH06O22frw48LwOLnc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=juDe2x0UBC3WoeiKsIqfx/se4WPkOG8NcVtkvtj4GjRRJZybNbkg2FwBU6owGCdxt
	 5LrHvrUnDu/+sHrldyrJGeGUUCNumgY6Te6owpIcsbep5egr9RTjuR0U9ffJQs9Trl
	 FQRdQxZctG+FbAd/IWVmMN8geWqRccc/A6iE2o5pon9yMe/g1iGnoNEBBpSypEmYR9
	 Pk72bDsXgPYRQAmNoiO59DyZ8FKcrcMtGpauGMGEsNWtD7HhAsaw0Uhdjt5OPt+zmd
	 Uq21DzEKFVbNVcYptnvLWLnTb1tSOPRG+v4rvaDBOkDOP5T/u5HF1eXYwc4+Sf4g4R
	 TVNUzO25wRWTg==
Date: Sat, 7 Nov 2026 14:06:15 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v2] lib/crypto: Add a sentence about zeroizing raw key
 structures
Message-ID: <20261107220615.GO137269@quark>
References: <20261105082902.327526-1-thuth@redhat.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105082902.327526-1-thuth@redhat.com>

On Thu, Nov 05, 2026 at 09:29:02AM +0100, Thomas Huth wrote:
> Let's make it clear that raw key material has to be zeroized, too.
> 
> Suggested-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  v2: Move the information into a separate paragraph
> 
>  Documentation/crypto/libcrypto-zeroization.rst | 5 +++++
>  1 file changed, 5 insertions(+)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
