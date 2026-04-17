Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266E13C9437;
	Fri, 17 Apr 2026 15:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776438743; cv=none; b=c3N3xAJ+A0yLQbb8BrKYG5ke7gJ2Os8lcsuS5I0AzIXXH+VuIILHArsrzo5Vm58yxH8B263W9J6KVqwPvMEw9HZCTMuyMMDiJvgp+/6EmD2/PGzn2JnDZvuwrYjWaUiO6n1W9izjSO2K3liFyJpcasFCedowo2jfJUxZqoa+mKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776438743; c=relaxed/simple;
	bh=obIy5ZhPxiRmcQE7pN7sNcQAHQQxN6EtciA2EEWWuVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=McPu52hzWgxvRlYeZWQm3lSmw+3Q2l/GGsVyJiUHoUEvDRPh6f8d1wmWG0WI3W2X1AYxN02XsxyTFMm+5abT7bchchSi1d6XPPGjob5UDkqus3MNIATA/fAXEOm6YPdHLBZNn+0WBlARCy32u6VxKbrfnSANnk7/Q1Xl/8dn3BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ntoYTNpV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ntoYTNpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B48C19425;
	Fri, 17 Apr 2026 15:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776438742;
	bh=obIy5ZhPxiRmcQE7pN7sNcQAHQQxN6EtciA2EEWWuVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ntoYTNpVY+OyDH/tdLforBUZDS6B45c3SHv/9AkL/8r2DSv8nX4eV5CEnsAklDvot
	 h0IxRaa7FQ83xp3pQazLVXdNArGNlwZ8sreQhRzi2Wt3F0HIfZaW7K3ZQo9tUqR5dK
	 /us4DbwY7gS5vYfsOi9BZIK/F5ZJB2K+x6lUz9oKFOteeUuxEpdtE5OM2qpSyuSVYz
	 VG+yEIPnVk+Kd/539BfMWpoYOp5t0XhJqR6N5mbnkFRaVIdmvMJir5F3ReNZBV2hgq
	 fY7IicW3JOy2uOdcAbfluVn7QecT/BixFS/Uo+nz7a7n6JEV2QXUhMiu5mEH/ClaMo
	 RkgAJWnhPP9Fw==
Date: Fri, 17 Apr 2026 09:12:20 -0600
From: Tycho Andersen <tycho@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>, kvm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 0/7] KVM: SEV: Don't advertise unusable VM types
Message-ID: <aeJNdXPDHSJCZM0m@tycho.pizza>
References: <20260416232329.3408497-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416232329.3408497-1-seanjc@google.com>

On Thu, Apr 16, 2026 at 04:23:22PM -0700, Sean Christopherson wrote:
> My preference would be to take this through the KVM tree, with acks on the
> crypto patches.  I'd also be a-ok with a stable branch/tag of the crypto
> changes.
> 
> In the words of Tycho:
> 
> Recent SEV firmware [1] does not support SEV-ES VMs when SNP is enabled.
> Expose this by revoking VM-types that are not supported by the current
> configurations either from firmware restrictions or ASID configuration.
> 
> My previous version of this patch series [2] used SNP_VERIFY_MITIGATION
> to test for a mitigation bit. While AMD-SB-3023 says that there is a
> mitigation bit (3) for CVE-2025-48514, bit 3 corresponds to an unrelated
> issue. The correct way to check for this is to use the SVN/SPL from the
> TCB. We are in the process of updating the SB to reflect this.

I re-ran my matrix of firmware tests:

Tested-by: Tycho Andersen (AMD) <tycho@kernel.org>

Thanks for cleaning this up.

Tycho
