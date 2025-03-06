Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9521825BACB;
	Thu,  6 Mar 2025 17:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741281695; cv=none; b=AuO/qfH6aKsXrCLc41SuujnZYHPRenYTxfxu5A79gO79jIS860X8bVy3iUlhawK45vvo2nQiO5yqodiiyXTfXibvUx/d29fc9gHA7PwjyAoDjWD2Gelm0APFO3y05b3gG2Pirm452BlbajpvBr9Nluk/IoWD4NuQsVAUvjRObuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741281695; c=relaxed/simple;
	bh=oTiEB28Q7lWRTjbcqhvAInLfO+lN6i0uQEtBC1OuqDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a5x7Id+QzUmzCwrGu0j4W/nWbiiHWhGlL5wmZlooRZv6fcwVbtZz+FeVPon9P6901YCGzSofuAXdxgqr0MZu1pQ/T4V3TgOkGbrrqs11d8FijMlDY2UpkJqQ0J1UXoOg6KDatGKEEAQ/wI6FThd4Fln0BVlqnvd7qMQQqWvKD78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J4xDDjHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J4xDDjHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE532C4CEE0;
	Thu,  6 Mar 2025 17:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741281695;
	bh=oTiEB28Q7lWRTjbcqhvAInLfO+lN6i0uQEtBC1OuqDs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J4xDDjHRR408/VPelZj/Wz/CaMj+m/NZm6aoOqN//7yW/f4Xug57ohev/6SGY3DnU
	 fm8ZRBrxCX9jpc4Rt0gtRWdpLu62HJ/ceKq6VWJid3ZPirtLC4UgCU3HJ48SdVMcNB
	 sl8Q0sNuFgpluAl9az1fhnhDpg/9NV27RTK6sfx6Ts7gviWpJT8lAmvx/kwnlZeIkT
	 ig/3gGV1Ieqelv8BrDL9nWQlN6FXEhpmI1v7VVNvsvVMaPuwUzSJUFH5WrZ6ooH2Bv
	 khS9VQPumIWahVFOTjfRYOVvhWiaE9Le7CAq1dPDlO13XlWJtUJofc40HO+GToDdGm
	 /RKR916Vn9aUA==
Date: Thu, 6 Mar 2025 09:21:33 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] lib/crc_kunit.c: add test and benchmark for crc7_be()
Message-ID: <20250306172133.GB1796@sol.localdomain>
References: <20250304223943.157493-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250304223943.157493-1-ebiggers@kernel.org>

On Tue, Mar 04, 2025 at 02:39:43PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Wire up crc7_be() to crc_kunit.  Previously it had no test.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  lib/Kconfig.debug |  1 +
>  lib/crc_kunit.c   | 35 +++++++++++++++++++++++++++++++++--
>  2 files changed, 34 insertions(+), 2 deletions(-)

Applied to
https://web.git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

- Eric
