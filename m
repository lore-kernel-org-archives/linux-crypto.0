Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C8B320CCC
	for <linux-crypto@vger.kernel.org>; Thu, 26 Feb 2026 20:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772137944; cv=none; b=W+bM6D+HESnVsZz4AcBv+YMhAiZt8+GqzGhig1kGgm7inc/WjVKk4cbx2Qbvj9X7lMZhCWN16ed2/bZp9xYTtNCZCazx/Dy3ZxOxL3f8Ifsed5muVOa2D4/43yp4V8374vu+Lf6QT/+lQdUrDARR4AYfOpRfk//pa1gBdHqBC74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772137944; c=relaxed/simple;
	bh=C+iTffCLjsqI4qo0b9qTkR5RJDv1+JxWY9RpgdkZiX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZfbcUb7anABOGsBzr+NUA245NuwfdwBvZUVxfIu1fXkn6M0ZG5cKMtc6yNu1MFrtPMIVbf1d2I/lLckeAx2tvaVbctIyBRqnfLIQOEk9h34EapxS4A0I3KxCzAfsI9Q0XFA/8/U2FBbrpOjlMrUR72BP0PBWp2/LNPxqM8LqtbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YXlAip6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YXlAip6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30193C116C6;
	Thu, 26 Feb 2026 20:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772137944;
	bh=C+iTffCLjsqI4qo0b9qTkR5RJDv1+JxWY9RpgdkZiX0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YXlAip6fEExCl1C0fzFtHFOrz+mm7xB/NUz1LDK9qscetMDQ9ds8LtPUb/gAdagWr
	 kPjGhG+6LKh6vIHmkLoNuVf1ZDO00l+09V2uMSAohIzX1MbBkmimZLAmKKEY9UJDPG
	 x3HPiXhyrNnH2eZAqQ7PZTcx+ZvhpuLTsfUV4d9Hd+07U4XSDU6Io11Y4AVh4Ag2jI
	 4qJtWJztMIwDi8ebRnDPGxM96bGa1Btm35VAzE5Ykbuu+Qpa901zxD8fW7llh7BtWr
	 yCSLc0lV/5WZ04zwAFP84AAchAiFfTsTQMQiKH+43xbCUVyHy+DcCPgXXHNSrw7vFb
	 uY2nFvWg8rUIQ==
Date: Thu, 26 Feb 2026 12:31:33 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Blaise Boscaccy <bboscaccy@linux.microsoft.com>
Subject: Re: [PATCH v3 3/5] crypto: pkcs7: allow pkcs7_digest() to be called
 from pkcs7_trust
Message-ID: <20260226203133.GB2273@sol>
References: <20260225211907.7368-1-James.Bottomley@HansenPartnership.com>
 <20260225211907.7368-4-James.Bottomley@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225211907.7368-4-James.Bottomley@HansenPartnership.com>

On Wed, Feb 25, 2026 at 04:19:05PM -0500, James Bottomley wrote:
> +	/*
> +	 * if we're being called immediately after parse, the
> +	 * signature won't have a calculated digest yet, so calculate
> +	 * one.  This function returns immediately if a digest has
> +	 * already been calculated
> +	 */
> +	pkcs7_digest(pkcs7, sinfo);

pkcs7_digest() can fail, returning an error code and leaving sig->m ==
NULL && sig->m_size == 0.  Here, the error is just being ignored.
Doesn't that then cause the signature verification to proceed against an
empty message, rather than anything related to the data provided?

- Eric
